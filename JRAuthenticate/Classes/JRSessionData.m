/* 
 Copyright (c) 2010, Janrain, Inc.
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer. 
 * Redistributions in binary
 form must reproduce the above copyright notice, this list of conditions and the
 following disclaimer in the documentation and/or other materials provided with
 the distribution. 
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
 */


#import "JRSessionData.h"

@implementation JRProvider

//@dynamic friendlyName;
//@dynamic placeholderText;
//@dynamic provider_requires_input;
//@synthesize provider_requires_input;

- (JRProvider*)initWithName:(NSString*)nm andStats:(NSDictionary*)stats
{
	[super init];
	
	providerStats = [[NSDictionary dictionaryWithDictionary:stats] retain];
	name = [nm retain];

	welcomeString = nil;
	
	placeholderText = nil;
	userInput = nil;
	friendlyName = nil;
	providerRequiresInput = NO;
	
	return self;
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



- (BOOL)providerRequiresInput
{
	if ([[providerStats objectForKey:@"requires_input"] isEqualToString:@"YES"])
		 return YES;
		
	return NO;
}

- (void)dealloc
{
	[providerStats release];
	[name release];
	[welcomeString release];
	[userInput release];
	
	[super dealloc];
}
@end


@implementation JRSessionData

//@synthesize provider;
//@synthesize placeholder_text;
//@synthesize user_input;
//@synthesize provider_requires_input;
//
//@synthesize welcome_string;
//@synthesize returning_provider;
//@synthesize returning_user_input;

@synthesize allProviders;
@synthesize configedProviders;

@synthesize currentProvider;
@synthesize returningProvider;

- (id)initWithBaseUrl:(NSString*)URL
{
	if (self = [super init]) 
	{
		baseURL = [[NSString stringWithString:URL] retain];
		
		currentProvider = nil;
		returningProvider = nil;
		
//		provider = nil;
//		placeholder_text = nil;
//		user_input = nil;
//		provider_requires_input = NO;
		
//		welcome_string = nil;
//		returning_provider = nil;
//		returning_user_input = nil;
		
		allProviders = nil;
		configedProviders = nil;
	
		errorStr = nil;
		
		[self startGetConfiguredProviders];
		[self loadAllProviders];
		[self loadCookieData];
	}
	return self;
}

- (void)dealloc 
{
//	[provider release];
//	[placeholder_text release];
//	[user_input release];
//	
//	[welcome_string release];
//	[returning_provider release];
//	[returning_user_input release];
	
	[allProviders release];
	[configedProviders release];
	
	[baseURL release];
	
	[errorStr release];
	
	[super dealloc];
}

- (NSURL*)startURL
{
	NSDictionary *providerStats = [allProviders objectForKey:currentProvider.name];
	NSMutableString *oid;
	
	if ([providerStats objectForKey:@"openid_identifier"])
	{
		oid = [NSMutableString stringWithString:[providerStats objectForKey:@"openid_identifier"]];
		
		if(currentProvider.userInput)
		{
			[oid replaceOccurrencesOfString:@"%s" withString:[currentProvider.userInput stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] options:NSLiteralSearch range:NSMakeRange(0, [oid length])];
		}
		oid = [[@"openid_identifier=" stringByAppendingString:oid] stringByAppendingString:@"&"];
	}
	else 
	{
		oid = [NSMutableString stringWithString:@""];
	}
	
	NSString* str = [NSString stringWithFormat:@"%@%@?%@device=iphone", baseURL, [providerStats objectForKey:@"url"], oid];
	
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@device=iphone", baseURL, [providerStats objectForKey:@"url"], oid]];
}


- (void)loadCookieData
{
	NSHTTPCookieStorage* cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray *cookies = [cookieStore cookiesForURL:[NSURL URLWithString:baseURL]];
	
	NSString *welcomeString = nil;
	NSString *provider = nil;
	NSString *userInput = nil;
		
	for (NSHTTPCookie *cookie in cookies) 
	{
//		if ([baseURL hasSuffix:cookie.domain])  // TODO: match on whole appname, not just suffix
//		{
			if ([cookie.name isEqualToString:@"welcome_info"])
			{
				welcomeString = [NSString stringWithString:cookie.value];
			}
			else if ([cookie.name isEqualToString:@"login_tab"])
			{
				provider = [NSString stringWithString:cookie.value];
			}
			else if ([cookie.name isEqualToString:@"user_input"])
			{
				userInput = [NSString stringWithString:cookie.value];
			}
//		}
	}	
	
	if (provider)
	{
		returningProvider = [[JRProvider alloc] initWithName:provider andStats:[allProviders objectForKey:provider]];
		
		if (welcomeString)
			[returningProvider setWelcomeString:welcomeString];
		if (userInput)
			[returningProvider setUserInput:userInput];
		
//		currentProvider = [returningProvider retain];
	}
}


- (void)loadAllProviders
{
	NSString	 *path = nil;
	NSFileHandle *readHandle = nil;
	NSString	 *provList = nil;
	NSDictionary *jsonDict = nil;
	
	path = [[NSBundle mainBundle] pathForResource:@"provider_list" ofType:@"json"];
	
	if(!path) // Then there was an error
		return; // TODO: manage error and memory
	
	readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
	
	if(!readHandle)  // Then there was an error
		return; // TODO: manage error and memory
	
	provList = [[NSString alloc] initWithData:[readHandle readDataToEndOfFile] 
									 encoding:NSUTF8StringEncoding];
	
	if(!provList) // Then there was an error
		return; // TODO: manage error and memory
	
	jsonDict = [provList JSONValue];
	
	if(!jsonDict) // Then there was an error
		return; // TODO: manage error and memory
	
	allProviders = [NSDictionary dictionaryWithDictionary:[jsonDict objectForKey:@"providers"]];
	[allProviders retain];
	
	printf("finishloadAllProviders\n");
}


- (void)startGetAllProviders
{
	NSString *urlString = @"http://rpxnow.com/iphone/providers";
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	if(!url) // Then there was an error
		return;
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
	
	NSString *tag = [NSString stringWithFormat:@"getAllProviders"];
	[tag retain];
	
	//	if (![self createConnectionFromRequest:request])
	if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
		errorStr = [NSString stringWithFormat:@"There was an error initializing JRAuthenticate.\nThere was a problem getting the list of all providers."];
}

- (void)finishGetAllProviders:(NSString*)dataStr
{
	NSDictionary *jsonDict = [dataStr JSONValue];
	
	if(!jsonDict) // Then there was an error
		return;
	
	allProviders = [NSDictionary dictionaryWithDictionary:[jsonDict objectForKey:@"providers"]];
	[allProviders retain];
}


- (void)startGetConfiguredProviders
{
	NSString *urlString = [baseURL stringByAppendingString:@"/openid/ui_config"];
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	if(!url) // Then there was an error
		return;
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
	
	NSString *tag = [NSString stringWithFormat:@"getConfiguredProviders"];
	[tag retain];
	
	//	if (![self createConnectionFromRequest:request])
	if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
		errorStr = [NSString stringWithFormat:@"There was an error initializing JRAuthenticate.\nThere was a problem getting the list of configured providers."];
}

- (void)finishGetConfiguredProviders:(NSString*)dataStr
{
	printf("finishGetConfiguredProviders\n");
	NSDictionary *jsonDict = [dataStr JSONValue];
	
	if(!jsonDict)
		return;
	
	configedProviders = [NSArray arrayWithArray:[jsonDict objectForKey:@"enabled_providers"]];
	
	if(configedProviders)
		[configedProviders retain];
	
	
	printf("jsonDict retain count: %d\n", [jsonDict retainCount]);
	printf("configed providers retain count: %d\n", [configedProviders retainCount]);
}


- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
	NSString* tag = (NSString*)userdata;
	
	if ([tag isEqualToString:@"getBaseURL"])
	{
		if ([payload hasPrefix:@"RPXNOW._base_cb(true"])
		{
			[self finishGetBaseUrl:payload];
		}
		else // There was an error...
		{
			errorStr = [NSString stringWithFormat:@"There was an error initializing JRAuthenticate.\nThere was an error in the response to a request."];
		}
	}
	else if ([tag isEqualToString:@"getConfiguredProviders"])
	{
		if ([payload rangeOfString:@"\"provider_info\":{"].length != 0)
		{
			[self finishGetConfiguredProviders:payload];
		}
		else // There was an error...
		{
			errorStr = [NSString stringWithFormat:@"There was an error initializing JRAuthenticate.\nThere was an error in the response to a request."];
		}
	}
	
	[tag release];	
}

