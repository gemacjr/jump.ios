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


// TODO: Figure out why the -DDEBUG cflag isn't being set when Active Conf is set to debug
#define DEBUG
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

//#define STAGING
//#define LOCAL
#ifdef STAGING
static NSString * const serverUrl = @"https://rpxstaging.com";
#else
#ifdef LOCAL 
static NSString * const serverUrl = @"http://lillialexis.janrain.com:8080";
#else
static NSString * const serverUrl = @"https://rpxnow.com";
#endif
#endif

/* Added a category to NSString including a function to correctly escape any arguments sent to any of the 
   Engage API calls */
@interface NSString (NSString_URL_ESCAPING)
- (NSString*)URLEscaped;
@end

// TODO: Test for all characters that might blow up the publish_activity api call
@implementation NSString (NSString_URL_ESCAPING)
- (NSString*)URLEscaped
{
    NSString *str = [self stringByReplacingOccurrencesOfString:@"/" withString:@"%2f"];
    str = [str stringByReplacingOccurrencesOfString:@":" withString:@"%3a"];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"%34"];
    str = [str stringByReplacingOccurrencesOfString:@"&" withString:@"%38"];
    
    return str;
}
@end

NSString* displayNameAndIdentifier()
{
//    return @"foobar";
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [infoPlist objectForKey:@"CFBundleDisplayName"];// stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] URLEscaped];
    NSString *ident = [infoPlist objectForKey:@"CFBundleIdentifier"];// stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] URLEscaped];
    
    return [NSString stringWithFormat:@"%@.%@", name, ident];
}



#import "SFHFKeychainUtils.h"

@implementation JRAuthenticatedUser
@synthesize photo;
@synthesize preferred_username;
@synthesize device_token;
@synthesize auth_info;
@synthesize provider_name;

- (id)initUserWithDictionary:(NSDictionary*)dictionary forProviderNamed:(NSString*)_provider_name
{
	DLog(@"");
  
    // QTS: How do I check this without getting the warning??
    if (dictionary == nil || _provider_name == nil || [dictionary objectForKey:@"device_token"] == (CFStringRef*)kCFNull)
	{
		[self release];
		return nil;
	}
	
	if (self = [super init]) 
	{
        provider_name = [_provider_name retain];
        
        if ([dictionary objectForKey:@"photo"] != kCFNull)
            photo = [[dictionary objectForKey:@"photo"] retain];

        if ([dictionary objectForKey:@"preferred_username"] != kCFNull)
            preferred_username = [[dictionary objectForKey:@"preferred_username"] retain];
        
//        auth_info = [[dictionary objectForKey:@"auth_info"] retain];
        
        device_token = [[dictionary objectForKey:@"device_token"] retain];
    }

	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	DLog(@"encoding: %@", provider_name);
   
    [coder encodeObject:provider_name forKey:@"provider_name"];
    [coder encodeObject:photo forKey:@"photo"];
    [coder encodeObject:preferred_username forKey:@"preferred_username"];
    [coder encodeObject:nil forKey:@"device_token"];

//    [coder encodeObject:device_token forKey:@"device_token"];
//    [coder encodeObject:auth_info forKey:@"auth_info"];

    NSError *error = nil;
    [SFHFKeychainUtils storeUsername:provider_name 
                         andPassword:device_token 
                      forServiceName:[NSString stringWithFormat:@"device_tokens.janrain.%@.", displayNameAndIdentifier()] 
                      updateExisting:YES 
                               error:&error];

    // TODO: Handle Keychain storage error
    if (error)
        DLog (@"Error storing device token in keychain: %@", [error localizedDescription]);
}

- (id)initWithCoder:(NSCoder *)coder
{
	self = [[JRAuthenticatedUser alloc] init];
    if (self != nil)
    {
        provider_name = [[coder decodeObjectForKey:@"provider_name"] retain];
    
        DLog(@"decoding: %@", provider_name);
        
        photo = [[coder decodeObjectForKey:@"photo"] retain];
        preferred_username = [[coder decodeObjectForKey:@"preferred_username"] retain];

        NSError *error = nil;
        device_token = [[SFHFKeychainUtils getPasswordForUsername:provider_name
                                                   andServiceName:[NSString stringWithFormat:@"device_tokens.janrain.%@.", displayNameAndIdentifier()] 
                                                            error:&error] retain];
        
        if (error)
            DLog (@"Error retrieving device token in keychain: %@", [error localizedDescription]);
        
        if (!device_token)
            device_token = [[coder decodeObjectForKey:@"device_token"] retain];
        
        
//        device_token = [[coder decodeObjectForKey:@"device_token"] retain];
//        auth_info = [[coder decodeObjectForKey:@"auth_info"] retain];
    }   

    return self;
}

- (void)removeDeviceTokenFromKeychain
{
    NSError *error = nil;
    [SFHFKeychainUtils deleteItemForUsername:provider_name
                              andServiceName:[NSString stringWithFormat:@"device_tokens.janrain.%@.", displayNameAndIdentifier()] 
                                       error:&error];
    if (error)
        DLog (@"Error deleting device token from keychain: %@", [error localizedDescription]);
    
}

- (void)dealloc
{
    [provider_name release];
    [photo release];
    [preferred_username release];
    [device_token release];
    [auth_info release];
    
    [super dealloc];
}
@end

@interface JRProvider ()
@property (readonly) NSString *openIdentifier;
@property (readonly) NSString *url;
@end

