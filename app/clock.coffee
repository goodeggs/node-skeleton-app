tz = require('timezone').tz
tz.timezones(require('timezone/timezones/northamerica'))

defaultTimezone = 'America/Los_Angeles'

module.exports = clock =
  # Per timezone's convention, an absolute time (without timezone) is specified as milliseconds since the epoch.
  now: ->
    Date.now()

  pacific: tz.specialize(defaultTimezone)

  tz: tz

  # Return a date of the specific day (Sunday, Monday, etc) for the Sun-Sat week of the given time
  dayInWeek: (time, day, timezone = defaultTimezone) ->
    dayIndex = tz.locales().en_US.day.full.indexOf(day)
    if tz(time, '%w', timezone) == '0'
      tz(time, "+#{dayIndex} days", timezone)
    else
      tz(time, '-1 sunday', "+#{dayIndex} days", timezone)

  daySuffix: (time, timezone = defaultTimezone) ->
    switch tz(time, '%d')[1]
      when '1'
        'st'
      when '2'
        'nd'
      when '3'
        'rd'
      else 'th'
