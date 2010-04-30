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


#import "JRProvidersController.h"

// TODO: Figure out why the -DDEBUG cflag isn't being set when Active Conf is set to debug
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

	label = nil;
	
	if (sessionData.returningProvider)
	{
		DLog(@"and there was a returning provider");
		[sessionData setCurrentProviderToReturningProvider];
		
		[[self navigationController] pushViewController:((JRModalNavigationController*)[self navigationController].parentViewController).myUserLandingController
											   animated:NO]; 
	}
	
	[myTableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated 
{
	DLog(@"");
	[super viewWillAppear:animated];
	
	self.title = @"Providers";

	if (!label)
	{
		label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont boldSystemFontOfSize:20.0];
		label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
		label.textAlignment = UITextAlignmentCenter;
		label.textColor = [UIColor whiteColor];

		self.navigationItem.titleView = label;
	}	
	label.text = NSLocalizedString(@"Sign in with...", @"");
	
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] 
									 initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
									  target:[self navigationController].parentViewController
									 action:@selector(cancelButtonPressed:)] autorelease];//cancelButtonPressed];

	self.navigationItem.rightBarButtonItem = cancelButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;

	UIBarButtonItem *dummyPlaceholder = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)]];
	
	self.navigationItem.leftBarButtonItem = dummyPlaceholder;
	self.navigationItem.leftBarButtonItem.enabled = NO;
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;

	if (!infoBar)
	{
		infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, 388, 320, 30)];
		[self.view addSubview:infoBar];
	}
	
	DLog(@"prov count = %d", [sessionData.configedProviders count]);
	
	if (!sessionData || [sessionData.configedProviders count] == 0)
	{
		[myActivitySpinner setHidden:NO];
		[myLoadingLabel setHidden:NO];
		
		[myActivitySpinner startAnimating];
		[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkProviders:) userInfo:nil repeats:NO];
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

- (void)checkProviders:(NSTimer*)theTimer
{
	static NSTimeInterval interval = 0.125;
	interval = interval * 2;
	
	DLog(@"prov count = %d", [sessionData.configedProviders count]);
	DLog(@"interval = %f", interval);
	
	if (!sessionData && [((JRModalNavigationController*)[[self navigationController] parentViewController]) sessionData])
		sessionData = [[((JRModalNavigationController*)[[self navigationController] parentViewController]) sessionData] retain];	

	if ([sessionData.configedProviders count] != 0)
	{
		[myActivitySpinner stopAnimating];
		[myActivitySpinner setHidden:YES];
		[myLoadingLabel setHidden:YES];
		
		[myTableView reloadData];
	
		return;
	}
	
	if (interval >= 8.0)
	{	
		DLog(@"No Available Providers");

		[myActivitySpinner setHidden:YES];
		[myLoadingLabel setHidden:YES];
		[myActivitySpinner stopAnimating];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Available Providers"
														message:@"There seems to be a problem connecting.  Please try again later."
													   delegate:self
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		return;
	}
	
	[NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(checkProviders:) userInfo:nil repeats:NO];
}

- (void)viewDidAppear:(BOOL)animated 
{
	[super viewDidAppear:animated];
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



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
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
	
	NSString *provider = [sessionData.configedProviders objectAtIndex:indexPath.row];
	[sessionData setProvider:[NSString stringWithString:provider]];

	DLog(@"cell for %@ was selected", provider);

	if (sessionData.currentProvider.providerRequiresInput || [provider isEqualToString:sessionData.returningProvider.name]) 
	{	
		[[self navigationController] pushViewController:((JRModalNavigationController*)[self navigationController].parentViewController).myUserLandingController
											   animated:YES]; 
	}
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
