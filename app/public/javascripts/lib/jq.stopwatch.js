(function($) {
  $.fn.stopwatch = function(theme,hh,mm,ss) {
    var stopwatch = $(this);
    stopwatch.addClass('stopwatch').addClass(theme);

    stopwatch.each(function() {
      var instance = $(this);
      var timer = 0;

      var stopwatchFace = $('<div>').addClass('the-time');
      var timeHour = $('<span>').addClass('hr digit').text("0".substring(hh >= 10) + hh);
      var timeMin = $('<span>').addClass('min digit').text("0".substring(mm >= 10) + mm);
      var timeSec = $('<span>').addClass('sec digit').text("0".substring(ss >= 10) + ss);
      var startStopBtn = $('<a>').attr('href', '').addClass('start-stop btn btn-inverse').text('Start');
      stopwatchFace = stopwatchFace.append(timeHour).append(timeMin).append(timeSec);
      instance.html('').append(stopwatchFace).append(startStopBtn);

      startStopBtn.bind('click', function(e) {
        e.preventDefault();
        var time = {hh:parseInt(timeHour.text()),mm:parseInt(timeMin.text()),ss:parseInt(timeSec.text())};
        var button = $(this);
        if(button.text() === 'Start') {          
          socket.emit('actionStopWatch', 'start', time);
          timer = setInterval(runStopwatch, 1000);
          button.text('Stop');
          $('#lightLive').removeClass('off').addClass('on')
        } else {
          socket.emit('actionStopWatch', 'stop', time);
          clearInterval(timer);
          button.text('Start');
          $('#lightLive').removeClass('on').addClass('off')
        }
      });

      function runStopwatch() {
        // We need to get the current time value within the widget.
        var hour = parseFloat(timeHour.text());
        var minute = parseFloat(timeMin.text());
        var second = parseFloat(timeSec.text());

        second++;

        if(second > 59) {
          second = 0;
          minute = minute + 1;
        }

        if(minute > 59) {
          minute = 0;
          hour = hour + 1;
        }

        timeHour.html("0".substring(hour >= 10) + hour);
        timeMin.html("0".substring(minute >= 10) + minute);
        timeSec.html("0".substring(second >= 10) + second);
      }
    });
  }
})(jQuery);