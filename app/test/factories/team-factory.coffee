redis   = require('redis').createClient()
Team    = require '../../models/Management/team'
Faker   = require 'Faker'
_       = require 'underscore'

TeamFactory =
  # Create two teams in the database.
  #
  # callback: () No params.
  createSeveral: (callback) ->
    # Attributes
    team1 =
      name: "Las Galacticos"
      country: Faker.random.uk_country()
      city: Faker.random.city_prefix()
      category: "Open"
      public: 'off'
      userId: "bayron@beltran.com"
    team2 =
      name: "El niupi"
      country: Faker.random.uk_country()
      city: Faker.random.city_prefix()      
      category: "Open"
      public: 'on'
      userId: "bayron@beltran.com"
    team3 =
      name: "Galatasara"
      country: Faker.random.uk_country()
      city: Faker.random.city_prefix()      
      category: "Women"
      public: 'on'
      userId: "bayron@beltran.com"
    team4 =
      name: "El Cucuta"
      country: Faker.random.uk_country()
      city: Faker.random.city_prefix()      
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

  clean: (callback)->
    redis.DEL Team.key()+'Id', ->
      redis.DEL Team.key(), ->
        callback() if callback



module.exports = TeamFactory