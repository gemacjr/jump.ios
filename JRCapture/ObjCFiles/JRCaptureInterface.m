//
//  Created by lillialexis on 1/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "CaptureInterface.h"
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

@interface CaptureInterface ()
@property (nonatomic, retain) id<CaptureInterfaceDelegate> captureInterfaceDelegate;
@property (nonatomic, retain) JRCaptureUser *captureUser;
@property (nonatomic, copy)   NSString      *captureCreationToken;
@property (nonatomic, copy)   NSString      *captureUrl;// = @"https://demo.staging.janraincapture.com/";
@property (nonatomic, copy)   NSString      *clientId;//   = @"svaf3gxsmcvyfpx5vcrdwyv2axvy9zqg";
@property (nonatomic, copy)   NSString      *typeName;//   = @"demo_user";
@end

@implementation CaptureInterface
@synthesize captureInterfaceDelegate;
@synthesize captureUser;
@synthesize captureCreationToken;
@synthesize captureUrl;
@synthesize clientId;
@synthesize typeName;
static CaptureInterface* singleton = nil;

//static NSString *captureUrl = @"https://demo.staging.janraincapture.com/";
//static NSString *clientId   = @"svaf3gxsmcvyfpx5vcrdwyv2axvy9zqg";
//static NSString *typeName   = @"demo_user";


- (CaptureInterface*)init
{
    if ((self = [super init])) { }

    return self;
}

+ (id)captureInterfaceInstance
{
    if (singleton == nil) {
        singleton = [((CaptureInterface*)[super allocWithZone:NULL]) init];
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

+ (void)setCaptureUrlString:(NSString *)captureUrlString andEntityTypeName:(NSString *)entityTypeName
{
    CaptureInterface* captureInterface = [CaptureInterface captureInterfaceInstance];
    captureInterface.captureUrl = captureUrlString;
    captureInterface.typeName   = entityTypeName;
}

- (void)finishCreateCaptureUser:(NSString*)message
{
    DLog(@"");
    // blah blah blah

    if ([message isEqualToString:@"ok"])
    {
        if ([captureInterfaceDelegate respondsToSelector:@selector(createCaptureUserDidSucceed)])
            [captureInterfaceDelegate createCaptureUserDidSucceed];
    }
    else
    {
        if ([captureInterfaceDelegate respondsToSelector:@selector(createCaptureUserDidFail)])
            [captureInterfaceDelegate createCaptureUserDidFail];
    }

    self.captureInterfaceDelegate = nil;
}

- (void)startCreateCaptureUser:(NSDictionary*)user
{
    DLog(@"");

    NSString      *attributes = [[user JSONString] URLEscaped];
    NSMutableData *body       = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"type_name=%@", typeName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&attributes=%@", attributes] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&creation_token=%@", captureCreationToken] dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity.create", captureUrl]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary* tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"createUser", @"action",
                                        user, @"user", nil];

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self finishCreateCaptureUser:@"fail"];
}

//+ (void)captureUserObjectFromDictionary:(NSDictionary *)dictionary
//{
//    CaptureInterface* captureInterface = [CaptureInterface captureInterfaceInstance];
//    captureInterface.captureUser       = [JRCaptureUser captureUserObjectFromDictionary:dictionary];
//}

+ (void)createCaptureUser:(NSDictionary *)user withCreationToken:(NSString *)creationToken
              forDelegate:(id<CaptureInterfaceDelegate>)delegate
{
    DLog(@"");
    CaptureInterface* captureInterface = [CaptureInterface captureInterfaceInstance];

    captureInterface.captureInterfaceDelegate = delegate;
    captureInterface.captureCreationToken     = creationToken;

    [captureInterface startCreateCaptureUser:user];
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
            [self finishCreateCaptureUser:@"ok"];
            // TODO populate user model with result, and result of user profile query
        }
        else
        {
            DLog(@"Capture creation failure: %@", payload);
            [self finishCreateCaptureUser:@"fail"];
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

    if ([action isEqualToString:@"createUser"])
    {
        // ...
        [self finishCreateCaptureUser:@"fail"];
    }
}

- (void)connectionWasStoppedWithTag:(NSObject*)userdata { }

- (void)dealloc
{
    [captureInterfaceDelegate release];
    [captureUser release];
    [captureCreationToken release];

    [captureUrl release];
    [clientId release];
    [typeName release];
    [super dealloc];
}

@end
