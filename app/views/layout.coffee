doctype 5
html ->
  head ->
    title 'Good Eggs'
    meta charset: 'utf-8'
    meta name: 'viewport', content: 'width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no'
    link rel: 'icon', type: 'image/png', href: '/img/favicon.png'

    #embed only those client suitable settings - be careful
    embed 'window.settings': only(@settings, 'mixpanelId', 'googleAnalyiticsId')

    text css('main')

    content 'head'

    coffeescript ->
      # Google Analytics
      _gaq = window._gaq = window._gaq || []
      _gaq.push ['_setAccount', window.settings.googleAnalyticsId]
      _gaq.push ['_trackPageview']
      (->
        ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true
        ga.src = ('https:' == document.location.protocol and 'https://ssl' or 'http://www') + '.google-analytics.com/ga.js'
        s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s)
      )()

      # Mixpanel
      mpq= window.mpq = window.mpq || []
      mpq.push ['init', window.settings.mixpanelId]
      (->
        mp = document.createElement('script'); mp.type = 'text/javascript'; mp.async = true
        mp.src = ('https:' == document.location.protocol and 'https:' or 'http:') + '//api.mixpanel.com/site_media/js/api/mixpanel.js'
        s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(mp, s)
        fn = (f) ->
          (-> mpq.push([f].concat(Array.prototype.slice.call(arguments, 0))))
        apis = ['init', 'track', 'track_links', 'track_forms', 'register', 'register_once', 'identify', 'name_tag', 'set_config']
        mpq[api] = fn(api) for api in apis
      )()
      if window.metrics?.cid?
        mpq.identify(window.metrics.cid)
        mpq.name_tag(window.metrics.cid)

     body ->
       div '#doc', ->
         div '#hd', ->
           h1 'Good Eggs'
         div '#frame', ->
           div '#bd', ->
             text @body
         div '#splash', ''

       script src: '/js/vendor/coffeekup.js' # Does not minify
       text js('main')

