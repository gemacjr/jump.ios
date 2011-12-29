//
//  JREngagePhoneGapWrapper.m
//  JREngage
//
//  Created by Lilli Szafranski on 12/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "JREngagePhoneGapWrapper.h"

@implementation JREngagePhoneGapWrapper
@synthesize callbackID;
- (id)init
{
    self = [super init];
    if (self)
    {

    }

    return self;
}

- (void)print:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    DLog(@"Here...%@", [arguments description]);
    ALog(@"Here, still...");

    //The first argument in the arguments parameter is the callbackID.
    //We use this to send data back to the successCallback or failureCallback
    //through PluginResult.
    self.callbackID = [arguments pop];

    DLog(@"[arguments pop]: %@", callbackID);

    //Get the string that javascript sent us
    NSString *stringObtainedFromJavascript = [arguments objectAtIndex:0];

    //Create the Message that we wish to send to the Javascript
    NSMutableString *stringToReturn = [NSMutableString stringWithString: @"StringReceived:"];
    //Append the received string to the string we plan to send out
    [stringToReturn appendString: stringObtainedFromJavascript];
    //Create Plugin Result
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK messageAsString:
                                  [stringToReturn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //Checking if the string received is HelloWorld or not
    if([stringObtainedFromJavascript isEqualToString:@"HelloWorld"]==YES)
    {
        //Call  the Success Javascript function
        [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];

    }
    else
    {
        //Call  the Failure Javascript function
        [self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];

    }
}

- (void)initializeJREngage:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callbackID = [arguments pop];

    NSString *appId = nil;
    NSString *tokenUrl = nil;

    if ([arguments count])
        appId = [arguments objectAtIndex:0];// pop];

    if ([arguments count] > 1)
        tokenUrl = [arguments objectAtIndex:1];// pop];

    jrEngage = [JREngage jrEngageWithAppId:appId andTokenUrl:tokenUrl delegate:self];

}

- (void)showAuthenticationDialog:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callbackID = [arguments pop];

    [jrEngage showAuthenticationDialog];
}

- (void)sendSuccessMessage:(NSString *)message
{
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK
                                                messageAsString:
                                      [message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    [self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];
}

- (void)sendFailureMessage:(NSString *)message
{
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK
                                                messageAsString:
                                      [message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    [self writeJavascript:[pluginResult toErrorCallbackString:self.callbackID]];
}

- (void)jrEngageDialogDidFailToShowWithError:(NSError*)error
{
    [self sendFailureMessage:[error description]];
}

- (void)jrAuthenticationDidNotComplete { }

- (void)jrAuthenticationDidSucceedForUser:(NSDictionary*)auth_info
                              forProvider:(NSString*)provider
{
    [self sendSuccessMessage:[NSString stringWithFormat:@"AUTH SUCCESS: %@, %@", [auth_info description], provider]];
}

- (void)jrAuthenticationDidFailWithError:(NSError*)error
                             forProvider:(NSString*)provider
{
    [self sendFailureMessage:[error description]];
}

- (void)jrAuthenticationDidReachTokenUrl:(NSString*)tokenUrl
                            withResponse:(NSURLResponse*)response
                              andPayload:(NSData*)tokenUrlPayload
                             forProvider:(NSString*)provider
{
//    [self sendSuccessMessage:[NSString stringWithFormat:@"TOKEN URL SUCCESS: %@, %@", , provider]];

}

- (void)jrAuthenticationCallToTokenUrl:(NSString*)tokenUrl
                      didFailWithError:(NSError*)error
                           forProvider:(NSString*)provider { }

- (void)jrSocialDidNotCompletePublishing { }

- (void)jrSocialDidCompletePublishing { }

- (void)jrSocialDidPublishActivity:(JRActivityObject*)activity
                       forProvider:(NSString*)provider { }

- (void)jrSocialPublishingActivity:(JRActivityObject*)activity
                  didFailWithError:(NSError*)error
                       forProvider:(NSString*)provider { }
@end
























