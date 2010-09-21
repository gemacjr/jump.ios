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
  
    if (dictionary == nil || _provider_name == nil || [dictionary objectForKey:@"device_token"] == (CFStringRef*)kCFNull)
	{
		[self release];
		return nil;
	}
	
	if (self = [super init]) 
	{
        provider_name = [[NSString alloc] initWithFormat:@"%@", _provider_name];
        
        if ([dictionary objectForKey:@"photo"] != kCFNull)
            photo = [[dictionary objectForKey:@"photo"] retain];

        if ([dictionary objectForKey:@"preferred_username"] != kCFNull)
            preferred_username = [[dictionary objectForKey:@"preferred_username"] retain];
        
        device_token = [[dictionary objectForKey:@"device_token"] retain];
    }
	
//    DLog(@"JRAuthenticatedUser retain count:      %d", [self retainCount]);
//    DLog(@"    JRAuthenticatedUser provider_name: %d", [self.provider_name retainCount]);
//    DLog(@"    JRAuthenticatedUser photo:         %d", [self.photo retainCount]);
//    DLog(@"    JRAuthenticatedUser username:      %d", [self.preferred_username retainCount]);
//    DLog(@"    JRAuthenticatedUser device_token:  %d", [self.device_token retainCount]);
    
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
	DLog(@"");
   
    [coder encodeObject:provider_name forKey:@"provider_name"];
    [coder encodeObject:photo forKey:@"photo"];
    [coder encodeObject:preferred_username forKey:@"preferred_username"];
    [coder encodeObject:device_token forKey:@"device_token"];
}

- (id)initWithCoder:(NSCoder *)coder;
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

//    DLog(@"JRAuthenticatedUser retain count:      %d", [self retainCount]);
//    DLog(@"    JRAuthenticatedUser provider_name: %d", [self.provider_name retainCount]);
//    DLog(@"    JRAuthenticatedUser photo:         %d", [self.photo retainCount]);
//    DLog(@"    JRAuthenticatedUser username:      %d", [self.preferred_username retainCount]);
//    DLog(@"    JRAuthenticatedUser device_token:  %d", [self.device_token retainCount]);
    
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
            shortText = [[newArr componentsJoinedByString:@" "] retain];	
        }
        else 
        {
            shortText = @"";
        }
    }
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
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

- (id)initWithCoder:(NSCoder *)coder;
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
	[welcomeString release];
	[userInput release];
	
	[super dealloc];
}
@end

@interface JRSessionData()
- (NSError*)startGetBaseUrl;
- (NSError*)startGetConfiguredProviders;
//- (NSError*)finishGetConfiguredProviders:(NSString*)dataStr;
- (NSError*)startGetConfiguration;
- (void)loadLastUsedBasicProvider;
- (void)loadLastUsedSocialProvider;
@end

@implementation JRSessionData
@synthesize configurationComplete;

//@synthesize allProviders;
//@synthesize basicProviders;
//@synthesize socialProviders;

@synthesize currentProvider;
@synthesize returningBasicProvider;
@synthesize returningSocialProvider;

@synthesize activity;

//@synthesize baseUrl;
@synthesize tokenUrl;
@synthesize forceReauth;

@synthesize social;
@synthesize error;

