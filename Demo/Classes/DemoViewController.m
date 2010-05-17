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



@implementation UIDemoButton

@synthesize label;
@synthesize logo1;
@synthesize logo2;
@synthesize logo3;
@synthesize logo4;

- (void)layoutSubviews
{
	[super layoutSubviews];

	logo1 = [[UIImageView alloc] initWithFrame:CGRectMake(135, 9, 20, 20)];
	logo1.image = [UIImage imageNamed:@"google_icon.png"];
	[self addSubview:logo1];

	logo2 = [[UIImageView alloc] initWithFrame:CGRectMake(164, 9, 20, 20)];
	logo2.image = [UIImage imageNamed:@"facebook_icon.png"];
	[self addSubview:logo2];
	
	logo3 = [[UIImageView alloc] initWithFrame:CGRectMake(193, 9, 20, 20)];
	logo3.image = [UIImage imageNamed:@"yahoo_icon.png"];
	[self addSubview:logo3];
	
	logo4 = [[UIImageView alloc] initWithFrame:CGRectMake(222, 9, 20, 20)];
	logo4.image = [UIImage imageNamed:@"aol_icon.png"];
	[self addSubview:logo4];
	
	logo4 = [[UIImageView alloc] initWithFrame:CGRectMake(251, 9, 20, 20)];
	logo4.image = [UIImage imageNamed:@"twitter_icon.png"];
	[self addSubview:logo4];
	
}	

- (void)dealloc
{
	[super dealloc];
}
@end


@implementation DemoViewController
@synthesize button;
@synthesize label;

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

- (BOOL)getSignedInUser
{
	/* First, see if there is a saved user */
	currentUser = [prefs objectForKey:@"currentUser"];
	
	if (!currentUser)
		return NO;
	
	/* If there is, check the cookies to make sure the saved user's identifier matches any cookie returned from
	   the token URL, or if their session has expired */
	NSHTTPCookieStorage* cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray *cookies = [cookieStore cookiesForURL:[NSURL URLWithString:@"http://jrauthenticate.appspot.com"]];
	
	for (NSHTTPCookie *cookie in cookies) 
	{
		if ([cookie.name isEqualToString:@"sid"])
		{
			identifier = [[[NSString stringWithString:cookie.value] 
							stringByTrimmingCharactersInSet:
							[NSCharacterSet characterSetWithCharactersInString:@"\""]] retain];
		}
	}	
	
	/* Then the cookie expired, and we have a user currently logged in, so we have to
	   log out the current user and save the history of the session in the array of preivous sessions */
	if (!identifier)
	{
		[self signUserOut];
		return NO;
	}

	/* Make sure the cookie's identifier matches the saved user's identifier,
	   otherwise, sign the user out */
	if (![identifier isEqualToString:[currentUser objectForKey:@"identifier"]])
	{
		[self signUserOut];
		return NO;
	}
	
	return YES;
}

- (void)displayWelcomeMessage
{
//	NSString *welcome_message = nil;
//	NSString *name = nil;
//	
//	NSDictionary *profile = [user objectForKey:@"profile"];
//	
//	if ([[profile objectForKey:@"name"] objectForKey:@"givenName"] && [[profile objectForKey:@"name"] objectForKey:@"familyName"])
//		name = [NSString stringWithFormat:@"%@ %@", 
//				[[profile objectForKey:@"name"] objectForKey:@"givenName"], 
//				[[profile objectForKey:@"name"] objectForKey:@"familyName"]];
//	else if ([profile objectForKey:@"preferredUsername"])
//		name = [NSString stringWithFormat:@"%@", [profile objectForKey:@"preferredUsername"]];
//	
//	if (name)
//	{
//		welcome_message = [NSString stringWithFormat:@"You are now signed in as %@", name];
//		label.text = [NSString stringWithFormat:@"Welcome, %@!", name];
//	}
//	else 
//	{
//		welcome_message = [NSString stringWithFormat:@"You are now signed in."];
//		label.text = [NSString stringWithFormat:@"Welcome!", name];
//	}
//	
//	[label setHidden:NO];
//	
//	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"User Authenticated"
//													 message:welcome_message
//													delegate:self
//										   cancelButtonTitle:@"OK"
//										   otherButtonTitles:nil] autorelease];
//	[alert show];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
	
	identifier = nil;
	
//	button.titleLabel.textAlignment = UITextAlignmentCenter;
//	button.titleLabel.adjustsFontSizeToFitWidth = YES;
	
	jrAuthenticate = [[JRAuthenticate jrAuthenticateWithAppID:appId andTokenUrl:tokenUrl delegate:self] retain];

	prefs = [[NSUserDefaults standardUserDefaults] retain];
    

	
	if (!navigationController)
	{
		navigationController = [[UINavigationController alloc] 
								initWithRootViewController:
								[[[UserProfileLevel1 alloc] 
								  initWithNibName:@"UserProfileLevel1" 
								  bundle:[NSBundle mainBundle]] autorelease]];
	}	
	
	if([self getSignedInUser])
		signedIn = YES;
	else
		signedIn = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	if (signedIn)
		[self showUserTable];
}

