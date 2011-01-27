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
#import "JREngage+CustomInterface.h"

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@interface UITableViewCellProviders : UITableViewCell { }
@end

@implementation UITableViewCellProviders

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) { }
	
	return self;
}	

- (void) layoutSubviews 
{
	[super layoutSubviews];

//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        self.imageView.frame = CGRectMake(15, 15, 70, 70);
//        self.textLabel.frame = CGRectMake(100, 22, 300, 60);
//        self.textLabel.font = [UIFont systemFontOfSize:36];
//    }
//    else
//    {	
        self.imageView.frame = CGRectMake(10, 10, 30, 30);
        self.textLabel.frame = CGRectMake(50, 15, 100, 22);
//    }
}
@end

@implementation JRProvidersController
@synthesize myBackgroundView;
@synthesize myTableView;
@synthesize myLoadingLabel;
@synthesize myActivitySpinner;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil andCustomInterface:(NSDictionary*)_customInterface
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    {
        customInterface = [_customInterface retain];

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            iPad = YES;
        else
            iPad = NO;
    }

    return self;
}

- (void)viewDidLoad 
{
	DLog(@"");
	[super viewDidLoad];

	sessionData = [JRSessionData jrSessionData];
    
    NSString *iPadSuffix = (iPad) ? @"-iPad" : @"";
    NSArray *backgroundColor = [customInterface objectForKey:kJRAuthenticationBackgroundColorRGBa];
    
    /* Load the custom background view, if there is one. */
    if ([[customInterface objectForKey:[NSString stringWithFormat:@"%@%@", kJRProviderTableBackgroundImageName, iPadSuffix]] isKindOfClass:[NSString class]])
        [myBackgroundView setImage:
         [UIImage imageNamed:[customInterface objectForKey:[NSString stringWithFormat:@"%@%@", kJRProviderTableBackgroundImageName, iPadSuffix]]]];

    /* If there is a UIColor object set for the background color, use this */
    if ([customInterface objectForKey:kJRAuthenticationBackgroundColor])
        myBackgroundView.backgroundColor = [customInterface objectForKey:kJRAuthenticationBackgroundColor];
    else /* Otherwise, set the background view to the provided RGBa color, if any. */
        if ([backgroundColor respondsToSelector:@selector(count)])
            if ([backgroundColor count] == 4)
                myBackgroundView.backgroundColor = 
                [UIColor colorWithRed:[(NSNumber*)[backgroundColor objectAtIndex:0] doubleValue]
                                green:[(NSNumber*)[backgroundColor objectAtIndex:1] doubleValue]
                                 blue:[(NSNumber*)[backgroundColor objectAtIndex:2] doubleValue]
                                alpha:[(NSNumber*)[backgroundColor objectAtIndex:3] doubleValue]];
    
    myTableView.backgroundColor = [UIColor clearColor];
    
    titleView = [customInterface objectForKey:[NSString stringWithFormat:@"%@%@", kJRProviderTableTitleView, iPadSuffix]];
    
    if (!titleView)
	{
		UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)] autorelease];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
		titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
		titleLabel.textAlignment = UITextAlignmentCenter;
		titleLabel.textColor = [UIColor whiteColor];
        
		titleLabel.text = NSLocalizedString(@"Sign in with...", @"");
        titleView = (UIView*)titleLabel;
	}	
    
    self.navigationItem.titleView = titleView;
    
    if ([[customInterface objectForKey:[NSString stringWithFormat:@"%@%@", kJRProviderTableHeaderView, iPadSuffix]] isKindOfClass:[UIView class]])
         myTableView.tableHeaderView = [customInterface objectForKey:[NSString stringWithFormat:@"%@%@", kJRProviderTableHeaderView, iPadSuffix]];
    
     if ([[customInterface objectForKey:[NSString stringWithFormat:@"%@%@", kJRProviderTableFooterView, iPadSuffix]] isKindOfClass:[UIView class]])
          myTableView.tableFooterView = [customInterface objectForKey:[NSString stringWithFormat:@"%@%@", kJRProviderTableFooterView, iPadSuffix]];
    
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
    
    if (!infoBar)
	{
//        if (iPad)
//            infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, 890, 768, 72) andStyle:[sessionData hidePoweredBy] | JRInfoBarStyleiPad];
//        else
            infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, 386, 320, 30) andStyle:[sessionData hidePoweredBy]];
        
