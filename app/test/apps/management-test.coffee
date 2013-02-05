require "../spec_helper"
express = require 'express'
assert  = require 'assert'
request = require 'request'
app     = require '../../server'
User    = require '../../models/user'
Team    = require '../../models/Management/team'
RequestHelper = require '../support/request-helper'

describe 'management', ->

  describe 'authenticated', ->
    # Login
    before (done) ->
      RequestHelper.login done

    describe 'GET /teams', ->
      body = null
      before (done) ->
        options =
          uri:"http://localhost:#{app.settings.port}/teams"
        request options, (err, response, _body) ->
          throw new Error(_body) if response.statusCode >= 400
          body = _body
          done()
      it "has title", ->
        assert.hasTag body, '//head/title', 'Live Throw - Teams'

