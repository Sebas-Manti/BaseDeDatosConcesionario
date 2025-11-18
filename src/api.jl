using HTTP
using JSON3
using Dates
using MySQL
using UUIDs


const SRC_DIR = @__DIR__

include(joinpath(SRC_DIR, "db.jl"))   
include(joinpath(SRC_DIR, "queue.jl"))

nl_path = joinpath(SRC_DIR, "nl.jl")
if isfile(nl_path)
    include(nl_path)
    @eval using .NL
else
   
    module NL
        export nl_to_sql
        nl_to_sql(prompt::String) = ""   
    end
    @eval using .NL
end


using .DB
using .QueueManager


const WS_CLIENTS = Set{HTTP.WebSockets.WebSocket}()

function broadcast_queue_update(msg)
    data = JSON3.write(msg)
    for ws in collect(WS_CLIENTS)
        try
            HTTP.WebSockets.send(ws, data)
        catch err
            delete!(WS_CLIENTS, ws)
        end
    end
end


Main.broadcast_queue_state = broadcast_queue_update

function safe_json_read(body::AbstractString)
    try
        return JSON3.read(body)
    catch
        return nothing
    end
end

function handler(req::HTTP.Request)
    method = String(req.method)
    target = String(req.target)

    if HTTP.WebSockets.isupgrade(req) && startswith(target, "/ws/queue")
        return HTTP.WebSockets.upgrade(req) do ws
            push!(WS_CLIENTS, ws)
            try
                HTTP.WebSockets.send(ws, JSON3.write(Dict("type"=>"connected","time"=>string(now()))))
                while true
                    _msg = try
                        HTTP.WebSockets.readavailable(ws)
                    catch
                        break
                    end
                end
            finally
                delete!(WS_CLIENTS, ws)
            end
        end
    end

    if method == "GET" && target == "/api/schema"
        try
            conn = DB.get_conn()
            res = MySQL.query(conn, "SELECT TABLE_NAME,COLUMN_NAME,COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=DATABASE()")
            meta = MySQL.fetchall(res)
            MySQL.close(conn)
            return HTTP.Response(200, JSON3.write(meta), ["Content-Type" => "application/json"])
        catch e
            return HTTP.Response(500, "DB error: $(e)")
        end
    end

    if method == "POST" && target == "/api/exec"
        body = String(req.body)
        payload = safe_json_read(body)
        if payload === nothing || !haskey(payload, "sql")
            return HTTP.Response(400, "Bad payload")
        end
        sql = payload["sql"]
        if !ismatch(r"^\s*SELECT\s+"i, sql)
            return HTTP.Response(400, "Only SELECT allowed on /api/exec")
        end
        try
            conn = DB.get_conn()
            res = MySQL.query(conn, sql)
            rows = MySQL.fetchall(res)
            MySQL.close(conn)
            return HTTP.Response(200, JSON3.write(rows), ["Content-Type" => "application/json"])
        catch e
            return HTTP.Response(500, "DB query error: $(e)")
        end
    end

    if method == "POST" && target == "/api/enqueue"
        payload = safe_json_read(String(req.body))
        if payload === nothing || !haskey(payload, "sql")
            return HTTP.Response(400, "Bad payload")
        end
        sql = payload["sql"]
        user = get(payload, "user", "anonymous")
        if isempty(strip(sql))
            return HTTP.Response(400, "Empty SQL")
        end
        item = Dict(
            "id" => string(UUIDs.uuid4()),
            "user" => user,
            "sql" => sql,
            "type" => get(payload, "type", "DML"),
            "timestamp_enqueued" => string(Dates.now()),
            "status" => "queued"
        )
        try
            QueueManager.enqueue!(item)
            return HTTP.Response(200, JSON3.write(Dict("id" => item["id"])), ["Content-Type" => "application/json"])
        catch e
            return HTTP.Response(500, "Queue enqueue error: $(e)")
        end
    end

    if method == "POST" && target == "/api/nl2sql"
        payload = safe_json_read(String(req.body))
        if payload === nothing || !haskey(payload, "prompt")
            return HTTP.Response(400, "Bad payload")
        end
        prompt = payload["prompt"]
        sql = try
            NL.nl_to_sql(prompt)
        catch e
            ""
        end
        return HTTP.Response(200, JSON3.write(Dict("sql" => sql)), ["Content-Type" => "application/json"])
    end

    return HTTP.Response(404, "Not found")
end

println("API listening on 0.0.0.0:8000")
HTTP.serve!(handler, "0.0.0.0", 8000)
