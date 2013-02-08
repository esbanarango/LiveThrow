redis          = require('redis').createClient()
_              = require 'underscore'
Team           = require './../Management/team'
Player         = require './../Management/player'
Action         = require './action'

class Match
  # The Redis key that will store all Match objects as a hash.
  @key: ->
    "Matches:#{process.env.NODE_ENV}"
  # Fetch all Match objects from the database.
  # callback: (err, matchs)
  @all: (callback) ->
    redis.hgetall Match.key(), (err, objects) ->
      matchs = []
      for key, value of objects
        match = new Match JSON.parse(value)
        matchs.push match
      callback null, matchs
  # Retrive a single Match by email.
  #
  # callback: (err, match)
  @getById: (id, callback) ->
    redis.hget Match.key(), id, (err, json) ->
      if json is null
        callback new Error("Match '#{id}' could not be found.")
        return
      match = new Match JSON.parse(json)
      callback null, match
  constructor: (attributes) ->
    @[key] = value for key,value of attributes
    @

  fillUp: (callback) ->
    Team.getById @teamId1, (err, _team1) =>
      @team1 = _team1
      Team.getById @teamId2, (err, _team2) =>
        @team2 = _team2
        Player.all @teamId1, (err, _players1) =>
          @players1 = _players1
          Player.all @teamId2, (err, _players2) =>
            @players2 = _players2
            Action.all @id, (err,_actions) =>              
              @actions =_actions.reverse()
              callback null,@
  # Persists the current object to Redis. The key is the Id.
  # All other attributes are saved as a sub-hash in JSON format.
  #
  # callback: (err, match)
  save: (callback) ->
    # Generate de id
    redis.incr Match.key()+'Id', ( err, id ) =>
      @id = id      
      redis.hset Match.key(), id, JSON.stringify(@), (err, responseCode) =>
        callback null, @
  update: (callback) ->
    redis.hset Match.key(), @id, JSON.stringify(@), (err, responseCode) =>
      callback null, @            
  destroy: (callback) ->
    redis.hdel Match.key(), @email, (err) ->
      callback err if callback



module.exports = Match