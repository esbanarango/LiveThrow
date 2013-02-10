require "../spec_helper"
express = require 'express'
assert  = require 'assert'
request = require 'request'
app     = require '../../server'
RequestHelper = require '../support/request-helper'

describe 'matches', ->

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
        TeamFactory.createSeveral ->
          RequestHelper.login done

      describe "POST /create", ->


