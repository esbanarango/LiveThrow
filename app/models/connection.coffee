mysql = require('mysql');


connection = ->
  dataBase= 'db_live_throw'
  client = mysql.createClient({user: 'root'})
  client.query("USE #{dataBase}")
  client


module.exports = connection