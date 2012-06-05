User = require '../../models/user'

routes = (app) ->
  app.get '/login', (req, res) ->
    user= new User {}
    res.render "#{__dirname}/views/login",
      title: 'Login'

  app.post '/sessions', (req, res) ->
    User.getByEmail req.body.email, (err, user) =>
      if (user and user.password is req.body.password)
        req.session.currentUser = user.email
        req.session.currentUser_name = user.username
        req.flash 'success', "You are now logged in as #{req.session.currentUser}."
        res.redirect '/'
        return
      req.flash 'error', 'Those credentials were incorrect. Please login again.'
      res.redirect '/login'

  app.del '/sessions', (req, res) ->
    req.session.regenerate (err) ->
      req.flash 'info', 'You have been logged out.'
      res.redirect '/login'

  app.get '/signup', (req, res) ->
    res.render "#{__dirname}/views/signup",
      title: 'Sign up'

  app.namespace '/user', ->
    app.post '/new', (req, res) ->
      attributes =
        username: req.body.username
        email: req.body.email
        password: req.body.password
        gender: req.body.gender
      user = new User attributes
      user.save () ->
        req.flash 'success', "¡Welcome!"
        res.redirect '/'

module.exports = routes