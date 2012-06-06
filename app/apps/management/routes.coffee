#Models
User = require '../../models/user'
Team = require '../../models/Management/team'
Player = require '../../models/Management/player'

routes = (app) ->

  #Teams
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
        scripts: ['teams/teams']

    app.post '/create', (req, res) ->
      attributes =
        name: req.body.name
        category: req.body.category
        public: req.body.public || 'off'
        userId: req.session.currentUser
      team = new Team attributes
      team.save () ->
        res.contentType('json');
        res.send({ response: JSON.stringify(team), message:"Team was successfully created." });

    app.get '/:id', (req, res) ->
      teamId = req.params.id
      Team.getById req.params.id, (err, team) =>
        if team is null
          console.log(err)
          res.render 'error',
            status: 403,
            message: "Incorrect Pie state: #{req.body.state} is not a recognized state."
            title: "Incorrect Pie state"
            stylesheet: 'admin'        
        else
          Player.all "Players#{teamId}", (err, players)->
            res.render "#{__dirname}/views/teams/show",
              title: "Team #{team.name}"
              scripts: ['teams/teams','players/players']
              team: team
              players: players

  #Teams
  app.namespace '/players', ->
    app.post '/create', (req, res) ->
      refParts = req.header('Referrer').split('/')
      teamId = refParts[4].split('?')[0]
      attributes =
        name: req.body.name
        last_name: req.body.last_name || ""
        nickname: "\""+req.body.nickname+"\"" || ""
        position: req.body.position || ""
      player = new Player attributes, "Players#{teamId}"
      player.save () ->        
        res.contentType('json');
        res.send({ response: player, message:"Player was successfully added." });

module.exports = routes