redis   = require('redis').createClient()
Team    = require '../../models/Management/team'
_       = require 'underscore'

TeamFactory =
  # Create two teams in the database.
  #
  # callback: () No params.
  createSeveral: (callback) ->
    # Attributes
    team1 =
      name: "Las Galacticos"
      category: "Open"
      public: 'off'
      userId: "bayron@beltran.com"
    team2 =
      name: "El niupi"
      category: "Open"
      public: 'on'
      userId: "bayron@beltran.com"
    team3 =
      name: "Galatasara"
      category: "Women"
      public: 'on'
      userId: "bayron@beltran.com"
    team4 =
      name: "El Cucuta"
      category: "Women"
      public: 'on'
      userId: "alexis@copen.com" 
    teamAttributes = [team1, team2, team3]
    # Now create them all
    createOne = @createOne
    runSequentially = (item, otherItems...) ->
      createOne item, ->
        if otherItems.length
          runSequentially otherItems...
        else
          callback()
    runSequentially teamAttributes...

  createOne: (attributes, callback) ->
    team = new Team attributes
    team.save (err, team) ->
      callback err, team

  clean: ->
    Team.allall (err,_allTeams) ->
      redis.DEL "Teams:#{process.env.NODE_ENV}Id"
      _.each _allTeams, (t)->
        t.destroy()



module.exports = TeamFactory