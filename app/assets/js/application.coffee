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

  # Transition
  timeToDisplay = 2000
  opacityChangeDelay = 50
  opacityChangeAmount = 0.05
  slideshow = $("#slideshow")
  urls = ["../images/front_4.jpg","../images/front_3.jpg", "../images/front_2.jpg", "../images/front_1.jpg"]
  index = 0
  transition = ->
    url = urls[index]
    slideshow.css "background-image", "url(" + url + ")"
    index = index + 1
    index = 0  if index > urls.length - 1

  fadeIn = (opacity) ->
    opacity = opacity + opacityChangeAmount
    slideshow.css "opacity", opacity
    if opacity >= 1
      slideshow.trigger "fadeIn-complete"
      return
    setTimeout (->
      fadeIn opacity
    ), opacityChangeDelay

  fadeOut = (opacity) ->
    opacity = opacity - opacityChangeAmount
    slideshow.css "opacity", opacity
    if opacity <= 0
      slideshow.trigger "fadeOut-complete"
      return
    setTimeout (->
      fadeOut opacity
    ), opacityChangeDelay

  slideshow.on "fadeOut-complete", (event) ->
    transition()
    fadeIn 0

  slideshow.on "display-complete", (event) ->
    fadeOut 1

  slideshow.on "fadeIn-complete", (event) ->
    setTimeout (->
      slideshow.trigger "display-complete"
    ), timeToDisplay

  transition()
  fadeIn 0
