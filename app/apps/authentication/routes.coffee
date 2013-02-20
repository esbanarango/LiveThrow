User = require '../../models/user'

routes = (app) ->
  app.get '/login', (req, res) ->
    user= new User {}
    res.render "#{__dirname}/views/login",
      title: 'Login'
      csss: ['zocial']

  app.post '/sessions', (req, res) ->
    User.getByEmail req.body.email, (err, user) =>
      if (user and (user.password is req.body.password) and (user.signup_from isnt 'facebook'))
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
      attrs =
        username: req.body.username
        email: req.body.email
        password: req.body.password
        gender: req.body.gender
        signup_from: 'email'
      user = new User attrs
      user.save (err, user) ->
        unless err
          req.session.currentUser = user.email
          req.session.currentUser_name = user.username
          req.flash 'success', "You are now logged in as #{req.session.currentUser_name}."        
          res.redirect '/'
        else
          req.flash 'error', err.message
          res.redirect '/signup'

    app.get '/edit', (req, res) ->
      User.getByEmail req.session.currentUser, (err,user) ->
        res.render "#{__dirname}/views/users/edit",
          title: 'Edit'
          user:user

    app.put '/me', (req, res) ->
      User.getByEmail req.session.currentUser, (err,user) ->
        user.username = req.body.username
        user.password = req.body.password if req.body.password
        user.gender = req.body.gender
        user.first_name = req.body.first_name
        user.last_name = req.body.last_name
        user.update (err,user) ->
          unless err
            req.session.currentUser_name = user.username
            req.flash 'success', "User was successfully updated."        
            res.redirect '/'
          else
            req.flash 'error', err.message
            res.redirect '/user/edit'          



module.exports = routes