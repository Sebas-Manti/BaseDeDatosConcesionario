import time
import threading
from queue import Queue
from src.db import get_conn

QUEUE = Queue()
HISTORY = []


def worker_loop():
    while True:
        item = QUEUE.get()
        item["status"] = "running"

        try:
            conn = get_conn()
            cursor = conn.cursor()
            cursor.execute(item["sql"])
            conn.commit()
            cursor.close()
            conn.close()

            item["status"] = "done"
            item["result"] = "OK"

        except Exception as e:
            item["status"] = "error"
            item["result"] = str(e)

        HISTORY.append(item)


# lanzar worker
threading.Thread(target=worker_loop, daemon=True).start()