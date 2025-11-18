module QueueManager

using JSON3
using Dates
using MySQL

using ..DB

export enqueue!, get_queue_state, QUEUE, HISTORY

const QUEUE   = Channel{Dict}(1024)
const HISTORY = Channel{Dict}(1024)

"""
enqueue!(item)
   Inserta un item en la cola.
"""
function enqueue!(item::Dict)
    put!(QUEUE, item)
    return item["id"]
end

"""
get_queue_state()
   Devuelve el estado actual de la cola.
"""
function get_queue_state()
    return collect(QUEUE)
end

"""
worker_loop()
   Hilo que procesa items en la cola FIFO.
"""
function worker_loop()
    while true
        item = take!(QUEUE)

        item["status"] = "running"
        item["started_at"] = Dates.now()

        try
            conn = DB.get_conn()
            MySQL.query(conn, item["sql"])
            MySQL.close(conn)

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
            try
                Main.broadcast_queue_state(item)
            catch
            end
        end
    end
end

const WORKER = @async worker_loop()

end
