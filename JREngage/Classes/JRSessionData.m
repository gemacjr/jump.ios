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

// TODO: Figure out why the -DDEBUG cflag isn't being set when Active Conf is set to debug
#define DEBUG
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@implementation JRAuthenticatedUser
@synthesize photo;
@synthesize preferred_username;
@synthesize device_token;
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
        
        device_token = [[dictionary objectForKey:@"device_token"] retain];
    }

	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	DLog(@"");
   
    [coder encodeObject:provider_name forKey:@"provider_name"];
    [coder encodeObject:photo forKey:@"photo"];
    [coder encodeObject:preferred_username forKey:@"preferred_username"];
    [coder encodeObject:device_token forKey:@"device_token"];
}

- (id)initWithCoder:(NSCoder *)coder
{
	DLog(@"");
  
    self = [[JRAuthenticatedUser alloc] init];
    if (self != nil)
    {
        provider_name = [[coder decodeObjectForKey:@"provider_key"] retain];
        photo = [[coder decodeObjectForKey:@"photo"] retain];
        preferred_username = [[coder decodeObjectForKey:@"preferred_username"] retain];
        device_token = [[coder decodeObjectForKey:@"device_token"] retain];
    }   

    return self;
}

- (void)dealloc
{
    [provider_name release];
    [photo release];
    [preferred_username release];
    [device_token release];
    
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
@synthesize userInput;
@synthesize welcomeString;

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
    [coder encodeObject:userInput forKey:@"userInput"];
    [coder encodeObject:welcomeString forKey:@"welcomeString"];
    [coder encodeBool:requiresInput forKey:@"requiresInput"];
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
        userInput =       [[coder decodeObjectForKey:@"userInput"] retain];
        welcomeString =   [[coder decodeObjectForKey:@"welcomeString"] retain];
        requiresInput =    [coder decodeBoolForKey:@"requiresInput"];
    }   
    
    return self;
}

- (BOOL)isEqualToProvider:(JRProvider*)provider
{
  	DLog(@"");

    if ([self.name isEqualToString:provider.name])
        return YES;
    
    return NO;
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

	[super dealloc];
}
@end

@interface JRSessionData()
- (NSError*)startGetConfiguration;
- (void)loadLastUsedBasicProvider;
- (void)loadLastUsedSocialProvider;
@end

@implementation JRSessionData
@synthesize currentProvider;
@synthesize returningBasicProvider;
@synthesize returningSocialProvider;
@synthesize activity;
@synthesize tokenUrl;
@synthesize forceReauth;
@synthesize social;
@synthesize configurationComplete;
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

- (BOOL)hidePoweredBy
{
    DLog(@"");
    return hidePoweredBy;
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
        
        NSData *archivedUsers = [[NSUserDefaults standardUserDefaults] objectForKey:@"jrAuthenticatedUsersByProvider"];
        if (archivedUsers != nil)
        {
            NSDictionary *unarchivedUsers = [NSKeyedUnarchiver unarchiveObjectWithData:archivedUsers];
            if (unarchivedUsers != nil)
                authenticatedUsersByProvider = [[NSMutableDictionary alloc] initWithDictionary:unarchivedUsers];
        }
        
        if (!authenticatedUsersByProvider)
            authenticatedUsersByProvider = [[NSMutableDictionary alloc] initWithCapacity:1];

        NSData *archivedProviders = [[NSUserDefaults standardUserDefaults] objectForKey:@"jrAllProviders"];
        if (archivedProviders != nil)
        {
            NSDictionary *unarchivedProviders = [NSKeyedUnarchiver unarchiveObjectWithData:archivedProviders];
            if (unarchivedProviders != nil)
                allProviders = [[NSMutableDictionary alloc] initWithDictionary:unarchivedProviders];
        }
        
        NSData *archivedBasicProviders = [[NSUserDefaults standardUserDefaults] objectForKey:@"jrBasicProviders"];
        if (archivedBasicProviders != nil)
        {
            basicProviders = [[NSKeyedUnarchiver unarchiveObjectWithData:archivedBasicProviders] retain];
//            if (unarchivedBasicProviders != nil)
//                basicProviders = [[NSArray alloc] initWithArray:unarchivedBasicProviders];
        }
        
        NSData *archivedSocialProviders = [[NSUserDefaults standardUserDefaults] objectForKey:@"jrSocialProviders"];
        if (archivedSocialProviders != nil)
        {
            socialProviders = [[NSKeyedUnarchiver unarchiveObjectWithData:archivedSocialProviders] retain];
//            if (unarchivedSocialProviders != nil)
//                socialProviders = [[NSArray alloc] initWithArray:unarchivedSocialProviders];
        }

        baseUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"jrBaseUrl"];
        hidePoweredBy = [[NSUserDefaults standardUserDefaults] boolForKey:@"jrHidePoweredBy"];
                
        // TODO: The loadLastUsed...Provider methods are going to get called twice if we call them at the end 
        // of the configuration calls and in the constructor. Figure out the most optimal solution for this...
        if (baseUrl && allProviders)
        {
            [self loadLastUsedSocialProvider];
            [self loadLastUsedBasicProvider];
        }
        
        //error = [self startGetBaseUrl];
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
    //error = [self startGetBaseUrl];
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

