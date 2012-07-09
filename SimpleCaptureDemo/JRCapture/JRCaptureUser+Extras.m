//
//  Created by lillialexis on 2/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "JRCaptureData.h"
#import "JRCaptureApidInterface.h"
#import "JRCaptureUser.h"

#import "JRCaptureUser+Extras.h"
#import "JRCaptureObject+Internal.h"
#import "JSONKit.h"
#import "JRCaptureError.h"

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface JRCaptureError (ApidResultErrorHelpers)
+ (NSDictionary *)invalidClassErrorForResult:(NSObject *)result;
+ (NSDictionary *)invalidStatErrorForResult:(NSObject *)result;
+ (NSDictionary *)invalidDataErrorForResult:(NSObject *)result;
+ (NSDictionary *)missingAccessTokenInResult:(NSObject *)result;
+ (NSDictionary *)lastUpdatedSelectorNotAvailable;
@end

@interface JRCaptureUserApidHandler : NSObject <JRCaptureInterfaceDelegate>
@end

@implementation JRCaptureUserApidHandler
+ (id)captureUserApidHandler
{
    return [[[JRCaptureUserApidHandler alloc] init] autorelease];
}

- (void)createCaptureUserDidFailWithResult:(NSObject *)result context:(NSObject *)context
{
    DLog(@"");
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureUser   *captureUser   = [myContext objectForKey:@"captureUser"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureUserDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    /* Calling the old protocol methods for testing purposes, but have to make sure we pass the result string... */
    if ([delegate conformsToProtocol:@protocol(JRCaptureUserTesterDelegate)] &&
        [delegate respondsToSelector:@selector(createCaptureUser:didFailWithResult:context:)])
            [((id<JRCaptureUserTesterDelegate>)delegate) createCaptureUser:captureUser
                                                         didFailWithResult:([result isKindOfClass:[NSString class]] ? (NSString *)result : [(NSDictionary *)result JSONString])
                                                                   context:callerContext];

    if ([delegate respondsToSelector:@selector(createDidFailForUser:withError:context:)])
            [delegate createDidFailForUser:captureUser withError:[JRCaptureError errorFromResult:result] context:callerContext];
}

- (void)createCaptureUserDidSucceedWithResult:(NSObject *)result context:(NSObject *)context
{
    DLog(@"");
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureUser   *captureUser   = [myContext objectForKey:@"captureUser"];
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureUserDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary;
    if ([result isKindOfClass:[NSString class]])
        resultDictionary = [(NSString *)result objectFromJSONString];
    else /* Uh-oh!! */
        return [self createCaptureUserDidFailWithResult:[JRCaptureError invalidClassErrorForResult:result]
                                                context:context];

    if (!resultDictionary)
        return [self createCaptureUserDidFailWithResult:[JRCaptureError invalidDataErrorForResult:result]
                                                context:context];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        return [self createCaptureUserDidFailWithResult:[JRCaptureError invalidStatErrorForResult:result]
                                                context:context];

    if (![resultDictionary objectForKey:@"result"] || ![[resultDictionary objectForKey:@"result"] isKindOfClass:[NSDictionary class]])
        return [self createCaptureUserDidFailWithResult:[JRCaptureError invalidDataErrorForResult:result]
                                                context:context];

    [captureUser replaceFromDictionary:[resultDictionary objectForKey:@"result"] withPath:capturePath];

    if (!captureUser)
        return [self createCaptureUserDidFailWithResult:[JRCaptureError invalidDataErrorForResult:result]
                                                context:context];

    NSString *accessToken = [resultDictionary objectForKey:@"access_token"];

    if (!accessToken)
        return [self createCaptureUserDidFailWithResult:[JRCaptureError missingAccessTokenInResult:result]
                                                context:context];

    NSString *uuid = nil;
    if ([captureUser respondsToSelector:NSSelectorFromString(@"uuid")])
        uuid = [captureUser performSelector:NSSelectorFromString(@"uuid")];

    [JRCaptureData setAccessToken:accessToken forUser:uuid];

    /* Calling the old protocol methods for testing purposes, but have to make sure we pass the result string... */
    if ([delegate conformsToProtocol:@protocol(JRCaptureUserTesterDelegate)] &&
        [delegate respondsToSelector:@selector(createCaptureUser:didSucceedWithResult:context:)])
            [((id<JRCaptureUserTesterDelegate>)delegate) createCaptureUser:captureUser
                                                      didSucceedWithResult:([result isKindOfClass:[NSString class]] ? (NSString *)result : [(NSDictionary *)result JSONString])
                                                                   context:callerContext];

    if ([delegate respondsToSelector:@selector(createDidSucceedForUser:context:)])
            [delegate createDidSucceedForUser:captureUser context:callerContext];
}

- (void)getCaptureUserDidFailWithResult:(NSObject *)result context:(NSObject *)context
{
    DLog(@"");
    NSDictionary    *myContext     = (NSDictionary *)context;
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureUserDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    if ([delegate respondsToSelector:@selector(fetchUserDidFailWithError:context:)])
        [delegate fetchUserDidFailWithError:[JRCaptureError errorFromResult:result] context:callerContext];
}

- (void)getCaptureUserDidSucceedWithResult:(NSObject *)result context:(NSObject *)context
{
    DLog(@"");
    NSDictionary    *myContext     = (NSDictionary *)context;
    //NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureUserDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary;
    if ([result isKindOfClass:[NSString class]])
        resultDictionary = [(NSString *)result objectFromJSONString];
    else /* Uh-oh!! */
        return [self getCaptureUserDidFailWithResult:[JRCaptureError invalidClassErrorForResult:result] context:context];

    if (!resultDictionary)
        return [self createCaptureUserDidFailWithResult:[JRCaptureError invalidDataErrorForResult:result] context:context];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        return [self getCaptureUserDidFailWithResult:[JRCaptureError invalidStatErrorForResult:result] context:context];

    if (![resultDictionary objectForKey:@"result"] || ![[resultDictionary objectForKey:@"result"] isKindOfClass:[NSDictionary class]])
        return [self getCaptureUserDidFailWithResult:[JRCaptureError invalidDataErrorForResult:result] context:context];

    JRCaptureUser *captureUser = [JRCaptureUser captureUserObjectFromDictionary:[resultDictionary objectForKey:@"result"]];

    if ([delegate respondsToSelector:@selector(fetchUserDidSucceed:context:)])
        [delegate fetchUserDidSucceed:captureUser context:callerContext];
}

- (void)getCaptureObjectDidFailWithResult:(NSObject *)result context:(NSObject *)context
{
    DLog(@"");
    NSDictionary    *myContext     = (NSDictionary *)context;
    //JRCaptureUser   *captureUser   = [myContext objectForKey:@"captureUser"];
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureUserDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    if ([delegate respondsToSelector:@selector(fetchLastUpdatedDidFailWithError:context:)])
        [delegate fetchLastUpdatedDidFailWithError:[JRCaptureError errorFromResult:result] context:callerContext];
}

- (void)getCaptureObjectDidSucceedWithResult:(NSObject *)result context:(NSObject *)context
{
    DLog(@"");
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureUser   *captureUser   = [myContext objectForKey:@"captureUser"];
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureUserDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary;
    if ([result isKindOfClass:[NSString class]])
        resultDictionary = [(NSString *)result objectFromJSONString];
    else /* Uh-oh!! */
        return [self getCaptureObjectDidFailWithResult:[JRCaptureError invalidClassErrorForResult:result] context:context];

    if (!resultDictionary)
        return [self createCaptureUserDidFailWithResult:[JRCaptureError invalidDataErrorForResult:result] context:context];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        return [self getCaptureObjectDidFailWithResult:[JRCaptureError invalidStatErrorForResult:result] context:context];

    if (![resultDictionary objectForKey:@"result"])
        return [self getCaptureObjectDidFailWithResult:[JRCaptureError invalidDataErrorForResult:result] context:context];

    if ([capturePath isEqualToString:@"/lastUpdated"])
    {
        const SEL lastUpdatedSelector = NSSelectorFromString(@"lastUpdated");

        if (![captureUser respondsToSelector:lastUpdatedSelector])
            return [self getCaptureObjectDidFailWithResult:[JRCaptureError lastUpdatedSelectorNotAvailable]
                                                   context:context];

        JRDateTime *serverLastUpdated = [JRDateTime dateFromISO8601DateTimeString:[resultDictionary objectForKey:@"result"]];
        JRDateTime *localLastUpdated  = [captureUser performSelector:lastUpdatedSelector];

        if (!serverLastUpdated)
            return [self getCaptureObjectDidFailWithResult:[JRCaptureError invalidDataErrorForResult:result] context:context];

//        if (!localLastUpdated) // TODO: Do we error when the local last updated is nil or just assume it's out of date?
//            return [self getCaptureObjectDidFailWithResult:[JRCaptureError MAKE AN ERROR:result] context:context];

        BOOL isOutdated = ([serverLastUpdated compare:localLastUpdated] != NSOrderedSame);

        if ([delegate respondsToSelector:@selector(fetchLastUpdatedDidSucceed:isOutdated:context:)])
            [delegate fetchLastUpdatedDidSucceed:serverLastUpdated isOutdated:isOutdated context:callerContext];
    }
    else
    {
        return [self getCaptureObjectDidFailWithResult:[JRCaptureError invalidDataErrorForResult:result] context:context];
    }
}
@end

@interface JRCaptureUser (JRCaptureUser_Internal)
+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;
- (void)decodeFromDictionary:(NSDictionary *)dictionary;
@end

@implementation JRCaptureUser (JRCaptureUser_Extras)

#define cJREncodedCaptureUser @"jrcapture.encodedCaptureUser"

- (void)encodeWithCoder:(NSCoder*)coder
{
    NSDictionary *dictionary = [self toDictionaryForEncoder:YES];
    [coder encodeObject:dictionary forKey:cJREncodedCaptureUser];
}

- (id)initWithCoder:(NSCoder*)coder
{
    if (self != nil)
    {
        [self init];
        NSDictionary *dictionary = [coder decodeObjectForKey:cJREncodedCaptureUser];
        [self decodeFromDictionary:dictionary];
    }

    return self;
}

- (void)createOnCaptureForDelegate:(id <JRCaptureUserDelegate>)delegate context:(NSObject *)context
{
    DLog(@"");
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureUser",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureApidInterface createCaptureUser:[self toReplaceDictionary]
                                    withToken:[JRCaptureData creationToken]
                                  forDelegate:[JRCaptureUserApidHandler captureUserApidHandler]
                                  withContext:newContext];
}

