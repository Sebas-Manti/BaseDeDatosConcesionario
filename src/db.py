import os
import mysql.connector
import yaml

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def load_config():
    with open("config/config.yaml", "r") as f:
        return yaml.safe_load(f)


CONFIG = load_config()["database"]


def get_conn():
    return mysql.connector.connect(
        host=CONFIG["host"],
        user=CONFIG["user"],
        password=CONFIG["password"],
        database=CONFIG["db"],
        autocommit=True
    )


def get_schema():
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE 
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = DATABASE()
    """)
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return rows