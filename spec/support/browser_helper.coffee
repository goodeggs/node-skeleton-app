Future = require 'fibers/future'

phantom = null
getPhantom = (cb) ->
  return cb(phantom) if phantom
  require('phantom').create (ph) ->
    phantom = ph
    cb(phantom)

afterAll ->
  phantom.exit() if phantom?

#All these methods return futures, and therefore are written for easy usage from within fibers.
#The marshalling of results to the return futures is done manually since the phantomjs api doesn't have the normal
#node style (error, result) callback parameters
class Browser
  constructor: (@page, @baseUrl) ->

  navigateTo: (path) ->
    future = new Future()
    @page.open "#{@baseUrl}#{path}", (status) ->
      if status != 'success'
        future.throw(new Error("Failed to load #{url}: #{status}"))
      else
        future.return(status)
    future

  click: (selector) ->
    future = new Future()
    fn = null
    eval "fn = function() { return $(#{JSON.stringify(selector)}).offset() }"
    @page.evaluate fn, (offset) =>
      @page.sendEvent 'click', offset.left, offset.top
      future.return()
    future

  render: (filename) ->
    future = new Future()
    @page.render filename, ->
      future.return()
    future

  evaluate: (fn) ->
    future = new Future()
    @page.evaluate fn, (result) ->
      future.return(result)
    future

global.withBrowser = () ->
  future = new Future()
  getPhantom (ph) ->
    ph.createPage (page) ->
      page.set 'viewportSize', width: 1024, height: 768, ->
        future.return(new Browser(page, settings.serverUrl))
  future
