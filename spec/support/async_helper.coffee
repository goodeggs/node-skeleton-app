require 'fibers'
fibrous = require '../../app/fibrous'

# Monkey patch 'it', 'beforeEach', 'afterEach' to wrap spec in
# async handler if it expects a done callback
for jasmineFunction in [ "it", "beforeEach", "afterEach"]
  do (jasmineFunction) ->
    original = global[jasmineFunction]
    global[jasmineFunction] = (args...) ->
      specFunction = args.pop()
      # No async callback expected, so not async
      if specFunction.length == 0 
        args.push specFunction
      else
        args.push -> asyncSpec(specFunction)

      original args...

# Run any function, failing the current spec if there is an error or it times out
asyncSpec = (spec, timeout = 5000) ->
  done = false
  runs ->
    try
      spec (error) ->
        done = true
        jasmine.getEnv().currentSpec.fail(error) if error?
    catch e
      # if we hit an exception before any async code, mark the spec done
      done = true
      throw e
  waitsFor ->
    done == true
  , "spec to complete", timeout


global.itFiber = (args...) ->
  spec = args.pop()
  global.it args..., (done) =>
    future = spec.future().apply(@)
    future.resolve (err, result) ->
      # Ensure the callback is called outside the fiber (to avoid switching to fibrous versions of method calls from the async expecting callback)
      process.nextTick ->
        done(err, result)

