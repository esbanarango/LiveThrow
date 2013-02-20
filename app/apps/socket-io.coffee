
module.exports = (server, app) ->
  socketIO = require('socket.io').listen(server)

  # Heroku Config 
  # "The WebSockets protocol is not yet supported on the Cedar stack."
  # socketIO.configure ->
  #   socketIO.set "transports", ["xhr-polling"]
  #   socketIO.set "polling duration", 10

  unless app.settings.socketIO
    app.set 'socketIO', socketIO
  socketIO.sockets.on 'connection', (socket) ->
    console.log 'CONNECTED'
    socket.on 'disconnect', ->
      console.log 'DISCONNECTED'