- (NSError*)startGetConfiguration
{	
    DLog(@"");
    
//#define STAGING
//#ifdef STAGING
//	NSString *urlString = [NSString stringWithFormat:
//                           @"http://rpxstaging.com/openid/iphone_config_and_baseurl?appId=%@&skipXdReceiver=true", 
//                           @"kcemlogaanidnljknmbj"];
//    tokenUrl = nil;
//#else
	NSString *urlString = [NSString stringWithFormat:
                           @"http://rpxnow.com/openid/iphone_config_and_baseurl?appId=%@&skipXdReceiver=true", 
                           appId];
//#endif
    
    DLog(@"url: %@", urlString);
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	if(!url)
		return [self setError:@"There was a problem connecting to the Janrain server while configuring authentication." 
                     withCode:JRUrlError 
                      andType:JRErrorTypeConfigurationFailed];
    
	NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url] autorelease];
	
	NSString *tag = [[NSString alloc] initWithFormat:@"getConfiguration"];
	
	if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
		return [self setError:@"There was a problem connecting to the Janrain server while configuring authentication." 
                     withCode:JRUrlError 
                      andType:JRErrorTypeConfigurationFailed];
    
    return nil;
}


- (NSError*)finishGetConfiguration:(NSString*)dataStr
{
	DLog(@"");
    
    if (![dataStr respondsToSelector:@selector(JSONValue)])
        return [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                     withCode:JRJsonError
                      andType:JRErrorTypeConfigurationFailed];
	
	NSDictionary *jsonDict = [dataStr JSONValue];
    
	if(!jsonDict)
		return [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                     withCode:JRJsonError
                      andType:JRErrorTypeConfigurationFailed];
	
    // TODO: Error check this (getting the new config stuff out of the new config api call)
    if (![[jsonDict objectForKey:@"baseurl"] isEqualToString:baseUrl])
        baseUrl = [[[jsonDict objectForKey:@"baseurl"] 
                    stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]] retain];
    
    [[NSUserDefaults standardUserDefaults] setValue:baseUrl forKey:@"jrBaseUrl"];
    
	NSDictionary *providerInfo   = [NSDictionary dictionaryWithDictionary:[jsonDict objectForKey:@"provider_info"]];
    
    BOOL reloadConfiguration = YES;//NO;
    
    // TODO: Rewrite all of the configuration stuff to use e-tag to compare new data with cached data in case anything changes
    //    for (NSString *name in [providerInfo allKeys])
    //    {
    //        if (![allProviders objectForKey:name]) 
    //        {
    //            reloadConfiguration = YES;
    //            break;
    //        }
    //    }
    
    if (reloadConfiguration)
    {
        allProviders = [[NSMutableDictionary alloc] initWithCapacity:[[providerInfo allKeys] count]];
        
        for (NSString *name in [providerInfo allKeys])
        {
            if (name)
            {
                NSDictionary *dictionary = [providerInfo objectForKey:name];
                
                JRProvider *provider = [[[JRProvider alloc] initWithName:name
                                                           andDictionary:dictionary] autorelease];
                
                [allProviders setObject:provider forKey:name];
            }
        }
        
        basicProviders = [[NSArray arrayWithArray:[jsonDict objectForKey:@"enabled_providers"]] retain];
        
        if (!allProviders || !basicProviders)
            return [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                         withCode:JRConfigurationInformationError
                          andType:JRErrorTypeConfigurationFailed];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:allProviders] 
                                                  forKey:@"jrAllProviders"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:basicProviders] 
                                                  forKey:@"jrBasicProviders"];
        
#ifdef SOCIAL_PUBLISHING	    
        socialProviders = [[NSArray arrayWithArray:[jsonDict objectForKey:@"social_providers"]] retain];
        
        /* yippie, yahoo! */
        if (!socialProviders)		
            return [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                         withCode:JRConfigurationInformationError
                          andType:JRErrorTypeConfigurationInformationMissing];
        
#endif
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:socialProviders] 
                                                  forKey:@"JRSocialProviders"];
        
        if ([[jsonDict objectForKey:@"hide_tagline"] isEqualToString:@"YES"])
            hidePoweredBy = YES;
        else
            hidePoweredBy = NO;
        
        [[NSUserDefaults standardUserDefaults] setBool:hidePoweredBy forKey:@"jrHidePoweredBy"];
    }
    
    