//@synthesize hidePoweredBy;
@synthesize customView;
@synthesize customProvider;


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

        NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"JREngage.bundle"];//[[[NSFileManager defaultManager] currentDirectoryPath]
                         // stringByAppendingPathComponent: path];
        
        DLog(@"current directory path: %@", path);

        NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:error];
        for (NSString *item in contents)
        {
            DLog(@"item: %@", item);
        }
        
        singleton = self;
        
        delegates = [[NSMutableArray alloc] initWithObjects:[_delegate retain], nil];
		appId = _appId;
        tokenUrl = _tokenUrl;
        
        configurationSemaphore = [[NSObject alloc] init];
        
        NSData *archivedUsers = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRAuthenticatedUsersByProvider"];
        if (archivedUsers != nil)
        {
            NSDictionary *unarchivedUsers = [NSKeyedUnarchiver unarchiveObjectWithData:archivedUsers];
            if (unarchivedUsers != nil)
                authenticatedUsersByProvider = [[NSMutableDictionary alloc] initWithDictionary:unarchivedUsers];
        }
        
        if (!authenticatedUsersByProvider)
            authenticatedUsersByProvider = [[NSMutableDictionary alloc] initWithCapacity:1];

        NSData *archivedProviders = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRAllProviders"];
        if (archivedProviders != nil)
        {
            NSDictionary *unarchivedProviders = [NSKeyedUnarchiver unarchiveObjectWithData:archivedProviders];
            if (unarchivedProviders != nil)
                allProviders = [[NSMutableDictionary alloc] initWithDictionary:unarchivedProviders];
        }
        
        NSData *archivedBasicProviders = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRBasicProviders"];
        if (archivedBasicProviders != nil)
        {
            NSArray *unarchivedBasicProviders = [NSKeyedUnarchiver unarchiveObjectWithData:archivedBasicProviders];
            if (unarchivedBasicProviders != nil)
                basicProviders = [[NSArray alloc] initWithArray:unarchivedBasicProviders];
        }
        
        NSData *archivedSocialProviders = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRSocialProviders"];
        if (archivedSocialProviders != nil)
        {
            NSArray *unarchivedSocialProviders = [NSKeyedUnarchiver unarchiveObjectWithData:archivedSocialProviders];
            if (unarchivedSocialProviders != nil)
                socialProviders = [[NSArray alloc] initWithArray:unarchivedSocialProviders];
        }

        baseUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"JRBaseUrl"];
        hidePoweredBy = [[NSUserDefaults standardUserDefaults] boolForKey:@"JRHidePoweredBy"];
                
        // TODO: These are going to get called twice if we call them at the end of the configuration calls. Figure out
        // the most optimal solution for this...
        if (baseUrl && allProviders)
        {
            [self loadLastUsedBasicProvider];
            [self loadLastUsedSocialProvider];
        }
        
        // TODO: Do we want to call this every time?  What if these values change while a user is trying to authenticate?
        error = [self startGetBaseUrl];
        //error = [self startGetConfiguration];
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

- (void)dealloc 
{
	DLog(@"");
	
	@synchronized (configurationSemaphore)
    {
        [allProviders release];
        [basicProviders release];
        
        [currentProvider release];
        [returningBasicProvider release];
        [returningSocialProvider release];
        
        [baseUrl release];
    }

    [error release];
	[delegates release];
	
	[super dealloc];
}

- (void)reconfigure
{
    DLog(@"");
    error = [self startGetBaseUrl];
}

- (void)addDelegate:(id<JRSessionDelegate>)_delegate
{
	DLog(@"");
    @synchronized (delegates)
    {
        [delegates addObject:_delegate];
    }
}

- (void)removeDelegate:(id<JRSessionDelegate>)_delegate
{
	DLog(@"");
    @synchronized (delegates)
    {
        [delegates removeObject:_delegate];
    }
}

- (NSString*)baseUrl
{
//    DLog(@"");
    @synchronized (configurationSemaphore)
    {
        return baseUrl;
    }
}

- (NSDictionary*)allProviders
{
    DLog(@"");
    @synchronized (configurationSemaphore)
    {
        return allProviders;
    }
}

- (NSArray*)basicProviders
{
    DLog(@"");
    @synchronized (configurationSemaphore)
    {
        return basicProviders;
    }
}

- (NSArray*)socialProviders
{
    DLog(@"");
    @synchronized (configurationSemaphore)
    {
        return socialProviders;
    }
}

