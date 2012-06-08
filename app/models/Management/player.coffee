redis          = require('redis').createClient()
_              = require 'underscore'

class Player
  ### The Redis key that will store all Player objects as a hash.
  @key: ->
    "Players"
  ###  
  # Fetch all Player objects from the database.
  # callback: (err, players)
  @all: (key, callback) ->
    redis.hgetall key, (err, objects) ->
      players = []
      for key, value of objects
        player = new Player JSON.parse(value), key
        players.push player
      callback null, players

  @getById: (id, callback) ->
    redis.hget @key, id, (err, json) ->
      if json is null
        callback new Error("Player '#{id}' could not be found.")
        return
      player = new Player JSON.parse(json), @key
      callback null, player

  @destroy: (key,id,callback) ->
    redis.hdel key, id, (err) ->
      callback err if callback    

  constructor: (attributes, key) ->
    @[k] = value for k,value of attributes
    @key = key
    @
  # Persists the current object to Redis. The key is the Id.
  # All other attributes are saved as a sub-hash in JSON format.
  #
  # callback: (err, player)
  save: (callback) ->
    # Generate de id
    redis.incr @key+"Id", ( err, id ) =>
      @id = id
      redis.hset @key, id, JSON.stringify(@), (err, responseCode) =>
        callback null, @  

  destroy: (callback) ->
    redis.hdel @key, @id, (err) ->
      callback err if callback

module.exports = Player