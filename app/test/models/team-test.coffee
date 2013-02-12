require '../_helper'
assert        = require 'assert'
request       = require 'request'
Team          = require '../../models/Management/team'
TeamFactory   = require '../factories/team-factory'
Faker         = require 'Faker'
_             = require 'underscore'

attr = null

describe 'Team', ->

  before ->
    attr=
      name: 'Ki-ê'
      category: 'open'
      country: 'Colombia'
      city: 'Medeshing'
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

      describe "non-existing record", ->

        it "returns error", (done) ->
          Team.getById -1, (err, json) ->
            assert.equal err.message, "Team '-1' could not be found."
            done()

      describe "all", ->
        teams = null
        before (done) ->
          TeamFactory.clean ->
            TeamFactory.createSeveral ->
              Team.allall (err, _teams) ->
                teams = _teams
                done()
        it "retrieves all teams", ->
          assert.equal teams.length, 4

    describe "destroy", ->
      team = null
      before (done) ->
        attrs=
          name: 'Ki-ê'
          category: 'open'
          country: 'Colombia'
          city: 'Medeshing'
          userId: '1'
        TeamFactory.createOne attrs, (err, _team)->
          team= _team
          done()
      it "is removed from the database", (done) ->
        # Fetch and destroy. Expect an error on next fetch.
        Team.getById team.id, (err, team) ->
          team.destroy (err) ->
            Team.getById team.id, (err) ->
              assert.equal err.message, "Team '#{team.id}' could not be found."
              done()


  after ->
    TeamFactory.clean()
