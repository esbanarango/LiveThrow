exec = require("child_process").exec;

routes = (app) ->
  app.get '/', (req, res) ->
    res.render "#{__dirname}/views/index",
      title: "Live Throw"

  app.get '/about', (req, res) ->
    res.render "#{__dirname}/views/about",
      title: "About"

  # Prueba de No-blocking
  app.get '/prueba', (req, res) ->
    exec "find /",
      timeout: 10000
      maxBuffer: 20000 * 1024
    , (error, stdout, stderr) ->
      res.writeHead 200,
        "Content-Type": "text/plain"
      res.write stdout
      res.end()

module.exports = routes