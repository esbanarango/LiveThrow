#Models
User = require '../../models/user'
Team = require '../../models/Management/team'
Player = require '../../models/Management/player'
Match = require '../../models/LiveScore/match'
Action = require '../../models/LiveScore/action'
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
            scripts: ['matches/matches']

    app.post '/create', (req, res) ->      
      attributes =
        teamId1: req.body.teams[0]
        teamId2: req.body.teams[1]
        scoreTeam1: 0
        scoreTeam2: 0
        description: req.body.description
        date: ""
      match = new Match attributes
      match.save () -> 
        req.flash 'success', 'Match was successfully created.'
        res.redirect "/live/#{match.id}/monitor"            

  #LiveScore
  app.namespace '/live', ->

    app.get '/:id/monitor', (req, res) ->
      Match.getById req.params.id, (err, match) ->
        match.fillUp (err, matchFull)->
          res.render "#{__dirname}/views/live/monitor",
            title: "Live Score"
            csss: ['scoreReport']
            scripts: ['livescore/monitor']
            match: matchFull

    app.post '/action', (req,res) ->
        matchId = req.header('Referrer').split('/')[4]
        attributes =
          team: req.body.team
          golPlayerId: req.body.golPlayerId
          assitencePlayerId: req.body.assitencePlayerId
          minuto: req.body.minuto        
        action = new Action attributes, "Actions#{matchId}"
        action.save () ->
          #Update Score
          Match.getById matchId, (err,match) ->
            if action.team == "1"
              newScore=parseInt(match.scoreTeam1)
              match.scoreTeam1 = ++newScore
            else
              newScore=parseInt(match.scoreTeam2)
              match.scoreTeam2 = ++newScore
            match.update ()->
              res.contentType('json');
              res.send({ response: action });

    app.get '/:id', (req, res) ->
      Match.getById req.params.id, (err, match) ->
        match.fillUp (err, matchFull)->
          console.log(matchFull.team1)
          res.render "#{__dirname}/views/live/show",
            title: "Live Score"
            csss: ['scoreReport']
            match: matchFull

    app.get '/', (req, res) ->
      res.render "#{__dirname}/views/live/show",
        title: "Live Score"            
        csss: ['scoreReport']

module.exports = routes











