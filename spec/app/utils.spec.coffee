require '../support/spec_helper'

u = require '../../app/utils'

describe 'utils', ->
  describe 'argsWithCallback', ->

    it "should return args as array", ->
      fn = (one, two) ->
        u.argsWithCallback arguments
      expect(fn(1,2)).toEqual [1,2]
      expect(fn(1)).toEqual [1]

    it "should grow args with function at end", ->
      fn = (one, two, callback) ->
        u.argsWithCallback arguments
      callback = ->
      expect(fn(1,callback)).toEqual [1,null,callback]
      expect(fn(callback)).toEqual [null,null,callback]

    it "should be a good example", ->
      fn = (optional, callback) ->
        [optional, callback] = u.argsWithCallback arguments
        expect(optional).toBeNull()
        expect(typeof callback).toEqual 'function'

      fn (done) -> done()
