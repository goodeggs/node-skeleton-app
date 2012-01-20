process.env.TZ = 'UTC'

require './globals'
express = require 'express'
fibrous = require './fibrous'

module.exports = app = express.createServer()
_.defaults(app.settings, settings) # Copy config/settings into the app.settings
env = settings.env

app.configure 'development', 'production', -> app.use express.logger() # don't do logging in tests
app.configure 'test', 'production', -> this.enable('view cache') # By default, the view cache is only enabled in production

app.configure ->
  app.set 'views', './app/views'
  app.set 'view engine', 'coffee'
  # for coffeekup, install template helpers
  app.set 'view options', hardcode: require('./views/helpers.coffee')
  app.register '.coffee', require('coffeekup').adapters.express
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use fibrous.middleware # create a fiber for every request route handler
  app.use app.router
  app.use express.static('./public')
  app.use require('connect-assets')(src: 'client', detectChanges: (env == 'development')) # We don't want the perf hit of detecting changes in prod OR test
  logger.configure airbrakeKey: settings.airbrakeKey, remote: (env == 'production')
  logger.handleUncaughtExceptions()
  app.use logger.middleware
  app.use express.errorHandler dumpExceptions: true, showStack: (env != 'production')

app.get '/', (req, res) ->
  res.render 'index'

