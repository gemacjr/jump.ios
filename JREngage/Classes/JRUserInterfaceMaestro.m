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
 
 File:	 JRUserInterfaceMaestro.m 
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, August 24, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#import "JRUserInterfaceMaestro.h"


@interface JRModalNavigationController : UIViewController 
{
	UINavigationController	*navigationController;
    
	BOOL shouldUnloadSubviews;
}
@property (retain) UINavigationController *navigationController;

- (id)initWithRootViewController:(UIViewController*)controller;

- (void)presentModalNavigationControllerForAuthentication;
//- (void)presentModalNavigationControllerForPublishingActivity;
- (void)dismissModalNavigationController:(UIModalTransitionStyle)style;
@end

@implementation JRModalNavigationController
@synthesize navigationController;

- (id)initWithRootViewController:(UIViewController*)controller
{
	if (controller == nil)
	{
		[self release];
		return nil;
	}
	
	if (self = [super init]) 
	{
        navigationController = [[UINavigationController alloc] 
                                initWithRootViewController:controller];    
        navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;   
        navigationController.navigationBar.clipsToBounds = YES;
    }
    
    return self;
}

- (void)loadView  
{
	UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    shouldUnloadSubviews = NO;
    
    [view setHidden:YES];
	[self setView:view];
    [view release];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [self retain]; // QTS: Why am I retaining myself??
}

//- (void)presentModalNavigationControllerForPublishingActivity
//{
//	navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
//	[self presentModalViewController:navigationController animated:YES];
//}

- (void)presentModalNavigationControllerForAuthentication
{
//    navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;//UIModalTransitionStyleCoverVertical;
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentModalViewController:navigationController animated:YES];
}

- (void)restore:(BOOL)animated
{
	[navigationController popToRootViewControllerAnimated:animated];
}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];

	if (shouldUnloadSubviews)
    {
        [self.view removeFromSuperview];
		[self release];
    }    
}

- (void)dismissModalNavigationController:(UIModalTransitionStyle)style
{
    shouldUnloadSubviews = YES;
    navigationController.modalTransitionStyle = style;
    [self.view setHidden:NO];
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return YES;
}

- (void)dealloc 
{
    [navigationController release];
    
	[super dealloc];
}
@end


@interface JRUserInterfaceMaestro ()
@property (retain) UINavigationController	*customNavigationController;
@property (retain) NSDictionary             *persistentCustomUI;
@end

@implementation JRUserInterfaceMaestro
@synthesize myProvidersController;
@synthesize myUserLandingController;
@synthesize myWebViewController;
@synthesize myPublishActivityController;
@synthesize customNavigationController;
@synthesize persistentCustomUI;

static JRUserInterfaceMaestro* singleton = nil;
+ (JRUserInterfaceMaestro*)jrUserInterfaceMaestro
{
	return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self jrUserInterfaceMaestro] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

- (id)initWithSessionData:(JRSessionData*)_sessionData
{
	if (self = [super init]) 
	{
        singleton = self;
        sessionData = _sessionData;
    }
    
	return self;
}

+ (JRUserInterfaceMaestro*)jrUserInterfaceMaestroWithSessionData:(JRSessionData*)_sessionData
{
	if(singleton)
		return singleton;
	
	if (_sessionData == nil)
		return nil;
    
	return [[super allocWithZone:nil] initWithSessionData:_sessionData];
}	

- (void)pushToCustomNavigationController:(UINavigationController*)_navigationController
{
    self.customNavigationController = _navigationController;
//    [navigationController release];
//    navigationController = [_navigationController retain];
}

- (void)buildCustomInterface:(NSDictionary*)customizations
{
    NSDictionary *infoPlist = [NSDictionary dictionaryWithContentsOfFile: 
                               [[[NSBundle mainBundle] resourcePath] 
                                stringByAppendingPathComponent:@"/JREngage-Info.plist"]];

    // TODO: Doesn't need to be so big
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:([customizations count] + [infoPlist count] + [persistentCustomUI count])];

    [dict addEntriesFromDictionary:[[infoPlist objectForKey:@"JREngage.CustomInterface"] objectForKey:@"DefaultValues"]];
    [dict addEntriesFromDictionary:[[infoPlist objectForKey:@"JREngage.CustomInterface"] objectForKey:@"CustomValues"]];
    [dict addEntriesFromDictionary:persistentCustomUI];
    [dict addEntriesFromDictionary:customizations];

    customUI = [[NSDictionary alloc] initWithDictionary:dict];
}

- (void)setCustomViews:(NSDictionary*)views
{
    self.persistentCustomUI = views;
}

