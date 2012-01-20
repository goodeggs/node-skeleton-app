# modules we want available globally.
GLOBAL._ = require 'underscore'
GLOBAL.async = require 'async'
GLOBAL.clock = require './clock'
GLOBAL.logger = require './logger'
GLOBAL.settings = require '../config/settings'

_.mixin
  only: (obj, keys...) ->
    result = {}
    result[key] = obj[key] for key in keys when obj[key]?
    result
