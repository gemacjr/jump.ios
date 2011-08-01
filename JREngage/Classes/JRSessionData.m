/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 Copyright (c) 2010, Janrain, Inc.
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
	 list of conditions and the following disclaimer. 
 * Redistributions in binary form must reproduce the above copyright notice, 
	 this list of conditions and the following disclaimer in the documentation and/or
	 other materials provided with the distribution. 
 * Neither the name of the Janrain, Inc. nor the names of its
	 contributors may be used to endorse or promote products derived from this
	 software without specific prior written permission.
 
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
 
 File:	 JRSessionData.m 
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import "JRSessionData.h"
#import <Security/Security.h>

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#pragma mark server_urls
//#define ENGAGE_STAGING_SERVER
//#define ENGAGE_LOCAL_SERVER
//#define ENGAGE_OLEG_SERVER
#ifdef ENGAGE_STAGING_SERVER
static NSString * const serverUrl = @"https://rpxstaging.com";
#else
#ifdef ENGAGE_LOCAL_SERVER
static NSString * const serverUrl = @"http://lilli.janrain.com:8080";
#else
#ifdef ENGAGE_OLEG_SERVER
static NSString * const serverUrl = @"http://oleg.janrain.com:8080";
#else
static NSString * const serverUrl = @"https://rpxnow.com";
#endif
#endif
#endif

#pragma mark consts
/* Lists of the standard names for providers' logo and icons */
static NSString * const iconNames[5] = { @"icon_%@_30x30.png",
                                         @"icon_%@_30x30@2x.png",
                                         @"logo_%@_280x65.png",
                                         @"logo_%@_280x65@2x.png", nil };

static NSString * const iconNamesSocial[11] = { @"icon_%@_30x30.png",
                                                @"icon_%@_30x30@2x.png",
                                                @"logo_%@_280x65.png",
                                                @"logo_%@_280x65@2x.png",
                                                @"icon_bw_%@_30x30.png",
                                                @"icon_bw_%@_30x30@2x.png",
                                                @"button_%@_135x40.png",
                                                @"button_%@_135x40@2x.png",
                                                @"button_%@_280x40.png",
                                                @"button_%@_280x40@2x.png", nil };

#define AUTHENTICATED_USERS_BY_PROVIDER	@"jrengage.sessionData.authenticatedUsersByProvider"
#define ALL_PROVIDERS					@"jrengage.sessionData.allProviders"
#define BASIC_PROVIDERS					@"jrengage.sessionData.basicProviders"
#define SOCIAL_PROVIDERS				@"jrengage.sessionData.socialProviders"
#define ICONS_STILL_NEEDED				@"jrengage.sessionData.iconsStillNeeded"
#define PROVIDERS_WITH_ICONS			@"jrengage.sessionData.providersWithIcons"
#define BASE_URL						@"jrengage.sessionData.baseUrl"
#define HIDE_POWERED_BY					@"jrengage.sessionData.hidePoweredBy"
#define LAST_USED_SOCIAL_PROVIDER		@"jrengage.sessionData.lastUsedSocialProvider"
#define LAST_USED_BASIC_PROVIDER		@"jrengage.sessionData.lastUsedBasicProvider"

#define JRENGAGE_KEYCHAIN_IDENTIFIER    @"device_tokens.janrain"

#define WELCOME_STRING_FOR_PROVIDER     @"jrengage.provider.%@.welcomeString"
#define USER_INPUT_FOR_PROVIDER         @"jrengage.provider.%@.userInput"
#define FORCE_REAUTH_FLAG_FOR_PROVIDER  @"jrengage.provider.%@.forceReauth"

#pragma mark helper_functions
NSString* applicationBundleDisplayNameAndIdentifier()
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [infoPlist objectForKey:@"CFBundleDisplayName"];
    NSString *ident = [infoPlist objectForKey:@"CFBundleIdentifier"];
    
    return [NSString stringWithFormat:@"%@.%@", name, ident];
}

NSString* applicationBundleDisplayName()
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    return [infoPlist objectForKey:@"CFBundleDisplayName"];
}

void RLog (NSObject *object)
{
    NSLog(@"Object: %@\t\tRetain Count:  %d", [object class], [object retainCount]);
}

#pragma mark JRError
NSString * JREngageErrorDomain = @"JREngage.ErrorDomain";

@implementation JRError
+ (NSError*)setError:(NSString*)message withCode:(NSInteger)code
{
    ALog (@"An error occured (%d): %@", code, message);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              message, NSLocalizedDescriptionKey, nil];
    
    return [[[NSError alloc] initWithDomain:JREngageErrorDomain
                                       code:code
                                   userInfo:userInfo] autorelease];
}
@end

#pragma mark JRActivityObject ()
@implementation JRActivityObject (shortenedUrl)
- (NSString*)shortenedUrl { return shortenedUrl; }
- (void)setShortenedUrl:(NSString*)newUrl { [newUrl retain]; [shortenedUrl release]; shortenedUrl = newUrl; }
@end

#pragma mark JRAuthenticatedUser
@interface JRAuthenticatedUser ()
- (id)initUserWithDictionary:(NSDictionary*)dictionary forProviderNamed:(NSString*)_provider_name;
@end

@implementation JRAuthenticatedUser
@synthesize photo;
@synthesize preferred_username;
@synthesize device_token;
@synthesize provider_name;

- (id)initUserWithDictionary:(NSDictionary*)dictionary forProviderNamed:(NSString*)_provider_name
{
    if (dictionary == nil || _provider_name == nil || (void*)[dictionary objectForKey:@"device_token"] == kCFNull)
	{
		[self release];
		return nil;
	}
	
	if (self = [super init]) 
	{
        device_token = [[dictionary objectForKey:@"device_token"] retain];
        provider_name = [_provider_name retain];
        
        if ((void*)[dictionary objectForKey:@"photo"] != kCFNull)
            photo = [[dictionary objectForKey:@"photo"] retain];

        if ((void*)[dictionary objectForKey:@"preferred_username"] != kCFNull)
            preferred_username = [[dictionary objectForKey:@"preferred_username"] retain];        
    }

	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:provider_name forKey:@"provider_name"];
    [coder encodeObject:photo forKey:@"photo"];
    [coder encodeObject:preferred_username forKey:@"preferred_username"];
    [coder encodeObject:nil forKey:@"device_token"];

    NSError *error = nil;
    [SFHFKeychainUtils storeUsername:provider_name 
                         andPassword:device_token 
                      forServiceName:[NSString stringWithFormat:@"%@.%@.", JRENGAGE_KEYCHAIN_IDENTIFIER, applicationBundleDisplayNameAndIdentifier()] 
                      updateExisting:YES 
                               error:&error];

    if (error)
        ALog (@"Error storing device token in keychain: %@", [error localizedDescription]);
}

- (id)initWithCoder:(NSCoder *)coder
{
    // QTS: Probably need to autorelease this, yes? I think that made it crash...
	//self = [[JRAuthenticatedUser alloc] init];

    if (self != nil)
    {
        provider_name = [[coder decodeObjectForKey:@"provider_name"] retain];
        photo = [[coder decodeObjectForKey:@"photo"] retain];
        preferred_username = [[coder decodeObjectForKey:@"preferred_username"] retain];

        NSError *error = nil;
        device_token = [[SFHFKeychainUtils getPasswordForUsername:provider_name
                                                   andServiceName:[NSString stringWithFormat:@"%@.%@.", JRENGAGE_KEYCHAIN_IDENTIFIER, applicationBundleDisplayNameAndIdentifier()] 
                                                            error:&error] retain];
        
        if (error)
            ALog (@"Error retrieving device token in keychain: %@", [error localizedDescription]);
        
        /* For backwards compatibility */
        if (!device_token)
            device_token = [[coder decodeObjectForKey:@"device_token"] retain];
        
    }   

    return self;
}