- (BOOL)hidePoweredBy
{
    DLog(@"");
    @synchronized (configurationSemaphore)
    {
        return hidePoweredBy;
    }
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

- (NSURL*)startUrl
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
        str = [NSString stringWithFormat:@"%@%@?%@%@%@device=iphone", 
                         baseUrl, 
                         currentProvider.url,
                         oid, // TODO: Always force reauth for social because there isn't a "force reauth" button
                         ((forceReauth) ? @"force_reauth=true&" : @""), // available and sometimes cookies take over?
                         (([currentProvider.name isEqualToString:@"facebook"]) ? 
                          @"ext_perm=publish_stream&" : @"")];
    else
        str = [NSString stringWithFormat:@"%@%@?%@%@device=iphone", 
                         baseUrl, 
                         currentProvider.url,
                         oid, 
                         ((forceReauth) ? @"force_reauth=true&" : @"")];
#else
        str = [NSString stringWithFormat:@"%@%@?%@%@device=iphone", 
                         baseUrl, 
                         currentProvider.url,
                         oid, 
                         ((forceReauth) ? @"force_reauth=true&" : @"")];    
#endif

	forceReauth = NO;
	
	DLog(@"startURL: %@", str);
	return [NSURL URLWithString:str];
}

- (NSError*)startGetBaseUrl
{	
    DLog(@"");
#if LOCAL 
	NSString *urlString = [NSString stringWithFormat:
                           @"http://lillialexis.janrain.com:8080/jsapi/v3/base_url?appId=%@&skipXdReceiver=true", 
                           @"dgnclgmgpcjmdebbhkhf"];
#else
	NSString *urlString = [NSString stringWithFormat:
                           @"http://rpxnow.com/jsapi/v3/base_url?appId=%@&skipXdReceiver=true", 
                           appId];
#endif

    DLog(@"url: %@", urlString);
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	if(!url)
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

	NSString *str = [arr objectAtIndex:1];
	str = [str stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
    
    /* If the baseUrl that we pulled out of the standardUserDefaults is different than the one we just received from the server */
    if (![str isEqualToString:baseUrl]) 
    {
        // TODO: Do we need to notify the library that this changed?
        @synchronized (configurationSemaphore)
        {
            [baseUrl release];
            baseUrl = [[NSString stringWithString:str] retain];
            
            [[NSUserDefaults standardUserDefaults] setValue:baseUrl forKey:@"JRBaseUrl"];
        }
    }
    
    return [self startGetConfiguredProviders];
}


- (NSError*)startGetConfiguredProviders
{
	DLog(@"");

	NSString *urlString = [baseUrl stringByAppendingString:@"/openid/iphone_config"];
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	if(!url)
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
    
    BOOL reloadConfiguration = NO;
    
    for (NSString *name in [providerInfo allKeys])
    {
        if (![allProviders objectForKey:name]) 
        {
            reloadConfiguration = YES;
            break;
        }
    }
    
    if (reloadConfiguration)
    {
        @synchronized (configurationSemaphore)
        {
            allProviders = [[NSMutableDictionary alloc] initWithCapacity:[[providerInfo allKeys] count]];
            
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
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:allProviders] 
                                                      forKey:@"JRAllProviders"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:basicProviders] 
                                                      forKey:@"JRBasicProviders"];
            
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
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:socialProviders] 
                                                      forKey:@"JRSocialProviders"];
            
            if ([[jsonDict objectForKey:@"hide_tagline"] isEqualToString:@"YES"])
                hidePoweredBy = YES;
            else
                hidePoweredBy = NO;
        
            [[NSUserDefaults standardUserDefaults] setBool:hidePoweredBy forKey:@"JRHidePoweredBy"];
        }
    }


#ifdef SOCIAL_PUBLISHING	
	[self loadLastUsedSocialProvider];
#endif
    
    [self loadLastUsedBasicProvider];
    
    return nil;
}

