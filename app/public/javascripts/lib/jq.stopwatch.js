(function(e){e.fn.stopwatch=function(t){var n=e(this);n.addClass("stopwatch").addClass(t);n.each(function(){function a(){var e=parseFloat(i.text());var t=parseFloat(s.text());var n=parseFloat(o.text());n++;if(n>59){n=0;t=t+1}if(t>59){t=0;e=e+1}i.html("0".substring(e>=10)+e);s.html("0".substring(t>=10)+t);o.html("0".substring(n>=10)+n)}var t=e(this);var n=0;var r=e("<div>").addClass("the-time");var i=e("<span>").addClass("hr").text("00");var s=e("<span>").addClass("min").text("00");var o=e("<span>").addClass("sec").text("00");var u=e("<a>").attr("href","").addClass("start-stop").text("Start");r=r.append(i).append(s).append(o);t.html("").append(r).append(u);u.bind("click",function(t){t.preventDefault();var r=e(this);if(r.text()==="Start"){n=setInterval(a,1e3);r.text("Stop")}else{clearInterval(n);r.text("Start")}})})}})(jQuery)