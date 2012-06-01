//
//  Created by lillialexis on 2/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "JRCaptureUser+Extras.h"

@interface JRCaptureUserExtras : NSObject
@property (retain) id<JRCaptureUserDelegate> delegate;
@property (copy) NSString *accessToken;
@property (copy) NSString *creationToken;
@end

@implementation JRCaptureUserExtras
@synthesize accessToken;
@synthesize creationToken;
@synthesize delegate;

static JRCaptureUserExtras *singleton = nil;


- (id)init
{
    if ((self = [super init])) { }

    return self;
}

/* Return the singleton instance of this class. */
+ (id)captureUserExtras
{
    if (singleton == nil) {
        singleton = (JRCaptureUserExtras *) [[super allocWithZone:NULL] init];
    }

    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self captureUserExtras];
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
    return NSUIntegerMax; /* Denotes an object that cannot be released */
}

- (oneway void)release { /* Do nothing */ }

- (id)autorelease
{
    return self;
}
@end

@implementation JRCaptureUser (Extras)
//- (NSString *)accessToken
//{
//    return [[JRCaptureUserExtras captureUserExtras] accessToken];
//}
//
//- (NSString *)creationToken
//{
//    return [[JRCaptureUserExtras captureUserExtras] creationToken];
//}
//
//- (void)setAccessToken:(NSString *)anAccessToken
//{
//    [[JRCaptureUserExtras captureUserExtras] setAccessToken:anAccessToken];
//}
//
//- (void)setCreationToken:(NSString *)aCreationToken
//{
//    [[JRCaptureUserExtras captureUserExtras] setCreationToken:aCreationToken];
//}
//
//- (void)updateForDelegate:(id<JRCaptureUserDelegate>)delegate
//{
//    [[JRCaptureUserExtras captureUserExtras] setDelegate:delegate];
//
//    NSMutableDictionary *captureUserDictionary =
//                                [NSMutableDictionary dictionaryWithDictionary:[self dictionaryFromObject]];
//    [captureUserDictionary removeObjectForKey:@"created"];
//    [captureUserDictionary removeObjectForKey:@"lastUpdated"];
//    [captureUserDictionary removeObjectForKey:@"uuid"];
//
//    [JRCaptureInterface updateCaptureUser:captureUserDictionary
//                          withAccessToken:[[JRCaptureUserExtras captureUserExtras] accessToken]
//                              forDelegate:self];
//}
//
//- (void)createForDelegate:(id<JRCaptureUserDelegate>)delegate
//{
//    [[JRCaptureUserExtras captureUserExtras] setDelegate:delegate];
//
//    [JRCaptureInterface createCaptureUser:[self dictionaryFromObject]
//                        withCreationToken:[[JRCaptureUserExtras captureUserExtras] creationToken]
//                              forDelegate:self];
//}
//
//- (void)createCaptureUserDidFailWithResult:(NSString *)result
//{
//    id<JRCaptureUserDelegate> delegate = [[JRCaptureUserExtras captureUserExtras] delegate];
//
//    if ([delegate respondsToSelector:@selector(createCaptureUser:didFailWithResult:)])
//        [delegate createCaptureUser:self didFailWithResult:result];
//
//    [[JRCaptureUserExtras captureUserExtras] setDelegate:nil];
//}
//
//- (void)createCaptureUserDidSucceedWithResult:(NSString *)result
//{
//    id<JRCaptureUserDelegate> delegate = [[JRCaptureUserExtras captureUserExtras] delegate];
//
//    if ([delegate respondsToSelector:@selector(createCaptureUser:didSucceedWithResult:)])
//        [delegate createCaptureUser:self didSucceedWithResult:result];
//
//    [[JRCaptureUserExtras captureUserExtras] setDelegate:nil];
//}
//
//- (void)updateCaptureUserDidFailWithResult:(NSString *)result
//{
//    id<JRCaptureUserDelegate> delegate = [[JRCaptureUserExtras captureUserExtras] delegate];
//
//    if ([delegate respondsToSelector:@selector(updateCaptureUser:didFailWithResult:)])
//        [delegate updateCaptureUser:self didFailWithResult:result];
//
//    [[JRCaptureUserExtras captureUserExtras] setDelegate:nil];
//}
//
//- (void)updateCaptureUserDidSucceedWithResult:(NSString *)result
//{
//    id<JRCaptureUserDelegate> delegate = [[JRCaptureUserExtras captureUserExtras] delegate];
//
//    if ([delegate respondsToSelector:@selector(updateCaptureUser:didSucceedWithResult:)])
//        [delegate updateCaptureUser:self didSucceedWithResult:result];
//
//    [[JRCaptureUserExtras captureUserExtras] setDelegate:nil];
//}


