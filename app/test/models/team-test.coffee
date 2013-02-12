require '../_helper'
assert        = require 'assert'
request       = require 'request'
Team          = require '../../models/Management/team'
TeamFactory   = require '../factories/team-factory'
_             = require 'underscore'

attr = null

describe 'Team', ->
  before ->
    attr=
      name: 'Ki-ê'
      category: 'open'
      userId: '1'
  describe "create", ->
    team = null
    before (done) ->
      team = new Team attr
      done()
    it "sets name", ->
      assert.equal team.name, 'Ki-ê'
    it "sets category", ->
      assert.equal team.category, 'open'  
    it "is public by default", ->
      assert.equal team.public, 'on'

  describe "persistence", ->
    it "builds a key", ->
      assert.equal Team.key(), 'Teams:test'
    describe "save", ->
      team = null
      before (done) ->
        team = new Team attr   
        team.save ->
          done()
      it "returns a Team object", ->
        assert.instanceOf team, Team

    describe "get", ->
      describe "existing record", ->
        team = null
        before (done) ->
          # Save a team and retrieve it again.
          TeamFactory.createOne attr, (err, _team) ->
            Team.getById _team.id, (err, _team) ->
              team = _team
              done()
        it "returns a Team object", ->
          assert.instanceOf team, Team
        it "fetches the correct object", ->
          assert.equal team.name, 'Ki-ê'

  after ->
    TeamFactory.clean()
