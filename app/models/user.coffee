redisHeroku = require('heroku-redis-client')
redis       = redisHeroku.createClient()
_              = require 'underscore'

class User
  # The Redis key that will store all User objects as a hash.
  @key: ->
    "Users:#{process.env.NODE_ENV}"
  # Fetch all User objects from the database.
  # callback: (err, users)
  @all: (callback) ->
    redis.hgetall User.key(), (err, objects) ->
      users = []
      for key, value of objects
        user = new User JSON.parse(value)
        users.push user
      callback err, users
  # Retrive a single User by email.
  #
  # callback: (err, user)
  @getByEmail: (email, callback) ->
    redis.hget User.key(), email, (err, json) ->
      if json is null
        callback new Error("User '#{email}' could not be found.")
        return
      user = new User JSON.parse(json)
      callback err, user
  constructor: (attributes) ->
    @[key] = value for key,value of attributes
    @
  # Persists the current object to Redis. The key is the Id.
  # All other attributes are saved as a sub-hash in JSON format.
  #
  # callback: (err, user)
  save: (callback) ->
    @validate (err) =>
      unless err
        redis.hset User.key(), @email, JSON.stringify(@), (err, responseCode) =>
          callback err, @ if callback
      else
        callback err, @ if callback

  destroy: (callback) ->
    redis.hdel User.key(), @email, (err) ->
      callback err if callback

  validate: (callback)->
    return callback new Error('Username is required.') unless @username
    redis.hexists User.key(), @email, (err, data)->
      if data
        callback new Error('Email is already taken.')
      else
        callback()

module.exports = User