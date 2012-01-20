require '../support/spec_helper'
request = require 'request'
$ = require 'jquery'
u = require '../../app/lib/utils'
qs = require 'querystring'

root_uri = settings.serverUrl

describe 'App', ->

  describe 'GET /', ->

    it 'returns the index page', (done) ->
      request { uri: "#{root_uri}/"
              , headers:  { 'Content-Type': 'text/html' }}, u.sendResultsTo done, (response, body) ->
        expect(response.statusCode).toEqual 200
        expect(body).toMatch /this is my content/

