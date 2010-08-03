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
    if (dictionary == nil || _provider_name == nil)
	{
		[self release];
		return nil;
	}
	
	if (self = [super init]) 
	{
        provider_name = [[NSString alloc] initWithFormat:@"%@", _provider_name];//[NSString stringWithString:_provider_name];//[_provider_name retain];
        
        photo = [[NSString alloc] initWithFormat:@"%@", [dictionary objectForKey:@"photo"]];
        preferred_username = [[NSString alloc] initWithFormat:@"%@", [dictionary objectForKey:@"preferred_username"]];
        device_token = [[NSString alloc] initWithFormat:@"%@", [dictionary objectForKey:@"device_token"]];
    }
	
    DLog(@"JRAuthenticatedUser retain count:      %d", [self retainCount]);
    DLog(@"    JRAuthenticatedUser provider_name: %d", [self.provider_name retainCount]);
    DLog(@"    JRAuthenticatedUser photo:         %d", [self.photo retainCount]);
    DLog(@"    JRAuthenticatedUser username:      %d", [self.preferred_username retainCount]);
    DLog(@"    JRAuthenticatedUser device_token:  %d", [self.device_token retainCount]);
    
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:provider_name forKey:@"provider_name"];
    [coder encodeObject:[photo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"photo"];
    [coder encodeObject:preferred_username forKey:@"preferred_username"];
    [coder encodeObject:device_token forKey:@"device_token"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[JRAuthenticatedUser alloc] init];
    if (self != nil)
    {
        provider_name = [[coder decodeObjectForKey:@"provider_key"] retain];
        photo = [[[coder decodeObjectForKey:@"photo"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] retain];
        preferred_username = [[coder decodeObjectForKey:@"preferred_username"] retain];
        device_token = [[coder decodeObjectForKey:@"device_token"] retain];
    }   

    DLog(@"JRAuthenticatedUser retain count:      %d", [self retainCount]);
    DLog(@"    JRAuthenticatedUser provider_name: %d", [self.provider_name retainCount]);
    DLog(@"    JRAuthenticatedUser photo:         %d", [self.photo retainCount]);
    DLog(@"    JRAuthenticatedUser username:      %d", [self.preferred_username retainCount]);
    DLog(@"    JRAuthenticatedUser device_token:  %d", [self.device_token retainCount]);
    
    return self;
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
            shortText = [newArr componentsJoinedByString:@" "];	
        }
        else 
        {
            shortText = @"";
        }
    }
	
	return self;
}

- (BOOL)isEqualToProvider:(JRProvider*)provider
{
    if ([self.name isEqualToString:provider.name])
        return YES;
    
    return NO;
}

- (void)dealloc
{
	DLog(@"");
		
	[name release];
	[welcomeString release];
	[userInput release];
	
	[super dealloc];
}
@end

@interface JRSessionData()
- (NSError*)startGetBaseUrl;
- (NSError*)startGetConfiguredProviders;
- (NSError*)finishGetConfiguredProviders:(NSString*)dataStr;
- (void)loadLastUsedBasicProvider;
- (void)loadLastUsedSocialProvider;
@end

@implementation JRSessionData
@synthesize configurationComplete;
@synthesize allProviders;
@synthesize basicProviders;
@synthesize socialProviders;
@synthesize currentProvider;
@synthesize currentBasicProvider;
@synthesize returningBasicProvider;
@synthesize currentSocialProvider;
@synthesize returningSocialProvider;
@synthesize activity;
@synthesize hidePoweredBy;
@synthesize baseUrl;
@synthesize tokenUrl;
@synthesize forceReauth;
@synthesize error;
@synthesize customView;
@synthesize customProvider;
@synthesize isSocial;


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

