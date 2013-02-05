redis   = require('redis').createClient()
User    = require '../models/user'

before ->
  attributes =
    username: 'bayron'
    email: 'bayron@beltran.com'
    password: '111111'
    gender: 'm'
  user = new User attributes
  user.save()
after ->
  redis.hdel User.key(), 'bayron@beltran.com'