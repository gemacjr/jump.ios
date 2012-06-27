//
//  Created by lillialexis on 2/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "JRCaptureData.h"
#import "JRCaptureApidInterface.h"
#import "JRCaptureUser.h"

#import "JRCaptureUser+Extras.h"
#import "JRCaptureInternal.h"
#import "JSONKit.h"

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface JRCaptureUserExtrasApidHandler : NSObject <JRCaptureInterfaceDelegate>
@end

@implementation JRCaptureUserExtrasApidHandler
+ (id)captureUserExtrasApidHandler
{
    return [[[JRCaptureUserExtrasApidHandler alloc] init] autorelease];
}

- (void)createCaptureUserDidFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureUser   *captureUser   = [myContext objectForKey:@"captureUser"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureUserDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    // TODO: Parse error out of result
    if ([delegate conformsToProtocol:@protocol(JRCaptureUserTesterDelegate)] &&
        [delegate respondsToSelector:@selector(createCaptureUser:didFailWithResult:context:)])
            [((id<JRCaptureUserTesterDelegate>)delegate) createCaptureUser:captureUser didFailWithResult:result context:callerContext];
    else if ([delegate respondsToSelector:@selector(createDidFailForUser:withError:context:)])
            [delegate createDidFailForUser:captureUser withError:result context:callerContext];
}

- (void)createCaptureUserDidSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureUser   *captureUser   = [myContext objectForKey:@"captureUser"];
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureUserDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary = [result objectFromJSONString];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        [self createCaptureUserDidFailWithResult:result context:context];

    if (![resultDictionary objectForKey:@"result"])
        [self createCaptureUserDidFailWithResult:result context:context];

    [captureUser replaceFromDictionary:[resultDictionary objectForKey:@"result"] withPath:capturePath];

    if ([delegate conformsToProtocol:@protocol(JRCaptureUserTesterDelegate)] &&
        [delegate respondsToSelector:@selector(createCaptureUser:didSucceedWithResult:context:)])
            [((id<JRCaptureUserTesterDelegate>)delegate) createCaptureUser:captureUser didSucceedWithResult:result context:callerContext];
    else if ([delegate respondsToSelector:@selector(createDidSucceedForUser:context:)])
            [delegate createDidSucceedForUser:captureUser context:callerContext];
}

- (void)getCaptureUserDidFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureUserDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    // TODO: Parse error out of result
    if ([delegate respondsToSelector:@selector(fetchUserDidFailWithError:context:)])
        [delegate fetchUserDidFailWithError:result context:callerContext];

}

- (void)getCaptureUserDidSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureUserDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary = [result objectFromJSONString];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        [self getCaptureUserDidFailWithResult:result context:context];

    if (![resultDictionary objectForKey:@"result"])
        [self getCaptureUserDidFailWithResult:result context:context];

    JRCaptureUser *captureUser = [JRCaptureUser captureUserObjectFromDictionary:[resultDictionary objectForKey:@"result"]];//replaceFromDictionary:[resultDictionary objectForKey:@"result"] withPath:capturePath];

    if ([delegate conformsToProtocol:@protocol(JRCaptureUserTesterDelegate)] &&
        [delegate respondsToSelector:@selector(createCaptureUser:didSucceedWithResult:context:)])
            [((id<JRCaptureUserTesterDelegate>)delegate) createCaptureUser:captureUser didSucceedWithResult:result context:callerContext];
    else if ([delegate respondsToSelector:@selector(createDidSucceedForUser:context:)])
            [delegate createDidSucceedForUser:captureUser context:callerContext];

}

- (void)getCaptureObjectDidFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureUser   *captureUser   = [myContext objectForKey:@"captureUser"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureUserDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    // TODO: Parse error out of result
    if ([delegate respondsToSelector:@selector(fetchLastUpdatedDidFailWithError:context:)])
        [delegate fetchLastUpdatedDidFailWithError:result context:callerContext];
}

- (void)getCaptureObjectDidSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureUser   *captureUser   = [myContext objectForKey:@"captureUser"];
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureUserDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary = [result objectFromJSONString];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        [self getCaptureObjectDidFailWithResult:result context:context];

    if (![resultDictionary objectForKey:@"result"])
        [self getCaptureObjectDidFailWithResult:result context:context];

    // TODO: Implement me!!!

    if ([delegate respondsToSelector:@selector(fetchLastUpdatedDidSucceed:isOutdated:context:)])
            [delegate fetchLastUpdatedDidSucceed:nil isOutdated:YES context:callerContext];
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
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureUser",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureApidInterface createCaptureUser:[self toReplaceDictionaryIncludingArrays:YES]
                                    withToken:[JRCaptureData creationToken]
                                  forDelegate:[JRCaptureUserExtrasApidHandler captureUserExtrasApidHandler]
                                  withContext:newContext];
}

+ (void)fetchCaptureUserFromServerForDelegate:(id <JRCaptureUserDelegate>)delegate context:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     @"/", @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureApidInterface getCaptureObjectAtPath:@"/"
                                         withToken:[JRCaptureData accessToken]
                                       forDelegate:[JRCaptureUserExtrasApidHandler captureUserExtrasApidHandler]
                                       withContext:newContext];
}

- (void)fetchLastUpdatedFromServerForDelegate:(id <JRCaptureUserDelegate>)delegate context:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureUser",
                                                     @"/lastUpdated", @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureApidInterface getCaptureObjectAtPath:@"/lastUpdated"
                                         withToken:[JRCaptureData accessToken]
                                       forDelegate:[JRCaptureUserExtrasApidHandler captureUserExtrasApidHandler]
                                       withContext:newContext];
}

+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary
{
    return [JRCaptureUser captureUserObjectFromDictionary:dictionary withPath:@""];
}
@end
