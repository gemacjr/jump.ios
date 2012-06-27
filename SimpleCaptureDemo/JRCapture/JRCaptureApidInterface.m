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

#import "JRCaptureApidInterface.h"
#import "JRCaptureData.h"
#import "JSONKit.h"
#import "JRCaptureError.h"

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

@implementation JRCaptureApidInterface
static JRCaptureApidInterface *singleton = nil;

/* Here for testing against Carl's local instance */
/* TODO: Remove when done */
static NSString *appIdArg   = nil;
//static NSString *appIdArg = @"&application_id=qx3ss262yufnmpb3ck93jr3zfs"

- (JRCaptureApidInterface *)init
{
    if ((self = [super init])) { }

    return self;
}

+ (id)captureInterfaceInstance
{
    if (singleton == nil) {
        singleton = [((JRCaptureApidInterface *)[super allocWithZone:NULL]) init];
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

- (void)finishGetCaptureUserWithStat:(CaptureInterfaceStat)stat andResult:(NSObject *)result
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

    /* Here for testing against Carl's local instance */
    /* TODO: Remove when done */
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

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:newTag])
        [self finishGetCaptureUserWithStat:StatFail
                                 andResult:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    @"error", @"stat",
                                                    @"url_connection", @"error",
                                                    [NSString stringWithFormat:@"Could not create a connection to %@", [[request URL] absoluteString]], @"error_description",
                                                    [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection], @"code", nil]
                               forDelegate:delegate
                               withContext:context];
}

- (void)finishCreateCaptureUserWithStat:(CaptureInterfaceStat)stat andResult:(NSObject *)result
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

    /* Here for testing against Carl's local instance */
    /* TODO: Remove when done */
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

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishCreateCaptureUserWithStat:StatFail
                                    andResult:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            @"error", @"stat",
                                                            @"url_connection", @"error",
                                                            [NSString stringWithFormat:@"Could not create a connection to %@", [[request URL] absoluteString]], @"error_description",
                                                            [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection], @"code", nil]
                                       forDelegate:delegate
                                       withContext:context];

}

- (void)finishGetObjectWithStat:(CaptureInterfaceStat)stat andResult:(NSObject *)result
                    forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(getCaptureObjectDidSucceedWithResult:context:)])
            [delegate getCaptureObjectDidSucceedWithResult:result context:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(getCaptureObjectDidFailWithResult:context:)])
            [delegate getCaptureObjectDidFailWithResult:result context:context];
    }
}

//- (void)startGetCaptureObjectWithId:(NSInteger)objectId atPath:(NSString *)entityPath withToken:(NSString *)token
- (void)startGetCaptureObjectAtPath:(NSString *)entityPath withToken:(NSString *)token
                        forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];

    if (!entityPath || [entityPath isEqualToString:@""]) ;
    else
        [body appendData:[[NSString stringWithFormat:@"&attribute_name=%@", entityPath] dataUsingEncoding:NSUTF8StringEncoding]];

    /* Here for testing against Carl's local instance */
    /* TODO: Remove when done */
    if (appIdArg)
        [body appendData:[appIdArg dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity", [JRCaptureData captureApidDomain]]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"getObject", @"action",
                                        delegate, @"delegate",
                                        context, @"context", nil];

    DLog(@"%@ access_token=%@ attribute_name=%@", [[request URL] absoluteString], token, entityPath);

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishGetObjectWithStat:StatFail
                            andResult:[NSDictionary dictionaryWithObjectsAndKeys:
                                               @"error", @"stat",
                                               @"url_connection", @"error",
                                               [NSString stringWithFormat:@"Could not create a connection to %@", [[request URL] absoluteString]], @"error_description",
                                               [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection], @"code", nil]
                          forDelegate:delegate
                          withContext:context];

}

- (void)finishUpdateObjectWithStat:(CaptureInterfaceStat)stat andResult:(NSObject *)result
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

