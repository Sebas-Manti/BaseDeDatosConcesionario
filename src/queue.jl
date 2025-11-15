module QueueManager
using JSON3, Dates, DB

export enqueue!, get_queue_state


const QUEUE = Channel{Dict}(1024)   
const HISTORY = Channel{Dict}(1024) 

# Estructura de item:
# { "id"=>UUID, "user"=>String, "sql"=>String, "type"=>"DML"/"DCL", "timestamp_enqueued"=>..., "status"=> "queued" }

function enqueue!(item::Dict)
    put!(QUEUE, item)
    return item["id"]
end

function get_queue_state()
    q = collect(QUEUE)
    return q
end


function worker_loop()
    while true
        item = take!(QUEUE) 
        item["status"] = "running"
        item["started_at"] = Dates.now()
        try
            conn = DB.get_conn()
            MySQL.query(conn, item["sql"]) 
            DB.close(conn)
            item["status"] = "done"
            item["finished_at"] = Dates.now()
            item["result"] = "OK"
        catch e
            item["status"] = "error"
            item["finished_at"] = Dates.now()
            item["result"] = string(e)
        end
        try
            put!(HISTORY, item)
        catch
        end
        if isdefined(Main, :broadcast_queue_state)
            Main.broadcast_queue_state(item)
        end
    end
end
const WORKER = @async worker_loop()
end
