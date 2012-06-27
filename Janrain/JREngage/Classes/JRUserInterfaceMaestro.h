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

 File:   JRUserInterfaceMaestro.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, August 24, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "JRSessionData.h"
#import "JRProvidersController.h"
#import "JRUserLandingController.h"
#import "JRWebViewController.h"
#import "JRPublishActivityController.h"

@class JRSessionData;
@class JRModalNavigationController;
@class JRProvidersController;
@class JRUserLandingController;
@class JRWebViewController;
@class JRPublishActivityController;

#define JANRAIN_BLUE    [UIColor colorWithRed:0.102 green:0.33 blue:0.48 alpha:1.0]
#define JANRAIN_BLUE_20 [UIColor colorWithRed:0.102 green:0.33 blue:0.48 alpha:0.2]
typedef enum
{
    PadPopoverModeNone,
    PadPopoverFromBar,
    PadPopoverFromFrame,
} PadPopoverMode;

@interface JRUserInterfaceMaestro : NSObject <UIPopoverControllerDelegate>
{
    JRModalNavigationController *jrModalNavController;
    JRSessionData   *sessionData;
    NSMutableArray  *delegates;

    BOOL iPad;

    PadPopoverMode padPopoverMode;
    BOOL usingAppNav;
    BOOL usingCustomNav;

    NSString *directProvider;

    UINavigationController  *customModalNavigationController;
    UINavigationController  *applicationNavigationController;
    UINavigationController  *savedNavigationController;
    UIViewController        *viewControllerToPopTo;

    JRProvidersController       *myProvidersController;
    JRUserLandingController     *myUserLandingController;
    JRWebViewController         *myWebViewController;
    JRPublishActivityController *myPublishActivityController;

    NSDictionary        *customInterface;
    NSDictionary        *janrainInterfaceDefaults;
    NSMutableDictionary *customInterfaceDefaults;
}

+ (JRUserInterfaceMaestro*)jrUserInterfaceMaestroWithSessionData:(JRSessionData*)newSessionData;
+ (JRUserInterfaceMaestro*)jrUserInterfaceMaestro;

//- (void)useApplicationNavigationController:(UINavigationController*)navigationController;

- (void)showAuthenticationDialogWithCustomInterface:(NSDictionary*)customizations;
- (void)showPublishingDialogForActivityWithCustomInterface:(NSDictionary*)customizations;

- (void)authenticationRestarted;
- (void)authenticationCompleted;
- (void)authenticationFailed;
- (void)authenticationCanceled;
- (void)publishingRestarted;
- (void)publishingCompleted;
- (void)publishingCanceled;
- (void)publishingFailed;

// Question to self: Do I want to make customInterfaceDefaults nonatomic?
@property (copy)     NSMutableDictionary         *customInterfaceDefaults;
@property (readonly) JRProvidersController       *myProvidersController;
@property (readonly) JRUserLandingController     *myUserLandingController;
@property (readonly) JRWebViewController         *myWebViewController;
@property (readonly) JRPublishActivityController *myPublishActivityController;
@property (copy)     NSString                    *directProvider;
@end
