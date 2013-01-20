routes = (app) ->
  app.all '*', (req, res, next) ->
    app.locals
      helpers: app.helpers
      flash: req.flash()
    for method of app.dynamicHelpers
      do (method, req, res) ->
        app.locals[method] = () ->
          app.dynamicHelpers[method] req, res
    next()

module.exports = routes
