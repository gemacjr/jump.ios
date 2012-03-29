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

    return [encodedString autorelease];
}
@end

@implementation JRCaptureInterface
static JRCaptureInterface *singleton = nil;

/* Here for testing against Carl's local instance */
/* TODO: Remove when done */
static NSString *appIdArg   = nil;
//static NSString *appIdArg = @"&application_id=qx3ss262yufnmpb3ck93jr3zfs"

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

typedef enum CaptureInterfaceStatEnum
{
    StatOk,
    StatFail,
} CaptureInterfaceStat;

- (void)finishGetCaptureUserWithStat:(CaptureInterfaceStat)stat andResult:(NSString*)result
                         forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(getCaptureUserDidSucceedWithResult:context:)])
            [delegate getCaptureUserDidSucceedWithResult:result context:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(getCaptureUserDidFailWithResult:context:)])
            [delegate getCaptureUserDidFailWithResult:result context:context];
    }
}

- (void)startGetCaptureUserWithToken:(NSString *)token
                         forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    NSMutableData *body = [NSMutableData data];

    // TODO: Do we need this for generic entities and will we need a different one for the top-level capture user??
    [body appendData:[[NSString stringWithFormat:@"type_name=%@", [JRCaptureData entityTypeName]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];

    if (appIdArg)
        [body appendData:[appIdArg dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity", [JRCaptureData captureApidDomain]]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *newTag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"getUser", @"action",
                                        delegate, @"delegate",
                                        context, @"context", nil];

    DLog(@"%@ type_name=%@ access_token=%@", [[request URL] absoluteString], [JRCaptureData entityTypeName], token);

    // TODO: Better error format
    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:newTag])
        [self finishGetCaptureUserWithStat:StatFail andResult:@"url failed" forDelegate:delegate withContext:context];
}

- (void)finishCreateCaptureUserWithStat:(CaptureInterfaceStat)stat andResult:(NSString*)result
                            forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(createCaptureUserDidSucceedWithResult:context:)])
            [delegate createCaptureUserDidSucceedWithResult:result context:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(createCaptureUserDidFailWithResult:context:)])
            [delegate createCaptureUserDidFailWithResult:result context:context];
    }
}

- (void)startCreateCaptureUser:(NSDictionary *)captureUser withToken:(NSString *)token
                   forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    NSString      *attributes = [[captureUser JSONString] URLEscaped];
    NSMutableData *body       = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"type_name=%@", [JRCaptureData entityTypeName]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&attributes=%@", attributes] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&creation_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];

    if (appIdArg)
        [body appendData:[appIdArg dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity.create", [JRCaptureData captureApidDomain]]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"createUser", @"action",
                                        delegate, @"delegate",
                                        context, @"context", nil];

    DLog(@"%@ type_name=%@ attributes=%@ creation_token=%@", [[request URL] absoluteString], [JRCaptureData entityTypeName], attributes, token);

    // TODO: Better error format
    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishCreateCaptureUserWithStat:StatFail andResult:@"url failed" forDelegate:delegate withContext:context];
}

- (void)finishUpdateObjectWithStat:(CaptureInterfaceStat)stat andResult:(NSString*)result
                       forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(updateCaptureObjectDidSucceedWithResult:context:)])
            [delegate updateCaptureObjectDidSucceedWithResult:result context:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(updateCaptureObjectDidFailWithResult:context:)])
            [delegate updateCaptureObjectDidFailWithResult:result context:context];
    }
}

