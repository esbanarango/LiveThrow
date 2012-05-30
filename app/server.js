require('coffee-script');

/**
 * Module dependencies.
 */

var express = require('express'),
    stylus = require('stylus'); 

require('express-namespace')

var app = module.exports = express.createServer();

require('./apps/socket-io')(app)

// Configuration

app.configure(function(){
  app.use(stylus.middleware({
    src: __dirname + "/views",
    // It will add /stylesheets to this path.
    dest: __dirname + "/public"
  }));
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.set('port', 3000);
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(require('connect-assets')());
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('test', function () {
  app.set('port', 3001);
});

app.configure('production', function(){
  app.use(express.errorHandler());
});

// Global helpers
require('./apps/helpers')(app);

// Routes
// Routes
require('./apps/static/routes')(app);

app.listen(app.settings.port, function(){
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
