apps = 
    bob:8081
    alice:8082
    eve:8083

domains = 
    proxy: 'fakeuser.cozycloud.cc'
    apps : 'apps.fakeuser.cozycloud.cc'

proxy = require './proxy'
proxy.apps = apps
proxy.domains = domains
proxy.listen 80
console.log 'fakeHome started'

for app , port of apps
    testApp = require "./#{app}"
    testApp.listen port
    console.log "#{app} started"

console.log 'please add : '
console.log ' ÏP '+domains.proxy
console.log ' ÏP '+domains.apps
console.log ' to your "hosts" file'