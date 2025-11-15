using HTTP, JSON3, Dates
include("db.jl")
include("queue.jl")
include("nl.jl")
using .DB, .QueueManager

const WS_CLIENTS = Set{HTTP.WebSockets.WebSocket}()

function broadcast_queue_update(msg)
    data = JSON3.write(msg)
    for ws in collect(WS_CLIENTS)
        try
            HTTP.WebSockets.send(ws, data)
        catch
            delete!(WS_CLIENTS, ws)
        end
    end
end

Main.broadcast_queue_state = broadcast_queue_update

function handler(req::HTTP.Request)
    method = String(req.method)
    target = String(req.target)
    if HTTP.WebSockets.isupgrade(req) && startswith(target, "/ws/queue")
        return HTTP.WebSockets.upgrade(req) do ws
            push!(WS_CLIENTS, ws)
            try
                HTTP.WebSockets.send(ws, JSON3.write(Dict("type"=>"connected","time"=>string(now()))))
                while true
                    msg = HTTP.WebSockets.readavailable(ws) 
                end
            finally
                delete!(WS_CLIENTS, ws)
            end
        end
    end

    if method == "GET" && target == "/api/schema"
        conn = DB.get_conn()
        res = MySQL.query(conn, "SELECT TABLE_NAME,COLUMN_NAME,COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=DATABASE()")
        meta = MySQL.fetchall(res)
        close(conn)
        return HTTP.Response(200, JSON3.write(meta), ["Content-Type"=>"application/json"])
    end

    if method == "POST" && target == "/api/exec"
        body = String(req.body)
        payload = JSON3.read(body)
        sql = payload["sql"]
        if !ismatch(r"^\s*SELECT\s+"i, sql)
            return HTTP.Response(400, "Only SELECT allowed on /api/exec")
        end
        conn = DB.get_conn()
        res = MySQL.query(conn, sql)
        rows = MySQL.fetchall(res)
        close(conn)
        return HTTP.Response(200, JSON3.write(rows), ["Content-Type"=>"application/json"])
    end

    if method == "POST" && target == "/api/enqueue"
        payload = JSON3.read(String(req.body))
        sql = payload["sql"]
        user = get(payload, "user", "anonymous")
        if isempty(strip(sql))
            return HTTP.Response(400, "Empty SQL")
        end
        item = Dict(
            "id" => string(uuid4()),
            "user" => user,
            "sql" => sql,
            "type" => payload["type"],
            "timestamp_enqueued" => string(Dates.now()),
            "status" => "queued"
        )
        QueueManager.enqueue!(item)
        return HTTP.Response(200, JSON3.write(Dict("id"=>item["id"])), ["Content-Type"=>"application/json"])
    end

    if method == "POST" && target == "/api/nl2sql"
        payload = JSON3.read(String(req.body))
        prompt = payload["prompt"]
        sql = nl_to_sql(prompt) 
        return HTTP.Response(200, JSON3.write(Dict("sql"=>sql)), ["Content-Type"=>"application/json"])
    end

    return HTTP.Response(404, "Not found")
end

println("API listening on 0.0.0.0:8000")
HTTP.serve!(handler, "0.0.0.0", 8000)
