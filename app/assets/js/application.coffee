#= require jquery.noty.js

#Beautyfull alerts with noty! :) http://needim.github.com/noty/
@notyAlert = (text, layOut, type, timeOut) ->
  noty
    text: text
    layout: layOut
    type: type
    theme : 'noty_theme_twitter'
    textAlign: "center"
    easing: "swing"
    animateOpen:
      height: "toggle"

    animateClose:
      height: "toggle"

    speed: "500"
    timeout: timeOut
    closable: false
    closeOnSelfClick: false

@notyConfirm = (text,layOut,type,okFunction,cancelFunction) ->    
  noty
    layout: layOut
    text: text
    type: type
    theme : 'noty_theme_twitter'
    closable: false
    timeout: false  
    closeOnSelfClick: false
    closeOnSelfHover: false    
    buttons: [
      type: "btn btn-small btn-danger"
      text: "Ok"
      click: ($noty) ->
        $noty.close()
        okFunction()
    ,
      type: "btn btn-small"
      text: "Cancel"
      click: ($noty) ->
        $noty.close()
        cancelFunction()
     ]

$.fn.serializeObject = ->
  o = {}
  a = @serializeArray()
  $.each a, ->
    if o[@name] isnt `undefined`
      o[@name] = [ o[@name] ]  unless o[@name].push
      o[@name].push @value or ""
    else
      o[@name] = @value or ""
  o

jQuery ->