matchers =
  toBeAnInstanceOf: (expectedClass) ->
    @message = -> "Expected #{@actual} (#{@actual?.constructor?.name}) to be an instance of #{expectedClass.name}"
    @actual instanceof expectedClass

beforeEach ->
  @addMatchers matchers

