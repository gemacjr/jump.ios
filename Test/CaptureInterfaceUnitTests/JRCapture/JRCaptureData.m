//
//  JRCaptureData.m
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

#import "JRCaptureData.h"
#import "SFHFKeychainUtils.h"

#define cJRCaptureKeychainIdentifier @"capture_tokens.janrain"
#define cJRCaptureUserUuid           @"jrcapture.captureUserUuid"
#define cJRCreationTokenDummyUuid    @"no_uuid_available.new_user"
#define cJRMissingUuidDummyString    @"no_uuid_available"


static NSString* applicationBundleDisplayNameAndIdentifier()
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [infoPlist objectForKey:@"CFBundleDisplayName"];
    NSString *ident = [infoPlist objectForKey:@"CFBundleIdentifier"];

    return [NSString stringWithFormat:@"%@.%@", name, ident];
}

typedef enum
{
    JRTokenTypeAccess,
    JRTokenTypeCreation,
} JRTokenType;

@interface JRCaptureData ()
+ (NSString *)loadUuidForLastLoggedInUser;
+ (void)saveUuidForLastLoggedInUser:(NSString *)uuid;
+ (NSString *)retrieveTokenFromKeychainOfType:(JRTokenType)tokenType forUser:(NSString *)uuid;
@property (nonatomic, copy) NSString *captureApidDomain;
@property (nonatomic, copy) NSString *captureUIDomain;
@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *entityTypeName;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *creationToken;
@property (nonatomic, copy) NSString *uuid;
@end

@implementation JRCaptureData
static JRCaptureData *singleton = nil;

@synthesize clientId;
@synthesize entityTypeName;
@synthesize captureApidDomain;
@synthesize captureUIDomain;
@synthesize accessToken;
@synthesize creationToken;
@synthesize uuid;

- (JRCaptureData *)init
{
    if ((self = [super init]))
    {
        uuid          = [[JRCaptureData loadUuidForLastLoggedInUser] retain];
        accessToken   = [[JRCaptureData retrieveTokenFromKeychainOfType:JRTokenTypeAccess forUser:uuid] retain];
        creationToken = [[JRCaptureData retrieveTokenFromKeychainOfType:JRTokenTypeCreation forUser:cJRCreationTokenDummyUuid] retain];
    }

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

+ (NSString *)loadUuidForLastLoggedInUser
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:cJRCaptureUserUuid];
}

+ (void)saveUuidForLastLoggedInUser:(NSString *)uuid
{
    [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:cJRCaptureUserUuid];
}

+ (NSString *)serviceNameForTokenType:(JRTokenType)tokenType
{
    return [NSString stringWithFormat:@"%@.%@.%@.",
                cJRCaptureKeychainIdentifier,
                (tokenType == JRTokenTypeAccess ? @"access_token" : @"creation_token"),
                applicationBundleDisplayNameAndIdentifier()];
}

+ (void)deleteTokenFromKeychainOfType:(JRTokenType)tokenType forUser:(NSString *)uuid
{
    NSError  *error = nil;

    [SFHFKeychainUtils deleteItemForUsername:uuid
                              andServiceName:[JRCaptureData serviceNameForTokenType:tokenType]
                                       error:&error];

    if (error)
        ALog (@"Error deleting device token from keychain: %@", [error localizedDescription]);
}

+ (void)storeTokenInKeychain:(NSString *)token ofType:(JRTokenType)tokenType forUser:(NSString *)uuid
{
    NSError  *error = nil;

    [SFHFKeychainUtils storeUsername:uuid
                         andPassword:token
                      forServiceName:[JRCaptureData serviceNameForTokenType:tokenType]
                      updateExisting:YES
                               error:&error];

    if (error)
        ALog (@"Error storing device token in keychain: %@", [error localizedDescription]);
}

+ (NSString *)retrieveTokenFromKeychainOfType:(JRTokenType)tokenType forUser:(NSString *)uuid
{
    NSError  *error = nil;

    NSString *token = [SFHFKeychainUtils getPasswordForUsername:uuid
                                                 andServiceName:[JRCaptureData serviceNameForTokenType:tokenType]
                                                          error:&error];

    if (error)
        ALog (@"Error retrieving device token in keychain: %@", [error localizedDescription]);

    return token;
}

+ (void)saveNewToken:(NSString *)token ofType:(JRTokenType)tokenType andUuid:(NSString *)newUuid
{
    NSString *oldUuid = [[JRCaptureData captureDataInstance] uuid];

    // TODO: Don't delete the tokens if they aren't already there
    [JRCaptureData deleteTokenFromKeychainOfType:JRTokenTypeAccess forUser:oldUuid];
    [JRCaptureData deleteTokenFromKeychainOfType:JRTokenTypeCreation forUser:oldUuid];

    [[JRCaptureData captureDataInstance] setUuid:newUuid];
    [JRCaptureData saveUuidForLastLoggedInUser:newUuid];

    if (tokenType == JRTokenTypeAccess)
    {
        [[JRCaptureData captureDataInstance] setAccessToken:token];
        [[JRCaptureData captureDataInstance] setCreationToken:nil];

        [JRCaptureData storeTokenInKeychain:token ofType:JRTokenTypeAccess forUser:newUuid];
    }
    else
    {
        [[JRCaptureData captureDataInstance] setCreationToken:token];
        [[JRCaptureData captureDataInstance] setAccessToken:nil];

        [JRCaptureData storeTokenInKeychain:token ofType:JRTokenTypeCreation forUser:newUuid];
    }
}

+ (void)setAccessToken:(NSString *)newAccessToken forUser:(NSString *)newUuid
{
    if (!newUuid || [newUuid isEqualToString:@""])
        newUuid = cJRMissingUuidDummyString;

    [JRCaptureData saveNewToken:newAccessToken ofType:JRTokenTypeAccess andUuid:newUuid];
}

+ (void)setCreationToken:(NSString *)newCreationToken// forUser:(NSString *)newUuid
{
    NSString *newUuid = cJRCreationTokenDummyUuid;

    [JRCaptureData saveNewToken:newCreationToken ofType:JRTokenTypeCreation andUuid:newUuid];
}

+ (NSString *)accessTokenForUser:(NSString *)uuid
{
    if (!uuid || [uuid isEqualToString:@""])
        uuid = cJRMissingUuidDummyString;

    if ([uuid isEqualToString:[[JRCaptureData captureDataInstance] uuid]])
        return [[JRCaptureData captureDataInstance] accessToken];

    return nil;
}

+ (NSString *)accessToken
{
    return [[JRCaptureData captureDataInstance] accessToken];
}

+ (NSString *)creationToken
{
    return [[JRCaptureData captureDataInstance] creationToken];
}

+ (NSString *)creationTokenForUser:(NSString *)uuid
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
    [uuid release];

    [super dealloc];
}
@end
