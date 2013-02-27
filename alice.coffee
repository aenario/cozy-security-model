express = require 'express'

app = express()
app.use express.static(__dirname + '/alice')
app.use express.bodyParser()

module.exports = app
