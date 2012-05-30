
routes = (app) ->
  app.get '/login', (req, res) ->
    res.render "#{__dirname}/views/login",
      title: 'Login'
      stylesheet: 'login'

  app.post '/sessions', (req, res) ->
    if ('admin' is req.body.user) and ('111111' is req.body.password)
      req.session.currentUser = req.body.user
      req.flash 'info', "You are now logged in as #{req.session.currentUser}."
      res.redirect '/admin/menu/stage'
      return
    req.flash 'error', 'Those credentials were incorrect. Please login again.'
    res.redirect '/login'

  app.del '/sessions', (req, res) ->
    req.session.regenerate (err) ->
      req.flash 'info', 'You have been logged out.'
      res.redirect '/login'

module.exports = routes