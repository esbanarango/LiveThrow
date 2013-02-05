Team    = require '../../models/Management/team'

TeamFactory =
  # Create two teams in the database.
  #
  # callback: () No params.
  createSeveral: (callback) ->
    # Now create them all
    createOne = @createOne
    runSequentially = (item, otherItems...) ->
      createOne item, ->
        if otherItems.length
          runSequentially otherItems...
        else
          callback()
    runSequentially teamAttributes...

  createOne: (attributes, callback) ->
    team = new Team attributes
    team.save (err, team) ->
      callback err, team


module.exports = TeamFactory