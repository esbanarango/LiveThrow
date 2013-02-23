 [![et](https://github.com/esbanarango/LiveThrow/blob/master/Docs./lg.png?raw=true)](http://livethrow.herokuapp.com/)

[![][2]][1]

  [1]: https://travis-ci.org/esbanarango/LiveThrow
  [2]: https://api.travis-ci.org/esbanarango/LiveThrow.png?branch=master (Code status)

Live Throw is the final project for the _Special Topics in Telematics_ course. The idea behind this project is an open-source web app where you can keep track of statistics, real-time updates/scores and community collaboration, all around Ultimate Frisbee games.

All written in [Node.js](http://nodejs.org/) with the fantastic and beautiful _little language_ [CoffeeScript](http://coffeescript.org/).

### Context

>Ultimate is a sport played with a flying disc. The object of the game is to score points by passing the disc to a player in the opposing end zone, similar to an end zone in American football or rugby. Players may not run with the disc, and may only move one foot (pivot) while holding the disc.

# Description

This is the 0.0.1 version of this project, right now it only has a _quick match_ functionality where you can create your teams, and stream a game; but I hope to grow it up adding more functionality eventually.

##  Requirements
Live Throw uses a Node.js full stack.

```json
{
  "name": "Live-Throw",
  "version": "0.0.1",
  "private": true,
  "dependencies": {
    "express": "~3.0.6",
    "jade": "~0.28.1",
    "coffee-script": "~1.2.0",
    "express-namespace": "0.1.1",
    "connect-assets": "~2.1.8",
    "socket.io": "~0.9.13",
    "underscore": "~1.3.3",
    "stylus": "~0.24.0",
    "redis": "~0.7.3",
    "hiredis": "~0.1.14",
    "connect-redis": "~1.3.0",
    "gravatar": "~1.0.6",
    "connect-flash": "~0.1.0",
    "heroku-redis-client": "~0.3.3",
    "passport": "~0.1.15",
    "passport-facebook": "~0.1.5",
    "yaml-config": "~0.2.1",
    "passport-twitter": "~0.1.4"
  }
}
```

## Install and run it

#### Setup

Make sure you already have [NPM](http://npmjs.org/) and [Redis](http://redis.io/) installed on you machine.

###### Redis
If you have [brew](http://mxcl.github.com/homebrew/) you can simply run:

    $ brew install redis
otherwise, go to http://redis.io/download.

-
====


Clone the repo, `$ git clone git@github.com:esbanarango/LiveThrow.git`, this will create a folder, _LiveThrow_, where you'll find:

    |-- app       -> Express.js app.
    |-- Docs.     -> References documents

Now you need to start the Node.js server.

Go to the app folder `$ cd app` and install all dependencies, run `$ npm install`. All the dependencies are specified on _package.json_.

>Remember to run Redis, you can make sure it's running by executing  `$ redis-cli`.

Then run `$ ./bin/devserver` to start the Node.js server.

## Try it

Having everything ready and running, go to `http://localhost:3000` and enjoy it! :)

## Test

Run tests:

    $ npm test


## Author
This was written by [Esteban Arango Medina](http://twitter.com/esbanarango).
>Special thanks to [@sduquej](https://twitter.com/sduquej) and [@dduqueti](https://twitter.com/dduqueti), for all the documentation.