- (void)removeDeviceTokenFromKeychain
{
    NSError *error = nil;
    [SFHFKeychainUtils deleteItemForUsername:provider_name
                              andServiceName:[NSString stringWithFormat:@"%@.%@.", JRENGAGE_KEYCHAIN_IDENTIFIER, applicationBundleDisplayNameAndIdentifier()] 
                                       error:&error];
    if (error)
        ALog (@"Error deleting device token from keychain: %@", [error localizedDescription]);
}

- (void)dealloc
{
    // QTS: Are we ever going to be leaking these?  Assuming correct retain counting,
    // these should dealloc when the user is signed out.
    [self removeDeviceTokenFromKeychain];
    
    DLog (@"");
    
    [provider_name release];
    [photo release];
    [preferred_username release];
    [device_token release];
    
    [super dealloc];
}
@end

#pragma mark JRProvider
@interface JRProvider ()
@property (readonly) BOOL      social;
@property (readonly) NSString *openIdentifier;
@property (readonly) NSString *url;
- (JRProvider*)initWithName:(NSString*)_name andDictionary:(NSDictionary*)_dictionary;
@end

@implementation JRProvider
@synthesize name;
@synthesize friendlyName;
@synthesize placeholderText;
@synthesize openIdentifier;
@synthesize url;
@synthesize requiresInput;
@synthesize shortText;
@synthesize socialSharingProperties;
@synthesize social;

- (NSString*)welcomeString
{
    return welcomeString;
}

