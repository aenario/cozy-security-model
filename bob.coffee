express = require 'express'

app = express()
app.use express.static(__dirname + '/bob')
app.use express.bodyParser()

app.get '/api', (req, res) -> res.json({'data':'secret'})

module.exports = app
