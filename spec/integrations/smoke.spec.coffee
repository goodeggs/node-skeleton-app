require '../support/spec_helper'
Future = require 'fibers/future'

describe 'The Homepage', ->
  itFiber 'should load', ->
    browser = withBrowser().wait()
    browser.navigateTo('/').wait()
    text = browser.evaluate(-> $('#bd').text()).wait()
    expect(text).toMatch /this is my content/