- (void)setWelcomeString:(NSString *)_welcomeString
{
    [_welcomeString retain];
    [welcomeString release];
    
    welcomeString = _welcomeString;
    
    /* Save our dynamic variables, in case we ever need to re-initialize a provider object, the init... functions can pull these
     from the user defaults. */
    [[NSUserDefaults standardUserDefaults] setValue:welcomeString forKey:[NSString stringWithFormat:WELCOME_STRING_FOR_PROVIDER, self.name]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)userInput
{
    return userInput;
}

- (void)setUserInput:(NSString *)_userInput
{
    [_userInput retain];
    [userInput release];
    
    userInput = _userInput;
    
    /* Save our dynamic variables, in case we ever need to re-initialize a provider object, the init... functions can pull these
     from the user defaults. */    
    [[NSUserDefaults standardUserDefaults] setValue:userInput forKey:[NSString stringWithFormat:USER_INPUT_FOR_PROVIDER, self.name]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)forceReauth
{
    return forceReauth;
}

- (void)setForceReauth:(BOOL)_forceReauth
{
    forceReauth = _forceReauth;
    
    /* Save our dynamic variables, in case we ever need to re-initialize a provider object, the init... functions can pull these
     from the user defaults. */    
    [[NSUserDefaults standardUserDefaults] setBool:forceReauth forKey:[NSString stringWithFormat:FORCE_REAUTH_FLAG_FOR_PROVIDER, self.name]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/* For a number of reasons, we may need to reload the configuration information for our providers.  Because these variables
   are dynamic (i.e., not returned in the block of configuration code), we need to save them elsewhere and call them by our 
   init... functions. */
- (void)loadDynamicVariables
{
    welcomeString = [[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:WELCOME_STRING_FOR_PROVIDER, name]] retain];
    userInput     = [[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:USER_INPUT_FOR_PROVIDER, name]] retain];
    forceReauth   =  [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:FORCE_REAUTH_FLAG_FOR_PROVIDER, name]];
}

- (JRProvider*)initWithName:(NSString*)_name andDictionary:(NSDictionary*)_dictionary
{
	DLog (@"New Provider: %@", _name);
    
    if (_name == nil || _name.length == 0 || _dictionary == nil)
	{
		[self release];
		return nil;
	}
	
	if (self = [super init]) 
	{
		name = [_name retain];
        
        friendlyName = [[_dictionary objectForKey:@"friendly_name"] retain];
        placeholderText = [[_dictionary objectForKey:@"input_prompt"] retain];
        openIdentifier = [[_dictionary objectForKey:@"openid_identifier"] retain];
        url = [[_dictionary objectForKey:@"url"] retain]; 

        if ([[_dictionary objectForKey:@"requires_input"] isEqualToString:@"YES"])
            requiresInput = YES;
        
        if (requiresInput)
        {
            NSArray *arr = [[self.placeholderText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@" "];
            NSRange subArr = {[arr count] - 2, 2};
            
            NSArray *newArr = [arr subarrayWithRange:subArr];
            shortText = [[newArr componentsJoinedByString:@" "] retain];	
        }
        else 
        {
            shortText = @"";
        }
        
        socialSharingProperties = [[_dictionary objectForKey:@"social_sharing_properties"] retain];
        
        if ([socialSharingProperties count])
            social = YES;
        
        [self loadDynamicVariables];
    }
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:friendlyName forKey:@"friendlyName"];
    [coder encodeObject:placeholderText forKey:@"placeholderText"];
    [coder encodeObject:shortText forKey:@"shortText"];
    [coder encodeObject:openIdentifier forKey:@"openIdentifier"];
    [coder encodeObject:url forKey:@"url"];
    [coder encodeBool:requiresInput forKey:@"requiresInput"];    
    [coder encodeObject:socialSharingProperties forKey:@"socialSharingProperties"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    //self = [[JRProvider alloc] init];
    
    if (self != nil)
    {
        name =            [[coder decodeObjectForKey:@"name"] retain];
        friendlyName =    [[coder decodeObjectForKey:@"friendlyName"] retain];
        placeholderText = [[coder decodeObjectForKey:@"placeholderText"] retain];
        shortText =       [[coder decodeObjectForKey:@"shortText"] retain];
        openIdentifier =  [[coder decodeObjectForKey:@"openIdentifier"] retain];
        url =             [[coder decodeObjectForKey:@"url"] retain];
        requiresInput =    [coder decodeBoolForKey:@"requiresInput"];
        socialSharingProperties = [[coder decodeObjectForKey:@"socialSharingProperties"] retain];
    }   
    [self loadDynamicVariables];
    
    return self;
}

- (BOOL)isEqualToReturningProvider:(NSString*)returningProvider
{
    if ([self.name isEqualToString:returningProvider])
        return YES;
    
    return NO;
}

- (void)dealloc
{
    [name release];
    [friendlyName release];
    [placeholderText release];
    [shortText release];
    [openIdentifier release];
    [url release];	
    [userInput release];
    [welcomeString release];
    [socialSharingProperties release];
    
	[super dealloc];
}
@end

#pragma mark JRSessionData
@interface JRSessionData ()
- (NSString*)getWelcomeMessageFromCookieString:(NSString*)cookieString;
- (NSError*)startGetConfiguration;
- (NSError*)finishGetConfiguration:(NSString *)dataStr;
- (void)startGetShortenedUrlsForActivity:(JRActivityObject *)_activity;
@end

@implementation JRSessionData
@synthesize allProviders;
@synthesize basicProviders;
@synthesize socialProviders;
@synthesize currentProvider;
@synthesize returningSocialProvider;
@synthesize baseUrl;
@synthesize tokenUrl;
@synthesize alwaysForceReauth;
@synthesize forceReauth;
@synthesize socialSharing;
@synthesize hidePoweredBy;
@synthesize error;

#pragma mark singleton_methods
static JRSessionData* singleton = nil;
+ (JRSessionData*)jrSessionData
{
	return singleton;
}

+ (id)allocWithZone:(NSZone*)zone
{
    return [[self jrSessionData] retain];
}

- (id)copyWithZone:(NSZone*)zone
{
    return self;
}

- (id)retain                { return self; }
- (NSUInteger)retainCount   { return NSUIntegerMax; }
- (void)release             { /* Do nothing... */ }
- (id)autorelease           { return self; }

#pragma mark accessors
- (NSString*)returningBasicProvider
{
    if (alwaysForceReauth)
        return nil;
    
    return returningBasicProvider;
}

- (BOOL)dialogIsShowing
{
    return dialogIsShowing;
}

- (void)setDialogIsShowing:(BOOL)isShowing
{/* If we found out that the configuration changed while a dialog was showing, we saved it until the dialog wasn't showing
    since the dialogs dynamically load our data. Now that the dialog isn't showing, load the saved configuration information. */
    if (!isShowing && savedConfigurationBlock)
        error = [[self finishGetConfiguration:savedConfigurationBlock] retain];
    
 /* If the dialog is going away, then we don't still need to shorten the urls */
    if (!isShowing)
        stillNeedToShortenUrls = NO;
    
    dialogIsShowing = isShowing;
}

- (void)setActivity:(JRActivityObject*)_activity
{   
    [_activity retain];
    [activity release];
    
    activity = _activity;

    if (!activity)
        return;

    [self startGetShortenedUrlsForActivity:activity];
}

- (JRActivityObject*)activity
{
    return activity;
}

#pragma mark initilization
- (id)initWithAppId:(NSString*)_appId tokenUrl:(NSString*)_tokenUrl andDelegate:(id<JRSessionDelegate>)_delegate
{
	DLog (@"");

	if (self = [super init]) 
	{
        singleton = self;
        
        delegates = [[NSMutableArray alloc] initWithObjects:[_delegate retain], nil];
		appId = [_appId retain];
        tokenUrl = [_tokenUrl retain];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            device = @"ipad";
        else
            device = @"iphone";
        
        /* First, we load all of the cached data (the list of providers, saved users, base url, etc.) */
        
        /* Load the dictionary of authenticated users */
        NSData *archivedUsers = [[NSUserDefaults standardUserDefaults] objectForKey:AUTHENTICATED_USERS_BY_PROVIDER];
        if (archivedUsers != nil)
        {
            NSDictionary *unarchivedUsers = [NSKeyedUnarchiver unarchiveObjectWithData:archivedUsers];
            if (unarchivedUsers != nil)
                authenticatedUsersByProvider = [[NSMutableDictionary alloc] initWithDictionary:unarchivedUsers];
        }
        
        /* And if there weren't any saved users, init the dictionary */
        if (!authenticatedUsersByProvider)
            authenticatedUsersByProvider = [[NSMutableDictionary alloc] initWithCapacity:1];

        /* Load the list of all providers */
        NSData *archivedProviders = [[NSUserDefaults standardUserDefaults] objectForKey:ALL_PROVIDERS];
        if (archivedProviders != nil)
        {
            NSDictionary *unarchivedProviders = [NSKeyedUnarchiver unarchiveObjectWithData:archivedProviders];
            if (unarchivedProviders != nil)
                allProviders = [[NSMutableDictionary alloc] initWithDictionary:unarchivedProviders];
        }
        
        /* Load the list of basic providers */
        basicProviders = [[[NSUserDefaults standardUserDefaults] objectForKey:BASIC_PROVIDERS] retain];
  
        /* Load the list of social providers */
//        NSMutableArray *temp = [NSMutableArray arrayWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:SOCIAL_PROVIDERS] retain]];
//        [temp addObject:@"yahoo"];
//        socialProviders = [[NSArray alloc] initWithArray:temp];//[[[NSUserDefaults standardUserDefaults] objectForKey:SOCIAL_PROVIDERS] retain];

        socialProviders = [[[NSUserDefaults standardUserDefaults] objectForKey:SOCIAL_PROVIDERS] retain];
        
        
        /* Load the list of icons that the library should re-attempt to download, in case previous attempts failed for whatever reason */
        NSData *archivedIconsStillNeeded = [[NSUserDefaults standardUserDefaults] objectForKey:ICONS_STILL_NEEDED];
        if (archivedIconsStillNeeded != nil)
        {
            NSDictionary *unarchivedIconsStillNeeded = [NSKeyedUnarchiver unarchiveObjectWithData:archivedIconsStillNeeded];
            if (unarchivedIconsStillNeeded != nil)
                iconsStillNeeded = [[NSMutableDictionary alloc] initWithDictionary:unarchivedIconsStillNeeded];
        }

        /* Load the set of providers that already have all of their icons; checking this list is faster than checking for the icons themselves */
        NSData *archivedProvidersWithIcons = [[NSUserDefaults standardUserDefaults] objectForKey:PROVIDERS_WITH_ICONS];
        if (archivedProvidersWithIcons != nil)
        {
            NSSet *unarchivedProvidersWithIcons = [NSKeyedUnarchiver unarchiveObjectWithData:archivedProvidersWithIcons];
            if (unarchivedProvidersWithIcons != nil)
                providersWithIcons = [[NSMutableSet alloc] initWithSet:unarchivedProvidersWithIcons];
        }
        
        /* Load the base url and whether or not we need to hide the tagline */
        baseUrl = [[[NSUserDefaults standardUserDefaults] stringForKey:BASE_URL] retain];
        hidePoweredBy = [[NSUserDefaults standardUserDefaults] boolForKey:HIDE_POWERED_BY];
        
        /* And load the last used basic and social providers */
        returningSocialProvider = [[[NSUserDefaults standardUserDefaults] stringForKey:LAST_USED_SOCIAL_PROVIDER] retain];
        returningBasicProvider = [[[NSUserDefaults standardUserDefaults] stringForKey:LAST_USED_BASIC_PROVIDER] retain];
        
        /* As this information may have changed, we're going to ask rpx for this information anyway */
        error = [[self startGetConfiguration] retain];
    }
    
	return self;
}

+ (JRSessionData*)jrSessionDataWithAppId:(NSString*)_appId tokenUrl:(NSString*)_tokenUrl andDelegate:(id<JRSessionDelegate>)_delegate
{
	if(singleton)
		return singleton;
	
	if (_appId == nil || _appId.length == 0)
		return nil;
    
	return [[super allocWithZone:nil] initWithAppId:_appId tokenUrl:_tokenUrl andDelegate:_delegate];
}	

- (void)tryToReconfigureLibrary
{
    ALog (@"Configuration error occurred. Trying to reconfigure the library.");
    [error release];
    error = nil;
    
    error = [[self startGetConfiguration] retain];
}

#pragma mark dynamic_icon_handling
- (void)finishDownloadPicture:(NSData*)picture named:(NSString*)pictureName forProvider:(NSString*)provider
{
    DLog (@"Downloaded %@ for %@", pictureName, provider);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:pictureName];
    [fileManager createFileAtPath:path contents:picture attributes:nil];
    
    NSMutableSet *iconsForProvider = [iconsStillNeeded objectForKey:provider];
    [iconsForProvider removeObject:pictureName];
    
    if ([iconsForProvider count] == 0)
    {
        [iconsStillNeeded removeObjectForKey:provider];
        [providersWithIcons addObject:provider];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:iconsStillNeeded] 
                                              forKey:ICONS_STILL_NEEDED];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:providersWithIcons] 
                                              forKey:PROVIDERS_WITH_ICONS];    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)startDownloadPicture:(NSString*)picture forProvider:(NSString*)provider
{
	NSString *urlString = [NSString stringWithFormat:
                           @"%@/cdn/images/mobile_icons/%@/%@", 
                           serverUrl, device, picture];
    
    DLog (@"Attempting to download icon for %@: %@", provider, urlString);
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	
    NSDictionary *tag = [[NSDictionary alloc] initWithObjectsAndKeys:picture, @"pictureName",
                         provider, @"providerName",
                         @"downloadPicture", @"action", nil];
    
    [JRConnectionManager createConnectionFromRequest:request forDelegate:self returnFullResponse:YES withTag:tag];    
}

