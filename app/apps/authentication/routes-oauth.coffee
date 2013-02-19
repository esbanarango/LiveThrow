User = require '../../models/user'

routes = (app, passport) ->
  # OAuth
  app.namespace '/auth', ->

    #Facebook
    app.get "/facebook", passport.authenticate("facebook",
      scope: ["read_stream", "publish_actions"]
    )

    app.get "/facebook/callback", passport.authenticate("facebook",
      failureRedirect: "/login"
    ), (req, res) ->
      console.log 'User from FB.'
      console.log req.user
      res.redirect "/login"



module.exports = routes