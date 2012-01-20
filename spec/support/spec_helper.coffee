process.env.NODE_ENV = 'test' unless process.env.NODE_ENV?

require './runner' unless jasmine?
require './async_helper'
require './before_after_all_helper'
require './browser_helper'
require './matchers_helper'
url = require 'url'

app = require '../../app/app'
require '../../app/globals'

parsedUrl = url.parse(settings.serverUrl)
port = parsedUrl.port or (parsedUrl.protocol == 'https:' and 443 or 80)

process.on 'uncaughtException', (error) ->
  console.error error.stack

beforeAll ->
  app.listen port

afterAll ->
  app.close()