@implementation JRProvider
@synthesize name;
@synthesize friendlyName;
@synthesize placeholderText;
@synthesize openIdentifier;
@synthesize url;
@synthesize requiresInput;
@synthesize shortText;
@synthesize socialPublishingProperties;
@synthesize extPerm;

- (void)loadDynamicVariables
{
    userInput     = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"jr%@UserInput", name]];
    welcomeString = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"jr%@WelcomeString", name]];
    forceReauth   = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"jr%@ForceReauth", name]];
}

- (JRProvider*)initWithName:(NSString*)_name andDictionary:(NSDictionary*)_dictionary
{
	DLog(@"");
	
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
        extPerm = [[_dictionary objectForKey:@"extended_permissions"] retain];

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
        
        socialPublishingProperties = [[_dictionary objectForKey:@"social_sharing_properties"] retain];
        
        [self loadDynamicVariables];
    }
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	DLog(@"");
    
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:friendlyName forKey:@"friendlyName"];
    [coder encodeObject:placeholderText forKey:@"placeholderText"];
    [coder encodeObject:shortText forKey:@"shortText"];
    [coder encodeObject:openIdentifier forKey:@"openIdentifier"];
    [coder encodeObject:url forKey:@"url"];
    [coder encodeObject:extPerm forKey:@"extPerm"];
    [coder encodeBool:requiresInput forKey:@"requiresInput"];    
    [coder encodeObject:socialPublishingProperties forKey:@"socialPublishingProperties"];
}

- (id)initWithCoder:(NSCoder *)coder
{
	DLog(@"");

    self = [[JRProvider alloc] init];
    if (self != nil)
    {
        name =            [[coder decodeObjectForKey:@"name"] retain];
        friendlyName =    [[coder decodeObjectForKey:@"friendlyName"] retain];
        placeholderText = [[coder decodeObjectForKey:@"placeholderText"] retain];
        shortText =       [[coder decodeObjectForKey:@"shortText"] retain];
        openIdentifier =  [[coder decodeObjectForKey:@"openIdentifier"] retain];
        url =             [[coder decodeObjectForKey:@"url"] retain];
        extPerm =         [[coder decodeObjectForKey:@"extPerm"] retain];
        requiresInput =    [coder decodeBoolForKey:@"requiresInput"];
        socialPublishingProperties = [[coder decodeObjectForKey:@"socialPublishingProperties"] retain];
    }   
    
    [self loadDynamicVariables];
    
    return self;
}

- (BOOL)isEqualToProvider:(JRProvider*)provider
{
  	DLog(@"");

    if ([self.name isEqualToString:provider.name])
        return YES;
    
    return NO;
}

- (BOOL)isEqualToReturningProvider:(NSString*)returningProvider
{
  	DLog(@"");
    
    if ([self.name isEqualToString:returningProvider])
        return YES;
    
    return NO;
}

- (NSString*)welcomeString
{
    return welcomeString;
}

