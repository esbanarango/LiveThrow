redis   = require('redis').createClient()
User    = require '../../models/user'
Faker   = require('Faker')
_       = require 'underscore'

UserFactory =

  createSeveral: (times=1, callback) ->
    # Now create them all
    createOne = @createOne
    runSequentially = ->
      attrs=
        username: Faker.Internet.userName()
        email: Faker.Internet.email()
        password: '123456'
        gender: if  times%2 then 'f' else 'm'
      createOne attrs, ->
        if --times
          runSequentially()
        else
          callback()
    runSequentially()

  createOne: (attributes, callback) ->
    user = new User attributes
    user.save (err, user) ->
      callback err, user

  clean: (callback)->
    redis.DEL User.key(), ->
      callback() if callback



module.exports = UserFactory