- (void)startUpdateObject:(NSDictionary *)captureObject /*withId:(NSInteger)objectId*/ atPath:(NSString *)entityPath
                withToken:(NSString *)token forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    NSString      *attributes = [[captureObject JSONString] URLEscaped];
    NSMutableData *body       = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"&attributes=%@", attributes] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"&include_record=true" dataUsingEncoding:NSUTF8StringEncoding]];

    if (!entityPath || [entityPath isEqualToString:@""]) ;
    else
        [body appendData:[[NSString stringWithFormat:@"&attribute_name=%@", entityPath] dataUsingEncoding:NSUTF8StringEncoding]];

    /* Here for testing against Carl's local instance */
    /* TODO: Remove when done */
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

    DLog(@"%@ attributes=%@ access_token=%@ attribute_name=%@", [[request URL] absoluteString], attributes, token, entityPath);

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishUpdateObjectWithStat:StatFail
                               andResult:[NSDictionary dictionaryWithObjectsAndKeys:
                                                  @"error", @"stat",
                                                  @"url_connection", @"error",
                                                  [NSString stringWithFormat:@"Could not create a connection to %@", [[request URL] absoluteString]], @"error_description",
                                                  [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection], @"code", nil]
                             forDelegate:delegate
                             withContext:context];

}

- (void)finishReplaceObjectWithStat:(CaptureInterfaceStat)stat andResult:(NSObject *)result
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

- (void)startReplaceObject:(NSDictionary *)captureObject /*withId:(NSInteger)objectId*/ atPath:(NSString *)entityPath
                 withToken:(NSString *)token forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    NSString      *attributes = [[captureObject JSONString] URLEscaped];
    NSMutableData *body       = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"&attributes=%@", attributes] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"&include_record=true" dataUsingEncoding:NSUTF8StringEncoding]];

    if (!entityPath || [entityPath isEqualToString:@""]) ;
    else
        [body appendData:[[NSString stringWithFormat:@"&attribute_name=%@", entityPath] dataUsingEncoding:NSUTF8StringEncoding]];

    /* Here for testing against Carl's local instance */
    /* TODO: Remove when done */
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

    DLog(@"%@ attributes=%@ access_token=%@ attribute_name=%@", [[request URL] absoluteString], attributes, token, entityPath);

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag]) /* tag vs context for workaround */
        [self finishReplaceObjectWithStat:StatFail
                                andResult:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   @"error", @"stat",
                                                   @"url_connection", @"error",
                                                   [NSString stringWithFormat:@"Could not create a connection to %@", [[request URL] absoluteString]], @"error_description",
                                                   [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection], @"code", nil]
                              forDelegate:delegate
                              withContext:context];

}

- (void)finishReplaceArrayWithStat:(CaptureInterfaceStat)stat andResult:(NSObject *)result
                       forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");
    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(replaceCaptureArrayDidSucceedWithResult:context:)])
            [delegate replaceCaptureArrayDidSucceedWithResult:result context:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(replaceCaptureArrayDidFailWithResult:context:)])
            [delegate replaceCaptureArrayDidFailWithResult:result context:context];
    }
}

- (void)startReplaceArray:(NSArray *)captureArray /*withId:(NSInteger)objectId*/ atPath:(NSString *)entityPath
                withToken:(NSString *)token forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    NSString      *attributes = [[captureArray JSONString] URLEscaped];
    NSMutableData *body       = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"&attributes=%@", attributes] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"&include_record=true" dataUsingEncoding:NSUTF8StringEncoding]];

    // TODO: Test for this at the beginning and send an error if it fails??
    if (!entityPath || [entityPath isEqualToString:@""]) ;
    else
        [body appendData:[[NSString stringWithFormat:@"&attribute_name=%@", entityPath] dataUsingEncoding:NSUTF8StringEncoding]];

    /* Here for testing against Carl's local instance */
    /* TODO: Remove when done */
    if (appIdArg)
         [body appendData:[appIdArg dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity.replace", [JRCaptureData captureApidDomain]]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"replaceArray", @"action",
                                        delegate, @"delegate",
                                        context, @"context", nil];

    DLog(@"%@ attributes=%@ access_token=%@ attribute_name=%@", [[request URL] absoluteString], attributes, token, entityPath);

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag]) /* tag vs context for workaround */
        [self finishReplaceArrayWithStat:StatFail
                               andResult:[NSDictionary dictionaryWithObjectsAndKeys:
                                                  @"error", @"stat",
                                                  @"url_connection", @"error",
                                                  [NSString stringWithFormat:@"Could not create a connection to %@", [[request URL] absoluteString]], @"error_description",
                                                  [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection], @"code", nil]
                             forDelegate:delegate
                             withContext:context];

}

