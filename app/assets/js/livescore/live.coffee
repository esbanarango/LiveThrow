
@changeIdByInfo = () ->
  $(".changeId").each ->
    id = $(@).text()
    idTeam = $(@).data("idteam") 
    playerInfo = $("#id-#{id}team-#{idTeam}")
    stringInfo = "#"+playerInfo.data("number")+" "+playerInfo.data("name")+" "+playerInfo.data("nickname")+" "+playerInfo.data("lastname")
    $(@).text(stringInfo)

@addToScore = (team)->
  #get number
  num = parseInt($("#eq#{team}").find('.scoreHidden').text())
  num++
  numS = ('0' + (num)).slice(-2)
  $("#eq#{team}").find('.scoreHidden').text(num)
  #Right digit
  aa = $("#eq#{team}").find('ul.secondPlay li.active')
  if aa.is(":last-child")
    $("#eq#{team}").find("ul.secondPlay li").removeClass "before"
    aa.addClass("before").removeClass "active"
    aa = $("#eq#{team}").find("ul.secondPlay li").eq(0)
    aa.find('.up .inn,.down .inn').text(numS[1])
    aa.addClass("active")
  else
    $("#eq#{team}").find("ul.secondPlay li").removeClass "before"
    aa.addClass("before").removeClass("active")
    aa.next("li").find('.up .inn,.down .inn').text(numS[1])
    aa.next("li").addClass("active")
  $("#eq#{team}").find('ul.secondPlay').addClass "play"
  #Left digit
  aa = $("#eq#{team}").find('ul.minutePlay li.active')
  if parseInt(aa.find('.up .inn').text()) < parseInt(numS[0])
    if aa.is(":last-child")
      $("#eq#{team}").find("ul.minutePlay li").removeClass "before"
      aa.addClass("before").removeClass "active"
      aa = $("#eq#{team}").find("ul.minutePlay li").eq(0)
      aa.find('.up .inn,.down .inn').text(numS[0])
      aa.addClass("active").closest("body").addClass "play"
    else
      $("#eq#{team}").find("ul.minutePlay li").removeClass "before"
      aa.addClass("before").removeClass("active")
      aa.next("li").find('.up .inn,.down .inn').text(numS[0])
      aa.next("li").addClass("active").closest("body").addClass "play"
    $("#eq#{team}").find('ul.minutePlay').addClass "play"

$ ->
  changeIdByInfo()
  matchId = window.location.pathname.split('/')[2]
  socket = io.connect("/")
  socket.on "match:#{matchId}", (action) ->
    addToScore(action.team)
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