+ (void)fetchCaptureUserFromServerForDelegate:(id <JRCaptureUserDelegate>)delegate context:(NSObject *)context
{
    DLog(@"");
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     @"/", @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureApidInterface getCaptureUserWithToken:[JRCaptureData accessToken]
                                        forDelegate:[JRCaptureUserApidHandler captureUserApidHandler]
                                        withContext:newContext];
}

- (void)fetchLastUpdatedFromServerForDelegate:(id <JRCaptureUserDelegate>)delegate context:(NSObject *)context
{
    DLog(@"");
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureUser",
                                                     @"/lastUpdated", @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureApidInterface getCaptureObjectAtPath:@"/lastUpdated"
                                         withToken:[JRCaptureData accessToken]
                                       forDelegate:[JRCaptureUserApidHandler captureUserApidHandler]
                                       withContext:newContext];
}

+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary
{
    return [JRCaptureUser captureUserObjectFromDictionary:dictionary withPath:@""];
}

+ (void)testCaptureUserApidHandlerCreateCaptureUserDidFailWithResult:(NSObject *)result context:(NSObject *)context
{
    [[JRCaptureUserApidHandler captureUserApidHandler] createCaptureUserDidFailWithResult:result context:context];
}

+ (void)testCaptureUserApidHandlerCreateCaptureUserDidSucceedWithResult:(NSObject *)result context:(NSObject *)context
{
    [[JRCaptureUserApidHandler captureUserApidHandler] createCaptureUserDidSucceedWithResult:result context:context];
}

+ (void)testCaptureUserApidHandlerGetCaptureUserDidFailWithResult:(NSObject *)result context:(NSObject *)context
{
    [[JRCaptureUserApidHandler captureUserApidHandler] getCaptureUserDidFailWithResult:result context:context];
}

+ (void)testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:(NSObject *)result context:(NSObject *)context
{
    [[JRCaptureUserApidHandler captureUserApidHandler] getCaptureUserDidSucceedWithResult:result context:context];
}

+ (void)testCaptureUserApidHandlerGetCaptureObjectDidFailWithResult:(NSObject *)result context:(NSObject *)context
{
    [[JRCaptureUserApidHandler captureUserApidHandler] getCaptureObjectDidFailWithResult:result context:context];
}

+ (void)testCaptureUserApidHandlerGetCaptureObjectDidSucceedWithResult:(NSObject *)result context:(NSObject *)context
{
    [[JRCaptureUserApidHandler captureUserApidHandler] getCaptureObjectDidSucceedWithResult:result context:context];
}

@end