+ (void)getCaptureUserWithToken:(NSString *)token
                    forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureApidInterface captureInterfaceInstance]
            startGetCaptureUserWithToken:token forDelegate:delegate withContext:context];
}

+ (void)createCaptureUser:(NSDictionary *)captureUser withToken:(NSString *)token
              forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureApidInterface captureInterfaceInstance]
            startCreateCaptureUser:captureUser withToken:token forDelegate:delegate withContext:context];
}

+ (void)getCaptureObjectAtPath:(NSString *)entityPath withToken:(NSString *)token
                   forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureApidInterface captureInterfaceInstance]
            startGetCaptureObjectAtPath:entityPath withToken:token forDelegate:delegate withContext:context];
}

+ (void)updateCaptureObject:(NSDictionary *)captureObject /*withId:(NSInteger)objectId*/ atPath:(NSString *)entityPath withToken:(NSString *)token
                forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");
    [[JRCaptureApidInterface captureInterfaceInstance]
            startUpdateObject:captureObject /*withId:objectId*/ atPath:entityPath withToken:token forDelegate:delegate withContext:context];
}

+ (void)replaceCaptureObject:(NSDictionary *)captureObject /*withId:(NSInteger)objectId*/ atPath:(NSString *)entityPath withToken:(NSString *)token
                 forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureApidInterface captureInterfaceInstance]
            startReplaceObject:captureObject /*withId:objectId*/ atPath:entityPath withToken:token forDelegate:delegate withContext:context];
}

+ (void)replaceCaptureArray:(NSArray *)captureArray /*withId:(NSInteger)objectId*/ atPath:(NSString *)entityPath withToken:(NSString *)token
                forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureApidInterface captureInterfaceInstance]
            startReplaceArray:captureArray /*withId:objectId*/ atPath:entityPath withToken:token forDelegate:delegate withContext:context];
}

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(id)userdata
{
    DLog(@"%@", payload);

    NSDictionary *tag       = (NSDictionary*)userdata;
    NSString     *action    = [tag objectForKey:@"action"];
    NSObject     *context   = [tag objectForKey:@"context"];

    NSDictionary *response    = [payload objectFromJSONString];
    CaptureInterfaceStat stat = [[response objectForKey:@"stat"] isEqualToString:@"ok"] ? StatOk : StatFail;

    id<JRCaptureInterfaceDelegate> delegate = [tag objectForKey:@"delegate"];

    if ([action isEqualToString:@"getUser"])
    {
        [self finishGetCaptureUserWithStat:stat andResult:payload forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"createUser"])
    {
        [self finishCreateCaptureUserWithStat:stat andResult:payload forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"getObject"])
    {
        [self finishGetObjectWithStat:stat andResult:payload forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"updateObject"])
    {
        [self finishUpdateObjectWithStat:stat andResult:payload forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"replaceObject"])
    {
        [self finishReplaceObjectWithStat:stat andResult:payload forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"replaceArray"])
    {
        [self finishReplaceArrayWithStat:stat andResult:payload forDelegate:delegate withContext:context];
    }
}

- (void)connectionDidFinishLoadingWithFullResponse:(NSURLResponse*)fullResponse unencodedPayload:(NSData*)payload
                                           request:(NSURLRequest*)request andTag:(id)userdata { }
- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(id)userdata
{
    DLog(@"");

    NSDictionary *tag       = (NSDictionary*)userdata;
    NSString     *action    = [tag objectForKey:@"action"];
    NSObject     *context   = [tag objectForKey:@"context"];
    id<JRCaptureInterfaceDelegate> delegate = [tag objectForKey:@"delegate"];

    // TODO: Better error format
    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"error", @"stat",
                                    [error localizedDescription], @"error",
                                    [error localizedFailureReason], @"error_description",
                                    [NSNumber numberWithInteger:JRCaptureLocalApidErrorConnectionDidFail], @"code", nil];


    if ([action isEqualToString:@"getUser"])
    {
        [self finishGetCaptureUserWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"createUser"])
    {
        [self finishCreateCaptureUserWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"getObject"])
    {
        [self finishGetObjectWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"updateObject"])
    {
        [self finishUpdateObjectWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"replaceObject"])
    {
        [self finishReplaceObjectWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:@"replaceArray"])
    {
        [self finishReplaceArrayWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
}

- (void)connectionWasStoppedWithTag:(id)userdata { }
@end
