import requests
from pathlib import Path
import yaml

CONFIG_PATH = Path("config/config.yaml")
CONTEXT_FILE = Path.home() / "BaseDeDatosConcesionario/src/contexto.txt"

def load_config():
    with open(CONFIG_PATH, "r") as f:
        return yaml.safe_load(f)

CONFIG = load_config()["llm"]

def nl_to_sql(prompt: str):
    if not CONTEXT_FILE.exists():
        raise FileNotFoundError(f"No se encontró el archivo de contexto: {CONTEXT_FILE}")

    with open(CONTEXT_FILE, "r") as f:
        context = f.read()

    final_prompt = f"{context}\nUsuario: {prompt}\nSQL:"

    data = {
        "model": CONFIG["model"],
        "prompt": final_prompt,
        "stream": False
    }

    try:
        r = requests.post("http://localhost:11434/api/generate", json=data)
        r.raise_for_status()
        out = r.json()["response"]
        out = out.replace("```sql", "").replace("```", "").strip()
        return out
    except Exception as e:
        print("Error generando SQL:", e)
        return ""

if __name__ == "__main__":
    q = input("Pregunta en NL: ")
    print("SQL generado:", nl_to_sql(q))
