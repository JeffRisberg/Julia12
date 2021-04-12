module Database

using MySQL
using DBInterface

const HOST = "localhost"
const USER = "developer"
const PASS = "123456"
const DB = "six_degrees"

const CONN = DBInterface.connect(MySQL.Connection, HOST, USER, PASS, db = DB)

export CONN

disconnect() = DBInterface.close!(CONN)

atexit(disconnect)

end