/* Download any icons that need to be downloaded */
- (void)downloadAnyIcons:(NSMutableDictionary*)neededIcons
{
    DLog ("Icons that are still needed:\n%@", [iconsStillNeeded description]);
    
    for (NSString *provider in [neededIcons allKeys])
    {
        NSMutableSet *icons = [neededIcons objectForKey:provider];
        for (NSString *icon in [icons allObjects])
        {
            [self startDownloadPicture:icon forProvider:provider];
        }
    }
}

- (void)checkForIcons:(NSString**)icons forProvider:(NSString*)providerName
{
//    DLog ("Checking providersWithIcons for %@:\n%@", providerName, [providersWithIcons description]);
//    DLog ("Icons needed so far:\n%@", [iconsStillNeeded description]);
    
 /* If we've already found this provider's icons, they should be in this list; just return. */
    if ([providersWithIcons containsObject:providerName])
        return;
    
 /* If the provider isn't in the list, either the provider's icons need to be downloaded or this is
    the first time this code was run (and no providers have been added to providersWithIcons yet). 
    If it's the latter, both these saved lists will probably be nil, so init them. */
    if (!providersWithIcons)
        providersWithIcons = [[NSMutableSet alloc] initWithCapacity:4];
    
    if (!iconsStillNeeded)
        iconsStillNeeded = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    NSMutableSet *iconsNeeded = [NSMutableSet setWithCapacity:4];
    
 /* Iterate our static arrays of standard image names, insert the provider name, and check if they're there */
    for (int i = 0; icons[i]; i++)
    {
        if (![UIImage imageNamed:[NSString stringWithFormat:icons[i], providerName]])
            [iconsNeeded addObject:[NSString stringWithFormat:icons[i], providerName]];
        else
            DLog ("Found icon: %@", [NSString stringWithFormat:icons[i], providerName]);
    }
    
    if ([iconsNeeded count]) /* And if there are icons that aren't there, add them to the list of icons */
        [iconsStillNeeded setObject:iconsNeeded forKey:providerName];   /*  that need to be downloaded. */
    else /* Otherwise, add the provider to the providersWithIcons list so that we can check these much  */
        [providersWithIcons addObject:providerName];                    /* quicker next time.           */
}

#pragma mark configuration
- (NSString*)appNameAndVersion
{   // TODO: Redo this
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [[[infoPlist objectForKey:@"CFBundleDisplayName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] URLEscaped];
    NSString *ident = [[[infoPlist objectForKey:@"CFBundleIdentifier"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] URLEscaped];
    
    infoPlist = [NSDictionary dictionaryWithContentsOfFile: 
                 [[[NSBundle mainBundle] resourcePath] 
                  stringByAppendingPathComponent:@"/JREngage-Info.plist"]];
    
    NSString *version = [[[infoPlist objectForKey:@"CFBundleShortVersionString"] 
                          stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] URLEscaped];
    
    return [NSString stringWithFormat:@"appName=%@.%@3&version=%@_%@", name, ident, device, version];
}

- (NSError*)startGetConfiguration
{	
    NSString *nameAndVersion = [self appNameAndVersion];
	NSString *urlString = [NSString stringWithFormat:
                           @"%@/openid/mobile_config_and_baseurl?device=%@&appId=%@&%@", 
                           serverUrl, device, appId, nameAndVersion];
    
    ALog (@"Getting configuration for RP: %@", urlString);
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	
	NSString *tag = [[NSString alloc] initWithFormat:@"getConfiguration"];
	
	if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self returnFullResponse:YES withTag:tag])
		return [JRError setError:@"There was a problem connecting to the Janrain server while configuring authentication." 
                        withCode:JRUrlError]; 
    
    return nil;
}

- (NSError*)finishGetConfiguration:(NSString*)dataStr
{
    ALog (@"Configuration information needs to be updated.");
    
    /* Make sure that the returned string can be parsed as json (which there should be no reason that this wouldn't happen) */
    if (![dataStr respondsToSelector:@selector(JSONValue)])
        return [JRError setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                        withCode:JRJsonError];
    
    NSDictionary *jsonDict = [dataStr JSONValue];
    
    /* Double-check the return value */
    if(!jsonDict)
        return [JRError setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                        withCode:JRJsonError];
    
    [baseUrl release];
    baseUrl = [[[jsonDict objectForKey:@"baseurl"] 
                stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]] retain];
    
    if (stillNeedToShortenUrls && activity)
        [self startGetShortenedUrlsForActivity:activity];
    stillNeedToShortenUrls = NO;
    
    /* Then save it */
    [[NSUserDefaults standardUserDefaults] setValue:baseUrl forKey:BASE_URL];
    
    /* Get the providers out of the provider_info section.  These are most likely to have changed. */
    NSDictionary *providerInfo   = [NSDictionary dictionaryWithDictionary:[jsonDict objectForKey:@"provider_info"]];

    [allProviders release];
    allProviders = [[NSMutableDictionary alloc] initWithCapacity:[[providerInfo allKeys] count]];
    
    /* For each provider... */
    for (NSString *name in [providerInfo allKeys])
    {   /* Get its dictionary, */
        NSDictionary *dictionary = [providerInfo objectForKey:name];
        
        /* use this to create a provider object, */
        JRProvider *provider = [[[JRProvider alloc] initWithName:name
                                                   andDictionary:dictionary] autorelease];
        
        /* make sure we have this provider's icons, */
        [self checkForIcons:((provider.social) ? (NSString**)&iconNamesSocial : (NSString**)&iconNames) forProvider:name];
        
        /* and finally add the object to our dictionary of providers. */
        [allProviders setObject:provider forKey:name];
    }
    
    /* Save these now, in case the downloading of the icons gets interrupted for any reason */
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:iconsStillNeeded] 
                                              forKey:ICONS_STILL_NEEDED];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:providersWithIcons] 
                                              forKey:PROVIDERS_WITH_ICONS];    
    [[NSUserDefaults standardUserDefaults] synchronize];    
    
    [basicProviders release];
    [socialProviders release];
    
    /* Get the ordered list of basic providers */
    basicProviders = [[NSArray arrayWithArray:[jsonDict objectForKey:@"enabled_providers"]] retain];
    
    /* Get the ordered list of social providers */
    socialProviders = [[NSArray arrayWithArray:[jsonDict objectForKey:@"social_providers"]] retain];
    
    NSMutableArray *temp = [[NSMutableArray arrayWithArray:[jsonDict objectForKey:@"social_providers"]] retain];
    [temp addObject:@"yahoo"];
    
    socialProviders = [[NSArray alloc] initWithArray:temp];//[[[NSUserDefaults standardUserDefaults] objectForKey:SOCIAL_PROVIDERS] retain];
    
    /* yippie, yahoo! */
    
    /* Then save our stuff */
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:allProviders] 
                                              forKey:ALL_PROVIDERS];
    [[NSUserDefaults standardUserDefaults] setObject:basicProviders forKey:BASIC_PROVIDERS];
    [[NSUserDefaults standardUserDefaults] setObject:socialProviders forKey:SOCIAL_PROVIDERS];
    
    /* Figure out if we need to hide the tag line */
    if ([[jsonDict objectForKey:@"hide_tagline"] isEqualToString:@"YES"])
        hidePoweredBy = YES;
    else
        hidePoweredBy = NO;
    
    /* And finally, save that too */
    [[NSUserDefaults standardUserDefaults] setBool:hidePoweredBy forKey:HIDE_POWERED_BY];
    
    /* Once we know that everything is parsed and saved correctly, save the new etag */
    [[NSUserDefaults standardUserDefaults] setValue:newEtag forKey:@"jrengage.sessionData.configurationEtag"];
    
    [[NSUserDefaults standardUserDefaults] setValue:gitCommit forKey:@"jrengage.sessionData.engageCommit"];
   
    [[NSUserDefaults standardUserDefaults] synchronize];
  
    /* Now, download any missing icons */
    [self downloadAnyIcons:iconsStillNeeded];
    
    /* Then release our saved configuration information */
    [savedConfigurationBlock release];
    [newEtag release];
    
    savedConfigurationBlock = nil;
    newEtag = nil;
    
    return nil;
}

