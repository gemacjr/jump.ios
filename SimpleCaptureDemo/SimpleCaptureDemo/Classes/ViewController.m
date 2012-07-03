//
//  ViewController.m
//  SimpleCaptureDemo
//
//  Created by lilli on 02/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
    DLog(@"");
}

- (IBAction)signInButtonPressed:(id)sender
{
    [self setButtonsEnabled:NO];
    currentUserLabel.text         = @"No current user   ";
    currentUserProviderIcon.image = nil;

    NSDictionary *customInterface = [NSDictionary dictionaryWithObject:self.navigationController
                                                                forKey:kJRApplicationNavigationController];

    [SharedData startAuthenticationWithCustomInterface:customInterface forDelegate:self];
}

- (void)engageSignInDidSucceed
{
    currentUserLabel.text         =
            [NSString stringWithFormat:@"Current user: %@", [SharedData currentDisplayName]];
    currentUserProviderIcon.image =
            [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@_30x30@2x.png", [SharedData currentProvider]]];
}

- (void)captureSignInDidSucceed
{
    [self setButtonsEnabled:YES];

    if ([SharedData notYetCreated] || [SharedData isNew])
    {
        CaptureNewUserViewController *viewController = [[CaptureNewUserViewController alloc]
                initWithNibName:@"CaptureNewUserViewController" bundle:[NSBundle mainBundle]];

        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)engageSignInDidFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error ? @"Error" : @"Canceled"
                                                        message:error ? [error description] : @"Authentication was canceled"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
    [alertView show];
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
