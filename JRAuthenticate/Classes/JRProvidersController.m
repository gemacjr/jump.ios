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
 
 File:	 JRProvidersController.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import "JRProvidersController.h"

// TODO: Figure out why the -DDEBUG cflag isn't being set when Active Conf is set to debug
// TODO: Take this out of the production app
#define DEBUG
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@interface UITableViewCellProviders : UITableViewCell 
{
	UIImageView *icon;
}

@property (nonatomic, retain) UIImageView *icon;

@end

@implementation UITableViewCellProviders

@synthesize icon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		[self addSubview:icon];
	}
	
	return self;
}	

- (void) layoutSubviews 
{
	[super layoutSubviews];

	self.imageView.frame = CGRectMake(10, 10, 30, 30);
	self.textLabel.frame = CGRectMake(50, 15, 100, 22);
}
@end

@implementation JRProvidersController

@synthesize myTableView;
@synthesize myLoadingLabel;
@synthesize myActivitySpinner;

/*
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		jrAuth = [JRAuthenticate jrAuthenticate];
		[jrAuth retain];
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	DLog(@"");
	[super viewDidLoad];
	
	jrAuth = [[JRAuthenticate jrAuthenticate] retain];
	sessionData = [[((JRModalNavigationController*)[[self navigationController] parentViewController]) sessionData] retain];	

	titleLabel = nil;
	
	/* Check the session data to see if there's information on the last provider the user logged in with. */
	if (sessionData.returningProvider)
	{
		DLog(@"and there was a returning provider");
		[sessionData setCurrentProviderToReturningProvider];
		
		/* If so, go straight to the returning provider screen. */
		[[self navigationController] pushViewController:((JRModalNavigationController*)[self navigationController].parentViewController).myUserLandingController
											   animated:NO]; 
	}
	
	/* Load the table with the list of providers. */
	[myTableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated 
{
	DLog(@"");
	[super viewWillAppear:animated];
	
	self.title = @"Providers";

	if (!titleLabel)
	{
		titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)] autorelease];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
		titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
		titleLabel.textAlignment = UITextAlignmentCenter;
		titleLabel.textColor = [UIColor whiteColor];

		self.navigationItem.titleView = titleLabel;
	}	
	titleLabel.text = NSLocalizedString(@"Sign in with...", @"");
	
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] 
									 initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
									  target:[self navigationController].parentViewController
									 action:@selector(cancelButtonPressed:)] autorelease];

	self.navigationItem.rightBarButtonItem = cancelButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;
	
	UIBarButtonItem *placeholderItem = [[[UIBarButtonItem alloc] 
										initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
										target:nil
										action:nil] autorelease];

	placeholderItem.width = 85;
	self.navigationItem.leftBarButtonItem = placeholderItem;
	
	if (!infoBar)
	{
		if (!sessionData || [sessionData hidePoweredBy])
			infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, 388, 320, 30) andStyle:JRInfoBarStyleHidePoweredBy];
		else
			infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, 388, 320, 30) andStyle:JRInfoBarStyleShowPoweredBy];
		[self.view addSubview:infoBar];
	}

	DLog(@"prov count = %d", [sessionData.configedProviders count]);
	
	/* If the user calls the library before the session data object is done initializing - 
	   because either the requests for the base URL or provider list haven't returned - 
	   display the "Loading Providers" label and activity spinner. 
	   sessionData = nil when the call to get the base URL hasn't returned
	   [sessionData.configuredProviders count] = 0 when the provider list hasn't returned */
	if (!sessionData || [sessionData.configedProviders count] == 0)
	{
		[myActivitySpinner setHidden:NO];
		[myLoadingLabel setHidden:NO];
		
		[myActivitySpinner startAnimating];
		
		/* Now poll every few milliseconds, for about 16 seconds, until the provider list is loaded or we time out. */
		[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkSessionDataAndProviders:) userInfo:nil repeats:NO];
	}
	else 
	{
		[myTableView reloadData];
		[infoBar fadeIn];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[(JRModalNavigationController*)[self navigationController].parentViewController dismissModalNavigationController:NO];	
}

/* If the user calls the library before the session data object is done initializing - 
   because either the requests for the base URL or provider list haven't returned - 
   keep polling every few milliseconds, for about 16 seconds, 
   until the provider list is loaded or we time out. */
