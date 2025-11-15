module DB
using MySQL
using TOML

CONF = TOML.parsefile("config.toml")["database"]

function get_conn()
  return MySQL.connect(
    host = DB_CONFIG[:host],
    user = DB_CONFIG[:user],
    password = DB_CONFIG[:password],
    db = DB_CONFIG[:db]
  )
end

end