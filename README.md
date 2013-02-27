cozy-security-model
===================

Step 1.

the User requests http://u.cozy.cc/
redirect to login (http://u.cozy.cc/login)
home client exchange user password against [home client key]
home client store [home client key] as a cookie on user's browser

Step 1b.

the User is already connected [home client key] is in cookies


Step 2.
home client create a [app key] using its [hom client key]
home client create an iframe with src="http://.client