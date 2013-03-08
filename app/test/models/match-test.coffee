require '../_helper'
assert        = require 'assert'
request       = require 'request'
Match         = require '../../models/LiveScore/match'
Team          = require '../../models/Management/team'
TeamFactory   = require '../factories/team-factory'
MatchFactory  = require '../factories/match-factory'
Faker         = require 'Faker'
_             = require 'underscore'

attrs = null

describe 'Match', ->

  before (done)->
    TeamFactory.createSeveral ->
      Team.allall (err, _teams) ->
        attrs =
          teamId1: _teams[0].id
          teamId2: _teams[1].id
          description: Faker.Lorem.sentences()
          dateFormated: '22 March, 2013'
          date: '22/03/2013'
          owner: '1'
        done()    

  describe "create", ->
    match = null
    before (done) ->
      match = new Match attrs
      done()
    it "sets time", ->
      assert.equal match.time.hh, 0
      assert.equal match.time.mm, 0
      assert.equal match.time.ss, 0
    it "is public by default", ->
      assert.equal match.public, 'on'

  describe "validation", ->

    it "requires two teams", ->
      attrs.teamId2 = null
      user = new Match attrs
      user.save (err, json) ->
        assert.equal err.message, 'Two teams are required.'


  after ->
    MatchFactory.clean()
