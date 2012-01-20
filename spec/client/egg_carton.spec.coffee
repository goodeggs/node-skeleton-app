describe 'EggCarton', ->
  html = '<div id="doc"><div id="hd">Hello Head</div><div id="frame"><div id="bd">Hello Body</div></div><div id="splash">Hello Splash</div></div>'
  doc = null

  beforeEach ->
    $(document.body).append(html)
    doc = $('#doc').get(0)

  afterEach ->
    $(doc).remove()

  describe 'on IOS/Android browsers', ->
    beforeEach ->
      $.os.ios = true

    it 'does not hide splash on instantiation', ->
      eggCarton = new EggCarton(el: doc)
      expect($('#splash').css('display')).not.toEqual 'none'


  describe 'on non-IOS/Android browsers', ->
    beforeEach ->
      $.os.ios = false

    it 'hides splash on instantiation', ->
      eggCarton = new EggCarton(el: doc)
      expect($('#splash').css('display')).toEqual 'none'

