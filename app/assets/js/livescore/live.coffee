
@changeIdByInfo = () ->
  $(".changeId").each ->
    id = $(@).text()
    idTeam = $(@).data("idteam") 
    playerInfo = $("#id-#{id}team-#{idTeam}")
    stringInfo = "#"+playerInfo.data("number")+" "+playerInfo.data("name")+" "+playerInfo.data("nickname")+" "+playerInfo.data("lastname")
    $(@).text(stringInfo)

jQuery ->
  changeIdByInfo()
  matchId = window.location.pathname.split('/')[2]
  socket = io.connect("/")
  socket.on "match:#{matchId}", (action) ->
    console.log(action)
    score = parseInt($("#team#{action.team}Score").text())
    $("#team#{action.team}Score").text(++score)
    assisPlayer = $("#id-#{action.assitencePlayerId}team-#{action.team}")
    golPlayer = $("#id-#{action.golPlayerId}team-#{action.team}")
    divData = $("#golStructTeam#{action.team} table tbody").clone()
    golString = "#"+golPlayer.data("number")+" "+golPlayer.data("name")+" "+golPlayer.data("nickname")+" "+golPlayer.data("lastname")
    divData.find(".golName").text(golString)
    assitString = "#"+assisPlayer.data("number")+" "+assisPlayer.data("name")+" "+assisPlayer.data("nickname")+" "+assisPlayer.data("lastname")
    divData.find(".assistName").text(assitString)
    golString = "<img src='./../../images/tiempo.png'>"+action.minuto
    divData.find(".golTime").html(golString)
    divData.attr("id","actionId"+action.id)
    #Put, scroll top and slideDown
    $("#tableScores table").prepend(divData.html())
    $("#tableScores").animate({scrollTop : 0},'fast')
    $("#tableScores table tbody").find(":first").find("td").show("slow")
    #$("#tableScores table tbody").find(":first").slideDown("slow")