- (void)setWelcomeString:(NSString *)_welcomeString
{
    welcomeString = _welcomeString;
    
    [[NSUserDefaults standardUserDefaults] setValue:welcomeString forKey:[NSString stringWithFormat:@"jr%@WelcomeString", self.name]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)userInput
{
    return userInput;
}

- (void)setUserInput:(NSString *)_userInput
{
    userInput = _userInput;
    
    [[NSUserDefaults standardUserDefaults] setValue:userInput forKey:[NSString stringWithFormat:@"jr%@UserInput", self.name]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)forceReauth
{
    return forceReauth;
}

- (void)setForceReauth:(BOOL)_forceReauth
{
    forceReauth = _forceReauth;
    
    [[NSUserDefaults standardUserDefaults] setBool:forceReauth forKey:[NSString stringWithFormat:@"jr%@ForceReauth", self.name]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc
{
	DLog(@"");
		
    [name release];
    [friendlyName release];
    [placeholderText release];
    [shortText release];
    [openIdentifier release];
    [url release];	
    [userInput release];
    [welcomeString release];
    [extPerm release];
    [socialPublishingProperties release];
    
	[super dealloc];
}
@end

@interface JRSessionData()
- (NSError*)startGetConfiguration;
- (NSError*)finishGetConfiguration:(NSString *)dataStr;
- (void)startGetShortenedUrlsForActivity:(JRActivityObject *)_activity;
- (void)loadLastUsedBasicProvider;
- (void)loadLastUsedSocialProvider;
@end

@implementation JRSessionData
@synthesize currentProvider;
@synthesize returningBasicProvider;
@synthesize returningSocialProvider;
@synthesize tokenUrl;
@synthesize alwaysForceReauth;
@synthesize forceReauth;
@synthesize social;
@synthesize error;

static JRSessionData* singleton = nil;
+ (JRSessionData*)jrSessionData
{
	return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self jrSessionData] retain];
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
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

// QTS: Do we need these?
// ATS: We might need to add logic to these getters that prevent the view controllers
// from calling the cached lists before or during updates. Leave them for now.
- (NSString*)baseUrl
{
    return baseUrl;
}

- (NSDictionary*)allProviders
{
    DLog(@"");
    return allProviders;
}

- (NSArray*)basicProviders
{
    DLog(@"");
    return basicProviders;
}

- (NSArray*)socialProviders
{
    DLog(@"");
    return socialProviders;
}

- (NSString*)returningBasicProvider
{
    if (alwaysForceReauth)
        return nil;
    
    return returningBasicProvider;
}

- (BOOL)hidePoweredBy
{
    DLog(@"");
    return hidePoweredBy;
}

- (BOOL)dialogIsShowing
{
    return dialogIsShowing;
}

- (void)setDialogIsShowing:(BOOL)isShowing
{/* If we found out that the configuration changed while a dialog was showing, we saved it until the dialog wasn't showing
    since the dialogs dynamically load our data. Now that the dialog isn't showing, load the saved configuration information. */
    if (!isShowing && savedConfigurationBlock)
        error = [self finishGetConfiguration:savedConfigurationBlock];

    dialogIsShowing = isShowing;
}

- (void)setActivity:(JRActivityObject *)_activity
{
    activity = [_activity retain];

    if (!activity)
        return;
    
    [self startGetShortenedUrlsForActivity:activity];
}

- (JRActivityObject*)activity
{
    return activity;
}

- (id)initWithAppId:(NSString*)_appId tokenUrl:(NSString*)_tokenUrl andDelegate:(id<JRSessionDelegate>)_delegate
{
	DLog(@"");

	if (self = [super init]) 
	{
        singleton = self;
        
        delegates = [[NSMutableArray alloc] initWithObjects:[_delegate retain], nil];
		appId = _appId;
        tokenUrl = _tokenUrl;
        
        // TODO: Uncomment when ready
        if (0)//(UI_USER_INTERFACE_IDIOM == UIUserInterfaceIdiomPad)
            device = @"ipad";
        else
            device = @"iphone";

        
        /* First, we load all of the cached data (the list of providers, saved users, base url, etc.) */
        
        /* Load the dictionary of authenticated users */
        NSData *archivedUsers = [[NSUserDefaults standardUserDefaults] objectForKey:@"jrAuthenticatedUsersByProvider"];
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
        NSData *archivedProviders = [[NSUserDefaults standardUserDefaults] objectForKey:@"jrAllProviders"];
        if (archivedProviders != nil)
        {
            NSDictionary *unarchivedProviders = [NSKeyedUnarchiver unarchiveObjectWithData:archivedProviders];
            if (unarchivedProviders != nil)
                allProviders = [[NSMutableDictionary alloc] initWithDictionary:unarchivedProviders];
        }
        
        /* Load the list of basic providers */
        NSData *archivedBasicProviders = [[NSUserDefaults standardUserDefaults] objectForKey:@"jrBasicProviders"];
        if (archivedBasicProviders != nil)
        {
            basicProviders = [[NSKeyedUnarchiver unarchiveObjectWithData:archivedBasicProviders] retain];
        }
        
        /* Load the list of social providers */
        NSData *archivedSocialProviders = [[NSUserDefaults standardUserDefaults] objectForKey:@"jrSocialProviders"];
        if (archivedSocialProviders != nil)
        {
            //[[NSArray alloc] initWithObjects:@"yahoo", nil];//
            socialProviders = [[NSKeyedUnarchiver unarchiveObjectWithData:archivedSocialProviders] retain];
        }

        /* Load the base url and whether or not we need to hide the tagline */
        baseUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"jrBaseUrl"];
        hidePoweredBy = [[NSUserDefaults standardUserDefaults] boolForKey:@"jrHidePoweredBy"];
                
        [self loadLastUsedBasicProvider];
        [self loadLastUsedSocialProvider];
                
        /* As this information may have changed, we're going to ask rpx for this information anyway */
        error = [self startGetConfiguration];
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
    DLog(@"");
    [error release];
    error = nil;
    
    error = [self startGetConfiguration];
}

- (void)addDelegate:(id<JRSessionDelegate>)_delegate
{
	DLog(@"");
    [delegates addObject:_delegate];
}

- (void)removeDelegate:(id<JRSessionDelegate>)_delegate
{
	DLog(@"");
    [delegates removeObject:_delegate];
}

- (NSError*)setError:(NSString*)message withCode:(NSInteger)code andType:(NSString*)type
{
    DLog(@"");
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              message, NSLocalizedDescriptionKey,
                              type, @"type", nil];
    
    return [[NSError alloc] initWithDomain:@"JREngage"
                                      code:code
                                  userInfo:userInfo];
}

- (NSString*)appNameAndVersion
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [[[infoPlist objectForKey:@"CFBundleDisplayName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] URLEscaped];
    NSString *ident = [[[infoPlist objectForKey:@"CFBundleIdentifier"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] URLEscaped];
    
    infoPlist = [NSDictionary dictionaryWithContentsOfFile: 
                 [[[NSBundle mainBundle] resourcePath] 
                  stringByAppendingPathComponent:@"/JREngage-Info.plist"]];
    
    NSString *version = [[[infoPlist objectForKey:@"CFBundleShortVersionString"] 
                          stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] URLEscaped];
    
    return [NSString stringWithFormat:@"&appName=%@.%@&version=%@_%@", name, ident, device, version];
}

- (NSError*)startGetConfiguration
{	
    DLog(@"");
    
    NSString *nameAndVersion = [self appNameAndVersion];
	NSString *urlString = [NSString stringWithFormat:
                           @"%@/openid/%@_config_and_baseurl?appId=%@&skipXdReceiver=true%@", 
                           serverUrl, device, appId, nameAndVersion];
    
    DLog(@"url: %@", urlString);
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	if(!url)
		return [self setError:@"There was a problem connecting to the Janrain server while configuring authentication." 
                     withCode:JRUrlError 
                      andType:JRErrorTypeConfigurationFailed];
    
	NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url] autorelease];
	
	NSString *tag = [[NSString alloc] initWithFormat:@"getConfiguration"];
	
	if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self returnFullResponse:YES withTag:tag])
		return [self setError:@"There was a problem connecting to the Janrain server while configuring authentication." 
                     withCode:JRUrlError 
                      andType:JRErrorTypeConfigurationFailed];
    
    return nil;
}

- (NSError*)finishGetConfiguration:(NSString*)dataStr
{
    DLog(@"");
    
    /* Make sure that the returned string can be parsed as json (which there should be no reason that this wouldn't happen) */
    if (![dataStr respondsToSelector:@selector(JSONValue)])
        return [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                     withCode:JRJsonError
                      andType:JRErrorTypeConfigurationFailed];
    
    NSDictionary *jsonDict = [dataStr JSONValue];
    
    /* Double-check the return value */
    if(!jsonDict)
        return [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                     withCode:JRJsonError
                      andType:JRErrorTypeConfigurationFailed];
    
    
    /* If the baseUrl has changed, get the new baseUrl */
    if (![[jsonDict objectForKey:@"baseurl"] isEqualToString:baseUrl])
        baseUrl = [[[jsonDict objectForKey:@"baseurl"] 
                    stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]] retain];
    
    /* Then save it */
    [[NSUserDefaults standardUserDefaults] setValue:baseUrl forKey:@"jrBaseUrl"];
    
    /* Get the providers out of the provider_info section.  These are most likely to have changed. */
    NSDictionary *providerInfo   = [NSDictionary dictionaryWithDictionary:[jsonDict objectForKey:@"provider_info"]];
    allProviders = [[NSMutableDictionary alloc] initWithCapacity:[[providerInfo allKeys] count]];
    
    /* For each provider... */
    for (NSString *name in [providerInfo allKeys])
    {   /* Get its dictionary, */
            NSDictionary *dictionary = [providerInfo objectForKey:name];
        
        /* use this to create a provider object, */
        JRProvider *provider = [[[JRProvider alloc] initWithName:name
                                                   andDictionary:dictionary] autorelease];
        
        /* and finally add the object to our dictionary of providers. */
        [allProviders setObject:provider forKey:name];
    }
    
    /* Get the ordered list of basic providers */
    basicProviders = [[NSArray arrayWithArray:[jsonDict objectForKey:@"enabled_providers"]] retain];
    
    /* Get the ordered list of social providers */
    socialProviders = [[NSArray arrayWithArray:[jsonDict objectForKey:@"social_providers"]] retain];
    
    /* yippie, yahoo! */
    
    /* Then save our stuff */
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:allProviders] 
                                              forKey:@"jrAllProviders"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:basicProviders] 
                                              forKey:@"jrBasicProviders"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:socialProviders] 
                                              forKey:@"jrSocialProviders"];
    
    /* Figure out if we need to hide the tag line */
    if ([[jsonDict objectForKey:@"hide_tagline"] isEqualToString:@"YES"])
        hidePoweredBy = YES;
    else
        hidePoweredBy = NO;
    
    /* And finally, save that too */
    [[NSUserDefaults standardUserDefaults] setBool:hidePoweredBy forKey:@"jrHidePoweredBy"];
    
    /* Once we know that everything is parsed and saved correctly, save the new etag */
    [[NSUserDefaults standardUserDefaults] setValue:newEtag forKey:@"jrConfigurationEtag"];
    
    [[NSUserDefaults standardUserDefaults] setValue:gitCommit forKey:@"jrEngageCommit"];
   
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /* The release our saved configuration information */
    [savedConfigurationBlock release];
    [newEtag release];
    
    savedConfigurationBlock = nil;
    newEtag = nil;
    
    return nil;
}

