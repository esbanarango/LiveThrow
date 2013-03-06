Match   = require '../models/LiveScore/match'
_       = require 'underscore'
dateFunctions = require '../lib/date_functions'

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
      updateTime(socket) if socket.type is 'monitor' and socket.match? and socket.stopWatch?

    socket.on 'actionStopWatch', (action,time) ->
      socket.stopWatch = 
        action: action
        time: time
        moment: new Date()


  updateTime = (socket)->
    Match.getById socket.match, (err, match) ->
      unless match is undefined

        time = socket.stopWatch.time
        if socket.stopWatch.action is 'start'
          timeDiff = dateFunctions.timeBetween(socket.stopWatch.moment, new Date())
          timeBefore = _.clone socket.stopWatch.time
          time.ss = (timeBefore.ss + timeDiff.ss)%60
          time.mm = (timeBefore.mm + timeDiff.mm)%60
          time.hh += timeDiff.hh            

        match.time = time
        match.update()