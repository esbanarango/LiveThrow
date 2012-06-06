#= require jquery-1.7.2.min.js
#= require underscore-min.js
#= require jquery.noty.js
#= require jquery.validate.js
#= require jquery.form.js

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

jQuery ->