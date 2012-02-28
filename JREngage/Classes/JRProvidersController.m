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

 File:   JRProvidersController.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "JRProvidersController.h"
#import "JREngage+CustomInterface.h"

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface UITableViewCellProviders : UITableViewCell { }
@end

@implementation UITableViewCellProviders

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) { }

    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];

    self.imageView.frame = CGRectMake(10, 10, 30, 30);
    self.textLabel.frame = CGRectMake(50, 15, 100, 22);
}
@end

@interface JRProvidersController ()
@property (retain) NSMutableArray *providers;
@end

@implementation JRProvidersController
@synthesize providers;
@synthesize hidesCancelButton;
@synthesize myBackgroundView;
@synthesize myTableView;
@synthesize myLoadingLabel;
@synthesize myActivitySpinner;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil andCustomInterface:(NSDictionary*)theCustomInterface
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        sessionData     = [JRSessionData jrSessionData];
        customInterface = [theCustomInterface retain];

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

 /* If there is a UIColor object set for the background color, use this */
    if ([customInterface objectForKey:kJRAuthenticationBackgroundColor])
        myBackgroundView.backgroundColor = [customInterface objectForKey:kJRAuthenticationBackgroundColor];

 /* Weird hack necessary on the iPad, as the iPad table views have some background view that is always gray */
    if ([myTableView respondsToSelector:@selector(setBackgroundView:)])
        [myTableView setBackgroundView:nil];

    titleView = [customInterface objectForKey:kJRProviderTableTitleView];

    if (!titleView)
    {
        UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)] autorelease];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];

        if ([customInterface objectForKey:kJRProviderTableTitleString])
             titleLabel.text = NSLocalizedString([customInterface objectForKey:kJRProviderTableTitleString], @"");
        else
             titleLabel.text = NSLocalizedString(@"Sign in with...", @"");

        titleView = titleLabel;
    }

    self.navigationItem.titleView = titleView;
    myTableView.tableHeaderView   = [customInterface objectForKey:kJRProviderTableHeaderView];
    myTableView.tableFooterView   = [customInterface objectForKey:kJRProviderTableFooterView];

    if (!hidesCancelButton)
    {
        UIBarButtonItem *cancelButton =
                [[[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target:sessionData
                                             action:@selector(triggerAuthenticationDidCancel:)] autorelease];

        self.navigationItem.leftBarButtonItem         = cancelButton;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem.style   = UIBarButtonItemStyleBordered;
    }

    if (!infoBar)
    {
        infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 30)
                                          andStyle:(JRInfoBarStyle)[sessionData hidePoweredBy]];

        [self.view addSubview:infoBar];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    DLog(@"");
    [super viewWillAppear:animated];