- (NSError*)finishGetConfiguration:(NSString*)dataStr withEtag:(NSString*)etag
{
    ALog (@"Configuration information downloaded: %@", dataStr);
    
    NSDictionary *infoPlist = [NSDictionary dictionaryWithContentsOfFile: 
                               [[[NSBundle mainBundle] resourcePath] 
                                stringByAppendingPathComponent:@"/JREngage-Info.plist"]];
    
    NSString *currentCommit = [infoPlist objectForKey:@"JREngage.GitCommit"];
    NSString *savedCommit = [[NSUserDefaults standardUserDefaults] stringForKey:@"jrengage.sessionData.engageCommit"];
    
    NSString *oldEtag = [[NSUserDefaults standardUserDefaults] stringForKey:@"jrengage.sessionData.configurationEtag"];
    
 /* If the downloaded configuration for this RP has changed, the http://mobile_config... URL's etag will have changed, and we need 
    to update our current configuration information.  Or, any time the JREngage library's code has been changed and committed, 
    the JREngage.GitCommit property in the JREngage-Info.plist will have changed to reflect the current commit.  Since code changes 
    may affect the objects that get synchronized, we need to update our current configuration information when this occurs as well.  
    We test for both of these cases by saving the last etag and commit string, and comparing the saved value to the current value.  
    Almost always, these will be the same, and we are safe using our cached configuration data.  Lastly, if we are testing changes 
    in the synchronization code, we can temporarily set the currentCommit (JREngage.GitCommit) to "1", forcing library to reconfigure
    itself every time. */
    if (![oldEtag isEqualToString:etag] || ![currentCommit isEqualToString:savedCommit] || [currentCommit isEqualToString:@"1"]) 
    {
        newEtag = [etag retain];
        gitCommit = [currentCommit retain];
    
     /* We can only update all of our data if the UI isn't currently using that information.  Otherwise, the library may 
        crash/behave inconsistently.  If a dialog isn't showing, go ahead and update new configuration information.  

        Or, in rare cases, there might not be any data at all (the lists of basic and social providers are nil), perhaps 
        because this is the first time the library was used and the configuration information is still downloading. In these cases, 
        the dialogs will display their view as greyed-out, with a spinning activity indicator and a loading message, as they wait 
        for the lists of providers to download, so we can go ahead and update the configuration information here, too. 
        The dialogs won't try and do anything until we're done updating the lists. */
        if (!dialogIsShowing)
            return [self finishGetConfiguration:dataStr];
        if ([basicProviders count] == 0 && !socialSharing)
            return [self finishGetConfiguration:dataStr];
        if ([socialProviders count] == 0 && socialSharing)
            return [self finishGetConfiguration:dataStr];
        
     /* Otherwise, we have to save all this information for later.  The UserInterfaceMaestro sends a 
        signal to sessionData when the dialog closes (by setting the boolean dialogIsShowing to "NO".
        In the setter function, sessionData checks to see if there's anything stored in the
        savedConfigurationBlock, and updates it then. */
        savedConfigurationBlock = [dataStr retain];
    }
    else
    {/* Even if we don't reconfigure, there may be icons that we still need to download.  
        (This is also called at the end of the finishGetConfiguration method.) */
        [self downloadAnyIcons:iconsStillNeeded];
    }

    return nil;
}

#pragma mark user_management
- (BOOL)weShouldBeFirstResponder
{
 /* If we're authenticating with a provider for social publishing, then don't worry about the return experience for basic authentication. */
    if (socialSharing)
        return currentProvider.requiresInput;
    
 /* If we're authenticating with a basic provider, then we don't need to gather infomation if we're displaying return screen. */
    if ([currentProvider isEqualToReturningProvider:returningBasicProvider])
        return NO;
    
    return currentProvider.requiresInput;
}

- (JRAuthenticatedUser*)authenticatedUserForProvider:(JRProvider*)provider
{
    return [authenticatedUsersByProvider objectForKey:provider.name];
}

- (JRAuthenticatedUser*)authenticatedUserForProviderNamed:(NSString*)provider;
{
    return [authenticatedUsersByProvider objectForKey:provider];
}

