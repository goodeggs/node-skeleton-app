# modules we want available globally.
GLOBAL._ = require 'underscore'
GLOBAL.async = require 'async'
GLOBAL.clock = require 'node-clock'
GLOBAL.logger = require 'node-airbrake-logger'
GLOBAL.settings = require '../config/settings'

_.mixin
  only: (obj, keys...) ->
    result = {}
    result[key] = obj[key] for key in keys when obj[key]?
    result
