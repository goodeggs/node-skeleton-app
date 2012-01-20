DRAGTHRESHOLD = 4 #px
BOUNCETHRESHOLD = 40 #px

class Scroller
  constructor: (@element) ->
    @startTouchY = 0
    @animateTo(0)

    for type in ['touchstart', 'touchend', 'touchmove', 'touchcancel']
      @element.addEventListener(type, ((e) => @handleEvent(e)), false)

  handleEvent: (e) ->
    switch e.type
      when 'touchstart'
        @onTouchStart(e)
      when 'touchmove'
        @onTouchMove(e)
      when 'touchend' or 'touchcancel'
        @onTouchEnd(e)

  onTouchStart: (e) ->
    @stopMomentum()
    @maxOffset = @element.parentNode.clientHeight - @element.clientHeight
    @startTouchY = e.touches[0].clientY
    @startTouchT = new Date().getTime()
    @contentStartOffsetY = @contentOffsetY
    @lastTouchY = @startTouchY
    @lastTouchT = new Date().getTime()
    return null

  onTouchMove: (e) ->
    newTouchY = e.touches[0].clientY
    newTouchT = new Date().getTime()
    @currentVelocity = (newTouchY - @lastTouchY) / (newTouchT - @lastTouchT) #px/msec
    @lastTouchY = newTouchY
    @lastTouchT = newTouchT
    if @isDragging()
      deltaY = @lastTouchY - @startTouchY
      newY = deltaY + @contentStartOffsetY
      if newY < BOUNCETHRESHOLD and newY > (@maxOffset - BOUNCETHRESHOLD)
        @animateTo(newY)
    return null

  onTouchEnd: (e) ->
    if @isDragging()
      if @shouldStartMomentum()
        @doMomentum()
      else
        @snapToBounds()
    @dragging = false
    return null

  animateTo: (offsetY) ->
    @contentOffsetY = offsetY

    # We use webkit-transforms with translate3d because these animations
    # will be hardware accelerated, and therefore significantly faster
    # than changing the top value.
    @element.style.webkitTransform = "translate3d(0, #{offsetY}px, 0)"

  boundifyNewOffset: (newOffsetY) ->
    if newOffsetY > 0
      0
    else if newOffsetY < @maxOffset
      @maxOffset
    else
      newOffsetY
    

  # Implementation of this method is left as an exercise for the reader.
  # You need to measure the current position of the scrollable content
  # relative to the frame. If the content is outside of the boundaries
  # then simply reposition it to be just within the appropriate boundary.
  snapToBounds: ->
    boundedOffsetY = @boundifyNewOffset(@contentOffsetY)
    if boundedOffsetY != @contentOffsetY
      @animateTo(boundedOffsetY)


  # Implementation of this method is left as an exercise for the reader.
  # You need to consider whether their touch has moved past a certain
  # threshold that should be considered ‘dragging’.
  isDragging: ->
    res = @dragging or (Math.abs(@startTouchY - @lastTouchY) > DRAGTHRESHOLD)
    @dragging = true if res
    res

  # Implementation of this method is left as an exercise for the reader.
  # You need to consider the end velocity of the drag was past the
  # threshold required to initiate momentum.
  shouldStartMomentum: ->
    Math.abs(@currentVelocity) > 0.075

  getEndVelocity: ->
    (@lastTouchY - @startTouchY) / (@lastTouchT - @startTouchT)

  doMomentum: ->
    # Calculate the movement properties. Implement getEndVelocity using the
    # start and end position / time.
    velocity = @currentVelocity
    acceleration = velocity < 0 and 0.0005 or -0.0005
    displacement = - (velocity * velocity) / (2 * acceleration)

    newY = @contentOffsetY + displacement
    boundedNewY = @boundifyNewOffset(newY)
    scale = boundedNewY / newY

    if Math.abs(@contentOffsetY - boundedNewY) <= BOUNCETHRESHOLD
      time = 250
    else
      time = Math.abs((velocity / acceleration) * scale)

    # Set up the transition and execute the transform. Once you implement this
    # you will need to figure out an appropriate time to clear the transition
    # so that it doesn’t apply to subsequent scrolling.
    @element.style.webkitTransition = "-webkit-transform #{time}ms cubic-bezier(0.33, 0.66, 0.66, 1)"
    clearTimeout(@transitionTimeout) if @transitionTimeout
    @transitionTimeout = setTimeout((=> @element.style.webkitTransition = ''; @transitionTimeout = null), time)

    @contentOffsetY = boundedNewY
    @element.style.webkitTransform = "translate3d(0, #{boundedNewY}px, 0)"

  isDecelerating: ->
    !!@transitionTimeout

  stopMomentum: ->
    if @isDecelerating()
      clearTimeout(@transitionTimeout)
      # Get the computed style object.
      style = document.defaultView.getComputedStyle(@element, null)
      # Computed the transform in a matrix object given the style.
      transform = new WebKitCSSMatrix(style.webkitTransform)
      # Clear the active transition so it doesn’t apply to our next transform.
      @element.style.webkitTransition = ''
      # Set the element transform to where it is right now.
      @animateTo(transform.m42)

@Scroller = Scroller
