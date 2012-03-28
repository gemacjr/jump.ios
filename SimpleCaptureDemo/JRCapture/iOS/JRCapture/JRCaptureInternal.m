//
//  JRCaptureData.m
//  SimpleCaptureDemo
//
//  Created by Lilli Szafranski on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JRCaptureInternal.h"

@implementation JRCaptureObject
@synthesize dirtyPropertySet;
@synthesize captureObjectPath;

- (id)init
{
    if ((self = [super init]))
    {
        dirtyPropertySet = [[NSMutableSet alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone
{
    JRCaptureObject *objectCopy =
                [[JRCaptureObject allocWithZone:zone] init];

    for (NSString *dirtyProperty in [self.dirtyPropertySet allObjects])
        [objectCopy.dirtyPropertySet addObject:dirtyProperty];

    objectCopy.captureObjectPath = self.captureObjectPath;

    return objectCopy;
}

- (void)replaceCaptureObjectDidFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    if ([delegate respondsToSelector:@selector(replaceCaptureObject:didFailWithResult:context:)])
        [delegate replaceCaptureObject:captureObject didFailWithResult:result context:callerContext];
}

- (void)replaceCaptureObjectDidSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary = [result objectFromJSONString];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        [self updateCaptureObjectDidFailWithResult:result context:context];

    if (![resultDictionary objectForKey:@"result"])
        [self updateCaptureObjectDidFailWithResult:result context:context];

    [captureObject replaceLocallyFromNewDictionary:[resultDictionary objectForKey:@"result"]];
    [captureObject.dirtyPropertySet removeAllObjects];

    if ([delegate respondsToSelector:@selector(replaceCaptureObject:didSucceedWithResult:context:)])
        [delegate replaceCaptureObject:captureObject didSucceedWithResult:result context:callerContext];
}

- (void)updateCaptureObjectDidFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    if ([delegate respondsToSelector:@selector(updateCaptureObject:didFailWithResult:context:)])
        [delegate updateCaptureObject:captureObject didFailWithResult:result context:callerContext];
}

- (void)updateCaptureObjectDidSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary = [result objectFromJSONString];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        [self updateCaptureObjectDidFailWithResult:result context:context];

    if (![resultDictionary objectForKey:@"result"])
        [self updateCaptureObjectDidFailWithResult:result context:context];

    [captureObject updateLocallyFromNewDictionary:[resultDictionary objectForKey:@"result"]];
    [captureObject.dirtyPropertySet removeAllObjects];

    if ([delegate respondsToSelector:@selector(updateCaptureObject:didSucceedWithResult:context:)])
        [delegate updateCaptureObject:captureObject didSucceedWithResult:result context:callerContext];
}

- (void)updateLocallyFromNewDictionary:(NSDictionary *)dictionary
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary *)dictionary
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)updateObjectOnCaptureForDelegate:(id <JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)replaceObjectOnCaptureForDelegate:(id <JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)dealloc
{
    [captureObjectPath release];
    [dirtyPropertySet release];

    [super dealloc];
}
@end

@interface JRCaptureData ()
@property (nonatomic, copy) NSString *captureApidDomain;
@property (nonatomic, copy) NSString *captureUIDomain;
@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *entityTypeName;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *creationToken;
@end

@implementation JRCaptureData
static JRCaptureData *singleton = nil;

@synthesize clientId;
@synthesize entityTypeName;
@synthesize captureApidDomain;
@synthesize captureUIDomain;
@synthesize accessToken;
@synthesize creationToken;

- (JRCaptureData *)init
{
    if ((self = [super init])) { }

    return self;
}

+ (id)captureDataInstance
{
    if (singleton == nil) {
        singleton = [((JRCaptureData*)[super allocWithZone:NULL]) init];
    }

    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self captureDataInstance] retain];
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
    JRCaptureData *captureDataInstance = [JRCaptureData captureDataInstance];
    return [NSString stringWithFormat:@"%@/oauth/mobile_signin?client_id=%@&redirect_uri=https://example.com",
                     captureDataInstance.captureUIDomain, captureDataInstance.clientId];
}

+ (void)setCaptureApiDomain:(NSString *)newCaptureApidDomain captureUIDomain:(NSString *)newCaptureUIDomain
                   clientId:(NSString *)newClientId andEntityTypeName:(NSString *)newEntityTypeName
{
    JRCaptureData *captureDataInstance    = [JRCaptureData captureDataInstance];
    captureDataInstance.captureApidDomain = newCaptureApidDomain;
    captureDataInstance.captureUIDomain   = newCaptureUIDomain;
    captureDataInstance.clientId          = newClientId;
    captureDataInstance.entityTypeName    = newEntityTypeName;
}

+ (void)setAccessToken:(NSString *)newAccessToken
{
    JRCaptureData *captureDataInstance = [JRCaptureData captureDataInstance];
    captureDataInstance.accessToken    = newAccessToken;
}

+ (void)setCreationToken:(NSString *)newCreationToken
{
    JRCaptureData *captureDataInstance = [JRCaptureData captureDataInstance];
    captureDataInstance.creationToken  = newCreationToken;
}

+ (NSString *)accessToken
{
    return [[JRCaptureData captureDataInstance] accessToken];
}

+ (NSString *)creationToken
{
    return [[JRCaptureData captureDataInstance] creationToken];
}

+ (NSString *)captureApidDomain
{
    return [[JRCaptureData captureDataInstance] captureApidDomain];
}

+ (NSString *)captureUIDomain
{
    return [[JRCaptureData captureDataInstance] captureUIDomain];
}

+ (NSString *)clientId
{
    return [[JRCaptureData captureDataInstance] clientId];
}

+ (NSString *)entityTypeName
{
    return [[JRCaptureData captureDataInstance] entityTypeName];
}

- (void)dealloc
{
    [clientId release];
    [entityTypeName release];
    [captureApidDomain release];
    [captureUIDomain release];
    [accessToken release];
    [creationToken release];
    [super dealloc];
}
@end
