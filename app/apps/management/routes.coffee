User = require '../../models/user'
Team = require '../../models/Management/team'

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
      Team.getByuserId req.session.currentUser, (err, teams) ->
        res.render "#{__dirname}/views/teams/index",
          title: "Live Throw"
          teams: teams

    app.get '/new', (req, res) ->
      res.render "#{__dirname}/views/teams/new",
        title: "Live Throw"
        scripts: ['teams']

    app.post '/create', (req, res) ->
      attributes =
        name: req.body.name
        category: req.body.category
        userId: req.session.currentUser
      team = new Team attributes
      team.save () ->
        res.contentType('json');
        res.send({ response: JSON.stringify(team) });

    app.get '/:id', (req, res) ->
      Team.getById req.params.id, (err, team) ->
        if team is null
          console.log(err)
          res.render 'error',
            status: 403,
            message: "Incorrect Pie state: #{req.body.state} is not a recognized state."
            title: "Incorrect Pie state"
            stylesheet: 'admin'        
        else
          res.render "#{__dirname}/views/teams/show",
            title: "Team #{team.name}"
            scripts: ['teams']
            team: team


module.exports = routes