- (id)initWithAppId:(NSString*)_appId tokenUrl:(NSString*)_tokenUrl andDelegate:(id<JRSessionDelegate>)_delegate
{
	DLog(@"");

	if (self = [super init]) 
	{
        singleton = self;
        
        delegates = [[NSMutableArray alloc] initWithObjects:[_delegate retain], nil];
		appId = _appId;
        tokenUrl = _tokenUrl;
        
        NSData *archivedUsers = [[NSUserDefaults standardUserDefaults] objectForKey:@"authenticatedUsersByProvider"];
        if (archivedUsers != nil)
        {
            NSDictionary *unarchivedUsers = [NSKeyedUnarchiver unarchiveObjectWithData:archivedUsers];
            if (unarchivedUsers != nil)
                authenticatedUsersByProvider = [[NSMutableDictionary alloc] initWithDictionary:unarchivedUsers];
        }
        
        if (!authenticatedUsersByProvider)
            authenticatedUsersByProvider = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        error = [self startGetBaseUrl];
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



- (void)reconfigure
{
    error = [self startGetBaseUrl];
}


- (void)dealloc 
{
	DLog(@"");
		
	[allProviders release];
	[basicProviders release];
	
	[currentProvider release];
	[currentBasicProvider release];
	[returningBasicProvider release];
	[currentSocialProvider release];
	[returningSocialProvider release];
	
	[baseUrl release];
	[errorStr release];
	
	[delegates release];
	
	[super dealloc];
}

- (NSError*)setError:(NSString*)message withCode:(NSInteger)code andSeverity:(NSString*)severity
{
    DLog(@"");
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                               message, NSLocalizedDescriptionKey,
                               severity, @"severity", nil];

    return [[NSError alloc] initWithDomain:@"JRAuthenticate"
                                      code:code
                                  userInfo:userInfo];
}

- (void)addDelegate:(id<JRSessionDelegate>)_delegate
{
    // TODO: Need memory management here (lock/semaphore?)
	DLog(@"");
    [delegates addObject:_delegate];
}

- (void)removeDelegate:(id<JRSessionDelegate>)_delegate
{
    // TODO: Need memory management here (lock/semaphore?)
	DLog(@"");
    [delegates removeObject:_delegate];
}

- (NSURL*)startUrl
{
	DLog(@"");
    
//    NSDictionary *providerStats = [providerInfo objectForKey:currentProvider.name];
	NSMutableString *oid;
	
	if (currentProvider.openIdentifier)//([providerStats objectForKey:@"openid_identifier"])
	{
		oid = [NSMutableString stringWithFormat:@"openid_identifier=%@&", currentProvider.openIdentifier];//[NSString stringWithString:[providerStats objectForKey:@"openid_identifier"]]]; //[NSMutableString stringWithString:[providerStats objectForKey:@"openid_identifier"]];
		
		if(currentProvider.requiresInput)
			[oid replaceOccurrencesOfString:@"%@" 
								 withString:[currentProvider.userInput
											 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] 
									options:NSLiteralSearch 
									  range:NSMakeRange(0, [oid length])];
		//	oid = [NSString stringWithFormat:oid, [currentProvider.userInput stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	}
	else 
	{
		oid = [NSMutableString stringWithString:@""];
	}

    NSString *str = nil;
#ifdef SOCIAL_PUBLISHING
    if (isSocial)
        str = [NSString stringWithFormat:@"%@%@?%@%@%@device=iphone", 
                         baseUrl, 
                         currentProvider.url,//[providerStats objectForKey:@"url"], 
                         oid, 
                         ((forceReauth) ? @"force_reauth=true&" : @""),
                         (([currentProvider.name isEqualToString:@"facebook"]) ? 
                          @"ext_perm=publish_stream&" : @"")];
    else
        str = [NSString stringWithFormat:@"%@%@?%@%@device=iphone", 
                         baseUrl, 
                         currentProvider.url,//[providerStats objectForKey:@"url"], 
                         oid, 
                         ((forceReauth) ? @"force_reauth=true&" : @"")];
#else
        str = [NSString stringWithFormat:@"%@%@?%@%@device=iphone", 
                         baseUrl, 
                         currentProvider.url,//[providerStats objectForKey:@"url"], 
                         oid, 
                         ((forceReauth) ? @"force_reauth=true&" : @"")];    
#endif

	forceReauth = NO;
	
	DLog(@"startURL: %@", str);
	return [NSURL URLWithString:str];
}



- (NSError*)startGetBaseUrl
{
	
#if LOCAL // TODO: Change this to use stringWithFormat instead
	NSString *urlString = [[@"http://lillialexis.janrain.com:8080/jsapi/v3/base_url?appId=" 
							stringByAppendingString:@"dgnclgmgpcjmdebbhkhf"]
						   stringByAppendingString:@"&skipXdReceiver=true"];
#else
	NSString *urlString = [[@"http://rpxnow.com/jsapi/v3/base_url?appId=" 
							stringByAppendingString:appId]
						   stringByAppendingString:@"&skipXdReceiver=true"];
#endif
    DLog(@"url: %@", urlString);
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	if(!url) // Then there was an error
		return [self setError:@"There was a problem connecting to the Janrain server while configuring authentication." 
                     withCode:JRUrlError 
                  andSeverity:JRErrorSeverityConfigurationFailed];
    
	NSURLRequest *request = [[[NSURLRequest alloc] initWithURL: url] autorelease];
	
	NSString *tag = [[NSString alloc] initWithFormat:@"getBaseURL"];
	
	if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
		return [self setError:@"There was a problem connecting to the Janrain server while configuring authentication." 
                     withCode:JRUrlError 
                  andSeverity:JRErrorSeverityConfigurationFailed];

    return nil;
}

- (NSError*)finishGetBaseUrl:(NSString*)dataStr
{
	DLog(@"dataStr: %@", dataStr);
	
	NSArray *arr = [dataStr componentsSeparatedByString:@"\""];
	
	if(!arr)
		return [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                     withCode:JRDataParsingError
                  andSeverity:JRErrorSeverityConfigurationFailed];
	
	baseUrl = [arr objectAtIndex:1];

    baseUrl = [[baseUrl stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]] retain];

    return [self startGetConfiguredProviders];
}


- (NSError*)startGetConfiguredProviders
{
	DLog(@"");

	NSString *urlString = [baseUrl stringByAppendingString:@"/openid/iphone_config"];
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	if(!url) // Then there was an error
		return [self setError:@"There was a problem connecting to the Janrain server while configuring authentication." 
                     withCode:JRUrlError 
                  andSeverity:JRErrorSeverityConfigurationFailed];
	
	NSURLRequest *request = [[[NSURLRequest alloc] initWithURL: url] autorelease];
	
	NSString *tag = [[NSString stringWithFormat:@"getConfiguredProviders"] retain];
	
	if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
		return [self setError:@"There was a problem connecting to the Janrain server while configuring authentication." 
                     withCode:JRUrlError 
                  andSeverity:JRErrorSeverityConfigurationFailed];
  
    return nil;
}

- (NSError*)finishGetConfiguredProviders:(NSString*)dataStr
{
	DLog(@"");
    
    if (![dataStr respondsToSelector:@selector(JSONValue)])
        return [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                     withCode:JRJsonError
                  andSeverity:JRErrorSeverityConfigurationFailed];
	
	NSDictionary *jsonDict = [dataStr JSONValue];
    
    DLog(@"dataStr retain count: %d", [dataStr retainCount]);
    DLog(@"jsonDict retain count: %d", [jsonDict retainCount]);
	
	if(!jsonDict)
		return [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                     withCode:JRJsonError
                  andSeverity:JRErrorSeverityConfigurationFailed];
	
	NSDictionary *providerInfo   = [NSDictionary dictionaryWithDictionary:[jsonDict objectForKey:@"provider_info"]];

    DLog(@"providerInfo retain count: %d", [providerInfo retainCount]);
    
    allProviders = [[NSMutableDictionary  alloc] initWithCapacity:[[providerInfo allKeys] count]];
    
    for (NSString *name in [providerInfo allKeys])
    {
        DLog(@"name retain count: %d", [name retainCount]);
        if (name)
        {
            NSDictionary *dictionary = [providerInfo objectForKey:name];
            
            DLog(@"dataStr retain count: %d", [dictionary retainCount]);

            JRProvider *provider = [[[JRProvider alloc] initWithName:name
                                                      andDictionary:dictionary] autorelease];
            
            [allProviders setObject:provider forKey:name];
            
            DLog(@"provider retain count: %d", [provider retainCount]);
            DLog(@"provider members retain count: %d", [provider.friendlyName retainCount]);
        }
    }
    
    basicProviders = [[NSArray arrayWithArray:[jsonDict objectForKey:@"enabled_providers"]] retain];

    if (!allProviders || !basicProviders)
		return [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                     withCode:JRConfigurationInformationError
                  andSeverity:JRErrorSeverityConfigurationFailed];
    
#ifdef SOCIAL_PUBLISHING	    
    //socialProviders = [[NSArray arrayWithArray:[jsonDict objectForKey:@"social_providers"]] retain];

    NSMutableArray *temporaryArrayForTestingShouldBeRemoved = [[[NSMutableArray alloc] initWithArray:[jsonDict objectForKey:@"social_providers"]
                                                                                           copyItems:YES] autorelease];
    [temporaryArrayForTestingShouldBeRemoved addObject:@"yahoo"];
    socialProviders = [[NSArray arrayWithArray:temporaryArrayForTestingShouldBeRemoved] retain];
    
    if (!socialProviders)		
        return [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                                        withCode:JRConfigurationInformationError
                                     andSeverity:JRErrorSeverityConfigurationInformationMissing];
    
#endif
        
	if ([[jsonDict objectForKey:@"hide_tagline"] isEqualToString:@"YES"])
		hidePoweredBy = YES;
	else
		hidePoweredBy = NO;
	
#ifdef SOCIAL_PUBLISHING	
	[self loadLastUsedSocialProvider];
#endif
    
    [self loadLastUsedBasicProvider];
    
    return nil;
}

- (void)loadLastUsedSocialProvider
{
	DLog(@"");
    NSString *savedProvider = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastUsedSocialProvider"];
    
    if (savedProvider)
    {
        returningSocialProvider = [[allProviders objectForKey:savedProvider] retain];//[[[JRProvider alloc] initWithName:savedProvider 
                                                                                     //                         andStats:[providerInfo objectForKey:savedProvider]] retain];
    }
}

- (void)saveLastUsedSocialProvider:(NSString*)deviceToken
{
	DLog(@"");
    [returningSocialProvider release];
    returningSocialProvider = [currentSocialProvider retain];
    
    [[NSUserDefaults standardUserDefaults] setValue:returningSocialProvider.name forKey:@"lastUsedSocialProvider"];
}


- (void)loadLastUsedBasicProvider
{
	DLog(@"");
	NSHTTPCookieStorage* cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray *cookies = [cookieStore cookiesForURL:[NSURL URLWithString:baseUrl]];
	
	NSString *welcomeString = nil;
	NSString *savedProvider = nil;
	NSString *userInput = nil;
    
	for (NSHTTPCookie *cookie in cookies) 
	{
		if ([cookie.name isEqualToString:@"welcome_info"])
		{
			welcomeString = [NSString stringWithString:cookie.value];
			DLog(@"welcomeString: %@", welcomeString);
		}
		else if ([cookie.name isEqualToString:@"login_tab"])
		{
			savedProvider = [NSString stringWithString:cookie.value];
			DLog(@"provider:      %@", savedProvider);
		}
		else if ([cookie.name isEqualToString:@"user_input"])
		{
			userInput = [NSString stringWithString:cookie.value];
			DLog(@"userInput:     %@", userInput);
		}
	}	
	
	if (savedProvider)
	{
		DLog(@"returningProvider: %@", savedProvider);
		returningBasicProvider = [allProviders objectForKey:savedProvider];//[[JRProvider alloc] initWithName:savedProvider andStats:[providerInfo objectForKey:savedProvider]];
		
		if (welcomeString)
			returningBasicProvider.welcomeString = welcomeString;
		if (userInput)
			returningBasicProvider.userInput = userInput;
	}
    
    configurationComplete = YES;
}

- (void)saveLastUsedBasicProvider
{
    DLog(@"");
    
    // TODO: There is a problem here with timing.  That is, if I start auth again, before the previous
    //       auth_info call finishes, the returning provider will be set to the new provider.  Fix this.
    [self setReturningBasicProviderToNewBasicProvider:currentBasicProvider];
    
    NSHTTPCookieStorage *cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray *cookies = [cookieStore cookiesForURL:[NSURL URLWithString:baseUrl]];
	
	[cookieStore setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
	NSDate *date = [[[NSDate alloc] initWithTimeIntervalSinceNow:604800] autorelease];
	
	NSHTTPCookie *cookie = nil;
	NSRange found;
	NSString* cookieDomain = nil;
	
	found = [baseUrl rangeOfString:@"http://"];
	
	if (found.length == 0)
		found = [baseUrl rangeOfString:@"https://"];
    
	if (found.length == 0)
		cookieDomain = baseUrl;
	else
		cookieDomain = [baseUrl substringFromIndex:(found.location + found.length)];
	
	DLog("Setting cookie \"login_tab\" to value:  %@", self.returningBasicProvider.name);
	cookie = [NSHTTPCookie cookieWithProperties:
			  [NSDictionary dictionaryWithObjectsAndKeys:
			   self.returningBasicProvider.name, NSHTTPCookieValue,
			   @"login_tab", NSHTTPCookieName,
			   cookieDomain, NSHTTPCookieDomain,
			   @"/", NSHTTPCookiePath,
			   @"FALSE", NSHTTPCookieDiscard,
			   date, NSHTTPCookieExpires, nil]];
	[cookieStore setCookie:cookie];
	
	DLog("Setting cookie \"user_input\" to value: %@", self.returningBasicProvider.userInput);
	cookie = [NSHTTPCookie cookieWithProperties:
			  [NSDictionary dictionaryWithObjectsAndKeys:
			   self.returningBasicProvider.userInput, NSHTTPCookieValue,
			   @"user_input", NSHTTPCookieName,
			   cookieDomain, NSHTTPCookieDomain,
			   @"/", NSHTTPCookiePath,
			   @"FALSE", NSHTTPCookieDiscard,
			   date, NSHTTPCookieExpires, nil]];
	[cookieStore setCookie:cookie];
	
    
    // TODO: Why am I creating new cookies above (for "login_tab" and "user_input"), but replacing the "welcome_info" cookie here?
	for (NSHTTPCookie *savedCookie in cookies) 
	{
		if ([savedCookie.name isEqualToString:@"welcome_info"])
		{
			[returningBasicProvider setWelcomeString:[NSString stringWithString:savedCookie.value]];
		}
	}	    
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
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] forKey:@"authenticatedUsersByProvider"];
    //[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] forKey:@"authenticatedUsersByProvider"];
}

