require 'fibers'
Future = require 'fibers/future'

Function.prototype.fibrous = (that, args...) ->
  f = @
  futureF = Future.wrap(f)
  futureF.apply(that, args)

module.exports = fibrous = (f) ->
  futureF = f.future()
  (args...) ->
    if Fiber.current
      return futureF.apply(@, args)
    else
      callback = args.pop()
      throw new Error("running #{futureF} outside of a Fiber, so expected a callback") unless callback instanceof Function
      future = futureF.apply(@, args)
      future.resolve (err, result) ->
        # Ensure the callback is called outside the fiber (to avoid switching to fibrous versions of method calls from the async expecting callback)
        process.nextTick ->
          callback(err, result)

# Run the subsequent steps in a Fiber (at least until some non-cooperative async operation)
fibrous.middleware = (req, res, next) ->
  process.nextTick ->
    Fiber ->
      try
        next()
      catch e
        # We expect any errors which bubble up the fiber will be handled by the router
        logger.error('Unexpected error bubble up to the top of the fiber', e)
    .run()

fibrous.wait = (futures...) ->
  Future.wait(futures...)
  future.get() for future in futures # return an array of the results

