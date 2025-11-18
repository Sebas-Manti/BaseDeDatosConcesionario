module NL

using OpenAI
using JSON3

export nl_to_sql, load_schema_context

const SCHEMA_CTX = Ref("")

"""
    load_schema_context(schema_dict)

Carga un contexto basado en el esquema real de la base de datos.
schema_dict debe ser un Dict o un array de Dicts tal como devuelve /api/schema.
"""
function load_schema_context(schema_dict)
    ctx = IOBuffer()
    println(ctx, "Database schema description:")

    for col in schema_dict
        println(ctx,
            "- Table: $(col["TABLE_NAME"]), Column: $(col["COLUMN_NAME"]), Type: $(col["COLUMN_TYPE"])"
        )
    end

    SCHEMA_CTX[] = String(take!(ctx))
end


"""
    nl_to_sql(prompt::String) -> SQL String

Envía el prompt a un LLM y devuelve SQL estricto (una sola consulta, sin comentarios ni markdown).
"""
function nl_to_sql(prompt::String)
    if isempty(SCHEMA_CTX[])
        error("Schema context not loaded. Call load_schema_context() first.")
    end

    system_prompt = """
Eres un generador experto en SQL.
Tienes el siguiente esquema de base de datos:

$(SCHEMA_CTX[])

Reglas estrictas:
- Devuelve SOLO SQL puro.
- No uses Markdown.
- No expliques nada.
- NO inventes tablas o columnas.
- Si el usuario pide algo imposible, devuelve: SELECT 'Error: solicitud no válida' AS error;
- Genera una sola consulta SQL válida.
"""

    client = OpenAI.Client(;
        api_key = "not-needed-for-local",
        base_url = "http://127.0.0.1:11434/v1" 
    )

    response = OpenAI.chat(client;
        model = "llama3",
        messages = [
            (role="system", content=system_prompt),
            (role="user", content=prompt)
        ]
    )

    sql = response["choices"][1]["message"]["content"]

    sql = replace(sql, "```sql" => "")
    sql = replace(sql, "```" => "")
    sql = strip(sql)

    return sql
end

end

