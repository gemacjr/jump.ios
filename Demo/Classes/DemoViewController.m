/* 
 Copyright (c) 2010, Janrain, Inc.
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
	list of conditions and the following disclaimer. 
 * Redistributions in binary
	form must reproduce the above copyright notice, this list of conditions and the
	following disclaimer in the documentation and/or other materials provided with
	the distribution. 
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
 */


#import "DemoViewController.h"

@interface User : NSObject
{
	NSDictionary *dictionary;
}

@property (retain) NSDictionary *dictionary;
@end

@implementation User

@synthesize dictionary;

- (id)initWithDictionary:(NSDictionary*)userDictionary
{
	self = [super init];
	[(dictionary = [NSDictionary dictionaryWithDictionary:userDictionary]) retain];
	
	return self;
}	

- (void)dealloc
{
	[dictionary release];
	
	[super dealloc];
}
@end



@implementation DemoViewController
@synthesize button;
@synthesize label;

static NSString *appId = @"appcfamhnpkagijaeinl";
static NSString *tokenUrl = @"http://jrauthenticate-sandbox.appspot.com/login";

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (NSDictionary*)getSignedInUser
{
	NSHTTPCookieStorage* cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray *cookies = [cookieStore cookies];//[cookieStore cookiesForURL:[NSURL URLWithString:@"jrauthenticate-sandbox.appspot.com"]];
	
	for (NSHTTPCookie *cookie in cookies) 
	{
		if ([cookie.name isEqualToString:@"sid"])
		{
			identifier = [[[NSString stringWithString:cookie.value] 
							stringByTrimmingCharactersInSet:
							[NSCharacterSet characterSetWithCharactersInString:@"\""]] retain];
		}
	}	
	
	
	if (!identifier)
		return nil;
	
	prefs = [[NSUserDefaults standardUserDefaults] retain];

	NSDictionary *tmp = [prefs dictionaryForKey:identifier];
	return tmp;
//	return [prefs dictionaryForKey:identifier];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	user = nil;
	identifier = nil;
	
	button.titleLabel.textAlignment = UITextAlignmentCenter;
	button.titleLabel.adjustsFontSizeToFitWidth = YES;
	
	jrAuthenticate = [[JRAuthenticate jrAuthenticateWithAppID:appId andTokenUrl:tokenUrl delegate:self] retain];
	//	jrAuthenticate = [[JRAuthenticate jrAuthenticateWithAppID:appId andTokenUrl:nil delegate:self] retain];

    [super viewDidLoad];
	
	if(user = [self getSignedInUser])
	{
		signedIn = YES;
		button.titleLabel.text = @"Sign Out";
		[self displayWelcomeMessage];
	}
	else
	{
		
	}
}

- (void)signUserIn
{
	identifier = [[[[user objectForKey:@"profile"] objectForKey:@"identifier"] stringByReplacingOccurrencesOfString:@"\/" withString:@"/"] retain];
	[prefs setObject:user forKey:identifier];
}

- (void)signUserOut
{
	[prefs removeObjectForKey:identifier];	
}

- (IBAction)launchJRAuthenticate:(id)sender 
{
	if (!signedIn)
	{
		[jrAuthenticate showJRAuthenticateDialog];
	}
	else
	{
		[self signUserOut];
		signedIn = NO;
		button.titleLabel.text = @"Sign In";
		[label setHidden:YES];
	}
	
}

- (void)displayWelcomeMessage
{
	NSString *welcome_message = nil;
	NSString *name = nil;

	NSDictionary *profile = [user objectForKey:@"profile"];
	
	if ([[profile objectForKey:@"name"] objectForKey:@"givenName"] && [[profile objectForKey:@"name"] objectForKey:@"familyName"])
		name = [NSString stringWithFormat:@"%@ %@", 
				[[profile objectForKey:@"name"] objectForKey:@"givenName"], 
				[[profile objectForKey:@"name"] objectForKey:@"familyName"]];
	else if ([profile objectForKey:@"preferredUsername"])
		name = [NSString stringWithFormat:@"%@", [profile objectForKey:@"preferredUsername"]];
	
	if (name)
	{
		welcome_message = [NSString stringWithFormat:@"You are now signed in as %@", name];
		label.text = [NSString stringWithFormat:@"Welcome, %@!", name];
	}
	else 
	{
		welcome_message = [NSString stringWithFormat:@"You are now signed in."];
		label.text = [NSString stringWithFormat:@"Welcome!", name];
	}
	
	[label setHidden:NO];
	
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"User Authenticated"
													 message:welcome_message
													delegate:self
										   cancelButtonTitle:@"OK"
										   otherButtonTitles:nil] autorelease];
	[alert show];
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didReceiveToken:(NSString*)token
{
	signedIn = YES;
	button.titleLabel.text = @"Sign Out";
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didReachTokenURL:(NSString*)tokenURL withPayload:(NSString*)tokenUrlPayload
{
	NSRange found = [tokenUrlPayload rangeOfString:@"{"];
	
	if (found.length == 0)
		return;
	
	NSString *userStr = [tokenUrlPayload substringFromIndex:found.location];
	
	user = [[userStr JSONValue] retain];
	
	if(!user) // Then there was an error
		return; // TODO: manage error and memory
	
	[self signUserIn];
	[self displayWelcomeMessage];
	
//	User* user = [[User alloc] initWithDictionary:[userDict objectForKey:@"profile"]];
}

- (void)jrAuthenticateDidNotCompleteAuthentication:(JRAuthenticate*)jrAuth
{
	
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didFailWithError:(NSError*)error 
{
	
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth callToTokenURL:(NSString*)tokenURL didFailWithError:(NSError*)error
{

}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	[user release];
	[identifier release];
	[prefs release];
    
	[super dealloc];
}

@end
