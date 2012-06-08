redis          = require('redis').createClient()
_              = require 'underscore'

class Action
  # The Redis key that will store all Action objects as a hash.
  @key: ->
    "Actions"
  # Fetch all Action objects from the database.
  # callback: (err, actions)
  @all: (callback) ->
    redis.hgetall Action.key(), (err, objects) ->
      actions = []
      for key, value of objects
        action = new Action JSON.parse(value)
        actions.push action
      callback null, actions
  # Retrive a single Action by email.
  #
  # callback: (err, action)
  @getById: (id, callback) ->
    redis.hget Action.key(), id, (err, json) ->
      if json is null
        callback new Error("Action '#{id}' could not be found.")
        return
      action = new Action JSON.parse(json)
      callback null, action
  constructor: (attributes) ->
    @[key] = value for key,value of attributes
    @
  # Persists the current object to Redis. The key is the Id.
  # All other attributes are saved as a sub-hash in JSON format.
  #
  # callback: (err, action)
  save: (callback) ->
    redis.hset Action.key(), @email, JSON.stringify(@), (err, responseCode) =>
      callback null, @
  destroy: (callback) ->
    redis.hdel Action.key(), @email, (err) ->
      callback err if callback

module.exports = Action