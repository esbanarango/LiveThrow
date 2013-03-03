
@changeIdByInfo = () ->
  $(".changeId").each ->
    id = $(@).text()
    idTeam = $(@).data("idteam") 
    playerInfo = $("#id-#{id}team-#{idTeam}")
    stringInfo = "#"+playerInfo.data("number")+" "+playerInfo.data("name")+" "+playerInfo.data("nickname")+" "+playerInfo.data("lastname")
    $(@).text(stringInfo)

@addToScore = (team)->
  div = $("#eq#{team}")
  #Get number
  num = parseInt(div.find('.scoreHidden').text())
  num++
  numS = ('0' + (num)).slice(-2)
  div.find('.scoreHidden').text(num)
  tables = ["minutePlay","secondPlay"]
  i = 1
  loop
    aa = div.find("ul.#{tables[i]} li.active")
    if aa.is(":last-child")
      div.find("ul.#{tables[i]} li").removeClass "before"
      aa.addClass("before").removeClass "active"
      aa = div.find("ul.#{tables[i]} li").eq(0)
      aa.find('.up .inn,.down .inn').text(numS[i])
      aa.addClass("active")
    else
      div.find("ul.#{tables[i]} li").removeClass "before"
      aa.addClass("before").removeClass("active")
      aa.next("li").find('.up .inn,.down .inn').text(numS[i])
      aa.next("li").addClass("active")
    div.find("ul.#{tables[i]}").addClass "play"
    i--
    break unless div.find("ul.minutePlay li.active .up .inn").text() < numS[0]

$ ->
  $('#stopwatch').stopwatch()
  $(".bordersTableScore").nanoScroller()
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
    $("#tableScores").find('.content').animate({scrollTop : 0},'fast')
    $("#tableScores table tbody").find(":first").find("td").show("slow")