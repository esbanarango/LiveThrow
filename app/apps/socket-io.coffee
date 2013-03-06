
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
    # Expose its socket id
    socket.emit 'id', socket.id
    socket.on 'disconnect', ->      
      console.log "DISCONNECTED"
      console.log "User: #{socket.currentUser}"
      console.log "Match: #{socket.match}"

