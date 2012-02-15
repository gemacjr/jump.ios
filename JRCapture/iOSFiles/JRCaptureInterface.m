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

#import "JRCaptureInterface.h"
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

@interface JRCaptureInterface ()
@property (nonatomic, retain) id<JRCaptureInterfaceDelegate> captureInterfaceDelegate;
@property (nonatomic, retain) JRCaptureUser *captureUser;
@property (nonatomic, copy)   NSString      *captureCreationToken;
@property (nonatomic, copy)   NSString      *captureDomain;
@property (nonatomic, copy)   NSString      *clientId;
@property (nonatomic, copy)   NSString      *entityTypeName;
@end

@implementation JRCaptureInterface
@synthesize captureInterfaceDelegate;
@synthesize captureUser;
@synthesize captureCreationToken;
@synthesize captureDomain;
@synthesize clientId;
@synthesize entityTypeName;
static JRCaptureInterface *singleton = nil;

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

+ (NSString *)captureMobileEndpointUrl
{
    JRCaptureInterface *captureInterface = [JRCaptureInterface captureInterfaceInstance];
    return [NSString stringWithFormat:@"%@/oauth/mobile_signin?client_id=%@&redirect_uri=https://example.com",
                     captureInterface.captureDomain, captureInterface.clientId];
}

+ (void)setCaptureDomain:(NSString *)newCaptureDomain clientId:(NSString *)newClientId andEntityTypeName:(NSString *)newEntityTypeName
{
    JRCaptureInterface *captureInterface = [JRCaptureInterface captureInterfaceInstance];
    captureInterface.clientId       = newClientId;
    captureInterface.captureDomain  = newCaptureDomain;
    captureInterface.entityTypeName = newEntityTypeName;
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

    [body appendData:[[NSString stringWithFormat:@"type_name=%@", entityTypeName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&attributes=%@", attributes] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&creation_token=%@", captureCreationToken] dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/entity.create", captureDomain]]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
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
              forDelegate:(id<JRCaptureInterfaceDelegate>)delegate
{
    DLog(@"");
   JRCaptureInterface *captureInterface = [JRCaptureInterface captureInterfaceInstance];

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

    [clientId release];
    [captureDomain release];
    [entityTypeName release];
    [super dealloc];
}

@end
