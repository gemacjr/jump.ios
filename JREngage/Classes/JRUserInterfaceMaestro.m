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
#import "JREngage+CustomInterface.h"

@interface JRModalNavigationController : UIViewController <UIPopoverControllerDelegate>
{
	UINavigationController *myNavigationController;
    UIPopoverController    *myPopoverController;

    BOOL iPad;
	BOOL shouldUnloadSubviews;
}
@property (retain) UINavigationController *myNavigationController;
@property (retain) UIPopoverController    *myPopoverController;
@end

@implementation JRModalNavigationController
@synthesize myNavigationController;
@synthesize myPopoverController;

- (id)initWithRootViewController:(UIViewController*)controller andCustomInterface:(NSDictionary*)_customInterface
{
	if (controller == nil)
	{
		[self release];
		return nil;
	}
        
	if (self = [super init]) { }

    return self;
}

- (void)loadView  
{
	DLog (@"");    
    UIView *view = [[[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame] autorelease];
    //view.backgroundColor = [UIColor redColor];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        iPad = YES;

    shouldUnloadSubviews = NO;

    [self setView:view];
}

- (void)presentPopoverNavigationControllerFromBarButton:(UIBarButtonItem*)barButtonItem inDirection:(UIPopoverArrowDirection)direction
{
	DLog (@"");
    [myPopoverController presentPopoverFromBarButtonItem:barButtonItem
                                permittedArrowDirections:direction 
                                                animated:YES];    
}

- (void)presentPopoverNavigationControllerFromCGRect:(CGRect)rect inDirection:(UIPopoverArrowDirection)direction
{
	DLog (@"");
    CGRect popoverPresentationFrame = [self.view convertRect:rect toView:[[UIApplication sharedApplication] keyWindow]];

    [myPopoverController presentPopoverFromRect:popoverPresentationFrame
                                         inView:self.view 
                       permittedArrowDirections:direction
                                       animated:YES];
}

- (void)presentModalNavigationController
{
	DLog (@"");
    
    if (iPad)
    {
        myNavigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        myNavigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [self presentModalViewController:myNavigationController animated:YES];
        
        myNavigationController.view.superview.frame = CGRectMake(0, 0, 320, 460);
        myNavigationController.view.superview.center = self.view.center;
    }
    else
    {
        myNavigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:myNavigationController animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated { DLog (@""); [super viewWillAppear:animated]; }
- (void)viewDidAppear:(BOOL)animated 
{
    DLog (@""); 

    if (shouldUnloadSubviews) { [self.view removeFromSuperview]; } 
    
    [super viewDidAppear:animated]; 
}
- (void)viewWillDisappear:(BOOL)animated { DLog (@""); [super viewWillDisappear:animated]; }
- (void)viewDidDisappear:(BOOL)animated { DLog (@""); [super viewDidDisappear:animated]; }

- (void)dismissModalNavigationController:(UIModalTransitionStyle)style
{
	DLog (@"");

    if (myPopoverController)
    {
        [myPopoverController dismissPopoverAnimated:YES];
    }
    else
    {
        myNavigationController.modalTransitionStyle = style;
        [self dismissModalViewControllerAnimated:YES];
    }

    shouldUnloadSubviews = YES;

    [self.view removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return YES;
}

- (void)dealloc 
{
	DLog (@"");
    [myNavigationController release];
    [myPopoverController release];
    
	[super dealloc];
}
@end

@interface JRUserInterfaceMaestro ()
@property (retain) JRModalNavigationController  *jrModalNavController;
@property (retain) UINavigationController       *applicationNavigationController;
@property (retain) UINavigationController       *customModalNavigationController;
@property (retain) UIPopoverController          *popoverController;
@property (retain) NSDictionary                 *customInterfaceDefaults;
@property (retain) NSDictionary                 *janrainInterfaceDefaults;
@end

@implementation JRUserInterfaceMaestro
@synthesize myProvidersController;
@synthesize myUserLandingController;
@synthesize myWebViewController;
@synthesize myPublishActivityController;
@synthesize jrModalNavController;
@synthesize applicationNavigationController;
@synthesize customModalNavigationController;
@synthesize popoverController;
@synthesize customInterfaceDefaults;
@synthesize janrainInterfaceDefaults;

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

- (NSDictionary*)loadJanrainInterfaceDefaults
{
    NSDictionary *infoPlist = [NSDictionary dictionaryWithContentsOfFile: 
                               [[[NSBundle mainBundle] resourcePath] 
                                stringByAppendingPathComponent:@"/JREngage-Info.plist"]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                 [[infoPlist objectForKey:@"JREngage.CustomInterface"] 
                                  objectForKey:@"DefaultValues"]];
    [dict addEntriesFromDictionary:[[infoPlist objectForKey:@"JREngage.CustomInterface"] objectForKey:@"CustomValues"]];
    
    // TODO: Convert RGB color to UIColor
    
    return dict;
}

- (id)initWithSessionData:(JRSessionData*)_sessionData
{
	if (self = [super init]) 
	{
        singleton = self;
        sessionData = _sessionData;
        janrainInterfaceDefaults = [[self loadJanrainInterfaceDefaults] retain];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            iPad = YES;
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

- (void)handleCustomInterfaceException:(NSException*)exception forKey:(NSString*)kJRKeyString
{
    ALog (@"Problem with custom interface object for kJRKeyString, %@: Caught %@: %@", kJRKeyString, [exception name], [exception reason]);
#ifdef DEBUG
    @throw exception;
#else
    ALog (@"Ignoring value for kJRKeyString, %@", kJRKeyString);
#endif            
}

- (void)useApplicationNavigationController:(UINavigationController*)navigationController
{
    self.applicationNavigationController = navigationController;
}

- (void)warnDeprecated:(NSDictionary*)customizations
{
    // TODO
}

- (void)buildCustomInterface:(NSDictionary*)customizations
{
//    NSDictionary *infoPlist = [NSDictionary dictionaryWithContentsOfFile: 
//                               [[[NSBundle mainBundle] resourcePath] 
//                                stringByAppendingPathComponent:@"/JREngage-Info.plist"]];

    // TODO: Doesn't need to be so big
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:
                                 ([customizations count] + 
                                  [janrainInterfaceDefaults count] + 
                                  [customInterfaceDefaults count])];

    [dict addEntriesFromDictionary:janrainInterfaceDefaults];
    [dict addEntriesFromDictionary:customInterfaceDefaults];
    [dict addEntriesFromDictionary:customizations];

    customInterface = [[NSDictionary alloc] initWithDictionary:dict];
}

- (void)setUpViewControllers
{
    DLog(@"");
    if (0)//(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
//        myProvidersController       = [[JRProvidersController alloc] initWithNibName:@"JRProvidersController-iPad" 
//                                                                              bundle:[NSBundle mainBundle]
//                                                                  andCustomInterface:customInterface];
//    
//        myUserLandingController     = [[JRUserLandingController alloc] initWithNibName:@"JRUserLandingController-iPad"
//                                                                                bundle:[NSBundle mainBundle]
//                                                                    andCustomInterface:customInterface];
//        
//        myWebViewController         = [[JRWebViewController alloc] initWithNibName:@"JRWebViewController-iPad"
//                                                                            bundle:[NSBundle mainBundle]
//                                                                andCustomInterface:customInterface];
//        
//        myPublishActivityController = [[JRPublishActivityController alloc] initWithNibName:@"JRPublishActivityController-iPad"
//                                                                                    bundle:[NSBundle mainBundle]
//                                                                        andCustomInterface:customInterface];
    }
    else
    {
        myProvidersController       = [[JRProvidersController alloc] initWithNibName:@"JRProvidersController" 
                                                                              bundle:[NSBundle mainBundle]
                                                                  andCustomInterface:customInterface];
        
        myUserLandingController     = [[JRUserLandingController alloc] initWithNibName:@"JRUserLandingController"
                                                                                bundle:[NSBundle mainBundle]
                                                                    andCustomInterface:customInterface];
        
        myWebViewController         = [[JRWebViewController alloc] initWithNibName:@"JRWebViewController"
                                                                            bundle:[NSBundle mainBundle]
                                                                andCustomInterface:customInterface];
        
        myPublishActivityController = [[JRPublishActivityController alloc] initWithNibName:@"JRPublishActivityController"
                                                                                    bundle:[NSBundle mainBundle]
                                                                        andCustomInterface:customInterface];
    }

    @try
    {
     /* We do this here, because sometimes we pop straight to the user landing controller and we need the back-button's title to be correct */
        if ([customInterface objectForKey:kJRProviderTableTitleString])
            myProvidersController.title = [customInterface objectForKey:kJRProviderTableTitleString];
        else
            myProvidersController.title = @"Providers";        
    }
    @catch (NSException *exception)
    {
        [self handleCustomInterfaceException:exception forKey:kJRProviderTableTitleString];
        myProvidersController.title = @"Providers";        
    }
    
    delegates = [[NSMutableArray alloc] initWithObjects:myProvidersController, 
                 myUserLandingController, 
                 myWebViewController, 
                 myPublishActivityController, nil];
    
    sessionData.dialogIsShowing = YES;
}

- (void)setUpDialogPresentation
{
    if ([customInterface objectForKey:kJRUseApplicationNavigationController])
        self.applicationNavigationController = [[customInterface objectForKey:kJRUseApplicationNavigationController] retain];
    
    if ([customInterface objectForKey:kJRUseCustomModalNavigationController])
        self.customModalNavigationController = [[customInterface objectForKey:kJRUseCustomModalNavigationController] retain];

    usingAppNav = usingCustomNav = NO;
    if (iPad)
    {
        if ([customInterface objectForKey:kJRPopoverPresentationBarButtonItem])
            padPopoverMode = PadPopoverFromBar;
//            if (customModalNavigationController && ![customModalNavigationController isViewLoaded])            
//                usingCustomNav = dialogPresentationMode = PopoverFromBarWithCustomNav;
//            else
//                dialogPresentationMode = PopoverFromBarWithDefaultNav;
        else if ([customInterface objectForKey:kJRPopoverPresentationFrameValue])
            padPopoverMode = PadPopoverFromFrame;
//            if (customModalNavigationController && ![customModalNavigationController isViewLoaded])            
//                usingCustomNav = dialogPresentationMode = PopoverFromRectWithCustomNav;
//            else
//                dialogPresentationMode = PopoverFromRectWithDefaultNav;
        else
            padPopoverMode = PadPopoverModeNone;
        
        if (customModalNavigationController && ![customModalNavigationController isViewLoaded])            
            usingCustomNav = YES;//dialogPresentationMode = ModalWithCustomNavPad;
        else
            usingCustomNav = NO;//dialogPresentationMode = ModalWithDefaultNavPad;
    }
    else
    {
        if (applicationNavigationController && [applicationNavigationController isViewLoaded])
            usingAppNav = YES;//dialogPresentationMode = PushOntoApplicationNav;
        else if (customModalNavigationController)
            usingCustomNav = YES;//dialogPresentationMode = ModalWithCustomNavPhone;
//        else
//            dialogPresentationMode = ModalWithDefaultNavPhone;
    }
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
    [customModalNavigationController release], customModalNavigationController = nil;
    
    [customInterface release], customInterface = nil;
    
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

- (UINavigationController*)createDefaultNavigationController
{
    UINavigationController *navigationController = [[[UINavigationController alloc] init] autorelease];
    navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;   
    navigationController.navigationBar.clipsToBounds = YES;
   
    NSArray *tintArray = [customInterface objectForKey:kJRNavigationBarTintColorRGBa];
    UIColor *tintColor = [customInterface objectForKey:kJRNavigationBarTintColor];
    
    @try
    {
        if (tintColor)
            [navigationController.navigationBar setTintColor:tintColor];
        else if (tintArray)
            if ([tintArray respondsToSelector:@selector(count)])
                if ([tintArray count] == 4)
                    [navigationController.navigationBar setTintColor: 
                     [UIColor colorWithRed:[(NSNumber*)[tintArray objectAtIndex:0] doubleValue]
                                     green:[(NSNumber*)[tintArray objectAtIndex:1] doubleValue]
                                      blue:[(NSNumber*)[tintArray objectAtIndex:2] doubleValue]
                                     alpha:[(NSNumber*)[tintArray objectAtIndex:3] doubleValue]]];
    }
    @catch (NSException *exception)
    {
        ALog (@"Problem with custom interface object for kJRNavigationBarTintColorRGBa or kJRNavigationBarTintColor: Caught %@: %@", 
              [exception name], [exception reason]);
#ifdef DEBUG
        @throw exception;
#else
        ALog (@"Ignoring value for kJRNavigationBarTintColorRGBa or kJRNavigationBarTintColor");
#endif        
    }
    
//    [navigationController.navigationBar setTintColor:[UIColor blueColor]];
    return navigationController;
}
 
- (void)loadModalNavigationControllerWithViewController:(UIViewController*)rootViewController
{
    DLog(@"");
//    if (!jrModalNavController)
//		jrModalNavController = [[JRModalNavigationController alloc] initWithRootViewController:controller
//                                                                            andCustomInterface:customInterface];

    self.jrModalNavController = [[JRModalNavigationController alloc] init];

    if (usingCustomNav)
        jrModalNavController.myNavigationController = customModalNavigationController;
    else
        jrModalNavController.myNavigationController = [self createDefaultNavigationController];
    
    if (padPopoverMode != PadPopoverModeNone)
    {
        jrModalNavController.myPopoverController = 
            [[UIPopoverController alloc] initWithContentViewController:
                jrModalNavController.myNavigationController];    
        
        [jrModalNavController.myNavigationController.navigationBar setTintColor:[UIColor greenColor]];        
        
        jrModalNavController.myPopoverController.popoverContentSize = CGSizeMake(320, 460);                
        jrModalNavController.myPopoverController.delegate = self;
    }

    [((UINavigationController*)jrModalNavController.myPopoverController.contentViewController).navigationBar setTintColor:[UIColor yellowColor]];        
    
    [jrModalNavController.myNavigationController pushViewController:rootViewController animated:NO];
    
    if (sessionData.returningBasicProvider && !sessionData.currentProvider && ![sessionData socialSharing])
    {   
        [sessionData setCurrentProvider:[sessionData getProviderNamed:sessionData.returningBasicProvider]];
        [jrModalNavController.myNavigationController pushViewController:myUserLandingController animated:NO];
    }
    
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) 
	{
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
    [window addSubview:jrModalNavController.view];
	
	
    if (padPopoverMode == PadPopoverFromBar)
        [jrModalNavController presentPopoverNavigationControllerFromBarButton:[customInterface objectForKey:kJRPopoverPresentationBarButtonItem]
                                                                  inDirection:[[customInterface objectForKey:kJRPopoverPresentationArrowDirection] intValue]];
    else if (padPopoverMode == PadPopoverFromFrame)
        [jrModalNavController presentPopoverNavigationControllerFromCGRect:[[customInterface objectForKey:kJRPopoverPresentationFrameValue] CGRectValue] 
                                                               inDirection:[[customInterface objectForKey:kJRPopoverPresentationArrowDirection] intValue]];
    else
        [jrModalNavController presentModalNavigationController];
    
    [((UINavigationController*)jrModalNavController.myPopoverController.contentViewController).navigationBar setTintColor:[UIColor purpleColor]];            
}

- (void)loadApplicationNavigationControllerWithViewController:(UIViewController*)rootViewController
{
    DLog(@"");
    if (!viewControllerToPopTo)
        viewControllerToPopTo = [[applicationNavigationController topViewController] retain];

    if (sessionData.returningBasicProvider && !sessionData.currentProvider && ![sessionData socialSharing])
    {   
        [sessionData setCurrentProvider:[sessionData getProviderNamed:sessionData.returningBasicProvider]];
        [applicationNavigationController pushViewController:rootViewController animated:NO];
        [applicationNavigationController pushViewController:myUserLandingController animated:YES];
    }
    else
    {
        [applicationNavigationController pushViewController:rootViewController animated:YES];
    }
}

//- (void)showAuthenticationDialogWithForcedReauth
//{
//    [self setUpViewControllers];
//    
//    if (customNavigationController && [customNavigationController isViewLoaded])
//        [self loadCustomNavigationControllerWithViewController:myProvidersController];
//    else
//        [self loadModalNavigationControllerWithViewController:myProvidersController];    
//}

- (void)showAuthenticationDialogWithCustomInterface:(NSDictionary*)customizations
{
    DLog(@"");
    [self buildCustomInterface:customizations];
    [self setUpViewControllers];
    [self setUpDialogPresentation];
    
    if (usingAppNav == YES)//(dialogPresentationMode == PushOntoApplicationNav)//(applicationNavigationController && [applicationNavigationController isViewLoaded])
        [self loadApplicationNavigationControllerWithViewController:myProvidersController];
    else
        [self loadModalNavigationControllerWithViewController:myProvidersController];
}

- (void)showPublishingDialogForActivityWithCustomInterface:(NSDictionary*)customizations
{   
    DLog(@"");
    [self buildCustomInterface:customizations];
    [self setUpViewControllers];	
    [self setUpSocialPublishing];
    [self setUpDialogPresentation];
    
    if (usingAppNav == YES)//(dialogPresentationMode == PushOntoApplicationNav)//(applicationNavigationController && [applicationNavigationController isViewLoaded])
        [self loadApplicationNavigationControllerWithViewController:myPublishActivityController];
    else
        [self loadModalNavigationControllerWithViewController:myPublishActivityController];
}

- (void)unloadModalNavigationControllerWithTransitionStyle:(UIModalTransitionStyle)style
{
    DLog(@"");
    [jrModalNavController dismissModalNavigationController:style];   
}

- (void)unloadApplicationNavigationController
{
    DLog(@"");
    [applicationNavigationController popToViewController:viewControllerToPopTo animated:YES];

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
    
    if (usingAppNav)//(applicationNavigationController && [applicationNavigationController isViewLoaded])
        [self unloadApplicationNavigationController];
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
    
    if (applicationNavigationController && [applicationNavigationController isViewLoaded])
        [applicationNavigationController popToViewController:originalRootViewController animated:YES];
    else
        [jrModalNavController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	DLog (@"");
    if ([sessionData socialSharing])
        [sessionData triggerPublishingDidCancel];
    else
        [sessionData triggerAuthenticationDidCancel];
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
