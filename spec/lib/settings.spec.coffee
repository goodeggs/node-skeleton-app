require '../support/spec_helper'

settings = require '../../config/settings'

describe 'settings', ->

  #TODO stub out filesystem dependency here.

  #it 'should have a single string for a specific environment', ->
  #  expect(settings.amazonPaymentsAccountId).toEqual 'QIELQHIPGLGS6UQVA12KRZTU288FQC2KIZHP6T'
  #  expect(JSON.parse(JSON.stringify(settings))).toEqual settings

  #it 'should leave the simple string values unchanged', ->
  #  expect(settings.mixpanelId).toEqual 'f21f3db1ad328354c7199010f0737e15'

  #it 'should include server settings', ->
  #  expect(settings.mailerUsername).toEqual 'admin@goodeggsinc.com'

  #it 'should include client settings', ->
  #  expect(settings.mixpanelId).toEqual 'f21f3db1ad328354c7199010f0737e15'

  describe 'env', ->

    it 'should be set', ->
      expect(settings.env).toEqual 'test'