- (void)setUpViewControllers
{
    DLog(@"");
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        myProvidersController       = [[JRProvidersController alloc] initWithNibName:@"JRProvidersController-iPad" 
                                                                              bundle:[NSBundle mainBundle]
                                                                         andCustomUI:customUI];
    
        myUserLandingController     = [[JRUserLandingController alloc] initWithNibName:@"JRUserLandingController-iPad"
                                                                                bundle:[NSBundle mainBundle]
                                                                           andCustomUI:customUI];
        
        myWebViewController         = [[JRWebViewController alloc] initWithNibName:@"JRWebViewController-iPad"
                                                                            bundle:[NSBundle mainBundle]
                                                                       andCustomUI:customUI];
        
        myPublishActivityController = [[JRPublishActivityController alloc] initWithNibName:@"JRPublishActivityController-iPad"
                                                                                    bundle:[NSBundle mainBundle]
                                                                               andCustomUI:customUI];
    }
    else
    {
        myProvidersController       = [[JRProvidersController alloc] initWithNibName:@"JRProvidersController" 
                                                                              bundle:[NSBundle mainBundle]
                                                                         andCustomUI:customUI];
        
        myUserLandingController     = [[JRUserLandingController alloc] initWithNibName:@"JRUserLandingController"
                                                                                bundle:[NSBundle mainBundle]
                                                                           andCustomUI:customUI];
        
        myWebViewController         = [[JRWebViewController alloc] initWithNibName:@"JRWebViewController"
                                                                            bundle:[NSBundle mainBundle]
                                                                       andCustomUI:customUI];
        
        myPublishActivityController = [[JRPublishActivityController alloc] initWithNibName:@"JRPublishActivityController"
                                                                                    bundle:[NSBundle mainBundle]
                                                                               andCustomUI:customUI];
    }

    /* We do this here, because sometimes we pop straight to the user landing controller and we need the back-button's title to be correct */
    if ([[customUI objectForKey:kJRProviderTableTitleString] isKindOfClass:[NSString class]])
        myProvidersController.title = [customUI objectForKey:kJRProviderTableTitleString];
    else
        myProvidersController.title = @"Providers";
    
    delegates = [[NSMutableArray alloc] initWithObjects:myProvidersController, 
                 myUserLandingController, 
                 myWebViewController, 
                 myPublishActivityController, nil];
    
    sessionData.dialogIsShowing = YES;
}

- (void)tearDownViewControllers
{
    DLog(@"");

    [delegates removeAllObjects];
    [delegates release], delegates = nil;
    
    [myProvidersController release],        myProvidersController = nil;
    [myUserLandingController release],      myUserLandingController = nil;
    [myWebViewController release],          myWebViewController = nil;
    [myPublishActivityController release],  myPublishActivityController = nil;    
    
    [jrModalNavController release],	jrModalNavController = nil;	   

    [customUI release], customUI = nil;
    
    sessionData.dialogIsShowing = NO;
}

- (void)setUpSocialPublishing
{
    DLog(@"");
    [sessionData setSocialSharing:YES];
    
    if (myPublishActivityController)
        [sessionData addDelegate:myPublishActivityController];
}

- (void)tearDownSocialPublishing
{
    DLog(@"");
    [sessionData setSocialSharing:NO];
    [sessionData setActivity:nil];
    
    if (myPublishActivityController)
        [sessionData removeDelegate:myPublishActivityController];
}

- (void)tintBar
{
    NSArray *tintArray = [customUI objectForKey:kJRNavigationBarTintColorRGBa];
    UIColor *tintColor = [customUI objectForKey:kJRNavigationBarTintColor];
    
    if (tintColor)
        [jrModalNavController.navigationController.navigationBar setTintColor:tintColor];
    else if (tintArray)
        if ([tintArray respondsToSelector:@selector(count)])
            if ([tintArray count] == 4)
                [jrModalNavController.navigationController.navigationBar setTintColor: 
                    [UIColor colorWithRed:[(NSNumber*)[tintArray objectAtIndex:0] doubleValue]
                                    green:[(NSNumber*)[tintArray objectAtIndex:1] doubleValue]
                                     blue:[(NSNumber*)[tintArray objectAtIndex:2] doubleValue]
                                    alpha:[(NSNumber*)[tintArray objectAtIndex:3] doubleValue]]];
}

