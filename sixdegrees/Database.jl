module Database

using MySQL

const HOST = "127.0.0.1"
const USER = "developer"
const PASS = "12345678"
const DB = "six_degrees"
const PORT = 8889

const CONN = MySQL.connect(HOST, USER, PASS, db = DB, port = PORT)

export CONN

disconnect() = MySQL.disconnect(CONN)

atexit(disconnect)

end
