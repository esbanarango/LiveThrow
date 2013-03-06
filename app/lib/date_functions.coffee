date =
  timeBetween: (t1,t2) ->
    dif = t1.getTime() - t2.getTime()
    seconds = dif / 1000
    seconds = Math.floor(Math.abs(seconds))
    minutes = Math.floor(Math.abs(seconds/60))
    hours = Math.floor(Math.abs(minutes/60))
    time=
      hh: hours
      mm: minutes
      ss: seconds
    return time

module.exports = date