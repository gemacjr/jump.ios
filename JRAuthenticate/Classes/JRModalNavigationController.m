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


#import "JRModalNavigationController.h"


@implementation JRModalNavigationController

@synthesize navigationController;
@synthesize sessionData;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (JRModalNavigationController*)initWithSessionData:(JRSessionData*)data
{
	if (!data)
	{
		[self release];
		return nil;
	}
	
	if (self = [super init])
	{
		shouldRestore = NO;
		sessionData = data;
	}
	
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView  
{
	UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
//	shouldRestore = NO;
	
	if (!navigationController)
	{
		navigationController = [[UINavigationController alloc] 
								initWithRootViewController:
								[[[JRProvidersController alloc] 
								  initWithNibName:@"JRProvidersController" 
								  bundle:[NSBundle mainBundle]] autorelease]];
	}
	
	[view setHidden:YES];
	[self setView:view];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
}
*/

- (void)presentModalNavigationController
{
	navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

	[self presentModalViewController:navigationController animated:YES];
}

- (void)viewDidAppear:(BOOL)animated 
{
	if (shouldRestore)
		[self restore:animated];
	
	shouldRestore = NO;
}

- (void)restore:(BOOL)animated
{
	while ([navigationController.viewControllers count] != 1)
	{
		[navigationController popViewControllerAnimated:animated];	
	}
}

- (void)cancelButtonPressed:(id)sender
{
	[self dismissModalNavigationController:NO];
}

- (void)dismissModalNavigationController:(BOOL)successfullyAuthed
{
	if (successfullyAuthed)
	{
		shouldRestore = YES;
		navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	}
	else 
	{
		navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	}
	
	[self dismissModalViewControllerAnimated:YES];
	[self.view removeFromSuperview];
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
	printf("navController retainCount: %d\n", [navigationController retainCount]);

	[sessionData release];
	[navigationController release];
//	navigationController = nil;
	
	[super dealloc];
}


@end
