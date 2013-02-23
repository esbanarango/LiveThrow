#Reference 

##CSS

####Bootstrap Custom
* Remember the readonly.

```css
  @bodyBackground = #252123
  @textColor = #AAA
  @baseFontSize = 13px
  @baseLineHeight = 18px
  @tableBackgroundAccent = #393939
  @tableBackgroundHover = #353535
  @linkColorHover = lighten(@linkColor, 15%)
  @inputBackground = #3D3D3D
  @inputBorder = rgba(255, 255, 255, 0.08)
  @formActionsBackground = rgba(62, 57, 61, 0.25)
  @navbarBackground = #103249
  @navbarBackgroundHighlight = #31646A
  @navbarSearchBackground = darken(@navbarBackground,25%)
  @navbarSearchBackgroundFocus = #393939
  @navbarText = #ccc
  @navbarBrandColor = #ddd
  @navbarLinkColor = #eee
  @dropdownLinkColor = #333333
```

##Heroku

jQuery noty version.

`"socket.io": "~0.9.6"`

"The WebSockets protocol is not yet supported on the Cedar stack."

```coffeescript
  socketIO.configure ->
    socketIO.set "transports", ["xhr-polling"]
    socketIO.set "polling duration", 10
```