- (void)forgetAllAuthenticatedUsers
{
    DLog(@"");
    [authenticatedUsersByProvider removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] forKey:@"authenticatedUsersByProvider"];
    //[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] forKey:@"authenticatedUsersByProvider"];
}

- (void)shareActivity:(JRActivityObject*)_activity forUser:(JRAuthenticatedUser*)user
{
    NSDictionary *jsonDict = [[activity dictionaryForObject] retain];

    DLog(@"_activity retain count: %d", [_activity retainCount]);
    DLog(@"jsonDict retain count: %d", [jsonDict retainCount]);
    
    NSString *content = [[jsonDict objectForKey:@"activity"] JSONRepresentation];                          
    NSString *device_token = user.device_token;
    
    DLog(@"content retain count: %d", [content retainCount]);    
    DLog(@"device_token retain count: %d", [device_token retainCount]);
    
//    NSRange range = { 1, content.length-2 };
//    content = [content substringWithRange:range];

    DLog(@"json: %@", content);
    
    NSMutableData* body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"device_token=%@", device_token] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&activity=%@", content] dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest* request = [[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:@"https://rpxnow.com/api/v2/activity?"]] retain];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
    NSString* tag = [[NSString stringWithString:@"shareThis"] retain];
    
    [JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag];
    
    [request release];    
}

