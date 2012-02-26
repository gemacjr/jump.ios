/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

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

 File:   JRCaptureInterface.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Thursday, January 26, 2012
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "JRCaptureInterface.h"
#import "JSONKit.h"

@interface NSString (NSString_JSON_ESCAPE)
- (NSString*)URLEscaped;
@end

@implementation NSString (NSString_JSON_ESCAPE)
- (NSString*)URLEscaped
{

    NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                NULL,
                                (CFStringRef)self,
                                NULL,
                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                kCFStringEncodingUTF8);

    return encodedString;
}
@end

@interface JRCaptureInterface ()
@property (nonatomic, retain) id<JRCaptureInterfaceDelegate> captureInterfaceDelegate;
//@property (nonatomic, retain) JRCaptureUser *captureUser;
@property (nonatomic, copy)   NSString      *captureCreationToken;
@property (nonatomic, copy)   NSString      *captureAccessToken;
@property (nonatomic, copy)   NSString      *captureDomain;
@property (nonatomic, copy)   NSString      *clientId;
@property (nonatomic, copy)   NSString      *entityTypeName;
@end

@implementation JRCaptureInterface
@synthesize captureInterfaceDelegate;
//@synthesize captureUser;
@synthesize captureCreationToken;
@synthesize captureAccessToken;
@synthesize captureDomain;
@synthesize clientId;
@synthesize entityTypeName;

static JRCaptureInterface *singleton = nil;

- (JRCaptureInterface*)init
{
    if ((self = [super init])) { }

    return self;
}

+ (id)captureInterfaceInstance
{
    if (singleton == nil) {
        singleton = [((JRCaptureInterface*)[super allocWithZone:NULL]) init];
    }

    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self captureInterfaceInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release { }

- (id)autorelease
{
    return self;
}

+ (NSString *)captureMobileEndpointUrl
{
    JRCaptureInterface *captureInterface = [JRCaptureInterface captureInterfaceInstance];
    return [NSString stringWithFormat:@"%@/oauth/mobile_signin?client_id=%@&redirect_uri=https://example.com",
                     captureInterface.captureDomain, captureInterface.clientId];
}

+ (void)setCaptureDomain:(NSString *)newCaptureDomain clientId:(NSString *)newClientId andEntityTypeName:(NSString *)newEntityTypeName
{
    JRCaptureInterface *captureInterface = [JRCaptureInterface captureInterfaceInstance];
    captureInterface.clientId       = newClientId;
    captureInterface.captureDomain  = newCaptureDomain;
    captureInterface.entityTypeName = newEntityTypeName;
}

typedef enum CaptureInterfaceStatEnum
{
    StatOk,
    StatFail,
} CaptureInterfaceStat;

- (void)finishCreateCaptureUserWithStat:(CaptureInterfaceStat)stat andResult:(NSString*)result
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([captureInterfaceDelegate respondsToSelector:@selector(createCaptureUserDidSucceedWithResult:)])
            [captureInterfaceDelegate createCaptureUserDidSucceedWithResult:result];
    }
    else
    {
        if ([captureInterfaceDelegate respondsToSelector:@selector(createCaptureUserDidFailWithResult:)])
            [captureInterfaceDelegate createCaptureUserDidFailWithResult:result];
    }

    self.captureInterfaceDelegate = nil;
}

- (void)startCreateCaptureUser:(NSDictionary*)user
{
    DLog(@"");

    NSString      *attributes = [[user JSONString] URLEscaped];
    NSMutableData *body       = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"type_name=%@", entityTypeName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&attributes=%@", attributes] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&creation_token=%@", captureCreationToken] dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity.create", captureDomain]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"createUser", @"action",
                                        user, @"user", nil];

    // TODO: Better error format
    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishCreateCaptureUserWithStat:StatFail andResult:@"url failed"];

    DLog(@"request: %@, user: %@", request, [user JSONString]);
}

- (void)finishUpdateCaptureUserWithStat:(CaptureInterfaceStat)stat andResult:(NSString*)result
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([captureInterfaceDelegate respondsToSelector:@selector(updateCaptureUserDidSucceedWithResult:)])
            [captureInterfaceDelegate updateCaptureUserDidSucceedWithResult:result];
    }
    else
    {
        if ([captureInterfaceDelegate respondsToSelector:@selector(updateCaptureUserDidFailWithResult:)])
            [captureInterfaceDelegate updateCaptureUserDidFailWithResult:result];
    }

    self.captureInterfaceDelegate = nil;
}

