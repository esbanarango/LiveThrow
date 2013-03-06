
$ ->

  socket.on 'id', (id)->

    url = window.location.pathname
    # it could ../:id/monitor/ or ../:id/monitor
    url = url.slice(0, -1) if url[url.length-1] is '/'
    $.post window.location.pathname+'/register',
      id: id
    , (data) ->

  $("#formGolTeam1,#formGolTeam2").on "submit", (e) ->
    e.preventDefault()
    data = $(@).serialize()
    time = $('#stopwatch').find('.hr').text()+':'+$('#stopwatch').find('.min').text()
    data += "&minuto=#{time}"
    $.ajax
      type: "POST"
      url: "/live/action"
      data: data
      error: (jqXHR) ->
        console.log "Error " + jqXHR
      success: (_data) => 