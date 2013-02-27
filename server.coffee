fakeHome = require './proxy'
fakeHome.listen 8080
console.log 'fakeHome started'

testApp = require './bob'
testApp.listen 8081
console.log 'bob started'

testApp = require './alice'
testApp.listen 8082
console.log 'alice started'

testApp = require './eve'
testApp.listen 8083
console.log 'eve started'