- (NSError*)startGetConfiguration
{	
    DLog(@"");
#define STAGING
#ifdef STAGING
	NSString *urlString = [NSString stringWithFormat:
                           @"http://rpxstaging.com/openid/iphone_config_and_baseurl?appId=%@&skipXdReceiver=true", 
                           @"kcemlogaanidnljknmbj"];
    tokenUrl = nil;
#else
	NSString *urlString = [NSString stringWithFormat:
                           @"http://rpxnow.com/jsapi/v3/base_url?appId=%@&skipXdReceiver=true", 
                           appId];
#endif
    
    DLog(@"url: %@", urlString);
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	if(!url)
		return [self setError:@"There was a problem connecting to the Janrain server while configuring authentication." 
                     withCode:JRUrlError 
                  andSeverity:JRErrorSeverityConfigurationFailed];
    
	NSURLRequest *request = [[[NSURLRequest alloc] initWithURL: url] autorelease];
	
	NSString *tag = [[NSString alloc] initWithFormat:@"getConfiguration"];
	
	if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
		return [self setError:@"There was a problem connecting to the Janrain server while configuring authentication." 
                     withCode:JRUrlError 
                  andSeverity:JRErrorSeverityConfigurationFailed];
    
    return nil;
}


- (NSError*)finishGetConfiguration:(NSString*)dataStr
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
	
    // TODO: Error check this
    if (![[jsonDict objectForKey:@"baseurl"] isEqualToString:baseUrl])
        baseUrl = [[[jsonDict objectForKey:@"baseurl"] 
                    stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]] retain];
        
    [[NSUserDefaults standardUserDefaults] setValue:baseUrl forKey:@"JRBaseUrl"];
    
	NSDictionary *providerInfo   = [NSDictionary dictionaryWithDictionary:[jsonDict objectForKey:@"provider_info"]];
    
    DLog(@"providerInfo retain count: %d", [providerInfo retainCount]);
    
    BOOL reloadConfiguration = YES;//NO;
    
// TODO: Rewrite to use e-tag to compare new data with cached data in case anything changes
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
        @synchronized (configurationSemaphore)
        {
            allProviders = [[NSMutableDictionary alloc] initWithCapacity:[[providerInfo allKeys] count]];
            
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
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:allProviders] 
                                                      forKey:@"JRAllProviders"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:basicProviders] 
                                                      forKey:@"JRBasicProviders"];
            
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
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:socialProviders] 
                                                      forKey:@"JRSocialProviders"];
            
            if ([[jsonDict objectForKey:@"hide_tagline"] isEqualToString:@"YES"])
                hidePoweredBy = YES;
            else
                hidePoweredBy = NO;
            
            [[NSUserDefaults standardUserDefaults] setBool:hidePoweredBy forKey:@"JRHidePoweredBy"];
        }
    }
    
    
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
        returningSocialProvider = [[allProviders objectForKey:savedProvider] retain];
}

- (void)saveLastUsedSocialProvider
{
	DLog(@"");
    [returningSocialProvider release];
    returningSocialProvider = [currentProvider retain];
    
    [[NSUserDefaults standardUserDefaults] setValue:returningSocialProvider.name forKey:@"lastUsedSocialProvider"];
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


- (void)loadLastUsedBasicProvider
{
    DLog(@"");
    
    if (!baseUrl)
        return;
    
	NSHTTPCookieStorage* cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStore cookiesForURL:[NSURL URLWithString:baseUrl]];
	
	NSString *providerName = nil;
	NSString *welcomeString = nil;
	NSString *userInput = nil;
    
	for (NSHTTPCookie *cookie in cookies) 
	{
		if ([cookie.name isEqualToString:@"login_tab"])
		{
			providerName = [NSString stringWithString:cookie.value];
			DLog(@"provider:      %@", providerName);
		}
		else if ([cookie.name isEqualToString:@"welcome_info"])
		{
			welcomeString = [NSString stringWithString:cookie.value];
			DLog(@"welcomeString: %@", welcomeString);
		}
		else if ([cookie.name isEqualToString:@"user_input"])
		{
			userInput = [NSString stringWithString:cookie.value];
			DLog(@"userInput:     %@", userInput);
		}
	}	
	
	if (providerName)
	{
		DLog(@"returningProvider: %@", providerName);
		returningBasicProvider = [[allProviders objectForKey:providerName] retain];
		
		if (welcomeString)
			returningBasicProvider.welcomeString = [self getWelcomeMessageFromCookieString:welcomeString];
		if (userInput)
			returningBasicProvider.userInput = userInput;
	}
    
      configurationComplete = YES;  
}

