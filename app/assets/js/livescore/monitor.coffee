jQuery ->
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