- (NSError*)finishGetConfiguration:(NSString*)dataStr withEtag:(NSString*)etag
{
	DLog(@"");
    
    
    NSDictionary *infoPlist = [NSDictionary dictionaryWithContentsOfFile: 
                               [[[NSBundle mainBundle] resourcePath] 
                                stringByAppendingPathComponent:@"/JREngage-Info.plist"]];
    
    NSString *currentCommit = [infoPlist objectForKey:@"Git Commit"];
    NSString *savedCommit = [[NSUserDefaults standardUserDefaults] stringForKey:@"jrEngageCommit"];
    
    NSString *oldEtag = [[NSUserDefaults standardUserDefaults] stringForKey:@"jrConfigurationEtag"];
    
 /* If the configuration for this rp has changed, the etag will have changed, and we need to update 
    our current configuration information. */
    if (![oldEtag isEqualToString:etag] || ![currentCommit isEqualToString:savedCommit]) 
    {
        newEtag = [etag retain];
        gitCommit = [currentCommit retain];
    
     /* We can only update all of our data if the UI isn't currently using that information.  Otherwise, 
        the library may crash/behave inconsistently.  If a dialog isn't showing, go ahead and update
        that information.  Or, in the case where a dialog is showing but there isn't any data that it could
        be using (that is, the lists of basic and social providers are nil), go ahead and update it too.
        The dialogs won't try and do anything until we're done updating the lists. */
        if (!dialogIsShowing || (!basicProviders && !socialProviders))
            return [self finishGetConfiguration:dataStr];
        
     /* Otherwise, we have to save all this information for later.  The UserInterfaceMaestro sends a 
        signal to sessionData when the dialog closes (by setting the boolean dialogIsShowing to "NO".
        In the setter function, sessionData checks to see if there's anything stored in the
        savedConfigurationBlock, and updates it then. */
        savedConfigurationBlock = [dataStr retain];
    }
    
    return nil;
}

