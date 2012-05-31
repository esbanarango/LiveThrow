Con = require '../../models/connection'

routes = (app) ->
  app.get '/', (req, res) ->
    client = Con()
    results = null
    client.query "SELECT * FROM USER", (err, _results, fields) =>
      throw err if err
      results = _results
      client.end()
  	  res.render "#{__dirname}/views/index",
  		  title: "Live Throw"
  		  results: results

module.exports = routes
