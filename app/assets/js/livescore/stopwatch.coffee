led = $("#led")
els = led.children()
uid = 0
size = 6
w = 0
h = 0
row = 0
col = 0
arr_lights = []
hh = document.getElementById("time-hh")
hx = document.getElementById("time-h")
mm = document.getElementById("time-mm")
mx = document.getElementById("time-m")
ss = document.getElementById("time-ss")
sx = document.getElementById("time-s")
k = 0
len = els.length

while k < len
  continue  unless els[k].nodeType is 1
  w = parseInt(els[k].clientWidth)
  h = parseInt(els[k].clientHeight)
  row = parseInt(h / size)
  col = parseInt(w / size)
  t = undefined
  l = undefined
  sum = 0
  i = 0

  while i < row
    j = 0

    while j < col
      uid++
      t = size * i
      l = size * j
      arr_lights.push "<div uid=\"" + uid + "\" id=\"l-" + uid + "\" class=\"light row-" + i + " col-" + j + "\" style=\"top:" + t + "px;left:" + l + "px\"></div>"
      j++
    i++
  els[k].innerHTML = arr_lights.join("")
  arr_lights = []
  k++
setInterval (->
  now = new Date()
  time_hh = parseInt(now.getHours())
  time_mm = parseInt(now.getMinutes())
  time_ss = parseInt(now.getSeconds())
  hh.className = "block-digital num-" + parseInt(time_hh / 10)
  hx.className = "block-digital num-" + parseInt(time_hh % 10)
  mm.className = "block-digital num-" + parseInt(time_mm / 10)
  mx.className = "block-digital num-" + parseInt(time_mm % 10)
  ss.className = "block-digital num-" + parseInt(time_ss / 10)
  sx.className = "block-digital num-" + parseInt(time_ss % 10)
), 1000