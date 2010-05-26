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

@implementation DemoViewController
@synthesize signInButton;	
@synthesize signOutButton;
@synthesize historyButton;
@synthesize welcomeLabelSignedIn;
@synthesize welcomeLabelSignedOut;

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
- (void)viewDidLoad 
{
	[super viewDidLoad];
	
	self.title = @"Quick Sign-In!";
	

	[self navigationController].navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	userProfileLevel1 = [[UserProfileLevel1 alloc] 
						  initWithNibName:@"UserProfileLevel1" 
						  bundle:[NSBundle mainBundle]];

	
	if ([[DemoUserModel getDemoUserModel] currentUser])
	{	
		[[self navigationController] pushViewController:userProfileLevel1 animated:YES];
	}
	else
	{
	
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

#ifdef LILLI	
	UIBarButtonItem *spacerButton = [[[UIBarButtonItem alloc]
									initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
									target:nil
									action:nil] autorelease];


	self.navigationItem.leftBarButtonItem = spacerButton;
	self.navigationItem.leftBarButtonItem.enabled = YES;

	self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered;

	UIBarButtonItem *addAnotherButton = [[[UIBarButtonItem alloc] 
										  initWithTitle:@"View Profiles" 
										  style:UIBarButtonItemStyleBordered
										  target:self
										  action:@selector(viewHistoryButtonPressed:)] autorelease];

	self.navigationItem.rightBarButtonItem = addAnotherButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
#endif

}

- (void)displayWelcomeMessage:(NSDictionary*)user
{
	NSString *welcome_message = nil;
	
	if (displayName)
	{
		welcome_message = [NSString stringWithFormat:@"You are now signed in as %@.", displayName];
		[UIView beginAnimations:@"fade" context:nil];
		[UIView setAnimationDuration:0.1];
		[UIView	setAnimationDelay:0.0];
		welcomeLabelSignedIn.text = welcome_message;
		[UIView commitAnimations];		
	}
	else 
	{
		welcome_message = [NSString stringWithFormat:@"You are now signed in."];
	}
	
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"User Authenticated"
													 message:welcome_message
													delegate:self
										   cancelButtonTitle:@"OK"
										   otherButtonTitles:nil] autorelease];
	[alert show];
}


- (void)delaySwitchAccounts:(NSTimer*)theTimer
{
	[userProfileLevel1 switchAccounts];
}

- (void)delayNavPush:(NSTimer*)theTimer
{
	[[self navigationController] pushViewController:userProfileLevel1 animated:YES]; 	
}

- (IBAction)signInButtonPressed:(id)sender 
{
#ifdef LILLI
	[[self navigationController] pushViewController:userProfileLevel1 animated:YES]; 	
	 [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(delaySwitchAccounts:) userInfo:nil repeats:NO];
#else
	[[DemoUserModel getDemoUserModel] startSignUserIn:userProfileLevel1];
	 [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(delayNavPush:) userInfo:nil repeats:NO];
#endif
	
}

- (IBAction)signOutButtonPressed:(id)sender
{
}

- (IBAction)viewHistoryButtonPressed:(id)sender
{
	[[self navigationController] pushViewController:userProfileLevel1 animated:YES]; 
}

- (void)didReceiveToken
{
//	[[self navigationController] pushViewController:userProfileLevel1 animated:YES]; 	
}

- (void)userDidSignIn
{
//	[[self navigationController] pushViewController:userProfileLevel1 animated:YES]; 	
}

- (void)userDidSignOut
{
	
}

- (void)didFailToSignIn
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
	[displayName release];
	[identifier release];

	[userProfileLevel1 release];
	
	[super dealloc];
}

@end