- (void)loadModalNavigationControllerWithViewController:(UIViewController*)controller
{
    DLog(@"");
    if (!jrModalNavController)
		jrModalNavController = [[JRModalNavigationController alloc] initWithRootViewController:controller];
	
    [self tintBar];
    
    if (sessionData.returningBasicProvider && !sessionData.currentProvider && ![sessionData socialSharing])
    {   
        [sessionData setCurrentProvider:[sessionData getProviderNamed:sessionData.returningBasicProvider]];
        [jrModalNavController.navigationController pushViewController:myUserLandingController animated:NO];
    }
   
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) 
	{
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
    [window addSubview:jrModalNavController.view];
	
	[jrModalNavController presentModalNavigationControllerForAuthentication];    
}

- (void)loadCustomNavigationControllerWithViewController:(UIViewController*)controller
{
    DLog(@"");
    if (!viewControllerToPopTo)
        viewControllerToPopTo = [[customNavigationController topViewController] retain];

    if (sessionData.returningBasicProvider && !sessionData.currentProvider && ![sessionData socialSharing])
    {   
        [sessionData setCurrentProvider:[sessionData getProviderNamed:sessionData.returningBasicProvider]];
        [customNavigationController pushViewController:controller animated:NO];
        [customNavigationController pushViewController:myUserLandingController animated:YES];
    }
    else
    {
        [customNavigationController pushViewController:controller animated:YES];
    }
}

- (void)showAuthenticationDialogWithCustomInterface:(NSDictionary*)customizations
{
    DLog(@"");
    [self buildCustomInterface:customizations];
    [self setUpViewControllers];

    if (customNavigationController && [customNavigationController isViewLoaded])
        [self loadCustomNavigationControllerWithViewController:myProvidersController];
    else
        [self loadModalNavigationControllerWithViewController:myProvidersController];
}

- (void)showPublishingDialogForActivityWithCustomInterface:(NSDictionary*)customizations
{   
    DLog(@"");
    [self buildCustomInterface:customizations];
    [self setUpViewControllers];	
    [self setUpSocialPublishing];
    
    if (customNavigationController && [customNavigationController isViewLoaded])
        [self loadCustomNavigationControllerWithViewController:myPublishActivityController];
    else
        [self loadModalNavigationControllerWithViewController:myPublishActivityController];
}

- (void)unloadModalNavigationControllerWithTransitionStyle:(UIModalTransitionStyle)style
{
    DLog(@"");
    [jrModalNavController dismissModalNavigationController:style];   
}

- (void)unloadCustomNavigationController
{
    DLog(@"");
    [customNavigationController popToViewController:viewControllerToPopTo animated:YES];

    [viewControllerToPopTo release];
    viewControllerToPopTo = nil;
}

- (void)unloadUserInterfaceWithTransitionStyle:(UIModalTransitionStyle)style
{
    DLog(@"");
    if ([sessionData socialSharing])
        [self tearDownSocialPublishing];
    
    for (id<JRUserInterfaceDelegate> delegate in delegates) 
        [delegate userInterfaceWillClose];
    
    if (customNavigationController && [customNavigationController isViewLoaded])
        [self unloadCustomNavigationController];
    else
        [self unloadModalNavigationControllerWithTransitionStyle:style];
    
    for (id<JRUserInterfaceDelegate> delegate in delegates) 
        [delegate userInterfaceDidClose];
    
    [self tearDownViewControllers];
}

- (void)popToOriginalRootViewController
{
    DLog(@"");
    UIViewController *originalRootViewController = nil;
    
    if ([sessionData socialSharing])
        originalRootViewController = myPublishActivityController;
    else
        originalRootViewController = myProvidersController;
    
    if (customNavigationController && [customNavigationController isViewLoaded])
        [customNavigationController popToViewController:originalRootViewController animated:YES];
    else
        [jrModalNavController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)authenticationRestarted
{
    DLog(@"");
    
    [self popToOriginalRootViewController];    
}

- (void)authenticationCompleted
{
    DLog(@"");
    if (![sessionData socialSharing])
        [self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCrossDissolve];
    else
        [self popToOriginalRootViewController];
}

- (void)authenticationFailed
{
    DLog(@"");
    [self popToOriginalRootViewController];
}

- (void)authenticationCanceled 
{	
    DLog(@"");
    [self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCoverVertical];
}

- (void)publishingRestarted
{
    DLog(@"");
    [self popToOriginalRootViewController];   
}

- (void)publishingCompleted 
{ 
    DLog(@"");
    [self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCoverVertical];
}

- (void)publishingCanceled
{
    DLog(@"");
	[self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCoverVertical];
}

- (void)publishingFailed 
{ 
    DLog(@"");
//  [self popToOriginalRootViewController];
// 	[self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCoverVertical];
}
@end