- (NSString*)getWelcomeMessageFromCookieString:(NSString*)cookieString
{
	DLog(@"");
	NSArray *strArr = [cookieString componentsSeparatedByString:@"%22"];
	
	if ([strArr count] <= 1)
		return @"Welcome, user!";
	
	return [[[NSString stringWithFormat:@"Sign in as %@?", (NSString*)[strArr objectAtIndex:5]] 
              stringByReplacingOccurrencesOfString:@"+" withString:@" "]
              stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)loadLastUsedSocialProvider
{
	DLog(@"");

    returningSocialProvider = [[[NSUserDefaults standardUserDefaults] stringForKey:@"jrLastUsedSocialProvider"] retain];
}

- (void)loadLastUsedBasicProvider
{
    DLog(@"");

    returningBasicProvider = [[[NSUserDefaults standardUserDefaults] stringForKey:@"jrLastUsedBasicProvider"] retain];
}

- (void)saveLastUsedSocialProvider
{
	DLog(@"");
    
    [returningSocialProvider release], returningSocialProvider = [currentProvider.name retain];

    [[NSUserDefaults standardUserDefaults] setObject:returningSocialProvider
                                              forKey:@"jrLastUsedSocialProvider"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveLastUsedBasicProvider
{
    DLog(@"");

    // TODO: See about re-adding cookie code that manually sets the last used provider and see 
    // if that means using rpx to log into site through Safari browser will also remember the user/provider
    
    NSHTTPCookieStorage *cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray *cookies = [cookieStore cookiesForURL:[NSURL URLWithString:baseUrl]];
	    
	for (NSHTTPCookie *savedCookie in cookies) 
	{
		if ([savedCookie.name isEqualToString:@"welcome_info"])
		{
			[currentProvider setWelcomeString:[self getWelcomeMessageFromCookieString:savedCookie.value]];
		}
	}	    
    
    [returningBasicProvider release], returningBasicProvider = [currentProvider.name retain];

    [[NSUserDefaults standardUserDefaults] setObject:returningBasicProvider
                                              forKey:@"jrLastUsedBasicProvider"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
	DLog(@"");
    
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
    
#define SOCIAL_PUBLISHING
#ifdef SOCIAL_PUBLISHING
//    if (social)
//        str = [NSString stringWithFormat:@"%@%@?%@%@%@version=iphone_two&device=iphone", 
//               baseUrl,               /* Always force reauth for social because with the social publishing flow, the user is never taken to    */
//               currentProvider.url,   /* the "Welcome back" screen, and therefore could never click the "switch Providers" button. Also,       */
//               oid,                   /* signing out of a social provider could happen at any time, like on previous launches, and that        */
//               @"force_reauth=true&", /* should always prompt a force_reauth. Assume we always want to force reauth when logging in for social */
//               (([currentProvider.name isEqualToString:@"facebook"]) ? 
//                @"ext_perm=publish_stream,offline_access&" : @"")];
//    else
        str = [NSString stringWithFormat:@"%@%@?%@%@%@device=%@&extended=true", 
               baseUrl, 
               currentProvider.url,
               oid, 
               ((alwaysForceReauth || currentProvider.forceReauth) ? @"force_reauth=true&" : @""),
               (currentProvider.extPerm) ? currentProvider.extPerm : @"",
               device];//(([currentProvider.name isEqualToString:@"facebook"]) ? 
                       // @"ext_perm=publish_stream,offline_access&" : @"")];
#else
//    str = [NSString stringWithFormat:@"%@%@?%@%@version=iphone_two&device=iphone", 
//           baseUrl, 
//           currentProvider.url,
//           oid, 
//           ((alwaysForceReauth || currentProvider.forceReauth) ? @"force_reauth=true&" : @"")];    
#endif
    
	currentProvider.forceReauth = NO;
	
	DLog(@"startURL: %@", str);
	return [NSURL URLWithString:str];
}

- (BOOL)weShouldBeFirstResponder
{
    DLog(@"");
    
    /* If we're authenticating with a provider for social publishing, then don't worry about the return experience
     * for basic authentication. */
    if (social)
        return currentProvider.requiresInput;
    
    /* If we're authenticating with a basic provider, then we don't need to gather infomation if we're displaying 
     * return screen. */
    if ([currentProvider isEqualToReturningProvider:returningBasicProvider])
        return NO;
    
    return currentProvider.requiresInput;
}

- (JRAuthenticatedUser*)authenticatedUserForProvider:(JRProvider*)provider
{
    DLog(@"");
    return [authenticatedUsersByProvider objectForKey:provider.name];
}

- (JRAuthenticatedUser*)authenticatedUserForProviderNamed:(NSString*)provider;
{
    DLog(@"");
    return [authenticatedUsersByProvider objectForKey:provider];
}

- (void)forgetAuthenticatedUserForProvider:(NSString*)providerName
{
    DLog(@"");
    
    JRProvider* provider = [allProviders objectForKey:providerName];
    provider.forceReauth = YES;
    
    [authenticatedUsersByProvider removeObjectForKey:providerName];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] 
                                              forKey:@"jrAuthenticatedUsersByProvider"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)forgetAllAuthenticatedUsers
{
    DLog(@"");
    
    for (NSString *provider in [allProviders allKeys])
    {
        JRProvider *p = [allProviders objectForKey:provider];
        p.forceReauth = YES;
    }
    
    [authenticatedUsersByProvider removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] 
                                              forKey:@"jrAuthenticatedUsersByProvider"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (JRProvider*)getProviderAtIndex:(NSUInteger)index fromArray:(NSArray*)array
{
    DLog(@"");
    if (index < [array count])
    {
        return [allProviders objectForKey:[array objectAtIndex:index]];
    }
    
    return nil;
}

- (JRProvider*)getBasicProviderAtIndex:(NSUInteger)index
{
    DLog(@"");
    return [self getProviderAtIndex:index fromArray:[self basicProviders]];
}

- (JRProvider*)getSocialProviderAtIndex:(NSUInteger)index
{
    DLog(@"");
    return [self getProviderAtIndex:index fromArray:[self socialProviders]];
}

- (JRProvider*)getProviderNamed:(NSString*)name
{
    return [allProviders objectForKey:name];
}

//- (void)setCurrentProvider:(JRProvider*)provider
//{
//    DLog(@"");
//    [currentProvider release];
//    currentProvider = [provider retain];    
//}

- (void)setReturningBasicProviderToNil;
{
    DLog(@"");
    [returningBasicProvider release];
    returningBasicProvider = nil;
}

- (void)finishShareActivity:(JRActivityObject*)_activity forProvider:(NSString*)providerName withResponse:(NSString*)response
{
    NSDictionary *response_dict = [response JSONValue];
    
    // TODO: The activity object should be getting passed as the tag (in the share activity connection), in case the instance variable
    // changes before this call is returned (e.g., gets set to null), unless whatever action caused that also cancels the open connections.  
    // This should get verified and fixed.
    if (!response_dict)
    {
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy) 
        {
            if ([delegate respondsToSelector:@selector(publishingActivity:didFailWithError:forProvider:)])
                [delegate publishingActivity:_activity
                            didFailWithError:[self setError:[response retain] 
                                                   withCode:JRPublishFailedError 
                                                    andType:JRErrorTypePublishFailed]
                                                forProvider:providerName];//currentProvider.name];
            
        }
    }
    if ([[response_dict objectForKey:@"stat"] isEqualToString:@"ok"])
    {
        [self saveLastUsedSocialProvider];
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy) 
        {
            if ([delegate respondsToSelector:@selector(publishingActivityDidSucceed:forProvider:)])
                [delegate publishingActivityDidSucceed:_activity forProvider:providerName];//currentProvider.name];
        }
    }
    else
    {
        NSDictionary *error_dict = [response_dict objectForKey:@"err"];
        NSError *publishError = nil;
        
        if (!error_dict)
        {
            publishError = [self setError:@"There was a problem publishing this activity" 
                                 withCode:JRPublishFailedError 
                                  andType:JRErrorTypePublishFailed];
        }
        else 
        {
            int code;
            if (!CFNumberGetValue([error_dict objectForKey:@"code"], kCFNumberSInt32Type, &code))
                code = 1000;
            
            switch (code)
            {
                case 0: /* "Missing parameter: apiKey" */
                    publishError = [self setError:[error_dict objectForKey:@"msg"] 
                                         withCode:JRPublishErrorMissingApiKey
                                          andType:JRErrorTypePublishNeedsReauthentication];
                    break;
                case 4: /* "Facebook Error: Invalid OAuth 2.0 Access Token" */
                    publishError = [self setError:[error_dict objectForKey:@"msg"] 
                                         withCode:JRPublishErrorInvalidOauthToken 
                                          andType:JRErrorTypePublishNeedsReauthentication];
                    break;
                case 100: // TODO LinkedIn character limit error
                    publishError = [self setError:[error_dict objectForKey:@"msg"] 
                                         withCode:JRPublishErrorLinkedInCharacterExceded
                                          andType:JRErrorTypePublishInvalidActivity];
                    break;
                case 6: // TODO Twitter duplicate error
                    publishError = [self setError:[error_dict objectForKey:@"msg"] 
                                         withCode:JRPublishErrorDuplicateTwitter
                                          andType:JRErrorTypePublishInvalidActivity];
                    break;
                case 1000: /* Extracting code failed; Fall through. */
                default: // TODO Other errors (find them)
                    publishError = [self setError:@"There was a problem publishing this activity" 
                                         withCode:JRPublishFailedError 
                                          andType:JRErrorTypePublishFailed];
                    break;
            }
        }
        
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy) 
        {
            if ([delegate respondsToSelector:@selector(publishingActivity:didFailWithError:forProvider:)])
                [delegate publishingActivity:_activity
                            didFailWithError:publishError
                                 forProvider:providerName];//currentProvider.name];
        }
    }
}

- (void)startShareActivityForUser:(JRAuthenticatedUser*)user
{
    DLog(@"");
    // TODO: Better error checking in sessionData's share activity bit
    NSDictionary *activityDictionary = [activity dictionaryForObject];
        
    NSString *activityContent = [[activityDictionary objectForKey:@"activity"] JSONRepresentation];                          
    NSString *deviceToken = user.device_token;
    
    NSMutableData* body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"device_token=%@", deviceToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&activity=%@", activityContent] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&options={\"urlShortening\":\"true\"}"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&device=%@", device] dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest* request = [[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@/api/v2/activity?", serverUrl]]] retain];
    
    DLog("Share activity request: %@ and body: %s", [[request URL] absoluteString], body.bytes);
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
    NSDictionary* tag = [[NSDictionary alloc] initWithObjectsAndKeys:activity, @"activity", 
                                                                     currentProvider.name, @"providerName", 
                                                                     @"shareActivity", @"action", nil];//[[NSString stringWithString:@"shareActivity"] retain];
    
    [JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag];
    
    [request release];    
}

