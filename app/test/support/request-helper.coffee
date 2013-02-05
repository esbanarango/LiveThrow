request = require 'request'
app     = require '../../server'

RequestHelper =
  login: (done) ->
    options =
      uri:"http://localhost:#{app.settings.port}/sessions"
      form:
        email: 'bayron@beltran.com'
        password: '111111'
      followAllRedirects: false
    request.post options, (err, _response, _body) ->
      done()

  logout: (done) ->
    options =
      uri:"http://localhost:#{app.settings.port}/sessions"
      followAllRedirects: false
    request.del options, (err, _response, _body) ->
      done()

module.exports = RequestHelper