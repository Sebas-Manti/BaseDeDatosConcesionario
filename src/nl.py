import requests
import yaml
from src.db import get_schema

def load_config():
    with open("config/config.yaml", "r") as f:
        return yaml.safe_load(f)

CONFIG = load_config()["llm"]


def nl_to_sql(prompt):
    schema = get_schema()

    system_prompt = f"""
Eres un modelo NL2SQL. Convierte la pregunta del usuario en SQL válido para MariaDB.
NO EXPLIQUEES NADA. SOLO ENTREGA SQL PLANO.
Esquema:
{schema}
    """

    data = {
        "model": CONFIG["model"],
        "prompt": system_prompt + "\nUsuario: " + prompt,
        "stream": False
    }

    r = requests.post("http://localhost:11434/api/generate", json=data)
    out = r.json()["response"]

    # extra: limpiar backticks y explicaciones
    out = out.replace("```sql", "").replace("```", "").strip()
    return out