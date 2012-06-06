jQuery ->
  $("#submitNewPlayerForm").on "click", ->
    $("#newPlayerForm").submit()
  $("#newPlayerForm").on "submit", (e) ->
    e.preventDefault()
    validation = $("#newPlayerForm").validate()
    if validation.form()
      data = $(@).serialize()
      $.ajax
        type: "POST"
        url: "/players/create"
        data: data
        error: (jqXHR) ->
          console.log "Error " + jqXHR
        success: (data) ->
          console.log data
          validation.resetForm()
          $("#modalNewPlayer").hide();
          addToList (data.response)        
          notyAlert(data.message,"topCenter","success","3000")

addToList = (player) ->
  newTr ="<tr style='display:none;'><td>#{player.name} #{player.nickname} #{player.last_name}</td><td>#{player.position}</td><td><a href=\"#\"><i class='icon-remove icon-white'></i></a></td></tr>"
  $("#playersTable").append(newTr);
  $("#playersTable tr:last").show("slow");