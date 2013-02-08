redis          = require('redis').createClient()
_              = require 'underscore'

class Team
  # The Redis key that will store all Team objects as a hash.
  @key: ->
    "Teams:#{process.env.NODE_ENV}"
  # Fetch all the public Teams objects from the database.
  # callback: (err, teams)
  @all: (callback) ->
    redis.hgetall Team.key(), (err, objects) ->
      teams = []
      for key, value of objects
        team = new Team JSON.parse(value)
        teams.push team if team.public is "on"
      callback null, teams
  
  # All the Teams 
  # callback: (err, teams)
  @allall: (callback) ->
    redis.hgetall Team.key(), (err, objects) ->
      teams = []
      for key, value of objects
        team = new Team JSON.parse(value)
        teams.push team
      callback null, teams
  # Retrive a single Team by Id.
  #
  # id: The unique id of the Team, such as 'Key-Lime'.
  # callback: (err, team)
  @getById: (id, callback) ->
    redis.hget Team.key(), id, (err, json) ->
      if json is null
        callback new Error("Team '#{id}' could not be found."), null
        return
      team = new Team JSON.parse(json)
      callback null, team

  @getByuserId: (id, callback) ->
    redis.hgetall Team.key(), (err, objects) ->
      teams = []
      for key, value of objects
        team = new Team JSON.parse(value)
        teams.push team if team.userId is id
      callback null, teams

  constructor: (attributes) ->
    @[key] = value for key,value of attributes
    @setDefaults()
    @

  setDefaults: ->
    unless @public
      @public = 'on'

  # callback: (err, team)
  save: (callback) ->
    # Generate de id
    redis.incr Team.key()+'Id', ( err, id ) =>
      @id = id
      redis.hset Team.key(), id, JSON.stringify(@), (err, responseCode) =>
        callback null, @
  destroy: (callback) ->
    redis.hdel Team.key(), @id, (err) ->
      callback err if callback

module.exports = Team