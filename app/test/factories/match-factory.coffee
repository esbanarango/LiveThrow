redis   = require('redis').createClient()
Match    = require '../../models/LiveScore/match'
_       = require 'underscore'

MatchFactory =

  clean: (callback)->
    redis.DEL Match.key()+'Id', ->
      redis.DEL Match.key(), ->
        callback() if callback

module.exports = MatchFactory