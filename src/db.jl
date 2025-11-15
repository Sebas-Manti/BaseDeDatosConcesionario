module DB
using MySQL

const DB_CONFIG = Dict(
  :host => "127.0.0.1",
  :user => "root",
  :password => "ProyectoBD1Final",
  :db => "concesionarioKONRUEDAS"
)

function get_conn()
  return MySQL.connect(
    host = DB_CONFIG[:host],
    user = DB_CONFIG[:user],
    password = DB_CONFIG[:password],
    db = DB_CONFIG[:db]
  )
end

end