- (void)saveLastUsedBasicProvider
{
    DLog(@"");
    
    [returningBasicProvider release];
    returningBasicProvider = [currentProvider retain];
    
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
	    
	for (NSHTTPCookie *savedCookie in cookies) 
	{
		if ([savedCookie.name isEqualToString:@"welcome_info"])
		{
			[returningBasicProvider setWelcomeString:[self getWelcomeMessageFromCookieString:savedCookie.value]];
		}
	}	    
}

- (JRAuthenticatedUser*)authenticatedUserForProvider:(JRProvider*)provider
{
    DLog(@"");
    @synchronized (authenticatedUsersByProvider)
    {
        return [authenticatedUsersByProvider objectForKey:provider.name];
    }
}


- (void)forgetAuthenticatedUserForProvider:(NSString*)provider
{
    DLog(@"");
    @synchronized (authenticatedUsersByProvider)
    {
        [authenticatedUsersByProvider removeObjectForKey:provider];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] 
                                                  forKey:@"JRAuthenticatedUsersByProvider"];
    }
}

- (void)forgetAllAuthenticatedUsers
{
    DLog(@"");
    @synchronized (authenticatedUsersByProvider)
    {
        [authenticatedUsersByProvider removeAllObjects];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] 
                                                  forKey:@"JRAuthenticatedUsersByProvider"];
    }
}

- (void)shareActivity:(JRActivityObject*)_activity forUser:(JRAuthenticatedUser*)user
{
    DLog(@"");
    NSDictionary *activityDictionary = [activity dictionaryForObject];
    
//    DLog(@"_activity retain count: %d", [_activity retainCount]);
//    DLog(@"jsonDict retain count: %d", [jsonDict retainCount]);
    
    NSString *activityContent = [[activityDictionary objectForKey:@"activity"] JSONRepresentation];                          
    NSString *deviceToken = user.device_token;
    
//    DLog(@"content retain count: %d", [content retainCount]);    
//    DLog(@"device_token retain count: %d", [device_token retainCount]);
//    
//    DLog(@"json: %@", content);
    
    NSMutableData* body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"device_token=%@", deviceToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&activity=%@", activityContent] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&options={\"urlShortening\":\"true\"}"] dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest* request = [[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:@"https://rpxnow.com/api/v2/activity?"]] retain];
    
    DLog("Share activity request: %@ and body: %s", [[request URL] absoluteString], body.bytes);
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
    NSString* tag = [[NSString stringWithString:@"shareThis"] retain];
    
    [JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag];
    
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
            @synchronized (delegates)
            {
                NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
                for (id<JRSessionDelegate> delegate in delegatesCopy) 
                {
                    [delegate authenticateDidReachTokenUrl:[(NSDictionary*)tag objectForKey:@"tokenUrl"] 
                                               withPayload:payload 
                                               forProvider:[(NSDictionary*)tag objectForKey:@"providerName"]];
                }
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
        if ([(NSString*)tag isEqualToString:@"getConfiguredProviders"])
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
        else if ([(NSString*)tag isEqualToString:@"getBaseURL"])
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
        else if ([(NSString*)tag isEqualToString:@"getConfiguration"])
        {
            if ([payload rangeOfString:@"\"provider_info\":{"].length != 0)
            {
                error = [self finishGetConfiguration:payload];
            }
            else // There was an error...
            {
                error = [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                              withCode:JRConfigurationInformationError
                           andSeverity:JRErrorSeverityConfigurationFailed];
            }
        }
        else if ([(NSString*)tag isEqualToString:@"shareThis"]) // TODO: Change "shareThis" to something better
        {
            NSDictionary *response_dict = [payload JSONValue];
            
            if (!response_dict)
            {
                @synchronized (delegates)
                {
                    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
                    for (id<JRSessionDelegate> delegate in delegatesCopy) 
                    {
                        [delegate publishingActivity:activity
                                    didFailWithError:[self setError:[payload retain] 
                                                           withCode:JRPublishFailedError 
                                                        andSeverity:JRErrorSeverityPublishFailed]];
                        
                    }
                }
            }
            if ([[response_dict objectForKey:@"stat"] isEqualToString:@"ok"])
            {
                [self saveLastUsedSocialProvider];
                @synchronized (delegates)
                {
                    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
                    for (id<JRSessionDelegate> delegate in delegatesCopy) 
                    {
                        [delegate publishingActivityDidSucceed:activity forProvider:currentProvider.name];
                    }
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
                                      andSeverity:JRErrorSeverityPublishFailed];
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
                                              andSeverity:JRErrorSeverityPublishNeedsReauthentication];
                            break;
                        case 4: /* "Facebook Error: Invalid OAuth 2.0 Access Token" */
                            publishError = [self setError:[error_dict objectForKey:@"msg"] 
                                                 withCode:JRPublishErrorInvalidOauthToken 
                                              andSeverity:JRErrorSeverityPublishNeedsReauthentication];
                            break;
                        case 100: // TODO LinkedIn character limit error
                            publishError = [self setError:[error_dict objectForKey:@"msg"] 
                                                 withCode:JRPublishErrorLinkedInCharacterExceded
                                              andSeverity:JRErrorSeverityPublishInvalidActivity];
                            break;
                        case 6: // TODO Twitter duplicate error
                            publishError = [self setError:[error_dict objectForKey:@"msg"] 
                                                 withCode:JRPublishErrorDuplicateTwitter
                                              andSeverity:JRErrorSeverityPublishInvalidActivity];
                            break;
                        case 1000: /* Extracting code failed; Fall through. */
                        default: // TODO Other errors (find them)
                            publishError = [self setError:@"There was a problem publishing this activity" 
                                                 withCode:JRPublishFailedError 
                                              andSeverity:JRErrorSeverityPublishFailed];
                            break;
                    }
                }
                
                @synchronized (delegates)
                {
                    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
                    for (id<JRSessionDelegate> delegate in delegatesCopy) 
                    {
                        [delegate publishingActivity:activity
                                    didFailWithError:publishError];
                                     
                    }
                }
            }
        }
    }
