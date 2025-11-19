from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from src.db import get_schema, get_conn
from src.queue import QUEUE, HISTORY
from src.nl import nl_to_sql
import uuid


app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"]
)


@app.get("/api/schema")
def schema():
    return get_schema()


@app.post("/api/exec")
def exec_sql(body: dict):
    sql = body["sql"]
    if not sql.strip().lower().startswith("select"):
        return {"error": "Only SELECT allowed"}
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(sql)
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return rows


@app.post("/api/enqueue")
def enqueue(body: dict):
    item = {
        "id": str(uuid.uuid4()),
        "sql": body["sql"],
        "user": body.get("user", "anonymous"),
        "type": body.get("type", "dml"),
        "status": "queued"
    }
    QUEUE.put(item)
    return {"id": item["id"]}


@app.get("/api/queue")
def queue_state():
    return list(QUEUE.queue)


@app.get("/api/history")
def history():
    return HISTORY


@app.post("/api/nl2sql")
def nl2sql(body: dict):
    prompt = body.get("prompt")
    print("Prompt recibido:", prompt)
    sql = nl_to_sql(prompt)
    print("SQL generado:", sql)
    return {"sql": sql}