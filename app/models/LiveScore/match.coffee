redis          = require('redis').createClient()
_              = require 'underscore'

class Match
  # The Redis key that will store all Match objects as a hash.
  @key: ->
    "Matchs"
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
  # Persists the current object to Redis. The key is the Id.
  # All other attributes are saved as a sub-hash in JSON format.
  #
  # callback: (err, match)
  save: (callback) ->
    redis.hset Match.key(), @email, JSON.stringify(@), (err, responseCode) =>
      callback null, @
  destroy: (callback) ->
    redis.hdel Match.key(), @email, (err) ->
      callback err if callback

module.exports = Match