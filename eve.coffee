express = require 'express'

app = express()
app.use express.static(__dirname + '/eve')
app.use express.bodyParser()

module.exports = app
