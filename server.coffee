app = require './app/lib/app'

app.listen(process.env.PORT || 3000)
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
