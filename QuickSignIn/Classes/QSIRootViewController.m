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


 File:   QSIRootViewController.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "QSIRootViewController.h"
#import "QSIUserModel.h"

@implementation RootViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        iPad = YES;

    self.title = @"Quick Sign-In!";

    [self navigationController].navigationBar.barStyle = UIBarStyleBlackOpaque;

//#ifdef LILLI
//    UIBarButtonItem *spacerButton = [[[UIBarButtonItem alloc]
//                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                      target:nil
//                                      action:nil] autorelease];
//
//    self.navigationItem.leftBarButtonItem = spacerButton;
//    self.navigationItem.leftBarButtonItem.enabled = YES;

    UIBarButtonItem *viewHistoryButton = [[[UIBarButtonItem alloc]
                                           initWithTitle:@"View Profiles"
                                           style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(viewHistoryButtonPressed:)] autorelease];

    self.navigationItem.rightBarButtonItem = viewHistoryButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;
//#endif

    if (iPad)
        level1ViewController = [[ViewControllerLevel1 alloc] initWithNibName:@"QSIViewControllerLevel1-iPad"
                                                                      bundle:[NSBundle mainBundle]];
    else
        level1ViewController = [[ViewControllerLevel1 alloc] initWithNibName:@"QSIViewControllerLevel1"
                                                                      bundle:[NSBundle mainBundle]];

    [[UserModel getUserModel] setNavigationController:[self navigationController]];

    /* Check to see if a user is already logged in, and, if so, wait half a second then drill down a level. */
    if ([[UserModel getUserModel] currentUser])
        [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(delayNavPush:) userInfo:nil repeats:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!iPad)
    {
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait ||
            self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            [layoutViewOutside setFrame:CGRectMake(0, 60, 320, 267)];
            [layoutViewInside  setFrame:CGRectMake(0, 100, 320, 167)];
        }
        else
        {
            [layoutViewOutside setFrame:CGRectMake(80, 0, 320, 267)];
            [layoutViewInside  setFrame:CGRectMake(0, 75, 320, 147)];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([[UserModel getUserModel] pendingCallToTokenUrl])
        [[UserModel getUserModel] setTokenUrlDelegate:self];
}

- (void)delaySwitchAccounts:(NSTimer*)theTimer
{
    [level1ViewController addAnotherButtonPressed:nil];
}

- (void)delayNavPush:(NSTimer*)theTimer
{
    [[self navigationController] pushViewController:level1ViewController animated:YES];
}

/* Go to www.janrain.com */
- (IBAction)janrainLinkClicked:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.janrain.com"];
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

/* If any of the small icons are touched, show the faint outline of the surrounding button... */
- (IBAction)signInButtonOnEvent:(id)sender
{
    if (sender == signInButton)
        signInButton.alpha = 0.2;
}

/* and if that touch is released, hide the faint outline of the surrounding button. */
- (IBAction)signInButtonOffEvent:(id)sender
{
    if (sender == signInButton)
        signInButton.alpha = 0.02;
}

- (IBAction)signInButtonPressed:(id)sender
{
//#ifdef LILLI
    if (iPad)
    {
        libraryDialogShowing = YES;
        [[UserModel getUserModel] setLibraryDialogDelegate:self];

        if (sender == signInButton)
            [[UserModel getUserModel] setCustomInterface:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                          [NSValue valueWithCGRect:
                                                           [layoutViewInside convertRect:signInButton.frame
                                                                                  toView:[[UIApplication sharedApplication] keyWindow]]],
                                                          kJRPopoverPresentationFrameValue,
                                                          [NSNumber numberWithInt:UIPopoverArrowDirectionDown],
                                                          kJRPopoverPresentationArrowDirection, nil]];
        else
            [[UserModel getUserModel] setCustomInterface:[NSMutableDictionary dictionaryWithObjectsAndKeys:nil]];

        if ([[UserModel getUserModel] currentUser])
        {
            [[UserModel getUserModel] startSignUserOut:self];
            [[UserModel getUserModel] startSignUserIn:self];
        }
        else
        {
            [[UserModel getUserModel] startSignUserIn:self];
        }
    }
    else
    {/* Drill down a level, then after half a second, sign the user in. */
        [[self navigationController] pushViewController:level1ViewController animated:YES];
        [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(delaySwitchAccounts:) userInfo:nil repeats:NO];
    }
//#else
//  [[UserModel getUserModel] startSignUserIn:level1ViewController];
//  [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(delayNavPush:) userInfo:nil repeats:NO];
//#endif
}

- (IBAction)viewHistoryButtonPressed:(id)sender
{
    [[self navigationController] pushViewController:level1ViewController animated:YES];
}

- (void)didFailToSignIn:(BOOL)showMessage
{
    if (showMessage)
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Log In Failed"
                                                         message:@"An error occurred while attempting to sign you in.  Please try again."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil] autorelease];
        [alert show];
    }
}

- (void)libraryDialogClosed
{
    libraryDialogShowing = NO;
}

- (void)userDidSignIn
{
    [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(delayNavPush:) userInfo:nil repeats:NO];
}

- (void)userDidSignOut { }
- (void)didReceiveToken { }

- (void)didReachTokenUrl
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Sign-In Complete"
                                                     message:@"You have successfully signed-in to the Quick Sign-In application and server."
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
    [alert show];
}

- (void)didFailToReachTokenUrl
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Sign-In Error"
                                                     message:@"An error occurred while attempting to sign you in to the Quick Sign-In server."
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
    [alert show];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (iPad && !libraryDialogShowing)
        return YES;

    return NO;//(toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (iPad)
        return;

    switch (toInterfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            [layoutViewOutside setFrame:CGRectMake(0, 60, 320, 267)];
            [layoutViewInside  setFrame:CGRectMake(0, 100, 320, 167)];
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            [layoutViewOutside setFrame:CGRectMake(80, 0, 320, 267)];
            [layoutViewInside  setFrame:CGRectMake(0, 75, 320, 147)];
            break;
        default:
            break;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if ([[UserModel getUserModel] pendingCallToTokenUrl])
        [[UserModel getUserModel] setTokenUrlDelegate:nil];

}

- (void)viewDidUnload { }

- (void)dealloc
{
    [signInButton release];
    [linkButton release];
    [level1ViewController release];

    [super dealloc];
}
@end