- (void)shareActivityForUser:(JRAuthenticatedUser*)user
{
    [self startShareActivityForUser:user];
}

- (void)finishGetShortenedUrlsForActivity:(JRActivityObject*)_activity withShortenedUrls:(NSString*)_urls
{
    // TODO: Fix when ready
    NSString *urls = [NSString stringWithString:
                      @"{ \
                      \"urls\": \
                      { \
                      \"email\":{\"foo.com\":\"rpx.me/1\",\"bar.com\":\"rpx.me/2\"}, \
                      \"sms\":{\"gazook.com\":\"rpx.me/4\", \"foobar.com\":\"rpx.me/5\", \"barbaz.com\":\"rpx.me/6\"} \
                      }, \
                      \"stat\":\"ok\" \
                      }"];
    
    NSDictionary *emailUrls = [[[urls JSONValue] objectForKey:@"urls"] objectForKey:@"email"];
    NSDictionary *smsUrls = [[[urls JSONValue] objectForKey:@"urls"] objectForKey:@"sms"];
    
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
}

- (void)startGetShortenedUrlsForActivity:(JRActivityObject*)_activity
{
    // TODO: Fix when ready
    NSDictionary *set = [NSDictionary dictionaryWithObjectsAndKeys:_activity.email.urls, @"email", _activity.sms.urls, @"sms", nil];
    NSString *urlString = @"http://example.com";
    //    [NSString stringWithFormat:
    //                           @"%@/getShortenedUrls/urls=%@",//openid/iphone_config_and_baseurl?appId=%@&skipXdReceiver=true", 
    //                           serverUrl, [set JSONRepresentation]];//appId];
    
    DLog(@"url: %@", urlString);
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url] autorelease];
	NSDictionary *tag = [[NSDictionary alloc] initWithObjectsAndKeys:_activity, @"activity", @"shortenUrls", @"action", nil];
    
	[JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag];    
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