- (void)connectionDidFinishLoadingWithUnEncodedPayload:(NSData*)payload request:(NSURLRequest*)request andTag:(void*)userdata { }

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
	NSString* tag = (NSString*)userdata;
	[payload retain];
	
	DLog(@"payload: %@", payload);
	DLog(@"tag:     %@", tag);
	
	if ([tag isEqualToString:@"getConfiguredProviders"])
	{
		if ([payload rangeOfString:@"\"provider_info\":{"].length != 0)
		{
			error = [self finishGetConfiguredProviders:payload];
		}
		else // There was an error...
		{
			error = [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                          withCode:JRConfigurationInformationError
                       andSeverity:JRErrorSeverityConfigurationFailed];
		}
	}
    else if ([tag isEqualToString:@"getBaseURL"])
    {
        if ([payload hasPrefix:@"RPXNOW._base_cb(true"])
		{
			error = [self finishGetBaseUrl:payload];
		}
		else // There was an error...
		{
			error = [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                          withCode:JRConfigurationInformationError
                       andSeverity:JRErrorSeverityConfigurationFailed];
		}        
    }
	else if ([tag hasPrefix:@"token_url:"])
	{
		NSString* _tokenUrl = [NSString stringWithString:[[request URL] absoluteString]];
        
        if (!isSocial)
            [self saveLastUsedBasicProvider];
        
        for (id<JRSessionDelegate> delegate in delegates) 
        {
            [delegate authenticateDidReachTokenUrl:_tokenUrl withPayload:payload forProvider:currentProvider.name];
        }
	}
    else if ([tag isEqualToString:@"shareThis"])
    {
        NSRange subStr = [payload rangeOfString:@"\"stat\":\"ok\""];
        if (subStr.length)
        {
            for (id<JRSessionDelegate> delegate in delegates) 
            {
                [delegate publishingDidCompleteWithActivity:activity forProvider:currentProvider.name];
            }
        }
        else
        {
            for (id<JRSessionDelegate> delegate in delegates) 
            {
                [delegate publishingDidFailWithError:[self setError:[payload retain] 
                                                           withCode:3902302 
                                                        andSeverity:@"TODO CHANGE ME"] 
                                         forProvider:currentProvider.name];
            }
        }
    }
    
	[payload release];
	[tag release];	
}