- (void)forgetAuthenticatedUserForProvider:(NSString*)providerName
{
    DLog (@"");
    
 /* If you are explicitely signing out a user for a provider, you should explicitely force reauthentication. */
    JRProvider* provider = [allProviders objectForKey:providerName];
    provider.forceReauth = YES;
    
    [authenticatedUsersByProvider removeObjectForKey:providerName];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] 
                                              forKey:AUTHENTICATED_USERS_BY_PROVIDER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)forgetAllAuthenticatedUsers
{
    DLog (@"");
    
    for (NSString *providerName in [allProviders allKeys])
    {
        JRProvider *provider = [allProviders objectForKey:providerName];
        provider.forceReauth = YES;
    }
    
    [authenticatedUsersByProvider removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] 
                                              forKey:AUTHENTICATED_USERS_BY_PROVIDER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark provider_management
- (JRProvider*)getProviderAtIndex:(NSUInteger)index fromArray:(NSArray*)array
{
    if (index < [array count])
    {
        return [allProviders objectForKey:[array objectAtIndex:index]];
    }
    
    return nil;
}

- (JRProvider*)getBasicProviderAtIndex:(NSUInteger)index
{
    return [self getProviderAtIndex:index fromArray:[self basicProviders]];
}

- (JRProvider*)getSocialProviderAtIndex:(NSUInteger)index
{
    return [self getProviderAtIndex:index fromArray:[self socialProviders]];
}

- (JRProvider*)getProviderNamed:(NSString*)name
{
    return [allProviders objectForKey:name];
}

#pragma mark authentication 
- (void)saveLastUsedSocialProvider:(NSString*)providerName
{
	DLog (@"Saving last used social provider: %@", providerName);
    
    [returningSocialProvider release], returningSocialProvider = [providerName retain];
    
    [[NSUserDefaults standardUserDefaults] setObject:returningSocialProvider
                                              forKey:LAST_USED_SOCIAL_PROVIDER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveLastUsedBasicProvider:(NSString*)providerName
{
	DLog (@"Saving last used basic provider: %@", providerName);
    
    // TODO: See about re-adding cookie code that manually sets the last used provider and see 
    // if that means using rpx to log into site through Safari browser will also remember the user/provider
    
    NSHTTPCookieStorage *cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray *cookies = [cookieStore cookiesForURL:[NSURL URLWithString:baseUrl]];
    
	for (NSHTTPCookie *savedCookie in cookies) 
	{
		if ([savedCookie.name isEqualToString:@"welcome_info"])
		{
			[[self getProviderNamed:providerName] setWelcomeString:[self getWelcomeMessageFromCookieString:savedCookie.value]];
		}
	}	    
    
    [returningBasicProvider release], returningBasicProvider = [providerName retain];
    
    [[NSUserDefaults standardUserDefaults] setObject:returningBasicProvider
                                              forKey:LAST_USED_BASIC_PROVIDER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setReturningBasicProviderToNil;
{
    [returningBasicProvider release];
    returningBasicProvider = nil;
}

- (NSString*)getWelcomeMessageFromCookieString:(NSString*)cookieString
{
	DLog (@"");
	NSArray *strArr = [cookieString componentsSeparatedByString:@"%22"];
	
	if ([strArr count] <= 1)
		return @"Welcome, user!";
	
	return [[[NSString stringWithFormat:@"Sign in as %@?", (NSString*)[strArr objectAtIndex:5]] 
             stringByReplacingOccurrencesOfString:@"+" withString:@" "]
            stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)deleteFacebookCookies
{
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* facebookCookies = [cookies cookiesForURL:[NSURL URLWithString:@"http://login.facebook.com"]];
    
    for (NSHTTPCookie* cookie in facebookCookies) 
    {    
        [cookies deleteCookie:cookie];
    }
}

- (void)deleteLiveCookies
{
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* liveCookies = [cookies cookiesForURL:[NSURL URLWithString:@"http://live.com"]];
    
    for (NSHTTPCookie* cookie in liveCookies) 
    {    
        [cookies deleteCookie:cookie];
    }
}

- (NSURL*)startUrlForCurrentProvider
{
	NSMutableString *oid;
    
    if (!currentProvider)
        return nil;
    
	if (currentProvider.openIdentifier)
	{
		oid = [NSMutableString stringWithFormat:@"openid_identifier=%@&", currentProvider.openIdentifier];
		
		if(currentProvider.requiresInput)
			[oid replaceOccurrencesOfString:@"%@" 
								 withString:[currentProvider.userInput
											 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] 
									options:NSLiteralSearch 
									  range:NSMakeRange(0, [oid length])];
	}
	else
	{
		oid = [NSMutableString stringWithString:@""];
	}
    
    NSString *str = nil;
    
    if ([currentProvider.name isEqualToString:@"facebook"])
        if (alwaysForceReauth || currentProvider.forceReauth)
            [self deleteFacebookCookies];
    
    if ([currentProvider.name isEqualToString:@"live_id"])
        if (alwaysForceReauth || currentProvider.forceReauth)
            [self deleteLiveCookies];
    
    str = [NSString stringWithFormat:@"%@%@?%@%@device=%@&extended=true", 
           baseUrl, 
           currentProvider.url,
           oid, 
           ((alwaysForceReauth || currentProvider.forceReauth) ? @"force_reauth=true&" : @""),
           device];
    
	currentProvider.forceReauth = NO;
	
	ALog (@"Starting authentication for %@:\n%@", currentProvider.name, str);
	return [NSURL URLWithString:str];
}

#pragma mark sharing
- (void)startShareActivityForUser:(JRAuthenticatedUser*)user
{
    // TODO: Better error checking in sessionData's share activity bit
    NSDictionary *activityDictionary = [activity dictionaryForObject];
    
    DLog (@"activity dictionary: %@", [activityDictionary description]);
    
    NSString *activityContent = [[activityDictionary objectForKey:@"activity"] JSONRepresentation];                          
    NSString *deviceToken = user.device_token;
        
    NSMutableData* body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"device_token=%@", deviceToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&activity=%@", activityContent] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"&options={\"urlShortening\":\"true\"}"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&url_shortening=true"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&device=%@", device] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&provider=%@", currentProvider.name] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&app_name=%@", applicationBundleDisplayName()] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/api/v2/activity", serverUrl]]] retain];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
    NSDictionary* tag = [[NSDictionary alloc] initWithObjectsAndKeys:activity, @"activity", 
                         currentProvider.name, @"providerName", 
                         @"shareActivity", @"action", nil];
    
    ALog ("Sharing activity on %@:\n request=%@\nbody=%@", user.provider_name, [[request URL] absoluteString], 
          [NSString stringWithCString:body.bytes encoding:NSUTF8StringEncoding]);
    
    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
        [self triggerPublishingDidFailWithError:[JRError setError:@"There was a problem connecting to the Janrain server to share this activity"
                                                         withCode:JRPublishErrorBadConnection]]; 
    
    [request release];    
}

- (void)shareActivityForUser:(JRAuthenticatedUser*)user
{
    [self startShareActivityForUser:user];
}

- (void)finishShareActivity:(JRActivityObject*)_activity forProvider:(NSString*)providerName withResponse:(NSString*)response
{
    ALog (@"Activity sharing response: %@", response);
    
    NSDictionary *response_dict = [response JSONValue];
    
    if (!response_dict)
    {
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy) 
        {
            if ([delegate respondsToSelector:@selector(publishingActivity:didFailWithError:forProvider:)])
                [delegate publishingActivity:_activity
                            didFailWithError:[JRError setError:[response retain] 
                                                      withCode:JRPublishFailedError]
                                 forProvider:providerName];
        }
        return;
    }
    
    if ([[response_dict objectForKey:@"stat"] isEqualToString:@"ok"])
    {
        [self saveLastUsedSocialProvider:providerName];
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy) 
        {
            if ([delegate respondsToSelector:@selector(publishingActivityDidSucceed:forProvider:)])
                [delegate publishingActivityDidSucceed:_activity forProvider:providerName];
        }
    }
    else
    {
        NSDictionary *error_dict = [response_dict objectForKey:@"err"];
        NSError *publishError = nil;
        
        if (!error_dict)
        {
            publishError = [JRError setError:@"There was a problem publishing this activity" 
                                    withCode:JRPublishFailedError];
        }
        else 
        {
            int code;
            if (!CFNumberGetValue((void*)[error_dict objectForKey:@"code"], kCFNumberSInt32Type, &code))
                code = 1000;
            
            switch (code)
            {
                case 0: /* "Missing parameter: apiKey" */
                    publishError = [JRError setError:[error_dict objectForKey:@"msg"] 
                                            withCode:JRPublishErrorMissingApiKey];
                    break;
                case 4: /* "Facebook Error: Invalid OAuth 2.0 Access Token" */
                    publishError = [JRError setError:[error_dict objectForKey:@"msg"] 
                                            withCode:JRPublishErrorInvalidOauthToken];
                    break;
                case 100: // TODO LinkedIn character limit error
                    publishError = [JRError setError:[error_dict objectForKey:@"msg"] 
                                            withCode:JRPublishErrorLinkedInCharacterExceded];
                    break;
                case 6: // TODO Twitter duplicate error
                    publishError = [JRError setError:[error_dict objectForKey:@"msg"] 
                                            withCode:JRPublishErrorDuplicateTwitter];
                    break;
                case 1000: /* Extracting code failed; Fall through. */
                default: // TODO Other errors (find them)
                    publishError = [JRError setError:@"There was a problem publishing this activity" 
                                            withCode:JRPublishFailedError];
                    break;
            }
        }
        
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy) 
        {
            if ([delegate respondsToSelector:@selector(publishingActivity:didFailWithError:forProvider:)])
                [delegate publishingActivity:_activity
                            didFailWithError:publishError
                                 forProvider:providerName];
        }
    }
}

- (void)startRecordActivitySharedBy:(NSString*)method
{
    ALog (@"");
    NSMutableData* body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"device=%@", device] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&method=%@", method] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *urlString = [NSString stringWithFormat:
                           @"%@/social/record_activity?", 
                           baseUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
	NSString *tag = [NSString stringWithFormat:@"%@Success", method];
	
    [JRConnectionManager createConnectionFromRequest:request forDelegate:self returnFullResponse:NO withTag:[tag retain]];    
}

#pragma mark url_shortening
- (void)startGetShortenedUrlsForActivity:(JRActivityObject*)_activity
{
    DLog(@"");
    
    /* In case there's an error, we'll just set the activity's shortened url to the 
     * unshortened url for now, and update it only if we successfully shorten it. */
    _activity.shortenedUrl = _activity.url;

    /* If we haven't gotten the baseUrl back from the configuration yet, return, and get the shortented urls later */
    if (!baseUrl)
    {
        stillNeedToShortenUrls = YES;
        return;
    }
    
    NSMutableDictionary *urls = [NSMutableDictionary dictionaryWithCapacity:3];
    if (_activity.email.urls) [urls setObject:_activity.email.urls forKey:@"email"];
    if (_activity.sms.urls) [urls setObject:_activity.email.urls forKey:@"sms"];
    if (_activity.url) [urls setObject:[NSArray arrayWithObject:_activity.url] forKey:@"activity"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/openid/get_urls?urls=%@&app_name=%@&device=%@",
                           baseUrl, [[urls JSONRepresentation] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            [self appNameAndVersion], device];
    
    DLog (@"Getting shortened URLs: %@", urlString);
	
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	
    NSDictionary *tag = [[NSDictionary alloc] initWithObjectsAndKeys:_activity, @"activity", @"shortenUrls", @"action", nil];
    
	[JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag];    
}

- (void)finishGetShortenedUrlsForActivity:(JRActivityObject*)_activity withShortenedUrls:(NSString*)urls
{
    DLog ("Shortened Urls: %@", urls);
//    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    NSDictionary *dict = [urls JSONValue];
    
    if (!dict) 
        goto foo;
    
    if ([dict objectForKey:@"err"])
        goto foo;
    
    NSDictionary *emailUrls = [[dict objectForKey:@"urls"] objectForKey:@"email"];
    NSDictionary *smsUrls = [[dict objectForKey:@"urls"] objectForKey:@"sms"];
    NSDictionary *activityUrls = [[dict objectForKey:@"urls"] objectForKey:@"activity"];
    
    for (NSString *key in [emailUrls allKeys])
    {
        _activity.email.messageBody = [_activity.email.messageBody 
                                       stringByReplacingOccurrencesOfString:key 
                                       withString:[emailUrls objectForKey:key]];
    }
    
    for (NSString *key in [smsUrls allKeys])
    {
        _activity.sms.message = [_activity.sms.message 
                                 stringByReplacingOccurrencesOfString:key 
                                 withString:[smsUrls objectForKey:key]];
    }

    for (NSString *key in [activityUrls allKeys])
    {
        if ([key isEqualToString:activity.url])
            [_activity setShortenedUrl:[activityUrls objectForKey:key]];            
    }
    
foo:
    for (id<JRSessionDelegate> delegate in [NSArray arrayWithArray:delegates]) 
        if ([delegate respondsToSelector:@selector(urlShortenedToNewUrl:forActivity:)])
            [delegate urlShortenedToNewUrl:[_activity shortenedUrl] forActivity:_activity];
}

#pragma mark token_url
- (void)startMakeCallToTokenUrl:(NSString*)_tokenUrl withToken:(NSString *)token forProvider:(NSString*)providerName
{
    ALog (@"Calling token URL for %@:\n%@", providerName, _tokenUrl);
    
	NSMutableData* body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest* request = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_tokenUrl]] retain];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:body];
	
    NSDictionary* tag = [[NSDictionary dictionaryWithObjectsAndKeys:_tokenUrl, @"tokenUrl", 
                                                                    providerName, @"providerName", 
                                                                    @"callTokenUrl", @"action", nil] retain];
    
	if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self returnFullResponse:YES withTag:tag])
	{
        NSError *_error = [JRError setError:@"Problem initializing the connection to the token url"
                                   withCode:JRAuthenticationFailedError];
        
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy) 
        {
            if ([delegate respondsToSelector:@selector(authenticationCallToTokenUrl:didFailWithError:forProvider:)])
                [delegate authenticationCallToTokenUrl:_tokenUrl didFailWithError:_error forProvider:providerName];
        }
	}
	
	[request release];
}

