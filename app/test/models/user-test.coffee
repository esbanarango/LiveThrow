require '../_helper'
assert        = require 'assert'
request       = require 'request'
User          = require '../../models/user'
UserFactory   = require '../factories/user-factory'
Faker         = require 'Faker'
_             = require 'underscore'

attr = null

describe 'User', ->

  before ->
    attr=
      username: 'Mariano'
      email: 'mariano@livethrow.com'
      password: 'dghfte'
      gender: 'm'

  describe "create", ->
    user = null
    before (done) ->
      user = new User attr
      done()
    it "sets name", ->
      assert.equal user.username, 'Mariano'
    it "sets email", ->
      assert.equal user.email, 'mariano@livethrow.com'  
    it "sets gender", ->
      assert.equal user.gender, 'm'

  describe "persistence", ->

    it "builds a key", ->
      assert.equal User.key(), 'Users:test'

    describe "save", ->
      user = null
      before (done) ->
        attrs=
          username: Faker.Internet.userName()
          email: Faker.Internet.email()
          password: '123456'
          gender: 'f'
        user = new User attrs
        user.save ->
          done()
      it "returns a User object", ->
        assert.instanceOf user, User

    describe "get", ->

      describe "existing record", ->
        user = null
        before (done) ->
          attrs=
            username: 'tyler'
            email: 'tyler_durden@latinchat.com'
            password: '123456'
            gender: 'm'          
          # Save a user and retrieve it again.
          UserFactory.createOne attrs, ->
            User.getByEmail 'tyler_durden@latinchat.com', (err, _user) ->
              user = _user
              done()
        it "returns a User object", ->
          assert.instanceOf user, User
        it "fetches the correct object", ->
          assert.equal user.email, 'tyler_durden@latinchat.com'
          assert.equal user.username, 'tyler'
          assert.equal user.gender, 'm'

      describe "non-existing record", ->

        it "returns error", (done) ->
          User.getByEmail 'amparito@yahoo.com', (err, json) ->
            assert.equal err.message, "User 'amparito@yahoo.com' could not be found."
            done()

      describe "all", ->
        users = null
        before (done) ->
          UserFactory.clean ->
            UserFactory.createSeveral 4, ->
              User.all (err, _users) ->
                users = _users
                done()
        it "retrieves all users", ->
          assert.equal users.length, 4

    describe "destroy", ->
      before (done) ->
        attrs=
          username: Faker.Internet.userName()
          email: 'marla_singer@latinchat.com'
          password: '123456'
          gender: 'f'
        UserFactory.createOne attrs, done
      it "is removed from the database", (done) ->
        # Fetch and destroy. Expect an error on next fetch.
        User.getByEmail 'marla_singer@latinchat.com', (err, user) ->
          user.destroy (err) ->
            User.getByEmail 'marla_singer@latinchat.com', (err) ->
              assert.equal err.message, "User 'marla_singer@latinchat.com' could not be found."
              done()

  describe "validation", ->

    describe "emial uniqueness", ->
      user = null
      attrs= null
      before (done) ->
        attrs=
          username: 'eduardo'
          email: 'edward_norton@latinchat.com'
          password: '123456'
          gender: 'm'          
        UserFactory.createOne attrs, done
      it "returns error", (done)->
        user = new User attrs
        user.save (err, json) ->
          assert.equal err.message, 'Email is already taken.'
          done()

    it "requires a username", ->
      user = new User {email: 'emilio@ar.com', password: '123456'}
      user.save (err, json) ->
        assert.equal err.message, 'Username is required.'

  after ->
    UserFactory.clean()