- (void)connectionDidFailWithError:(NSError*)_error request:(NSURLRequest*)request andTag:(void*)userdata 
{
	NSString* tag = (NSString*)userdata;
	DLog(@"tag:     %@", tag);

	if ([tag isEqualToString:@"getBaseURL"])
	{
        error = [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                      withCode:JRConfigurationInformationError
                   andSeverity:JRErrorSeverityConfigurationFailed];
	}
	else if ([tag isEqualToString:@"getConfiguredProviders"])
	{
        error = [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                      withCode:JRConfigurationInformationError
                   andSeverity:JRErrorSeverityConfigurationFailed];
	}
    else if ([tag hasPrefix:@"token_url:"])
	{
		errorStr = [NSString stringWithFormat:@"There was an error posting the token to the token URL.\nThere was an error in the response to a request."];
		NSRange prefix = [tag rangeOfString:@"token_url:"];
		
		NSString *_tokenUrl = (prefix.length > 0) ? [tag substringFromIndex:prefix.length]: nil;
		
        for (id<JRSessionDelegate> delegate in delegates) 
        {
            [delegate authenticateCallToTokenUrl:_tokenUrl didFailWithError:_error forProvider:currentProvider.name];
        }
    }
    
	[tag release];	
}

- (void)connectionWasStoppedWithTag:(void*)userdata 
{
    DLog(@"");
    [(NSString*)userdata release];
}

