require 'moment'
redis         = require('redis').createClient()
Match         = require '../../models/LiveScore/match'
TeamFactory   = require '../factories/team-factory'
Team          = require '../../models/Management/team'
Faker         = require 'Faker'
_             = require 'underscore'

MatchFactory =

  # Create two teams in the database.
  #
  # callback: () No params.
  createSeveral: (callback) ->
    TeamFactory.createSeveral =>
      Team.allall (err, _teams) =>    
        # Attributes
        match1 =
          teamId1: _teams[0].id
          teamId2: _teams[1].id
          description: Faker.Lorem.sentences()
          dateFormated: '22 March, 2013'
          date: moment().add('days', 1).format('L')
          owner: '1'
        match2 =
          teamId1: _teams[2].id
          teamId2: _teams[1].id
          description: Faker.Lorem.sentences()
          dateFormated: '22 March, 2013'
          date: moment().add('days', 1).format('L')
          owner: '1'
        match3 =
          teamId1: _teams[3].id
          teamId2: _teams[1].id
          description: Faker.Lorem.sentences()
          dateFormated: '22 March, 2013'
          date: moment().add('days', 1).format('L')
          owner: '1'
        match4 =
          teamId1: _teams[0].id
          teamId2: _teams[2].id
          description: Faker.Lorem.sentences()
          dateFormated: '22 March, 2013'
          date: moment().add('days', 1).format('L')
          owner: '1'
        matchAttributes = [match1, match2, match3, match4]
        # Now create them all
        createOne = @createOne
        runSequentially = (item, otherItems...) ->
          createOne item, ->
            if otherItems.length
              runSequentially otherItems...
            else
              callback()
        runSequentially matchAttributes...

  createOne: (attributes, callback) ->
    match = new Match attributes
    match.save (err, match) ->
      callback err, match


  clean: (callback)->
    redis.DEL Match.key()+'Id', ->
      redis.DEL Match.key(), ->
        callback() if callback

module.exports = MatchFactory