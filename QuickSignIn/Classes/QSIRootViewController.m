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
	 
 
 File:	 DemoRootViewController.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import "DemoRootViewController.h"

@implementation DemoRootViewController
@synthesize signInButton;	
@synthesize linkButton;

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
	
#ifdef LILLI	
	UIBarButtonItem *spacerButton = [[[UIBarButtonItem alloc]
									  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
									  target:nil
									  action:nil] autorelease];
	
	self.navigationItem.leftBarButtonItem = spacerButton;
	self.navigationItem.leftBarButtonItem.enabled = YES;
//	self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered;
	
	UIBarButtonItem *viewHistoryButton = [[[UIBarButtonItem alloc] 
										   initWithTitle:@"View Profiles" 
										   style:UIBarButtonItemStyleBordered
										   target:self
										   action:@selector(viewHistoryButtonPressed:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = viewHistoryButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
#endif
	
	level1ViewController = [[DemoViewControllerLevel1 alloc] 
							initWithNibName:@"DemoViewControllerLevel1" 
							bundle:[NSBundle mainBundle]];
    
//    [[DemoUserModel getDemoUserModel] setNavigationController:[self navigationController]];
	
	/* Check to see if a user is already logged in, and, if so, wait half a second then drill down a level. */
	if ([[DemoUserModel getDemoUserModel] currentUser]) 
		[NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(delayNavPush:) userInfo:nil repeats:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)delaySwitchAccounts:(NSTimer*)theTimer
{
	[level1ViewController addAnotherButtonPressed:nil];
}

- (void)delayNavPush:(NSTimer*)theTimer
{
	[[self navigationController] pushViewController:level1ViewController animated:YES]; 	
}

/* Go to www.janrain.com */
- (IBAction)janrainLinkClicked:(id)sender
{
	NSURL *url = [NSURL URLWithString:@"http://www.janrain.com"];
	if (![[UIApplication sharedApplication] openURL:url])	
		NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

/* If any of the small icons are touched, show the faint outline of the surrounding button... */
- (IBAction)signInButtonOnEvent:(id)sender
{
	if (sender == signInButton)
		signInButton.alpha = 0.2;
}

/* and if that touch is released, hide the faint outline of the surrounding button. */
- (IBAction)signInButtonOffEvent:(id)sender
{
	if (sender == signInButton)
		signInButton.alpha = 0.02;
}

- (IBAction)signInButtonPressed:(id)sender 
{
#ifdef LILLI /* Drill down a level, then after half a second, sign the user in. */
	[[self navigationController] pushViewController:level1ViewController animated:YES]; 	
	 [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(delaySwitchAccounts:) userInfo:nil repeats:NO];
#else
	[[DemoUserModel getDemoUserModel] startSignUserIn:level1ViewController];
	 [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(delayNavPush:) userInfo:nil repeats:NO];
#endif
}

- (IBAction)viewHistoryButtonPressed:(id)sender
{
	[[self navigationController] pushViewController:level1ViewController animated:YES]; 
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
	[level1ViewController release];
	
	[super dealloc];
}

@end
