jQuery ->
  $("#formGolTeam1,#formGolTeam2").on "submit", (e) ->
    e.preventDefault()
    data = $(@).serialize()    
    $.ajax
      type: "POST"
      url: "/live/action"
      data: data
      error: (jqXHR) ->
        console.log "Error " + jqXHR
      success: (_data) => 