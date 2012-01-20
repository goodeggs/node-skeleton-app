#= require vendor/zepto
#= require vendor/underscore
#= require vendor/backbone
#= require vendor/json2
#= require scroller

ANDROID_ADDRESS_BAR_ANIMATION_DURATION = 1000

class EggCarton extends Backbone.View

  events:
    'touchmove': 'touchMove',

  constructor: ->
    super(el: $('#doc').get(0))
    if $.os.ios or $.os.android
      window.scrollTo 0, 1
      window.addEventListener 'load', (=> @onLoad()), false
    else
      @disabled = true
      @$('#doc').css(height: '100%')
      @$('#frame').css(position: 'absolute', bottom: 'auto', overflow: 'visible')
      @$('#hd').css(position: 'fixed')
      @$('#splash').hide()

  touchMove: (e) ->
    e.preventDefault() unless @disabled

  onLoad: ->
    frameEl = @$('#frame')
    bdEl = @$('#bd')
    splashEl = @$('#splash')

    getOffset = ->
      window.innerHeight - document.body.clientHeight

    setTimeout((->
      window.scrollTo 0, 1
      setTimeout((->
        offset = getOffset()
        frameEl.height(frameEl.height() + offset)
        scroller = new Scroller(bdEl.get(0))
        splashEl.hide()
      ), ANDROID_ADDRESS_BAR_ANIMATION_DURATION)
    ), 0)

@EggCarton = EggCarton