- (void)createCaptureUserDidFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    if ([delegate respondsToSelector:@selector(createCaptureUser:didFailWithResult:context:)])
        [delegate createCaptureUser:captureObject didFailWithResult:result context:callerContext];
}

- (void)createCaptureUserDidSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary = [result objectFromJSONString];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        [self updateCaptureObjectDidFailWithResult:result context:context];

    if (![resultDictionary objectForKey:@"result"])
        [self updateCaptureObjectDidFailWithResult:result context:context];

    [captureObject replaceFromDictionary:[resultDictionary objectForKey:@"result"] withPath:capturePath];
    [captureObject.dirtyPropertySet removeAllObjects];

    if ([delegate respondsToSelector:@selector(createCaptureUser:didSucceedWithResult:context:)])
        [delegate createCaptureUser:captureObject didSucceedWithResult:result context:callerContext];
}

- (void)replaceCaptureObjectDidFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
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
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary = [result objectFromJSONString];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        [self updateCaptureObjectDidFailWithResult:result context:context];

    if (![resultDictionary objectForKey:@"result"])
        [self updateCaptureObjectDidFailWithResult:result context:context];

    [captureObject replaceFromDictionary:[resultDictionary objectForKey:@"result"] withPath:capturePath];
    [captureObject.dirtyPropertySet removeAllObjects];

    if ([delegate respondsToSelector:@selector(replaceCaptureObject:didSucceedWithResult:context:)])
        [delegate replaceCaptureObject:captureObject didSucceedWithResult:result context:callerContext];
}

- (void)updateCaptureObjectDidFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
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
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary = [result objectFromJSONString];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        [self updateCaptureObjectDidFailWithResult:result context:context];

    if (![resultDictionary objectForKey:@"result"])
        [self updateCaptureObjectDidFailWithResult:result context:context];

    [captureObject updateFromDictionary:[resultDictionary objectForKey:@"result"] withPath:capturePath];
    [captureObject.dirtyPropertySet removeAllObjects];

    if ([delegate respondsToSelector:@selector(updateCaptureObject:didSucceedWithResult:context:)])
        [delegate updateCaptureObject:captureObject didSucceedWithResult:result context:callerContext];
}

- (void)updateUserOnCaptureForDelegate:(id<JRCaptureUserDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureApidInterface updateCaptureObject:[self toUpdateDictionary]
                                     withId:self.captureUserId
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (void)replaceUserOnCaptureForDelegate:(id<JRCaptureUserDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureApidInterface replaceCaptureObject:[self toReplaceDictionary]
                                      withId:self.captureUserId
                                      atPath:self.captureObjectPath
                                   withToken:[JRCaptureData accessToken]
                                 forDelegate:self
                                 withContext:newContext];
}

- (void)createUserOnCaptureForDelegate:(id<JRCaptureUserDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureApidInterface createCaptureUser:[self toReplaceDictionary]
                                withToken:[JRCaptureData creationToken]
                              forDelegate:self
                              withContext:newContext];
}

+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary
{
    return [JRCaptureUser captureUserObjectFromDictionary:dictionary withPath:@""];
}

@end
