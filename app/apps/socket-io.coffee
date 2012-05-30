
module.exports = (app) ->
  socketIO = require('socket.io').listen(app)
  unless app.settings.socketIO
    app.set 'socketIO', socketIO
  socketIO.sockets.on 'connection', (socket) ->
    console.log "CONNECTED"
