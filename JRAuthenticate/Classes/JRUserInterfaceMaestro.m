//
//  JRUserInterfaceMaestro.m
//  JRAuthenticate
//
//  Created by lilli on 8/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

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
    myProvidersController       = [[JRProvidersController alloc] initWithNibName:@"JRProvidersController" 
                                                                          bundle:[NSBundle mainBundle]];
    
    myUserLandingController     = [[JRUserLandingController alloc] initWithNibName:@"JRUserLandingController"
                                                                            bundle:[NSBundle mainBundle]];
    
    myWebViewController         = [[JRWebViewController alloc] initWithNibName:@"JRWebViewController"
                                                                        bundle:[NSBundle mainBundle]];
    
    myPublishActivityController = [[JRPublishActivityController alloc] initWithNibName:@"JRPublishActivityController"
                                                                                bundle:[NSBundle mainBundle]];
    
    delegates = [[NSMutableArray alloc] initWithObjects:myProvidersController, 
                 myUserLandingController, 
                 myWebViewController, 
                 myPublishActivityController, nil];
    
}

- (void)pushToCustomNavigationController:(UINavigationController*)_navigationController
{
    [navigationController release];
    navigationController = [_navigationController retain];
}

//- (void)popCustomNavigationControllerToViewController:(UIViewController*)_viewController
//{
//    [viewControllerToPopTo release];
//    viewControllerToPopTo = _viewController;
//}

- (void)tearDownViewControllers
{
    [delegates removeAllObjects];
    [delegates release];
    delegates = nil;
    
    [myProvidersController release];
    [myUserLandingController release];
    [myWebViewController release];
    [myPublishActivityController release];
    
    myProvidersController = nil;
    myUserLandingController = nil;
    myWebViewController = nil;
    myPublishActivityController = nil;    
    
    [jrModalNavController release];
	jrModalNavController = nil;	   
    
    
}


- (void)setUpSocialPublishing
{
    [sessionData setSocial:YES];
    
    if (myPublishActivityController)
        [sessionData addDelegate:myPublishActivityController];
}

- (void)tearDownSocialPublishing
{
    [sessionData setSocial:NO];
    
    if (myPublishActivityController)
        [sessionData removeDelegate:myPublishActivityController];
}

- (void)loadModalNavigationControllerWithViewController:(UIViewController*)controller
{
    if (!jrModalNavController)
		jrModalNavController = [[JRModalNavigationController alloc] initWithRootViewController:controller];
	
    if (sessionData.returningBasicProvider && !sessionData.currentProvider && ![sessionData social])
    {   
        [sessionData setCurrentProvider:sessionData.returningBasicProvider];
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
    if (!viewControllerToPopTo)
        viewControllerToPopTo = [[navigationController topViewController] retain];

    if (sessionData.returningBasicProvider && !sessionData.currentProvider && ![sessionData social])
    {   
        [sessionData setCurrentProvider:sessionData.returningBasicProvider];
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
    [self setUpViewControllers];

    if (navigationController && [navigationController isViewLoaded])
        [self loadCustomNavigationControllerWithViewController:myProvidersController];
    else
        [self loadModalNavigationControllerWithViewController:myProvidersController];
    
    
//	if (!jrModalNavController)
//		jrModalNavController = [[JRModalNavigationController alloc] initWithRootViewController:myProvidersController];
//	
//
//	UIWindow* window = [UIApplication sharedApplication].keyWindow;
//	if (!window) 
//	{
//		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//	}
//    [window addSubview:jrModalNavController.view];
//	
//	[jrModalNavController presentModalNavigationControllerForAuthentication];    
}

- (void)showPublishingDialogWithActivity
{   
    [self setUpViewControllers];	
    [self setUpSocialPublishing];
    
    if (navigationController && [navigationController isViewLoaded])
        [self loadCustomNavigationControllerWithViewController:myPublishActivityController];
    else
        [self loadModalNavigationControllerWithViewController:myPublishActivityController];
         
         
//    if (!jrModalNavController)
//		jrModalNavController = [[JRModalNavigationController alloc] initWithRootViewController:myPublishActivityController];
//	
//	
//    UIWindow* window = [UIApplication sharedApplication].keyWindow;
//	if (!window) 
//	{
//		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//	}    
//    [window addSubview:jrModalNavController.view];
//    
//	[jrModalNavController presentModalNavigationControllerForPublishingActivity];    
}

- (void)unloadModalNavigationControllerWithTransitionStyle:(UIModalTransitionStyle)style
{
    if ([sessionData social])
        [self tearDownSocialPublishing];
    
    for (id<JRUserInterfaceDelegate> delegate in delegates) 
        [delegate userInterfaceWillClose];
    
    [jrModalNavController dismissModalNavigationController:style];   

    for (id<JRUserInterfaceDelegate> delegate in delegates) 
        [delegate userInterfaceDidClose];
    
    [self tearDownViewControllers];
}

- (void)unloadCustomNavigationController
{
    [navigationController popToViewController:viewControllerToPopTo animated:YES];

    [viewControllerToPopTo release];
    viewControllerToPopTo = nil;
}

- (void)unloadUserInterfaceWithTransitionStyle:(UIModalTransitionStyle)style
{
    if (navigationController && [navigationController isViewLoaded])
        [self unloadCustomNavigationController];
    else
        [self unloadModalNavigationControllerWithTransitionStyle:style];
}

- (void)authenticationCompleted
{
    if (![sessionData social])
        [self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCrossDissolve];//[jrModalNavController dismissModalNavigationController:YES];
}

- (void)authenticationFailed
{
    [self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCoverVertical];//[jrModalNavController dismissModalNavigationController:NO];
}

- (void)authenticationCanceled 
{	
    [self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCoverVertical];//[jrModalNavController dismissModalNavigationController:YES];
}

- (void)publishingCompleted 
{ 
    [self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCoverVertical];//[jrModalNavController dismissModalNavigationController:YES];       
}

- (void)publishingCanceled
{
	[self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCoverVertical];//[jrModalNavController dismissModalNavigationController:YES];   
}

- (void)publishingFailed 
{ 
 	[self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCoverVertical];//[jrModalNavController dismissModalNavigationController:YES];       
}
@end