- (void)finishMakeCallToTokenUrl:(NSString*)_tokenUrl withResponse:(NSURLResponse*)fullResponse 
                      andPayload:(NSData*)payload forProvider:(NSString*)providerName
{
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {   
        if ([delegate respondsToSelector:@selector(authenticationDidReachTokenUrl:withResponse:andPayload:forProvider:)])
            [delegate authenticationDidReachTokenUrl:_tokenUrl 
                                        withResponse:fullResponse
                                          andPayload:payload 
                                         forProvider:providerName];
    }
}

#pragma mark connection_manager_delegate_protocol
- (void)connectionDidFinishLoadingWithFullResponse:(NSURLResponse*)fullResponse unencodedPayload:(NSData*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
    NSObject *tag = (NSObject*)userdata;

    NSDictionary *headers = nil;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)fullResponse;
    if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) 
        headers = [httpResponse allHeaderFields];
    
    // QTS: We don't need to do this, do we??? >:-/
    [payload retain];
    
    if ([tag isKindOfClass:[NSDictionary class]])
    {
        NSString *action = [(NSDictionary*)tag objectForKey:@"action"];
        //DLog (@"Connect did finish loading: %@", action);
        
        if ([action isEqualToString:@"callTokenUrl"])
        {
            [self finishMakeCallToTokenUrl:[(NSDictionary*)tag objectForKey:@"tokenUrl"]
                              withResponse:fullResponse 
                                andPayload:payload 
                               forProvider:[(NSDictionary*)tag objectForKey:@"providerName"]];
        }
        if ([action isEqualToString:@"downloadPicture"])
        {
            // TODO: Later, make this more dynamic, and not fixed to just pngs.
            if ([[fullResponse MIMEType] isEqualToString:@"image/png"])
                [self finishDownloadPicture:payload 
                                      named:[(NSDictionary*)tag objectForKey:@"pictureName"]
                                forProvider:[(NSDictionary*)tag objectForKey:@"providerName"]];
            else
                ALog ("Not able to download the picture: %@", [[request URL] absoluteString]);
        }
    }
    else if ([tag isKindOfClass:[NSString class]])
    {   	
        //DLog (@"Connect did finish loading: %@", tag);
        
        if ([(NSString*)tag isEqualToString:@"getConfiguration"])
        {
            NSString *payloadString = [[[NSString alloc] initWithData:payload encoding:NSASCIIStringEncoding] autorelease];
            
            if ([payloadString rangeOfString:@"\"provider_info\":{"].length != 0)
            {
                error = [[self finishGetConfiguration:payloadString 
                                             withEtag:[headers objectForKey:@"Etag"]] retain];
            }
            else // There was an error...
            {
                error = [[JRError setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                                  withCode:JRConfigurationInformationError] retain];
            }
        }
    }
    
	[payload release];
	[tag release];	
}

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
    NSObject* tag = (NSObject*)userdata;
    
	[payload retain];
	
    if ([tag isKindOfClass:[NSDictionary class]])
    {   	
        NSString *action = [(NSDictionary*)tag objectForKey:@"action"];
        DLog (@"Connect did finish loading: %@", action);
        
        if ([action isEqualToString:@"shareActivity"])
        {
            [self finishShareActivity:[(NSDictionary*)tag objectForKey:@"activity"] 
                          forProvider:[(NSDictionary*)tag objectForKey:@"providerName"] 
                         withResponse:payload];
        }
        else if ([action isEqualToString:@"shortenUrls"])
        {
            [self finishGetShortenedUrlsForActivity:[(NSDictionary*)tag objectForKey:@"activity"] 
                                  withShortenedUrls:payload];            
        }
    }
    else if ([tag isKindOfClass:[NSString class]])
    {
        DLog (@"Connect did finish loading: %@", tag);
        DLog (@"Response: %@", payload);
        if ([(NSString*)tag isEqualToString:@"emailSuccess"])
        {
            // Do nothing for now...
        }
        else if ([(NSString*)tag isEqualToString:@"smsSuccess"])
        {
            // Do nothing for now...
        }
        else
        {
            // Do nothing for now...
        }
    }
    
	[payload release];
	[tag release];	
}