- (void)setReturningProviderToProvider:(JRProvider*)provider
{
	[returningProvider release];
	returningProvider = [provider retain];
}

- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(void*)userdata 
{
	NSString* tag = (NSString*)userdata;
	
	if ([tag isEqualToString:@"getBaseURL"])
	{
		errorStr = [NSString stringWithFormat:@"There was an error initializing JRAuthenticate.\nThere was an error in the response to a request."];
	}
	else if ([tag isEqualToString:@"getConfiguredProviders"])
	{
		errorStr = [NSString stringWithFormat:@"There was an error initializing JRAuthenticate.\nThere was an error in the response to a request."];
	}
	
	[tag release];	
}

- (void)connectionWasStoppedWithTag:(void*)userdata 
{
	[(NSString*)userdata release];
}

//- (void)provider
//{
//	return provider;
//}

- (void)setCurrentProviderToReturningProvider
{
	currentProvider = [returningProvider retain];
}

- (void)setProvider:(NSString *)prov
{
	if (![currentProvider.name isEqualToString:prov])
	{	
		[currentProvider release];
		
		if ([returningProvider.name isEqualToString:prov])
			[self setCurrentProviderToReturningProvider];
		else
			currentProvider = [[[JRProvider alloc] initWithName:prov andStats:[allProviders objectForKey:prov]] retain];
	}
	[currentProvider retain];
printf("currentProvider(%p)\n", currentProvider);
	if (currentProvider.name)
	{
		printf("helloooooooooooo\n");
	}
	//provider = prov;
	
//	NSDictionary *provider_stats = [allProviders objectForKey:provider];
//	NSString *input_required = [provider_stats objectForKey:@"requires_input"];
//	NSString *input_prompt = [provider_stats objectForKey:@"input_prompt"];
//	
////	provider = [NSString stringWithString:provider];
//	user_input = nil;
//	
//	if ([input_required isEqualToString:@"YES"]) 
//	{		
//		provider_requires_input = YES;
//		placeholder_text = [NSString stringWithString:input_prompt];
//	}
//	else
//	{
//		provider_requires_input = NO;
//		placeholder_text = nil;
//	}
}


@end
