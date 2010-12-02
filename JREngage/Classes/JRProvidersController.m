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
//	UIImageView *icon;
}

//@property (nonatomic, retain) UIImageView *icon;

@end

@implementation UITableViewCellProviders

//@synthesize icon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
//		[self addSubview:icon];
	}
	
	return self;
}	

- (void) layoutSubviews 
{
	[super layoutSubviews];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.imageView.frame = CGRectMake(15, 15, 70, 70);
        self.textLabel.frame = CGRectMake(100, 22, 300, 60);
        self.textLabel.font = [UIFont systemFontOfSize:36];
    }
    else
    {	
        self.imageView.frame = CGRectMake(10, 10, 30, 30);
        self.textLabel.frame = CGRectMake(50, 15, 100, 22);
    }
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
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	DLog(@"");
	[super viewDidLoad];
	sessionData = [JRSessionData jrSessionData];
	titleLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated 
{
	DLog(@"");
	[super viewWillAppear:animated];
	
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
									  target:sessionData
                                      action:@selector(triggerAuthenticationDidCancel:)] autorelease];

	self.navigationItem.rightBarButtonItem = cancelButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;
	
	UIBarButtonItem *placeholderItem = [[[UIBarButtonItem alloc] 
										initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
										target:nil
										action:nil] autorelease];

	placeholderItem.width = 85;
	self.navigationItem.leftBarButtonItem = placeholderItem;
	
    // TODO: Instead of removing the infoBar for iPad, fix it!
	if (!infoBar)
	{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, 890, 768, 72) andStyle:[sessionData hidePoweredBy] | JRInfoBarStyleiPad];
        else
            infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, 388, 320, 30) andStyle:[sessionData hidePoweredBy]];
        
        if ([sessionData hidePoweredBy] == JRInfoBarStyleShowPoweredBy)
            [myTableView setFrame:CGRectMake(myTableView.frame.origin.x,
                                             myTableView.frame.origin.y, 
                                             myTableView.frame.size.width, 
                                             myTableView.frame.size.height - infoBar.frame.size.height)];
        
		[self.view addSubview:infoBar];
	}
}


- (void)viewDidAppear:(BOOL)animated 
{
	DLog(@"");
	[super viewDidAppear:animated];
	
    if ([[sessionData basicProviders] count] > 0)
    {
        [myActivitySpinner stopAnimating];
        [myActivitySpinner setHidden:YES];
        [myLoadingLabel setHidden:YES];
        
        /* Load the table with the list of providers. */
        [myTableView reloadData];    
		[infoBar fadeIn];
    }
    else
    {
        DLog(@"prov count = %d", [[sessionData basicProviders] count]);
        
        /* If the user calls the library before the session data object is done initializing - 
         because either the requests for the base URL or provider list haven't returned - 
         display the "Loading Providers" label and activity spinner. 
         sessionData = nil when the call to get the base URL hasn't returned
         [sessionData.configuredProviders count] = 0 when the provider list hasn't returned */
        [myActivitySpinner setHidden:NO];
        [myLoadingLabel setHidden:NO];
        
        [myActivitySpinner startAnimating];
        
        /* Now poll every few milliseconds, for about 16 seconds, until the provider list is loaded or we time out. */
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkSessionDataAndProviders:) userInfo:nil repeats:NO];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [sessionData triggerAuthenticationDidTimeOutConfiguration];
}

/* If the user calls the library before the session data object is done initializing - 
   because either the requests for the base URL or provider list haven't returned - 
   keep polling every few milliseconds, for about 16 seconds, 
   until the provider list is loaded or we time out. */
- (void)checkSessionDataAndProviders:(NSTimer*)theTimer
{
    DLog(@"");
    static NSTimeInterval interval = 0.5;
	interval = interval + 0.5;
	
    timer = nil;
    
	DLog(@"prov count = %d", [[sessionData basicProviders] count]);
	DLog(@"interval = %f", interval);
    
    /* If we have our list of providers, stop the progress indicators and load the table. */
	if ([[sessionData basicProviders] count] > 0)
	{
		
        [myActivitySpinner stopAnimating];
		[myActivitySpinner setHidden:YES];
		[myLoadingLabel setHidden:YES];
		       
		[myTableView reloadData];
	
		return;
	}
	
	/* Otherwise, keep polling until we've timed out. */
	if (interval >= 16.0)
	{	
		DLog(@"No Available Providers");

		[myActivitySpinner setHidden:YES];
		[myLoadingLabel setHidden:YES];
		[myActivitySpinner stopAnimating];
		
		UIApplication* app = [UIApplication sharedApplication]; 
		app.networkActivityIndicatorVisible = YES;
			
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"No Available Providers" message:

@"There are no available providers. \
Either there is a problem connecting \
or no providers have been configured. \
Please try again later."

														delegate:self
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil] autorelease];
		[alert show];
		return;
	}
	
	timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkSessionDataAndProviders:) userInfo:nil repeats:NO];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	// return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

/* Footer makes room for info bar.  If info bar is removed, remove the footer as well. */
// QTS: Or do we keep it here because the info bar pops up when loading?
// QTS: Do we need this or does setting the heightForFooterInSection acheive this?
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 37)] autorelease];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 37;
    else
        return 37;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 100;
    else
        return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section 
{
	return [[sessionData basicProviders] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCellProviders *cell = 
        (UITableViewCellProviders*)[tableView dequeueReusableCellWithIdentifier:@"cachedCell"];
	
	if (cell == nil)
		cell = [[[UITableViewCellProviders alloc] 
				 initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cachedCell"] autorelease];
	
	JRProvider* provider = [sessionData getBasicProviderAtIndex:indexPath.row];

    if (!provider)
        return cell;
	
    NSString *imagePath = [NSString stringWithFormat:@"jrauth_%@_icon.png", provider.name];

	cell.textLabel.text = provider.friendlyName;
	cell.imageView.image = [UIImage imageNamed:imagePath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
    [cell layoutSubviews];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"");
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	/* Let sessionData know which provider the user selected */
	JRProvider *provider = [[sessionData getBasicProviderAtIndex:indexPath.row] retain];
    [sessionData setCurrentProvider:provider];

    DLog(@"cell for %@ was selected", provider);

    /* If the selected provider requires input from the user, go to the user landing view.
       Or if the user started on the user landing page, went back to the list of providers, then selected 
       the same provider as their last-used provider, go back to the user landing view. */
    if (provider.requiresInput || [provider isEqualToReturningProvider:sessionData.returningBasicProvider]) 
    {	
        [[self navigationController] pushViewController:[JRUserInterfaceMaestro jrUserInterfaceMaestro].myUserLandingController
                                               animated:YES]; 
    }
    /* Otherwise, go straight to the web view. */
    else
    {
        [[self navigationController] pushViewController:[JRUserInterfaceMaestro jrUserInterfaceMaestro].myWebViewController
                                               animated:YES]; 
    }
    
    [provider release];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewWillDisappear:(BOOL)animated
{
    DLog(@"");
    [infoBar fadeOut];
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    DLog(@"");
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload	
{
    DLog(@"");
    [super viewDidUnload];
}

- (void)userInterfaceWillClose
{
    [timer invalidate];
}
     
- (void)userInterfaceDidClose
{
 
}

- (void)dealloc 
{
	DLog(@"");

	[myTableView release];
	[myLoadingLabel release];
	[myActivitySpinner release];
	[infoBar release];
    
	[super dealloc];
}

@end
