//
//  JRCaptureInterfaceTwo.m
//  SimpleCaptureDemo
//
//  Created by Lilli Szafranski on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "JRCaptureInterfaceTwo.h"
#import "JRCaptureData.h"
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

@implementation JRCaptureInterfaceTwo
static JRCaptureInterfaceTwo *singleton = nil;

- (JRCaptureInterfaceTwo*)init
{
    if ((self = [super init])) { }

    return self;
}

+ (id)captureInterfaceInstance
{
    if (singleton == nil) {
        singleton = [((JRCaptureInterfaceTwo*)[super allocWithZone:NULL]) init];
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
                         forDelegate:(id <JRCaptureInterfaceTwoDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(getCaptureUserDidSucceedWithResult:andContext:)])
            [delegate getCaptureUserDidSucceedWithResult:result andContext:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(getCaptureUserDidFailWithResult:andContext:)])
            [delegate getCaptureUserDidFailWithResult:result andContext:context];
    }

    //self.captureInterfaceDelegate = nil;
}

- (void)startGetCaptureUserWithToken:(NSString *)token
                         forDelegate:(id <JRCaptureInterfaceTwoDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    NSMutableData *body = [NSMutableData data];

    // TODO: Do we need this for generic entities and will we need a different one for the top-level capture user??
    [body appendData:[[NSString stringWithFormat:@"type_name=%@", [JRCaptureData entityTypeName]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity", [JRCaptureData captureDomain]]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *newTag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"getUser", @"action",
                                        delegate, @"delegate",
                                        context, @"context", nil];

    // TODO: Better error format
    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:newTag])
        [self finishGetCaptureUserWithStat:StatFail andResult:@"url failed" forDelegate:delegate withContext:context];
}

- (void)finishCreateCaptureUserWithStat:(CaptureInterfaceStat)stat andResult:(NSString*)result
                            forDelegate:(id <JRCaptureInterfaceTwoDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(createCaptureUserDidSucceedWithResult:andContext:)])
            [delegate createCaptureUserDidSucceedWithResult:result andContext:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(createCaptureUserDidFailWithResult:andContext:)])
            [delegate createCaptureUserDidFailWithResult:result andContext:context];
    }

    //self.captureInterfaceDelegate = nil;
}

- (void)startCreateCaptureUser:(NSDictionary *)captureUser withToken:(NSString *)token
                   forDelegate:(id <JRCaptureInterfaceTwoDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    NSString      *attributes = [[captureUser JSONString] URLEscaped];
    NSMutableData *body       = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"type_name=%@", [JRCaptureData entityTypeName]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&attributes=%@", attributes] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&creation_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity.create", [JRCaptureData captureDomain]]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"createUser", @"action",
                                        delegate, @"delegate",
                                        context, @"context", nil];

    // TODO: Better error format
    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishCreateCaptureUserWithStat:StatFail andResult:@"url failed" forDelegate:delegate withContext:context];
}

- (void)finishUpdateObjectWithStat:(CaptureInterfaceStat)stat andResult:(NSString*)result
                       forDelegate:(id <JRCaptureInterfaceTwoDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(updateCaptureObjectDidSucceedWithResult:andContext:)])
            [delegate updateCaptureObjectDidSucceedWithResult:result andContext:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(updateCaptureObjectDidFailWithResult:andContext:)])
            [delegate updateCaptureObjectDidFailWithResult:result andContext:context];
    }
}

- (void)startUpdateObject:(NSDictionary *)captureObject withId:(NSInteger)objectId atPath:(NSString *)entityPath
                withToken:(NSString *)token forDelegate:(id <JRCaptureInterfaceTwoDelegate>)delegate withContext:(NSObject *)context
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

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity.update", [JRCaptureData captureDomain]]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"updateObject", @"action",
                                        delegate, @"delegate",
                                        context, @"context", nil];

    // TODO: Better error format
    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishUpdateObjectWithStat:StatFail andResult:@"url failed" forDelegate:delegate withContext:context];
}

- (void)finishReplaceObjectWithStat:(CaptureInterfaceStat)stat andResult:(NSString*)result
                        forDelegate:(id <JRCaptureInterfaceTwoDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(replaceCaptureObjectDidSucceedWithResult:andContext:)])
            [delegate replaceCaptureObjectDidSucceedWithResult:result andContext:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(replaceCaptureObjectDidFailWithResult:andContext:)])
            [delegate replaceCaptureObjectDidFailWithResult:result andContext:context];
    }
}

- (void)startReplaceObject:(NSDictionary *)captureObject withId:(NSInteger)objectId atPath:(NSString *)entityPath
                 withToken:(NSString *)token forDelegate:(id <JRCaptureInterfaceTwoDelegate>)delegate withContext:(NSObject *)context
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

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity.replace", [JRCaptureData captureDomain]]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"replaceObject", @"action",
                                        delegate, @"delegate",
                                        context, @"context", nil];

    // TODO: Better error format
    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishReplaceObjectWithStat:StatFail andResult:@"url failed" forDelegate:delegate withContext:context];
}

+ (void)getCaptureUserWithToken:(NSString *)token
                    forDelegate:(id <JRCaptureInterfaceTwoDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureInterfaceTwo captureInterfaceInstance]
            startGetCaptureUserWithToken:token forDelegate:delegate withContext:context];
}

+ (void)createCaptureUser:(NSDictionary *)captureUser withToken:(NSString *)token
              forDelegate:(id <JRCaptureInterfaceTwoDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureInterfaceTwo captureInterfaceInstance]
            startCreateCaptureUser:captureUser withToken:token forDelegate:delegate withContext:context];
}

+ (void)updateCaptureObject:(NSDictionary *)captureObject withId:(NSInteger)objectId atPath:(NSString *)entityPath withToken:(NSString *)token
                forDelegate:(id <JRCaptureInterfaceTwoDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureInterfaceTwo captureInterfaceInstance]
            startUpdateObject:captureObject withId:objectId atPath:entityPath withToken:token forDelegate:delegate withContext:context];
}

+ (void)replaceCaptureObject:(NSDictionary *)captureObject withId:(NSInteger)objectId atPath:(NSString *)entityPath withToken:(NSString *)token
                 forDelegate:(id <JRCaptureInterfaceTwoDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureInterfaceTwo captureInterfaceInstance]
            startReplaceObject:captureObject withId:objectId atPath:entityPath withToken:token forDelegate:delegate withContext:context];
}

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(NSObject*)userdata
{
    DLog(@"%@", payload);

    NSDictionary *tag       = (NSDictionary*)userdata;
    NSString     *action    = [tag objectForKey:@"action"];
    NSObject     *context   = [tag objectForKey:@"context"];
    id<JRCaptureInterfaceTwoDelegate> delegate = [tag objectForKey:@"delegate"];

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

- (void)connectionDidFinishLoadingWithFullResponse:(NSURLResponse*)fullResponse
                                  unencodedPayload:(NSData*)payload
                                           request:(NSURLRequest*)request
                                            andTag:(NSObject*)userdata
{

}

- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(NSObject*)userdata
{
    DLog(@"");

    NSDictionary *tag       = (NSDictionary*)userdata;
    NSString     *action    = [tag objectForKey:@"action"];
    NSObject     *context   = [tag objectForKey:@"context"];
    id<JRCaptureInterfaceTwoDelegate> delegate = [tag objectForKey:@"delegate"];

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