- (void)startMakeCallToTokenUrl:(NSString*)_tokenUrl withToken:(NSString *)token forProvider:(NSString*)providerName
{
	DLog(@"");
    DLog(@"token:    %@", token);
	DLog(@"tokenURL: %@", _tokenUrl);
	
	NSMutableData* body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest* request = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_tokenUrl]] retain];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:body];
	
    NSDictionary* tag = [[NSDictionary dictionaryWithObjectsAndKeys:_tokenUrl, @"tokenUrl", 
                                                                    providerName, @"providerName", 
                                                                    @"callTokenUrl", @"action", nil] retain];
    
	if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self returnFullResponse:YES withTag:tag])// stringEncodeData:NO])
	{
        NSError *_error = [self setError:@"Problem initializing the connection to the token url"
                                withCode:JRAuthenticationFailedError
                                 andType:JRErrorTypeAuthenticationFailed];
        
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy) 
        {
            if ([delegate respondsToSelector:@selector(authenticationCallToTokenUrl:didFailWithError:forProvider:)])
                [delegate authenticationCallToTokenUrl:_tokenUrl didFailWithError:_error forProvider:providerName];
        }
	}
	
	[request release];
}

- (void)connectionDidFinishLoadingWithFullResponse:(NSURLResponse*)fullResponse unencodedPayload:(NSData*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
    NSObject* tag = (NSObject*)userdata;
    [payload retain];
    
    if ([tag isKindOfClass:[NSDictionary class]])
    {
        NSString *action = [(NSDictionary*)tag objectForKey:@"action"];
        DLog(@"action:  %@", action);

        if ([action isEqualToString:@"callTokenUrl"])//([(NSDictionary*)tag objectForKey:@"tokenUrl"])
        {
            [self finishMakeCallToTokenUrl:[(NSDictionary*)tag objectForKey:@"tokenUrl"]
                              withResponse:fullResponse 
                                andPayload:payload 
                               forProvider:[(NSDictionary*)tag objectForKey:@"providerName"]];
        }
    }
    else if ([tag isKindOfClass:[NSString class]])
    {   	
        DLog(@"tag:     %@", tag);
        
        if ([(NSString*)tag isEqualToString:@"getConfiguration"])
        {
            NSString *payloadString = [[[NSString alloc] initWithData:payload encoding:NSASCIIStringEncoding] autorelease];
            
            DLog(@"payload: %@", payloadString);
            
            if ([payloadString rangeOfString:@"\"provider_info\":{"].length != 0)
            {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)fullResponse;

                if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) 
                    error = [self finishGetConfiguration:payloadString 
                                                withEtag:[[httpResponse allHeaderFields] objectForKey:@"Etag"]];
            }
            else // There was an error...
            {
                error = [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                              withCode:JRConfigurationInformationError
                               andType:JRErrorTypeConfigurationFailed];
            }
        }
    }
    
	[payload release];
	[tag release];	
}

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
	DLog(@"");
    NSObject* tag = (NSObject*)userdata;
    
	[payload retain];
	
	DLog(@"payload: %@", payload);
    
    if ([tag isKindOfClass:[NSDictionary class]])
    {   	
        NSString *action = [(NSDictionary*)tag objectForKey:@"action"];
        DLog(@"action:  %@", action);
        
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
    DLog(@"");
    NSObject* tag = (NSObject*)userdata;
    
    if ([tag isKindOfClass:[NSString class]])
    {   
        if ([(NSString*)tag isEqualToString:@"getConfiguration"])
        {
            error = [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                          withCode:JRConfigurationInformationError
                           andType:JRErrorTypeConfigurationFailed];
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
        DLog(@"action:  %@", action);

        if ([action isEqualToString:@"callTokenUrl"])//([(NSDictionary*)tag objectForKey:@"tokenUrl"])
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
            // Do nothing for now...
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
    DLog(@"");
    if ([(NSObject*)userdata isKindOfClass:[NSString class]])
        [(NSString*)userdata release];
    if ([(NSObject*)userdata isKindOfClass:[NSDictionary class]])
        [(NSDictionary*)userdata release];
}

- (void)triggerAuthenticationDidCompleteWithPayload:(NSDictionary*)payloadDict
{  
    DLog(@"");
    
 /* This value will be nil if authentication was canceled after the user authenticated in the
    webview, but before the authentication call was completed, like in the case where the calling
    application issues the cancelAuthentication command. */
    if (!currentProvider)
        return;
    
    NSDictionary *goodies = [payloadDict objectForKey:@"rpx_result"];
    NSString *token = [goodies objectForKey:@"token"];
    
    JRAuthenticatedUser *user = [[[JRAuthenticatedUser alloc] initUserWithDictionary:goodies
                                                                    forProviderNamed:currentProvider.name] autorelease];    
    
    // TODO: Verify that the provider returned in the rpx_result is the same as the currentProvider
    
    [authenticatedUsersByProvider setObject:user forKey:currentProvider.name];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] 
                                              forKey:@"jrAuthenticatedUsersByProvider"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([[self basicProviders] containsObject:currentProvider.name])
        [self saveLastUsedBasicProvider];
    
    if ([[self socialProviders] containsObject:currentProvider.name])
        [self saveLastUsedSocialProvider];
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(authenticationDidCompleteForUser:forProvider:)])
            [delegate authenticationDidCompleteForUser:[goodies objectForKey:@"auth_info"] forProvider:currentProvider.name];
    }
    
	if (tokenUrl)
        [self startMakeCallToTokenUrl:tokenUrl withToken:token forProvider:currentProvider.name];
    
    [currentProvider release];
    currentProvider = nil;
}

