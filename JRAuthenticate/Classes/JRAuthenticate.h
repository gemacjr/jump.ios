/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 Copyright (c) 2010, Janrain, Inc.
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
	 list of conditions and the following disclaimer. 
 * Redistributions in binary form must reproduce the above copyright notice, 
	 this list of conditions and the following disclaimer in the documentation and/or
	 other materials provided with the distribution. 
 * Neither the name of the Janrain, Inc. nor the names of its
	 contributors may be used to endorse or promote products derived from this
	 software without specific prior written permission.
 
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
 
 File:	 JRAuthenticate.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import <Foundation/Foundation.h>
#import <JSON/JSON.h>
#import "JRConnectionManager.h"
#import "JRModalNavigationController.h"
#import "JRWebViewController.h"
#import "JRSessionData.h"

#define LOCAL 0

@protocol JRAuthenticateDelegate <NSObject>
@optional
/**
 * These messages are both sent to any JRAuthenticateDelegates after the library has received the
 * token and before the library posts the token to the token URL.  When this event occurs, the 
 * library closes the modal dialog, so you may want to capture this moment so that you can update
 * you UI.  You may implement neither or both, but the only difference between the two is that the 
 * second one includes the provider the user is authenticating with (the first one was left for 
 * backwards compatibility).  If you instantiate the library with a token URL, authentication is 
 * completed automatically, and you won't need the token for anything.  As tokens are only valid for
 * a small amount of time, do not persist this value.
 */
- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didReceiveToken:(NSString*)token;
- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didReceiveToken:(NSString*)token forProvider:(NSString*)provider;

@required
/**
 * This message is sent to any JRAuthenticateDelegates after the library has posted the token to the token URL
 * and received a response from the token URL.  This event completes authentication and the response is passed 
 * along to the application in the tokenURLPayload.  The content of this response is dependent on the implementation
 * of the token URL and application, but should contain any information required by the application, such as the 
 * user's profile, session cookies, etc.
 */
- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didReachTokenURL:(NSString*)tokenURL withPayload:(NSString*)tokenUrlPayload;

/**
 * The following messages are sent when authentication failed (not canceled) for any reason. 
 */
- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didFailWithError:(NSError*)error;
- (void)jrAuthenticate:(JRAuthenticate*)jrAuth callToTokenURL:(NSString*)tokenURL didFailWithError:(NSError*)error;

/**
 * This message is sent if the authorization was canceled for any reason other than an error.  For example, 
 * the user hits the "Cancel" button, or any class (including the JRAuthenticate delegate) calls the 
 * cancelAuthentication message.
 */
- (void)jrAuthenticateDidNotCompleteAuthentication:(JRAuthenticate*)jrAuth;
@end

/**
 * Use the JRAuthenticate class to authenticate the user with an account they may 
 * have on several providers.  To create a singleton instance of the JRAuthenticate
 * class, you will need to have an Engage application on RPXNow.com and use your
 * application's 20-character application ID.  You must also implement a token URL on a 
 * web application to complete authentication.
 */
@interface JRAuthenticate : NSObject <JRConnectionManagerDelegate, JRSessionDelegate>
{
	JRModalNavigationController *jrModalNavController;
	
	NSString		*theAppId;
	NSString		*theBaseUrl;
	NSString		*theTokenUrl;
	
	NSArray			*delegates;
	
	NSString		*theToken;
	NSString		*theTokenUrlPayload;
	
	JRSessionData	*sessionData;
	
	NSString		*errorStr;
}

/**
 * This is the base URL of your Engage application.
 */
@property (nonatomic, readonly) NSString* theBaseUrl;

/**
 * This is the token URL you supplied when you created the instance of the
 * JRAuthenticate library.
 */
@property (nonatomic, readonly) NSString* theTokenUrl;

/**
 * This is the token returned to the library from the Engage server once your
 * user authenticates with a provider.  This token is used to retrieve the 
 * profile data of your user from your token URL.  It has a short lifetime,
 * so it is not recommended that you store this anywhere.
 */
@property (nonatomic, readonly) NSString* theToken;

/**
 * This is the data returned from your token URL after the library POSTS 
 * the token and your token URL makes the call to the auth_info API. The 
 * library will pass this back to your application, but the contents of 
 * this are dependent on your token URL's implementation.
 */
@property (nonatomic, readonly) NSString* theTokenUrlPayload;


/**
 * Once an instance of the JRAuthenticate library is created, this will return 
 * that instance.  Otherwise, it will return nil.
 */
+ (JRAuthenticate*)jrAuthenticate;

/**
 * Use this function to create an instance of the JRAuthenticate library.
 * Arguments:
 *       appID: This is your 20-character application ID.  It is required.
 *    tokenURL: This is url where the library will automatically POST the token.
 *		    	It is not required, but if you don't supply one, the library won't
 *              automatically POST the token.  You can manually post the token by 
 *              calling the makeCallToTokenUrl message described below.
 *    delegate: This is the class that implements the JRAuthenticateDelegate protocol.
 */
+ (JRAuthenticate*)jrAuthenticateWithAppID:(NSString*)appId 
							   andTokenUrl:(NSString*)tokenUrl
								  delegate:(id<JRAuthenticateDelegate>)delegate;


/**
 * Use this function to begin authentication.  The JRAuthenticate library will 
 * pop up a modal dialog and take the user through the sign-in process.
 */
- (void)showJRAuthenticateDialog;
- (void)unloadModalViewController;

/**
 * Use these functions if you need to cancel authentication for any reason.
 */
- (void)cancelAuthentication;
- (void)cancelAuthenticationWithError:(NSError*)error;

/**
 * Use this function if you need to post the token to a token URL that is 
 * different than the one you initiated the library with, or if you didn't
 * use a token URL when initiating the library.
 */
- (void)makeCallToTokenUrl:(NSString*)tokenURL WithToken:(NSString *)token;
@end