- (void)checkSessionDataAndProviders:(NSTimer*)theTimer
{
	static NSTimeInterval interval = 0.125;
	interval = interval * 2;
	
	DLog(@"prov count = %d", [sessionData.configedProviders count]);
	DLog(@"interval = %f", interval);
	
	/* If sessionData was nil in viewDidLoad and viewWillAppear, but it isn't nil now, set the sessionData variable. */
	if (!sessionData && [((JRModalNavigationController*)[[self navigationController] parentViewController]) sessionData])
		sessionData = [[((JRModalNavigationController*)[[self navigationController] parentViewController]) sessionData] retain];	

	/* If we have our list of providers, stop the progress indicators and load the table. */
	if ([sessionData.configedProviders count] != 0)
	{
		[myActivitySpinner stopAnimating];
		[myActivitySpinner setHidden:YES];
		[myLoadingLabel setHidden:YES];
		
		[myTableView reloadData];
	
		return;
	}
	
	/* Otherwise, keep polling until we've timed out. */
	if (interval >= 8.0)
	{	
		DLog(@"No Available Providers");

		[myActivitySpinner setHidden:YES];
		[myLoadingLabel setHidden:YES];
		[myActivitySpinner stopAnimating];
		
		UIApplication* app = [UIApplication sharedApplication]; 
		app.networkActivityIndicatorVisible = YES;
			
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"No Available Providers"
														 message:@"There seems to be a problem connecting.  Please try again later."
														delegate:self
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil] autorelease];
		[alert show];
		return;
	}
	
	[NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(checkSessionDataAndProviders:) userInfo:nil repeats:NO];
}

- (void)viewDidAppear:(BOOL)animated 
{
	[super viewDidAppear:animated];
	
	// TODO: Only compile in debug version
	NSArray *vcs = [self navigationController].viewControllers;
	DLog(@"");
	for (NSObject *vc in vcs)
	{
		DLog(@"view controller: %@", [vc description]);
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	// return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

/* Footer makes room for info bar.  If info bar is removed, remove the footer as well. */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 37)] autorelease];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 37;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section 
{
	return [sessionData.configedProviders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCellProviders *cell = 
	(UITableViewCellProviders*)[tableView dequeueReusableCellWithIdentifier:@"cachedCell"];
	
	if (cell == nil)
		cell = [[[UITableViewCellProviders alloc] 
				 initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cachedCell"] autorelease];
	
	// TODO: Add error handling for the case where there may be an error retrieving the provider stats.
	// Shouldn't happen, unless the response from rpxnow becomes malformed in the future, but just in case.
	NSString *provider = [sessionData.configedProviders objectAtIndex:indexPath.row];
	NSDictionary* provider_stats = [sessionData.allProviders objectForKey:provider];
	
	NSString *friendly_name = [provider_stats objectForKey:@"friendly_name"];
	NSString *imagePath = [NSString stringWithFormat:@"jrauth_%@_icon.png", provider];
	
	DLog(@"cell for %@", provider);

#if __IPHONE_3_0
	cell.textLabel.text = friendly_name;
#else
	cell.text = friendly_name;
#endif

#if __IPHONE_3_0
	// TODO: Add error handling in the case that the icon can't be loaded. (Like moving the textLabel over?)
	// Shouldn't happen, but just in case.
	cell.imageView.image = [UIImage imageNamed:imagePath];
#else
	cell.image = [UIImage imageNamed:imagePath];
#endif

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	/* Let sessionData know which provider the user selected */
	NSString *provider = [sessionData.configedProviders objectAtIndex:indexPath.row];
	[sessionData setProvider:[NSString stringWithString:provider]];

	DLog(@"cell for %@ was selected", provider);

	/* If the selected provider requires input from the user, go to the user landing view.
	   Or if the user started on the user landing page, went back to the list of providers, then selected 
	   the same provider as their last-used provider, go back to the user landing view. */
	if (sessionData.currentProvider.providerRequiresInput || [provider isEqualToString:sessionData.returningProvider.name]) 
	{	
		[[self navigationController] pushViewController:((JRModalNavigationController*)[self navigationController].parentViewController).myUserLandingController
											   animated:YES]; 
	}
	/* Otherwise, go straight to the web view. */
	else
	{
		[[self navigationController] pushViewController:((JRModalNavigationController*)[self navigationController].parentViewController).myWebViewController
											   animated:YES]; 
	}	
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewWillDisappear:(BOOL)animated
{
	[infoBar fadeOut];
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload	
{
	[super viewDidUnload];
}

- (void)dealloc 
{
	DLog(@"");

	[jrAuth release];
	[sessionData release];

	[myTableView release];
	[myLoadingLabel release];
	[myActivitySpinner release];
	[infoBar release];
    
	[super dealloc];
}

@end