//    else if ([tag isKindOfClass:[NSDictionary class]])
//    {
//        if ([(NSDictionary*)tag objectForKey:@"tokenUrl"])
//        {
//            @synchronized (delegates)
//            {
//                NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
//                for (id<JRSessionDelegate> delegate in delegatesCopy) 
//                {
//                    [delegate authenticateDidReachTokenUrl:[(NSDictionary*)tag objectForKey:@"tokenUrl"] 
//                                               withPayload:payload 
//                                               forProvider:[(NSDictionary*)tag objectForKey:@"providerName"]];
//                }
//            }
//        }
//    }
    
	[payload release];
	[tag release];	
}

- (void)connectionDidFailWithError:(NSError*)_error request:(NSURLRequest*)request andTag:(void*)userdata 
{
    DLog(@"");
    NSObject* tag = (NSObject*)userdata;

    if ([tag isKindOfClass:[NSString class]])
    {   
        if ([(NSString*)tag isEqualToString:@"getBaseURL"])
        {
            error = [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                          withCode:JRConfigurationInformationError
                       andSeverity:JRErrorSeverityConfigurationFailed];
        }
        else if ([(NSString*)tag isEqualToString:@"getConfiguredProviders"])
        {
            error = [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                          withCode:JRConfigurationInformationError
                       andSeverity:JRErrorSeverityConfigurationFailed];
        }
        else if ([(NSString*)tag isEqualToString:@"getConfiguration"])
        {
            error = [self setError:@"There was a problem communicating with the Janrain server while configuring authentication." 
                          withCode:JRConfigurationInformationError
                       andSeverity:JRErrorSeverityConfigurationFailed];
        }
        else if ([(NSString*)tag isEqualToString:@"shareThis"])
        {
            NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
            for (id<JRSessionDelegate> delegate in delegatesCopy) 
            {
                [delegate publishingActivity:activity
                            didFailWithError:_error];
                
            }            
        }
    }
    else if ([(NSDictionary*)tag isKindOfClass:[NSDictionary class]])
    {
        if ([(NSDictionary*)tag objectForKey:@"tokenUrl"])
        {
            @synchronized (delegates)
            {
                NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
                for (id<JRSessionDelegate> delegate in delegatesCopy) 
                {
                    [delegate authenticateCallToTokenUrl:[(NSDictionary*)tag objectForKey:@"tokenUrl"] 
                                        didFailWithError:_error 
                                             forProvider:[(NSDictionary*)tag objectForKey:@"providerName"]];
                }
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

- (BOOL)gatheringInfo
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

//- (void)setReturningBasicProviderToNewBasicProvider:(JRProvider*)provider
//{
//	DLog(@"");
//    
//	[returningBasicProvider release];
//	returningBasicProvider = [provider retain];
//}
//
//- (void)setCurrentBasicProviderToReturningProvider
//{
//	DLog(@"");
//    isSocial = NO;
//	currentProvider = currentBasicProvider = [returningBasicProvider retain];
//}
//
//- (void)setBasicProvider:(JRProvider*)provider
//{
//	DLog(@"provider: %@", provider);
//
//	if (![currentBasicProvider isEqualToProvider:provider])
//	{	
//		[currentBasicProvider release];
//		
//		if ([returningBasicProvider isEqualToProvider:provider])
//			[self setCurrentBasicProviderToReturningProvider];
//		else
//			currentBasicProvider = [provider retain];
//	}
//
//    isSocial = NO;
//    currentProvider = currentBasicProvider;
//}
//
//
//- (void)setSocialProvider:(JRProvider*)provider
//{
//	DLog(@"provider: %@", provider);
//    
//	if (![currentSocialProvider isEqualToProvider:provider])
//	{	
//		[currentSocialProvider release];
//		
//        currentSocialProvider = [provider retain];
//    }
//    
//    isSocial = YES;
//    currentProvider = currentSocialProvider;
//}

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
	
    // TODO: Test that this works with a nil provider
	NSDictionary* tag = [[NSDictionary dictionaryWithObjectsAndKeys:_tokenUrl, @"tokenUrl", providerName, @"providerName", nil] retain];
    
	if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag stringEncodeData:NO])
	{
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Problem initializing connection to Token URL" 
                                                             forKey:NSLocalizedDescriptionKey];
        NSError *new_error = [NSError errorWithDomain:@"JRAuthenticate"
                                             code:100
                                         userInfo:userInfo];
		@synchronized (delegates)
        {
            NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
            for (id<JRSessionDelegate> delegate in delegatesCopy) 
            {
                [delegate authenticateCallToTokenUrl:_tokenUrl didFailWithError:new_error forProvider:providerName];
            }
        }
	}
	
	[request release];
}