- (void)startUpdateObject:(NSDictionary *)captureObject withId:(NSInteger)objectId atPath:(NSString *)entityPath
                withToken:(NSString *)token forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    NSString      *attributes = [[captureObject JSONString] URLEscaped];
    NSMutableData *body       = [NSMutableData data];

    //[body appendData:[[NSString stringWithFormat:@"type_name=%@", [JRCaptureData entityTypeName]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&attributes=%@", attributes] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];

    if (objectId)
    {
        [body appendData:[[NSString stringWithFormat:@"&entity_path=%@", entityPath] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"&id=%@", [NSString stringWithFormat:@"%d", objectId]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {
        [body appendData:[[NSString stringWithFormat:@"&attribute_name=%@", entityPath] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if (appIdArg)
        [body appendData:[appIdArg dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity.update", [JRCaptureData captureApidDomain]]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"updateObject", @"action",
                                        delegate, @"delegate",
                                        context, @"context", nil];

    if (objectId)
        DLog(@"%@ attributes=%@ access_token=%@ entity_path=%@ id=%d", [[request URL] absoluteString], attributes, token, entityPath, objectId);
    else
        DLog(@"%@ attributes=%@ access_token=%@ attribute_name=%@", [[request URL] absoluteString], attributes, token, entityPath);

    // TODO: Better error format
    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishUpdateObjectWithStat:StatFail andResult:@"url failed" forDelegate:delegate withContext:context];
}

- (void)finishReplaceObjectWithStat:(CaptureInterfaceStat)stat andResult:(NSString*)result
                        forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(replaceCaptureObjectDidSucceedWithResult:context:)])
            [delegate replaceCaptureObjectDidSucceedWithResult:result context:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(replaceCaptureObjectDidFailWithResult:context:)])
            [delegate replaceCaptureObjectDidFailWithResult:result context:context];
    }
}

- (void)startReplaceObject:(NSDictionary *)captureObject withId:(NSInteger)objectId atPath:(NSString *)entityPath
                 withToken:(NSString *)token forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    NSString      *attributes = [[captureObject JSONString] URLEscaped];
    NSMutableData *body       = [NSMutableData data];

    //[body appendData:[[NSString stringWithFormat:@"type_name=%@", [JRCaptureData entityTypeName]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&attributes=%@", attributes] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];

    if (objectId)
    {
        [body appendData:[[NSString stringWithFormat:@"&entity_path=%@", entityPath] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"&id=%@", [NSString stringWithFormat:@"%d", objectId]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {
        [body appendData:[[NSString stringWithFormat:@"&attribute_name=%@", entityPath] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if (appIdArg)
         [body appendData:[appIdArg dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity.replace", [JRCaptureData captureApidDomain]]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"replaceObject", @"action",
                                        delegate, @"delegate",
                                        context, @"context", nil];

    if (objectId)
        DLog(@"%@ attributes=%@ access_token=%@ entity_path=%@ id=%d", [[request URL] absoluteString], attributes, token, entityPath, objectId);
    else
        DLog(@"%@ attributes=%@ access_token=%@ attribute_name=%@", [[request URL] absoluteString], attributes, token, entityPath);

    // TODO: Better error format
    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishReplaceObjectWithStat:StatFail andResult:@"url failed" forDelegate:delegate withContext:context];
}

+ (void)getCaptureUserWithToken:(NSString *)token
                    forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureInterface captureInterfaceInstance]
            startGetCaptureUserWithToken:token forDelegate:delegate withContext:context];
}

+ (void)createCaptureUser:(NSDictionary *)captureUser withToken:(NSString *)token
              forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureInterface captureInterfaceInstance]
            startCreateCaptureUser:captureUser withToken:token forDelegate:delegate withContext:context];
}

+ (void)updateCaptureObject:(NSDictionary *)captureObject withId:(NSInteger)objectId atPath:(NSString *)entityPath withToken:(NSString *)token
                forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");
    [[JRCaptureInterface captureInterfaceInstance]
            startUpdateObject:captureObject withId:objectId atPath:entityPath withToken:token forDelegate:delegate withContext:context];
}

