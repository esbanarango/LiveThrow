Con = require './connection'
_   = require 'underscore'

class User
  constructor: (attributes) ->
    @[key] = value for key,value of attributes
    client = Con()
    results = null
    client.query "SELECT * FROM USER", (err, _results, fields) ->
      throw err if err
      results = _results
      console.log(results)
      client.end()
    @
  # Persists the current object to MySQL. The key is the Id.
  #
  save: (callback) ->
    @generateId()
    redis.hset Pie.key(), @id, JSON.stringify(@), (err, responseCode) =>
      callback()
  destroy: (callback) ->
    redis.hdel Pie.key(), @id, (err) ->
      callback err if callback

module.exports = User