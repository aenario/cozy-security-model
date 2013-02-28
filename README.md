cozy-security-model
===================

Step 1a. opening home
- the User requests http://user.cozy.cc/
- redirect to login (http://user.cozy.cc/login)
- user fill and send
- home server exchange user password against [home client key]
- home client store [home client key] as a cookie on user's browser

Step 1b.
- when the User is already connected, [home client key] is in cookies


Step 2. opening an app
- home client create a [app key] using its [home client key]
- home client create an iframe with src="http://user-apps.client/?k=key"
- server check for key and serve the client

Step 3. app client make a request. 
- all requests from the client need to carry the [app key]
(cf. https://github.com/aenario/cozy-security-model/blob/master/proxy.coffee#L54)
- requests can be made to other apps API (validated by proxy)
- requests are forwarded to the requested app server

Potential fails and security : (eve is a bad app, bob is a good app with access to sensible data)
- eve cannot access key through the dom (window.parent) (sandbox + not same origin)
- eve cannot request /home to get the [home client key] (not same origin)
- eve cannot read the home cookies (not same origin)

- eve cannot make an ajax call to bob/api (server will refuse eve client key)
- eve cannot POST a form to bob/api (server will refuse eve client key)
