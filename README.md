 ![et](https://github.com/esbanarango/LiveThrow/blob/master/Docs./lg.png?raw=true)

Live Throw is the final project for the _Special Topics in Telematics_ course; the idea behind this project is a open-source web app where you can keep track of statistics, real-time updates/score and community collaboration, all around Ultimate Frisbee games.

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
    "connect-flash": "~0.1.0"
  }
}
```

## Install and run it

To run it you just need to follow the steps below.

First clone the repo into your machine, `$ git clone git@github.com:esbanarango/LiveThrow.git`, this will create a folder, _LiveThrow_, where you'll find:

    |-- app       -> Express.js app.
    |-- Docs.     -> References documents

Now you need to start the Node.js server.
>Make sure you already have installed NPM on you machine ([NPM](http://npmjs.org/)), and [Redis](http://redis.io/download).

`$ cd app` 

First you need install all dependencies on your local directory, run `$ npm install`. All the dependencies are specified on _package.json_.

* Remember to run Redis, you can make sure it's running by executing  `$ redis-cli`.

Then run `$ ./bin/devserver` to start the Node.js server.

## Try it

Having everything ready and running, go to `http://localhost:3000` and enjoy it! :)

## Author
This was written by [Esteban Arango Medina](http://twitter.com/esbanarango).
>Special thanks to [@sduquej](https://twitter.com/sduquej) and [@dduqueti](https://twitter.com/dduqueti), for all the documentation.