#ifdef SOCIAL_PUBLISHING	
	[self loadLastUsedSocialProvider];
#endif
    
    [self loadLastUsedBasicProvider];
    
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

    NSData *archivedProvider = [[NSUserDefaults standardUserDefaults] objectForKey:@"jrLastUsedSocialProvider"];
    if (archivedProvider != nil)
        returningSocialProvider = [[NSKeyedUnarchiver unarchiveObjectWithData:archivedProvider] retain];
}

- (void)loadLastUsedBasicProvider
{
    DLog(@"");

    NSData *archivedProvider = [[NSUserDefaults standardUserDefaults] objectForKey:@"jrLastUsedBasicProvider"];
    if (archivedProvider != nil)
        returningBasicProvider = [[NSKeyedUnarchiver unarchiveObjectWithData:archivedProvider] retain];
    
    configurationComplete = YES;  
}

- (void)saveLastUsedSocialProvider
{
	DLog(@"");
    
    [returningSocialProvider release];
    returningSocialProvider = [currentProvider retain];

    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:returningSocialProvider] 
                                              forKey:@"jrLastUsedSocialProvider"];
}

- (void)saveLastUsedBasicProvider
{
    DLog(@"");
    
    [returningBasicProvider release];
    returningBasicProvider = [currentProvider retain];

    // TODO: See about re-adding cookie code that manually sets the last used provider and see 
    // if that means using rpx to log into site through Safari browser will also remember the user/provider
    
    NSHTTPCookieStorage *cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray *cookies = [cookieStore cookiesForURL:[NSURL URLWithString:baseUrl]];
	    
	for (NSHTTPCookie *savedCookie in cookies) 
	{
		if ([savedCookie.name isEqualToString:@"welcome_info"])
		{
			[returningBasicProvider setWelcomeString:[self getWelcomeMessageFromCookieString:savedCookie.value]];
		}
	}	    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:returningBasicProvider] 
                                              forKey:@"jrLastUsedBasicProvider"];
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
#ifdef SOCIAL_PUBLISHING
    if (social)
        str = [NSString stringWithFormat:@"%@%@?%@%@%@version=iphone_two&device=iphone", 
               baseUrl,               /* Always force reauth for social because with the social publishing flow, the user is never taken to    */
               currentProvider.url,   /* the "Welcome back" screen, and therefore could never click the "switch Providers" button. Also,       */
               oid,                   /* signing out of a social provider could happen at any time, like on previous launches, and that        */
               @"force_reauth=true&", /* should always prompt a force_reauth. Assume we always want to force reauth when logging in for social */
               (([currentProvider.name isEqualToString:@"facebook"]) ? 
                @"ext_perm=publish_stream,offline_access&" : @"")];
    else
        str = [NSString stringWithFormat:@"%@%@?%@%@version=iphone_two&device=iphone", 
               baseUrl, 
               currentProvider.url,
               oid, 
               ((forceReauth) ? @"force_reauth=true&" : @"")];
#else
    str = [NSString stringWithFormat:@"%@%@?%@%@version=iphone_two&device=iphone", 
           baseUrl, 
           currentProvider.url,
           oid, 
           ((forceReauth) ? @"force_reauth=true&" : @"")];    
#endif
    
	forceReauth = NO;
	
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
    if ([currentProvider isEqualToProvider:returningBasicProvider])
        return NO;
    
    return currentProvider.requiresInput;
}

- (JRAuthenticatedUser*)authenticatedUserForProvider:(JRProvider*)provider
{
    DLog(@"");
    return [authenticatedUsersByProvider objectForKey:provider.name];
}


- (void)forgetAuthenticatedUserForProvider:(NSString*)provider
{
    DLog(@"");
    [authenticatedUsersByProvider removeObjectForKey:provider];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] 
                                              forKey:@"jrAuthenticatedUsersByProvider"];
}

- (void)forgetAllAuthenticatedUsers
{
    DLog(@"");
    [authenticatedUsersByProvider removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] 
                                              forKey:@"jrAuthenticatedUsersByProvider"];
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

- (void)setCurrentProvider:(JRProvider*)provider
{
    DLog(@"");
    [currentProvider release];
    currentProvider = [provider retain];    
}

- (void)setReturningBasicProviderToNil;
{
    DLog(@"");
    [returningBasicProvider release];
    returningBasicProvider = nil;
}

- (void)shareActivity:(JRActivityObject*)_activity forUser:(JRAuthenticatedUser*)user
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
#ifdef STAGING
    NSMutableURLRequest* request = [[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:@"https://rpxstaging.com/api/v2/activity?"]] retain];
#else
    NSMutableURLRequest* request = [[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:@"https://rpxnow.com/api/v2/activity?"]] retain];