- (BOOL)gatheringInfo
{
    DLog(@"");
    /* If we're authenticating with a provider for social publishing, then don't worry about the return experience
     * for basic authentication. */
    if (isSocial)
        return currentProvider.requiresInput;
    
    /* If we're authenticating with a basic provider, then we don't need to gather infomation if we're displaying 
     * return screen. */
    if ([currentProvider isEqualToProvider:returningBasicProvider])
        return NO;
    
    return currentProvider.requiresInput;
}

- (JRProvider*)getProviderAtIndex:(NSUInteger)index fromArray:(NSArray*)array
{
    DLog(@"");
    if (index < [array count])
    {
        return [allProviders objectForKey:[array objectAtIndex:index]];
        
//        return [[[JRProvider alloc] initWithName:[array objectAtIndex:index] 
//                                        andStats:[providerInfo objectForKey:[array objectAtIndex:index]]] autorelease];
    }
    
    return nil;
}

- (JRProvider*)getBasicProviderAtIndex:(NSUInteger)index
{
    DLog(@"");
    return [self getProviderAtIndex:index fromArray:basicProviders];
}

- (JRProvider*)getSocialProviderAtIndex:(NSUInteger)index
{
    DLog(@"");
    return [self getProviderAtIndex:index fromArray:socialProviders];
}

- (void)setReturningBasicProviderToNewBasicProvider:(JRProvider*)provider
{
	DLog(@"");
    
	[returningBasicProvider release];
	returningBasicProvider = [provider retain];
}

- (void)setCurrentBasicProviderToReturningProvider
{
	DLog(@"");
    isSocial = NO;
	currentProvider = currentBasicProvider = [returningBasicProvider retain];
}

