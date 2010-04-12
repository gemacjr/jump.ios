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

@synthesize myUserLandingController;
@synthesize myWebViewController;

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

- (void)viewWillAppear:(BOOL)animated 
{
    printf("viewwillappear\n");
	[super viewWillAppear:animated];
	
	self.title = @"Providers";

	int yPos = (self.view.frame.size.height - 20);

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
	
	if (!bar)
	{
		bar = [[UIImageView alloc] initWithFrame:CGRectMake(0, yPos, 320, 20)];
		bar.image = [UIImage imageNamed:@"info_bar.png"];
		[self.view addSubview:bar];
	}
	
	if (!powered_by)
	{
		powered_by = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, 320, 20)];
		powered_by.backgroundColor = [UIColor clearColor];
		powered_by.font = [UIFont italicSystemFontOfSize:14.0];
		powered_by.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
		powered_by.shadowColor = [UIColor colorWithWhite:0.8 alpha:0.8];
		powered_by.shadowOffset = CGSizeMake(1.0, 1.0);
		powered_by.textAlignment = UITextAlignmentCenter;
		powered_by.text = @"Powered by RPX";
		[self.view addSubview:powered_by];
	}
	
	if (!info)
	{
		info = [UIButton buttonWithType:UIButtonTypeInfoDark];
		info.frame = CGRectMake(304, yPos+4, 15, 15);
		[info addTarget:self
				 action:@selector(getInfo) 
	   forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:info];
	}
	
	printf("prov count = %d\n", [sessionData.configedProviders count]);
	if ([sessionData.configedProviders count] == 0)
	{
		[myActivitySpinner setHidden:NO];
		[myLoadingLabel setHidden:NO];
		
		[myActivitySpinner startAnimating];
		[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkProviders:) userInfo:nil repeats:NO];
	}
	else 
	{
		[myTableView reloadData];
	}
}

- (void)getInfo
{
	UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"JanRain Authenticate Library\nVersion 0.1.5"
														delegate:self
											   cancelButtonTitle:@"OK"  
										  destructiveButtonTitle:nil
											   otherButtonTitles:nil];
	[action showInView:self.view];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[(JRModalNavigationController*)[self navigationController].parentViewController dismissModalNavigationController:NO];	
}


- (void)checkProviders:(NSTimer*)theTimer
{
	static NSTimeInterval interval = 0.125;
	interval = interval * 2;
	
	printf("prov count = %d\n", [sessionData.configedProviders count]);
	printf("interval = %f\n", interval);
	
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
		printf("alert!\n");

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


- (void)viewDidAppear:(BOOL)animated {
	NSArray *vcs = [self navigationController].viewControllers;
	printf("\nvc list\n");
	for (NSObject *vc in vcs)
	{
		printf("vc: %s\n", [[vc description] cString] );
	}
    
	[super viewDidAppear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
	
	jrAuth = [[JRAuthenticate jrAuthenticate] retain];
	
	sessionData = [[((JRModalNavigationController*)[[self navigationController] parentViewController]) sessionData] retain];

    printf("viewdidload\n");
	printf("prov count = %d\n", [sessionData.configedProviders count]);
		
	label = nil;
	bar = nil;
	powered_by = nil;
	info = nil;
	
	
	if (sessionData.returningProvider)
	{
//		[self loadProviderStats:sessionData.returning_provider];

//		[sessionData setProvider:[NSString stringWithString:sessionData.returning_provider]];
		[sessionData setCurrentProviderToReturningProvider];
		
		
		[[self navigationController] pushViewController:((JRModalNavigationController*)[self navigationController].parentViewController).myUserLandingController
												animated:NO]; 

		
//		myUserLandingController = [JRUserLandingController alloc];
//		
//		[[self navigationController] pushViewController:myUserLandingController animated:NO];
	}
	
	[myTableView reloadData];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	
	if (sessionData.currentProvider.providerRequiresInput || [provider isEqualToString:sessionData.returningProvider.name]) 
	{	
		[[self navigationController] pushViewController:((JRModalNavigationController*)[self navigationController].parentViewController).myUserLandingController
											   animated:YES]; 
		
//		
//		if (!myUserLandingController)
//			myUserLandingController = [JRUserLandingController alloc];
//		
//		[[self navigationController] pushViewController:myUserLandingController animated:YES];
	}
	else
	{
		[[self navigationController] pushViewController:((JRModalNavigationController*)[self navigationController].parentViewController).myWebViewController
											   animated:YES]; 
		
		
//		if (!myWebViewController)
//			myWebViewController = [JRWebViewController alloc];
//		
//		[[self navigationController] pushViewController:myWebViewController animated:YES];
	}	
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

//- (void)viewDidUnload {
//	// Release any retained subviews of the main view.
//	// e.g. self.myOutlet = nil;
//}

//- (void)viewWillDisappear:(BOOL)animated
//{
//
//}


- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)dealloc 
{
	[myTableView release];
	[myLoadingLabel release];
	[myActivitySpinner release];

	[myUserLandingController release];
	[myWebViewController release];

	[jrAuth release];
    
	[super dealloc];
}


@end
