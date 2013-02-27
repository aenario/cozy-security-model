express = require 'express'
httpProxy = require 'http-proxy'

app = express()
proxy = new httpProxy.RoutingProxy()
proxy.source.port = 8080

app.use express.logger 'dev'
app.use express.static(__dirname + '/proxy', maxAge: 86400000)
#app.use express.bodyParser()

key = null;

apps = 
    'bob':8081
    'alice':8082
    'eve':8083

#should be same hash than client + more complex right management
checkKey = (appName, k) ->
    if appName == 'bob'
        return (key+'bob' == k) || (key+'alice' == k)
    return key+appName == k 

console.log checkKey('bob', '42bob')
console.log checkKey('bob', '42alice')
console.log checkKey('bob', '42eve')

forward = (req, res, appName) ->
    buffer = httpProxy.buffer(req)
    req.url = req.url.substring "/apps/#{appName}".length
    proxy.proxyRequest req, res,
        host: 'localhost'
        port: apps[appName]
        buffer: buffer

app.get '/apps/:appName/*', (req, res) =>
    appName = req.params.appName
    console.log key, appName, req.query.k
    console.log checkKey('bob', '42bob')
    console.log checkKey('bob', '42alice')
    console.log checkKey('bob', '42eve')
    if checkKey(appName, req.query.k)
        forward(req, res, appName)
    else
        res.send 401, 'hack attempt' # should redirect to a proxy-page that wraps around the app

app.get '/key.js', (req, res) =>
    key = 42; #should be random
    res.send 200, "window.secretKey=#{key};"

module.exports = app