- (void)showUserTable
{
	navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:navigationController animated:YES];	
}

- (void)hideUserTable
{
	navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self dismissModalViewControllerAnimated:YES];
}

- (void)signUserIn:(NSDictionary*)user
{
	/* Get the identifier and normalize it (remove html escapes) */
	identifier = [[[[user objectForKey:@"profile"] objectForKey:@"identifier"] stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"] retain];
	
	/* Store the current user's profile dictionary in the dictionary of users, 
	   using the identifier as the key, and then save the dictionary of users */
	NSDictionary *tmpDict = [prefs objectForKey:@"previousUsersDict"];
	NSMutableDictionary* previousUsersDict = [[NSMutableDictionary alloc] 
											   initWithCapacity:[tmpDict count]]; 
	[previousUsersDict addEntriesFromDictionary:tmpDict];
		
	[previousUsersDict setObject:user forKey:identifier];
	[prefs setObject:previousUsersDict forKey:@"previousUsersDict"];

	[previousUsersDict release];
	
	/* Get the approximate timestamp of the user's log in */
	NSDate *today = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	
	NSString *currentTime = [dateFormatter stringFromDate:today];
	[dateFormatter release];
	
	/* Create a dictionary of the identifier and the timestamp.  For now, save this dictionary 
	   as the currently logged in user. */
	currentUser = [[NSDictionary dictionaryWithObjectsAndKeys:
					identifier, @"identifier",
					currentTime, @"timestamp", nil] retain];
						 
	[prefs setObject:currentUser forKey:@"currentUser"];

	[self showUserTable];
}

- (void)signUserOut
{
	/* Save the dictionary (identifier and the timestamp) at the beginning of the array (stack) of 
	 previously logged in users one user may have multiple sessions.  Saving a list of timestamps 
	 in the previous users' dictionaries would require more work to sort in the UserProfileLevel1 
	 class, whereas the sole purpose of using this array is to preserve login order. */
	NSArray *tmpArr = [prefs arrayForKey:@"previousUsersArr"];
	NSMutableArray *previousUsersArr = [[NSMutableArray alloc] 
										 initWithCapacity:[tmpArr count]];
	[previousUsersArr addObjectsFromArray:tmpArr];
	
	[previousUsersArr insertObject:currentUser atIndex:0];

	[prefs setObject:previousUsersArr forKey:@"previousUsersArr"];
	[prefs setObject:nil forKey:@"currentUser"];

	[currentUser release];
	[previousUsersArr release];
		
	[self hideUserTable];
}

- (IBAction)launchJRAuthenticate:(id)sender 
{
	if (!signedIn)
		[jrAuthenticate showJRAuthenticateDialog];

//	else
//	{
//		[self signUserOut];
//		signedIn = NO;
//		button.titleLabel.text = @"Sign In";
//		[label setHidden:YES];
//	}
	
}


- (void)signoutButtonPressed:(id)sender
{
	signedIn = NO;
	[self signUserOut];
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
	NSDictionary* user = [userStr JSONValue];
	
	if(!user) // Then there was an error
		return; // TODO: manage error and memory
		
	[self signUserIn:user];
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
	[currentUser release];
	[identifier release];
		
	[super dealloc];
}

@end
