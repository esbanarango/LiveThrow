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

  # Extracts all the user information from the Facebook response,
  # and calls the callbak with the new user.
  # callback: (err, user)
  @createFromFacebook: (user, callback) ->
    attrs =
      u_id:         user.id
      username:     user.username
      email:        user.emails[0].value
      first_name:   user._json.first_name
      last_name:    user._json.last_name
      birthday:     user._json.birthday
      gender:       user._json.gender
      timezone:     user._json.timezone
      signup_from: 'facebook'
    user = new User attrs
    callback user

  constructor: (attributes) ->
    @[key] = value for key,value of attributes
    @
  # Persists the current object to Redis. The key is the Id.
  # All other attributes are saved as a sub-hash in JSON format.
  #
  # callback: (err, user)
  save: (callback) ->
    @validate 'save',(err) =>
      unless err
        redis.hset User.key(), @email, JSON.stringify(@), (err, responseCode) =>
          callback err, @ if callback
      else
        callback err, @ if callback

  # Update the current object to Redis.
  # All other attributes are saved as a sub-hash in JSON format.
  #
  # callback: (err, user)
  update: (callback) ->
    redis.hexists User.key(), @email, (err, data)=>
      if data
        @validate 'update', (err) =>
          unless err
            redis.hset User.key(), @email, JSON.stringify(@), (err, responseCode) =>
              callback err, @ if callback
          else
            callback err, @ if callback
      else
        callback new Error("This user hasn't been saved.")    

  destroy: (callback) ->
    redis.hdel User.key(), @email, (err) ->
      callback err if callback

  validate: (from,callback)->
    return callback new Error('Username is required.') unless @username
    return callback new Error('Email is required.') unless @email
    if from is 'save'
      redis.hexists User.key(), @email, (err, data)->
        if data
          callback new Error('Email is already taken.')
        else
          callback()
    else
      callback()

module.exports = User