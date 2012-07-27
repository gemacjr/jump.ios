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

 Author: ${USER}
 Date:   ${DATE}
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "ViewController.h"
#import "JREngage+CustomInterface.h"
#import "CaptureNewUserViewController.h"
#import "ObjectDrillDownViewController.h"

@interface ViewController ()
@end

@implementation ViewController
@synthesize currentUserLabel;
@synthesize currentUserProviderIcon;
@synthesize browseButton;
@synthesize testerButton;
@synthesize updateButton;
@synthesize signinButton;


- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([SharedData currentDisplayName])
        currentUserLabel.text = [NSString stringWithFormat:@"Current user: %@", [SharedData currentDisplayName]];
    else
        currentUserLabel.text = @"No current user";

    if ([SharedData currentProvider])
        currentUserProviderIcon.image = [UIImage imageNamed:
                     [NSString stringWithFormat:@"icon_%@_30x30@2x.png", [SharedData currentProvider]]];
}

- (void)setButtonsEnabled:(BOOL)enabled
{
    [browseButton setEnabled:enabled];
    [testerButton setEnabled:enabled];
    [updateButton setEnabled:enabled];
}

- (IBAction)browseButtonPressed:(id)sender
{
    ObjectDrillDownViewController *drillDown =
                [[ObjectDrillDownViewController alloc] initWithNibName:@"ObjectDrillDownViewController"
                                                                bundle:[NSBundle mainBundle]
                                                             forObject:[SharedData captureUser]
                                                   captureParentObject:nil
                                                                andKey:@"CaptureUser"];

    [[self navigationController] pushViewController:drillDown animated:YES];
}

- (IBAction)updateButtonPressed:(id)sender
{
    CaptureNewUserViewController *viewController = [[CaptureNewUserViewController alloc]
            initWithNibName:@"CaptureNewUserViewController" bundle:[NSBundle mainBundle]];

    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)testerButtonPressed:(id)sender
{
//    DLog(@"");
   JRCaptureUser *captureUser = [JRCaptureUser captureUser];



//
//    captureUser.displayName = @"mcspilli";
//    captureUser.avatar      = @"sexy_brunette.jpg";
//      captureUser.bankroll    = [NSNumber numberWithDouble:1000.0];
//
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Welcome!"
//                                                        message:@"You have just been awarded $1000 for joining!"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Dismiss"
//                                              otherButtonTitles:nil];
//    [alertView show];
//
//    [captureUser updateOnCaptureForDelegate:self context:nil];
//
//    JRBestHand *bestHand = [JRBestHand bestHand];
//
//    bestHand.

}

- (IBAction)signInButtonPressed:(id)sender
{
    [self setButtonsEnabled:NO];
    currentUserLabel.text         = @"No current user";
    currentUserProviderIcon.image = nil;

    NSDictionary *customInterface = [NSDictionary dictionaryWithObject:self.navigationController
                                                                forKey:kJRApplicationNavigationController];

    [SharedData startAuthenticationWithCustomInterface:customInterface forDelegate:self];
}

- (void)engageSignInDidSucceed
{
    currentUserLabel.text         = [SharedData currentDisplayName] ?
            [NSString stringWithFormat:@"Current user: %@", [SharedData currentDisplayName]] :
            @"Capture User";
    currentUserProviderIcon.image = [SharedData currentProvider] ?
            [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@_30x30@2x.png", [SharedData currentProvider]]] :
            nil;
}

- (void)captureSignInDidSucceed
{
    [self setButtonsEnabled:YES];

    [self engageSignInDidSucceed]; /* In case this method wasn't called if the user signed in directly */

    if ([SharedData notYetCreated] || [SharedData isNew])
    {
        CaptureNewUserViewController *viewController = [[CaptureNewUserViewController alloc]
                initWithNibName:@"CaptureNewUserViewController" bundle:[NSBundle mainBundle]];

        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)engageSignInDidFailWithError:(NSError *)error
{
    if (error)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"//error ? @"Error" : @"Canceled"
                                                            message:[error description]//error ? [error description] : @"Authentication was canceled"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
        [alertView show];
    }

}

- (void)captureSignInDidFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error description]
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
@end
