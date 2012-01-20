require '../support/spec_helper'

clock = require '../../app/lib/clock'

describe 'clock', ->

  describe 'dayInWeek', ->
    it 'it should get you to the previous sunday from saturday', ->
      expect(clock.pacific(clock.dayInWeek('2011-10-08 23:59', 'Sunday', 'America/Los_Angeles'), '%c')).toEqual "Sun 02 Oct 2011 11:59:00 PM UTC"

    it 'should remain unchanged on sunday', ->
      expect(clock.pacific(clock.dayInWeek('2011-10-09 00:01', 'Sunday', 'America/Los_Angeles'), '%c')).toEqual "Sun 09 Oct 2011 12:01:00 AM UTC"

    it 'works for other days', ->
      expect(clock.pacific(clock.dayInWeek('2011-10-09 00:01', 'Tuesday'), '%c')).toEqual "Tue 11 Oct 2011 12:01:00 AM UTC"

  describe 'daySuffix', ->
    it 'returns st for 1s', ->
      expect(clock.daySuffix('2011-10-01')).toEqual 'st'
      expect(clock.daySuffix('2011-10-11')).toEqual 'st'
      expect(clock.daySuffix('2011-10-21')).toEqual 'st'

    it 'returns nd for 2s', ->
      expect(clock.daySuffix('2011-10-02')).toEqual 'nd'
      expect(clock.daySuffix('2011-10-12')).toEqual 'nd'
      expect(clock.daySuffix('2011-10-22')).toEqual 'nd'

    it 'returns rd for 3s', ->
      expect(clock.daySuffix('2011-10-03')).toEqual 'rd'
      expect(clock.daySuffix('2011-10-13')).toEqual 'rd'
      expect(clock.daySuffix('2011-10-23')).toEqual 'rd'

    it 'returns th for everything else', ->
      expect(clock.daySuffix('2011-10-04')).toEqual 'th'
      expect(clock.daySuffix('2011-10-05')).toEqual 'th'
      expect(clock.daySuffix('2011-10-06')).toEqual 'th'
      expect(clock.daySuffix('2011-10-07')).toEqual 'th'
      expect(clock.daySuffix('2011-10-15')).toEqual 'th'
      expect(clock.daySuffix('2011-10-27')).toEqual 'th'
