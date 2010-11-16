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


#define DEBUG
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#import "JRUserInterfaceMaestro.h"

@implementation JRUserInterfaceMaestro
@synthesize navigationController;
@synthesize myProvidersController;
@synthesize myUserLandingController;
@synthesize myWebViewController;
@synthesize myPublishActivityController;

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

- (void)setUpViewControllers
{
    DLog(@"");
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        myProvidersController       = [[JRProvidersController alloc] initWithNibName:@"JRProvidersController-iPad" 
                                                                              bundle:[NSBundle mainBundle]];
    
        myUserLandingController     = [[JRUserLandingController alloc] initWithNibName:@"JRUserLandingController-iPad"
                                                                                bundle:[NSBundle mainBundle]];
        
        myWebViewController         = [[JRWebViewController alloc] initWithNibName:@"JRWebViewController-iPad"
                                                                            bundle:[NSBundle mainBundle]];
        
        myPublishActivityController = [[JRPublishActivityController alloc] initWithNibName:@"JRPublishActivityController-iPad"
                                                                                    bundle:[NSBundle mainBundle]];
    }
    else
    {
        myProvidersController       = [[JRProvidersController alloc] initWithNibName:@"JRProvidersController" 
                                                                              bundle:[NSBundle mainBundle]];
        
        myUserLandingController     = [[JRUserLandingController alloc] initWithNibName:@"JRUserLandingController"
                                                                                bundle:[NSBundle mainBundle]];
        
        myWebViewController         = [[JRWebViewController alloc] initWithNibName:@"JRWebViewController"
                                                                            bundle:[NSBundle mainBundle]];
        
        myPublishActivityController = [[JRPublishActivityController alloc] initWithNibName:@"JRPublishActivityController"
                                                                                    bundle:[NSBundle mainBundle]];
    }
    
    delegates = [[NSMutableArray alloc] initWithObjects:myProvidersController, 
                 myUserLandingController, 
                 myWebViewController, 
                 myPublishActivityController, nil];
    
    sessionData.dialogIsShowing = YES;
}

- (void)pushToCustomNavigationController:(UINavigationController*)_navigationController
{
    [navigationController release];
    navigationController = [_navigationController retain];
}

- (void)tearDownViewControllers
{
    DLog(@"");

    [delegates removeAllObjects];
    [delegates release];
    delegates = nil;
    
    [myProvidersController release],        myProvidersController = nil;
    [myUserLandingController release],      myUserLandingController = nil;
    [myWebViewController release],          myWebViewController = nil;
    [myPublishActivityController release],  myPublishActivityController = nil;    
    
    [jrModalNavController release],	jrModalNavController = nil;	   
    
    sessionData.dialogIsShowing = NO;
}


- (void)setUpSocialPublishing
{
    DLog(@"");
    [sessionData setSocial:YES];
    
    if (myPublishActivityController)
        [sessionData addDelegate:myPublishActivityController];
}

- (void)tearDownSocialPublishing
{
    DLog(@"");
    [sessionData setSocial:NO];
    [sessionData setActivity:nil];
    
    if (myPublishActivityController)
        [sessionData removeDelegate:myPublishActivityController];
}

- (void)loadModalNavigationControllerWithViewController:(UIViewController*)controller
{
    DLog(@"");
    if (!jrModalNavController)
		jrModalNavController = [[JRModalNavigationController alloc] initWithRootViewController:controller];
	
    if (sessionData.returningBasicProvider && !sessionData.currentProvider && ![sessionData social])
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
        viewControllerToPopTo = [[navigationController topViewController] retain];

    if (sessionData.returningBasicProvider && !sessionData.currentProvider && ![sessionData social])
    {   
        [sessionData setCurrentProvider:[sessionData getProviderNamed:sessionData.returningBasicProvider]];
        [navigationController pushViewController:controller animated:NO];
        [navigationController pushViewController:myUserLandingController animated:YES];
    }
    else
    {
        [navigationController pushViewController:controller animated:YES];
    }
}

- (void)showAuthenticationDialog
{
    DLog(@"");
    [self setUpViewControllers];

    if (navigationController && [navigationController isViewLoaded])
        [self loadCustomNavigationControllerWithViewController:myProvidersController];
    else
        [self loadModalNavigationControllerWithViewController:myProvidersController];
}

- (void)showPublishingDialogWithActivity
{   
    DLog(@"");
    [self setUpViewControllers];	
    [self setUpSocialPublishing];
    
    if (navigationController && [navigationController isViewLoaded])
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
    [navigationController popToViewController:viewControllerToPopTo animated:YES];

    [viewControllerToPopTo release];
    viewControllerToPopTo = nil;
}

- (void)unloadUserInterfaceWithTransitionStyle:(UIModalTransitionStyle)style
{
    DLog(@"");
    if ([sessionData social])
        [self tearDownSocialPublishing];
    
    for (id<JRUserInterfaceDelegate> delegate in delegates) 
        [delegate userInterfaceWillClose];
    
    if (navigationController && [navigationController isViewLoaded])
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
    
    if ([sessionData social])
        originalRootViewController = myPublishActivityController;
    else
        originalRootViewController = myProvidersController;
    
    if (navigationController && [navigationController isViewLoaded])
        [navigationController popToViewController:originalRootViewController animated:YES];
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
    if (![sessionData social])
        [self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCrossDissolve];
    else
        [self popToOriginalRootViewController];
}

- (void)authenticationFailed
{
    DLog(@"");
    [self popToOriginalRootViewController];
//    [self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCoverVertical];
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