- (void)makeCallToTokenUrlWithToken:(NSString*)token
{
	DLog(@"");
    [self makeCallToTokenUrl:tokenUrl withToken:token forProvider:currentProvider.name];
}	

- (void)authenticationDidCompleteWithPayload:(NSDictionary*)payloadDict// forProvider:(JRProvider*)provider
{  
    DLog(@"");
    NSDictionary *goodies = [payloadDict objectForKey:@"rpx_result"];
    NSString *token = [goodies objectForKey:@"token"];
    
    JRAuthenticatedUser *user = [[[JRAuthenticatedUser alloc] initUserWithDictionary:goodies
                                                                    forProviderNamed:currentProvider.name] autorelease];    
    
    @synchronized (authenticatedUsersByProvider)
    {
        [authenticatedUsersByProvider setObject:user forKey:currentProvider.name];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider] 
                                                  forKey:@"JRAuthenticatedUsersByProvider"];
    }
    
    if ([[self basicProviders] containsObject:currentProvider.name])
        [self saveLastUsedBasicProvider];
        
    if ([[self socialProviders] containsObject:currentProvider.name])
        [self saveLastUsedSocialProvider];
    
    @synchronized (delegates)
    {
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy) 
        {
#ifdef STAGING
            [delegate authenticationDidCompleteWithToken:token forProvider:currentProvider.name];
#else
            [delegate authenticationDidCompleteForUser:[goodies objectForKey:@"profile"] forProvider:currentProvider.name];
#endif
        }
    }
    
	if (tokenUrl)
        [self makeCallToTokenUrl:tokenUrl withToken:token forProvider:currentProvider.name];
    
    [currentProvider release];
    currentProvider = nil;
}

