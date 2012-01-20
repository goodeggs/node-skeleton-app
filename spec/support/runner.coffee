process.env.NODE_ENV = 'test' unless process.env.NODE_ENV?

util = require 'util'
_ = require 'underscore'

dir = 'jasmine-node/lib/jasmine-node/'
filename =  'jasmine-2.0.0.rc1'

for key, value of require("#{dir}#{filename}")
  global[key] = value

TerminalReporter = require("#{dir}reporter").TerminalReporter
jasmine.getEnv().addReporter(new TerminalReporter(
  print: util.print
  color: true
  stackFilter: (text) ->
    _(text.split /\n/).filter((line) -> line.indexOf("#{dir}#{filename}") == -1).join('\n')
))

process.nextTick ->
  jasmine.getEnv().execute()

