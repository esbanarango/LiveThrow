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
      Team.getByuserId req.session.currentUser, (err, _teams) ->
        teams = _teams.reverse()
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
        req.flash 'success', 'Team was successfully created.'
        res.redirect '/teams'

    app.get '/:id', (req, res) ->
      teamId = req.params.id
      Team.getById req.params.id, (err, team) =>
        if team is null
          console.log(err)
          res.render 'error',
            status: 403,
            message: "Team does not exist."
            title: "Incorrect Team id"
            stylesheet: 'admin'        
        else
          Player.all "Players#{teamId}", (err, players)->
            res.render "#{__dirname}/views/teams/show",
              title: "Team #{team.name}"
              scripts: ['teams/teams','players/players']
              team: team
              players: players

  #Players
  app.namespace '/players', ->

    # Authentication check
    app.all '/*', (req, res, next) ->
      if not (req.session.currentUser)
        req.flash 'error', 'Please login.'
        res.redirect '/login'
        return
      next()

    app.post '/create', (req, res) ->
      refParts = req.header('Referrer').split('/')
      teamId = refParts[4].split('?')[0]
      attributes =
        name: req.body.name
        last_name: req.body.last_name || ""
        nickname: if req.body.nickname then "\""+req.body.nickname+"\"" else ""
        position: req.body.position || ""
        number: req.body.number || ""
        gender: req.body.gender || ""        
      player = new Player attributes, "Players#{teamId}"
      player.save () ->        
        res.contentType('json');
        res.send({ response: player, message:"Player was successfully added." });

    app.del '/', (req, res) ->
      refParts = req.header('Referrer').split('/')
      teamId = refParts[4].split('?')[0]
      id = req.body.id
      Player.destroy "Players#{teamId}", id, (err) ->
        response = "Destroyed"
        response = err if err
        res.contentType('json')
        res.send({ response: response})

  #Matches
  app.namespace '/matches', ->

    # Authentication check
    app.all '/*', (req, res, next) ->
      if not (req.session.currentUser)
        req.flash 'error', 'Please login.'
        res.redirect '/login'
        return
      next()
      
    app.get '/', (req, res) ->
      Team.getByuserId req.session.currentUser, (err, _teams) ->
        teams = _teams.reverse()
        res.render "#{__dirname}/views/teams/index",
          title: "Live Throw"
          teams: teams



module.exports = routes











