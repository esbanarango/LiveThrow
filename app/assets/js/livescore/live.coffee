jQuery ->
  matchId = window.location.pathname.split('/')[2]
  socket = io.connect("/")
  socket.on "match:#{matchId}", (action) ->
    console.log(action)
    score = parseInt($("#team#{action.team}Score").text())
    $("#team#{action.team}Score").text(++score)