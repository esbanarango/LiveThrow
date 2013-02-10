redis   = require('redis').createClient()
Match    = require '../../models/LiveScore/match'
_       = require 'underscore'

MatchFactory =

  clean: ->
    Match.all (err,_allMatches) ->
      redis.DEL "Matches:#{process.env.NODE_ENV}Id"
      _.each _allMatches, (m)->
        m.destroy()



module.exports = MatchFactory