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

    if ([delegate conformsToProtocol:@protocol(JRCaptureUserTesterDelegate)] &&
        [delegate respondsToSelector:@selector(createCaptureUser:didFailWithResult:context:)])
            [((id<JRCaptureUserTesterDelegate>)delegate) createCaptureUser:captureUser
                                                         didFailWithResult:([result isKindOfClass:[NSString class]] ? (NSString *)result : [(NSDictionary *)result JSONString])
                                                                   context:callerContext];
    else if ([delegate respondsToSelector:@selector(createDidFailForUser:withError:context:)])
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

    NSDictionary *resultDictionary = [(NSString *)result objectFromJSONString];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        [self createCaptureUserDidFailWithResult:result context:context];

    if (![resultDictionary objectForKey:@"result"])
        [self createCaptureUserDidFailWithResult:result context:context];

    [captureUser replaceFromDictionary:[resultDictionary objectForKey:@"result"] withPath:capturePath];

    if ([delegate conformsToProtocol:@protocol(JRCaptureUserTesterDelegate)] &&
        [delegate respondsToSelector:@selector(createCaptureUser:didSucceedWithResult:context:)])
            [((id<JRCaptureUserTesterDelegate>)delegate) createCaptureUser:captureUser
                                                      didSucceedWithResult:([result isKindOfClass:[NSString class]] ? (NSString *)result : [(NSDictionary *)result JSONString])
                                                                   context:callerContext];
    else if ([delegate respondsToSelector:@selector(createDidSucceedForUser:context:)])
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
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureUserDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary = [(NSString *)result objectFromJSONString];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        [self getCaptureUserDidFailWithResult:result context:context];

    if (![resultDictionary objectForKey:@"result"])
        [self getCaptureUserDidFailWithResult:result context:context];

    JRCaptureUser *captureUser = [JRCaptureUser captureUserObjectFromDictionary:[resultDictionary objectForKey:@"result"]];

    if ([delegate respondsToSelector:@selector(fetchUserDidSucceed:context:)])
        [delegate fetchUserDidSucceed:captureUser context:callerContext];

}

- (void)getCaptureObjectDidFailWithResult:(NSObject *)result context:(NSObject *)context
{
    DLog(@"");
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureUser   *captureUser   = [myContext objectForKey:@"captureUser"];
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureUserDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    if ([capturePath isEqualToString:@"/lastUpdated"])
    {
        if ([delegate respondsToSelector:@selector(fetchLastUpdatedDidFailWithError:context:)])
            [delegate fetchLastUpdatedDidFailWithError:[JRCaptureError errorFromResult:result] context:callerContext];
    }
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

    NSDictionary *resultDictionary = [(NSString *)result objectFromJSONString];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        [self getCaptureObjectDidFailWithResult:result context:context];

    if (![resultDictionary objectForKey:@"result"])
        [self getCaptureObjectDidFailWithResult:result context:context];

    // TODO: Implement me!!!

    if ([capturePath isEqualToString:@"/lastUpdated"])
    {
        if ([delegate respondsToSelector:@selector(fetchLastUpdatedDidSucceed:isOutdated:context:)])
                [delegate fetchLastUpdatedDidSucceed:nil isOutdated:YES context:callerContext];

    }
}
@end

@interface JRCaptureUser (Internal)
+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;
@end

@implementation JRCaptureUser (Extras)

- (void)encodeWithCoder:(NSCoder*)coder
{
    NSDictionary *dictionary = [self toDictionary];
    [coder encodeObject:dictionary forKey:@"captureUser"];
}

- (id)initWithCoder:(NSCoder*)coder
{
    if (self != nil)
    {
        NSDictionary *dictionary = [coder decodeObjectForKey:@"captureUser"];
        [self replaceFromDictionary:dictionary withPath:@""];
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

    [JRCaptureApidInterface createCaptureUser:[self toReplaceDictionaryIncludingArrays:YES]
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
@end
