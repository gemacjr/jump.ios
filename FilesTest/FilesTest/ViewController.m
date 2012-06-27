//
//  ViewController.m
//  FilesTest
//
//  Created by Lilli Szafranski on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

static NSString *appId = @"appcfamhnpkagijaeinl";
static NSString *tokenUrl = @"http://jrauthenticate.appspot.com/login";

@implementation ViewController
@synthesize myButton;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    jrEngage = [JREngage jrEngageWithAppId:appId andTokenUrl:tokenUrl delegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)signinButtonPressed:(id)sender
{
    [jrEngage showAuthenticationDialog];
}

- (void)jrEngageDialogDidFailToShowWithError:(NSError*)error{}
- (void)jrAuthenticationDidNotComplete{}
- (void)jrAuthenticationDidSucceedForUser:(NSDictionary*)auth_info forProvider:(NSString*)provider{}
- (void)jrAuthenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider{}
- (void)jrAuthenticationDidReachTokenUrl:(NSString*)tokenUrl withResponse:(NSURLResponse*)response andPayload:(NSData*)tokenUrlPayload forProvider:(NSString*)provider{}
- (void)jrAuthenticationCallToTokenUrl:(NSString*)tokenUrl didFailWithError:(NSError*)error forProvider:(NSString*)provider{}
- (void)jrSocialDidNotCompletePublishing{}
- (void)jrSocialDidCompletePublishing{}
- (void)jrSocialDidPublishActivity:(JRActivityObject*)activity forProvider:(NSString*)provider{}
- (void)jrSocialPublishingActivity:(JRActivityObject*)activity didFailWithError:(NSError*)error forProvider:(NSString*)provider{}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
