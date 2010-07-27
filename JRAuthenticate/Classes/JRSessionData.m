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

@interface JRProvider ()
@property (readonly) NSString *open_identifier;
@property (readonly) NSString *url;
@end

@implementation JRProvider

- (JRProvider*)initWithName:(NSString*)_name andStats:(NSDictionary*)_stats
{
	DLog(@"");
	
	if (_name == nil || _name.length == 0 || _stats == nil)
	{
		[self release];
		return nil;
	}
	
	if (self = [super init]) 
	{
		providerStats = [[NSDictionary dictionaryWithDictionary:_stats] retain];
		name = [_name retain];
	}
	
	return self;
}

- (BOOL)isEqualToProvider:(JRProvider*)provider
{
    if ([self.name isEqualToString:provider.name])
        return YES;
    
    return NO;
}

- (NSString*)name
{
	return name;
}

- (NSString*)friendlyName 
{
	return [providerStats objectForKey:@"friendly_name"];
}

- (NSString*)placeholderText
{
	return [providerStats objectForKey:@"input_prompt"];
}

- (NSString*)shortText
{
	if (self.providerRequiresInput)
	{
		NSArray *arr = [[self.placeholderText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@" "];
		NSRange subArr = {[arr count] - 2, 2};
		
		NSArray *newArr = [arr subarrayWithRange:subArr];
		return [newArr componentsJoinedByString:@" "];	
	}
	else 
	{
		return @"";
	}
}

- (NSString*)userInput
{
	return userInput;
}

- (void)setUserInput:(NSString*)ui
{
	userInput = [ui retain];
}

- (void)setWelcomeString:(NSString*)ws
{
	welcomeString = [ws retain];
}

- (NSString*)welcomeString
{
	return welcomeString;
}

- (NSString*)open_id
{
    return [providerStats objectForKey:@"open_identifier"];
}

- (NSString*)url
{
    return [providerStats objectForKey:@"url"]; 
}

- (BOOL)providerRequiresInput
{
	if ([[providerStats objectForKey:@"requires_input"] isEqualToString:@"YES"])
		 return YES;
		
	return NO;
}

- (void)dealloc
{
	DLog(@"");
		
	[providerStats release];
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
@synthesize providerInfo;
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
@synthesize forceReauth;
@synthesize error;
@synthesize customView;
@synthesize customProvider;

- (id)initWithAppId:(NSString*)_appId /*tokenUrl:(NSString*)tokUrl*/ andDelegate:(id<JRSessionDelegate>)_delegate
{
	DLog(@"");
	
	if (_appId == nil || _appId.length == 0)
	{
		[self release];
		return nil;
	}
	
	if (self = [super init]) 
	{
        delegates = [[NSMutableArray alloc] initWithObjects:[_delegate retain], nil];

		appId = _appId;
        
        deviceTokensByProvider = [[NSMutableDictionary alloc] 
                                  initWithDictionary:[[NSUserDefaults standardUserDefaults] 
                                        objectForKey:@"deviceTokensByProvider"]];
        
        error = [self startGetBaseUrl];
	}
	return self;
}

- (void)dealloc 
{
	DLog(@"");
		
	[providerInfo release];
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
    NSDictionary *userInfo = [[NSDictionary dictionaryWithObjectsAndKeys:
                               message, NSLocalizedDescriptionKey,
                               severity, @"severity", nil] autorelease];

    return [[NSError alloc] initWithDomain:@"JRAuthenticate"
                                      code:code
                                  userInfo:userInfo];
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

- (NSURL*)startURL
{
	DLog(@"");
    
//    NSDictionary *providerStats = [providerInfo objectForKey:currentProvider.name];
	NSMutableString *oid;
	
	if (currentProvider.open_id)//([providerStats objectForKey:@"openid_identifier"])
	{
		oid = [NSMutableString stringWithFormat:@"openid_identifier=%@&", currentProvider.open_id];//[NSString stringWithString:[providerStats objectForKey:@"openid_identifier"]]]; //[NSMutableString stringWithString:[providerStats objectForKey:@"openid_identifier"]];
		
		if(currentProvider.providerRequiresInput)
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
    	
//	[request release];
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
    
//	NSUInteger length = [baseUrl length];
//	unichar endChar = [baseUrl characterAtIndex:(length - 1)];
//	if (endChar == '/') 
//	{ // TODO: Use stringTrim function instead
//		baseUrl = [[baseUrl stringByReplacingCharactersInRange:NSMakeRange ((length - 1), 1) withString:@""] retain];
//	}

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
//	[request release];
}

- (void)finishGetConfiguredProviders:(NSString*)dataStr
{
	DLog(@"");
	NSDictionary *jsonDict = [dataStr JSONValue];
	
	if(!jsonDict)
		return [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                     withCode:JRJsonError
                  andSeverity:JRErrorSeverityConfigurationFailed];
	
	providerInfo   = [[NSDictionary dictionaryWithDictionary:[jsonDict objectForKey:@"provider_info"]] retain];
    basicProviders = [[NSArray arrayWithArray:[jsonDict objectForKey:@"enabled_providers"]] retain];

    if (!providerInfo || !basicProviders)
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
#else
    return [self loadLastUsedBasicProvider];
#endif
    
    return nil;
}

- (void)loadLastUsedSocialProvider
{
	DLog(@"");
    NSString *savedProvider = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastUsedSocialProvider"];
    
    if (savedProvider)
    {
        returningSocialProvider = [[[JRProvider alloc] initWithName:savedProvider 
                                                           andStats:[providerInfo objectForKey:savedProvider]] retain];
    }
    
    [self loadLastUsedBasicProvider];    
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
		returningBasicProvider = [[JRProvider alloc] initWithName:savedProvider andStats:[providerInfo objectForKey:savedProvider]];
		
		if (welcomeString)
			[returningBasicProvider setWelcomeString:welcomeString];
		if (userInput)
			[returningBasicProvider setUserInput:userInput];
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

- (NSString*)identifierForProvider:(NSString*)provider
{
    DLog(@"");
    return [identifiersProviders objectForKey:provider];
}

- (NSString*)deviceTokenForProvider:(NSString*)provider
{
    DLog(@"");
    return [deviceTokensByProvider objectForKey:provider];
}

- (void)forgetDeviceTokenForProvider:(NSString*)provider
{
    DLog(@"");
    [deviceTokensByProvider removeObjectForKey:@"provider"];
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokensByProvider forKey:@"deviceTokensByProvider"];
}

- (void)forgetAllDeviceTokens
{
    DLog(@"");
    [deviceTokensByProvider release];
    deviceTokensByProvider = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"deviceTokensByProvider"];
}

// TODO: Many issues with this function, like timing of cookies/calls/etc/
- (void)checkForIdentifierCookie:(NSURLRequest*)request
{
    DLog(@"");
    NSHTTPCookieStorage* cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray *cookies = [cookieStore cookiesForURL:[request URL]];//[NSURL URLWithString:@"http://jrauthenticate.appspot.com"]];
	NSString *cookieIdentifier = nil;
//	NSString *test = [request valueForHTTPHeaderField:@"sid"];
    
	for (NSHTTPCookie *cookie in cookies) 
	{
		if ([cookie.name isEqualToString:@"sid"])
		{
			cookieIdentifier = [[NSString stringWithString:cookie.value] 
								stringByTrimmingCharactersInSet:
								[NSCharacterSet characterSetWithCharactersInString:@"\""]];
		}
	}	
    
    if (currentSocialProvider)
    {
        if (!identifiersProviders)
            identifiersProviders = [[NSMutableDictionary alloc] initWithObjectsAndKeys:cookieIdentifier, currentSocialProvider.name, nil];
        else
            [identifiersProviders setObject:cookieIdentifier forKey:currentSocialProvider.name];
        
        if (!deviceTokensByProvider)
            deviceTokensByProvider = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        [deviceTokensByProvider setObject:cookieIdentifier forKey:currentSocialProvider.name];
        [[NSUserDefaults standardUserDefaults] setObject:deviceTokensByProvider forKey:@"deviceTokensByProvider"];
    }
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
//		theTokenUrlPayload = [[NSString stringWithString:payload] retain];
		NSString* tokenURL = [NSString stringWithString:[[request URL] absoluteString]];
        
        if (!isSocial)
            [self saveLastUsedBasicProvider];
        else
            [self checkForIdentifierCookie:request];
        
        for (id<JRSessionDelegate> delegate in delegates) 
        {
            [delegate jrAuthenticateDidReachTokenURL:tokenURL withPayload:payload];
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
		
		NSString *tokenURL = (prefix.length > 0) ? [tag substringFromIndex:prefix.length]: nil;
		
        for (id<JRSessionDelegate> delegate in delegates) 
        {
            [delegate jrAuthenticateCallToTokenURL:tokenURL didFailWithError:_error];
        }
    }
    
	[tag release];	
}

- (void)connectionWasStoppedWithTag:(void*)userdata 
{
    DLog(@"");
    [(NSString*)userdata release];
}

- (JRProvider*)getProviderAtIndex:(NSUInteger)index fromArray:(NSArray*)array
{
    DLog(@"");
    if (index < [array count])
    {
        return [[[JRProvider alloc] initWithName:[array objectAtIndex:index] 
                                        andStats:[providerInfo objectForKey:[array objectAtIndex:index]]] autorelease];
    }
    
    return nil;
}

- (BOOL)gatheringInfo
{
    DLog(@"");
    /* If we're authenticating with a provider for social publishing, then don't worry about the return experience
     * for basic authentication. */
    if (isSocial)
        return currentProvider.providerRequiresInput;
    
    /* If we're authenticating with a basic provider, then we don't need to gather infomation if we're displaying 
     * return screen. */
    if ([currentProvider isEqualToProvider:returningBasicProvider])
        return NO;
    
    return currentProvider.providerRequiresInput;
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

- (void)makeCallToTokenUrl:(NSString*)tokenURL WithToken:(NSString *)token
{
	DLog(@"token:    %@", token);
	DLog(@"tokenURL: %@", tokenURL);
	
	NSMutableData* body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest* request = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:tokenURL]] retain];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:body];
	
	NSString* tag = [[NSString stringWithFormat:@"token_url:%@", tokenURL] retain];
	
	if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
	{
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Problem initializing connection to Token URL" 
                                                             forKey:NSLocalizedDescriptionKey];
        NSError *new_error = [NSError errorWithDomain:@"JRAuthenticate"
                                             code:100
                                         userInfo:userInfo];
		
        for (id<JRSessionDelegate> delegate in delegates) 
        {
            [delegate jrAuthenticateCallToTokenURL:tokenURL didFailWithError:new_error];
        }
	}
	
	[request release];
}

