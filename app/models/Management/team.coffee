_              = require 'underscore'

class Team
  # The Redis key that will store all Team objects as a hash.
  @key: ->
    "Teams"
  @states: ['inactive', 'making', 'ready']
  # Fetch all Team objects from the database.
  # callback: (err, teams)
  @all: (callback) ->
    redis.hgetall Team.key(), (err, objects) ->
      teams = []
      for key, value of objects
        team = new Team JSON.parse(value)
        teams.push team
      callback null, teams
  @active: (callback) ->
    Team.all (err, teams) ->
      activeTeams = []
      activeTeams.push team for team in teams when team.state isnt 'inactive'
      readyTeams  = _.filter activeTeams, (team) -> team.state is 'ready'
      makingTeams = _.filter activeTeams, (team) -> team.state is 'making'
      readyTeams  = _.sortBy readyTeams,  (team) -> -team.stateUpdatedAt
      makingTeams = _.sortBy makingTeams, (team) -> -team.stateUpdatedAt
      sortedTeams = _.flatten [makingTeams, readyTeams]
      callback null, sortedTeams

  # Retrive a single Team by Id.
  #
  # id: The unique id of the Team, such as 'Key-Lime'.
  # callback: (err, team)
  @getById: (id, callback) ->
    redis.hget Team.key(), id, (err, json) ->
      if json is null
        callback new Error("Team '#{id}' could not be found.")
        return
      team = new Team JSON.parse(json)
      callback null, team
  constructor: (attributes) ->
    @[key] = value for key,value of attributes
    @setDefaults()
    @
  setDefaults: ->
    unless @state
      @state = 'inactive'
    @generateId()
    @defineStateMachine()
  generateId: ->
    if not @id and @name
      @id = @name.replace /\s/g, '-'
  # Adds a method for each state that can be called to change the @state to that state.
  defineStateMachine: ->
    for state in Team.states
      do (state) =>
        @[state] = (callback) ->
          @state = state
          @stateUpdatedAt = (new Date).getTime()
          @save ->
            callback()
  # Persists the current object to Redis. The key is the Id.
  # All other attributes are saved as a sub-hash in JSON format.
  #
  # callback: (err, team)
  save: (callback) ->
    @generateId()
    redis.hset Team.key(), @id, JSON.stringify(@), (err, responseCode) =>
      callback null, @
  destroy: (callback) ->
    redis.hdel Team.key(), @id, (err) ->
      callback err if callback

module.exports = Team