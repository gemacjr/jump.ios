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

static NSString *appId = @"appcfamhnpkagijaeinl";
static NSString *tokenUrl = @"http://jrauthenticate.appspot.com/login";

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	button.titleLabel.textAlignment = UITextAlignmentCenter;
	
	jrAuthenticate = [[JRAuthenticate initWithAppID:appId andTokenUrl:tokenUrl delegate:self] retain];
}

- (IBAction)launchJRAuthenticate:(id)sender 
{
	printf("clicked button\n");
	if (!signedIn)
	{
		[jrAuthenticate showJRAuthenticateDialog];
	}
	else
	{
		signedIn = NO;
		button.titleLabel.text = @"Authenticate";
		[label setHidden:YES];
	}
	
}


- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didCompleteAuthentication:(NSDictionary*)userInfo { }

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didReceiveToken:(NSString*)token 
{
	signedIn = YES;
	button.titleLabel.text = @"Sign Out";
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didReachTokenURL:(NSString*)tokenUrlPayload 
{
	NSRange found = [tokenUrlPayload rangeOfString:@"{"];
	
	if (found.length == 0)
		return;
	
	NSString *userStr = [tokenUrlPayload substringFromIndex:found.location];
	
	NSDictionary *userDict = [userStr JSONValue];
	
	if(!userDict) // Then there was an error
		return; // TODO: manage error and memory
	
	User* user = [[User alloc] initWithDictionary:[userDict objectForKey:@"profile"]];
	
	
	NSString *welcome_message = nil;
	NSString *name = nil;
	
	if ([[user.dictionary objectForKey:@"name"] objectForKey:@"givenName"] && [[user.dictionary objectForKey:@"name"] objectForKey:@"familyName"])
		name = [NSString stringWithFormat:@"%@ %@", 
						   [[user.dictionary objectForKey:@"name"] objectForKey:@"givenName"], 
						   [[user.dictionary objectForKey:@"name"] objectForKey:@"familyName"]];
	else if ([user.dictionary objectForKey:@"preferredUsername"])
		name = [NSString stringWithFormat:@"%@", [user.dictionary objectForKey:@"preferredUsername"]];
	
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
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User Authenticated"
													message:welcome_message
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didFailWithError:(NSString*)error 
{
	
	
	
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didNotCompleteAuthentication:(NSString*)reason 
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


- (void)dealloc {
    [super dealloc];
}

@end
