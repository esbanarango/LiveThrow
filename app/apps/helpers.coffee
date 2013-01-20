
helpers = (app) ->
  app.dynamicHelpers =
    currentUserId: (req, res) ->
      req.session.currentUser
    currentUserName: (req, res) ->
      req.session.currentUser_name
  app.helpers =
    # Returns the 'expected' state and 'on' if it matches 'actual'.
    #
    # expected: A state such as 'making' or 'inactive'
    # actual:   The state of the object being compared to.
    cssClassForState: (expected, actual) ->
      if actual is expected
        [expected, 'on']
      else
        expected
    cssClassForCurrentURL: (actual, expected) ->
      if actual is expected
        return 'current'
      null

module.exports = helpers