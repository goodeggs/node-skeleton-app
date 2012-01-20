dateReviver = (key, value) ->
  _.isString(value) and (a = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2}(?:\.\d*)?)Z$/.exec(value)) and
    new Date(Date.UTC(+a[1], +a[2] - 1, +a[3], +a[4], +a[5], +a[6])) or value

module.exports = utils =
  returning: (syncFunc) ->
    ->
      args = Array.prototype.slice.call(arguments)
      callback = args.pop()
      try
        result = syncFunc.apply(this, args)
        callback(null, result)
      catch e
        callback(e)

  returningAsync: (syncFunc) ->
    ->
      args = Array.prototype.slice.call(arguments)
      callback = args.pop()
      that = this
      process.nextTick ->
        try
          result = syncFunc.apply(that, args)
          callback(null, result)
        catch e
          callback(e)


  sendErrorTo: (callback, func) ->
    (error, input...) ->
      return callback(error) if error?

      try
        result = func.apply(this, input)
      catch e
        callback(e)

  sendResultsTo: (callback, func) ->
    (error, input...) ->
      return callback(error) if error?

      try
        result = func.apply(this, input)
        callback(null, result)
      catch e
        callback(e)

  deepJsonClone: (obj) ->
    JSON.parse JSON.stringify(obj), dateReviver

  # fn = (optional, callback) ->
  #   [optional, callback] = u.argsWithCallback arguments
  argsWithCallback: (args) ->
    callee = args.callee
    args = Array.prototype.slice.call(args)
    while args.length < callee.length and typeof args[args.length - 1] == 'function'
      args.push args[args.length - 1]
      args[args.length - 2] = null
    args


