User = require '../../models/user'

routes = (app, passport) ->
  # OAuth
  app.namespace '/auth', ->

    #Facebook
    app.get "/facebook", passport.authenticate("facebook",
      scope: ["read_stream", "publish_actions", "email"]
    )

    app.get "/facebook/callback", passport.authenticate("facebook",
      failureRedirect: "/login"
    ), (req, res) ->
      User.getByEmail req.user.emails[0].value, (err, user) =>
        if user
          req.session.currentUser = user.email
          req.session.currentUser_name = user.username
          req.flash 'success', "You are now logged in as #{req.session.currentUser_name}."
          res.redirect '/'
          return
        else
          User.createFromFacebook req.user, (user) =>
            user.save (err, user) ->
              unless err
                req.session.currentUser = user.email
                req.session.currentUser_name = user.username
                req.flash 'success', "You are now logged in as #{req.session.currentUser_name}."        
                res.redirect '/'
              else
                req.flash 'error', err.message
                res.redirect '/signup'

    #Twitter
    app.get "/twitter", passport.authenticate("twitter",
      scope: 'email'
    )

    app.get "/twitter/callback", passport.authenticate("twitter",
      failureRedirect: "/login"
    ), (req, res) ->
      console.log req.user
      req.flash 'info', "Twitter authentication hasn't been finished yet." 
      res.redirect '/signup'

module.exports = routes