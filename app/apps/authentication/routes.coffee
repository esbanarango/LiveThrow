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
        req.flash 'success', "You are now logged in as #{req.session.currentUser_name}."
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
    app.post '/create', (req, res) ->
      attributes =
        username: req.body.username
        email: req.body.email
        password: req.body.password
        gender: req.body.gender
      user = new User attributes
      user.save () ->
        req.session.currentUser = user.email
        req.session.currentUser_name = user.username
        req.flash 'success', "You are now logged in as #{req.session.currentUser_name}."        
        res.redirect '/'

    app.get '/edit', (req, res) ->
      User.getByEmail req.session.currentUser, (err,user) ->
            res.render "#{__dirname}/views/users/edit",
              title: 'Edit'
              user:user

    app.put '/:email', (req, res) ->
      userEmail = req.params.email
      attrs =
        username: req.body.username
        password: req.body.password
        gender: req.body.gender
      User.getByEmail req.session.currentUser, (err,user) ->
        user.username = attrs.username
        user.passwoord = attrs.password if attrs.password
        user.gender = attrs.gender
        user.save ->
          req.session.currentUser_name = user.username
          req.flash 'success', "User was successfully updated."        
          res.redirect '/'



module.exports = routes