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

@interface ViewController ()
@property (strong) SharedData *sharedData;
@end

@implementation ViewController
@synthesize sharedData;
@synthesize currentUserLabel;
@synthesize currentUserProviderIcon;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sharedData = [SharedData sharedData];

    if (sharedData.currentDisplayName)
        currentUserLabel.text = [NSString stringWithFormat:@"Current user: %@", sharedData.currentDisplayName];

    if (sharedData.currentProvider)
        currentUserProviderIcon.image = [UIImage imageNamed:
                     [NSString stringWithFormat:@"icon_%@_30x30@2x.png", sharedData.currentProvider]];
}

- (IBAction)browseButtonPressed:(id)sender
{
    ObjectDrillDownViewController *drillDown =
                [[ObjectDrillDownViewController alloc] initWithNibName:@"ObjectDrillDownViewController"
                                                                bundle:[NSBundle mainBundle]
                                                             forObject:sharedData.captureUser
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
//    [sharedData.captureUser replaceGamesArrayOnCaptureForDelegate:self withContext:nil];
//    [sharedData.captureUser replaceTesterStringPluralArrayOnCaptureForDelegate:self withContext:nil];
//
//    [[SharedData sharedData] resaveCaptureUser];


//    NSMutableString *mutableString = [NSMutableString stringWithString:@"foo"];
//    NSString *string = [NSString stringWithString:@"baz"];
//
//    sharedData.captureUser.aboutMe = mutableString;
//
//    mutableString = (NSMutableString *) sharedData.captureUser.aboutMe;
//
//    @try { [mutableString appendString:@"bar"]; }
//    @catch(NSException *e){ }
//
//
//    DLog(@"%@", mutableString);
}

- (void)replaceArray:(NSArray *)array named:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    DLog(@"");
}

- (void)replaceArrayNamed:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{
    DLog(@"");
}

- (IBAction)signInButtonPressed:(id)sender
{
    NSDictionary *customInterface = [NSDictionary dictionaryWithObject:self.navigationController
                                                                forKey:kJRApplicationNavigationController];

    [sharedData startAuthenticationWithCustomInterface:customInterface forDelegate:self];
}

- (void)engageSignInDidSucceed
{
    currentUserLabel.text         =
            [NSString stringWithFormat:@"Current user: %@", sharedData.currentDisplayName];
    currentUserProviderIcon.image =
            [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@_30x30@2x.png", sharedData.currentProvider]];
}

- (void)captureSignInDidSucceed
{
    if (sharedData.notYetCreated || sharedData.isNew)
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
