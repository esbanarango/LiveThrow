require "../spec_helper"
express = require 'express'
assert  = require 'assert'
request = require 'request'
app     = require '../../server'
TeamFactory   = require '../factories/team-factory'
MatchFactory   = require '../factories/match-factory'
RequestHelper = require '../support/request-helper'

describe 'matches', ->

  describe 'matches display', ->

    before (done) ->
      MatchFactory.createSeveral done

    describe 'GET /', ->
      [response, body] = [null, null]
      before (done) ->
        options =
          uri:"http://localhost:#{app.settings.port}/live"
        request.get options, (err, _response, _body) ->
          [response, body] = [_response, _body]
          done()
      it "has title", ->
        assert.hasTag body, '//head/title', 'Live Throw - Live Games'

  describe 'matches creation', ->

    describe 'unauthenticated', ->
      # Logout
      before (done) ->
        RequestHelper.logout done
      
      describe 'POST /create', ->
        [response, body] = [null, null]
        before (done) ->
          options =
            uri:"http://localhost:#{app.settings.port}/matches/create"
            form:
              teams: [1,2]
          request.post options, (err, _response, _body) ->
            [response, body] = [_response, _body]
            done()      
        it "redirects to /login", ->
          assert.match body, "Redirecting to /login"

# //*[@id="container"]/div/div/div/table/tbody/tr/td[2]

      describe 'GET /new', ->
        [response, body] = [null, null]
        before (done) ->
          options =
            uri:"http://localhost:#{app.settings.port}/matches/new"
          request options, (err, _response, _body) ->
            [response, body] = [_response, _body]
            done()      
        it "redirects to /login", ->
          assert.equal response.request.path, "/login"          

    describe 'authenticated', ->
      # Login
      before (done) ->
        MatchFactory.clean ->
          TeamFactory.createSeveral ->
            RequestHelper.login done

      describe "POST /create", ->

        describe "one team selected", ->
          [response, body] = [null, null]
          before (done) ->
            options =
              uri:"http://localhost:#{app.settings.port}/matches/create"
              form:
                teams: [1]
            request.post options, (err, _response, _body) ->
              [response, body] = [_response, _body]
              done()
          it "redirects to /matches/new", ->
            assert.match body, "Redirecting to /matches/new"

        describe "two team selected", ->
          [response, body] = [null, null]
          before (done) ->
            options =
              uri:"http://localhost:#{app.settings.port}/matches/create"
              form:
                teams: [1,2]
            request.post options, (err, _response, _body) ->
              [response, body] = [_response, _body]
              done()
          it "redirects to /live/1/monitor", ->
            assert.match body, "Redirecting to /live/1/monitor"

      after ->
        TeamFactory.clean()
        MatchFactory.clean()


