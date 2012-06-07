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
          $("#modalNewPlayer #buttonXModal").trigger("click");
          addToList (data.response)        
          notyAlert(data.message,"topCenter","success","3000")

  $(document).on "click","a.deletePlayer", ->
    id = $(@).parent().parent().data("playerid")
    notyConfirm("Do you really want to delete this player?","topCenter","alert"
      =>
        trDelete = $(@).parent().parent()
        $.ajax
          type: "POST"
          url: "/players"
          data: {_method:"delete",id:id}
          error: (jqXHR) ->
            console.log "Error " + jqXHR
          success: (data) ->
            console.log data
            trDelete.slideUp "slow", ->
              $(@).remove()
      ,
      ->
      )  

addToList = (player) ->
  newTr ="<tr style='display:none;' data-playerid='#{player.id}' data-playername='#{player.name} #{player.nickname} #{player.last_name}' >
            <td>#{player.number}</td>
            <td>#{player.name} #{player.nickname} #{player.last_name}</td>
            <td>#{player.position}</td>
            <td>#{player.gender}</td>
            <td><a href='#' class='deletePlayer' ><i class='icon-remove icon-white'></i></a></td></tr>"
  $("#playersTable").append(newTr);
  $("#playersTable tr:last").show("slow");