- (void)triggerAuthenticationDidFailWithError:(NSError*)_error
{
    DLog(@"");
    [currentProvider release];
    currentProvider = nil;
    
    [returningBasicProvider release];
    returningBasicProvider = nil;
    
    [returningSocialProvider release];
    returningSocialProvider = nil;
    
    DLog(@"");
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(authenticationDidFailWithError:forProvider:)])
            [delegate authenticationDidFailWithError:_error forProvider:currentProvider.name];
    }
}

- (void)triggerAuthenticationDidCancel
{
    DLog(@"");
    [currentProvider release];
    currentProvider = nil;
    
    [returningBasicProvider release];
    returningBasicProvider = nil;
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(authenticationDidCancel)])
            [delegate authenticationDidCancel];
    }
}

- (void)triggerAuthenticationDidCancel:(id)sender
{
    DLog(@"");
    [self triggerAuthenticationDidCancel];
}

- (void)triggerAuthenticationDidTimeOutConfiguration
{
    DLog(@"");
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
    DLog(@"");
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(authenticationDidRestart)])
            [delegate authenticationDidRestart];
    }
}

- (void)triggerPublishingDidCancel
{
    DLog(@"");
    [currentProvider release];
    currentProvider = nil;
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(publishingDidCancel)])
            [delegate publishingDidCancel];
    }
    
    social = NO;
}

- (void)triggerPublishingDidCancel:(id)sender
{
    DLog(@"");
    [self triggerPublishingDidCancel];
}

- (void)triggerPublishingDidTimeOutConfiguration
{
    [currentProvider release];
    currentProvider = nil;
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(publishingDidCancel)])
            [delegate publishingDidCancel];
    }
    
    social = NO;
}

- (void)triggerPublishingDidComplete
{
    DLog(@"");
    [currentProvider release];
    currentProvider = nil;
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(publishingDidComplete)])
            [delegate publishingDidComplete];
    }
    
    social = NO;    
}

- (void)triggerPublishingDidComplete:(id)sender
{
    DLog(@"");
    [self triggerPublishingDidComplete];
}

- (void)triggerPublishingDidFailWithError:(NSError*)_error
{
    DLog(@"");
    
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
    DLog(@"");
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy) 
    {
        if ([delegate respondsToSelector:@selector(publishingDidRestart)])
            [delegate publishingDidRestart];
    }
}

- (void)triggerEmailSharingDidComplete
{
    // TODO: Fix when ready
    //    NSString *urlString = [NSString stringWithFormat:
    //                           @"%@/openid/iphone_config_and_baseurl?appId=%@&skipXdReceiver=true", 
    //                           serverUrl, appId];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];//urlString];
	    
	NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url] autorelease];
	
	NSString *tag = @"emailSuccess";//[[NSString alloc] initWithFormat:@"emailSuccess"];
	
    [JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:[tag retain]];
}

- (void)triggerSmsSharingDidComplete
{
    // TODO: Fix when ready
    //    NSString *urlString = [NSString stringWithFormat:
    //                           @"%@/openid/iphone_config_and_baseurl?appId=%@&skipXdReceiver=true", 
    //                           serverUrl, appId];
    
    NSURL *url = [NSURL URLWithString:@"http://example.com"];//urlString];
    
	NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url] autorelease];
	
	NSString *tag = @"smsSuccess";//[[NSString alloc] initWithFormat:@"emailSuccess"];
	
    [JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:[tag retain]];    
}
@end