+ (void)replaceCaptureObject:(NSDictionary *)captureObject withId:(NSInteger)objectId atPath:(NSString *)entityPath withToken:(NSString *)token
                 forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureInterface captureInterfaceInstance]
            startReplaceObject:captureObject withId:objectId atPath:entityPath withToken:token forDelegate:delegate withContext:context];
}

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(NSObject*)userdata
{
    DLog(@"%@", payload);

    NSDictionary *tag       = (NSDictionary*)userdata;
    NSString     *action    = [tag objectForKey:@"action"];
    NSObject     *context   = [tag objectForKey:@"context"];
    id<JRCaptureInterfaceDelegate> delegate = [tag objectForKey:@"delegate"];

    if ([action isEqualToString:@"getUser"])
    {
        NSDictionary *response = [payload objectFromJSONString];
        if ([(NSString *)[response objectForKey:@"stat"] isEqualToString:@"ok"])
        {
            DLog(@"Get entity success: %@", payload);
            [self finishGetCaptureUserWithStat:StatOk andResult:payload forDelegate:delegate withContext:context];
        }
        else
        {
            DLog(@"Get entity failure: %@", payload);
            [self finishGetCaptureUserWithStat:StatFail andResult:payload forDelegate:delegate withContext:context];
        }
    }
    else if ([action isEqualToString:@"createUser"])
    {
        NSDictionary *response = [payload objectFromJSONString];
        if ([(NSString *)[response objectForKey:@"stat"] isEqualToString:@"ok"])
        {
            DLog(@"Capture creation success: %@", payload);
            [self finishCreateCaptureUserWithStat:StatOk andResult:payload forDelegate:delegate withContext:context];
        }
        else
        {
            DLog(@"Capture creation failure: %@", payload);
            [self finishCreateCaptureUserWithStat:StatFail andResult:payload forDelegate:delegate withContext:context];
        }
    }
    else if ([action isEqualToString:@"updateObject"])
    {
        NSDictionary *response = [payload objectFromJSONString];
        if ([(NSString *)[response objectForKey:@"stat"] isEqualToString:@"ok"])
        {
            DLog(@"Capture update success: %@", payload);
            [self finishUpdateObjectWithStat:StatOk andResult:payload forDelegate:delegate withContext:context];
        }
        else
        {
            DLog(@"Capture update failure: %@", payload);
            [self finishUpdateObjectWithStat:StatFail andResult:payload forDelegate:delegate withContext:context];
        }
    }
    else if ([action isEqualToString:@"replaceObject"])
    {
        NSDictionary *response = [payload objectFromJSONString];
        if ([(NSString *)[response objectForKey:@"stat"] isEqualToString:@"ok"])
        {
            DLog(@"Get entity success: %@", payload);
            [self finishReplaceObjectWithStat:StatOk andResult:payload forDelegate:delegate withContext:context];
        }
        else
        {
            DLog(@"Get entity failure: %@", payload);
            [self finishReplaceObjectWithStat:StatFail andResult:payload forDelegate:delegate withContext:context];
        }
    }
}

- (void)connectionDidFinishLoadingWithFullResponse:(NSURLResponse*)fullResponse unencodedPayload:(NSData*)payload
                                           request:(NSURLRequest*)request andTag:(NSObject*)userdata { }
- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(NSObject*)userdata
{
    DLog(@"");

    NSDictionary *tag       = (NSDictionary*)userdata;
    NSString     *action    = [tag objectForKey:@"action"];
    NSObject     *context   = [tag objectForKey:@"context"];
    id<JRCaptureInterfaceDelegate> delegate = [tag objectForKey:@"delegate"];

    // TODO: Better error format
    NSString *result = @"connection failed";

    if ([action isEqualToString:@"getUser"])
    {
        [self finishGetCaptureUserWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"createUser"])
    {
        [self finishCreateCaptureUserWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"updateObject"])
    {
        [self finishUpdateObjectWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"replaceObject"])
    {
        [self finishReplaceObjectWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
}

- (void)connectionWasStoppedWithTag:(NSObject*)userdata { }
@end
