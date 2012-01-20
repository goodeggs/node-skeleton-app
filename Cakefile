fs            = require 'fs'
path          = require 'path'
async         = require 'async'
url = require 'url'
{print}       = require 'util'
{spawn, exec} = require 'child_process'
_ = require 'underscore'

spec_jasmine_node = (callback) ->
  console.log 'Running Jasmine-Node specs...'
  options = ['spec/app', '--coffee', '--junitreport', '--noColor']
  run_spec 'jasmine-node', options, callback

spec_jasmine_headless = (callback) ->
  options = ['--report=reports/headless.txt']
  run_spec 'jasmine-headless-webkit', options, callback

spec_phantomjs = (callback) ->
  console.log 'Running integration specs...'
  options = ['spec/integrations', '--coffee', '--junitreport', '--noColor']
  run_spec 'jasmine-node', options, callback

run_spec = (command, options, callback) ->
  spec = spawn command, options
  spec.stdout.on 'data', (data) -> print data.toString()
  spec.stderr.on 'data', (data) -> print data.toString()
  spec.on 'exit', (status) ->
    if callback?
      callback(null, status)
    else
      process.exit(status)

task 'spec:app', 'Run jasmine-node', ->
  spec_jasmine_node()

task 'spec:client', 'Run jasmine-headless-webkit', ->
  spec_jasmine_headless()

task 'spec:integrations', 'Run integration specs', ->
  spec_phantomjs()

task 'spec', 'Run all specs', ->
  async.series [
    spec_jasmine_node
    spec_jasmine_headless
    (next) -> console.log("\n"); next()
    spec_phantomjs
  ], (error, results) ->
    if error
      console.error error
      process.exit(1)
    errors = (code for code in results when code != 0)
    process.exit(errors[0]) if errors.length > 0

