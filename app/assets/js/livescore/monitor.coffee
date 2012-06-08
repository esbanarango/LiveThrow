jQuery ->
  $("#formGolTeam1,#formGolTeam2").on "submit", (e) ->
    e.preventDefault()
    data = $(@).serialize()
    console.log data     
    $.ajax
      type: "POST"
      url: "/live/action"
      data: data
      error: (jqXHR) ->
        console.log "Error " + jqXHR
      success: (_data) =>
        console.log _data
        numTeam = $(@).find("input[name=team]").val()
        console.log numTeam
        score = parseInt($("#team#{numTeam}Score").text())
        $("#team#{numTeam}Score").text(++score)