- (void)startUpdateCaptureUser:(NSDictionary*)user
{
    DLog(@"");

    NSString      *attributes = [[user JSONString] URLEscaped];
    NSMutableData *body       = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"type_name=%@", entityTypeName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&attributes=%@", attributes] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", captureAccessToken] dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity.update", captureDomain]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"updateUser", @"action",
                                        user, @"user", nil];

    // TODO: Better error format
    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishUpdateCaptureUserWithStat:StatFail andResult:@"url failed"];

    DLog(@"request: %@, user: %@", request, [user JSONString]);
}

- (void)finishGetEntityWithStat:(CaptureInterfaceStat)stat andResult:(NSString*)result
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([captureInterfaceDelegate respondsToSelector:@selector(getCaptureEntityDidSucceedWithResult:)])
            [captureInterfaceDelegate getCaptureEntityDidSucceedWithResult:result];
    }
    else
    {
        if ([captureInterfaceDelegate respondsToSelector:@selector(getCaptureEntityDidFailWithResult:)])
            [captureInterfaceDelegate getCaptureEntityDidFailWithResult:result];
    }

    self.captureInterfaceDelegate = nil;
}

- (void)startGetEntityWithName:(NSString*)entityName andId:(NSInteger)entityId
{
    DLog(@"");

    NSString      *attributeName = [NSString stringWithFormat:@"attribute_name=%@#%d", entityName, entityId];
    NSMutableData *body          = [NSMutableData data];

//    [body appendData:[[NSString stringWithFormat:@"type_name=%@", entityName] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"id=%d", entityId] dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[attributeName dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", captureAccessToken] dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity", captureDomain]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"getEntity", @"action",
                                        attributeName, @"attributeName", nil];

    // TODO: Better error format
    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishCreateCaptureUserWithStat:StatFail andResult:@"url failed"];

    DLog(@"request: %@, access token: %@, attribute name: %@", request, captureAccessToken, attributeName);
}

- (void)finishGetCaptureUserWithStat:(CaptureInterfaceStat)stat andResult:(NSString*)result
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([captureInterfaceDelegate respondsToSelector:@selector(getCaptureUserDidSucceedWithResult:)])
            [captureInterfaceDelegate getCaptureUserDidSucceedWithResult:result];
    }
    else
    {
        if ([captureInterfaceDelegate respondsToSelector:@selector(getCaptureUserDidFailWithResult:)])
            [captureInterfaceDelegate getCaptureUserDidFailWithResult:result];
    }

    self.captureInterfaceDelegate = nil;
}

- (void)startGetCaptureUser
{
    DLog(@"");

    NSMutableData *body          = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"type_name=%@", entityTypeName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", captureAccessToken] dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity", captureDomain]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"getUser", @"action", nil];
            //attributeName, @"attributeName", nil];

    // TODO: Better error format
    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishCreateCaptureUserWithStat:StatFail andResult:@"url failed"];

//    DLog(@"request: %@, access token: %@, attribute name: %@", request, captureAccessToken, attributeName);
}

+ (void)createCaptureUser:(NSDictionary *)user withCreationToken:(NSString *)creationToken
              forDelegate:(id<JRCaptureInterfaceDelegate>)delegate
{
    DLog(@"");
   JRCaptureInterface *captureInterface = [JRCaptureInterface captureInterfaceInstance];

    captureInterface.captureInterfaceDelegate = delegate;
    captureInterface.captureCreationToken     = creationToken;

    [captureInterface startCreateCaptureUser:user];
}

+ (void)updateCaptureUser:(NSDictionary *)user withAccessToken:(NSString *)accessToken
              forDelegate:(id<JRCaptureInterfaceDelegate>)delegate
{
    DLog(@"");
   JRCaptureInterface *captureInterface = [JRCaptureInterface captureInterfaceInstance];

    captureInterface.captureInterfaceDelegate = delegate;
    captureInterface.captureAccessToken       = accessToken;

    [captureInterface startUpdateCaptureUser:user];
}

