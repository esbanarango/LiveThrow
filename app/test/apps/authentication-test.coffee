require "../spec_helper"
express = require 'express'
assert  = require 'assert'
request = require 'request'
app     = require '../../server'
RequestHelper = require '../support/request-helper'

describe 'authentication', ->

  describe 'GET /login', ->
    body = null
    before (done) ->
      request {uri:"http://localhost:#{app.settings.port}/login"}, (err, response, _body) ->
        body = _body
        done()
    it "has title", ->
      assert.hasTag body, '//head/title', 'Live Throw - Login'
    it "has email field", ->
      assert.hasTag body, '//input[@name="email"]', ''
    it "has password field", ->
      assert.hasTag body, '//input[@name="password"]', ''

  describe "POST /sessions", ->
    describe "incorrect credentials", ->
      [body, response] = [null, null]
      before (done) ->
        options =
          uri:"http://localhost:#{app.settings.port}/sessions"
          form:
            email: 'incorrect user'
            password: 'incorrect password'
          followAllRedirects: true
        request.post options, (err, _response, _body) ->
          [body, response] = [_body, _response]
          done()
      it "shows 'Those credentials were incorrect. Please login again.'", ->
        errorText = 'Those credentials were incorrect. Please login again.'
        assert.hasTag body, "//div[2]/div[@class='alert alert-error']/text()", errorText

    describe "correct credentials", ->
      [body, response] = [null, null]
      before (done) ->
        options =
          uri:"http://localhost:#{app.settings.port}/sessions"
          form:
            email: 'bayron@beltran.com'
            password: '111111'
          followAllRedirects: true
        request.post options, (err, _response, _body) ->
          [body, response] = [_body, _response]
          done()
      it "shows a welcome flash message", ->
        rightText = 'You are now logged in as bayron.'
        assert.hasTag body, "//div[2]/div[@class='alert alert-success']/text()", rightText

  describe "DELETE /sessions", ->
    [body, response] = [null, null]
    before (done) ->
      options =
        uri:"http://localhost:#{app.settings.port}/sessions"
        followAllRedirects: true
      request.del options, (err, _response, _body) ->
        [body, response] = [_body, _response]
        done()
    it "shows 'You have been logged out.'", ->
      errorText = 'You have been logged out.'
      assert.hasTag body, "//div[2]/div[@class='alert alert-info']/text()", errorText

  describe 'GET /signup', ->
    body = null
    before (done) ->
      request {uri:"http://localhost:#{app.settings.port}/signup"}, (err, response, _body) ->
        body = _body
        done()
    it "has title", ->
      assert.hasTag body, '//head/title', 'Live Throw - Sign up'
    it "has email field", ->
      assert.hasTag body, '//input[@name="email"]', ''
    it "has password field", ->
      assert.hasTag body, '//input[@name="password"]', ''
    it "has password confirmation field", ->
      assert.hasTag body, '//input[@name="password_confirmation"]', ''      
      

  describe "/user", ->

    describe "POST /create", ->
      describe "with an email that already exists", ->
        [body, response] = [null, null]
        before (done) ->
          options =
            uri:"http://localhost:#{app.settings.port}/user/create"
            form:
              username: 'albarito'
              email: 'bayron@beltran.com'
              password: '111111'
              password_confirmation: '111111'
            followAllRedirects: true
          request.post options, (err, _response, _body) ->
            [body, response] = [_body, _response]
            done()        
        it "shows 'Email is already taken.'", ->
          errorText = 'Email is already taken.'
          assert.hasTag body, "//div[2]/div[@class='alert alert-error']/text()", errorText


