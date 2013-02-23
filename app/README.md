[![et](https://github.com/esbanarango/LiveThrow/blob/master/Docs./lg.png?raw=true)](http://livethrow.herokuapp.com/)

### Structure


    ├── apps/                                 # VC (View, Controller/Routes)
    │   ├── authentication/
    │   ├── livescore/
    │   ├── static/
    │   ├── management/
    │   ├── socket-io.coffee
    │   └── helpers.coffee
    ├── models/
    │   ├── LiveScore/
    │   │   ├── action.coffee
    │   │   └── match.coffee
    │   ├── Management/
    │   │   ├── player.coffee
    │   │   └── team.coffee
    │   └── user.coffee
    ├── views/
    │   ├── error.jade
    │   ├── includes/
    │   │   ├── footer.jade
    │   │   └── header.jade
    │   └── layout.jade
    ├── assets/
    │   ├── css/
    │   └── js/
    │       ├── application.coffee
    │       ├── jquery.noty.js
    │       ├── livescore/
    │       │   ├── live.coffee
    │       │   └── monitor.coffee
    │       ├── matches/
    │       │   └── matches.coffee
    │       ├── players/
    │       │   └── players.coffee
    │       └── teams/
    │           └── teams.coffee
    ├── bin/
    │   ├── devserver
    │   └── test
    ├── config/
    │   └── facebook-test.yml
    ├── middleware/
    │   └── upgrade.coffee
    ├── public/
    │   ├── humans.txt
    │   ├── images/
    │   ├── fonts/
    │   ├── javascripts/
    │   │   └── lib/
    │   │       ├── jq.stopwatch.js
    │   │       └── pickdate.js
    │   ├── lib/
    │   │   ├── bootstrap/
    │   │   └── css/
    │   └── stylesheets/
    ├── test/
    │   ├── apps/
    │   ├── factories/
    │   ├── models/
    │   ├── mocha.opts
    │   ├── _helper.js
    │   ├── assert-extra.coffee
    │   ├── spec_helper.coffee
    │   └── support/
    ├── server.js
    └── package.json

Epa! ;)
