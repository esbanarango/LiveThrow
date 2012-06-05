User = require '../../models/user'
User = require '../../models/Management/team'

routes = (app) ->
  app.namespace '/teams', ->
    # Authentication check
    app.all '/*', (req, res, next) ->
      if not (req.session.currentUser)
        req.flash 'error', 'Please login.'
        res.redirect '/login'
        return
      next()

    app.get '/', (req, res) ->
      res.render "#{__dirname}/views/index",
        title: "Live Throw"

    app.get '/new', (req, res) ->
      res.render "#{__dirname}/views/new",
        title: "Live Throw"

module.exports = routes