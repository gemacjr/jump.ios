//
//  JRUserInterfaceMaestro.h
//  JRAuthenticate
//
//  Created by lilli on 8/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRSessionData.h"
#import "JRModalNavigationController.h"
#import "JRSetStatusController.h"
//#import "JRProvidersController.h"
//#import "JRUserLandingController.h"
//#import "JRWebViewController.h"
//#import "JRPublishActivityController.h"

@protocol JRUserInterfaceDelegate <NSObject>
- (void)userInterfaceWillClose;
- (void)userInterfaceDidClose;
@end

@class JRSessionData;
@class JRModalNavigationController;
@class JRProvidersController;
@class JRUserLandingController;
@class JRWebViewController;
@class JRPublishActivityController;

@interface JRUserInterfaceMaestro : NSObject 
{
	JRModalNavigationController *jrModalNavController;
	JRSessionData	*sessionData;
	NSMutableArray	*delegates;    
    
    UINavigationController	*navigationController;

    JRProvidersController       *myProvidersController;
	JRUserLandingController     *myUserLandingController;
	JRWebViewController         *myWebViewController;
    JRPublishActivityController *myPublishActivityController;
    
    NSMutableArray *setStatusBars;
}

+ (JRUserInterfaceMaestro*)jrUserInterfaceMaestroWithSessionData:(JRSessionData*)_sessionData;
+ (JRUserInterfaceMaestro*)jrUserInterfaceMaestro;

- (void)showAuthenticationDialog;
- (void)showPublishingDialogWithActivity;

- (void)authenticationCompleted;
- (void)authenticationFailed;
- (void)authenticationCanceled;
- (void)publishingCompleted;
- (void)publishingCanceled;
- (void)publishingFailed;

- (id)setStatusBar;

@property (readonly) UINavigationController	*navigationController;

@property (readonly) JRProvidersController       *myProvidersController;
@property (readonly) JRUserLandingController     *myUserLandingController;
@property (readonly) JRWebViewController         *myWebViewController;
@property (readonly) JRPublishActivityController *myPublishActivityController;
@end
