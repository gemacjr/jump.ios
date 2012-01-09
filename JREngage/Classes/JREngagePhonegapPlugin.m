//
//  JREngagePhonegapPlugin.m
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

#import <PhoneGap/JSONKit.h>
#import "JREngagePhonegapPlugin.h"

@interface NSString (NSString_JSON_ESCAPING)
- (NSString*)JSONEscape;
@end

@implementation NSString (NSString_JSON_ESCAPING)
- (NSString*)JSONEscape
{

    NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                NULL,
                                (CFStringRef)self,
                                NULL,
                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                kCFStringEncodingUTF8);

    return encodedString;

//    NSString *str = [self stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
//    str = [str stringByReplacingOccurrencesOfString:@":" withString:@"%3a"];
//    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"%34"];
//    str = [str stringByReplacingOccurrencesOfString:@";" withString:@"%3b"];
//
//    return str;
}
@end


@interface JREngagePhonegapPlugin ()
@property (nonatomic, retain) NSMutableDictionary *fullAuthenticationResponse;
//@property (nonatomic, retain) NSDictionary        *authInfo;
@end

@implementation JREngagePhonegapPlugin
@synthesize callbackID;
@synthesize fullAuthenticationResponse;
//@synthesize authInfo;

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


    NSString *appId;
    if ([arguments count])
        appId = [arguments objectAtIndex:0];
    else
    {
        PluginResult* result = [PluginResult resultWithStatus:PGCommandStatus_ERROR
                                              messageAsString:@"Missing appId in call to initialize"];

        [self writeJavascript:[result toSuccessCallbackString:self.callbackID]];
        return;
    }

    NSString *tokenUrl = nil;
    if ([arguments count] > 1)
        tokenUrl = [arguments objectAtIndex:1];

    jrEngage = [JREngage jrEngageWithAppId:appId andTokenUrl:tokenUrl delegate:self];

    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK
                                                messageAsString:@"Initializing JREngage"];

    [self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];
}

- (void)showAuthenticationDialog:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callbackID = [arguments pop];

    [jrEngage showAuthenticationDialog];
}

- (void)sendSuccessMessage:(NSString *)message
{
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK
                                                messageAsString:[message JSONEscape]];
                                      //[message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    [self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];
}

- (void)sendFailureMessage:(NSString *)message
{
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK
                                                messageAsString:[message JSONEscape]];
                                      //[message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    [self writeJavascript:[pluginResult toErrorCallbackString:self.callbackID]];
}

- (void)jrEngageDialogDidFailToShowWithError:(NSError*)error
{
    // TODO: Build error JSON object to send that back
    // [self sendFailureMessage:[error description]];
}

- (void)jrAuthenticationDidNotComplete
{
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_ERROR]
    [self writeJavascript:[pluginResult ]]
}

- (void)jrAuthenticationDidSucceedForUser:(NSDictionary*)auth_info
                              forProvider:(NSString*)provider
{
    if (!fullAuthenticationResponse)
        self.fullAuthenticationResponse = [NSMutableDictionary dictionaryWithCapacity:5];

    // TODO: Remove the 'stat' key/value from auth_info dictionary

    [fullAuthenticationResponse setObject:auth_info forKey:@"auth_info"];
    [fullAuthenticationResponse setObject:provider forKey:@"provider"];

//    [self sendSuccessMessage:[NSString stringWithFormat:@"AUTH SUCCESS: %@, %@", [auth_info description], provider]];
}

- (void)jrAuthenticationDidFailWithError:(NSError*)error
                             forProvider:(NSString*)provider
{
    // TODO: Build error JSON object to send that back
//    [self sendFailureMessage:[error description]];
}

- (void)jrAuthenticationDidReachTokenUrl:(NSString*)tokenUrl
                            withResponse:(NSURLResponse*)response
                              andPayload:(NSData*)tokenUrlPayload
                             forProvider:(NSString*)provider
{
    if (!fullAuthenticationResponse) /* That's not right! */;

    NSString *payloadString = [[[NSString alloc] initWithData:tokenUrlPayload encoding:NSASCIIStringEncoding] autorelease];

    [fullAuthenticationResponse setObject:tokenUrl forKey:@"tokenUrl"];
    [fullAuthenticationResponse setObject:(payloadString ? payloadString : (void *) kCFNull)
                                   forKey:@"tokenUrlPayload"];
    [fullAuthenticationResponse setObject:@"ok" forKey:@"stat"];

    NSString *authResponseString = [fullAuthenticationResponse JSONString];

    [self sendSuccessMessage:authResponseString];
}

- (void)jrAuthenticationCallToTokenUrl:(NSString*)tokenUrl
                      didFailWithError:(NSError*)error
                           forProvider:(NSString*)provider
{
    // TODO: Build error JSON object to send that back
}

//- (void)jrSocialDidNotCompletePublishing { }
//
//- (void)jrSocialDidCompletePublishing { }
//
//- (void)jrSocialDidPublishActivity:(JRActivityObject*)activity
//                       forProvider:(NSString*)provider { }
//
//- (void)jrSocialPublishingActivity:(JRActivityObject*)activity
//                  didFailWithError:(NSError*)error
//                       forProvider:(NSString*)provider { }

- (void)dealloc
{
    [fullAuthenticationResponse release];
    [super dealloc];
}
@end
























