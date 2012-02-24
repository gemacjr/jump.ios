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
@property (nonatomic, retain) JREngage *jrEngage;
@property (strong) NSDictionary   *engageUser;
@property (strong) JRCaptureUser  *captureUser;
@property (strong) NSString       *accessToken;
@property (strong) NSString       *creationToken;
@property (strong) NSUserDefaults *prefs;
@end

@implementation ViewController
@synthesize jrEngage;
@synthesize accessToken;
@synthesize captureUser;
@synthesize engageUser;
@synthesize creationToken;
@synthesize prefs;
@synthesize currentUserLabel;
@synthesize currentUserProviderIcon;


static NSString *appId    = @"mlfeingbenjalleljkpo";
static NSString *tokenUrl = nil;

static NSString *captureDomain  = @"https://demo.staging.janraincapture.com/";
static NSString *clientId       = @"svaf3gxsmcvyfpx5vcrdwyv2axvy9zqg";
static NSString *entityTypeName = @"demo_user";

//static NSString * const appId = @"appcfamhnpkagijaeinl";
//static NSString * const tokenUrl = @"http://jrauthenticate.appspot.com/login";


- (void)viewDidLoad
{
    [super viewDidLoad];

    [JRCaptureInterface setCaptureDomain:captureDomain clientId:clientId andEntityTypeName:entityTypeName];
    self.jrEngage = [JREngage jrEngageWithAppId:appId
                                    andTokenUrl:[JRCaptureInterface captureMobileEndpointUrl]
                                       delegate:self];

    self.prefs = [NSUserDefaults standardUserDefaults];
    self.engageUser = [prefs objectForKey:@"engageUser"];
    self.captureUser = [JRCaptureUser captureUserObjectFromDictionary:[prefs objectForKey:@"captureUser"]];
    self.accessToken = [prefs objectForKey:@"accessToken"];
    self.creationToken = [prefs objectForKey:@"creationToken"];

    if ([prefs objectForKey:@"displayName"])
        currentUserLabel.text = [NSString stringWithFormat:@"Current user: %@", [prefs objectForKey:@"displayName"]];

    if ([prefs objectForKey:@"provider"])
        currentUserProviderIcon.image = [UIImage imageNamed:
                     [NSString stringWithFormat:@"icon_%@_30x30@2x.png", [prefs objectForKey:@"provider"]]];
}

- (IBAction)browseButtonPressed:(id)sender
{

}

- (IBAction)updateButtonPressed:(id)sender
{

}

- (IBAction)deleteButtonPressed:(id)sender
{

}

- (IBAction)signInButtonPressed:(id)sender
{
    NSDictionary *customUI = [NSDictionary dictionaryWithObject:self.navigationController
                                                         forKey:kJRApplicationNavigationController];

    [jrEngage showAuthenticationDialogWithCustomInterfaceOverrides:customUI];
}

+ (NSString*)getDisplayNameFromProfile:(NSDictionary*)profile
{
    NSString *name = nil;

    if ([profile objectForKey:@"preferredUsername"])
        name = [NSString stringWithFormat:@"%@", [profile objectForKey:@"preferredUsername"]];
    else if ([[profile objectForKey:@"name"] objectForKey:@"formatted"])
        name = [NSString stringWithFormat:@"%@",
                [[profile objectForKey:@"name"] objectForKey:@"formatted"]];
    else
        name = [NSString stringWithFormat:@"%@%@%@%@%@",
                ([[profile objectForKey:@"name"] objectForKey:@"honorificPrefix"]) ?
                [NSString stringWithFormat:@"%@ ",
                 [[profile objectForKey:@"name"] objectForKey:@"honorificPrefix"]] : @"",
                ([[profile objectForKey:@"name"] objectForKey:@"givenName"]) ?
                [NSString stringWithFormat:@"%@ ",
                 [[profile objectForKey:@"name"] objectForKey:@"givenName"]] : @"",
                ([[profile objectForKey:@"name"] objectForKey:@"middleName"]) ?
                [NSString stringWithFormat:@"%@ ",
                 [[profile objectForKey:@"name"] objectForKey:@"middleName"]] : @"",
                ([[profile objectForKey:@"name"] objectForKey:@"familyName"]) ?
                [NSString stringWithFormat:@"%@ ",
                 [[profile objectForKey:@"name"] objectForKey:@"familyName"]] : @"",
                ([[profile objectForKey:@"name"] objectForKey:@"honorificSuffix"]) ?
                [NSString stringWithFormat:@"%@ ",
                 [[profile objectForKey:@"name"] objectForKey:@"honorificSuffix"]] : @""];

    return name;
}


- (void)jrAuthenticationCallToTokenUrl:(NSString *)tokenUrl didFailWithError:(NSError *)error forProvider:(NSString *)provider
{

}

- (void)jrAuthenticationDidFailWithError:(NSError *)error forProvider:(NSString *)provider
{

}

- (void)jrAuthenticationDidNotComplete
{

}

- (void)jrAuthenticationDidSucceedForUser:(NSDictionary *)auth_info forProvider:(NSString *)provider
{
    self.engageUser = auth_info;

 /* Get the display name */
    NSString *displayName = [ViewController getDisplayNameFromProfile:[engageUser objectForKey:@"profile"]];

    currentUserLabel.text = [NSString stringWithFormat:@"Current user: %@", displayName];
    currentUserProviderIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@_30x30@2x.png", provider]];

    [prefs setObject:engageUser forKey:@"engageUser"];
    [prefs setObject:displayName forKey:@"displayName"];
    [prefs setObject:provider forKey:@"provider"];
}

- (void)jrAuthenticationDidReachTokenUrl:(NSString *)tokenUrl withResponse:(NSURLResponse *)response
                              andPayload:(NSData *)tokenUrlPayload forProvider:(NSString *)provider
{

}

- (void)jrEngageDialogDidFailToShowWithError:(NSError *)error
{

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
