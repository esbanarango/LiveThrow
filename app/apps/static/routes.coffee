routes = (app) ->
  app.get '/', (req, res) ->
	  res.render "#{__dirname}/views/index",
		  title: "Live Throw"
		  results: results

module.exports = routes