//- (void)authenticationDidCompleteWithToken:(NSString*)token
//{	
//    DLog(@"");
//
//    for (id<JRSessionDelegate> delegate in delegatesCopy) 
//    {
//        [delegate authenticationDidCompleteWithToken:token forProvider:currentProvider.name];
//    }
//}
//
//- (void)authenticationDidCompleteWithAuthenticationToken:(NSString*)authenticationToken andDeviceToken:(NSString*)deviceToken
//{
//	DLog(@"");
//    [self saveLastUsedSocialProvider:deviceToken];
//    
//    [self authenticationDidCompleteWithToken:authenticationToken];
//}

- (void)authenticationDidFailWithError:(NSError*)_error
{
    DLog(@"");
    [currentProvider release];
    currentProvider = nil;
    
    [returningBasicProvider release];
    returningBasicProvider = nil;
    
    [returningSocialProvider release];
    returningSocialProvider = nil;
    
    DLog(@"");
    @synchronized (delegates)
    {
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy) 
        {
            [delegate authenticationDidFailWithError:_error forProvider:currentProvider.name];
        }
    }
}

- (void)authenticationDidCancel
{
    DLog(@"");
    [currentProvider release];
    currentProvider = nil;
    
    [returningBasicProvider release];
    returningBasicProvider = nil;
    
    //    [returningSocialProvider release];
    //    returningSocialProvider = nil;
    
    DLog(@"");
    @synchronized (delegates)
    {
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy) 
        {
            [delegate authenticationDidCancel];//ForProvider:nil];
        }
    }
}

- (void)authenticationDidCancel:(id)sender
{
    DLog(@"");
    [self authenticationDidCancel];
}

- (void)authenticationDidCancelWithError
{
    DLog(@"");
    [currentProvider release];
    currentProvider = nil;
    
    @synchronized (delegates)
    {
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy) 
        {
            [delegate authenticationDidCancel];//ForProvider:nil];
        }
    }
}

- (void)publishingDidCancel
{
    DLog(@"");
    [currentProvider release];
    currentProvider = nil;
    
    @synchronized (delegates)
    {
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy) 
        {
            [delegate publishingDidCancel];
        }
    }
    
    social = NO;
}

- (void)publishingDidCancel:(id)sender
{
    DLog(@"");
    [self publishingDidCancel];
}

- (void)publishingDidCancelWithError
{
    [currentProvider release];
    currentProvider = nil;
    
    @synchronized (delegates)
    {
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy) 
        {
            [delegate publishingDidCancel];
        }
    }    

    social = NO;
}

- (void)publishingDidComplete
{
    DLog(@"");
    [currentProvider release];
    currentProvider = nil;
    
    @synchronized (delegates)
    {
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy) 
        {
            [delegate publishingDidComplete];
        }
    }
    
    social = NO;    
}

- (void)publishingDidComplete:(id)sender
{
    DLog(@"");
    [self publishingDidComplete];
}

- (void)publishingDidRestart:(id)sender
{    
    DLog(@"");
    @synchronized (delegates)
    {
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy) 
        {
            [delegate publishingDidRestart];//ForProvider:nil];
        }
    }    
}

- (void)authenticationDidRestart:(id)sender
{
    DLog(@"");
    @synchronized (delegates)
    {
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy) 
        {
            [delegate authenticationDidRestart];//ForProvider:nil];
        }
    }        
}


@end
