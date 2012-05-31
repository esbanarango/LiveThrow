_              = require 'underscore'

class Team
  # The Redis key that will store all Pie objects as a hash.
  @key: ->
    "Pie:#{process.env.NODE_ENV}"
  @states: ['inactive', 'making', 'ready']
  # Fetch all Pie objects from the database.
  # callback: (err, pies)
  @all: (callback) ->
    redis.hgetall Pie.key(), (err, objects) ->
      pies = []
      for key, value of objects
        pie = new Pie JSON.parse(value)
        pies.push pie
      callback null, pies
  @active: (callback) ->
    Pie.all (err, pies) ->
      activePies = []
      activePies.push pie for pie in pies when pie.state isnt 'inactive'
      readyPies  = _.filter activePies, (pie) -> pie.state is 'ready'
      makingPies = _.filter activePies, (pie) -> pie.state is 'making'
      readyPies  = _.sortBy readyPies,  (pie) -> -pie.stateUpdatedAt
      makingPies = _.sortBy makingPies, (pie) -> -pie.stateUpdatedAt
      sortedPies = _.flatten [makingPies, readyPies]
      callback null, sortedPies

  # Retrive a single Pie by Id.
  #
  # id: The unique id of the Pie, such as 'Key-Lime'.
  # callback: (err, pie)
  @getById: (id, callback) ->
    redis.hget Pie.key(), id, (err, json) ->
      if json is null
        callback new Error("Pie '#{id}' could not be found.")
        return
      pie = new Pie JSON.parse(json)
      callback null, pie
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
    for state in Pie.states
      do (state) =>
        @[state] = (callback) ->
          @state = state
          @stateUpdatedAt = (new Date).getTime()
          @save ->
            callback()
  # Persists the current object to Redis. The key is the Id.
  # All other attributes are saved as a sub-hash in JSON format.
  #
  # callback: (err, pie)
  save: (callback) ->
    @generateId()
    redis.hset Pie.key(), @id, JSON.stringify(@), (err, responseCode) =>
      callback null, @
  destroy: (callback) ->
    redis.hdel Pie.key(), @id, (err) ->
      callback err if callback

module.exports = Pie