//        if (([sessionData hidePoweredBy] == JRInfoBarStyleShowPoweredBy) && !iPad)
//            [myTableView setFrame:CGRectMake(myTableView.frame.origin.x,
//                                             myTableView.frame.origin.y, 
//                                             myTableView.frame.size.width, 
//                                             myTableView.frame.size.height - infoBar.frame.size.height)];
        
		[self.view addSubview:infoBar];
	}
}

- (void)viewWillAppear:(BOOL)animated 
{
	DLog(@"");
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated 
{
	DLog(@"");
	[super viewDidAppear:animated];
	
	self.contentSizeForViewInPopover = CGSizeMake(320, 416);

    if ([[sessionData basicProviders] count] > 0)
    {
        [myActivitySpinner stopAnimating];
        [myActivitySpinner setHidden:YES];
        [myLoadingLabel setHidden:YES];
        
        /* Load the table with the list of providers. */
        [myTableView reloadData];    
		//[infoBar fadeIn];
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
    
    [infoBar fadeIn];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [customInterface objectForKey:kJRProviderTableSectionHeaderTitleString];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *iPadSuffix = (iPad) ? @"-iPad" : @"";

    if ([customInterface objectForKey:[NSString stringWithFormat:@"%@%@", kJRProviderTableSectionHeaderView, iPadSuffix]])
        return ((UIView*)[customInterface objectForKey:[NSString stringWithFormat:@"%@%@", kJRProviderTableSectionHeaderView, iPadSuffix]]).frame.size.height;
    else if ([customInterface objectForKey:kJRProviderTableSectionHeaderTitleString])
        return 35;
        
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *iPadSuffix = (iPad) ? @"-iPad" : @"";
    return [customInterface objectForKey:[NSString stringWithFormat:@"%@%@", kJRProviderTableSectionHeaderView, iPadSuffix]];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [customInterface objectForKey:kJRProviderTableSectionFooterTitleString];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSString *iPadSuffix = (iPad) ? @"-iPad" : @"";

    if ([customInterface objectForKey:[NSString stringWithFormat:@"%@%@", kJRProviderTableSectionFooterView, iPadSuffix]])
        return ((UIView*)[customInterface objectForKey:[NSString stringWithFormat:@"%@%@", kJRProviderTableSectionFooterView, iPadSuffix]]).frame.size.height +
                infoBar.frame.size.height;
    else if ([customInterface objectForKey:kJRProviderTableSectionFooterTitleString])
        return 30 + infoBar.frame.size.height;

    return 30 + infoBar.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSString *iPadSuffix = (iPad) ? @"-iPad" : @"";
    
    if ([customInterface objectForKey:[NSString stringWithFormat:@"%@%@", kJRProviderTableSectionFooterView, iPadSuffix]])
        return [customInterface objectForKey:[NSString stringWithFormat:@"%@%@", kJRProviderTableSectionFooterView, iPadSuffix]];
    else
        return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, myTableView.frame.size.width, infoBar.frame.size.height)] autorelease];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (iPad)
//        return 100;
//    else
        return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [[sessionData basicProviders] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCellProviders *cell = 
        (UITableViewCellProviders*)[tableView dequeueReusableCellWithIdentifier:@"cachedCell"];
	
	if (cell == nil)
		cell = [[[UITableViewCellProviders alloc] 
				 initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cachedCell"] autorelease];
	
	JRProvider* provider = [sessionData getBasicProviderAtIndex:indexPath.row];

    if (!provider)
        return cell;
	
    NSString *imagePath = [NSString stringWithFormat:@"icon_%@_30x30%@.png", provider.name, (iPad) ? @"@2x" : @"" ];

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
     
- (void)userInterfaceDidClose { }

- (void)dealloc 
{
	DLog(@"");
    
    [customInterface release];
    [myBackgroundView release];
	[myTableView release];
	[myLoadingLabel release];
	[myActivitySpinner release];
	[infoBar release];
    
	[super dealloc];
}

@end