// /* We need to figure out if the user canceled authentication by hitting the back button or the cancel button,
//    or if it stopped because it failed or completed successfully on its own.  Assume that the user did hit the
//    back button until told otherwise. */
//  userHitTheBackButton = YES;

 /* Load the custom background view, if there is one. */
    if ([customInterface objectForKey:kJRAuthenticationBackgroundImageView])
        [myBackgroundView addSubview:[customInterface objectForKey:kJRAuthenticationBackgroundImageView]];

    CGFloat tableAndSectionHeaderHeight = 0;
    if (myTableView.tableHeaderView)
        tableAndSectionHeaderHeight += myTableView.tableHeaderView.frame.size.height;

    tableAndSectionHeaderHeight += [self tableView:myTableView heightForHeaderInSection:0];

    if (tableAndSectionHeaderHeight)
    {
        DLog ("self.frame: %f %f", self.view.frame.size.width, self.view.frame.size.height);

        CGFloat loadingLabelAndSpinnerVerticalOffset =
                        ((self.view.frame.size.height - tableAndSectionHeaderHeight) / 2) + tableAndSectionHeaderHeight;

        [myLoadingLabel setFrame:
                CGRectMake(myLoadingLabel.frame.origin.x,
                           loadingLabelAndSpinnerVerticalOffset - 40,
                           myLoadingLabel.frame.size.width,
                           myLoadingLabel.frame.size.height)];
        [myActivitySpinner setFrame:
                CGRectMake(myActivitySpinner.frame.origin.x,
                           loadingLabelAndSpinnerVerticalOffset,
                           myActivitySpinner.frame.size.width,
                           myActivitySpinner.frame.size.height)];

        DLog ("label.frame: %f, %f", myLoadingLabel.frame.origin.x, myLoadingLabel.frame.origin.y);
    }

    if ([[sessionData basicProviders] count] > 0)
    {
        [self setProviders:[NSMutableArray arrayWithArray:sessionData.basicProviders]];
        [providers removeObjectsInArray:[customInterface objectForKey:kJRRemoveProvidersFromAuthentication]];

        [myActivitySpinner stopAnimating];
        [myActivitySpinner setHidden:YES];
        [myLoadingLabel setHidden:YES];

     /* Load the table with the list of providers. */
        [myTableView reloadData];
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

- (void)viewDidAppear:(BOOL)animated
{
    DLog(@"");
    [super viewDidAppear:animated];

    self.contentSizeForViewInPopover = CGSizeMake(320, 416);

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
        [self setProviders:[NSMutableArray arrayWithArray:sessionData.basicProviders]];
        [providers removeObjectsInArray:[customInterface objectForKey:kJRRemoveProvidersFromAuthentication]];

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

    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self
                                           selector:@selector(checkSessionDataAndProviders:)
                                           userInfo:nil repeats:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    DLog(@"");
    if (sessionData.canRotate)
        return YES;

    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString([customInterface objectForKey:kJRProviderTableSectionHeaderTitleString], @"");
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([customInterface objectForKey:kJRProviderTableSectionHeaderView])
        return ((UIView*)[customInterface objectForKey:kJRProviderTableSectionHeaderView]).frame.size.height;
    else if ([customInterface objectForKey:kJRProviderTableSectionHeaderTitleString])
        return 35;

    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [customInterface objectForKey:kJRProviderTableSectionHeaderView];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return NSLocalizedString([customInterface objectForKey:kJRProviderTableSectionFooterTitleString], @"");
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat infoBarHeight = sessionData.hidePoweredBy ? 0.0 : infoBar.frame.size.height;

    if ([customInterface objectForKey:kJRProviderTableSectionFooterView])
        return ((UIView*)[customInterface objectForKey:kJRProviderTableSectionFooterView]).frame.size.height +
                infoBarHeight;
    else if ([customInterface objectForKey:kJRProviderTableSectionFooterTitleString])
        return 35 + infoBarHeight;

    return 0 + infoBarHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([customInterface objectForKey:kJRProviderTableSectionFooterView])
        return [customInterface objectForKey:kJRProviderTableSectionFooterView];
    else if (![customInterface objectForKey:kJRProviderTableSectionFooterTitleString])
        return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, myTableView.frame.size.width, infoBar.frame.size.height)] autorelease];
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [providers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"");

    UITableViewCellProviders *cell =
        (UITableViewCellProviders*)[tableView dequeueReusableCellWithIdentifier:@"cachedCell"];

    if (cell == nil)
        cell = [[[UITableViewCellProviders alloc]
                 initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cachedCell"] autorelease];

    JRProvider* provider = [sessionData getProviderNamed:[providers objectAtIndex:indexPath.row]];

    if (!provider)
        return cell;

    NSString *imagePath = [NSString stringWithFormat:@"icon_%@_30x30.png", provider.name];

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
    JRProvider *provider = [sessionData getProviderNamed:[providers objectAtIndex:indexPath.row]];
    [sessionData setCurrentProvider:provider];

    DLog(@"cell for %@ was selected", provider);

//    userHitTheBackButton = NO;

    // TODO: Change me (comment)!
 /* If the selected provider requires input from the user, go to the user landing view.
    Or if the user started on the user landing page, went back to the list of providers, then selected
    the same provider as their last-used provider, go back to the user landing view. */
    if (provider.requiresInput ||
        ([sessionData authenticatedUserForProvider:provider] && !(provider.forceReauth || sessionData.alwaysForceReauth)))
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

//    if (hidesCancelButton && userHitTheBackButton)
//        [sessionData triggerAuthenticationDidCancel];
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
    [providers release];

    [super dealloc];
}
@end
