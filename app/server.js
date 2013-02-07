require('coffee-script');

/**
 * Module dependencies.
 */

var express     = require('express')
  , stylus      = require('stylus')
  , RedisStore  = require('connect-redis')(express)
  , http        = require('http')
  , path        = require('path');

require('express-namespace');

var app = module.exports = express();
var server = http.createServer(app);

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
  app.use(express.cookieParser());
  app.use(express.session({
    secret: "KioxIqpvdyfMXOHjVkUQmGLwEAtB0SZ9cTuNgaWFJYsbzerCDn",
    store: new RedisStore
  }));
  app.use(require('connect-flash')());
  app.use(require('connect-assets')());
  app.use(app.router);
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
  process.env.NODE_ENV = 'development';
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('test', function () {
  app.set('port', 3001);
});

app.configure('production', function(){
  process.env.NODE_ENV = 'production';
  app.use(express.errorHandler());
});

// Global helpers
require('./apps/helpers')(app);

// Routes
require('./middleware/upgrade')(app);
require('./apps/static/routes')(app);
require('./apps/authentication/routes')(app);
require('./apps/management/routes')(app);
require('./apps/livescore/routes')(app);

server.listen(app.settings.port, function(){
  console.log("Express server listening on port %d in %s mode", server.address().port, app.settings.env);
});

// Express 3.0 returns the server after the call to `listen`.
require('./apps/socket-io')(server, app)
