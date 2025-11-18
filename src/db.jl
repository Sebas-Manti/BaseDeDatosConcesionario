module DB

using MySQL
using TOML

export get_conn, load_config

"""
    load_config()

Carga el archivo config.toml y devuelve el diccionario de configuración.
"""
function load_config()
    config_path = joinpath(@__DIR__, "..", "config.toml")

    if !isfile(config_path)
        error("ERROR: No se encontró config.toml en: $config_path")
    end

    conf = TOML.parsefile(config_path)
    return conf["database"]
end

const DB_CONFIG = load_config()

"""
    get_conn()

Abre una conexión MySQL usando la configuración cargada.
"""
function get_conn()
    return MySQL.connect(
        host     = DB_CONFIG["host"],
        user     = DB_CONFIG["user"],
        password = DB_CONFIG["password"],
        db       = DB_CONFIG["db"]
    )
end

end
