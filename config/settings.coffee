_ = require('underscore')
coffeescript = require 'coffee-script'
fs = require 'fs'

env = process.env.NODE_ENV ? 'development'

builder = (settingsFile) ->
  file = "./config/#{settingsFile}"
  try
    code = coffeescript.compile(fs.readFileSync(file, 'utf8'), bare: on)
    return (target) ->
      eval("(#{new Function(code).toString()}).apply(target);")
  catch e
    return(->) if e.code == 'EBADF' or e.code == 'ENOENT'
    throw e


baseBuilder = builder('settings.base.coffee')
localBuilder = builder('settings.local.coffee')

# aggregate settings, overriding base with local
settings = {env: env}
baseBuilder(settings)
localBuilder(settings)

module.exports = settings
