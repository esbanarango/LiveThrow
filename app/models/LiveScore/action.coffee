redis          = require('redis').createClient()
_              = require 'underscore'

class Action
  # The Redis key that will store all Action objects as a hash.
  @key: ->
    "Actions"
  # Fetch all Action objects from the database.
  # callback: (err, actions)
  @all: (key, callback) ->
    redis.hgetall key, (err, objects) ->
      actions = []
      for key, value of objects
        action = new Action JSON.parse(value), key
        actions.push action
      callback null, actions


  constructor: (attributes, key) ->
    @[k] = value for k,value of attributes
    @key = key
    @
  # Persists the current object to Redis. The key is the Id.
  # All other attributes are saved as a sub-hash in JSON format.
  #
  # callback: (err, action)
  save: (callback) ->
    # Generate de id
    redis.incr @key+"Id", ( err, id ) =>
      @id = id
      redis.hset @key, id, JSON.stringify(@), (err, responseCode) =>
        callback null, @  
  destroy: (callback) ->
    redis.hdel Action.key(), @email, (err) ->
      callback err if callback

module.exports = Action