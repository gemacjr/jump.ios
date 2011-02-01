#!/usr/bin/env python
#
# Copyright (c) 2010, Janrain, Inc.
#  
#  All rights reserved.
#  
#  Redistribution and use in source and binary forms, with or without modification,
#  are permitted provided that the following conditions are met:
#  
#  * Redistributions of source code must retain the above copyright notice, this
# 	 list of conditions and the following disclaimer. 
#  * Redistributions in binary
# 	 form must reproduce the above copyright notice, this list of conditions and the
# 	 following disclaimer in the documentation and/or other materials provided with
# 	 the distribution. 
#  * Neither the name of the Janrain, Inc. nor the names of its
# 	 contributors may be used to endorse or promote products derived from this
# 	 software without specific prior written permission.
#  
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
#  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
#  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 


import urllib
import urllib2

import os
from google.appengine.ext.webapp import template

import cgi

from google.appengine.ext import webapp
from google.appengine.ext.webapp import util
from google.appengine.ext.webapp.util import run_wsgi_app
from google.appengine.ext import db

from django.utils import simplejson

import Cookie


class UserLogin(db.Model):
    identifier = db.StringProperty(multiline=False)
    date = db.DateTimeProperty(auto_now_add=True)


class MainHandler(webapp.RequestHandler):
	
	def get(self):
       		path = os.path.join(os.path.dirname(__file__), 'index.html')
       		self.response.out.write(template.render(path, 0))


class Login(webapp.RequestHandler):

	def post(self):  
			# Step 1) Extract the token from your environment. If you are using app 
			# engine, you'd do something like:
			token = self.request.get('token')
		
			# Step 2) Now that we have the token, we need to make the api call to 
			# auth_info.  auth_info expects an HTTP Post with the following paramters:
			api_params = {
				'token': token,
				'apiKey': '<YOUR_RPX_APPLICATIONS_40_CHARACTER_API_KEY>',
				'format': 'json',
			}
			http_response = urllib2.urlopen('https://rpxnow.com/api/v2/auth_info',
											urllib.urlencode(api_params))
			response = http_response.read()

			auth_info = simplejson.loads(response)
			profile = auth_info['profile']
   
			# 'identifier' will always be in the payload. This is the
			# unique idenfifier that you use to sign the user in to your site
			identifier = profile['identifier']
   
			# Create a user object and store it in your datastore
			userLogin = UserLogin()
			userLogin.identifier = identifier
			userLogin.put()

			# Create a cookie with the identifier to send to the iPhone app
			cookie = Cookie.SimpleCookie()
			
			# Set the sid in the cookie
			cookie['sid'] = identifier
			
			# Will expire in two weeks
			cookie['sid']['expires'] = 14 * 24 * 60 * 60
			cookie['sid']['path'] = "/"
			cookie['sid']['domain'] = "<YOUR_DOMAIN>"
			
			self.response.headers.add_header('Set-Cookie', cookie['sid'].OutputString())
			self.response.out.write(response)
			print response
	

def main():
	application = webapp.WSGIApplication([('/', MainHandler),
    									  ('/login', Login)],
    										debug=True)
	util.run_wsgi_app(application)


if __name__ == '__main__':
	main()
