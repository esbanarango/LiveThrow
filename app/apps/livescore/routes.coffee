#Models
User = require '../../models/user'
Team = require '../../models/Management/team'
Player = require '../../models/Management/player'
_              = require 'underscore'

routes = (app) ->

  #Matches
  app.namespace '/matches', ->

    # Authentication check
    app.all '/*', (req, res, next) ->
      if not (req.session.currentUser)
        req.flash 'error', 'Please login.'
        res.redirect '/login'
        return
      next()
      
    app.get '/new', (req, res) ->
      Team.getByuserId req.session.currentUser, (err, _myTeams) ->
        Team.all (err,_allTeams)->
          myTeams = _myTeams.reverse()
          allTeams = _allTeams.reverse()
          res.render "#{__dirname}/views/matches/new",
            title: "New Match"            
            myTeams: myTeams
            allTeams: allTeams

  #LiveScore
  app.namespace '/live', ->

    app.get '/', (req, res) ->
      res.render "#{__dirname}/views/live/show",
        title: "Live Score"            
        csss: ['scoreReport']

    app.get '/', (req, res) ->
      res.render "#{__dirname}/views/live/show",
        title: "Live Score"            
        csss: ['scoreReport']

module.exports = routes