+ (void)getCaptureEntityNamed:(NSString *)entityName withEntityId:(NSInteger)entityId
               andAccessToken:(NSString *)accessToken forDelegate:(id<JRCaptureInterfaceDelegate>)delegate
{
    JRCaptureInterface *captureInterface = [JRCaptureInterface captureInterfaceInstance];

     captureInterface.captureInterfaceDelegate = delegate;
     captureInterface.captureAccessToken       = accessToken;

     [captureInterface startGetEntityWithName:entityName andId:entityId];
}

+ (void)getCaptureUserWithAccessToken:(NSString *)accessToken forDelegate:(id<JRCaptureInterfaceDelegate>)delegate
{
    JRCaptureInterface *captureInterface = [JRCaptureInterface captureInterfaceInstance];

     captureInterface.captureInterfaceDelegate = delegate;
     captureInterface.captureAccessToken       = accessToken;

     [captureInterface startGetCaptureUser];
}

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(NSObject*)userdata
{
    DLog(@"%@", payload);

    NSDictionary *tag = (NSDictionary*)userdata;
    NSString *action  = [tag objectForKey:@"action"];

    if ([action isEqualToString:@"createUser"])
    {
        NSDictionary *response = [payload objectFromJSONString];
        if ([(NSString *)[response objectForKey:@"stat"] isEqualToString:@"ok"])
        {
            DLog(@"Capture creation success: %@", payload);
            [self finishCreateCaptureUserWithStat:StatOk andResult:payload];
        }
        else
        {
            DLog(@"Capture creation failure: %@", payload);
            [self finishCreateCaptureUserWithStat:StatFail andResult:payload];
        }
    }
    else if ([action isEqualToString:@"updateUser"])
    {
        NSDictionary *response = [payload objectFromJSONString];
        if ([(NSString *)[response objectForKey:@"stat"] isEqualToString:@"ok"])
        {
            DLog(@"Capture update success: %@", payload);
            [self finishUpdateCaptureUserWithStat:StatOk andResult:payload];
        }
        else
        {
            DLog(@"Capture update failure: %@", payload);
            [self finishUpdateCaptureUserWithStat:StatFail andResult:payload];
        }
    }
    else if ([action isEqualToString:@"getEntity"])
    {
        NSDictionary *response = [payload objectFromJSONString];
        if ([(NSString *)[response objectForKey:@"stat"] isEqualToString:@"ok"])
        {
            DLog(@"Get entity success: %@", payload);
            [self finishGetEntityWithStat:StatOk andResult:payload];
        }
        else
        {
            DLog(@"Get entity failure: %@", payload);
            [self finishGetEntityWithStat:StatFail andResult:payload];
        }
    }
    else if ([action isEqualToString:@"getUser"])
    {
        NSDictionary *response = [payload objectFromJSONString];
        if ([(NSString *)[response objectForKey:@"stat"] isEqualToString:@"ok"])
        {
            DLog(@"Get entity success: %@", payload);
            [self finishGetCaptureUserWithStat:StatOk andResult:payload];
        }
        else
        {
            DLog(@"Get entity failure: %@", payload);
            [self finishGetCaptureUserWithStat:StatFail andResult:payload];
        }
    }
}

- (void)connectionDidFinishLoadingWithFullResponse:(NSURLResponse*)fullResponse
                                  unencodedPayload:(NSData*)payload
                                           request:(NSURLRequest*)request
                                            andTag:(NSObject*)userdata
{

}

- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(NSObject*)userdata
{
    DLog(@"");

    NSDictionary *tag = (NSDictionary*)userdata;
    NSString *action  = [tag objectForKey:@"action"];

    // TODO: Better error format
    NSString *result = @"connection failed";

    if ([action isEqualToString:@"createUser"])
    {
        [self finishCreateCaptureUserWithStat:StatFail andResult:result];
    }
    else if ([action isEqualToString:@"updateUser"])
    {
        [self finishUpdateCaptureUserWithStat:StatFail andResult:result];
    }
    else if ([action isEqualToString:@"getEntity"])
    {
        [self finishGetEntityWithStat:StatFail andResult:result];
    }
    else if ([action isEqualToString:@"getUser"])
    {
        [self finishGetCaptureUserWithStat:StatFail andResult:result];
    }
}

- (void)connectionWasStoppedWithTag:(NSObject*)userdata { }

- (void)dealloc
{
    [captureInterfaceDelegate release];
    //[captureUser release];
    [captureCreationToken release];

    [clientId release];
    [captureDomain release];
    [entityTypeName release];
    [captureAccessToken release];
    [super dealloc];
}

@end
