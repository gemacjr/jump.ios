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
- (NSString *)accessToken
{
    return [[JRCaptureUserExtras captureUserExtras] accessToken];
}

- (NSString *)creationToken
{
    return [[JRCaptureUserExtras captureUserExtras] creationToken];
}

- (void)setAccessToken:(NSString *)anAccessToken
{
    [[JRCaptureUserExtras captureUserExtras] setAccessToken:anAccessToken];
}

- (void)setCreationToken:(NSString *)aCreationToken
{
    [[JRCaptureUserExtras captureUserExtras] setCreationToken:aCreationToken];
}

- (void)updateForDelegate:(id<JRCaptureUserDelegate>)delegate
{
    [[JRCaptureUserExtras captureUserExtras] setDelegate:delegate];

    [JRCaptureInterface updateCaptureUser:[self dictionaryFromObject]
                          withAccessToken:[[JRCaptureUserExtras captureUserExtras] accessToken]
                              forDelegate:self];
}

- (void)createForDelegate:(id<JRCaptureUserDelegate>)delegate
{
    [[JRCaptureUserExtras captureUserExtras] setDelegate:delegate];

    [JRCaptureInterface createCaptureUser:[self dictionaryFromObject]
                        withCreationToken:[[JRCaptureUserExtras captureUserExtras] creationToken]
                              forDelegate:self];
}

- (void)createCaptureUserDidFailWithResult:(NSString *)result
{
    id<JRCaptureUserDelegate> delegate = [[JRCaptureUserExtras captureUserExtras] delegate];

    if ([delegate respondsToSelector:@selector(captureUserCreated:withResult:)])
        [delegate captureUserCreated:self withResult:result];

    [[JRCaptureUserExtras captureUserExtras] setDelegate:nil];
}

- (void)createCaptureUserDidSucceedWithResult:(NSString *)result
{
    id<JRCaptureUserDelegate> delegate = [[JRCaptureUserExtras captureUserExtras] delegate];

    if ([delegate respondsToSelector:@selector(captureUserCreated:withResult:)])
        [delegate captureUserCreated:self withResult:result];

    [[JRCaptureUserExtras captureUserExtras] setDelegate:nil];
}

- (void)updateCaptureUserDidFailWithResult:(NSString *)result
{
    id<JRCaptureUserDelegate> delegate = [[JRCaptureUserExtras captureUserExtras] delegate];

    if ([delegate respondsToSelector:@selector(captureUserUpdated:withResult:)])
        [delegate captureUserUpdated:self withResult:result];

    [[JRCaptureUserExtras captureUserExtras] setDelegate:nil];
}

- (void)updateCaptureUserDidSucceedWithResult:(NSString *)result
{
    id<JRCaptureUserDelegate> delegate = [[JRCaptureUserExtras captureUserExtras] delegate];

    if ([delegate respondsToSelector:@selector(captureUserCreated:withResult:)])
        [delegate captureUserUpdated:self withResult:result];

    [[JRCaptureUserExtras captureUserExtras] setDelegate:nil];
}

@end
