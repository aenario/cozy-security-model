express = require 'express'
httpProxy = require 'http-proxy'

app = express()
proxy = new httpProxy.RoutingProxy()
proxy.source.port = 80


app.use express.logger 'dev'
app.use express.static(__dirname + '/proxy', maxAge: 86400000)
app.use express.cookieParser 'secret'

key = 42; #should be random

module.exports.apps = {}
module.exports.domains = {}

#should be same hash than client + true right management
checkKey = (appName, k) ->
    if appName == 'bob'
        return (key+'bob' == k) || (key+'alice' == k)
    return key+appName == k 

forward = (req, res, appName) ->
    # todo should add the server token to the req
    # todo should remove the client token from the req (discourage dev to play with it)
    buffer = httpProxy.buffer(req)
    req.url = req.url.substring "/apps/#{appName}".length
    proxy.proxyRequest req, res,
        host: 'localhost'
        port: module.exports.apps[appName]
        buffer: buffer

app.get '/apps/:appName/*', (req, res) =>
    appName = req.params.appName
    #todo key can be :
    # - in query (?k=bob42)
    # - in X-Cozy-App-Token HTTP header
    # - in path for websockets
    if checkKey(appName, req.get('X-Cozy-App-Token')) || checkKey(appName, req.query.k)
        forward(req, res, appName)
    else
        res.send 401, 'hack attempt' # should redirect to a proxy-page that wraps around the app

app.get '/checkPass', (req, res) =>
    # this will actually be split between loginPost and root
    if (req.query.password == 'password') or (req.signedCookies.sid == 'sid')
        res.cookie('sid', 'sid', {maxAge: 900000, httpOnly:true, signed:true})
        res.json 'key':key
    else 
        res.json 'error':'wrong password'

# HELPER FOR APP DEVELOPPERS
app.get '/cozy-token-management.js', (req, res) =>
    res.send "
        var tk = window.location.search.replace('?k=','');
        $.ajaxSetup({headers: { 'X-Cozy-App-Token': tk }});"

# IGNORE ME, QUICK AND DIRTY WAY TO PASS DOMAINS AROUND FOR TESTS
app.get '/domains.js', (req, res) =>
    res.send "window.domains = {proxy:'#{module.exports.domains.proxy}',apps:'#{module.exports.domains.apps}'};"

module.exports = app