//- (void)makeCallToTokenUrlWithToken:(NSString*)token
//{
//	[self makeCallToTokenUrl:theTokenUrl WithToken:token];
//}	

- (void)authenticationDidCancel
{
    DLog(@"");
    for (id<JRSessionDelegate> delegate in delegates) 
    {
        [delegate jrAuthenticationDidCancel];
    }
}

- (void)authenticationDidCompleteWithToken:(NSString*)token
{	
    DLog(@"");
//	token = [tok retain];
	
//	[self setReturningProviderToProvider:self.currentProvider];
    for (id<JRSessionDelegate> delegate in delegates) 
    {
        [delegate jrAuthenticationDidCompleteWithToken:token andProvider:currentProvider.name];
    }
}

- (void)authenticationDidCompleteWithAuthenticationToken:(NSString*)authenticationToken andDeviceToken:(NSString*)deviceToken
{
	DLog(@"");
    [self saveLastUsedSocialProvider:deviceToken];
    
    if (!deviceTokensByProvider)
        deviceTokensByProvider = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    [deviceTokensByProvider setObject:deviceToken forKey:currentProvider.name];
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokensByProvider forKey:@"deviceTokensByProvider"];   
    
    [self authenticationDidCompleteWithToken:authenticationToken];
}

- (void)authenticationDidFailWithError:(NSError*)_error
{
    DLog(@"");
    for (id<JRSessionDelegate> delegate in delegates) 
    {
        [delegate jrAuthenticationDidFailWithError:_error];
    }
}

@end