- (void)connectionDidFailWithError:(NSError*)_error request:(NSURLRequest*)request andTag:(void*)userdata 
{
    NSObject* tag = (NSObject*)userdata;
    
    if ([tag isKindOfClass:[NSString class]])
    {   
        ALog (@"Connection for %@ failed with error: %@", tag, [_error localizedDescription]);

        if ([(NSString*)tag isEqualToString:@"getConfiguration"])
        {
            error = [[JRError setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                              withCode:JRConfigurationInformationError] retain];
        }   
        else if ([(NSString*)tag isEqualToString:@"emailSuccess"])
        {
            // Do nothing for now...
        }
        else if ([(NSString*)tag isEqualToString:@"smsSuccess"])
        {
            // Do nothing for now...
        }
        else
        {
            // Do nothing for now...
        }
    }
    else if ([(NSDictionary*)tag isKindOfClass:[NSDictionary class]])
    {
        NSString *action = [(NSDictionary*)tag objectForKey:@"action"];
        ALog (@"Connection for %@ failed with error: %@", action, [error localizedDescription]);

        if ([action isEqualToString:@"callTokenUrl"])
        {
            NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
            for (id<JRSessionDelegate> delegate in delegatesCopy) 
            {
                if ([delegate respondsToSelector:@selector(authenticationCallToTokenUrl:didFailWithError:forProvider:)])
                    [delegate authenticationCallToTokenUrl:[(NSDictionary*)tag objectForKey:@"tokenUrl"] 
                                          didFailWithError:_error 
                                               forProvider:[(NSDictionary*)tag objectForKey:@"providerName"]];
            }
        }
        else if ([action isEqualToString:@"shareActivity"])
        {
            NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
            for (id<JRSessionDelegate> delegate in delegatesCopy) 
            {
                if ([delegate respondsToSelector:@selector(publishingActivity:didFailWithError:forProvider:)])
                    [delegate publishingActivity:activity
                                didFailWithError:_error
                                     forProvider:currentProvider.name];
                
            }          
        }
        else if ([action isEqualToString:@"shortenUrls"])
        {
            /* Call with _activity.shortenedUrl (as opposed to newShortened) in case there was an error, as
             * _activity.shortenedUrl was previously set to fall back to the full url. */
            NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
            for (id<JRSessionDelegate> delegate in delegatesCopy) 
                if ([delegate respondsToSelector:@selector(urlShortenedToNewUrl:forActivity:)])
                    [delegate urlShortenedToNewUrl:((JRActivityObject*)[(NSDictionary*)tag objectForKey:@"activity"]).shortenedUrl 
                                       forActivity:((JRActivityObject*)[(NSDictionary*)tag objectForKey:@"activity"])];
        }
        else
        {
            // Do nothing for now...
        }
    }
    
	[tag release];	
}

- (void)connectionWasStoppedWithTag:(void*)userdata 
{
    DLog (@"Connection was stopped.");
    
    if ([(NSObject*)userdata isKindOfClass:[NSString class]])
        [(NSString*)userdata release];
    if ([(NSObject*)userdata isKindOfClass:[NSDictionary class]])
        [(NSDictionary*)userdata release];
}

#pragma mark delegate_management
- (void)addDelegate:(id<JRSessionDelegate>)_delegate
{
    if (_delegate)
        [delegates addObject:_delegate];
}

- (void)removeDelegate:(id<JRSessionDelegate>)_delegate
{
    [delegates removeObject:_delegate];
}

#pragma mark trigger_methods
- (void)triggerAuthenticationDidCompleteWithPayload:(NSDictionary*)payloadDict
{      
 /* This value will be nil if authentication was canceled after the user authenticated in the
    webview, but before the authentication call was completed, like in the case where the calling
    application issues the cancelAuthentication command. */
    if (!currentProvider)
        return;
    
    // TODO: TEST THIS!!!
    NSDictionary *goodies = [payloadDict objectForKey:@"rpx_result"];
    NSString *token = [goodies objectForKey:@"token"];
    NSMutableDictionary *auth_info = [NSMutableDictionary dictionaryWithDictionary:[goodies objectForKey:@"auth_info"]];
    
    [auth_info setObject:token forKey:@"token"];
    
    DLog (@"Authentication completed for user: %@", [goodies description]);

    JRAuthenticatedUser *user = [[[JRAuthenticatedUser alloc] initUserWithDictionary:goodies
                                                                    forProviderNamed:currentProvider.name] autorelease];    
    
    [authenticatedUsersByProvider setObject:user forKey:currentProvider.name];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] 
                                              forKey:AUTHENTICATED_USERS_BY_PROVIDER];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([[self basicProviders] containsObject:currentProvider.name] && !socialSharing)
        [self saveLastUsedBasicProvider:currentProvider.name];
    
    if ([[self socialProviders] containsObject:currentProvider.name])
        [self saveLastUsedSocialProvider:currentProvider.name];
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(authenticationDidCompleteForUser:forProvider:)])
            [delegate authenticationDidCompleteForUser:auth_info forProvider:currentProvider.name];
    }

	if (tokenUrl)
        [self startMakeCallToTokenUrl:tokenUrl withToken:token forProvider:currentProvider.name];
    
    [currentProvider release];
    currentProvider = nil;
}

- (void)triggerAuthenticationDidFailWithError:(NSError*)_error
{
    [currentProvider release];
    currentProvider = nil;
    
    [returningBasicProvider release];
    returningBasicProvider = nil;
    
    [returningSocialProvider release];
    returningSocialProvider = nil;
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(authenticationDidFailWithError:forProvider:)])
            [delegate authenticationDidFailWithError:_error forProvider:currentProvider.name];
    }
}

- (void)triggerAuthenticationDidCancel
{
    DLog (@"");
    [currentProvider release];
    currentProvider = nil;
    
//    [returningBasicProvider release];
//    returningBasicProvider = nil;
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(authenticationDidCancel)])
            [delegate authenticationDidCancel];
    }
}

- (void)triggerAuthenticationDidCancel:(id)sender
{
    [self triggerAuthenticationDidCancel];
}

- (void)triggerAuthenticationDidTimeOutConfiguration
{
    DLog (@"");
    [currentProvider release];
    currentProvider = nil;
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(authenticationDidCancel)])
            [delegate authenticationDidCancel];
    }
}

- (void)triggerAuthenticationDidStartOver:(id)sender
{
    DLog (@"");
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(authenticationDidRestart)])
            [delegate authenticationDidRestart];
    }
}

- (void)triggerPublishingDidCancel
{
    DLog (@"");
    [currentProvider release];
    currentProvider = nil;
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(publishingDidCancel)])
            [delegate publishingDidCancel];
    }
    
    socialSharing = NO;
}

- (void)triggerPublishingDidCancel:(id)sender
{
    [self triggerPublishingDidCancel];
}

- (void)triggerPublishingDidTimeOutConfiguration
{
    DLog (@"");
   [currentProvider release];
    currentProvider = nil;
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(publishingDidCancel)])
            [delegate publishingDidCancel];
    }
    
    socialSharing = NO;
}

- (void)triggerPublishingDidComplete
{
    [currentProvider release];
    currentProvider = nil;
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(publishingDidComplete)])
            [delegate publishingDidComplete];
    }
    
    socialSharing = NO;    
}

- (void)triggerPublishingDidComplete:(id)sender
{
    [self triggerPublishingDidComplete];
}

- (void)triggerPublishingDidFailWithError:(NSError*)_error
{
    // QTS: When will this ever be called and what do we do when it happens?
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(publishingActivity:didFailWithError:forProvider:)])
            [delegate publishingActivity:activity didFailWithError:_error forProvider:currentProvider.name];
    }
}

- (void)triggerPublishingDidStartOver:(id)sender
{    
    DLog (@"");
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(publishingDidRestart)])
            [delegate publishingDidRestart];
    }
}

- (void)triggerEmailSharingDidComplete
{
    DLog (@"");
    [self startRecordActivitySharedBy:@"email"];
}

- (void)triggerSmsSharingDidComplete
{
    DLog (@"");
    [self startRecordActivitySharedBy:@"sms"];
}
@end