#endif
    
    DLog("Share activity request: %@ and body: %s", [[request URL] absoluteString], body.bytes);
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
    NSString* tag = [[NSString stringWithString:@"shareActivity"] retain];
    
    [JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag];
    
    [request release];    
}

- (void)makeCallToTokenUrl:(NSString*)_tokenUrl withToken:(NSString *)token forProvider:(NSString*)providerName
{
	DLog(@"");
    DLog(@"token:    %@", token);
	DLog(@"tokenURL: %@", _tokenUrl);
	
	NSMutableData* body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest* request = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_tokenUrl]] retain];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:body];
	
    NSDictionary* tag = [[NSDictionary dictionaryWithObjectsAndKeys:_tokenUrl, @"tokenUrl", providerName, @"providerName", nil] retain];
    
	if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag stringEncodeData:NO])
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

- (void)connectionDidFinishLoadingWithUnEncodedPayload:(NSData*)payload request:(NSURLRequest*)request andTag:(void*)userdata 
{
    NSObject* tag = (NSObject*)userdata;
    [payload retain];
    
    if ([tag isKindOfClass:[NSDictionary class]])
    {
        if ([(NSDictionary*)tag objectForKey:@"tokenUrl"])
        {
            NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
            for (id<JRSessionDelegate> delegate in delegatesCopy) 
            {
                if ([delegate respondsToSelector:@selector(authenticationDidReachTokenUrl:withPayload:forProvider:)])
                    [delegate authenticationDidReachTokenUrl:[(NSDictionary*)tag objectForKey:@"tokenUrl"] 
                                                 withPayload:payload 
                                                 forProvider:[(NSDictionary*)tag objectForKey:@"providerName"]];
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
    
    if ([tag isKindOfClass:[NSString class]])
    {   	
        DLog(@"tag:     %@", tag);

        if ([(NSString*)tag isEqualToString:@"getConfiguration"])
        {
            if ([payload rangeOfString:@"\"provider_info\":{"].length != 0)
            {
                error = [self finishGetConfiguration:payload];
            }
            else // There was an error...
            {
                error = [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                              withCode:JRConfigurationInformationError
                               andType:JRErrorTypeConfigurationFailed];
            }
        }
        else if ([(NSString*)tag isEqualToString:@"shareActivity"])
        {
            NSDictionary *response_dict = [payload JSONValue];
            
            if (!response_dict)
            {
                NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
                for (id<JRSessionDelegate> delegate in delegatesCopy) 
                {
                    if ([delegate respondsToSelector:@selector(publishingActivity:didFailWithError:forProvider:)])
                        [delegate publishingActivity:activity
                                    didFailWithError:[self setError:[payload retain] 
                                                           withCode:JRPublishFailedError 
                                                            andType:JRErrorTypePublishFailed]
                                         forProvider:currentProvider.name];
                    
                }
            }
            if ([[response_dict objectForKey:@"stat"] isEqualToString:@"ok"])
            {
                [self saveLastUsedSocialProvider];
                NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
                for (id<JRSessionDelegate> delegate in delegatesCopy) 
                {
                    if ([delegate respondsToSelector:@selector(publishingActivityDidSucceed:forProvider:)])
                        [delegate publishingActivityDidSucceed:activity forProvider:currentProvider.name];
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
                        [delegate publishingActivity:activity
                                    didFailWithError:publishError
                                         forProvider:currentProvider.name];
                    
                }
            }
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
        else if ([(NSString*)tag isEqualToString:@"shareActivity"])
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
    }
    else if ([(NSDictionary*)tag isKindOfClass:[NSDictionary class]])
    {
        if ([(NSDictionary*)tag objectForKey:@"tokenUrl"])
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
    }
    
	[tag release];	
}

- (void)connectionWasStoppedWithTag:(void*)userdata 
{
    DLog(@"");
    [(NSString*)userdata release];
}

- (void)triggerAuthenticationDidCompleteWithPayload:(NSDictionary*)payloadDict
{  
    DLog(@"");
    NSDictionary *goodies = [payloadDict objectForKey:@"rpx_result"];
    NSString *token = [goodies objectForKey:@"token"];
    
    JRAuthenticatedUser *user = [[[JRAuthenticatedUser alloc] initUserWithDictionary:goodies
                                                                    forProviderNamed:currentProvider.name] autorelease];    
    
    // QTS: Do we need to synchronize this object??
    //@synchronized (authenticatedUsersByProvider)
    //{
    [authenticatedUsersByProvider setObject:user forKey:currentProvider.name];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] 
                                              forKey:@"jrAuthenticatedUsersByProvider"];
    //}
    
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
        [self makeCallToTokenUrl:tokenUrl withToken:token forProvider:currentProvider.name];
    
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
    
    //    [returningSocialProvider release];
    //    returningSocialProvider = nil;
    
    DLog(@"");
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
@end
