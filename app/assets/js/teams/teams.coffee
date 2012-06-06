jQuery ->
  $("#newTeamForm").on "submit", (e) ->
    e.preventDefault()
    validation = $("#newTeamForm").validate()
    if validation.form()
      data = $(this).serialize()
      $.ajax
        type: "POST"
        url: "/teams/create"
        data: data
        error: (jqXHR) ->
          console.log "Error " + jqXHR
        success: (data) ->
          console.log data
          validation.resetForm()          
          notyAlert(data.message,"topCenter","success","3000")



          