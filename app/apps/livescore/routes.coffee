#Models
User    = require '../../models/user'
Team    = require '../../models/Management/team'
Player  = require '../../models/Management/player'
Match   = require '../../models/LiveScore/match'
Action  = require '../../models/LiveScore/action'
_       = require 'underscore'

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
        Team.all (err,_allTeams) ->
          myTeams = _myTeams
          allString = _.collect _allTeams, (t) -> JSON.stringify t
          myString = _.collect _myTeams, (t) -> JSON.stringify t
          allTeams =  _.collect (_.difference allString,myString),(s)->JSON.parse(s)
          res.render "#{__dirname}/views/matches/new",
            title: "New Match"            
            myTeams: myTeams
            allTeams: allTeams
            scripts: ['matches/matches']

    app.post '/create', (req, res) -> 
      if (req.body.teams is undefined) or (req.body.teams.length < 2)
        req.flash 'error', 'Please select 2 teams.'
        res.redirect '/matches/new'
        return             
      attributes =
        teamId1: req.body.teams[0]
        teamId2: req.body.teams[1]
        scoreTeam1: 0
        scoreTeam2: 0
        description: req.body.description
        date: ""
        owner: req.session.currentUser
      match = new Match attributes
      match.save () -> 
        req.flash 'success', 'Match was successfully created.'
        res.redirect "/live/#{match.id}/monitor"            

  #LiveScore
  app.namespace '/live', ->

    # Authentication check
    app.all '/:id/*', (req, res, next) ->
      if not (req.session.currentUser)
        req.flash 'error', 'Please login.'
        res.redirect '/login'
        return
      next()

    app.get '/:id/monitor', (req, res) ->
      Match.getById req.params.id, (err, match) ->
        if match.owner isnt req.session.currentUser
          res.redirect "/live/#{req.params.id}"
          return
        match.fillUp (err, matchFull)->
          res.render "#{__dirname}/views/live/monitor",
            title: "Live Score / Transmitting"
            csss: ['scoreReport','stopwatch']
            scripts: ['livescore/monitor','livescore/live','stopwatch']
            match: matchFull

    app.post '/action', (req,res) ->
        matchId = req.header('Referrer').split('/')[4]
        attributes =
          team: req.body.team
          golPlayerId: req.body.golPlayerId
          assitencePlayerId: req.body.assitencePlayerId
          minuto: req.body.minuto        
        action = new Action attributes, matchId
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
              if socketIO = app.settings.socketIO
                socketIO.sockets.emit "match:#{matchId}", action   
              res.contentType('json');
              res.send({ response: action });

    app.get '/:id', (req, res) ->
      Match.getById req.params.id, (err, match) ->
        if match is undefined
          console.log(err)
          res.render 'error',
            status: 403,
            message: "Match does not exist."
            title: "Incorrect Team id"
            stylesheet: 'admin'        
        else
          match.fillUp (err, matchFull)->
            res.render "#{__dirname}/views/live/show",
              title: "Live Score"
              csss: ['scoreReport','stopwatch']
              scripts: ['livescore/live', 'livescore/stopwatch']
              match: matchFull

    app.get '/', (req, res) ->
      Match.all (err, _matches) ->
        Team.allall (err, _teams) ->
          res.render "#{__dirname}/views/live/index",
            title: "Live Games"
            matches: _matches
            teams: _teams        

module.exports = routes











