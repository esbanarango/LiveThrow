Team    = require '../../models/Management/team'

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


module.exports = TeamFactory