- (void)setBasicProvider:(JRProvider*)provider
{
	DLog(@"provider: %@", provider);

	if (![currentBasicProvider isEqualToProvider:provider])
	{	
		[currentBasicProvider release];
		
		if ([returningBasicProvider isEqualToProvider:provider])
			[self setCurrentBasicProviderToReturningProvider];
		else
			currentBasicProvider = [provider retain];
	}

    isSocial = NO;
    currentProvider = currentBasicProvider;
}


- (void)setSocialProvider:(JRProvider*)provider
{
	DLog(@"provider: %@", provider);
    
	if (![currentSocialProvider isEqualToProvider:provider])
	{	
		[currentSocialProvider release];
		
        currentSocialProvider = [provider retain];
    }
    
    isSocial = YES;
    currentProvider = currentSocialProvider;
}

- (void)makeCallToTokenUrl:(NSString*)_tokenUrl withToken:(NSString *)token forProvider:(NSString*)provider
{
	DLog(@"token:    %@", token);
	DLog(@"tokenURL: %@", _tokenUrl);
	
	NSMutableData* body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest* request = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_tokenUrl]] retain];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:body];
	
	NSString* tag = [[NSString stringWithFormat:@"token_url:%@", _tokenUrl] retain];
	
	if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
	{
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Problem initializing connection to Token URL" 
                                                             forKey:NSLocalizedDescriptionKey];
        NSError *new_error = [NSError errorWithDomain:@"JRAuthenticate"
                                             code:100
                                         userInfo:userInfo];
		
        for (id<JRSessionDelegate> delegate in delegates) 
        {
            [delegate authenticateCallToTokenUrl:_tokenUrl didFailWithError:new_error forProvider:currentProvider.name];
        }
	}
	
	[request release];
}

- (void)makeCallToTokenUrlWithToken:(NSString*)token
{
	[self makeCallToTokenUrl:tokenUrl withToken:token forProvider:currentProvider.name];
}	

- (void)authenticationDidCancel
{
    DLog(@"");
    for (id<JRSessionDelegate> delegate in delegates) 
    {
        [delegate authenticationDidCancelForProvider:nil];
    }
}

- (void)authenticationDidCompleteWithPayload:(NSDictionary*)payloadDict forProvider:(JRProvider*)provider
{  
    NSDictionary *goodies = [[payloadDict objectForKey:@"rpx_result"] autorelease];
    NSString *token = [[goodies objectForKey:@"token"] retain];
    JRAuthenticatedUser *user = [[[JRAuthenticatedUser alloc] initUserWithDictionary:goodies
                                                                    forProviderNamed:provider.name] autorelease];    
    [authenticatedUsersByProvider setObject:user forKey:provider.name];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] 
                                              forKey:@"authenticatedUsersByProvider"];
    //[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] forKey:@"authenticatedUsersByProvider"];

    
    for (id<JRSessionDelegate> delegate in delegates) 
    {
        [delegate authenticationDidCompleteWithToken:token forProvider:provider.name];
    }
        
	if (tokenUrl)
        [self makeCallToTokenUrl:tokenUrl withToken:token forProvider:provider.name];
    
}

- (void)authenticationDidCompleteWithToken:(NSString*)token
{	
    DLog(@"");
//	token = [tok retain];
	
//	[self setReturningProviderToProvider:self.currentProvider];
    for (id<JRSessionDelegate> delegate in delegates) 
    {
        [delegate authenticationDidCompleteWithToken:token forProvider:currentProvider.name];
    }
}

- (void)authenticationDidCompleteWithAuthenticationToken:(NSString*)authenticationToken andDeviceToken:(NSString*)deviceToken
{
	DLog(@"");
    [self saveLastUsedSocialProvider:deviceToken];
    
//    if (!authenticatedUsersByProvider)
//        authenticatedUsersByProvider = [[NSMutableDictionary alloc] initWithCapacity:1];
//    
//    [authenticatedUsersByProvider setObject:deviceToken forKey:currentProvider.name];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] forKey:@"authenticatedUsersByProvider"];
    //[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] forKey:@"authenticatedUsersByProvider"];
    
    [self authenticationDidCompleteWithToken:authenticationToken];
}

- (void)authenticationDidFailWithError:(NSError*)_error
{
    DLog(@"");
    for (id<JRSessionDelegate> delegate in delegates) 
    {
        [delegate authenticationDidFailWithError:_error forProvider:currentProvider.name];
    }
}

@end
