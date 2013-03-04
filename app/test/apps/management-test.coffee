require "../spec_helper"
express       = require 'express'
assert        = require 'assert'
request       = require 'request'
app           = require '../../server'
User          = require '../../models/user'
Team          = require '../../models/Management/team'
TeamFactory   = require '../factories/team-factory'
RequestHelper = require '../support/request-helper'

describe 'management', ->

  describe 'unauthenticated', ->
    # Logout
    before (done) ->
      RequestHelper.logout done
    
    describe 'GET /teams', ->
      body = null
      before (done) ->
        options =
          uri:"http://localhost:#{app.settings.port}/teams"
        request options, (err, response, _body) ->
          throw new Error(_body) if response.statusCode >= 400
          body = _body
          done()      
      it "shows flash message", ->
        errorText = 'Please login.'
        assert.hasTag body, "//div[2]/div[@class='alert alert-error']/text()", errorText

  describe 'authenticated', ->
    # Login
    before (done) ->
      TeamFactory.createSeveral ->
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
      it "displays a team", ->
        xpath = "//table[@id='teams']/tbody/tr/td[2]"
        assert.hasTag body, xpath, 'Galatasara'
      it "doesn't display a team which is not mine", ->
        xpath = "//table[@id='teams']/tbody"
        assert.notMatch body, 'El Cucuta'  

    after ->
      TeamFactory.clean()


