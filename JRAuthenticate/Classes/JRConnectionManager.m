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
 
 File:	 JRConnectionManager.m 
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import "JRConnectionManager.h"

// TODO: Figure out why the -DDEBUG cflag isn't being set when Active Conf is set to debug
#define DEBUG
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


@interface ConnectionData2 : NSObject 
{
	NSURLRequest	*request;
	NSMutableData	*response;
	
	void *tag;
	
	id<JRConnectionManagerDelegate> delegate;
}

@property (retain) NSURLRequest		*request;
@property (retain) NSMutableData	*response;

@property (readonly) void *tag;
@property (readonly) id<JRConnectionManagerDelegate> delegate;
@end

@implementation ConnectionData2

@synthesize request;
@synthesize response;
@synthesize tag;
@synthesize delegate;

- (id)initWithRequest:(NSURLRequest*)req forDelegate:(id<JRConnectionManagerDelegate>)del withTag:(void*)userdata
{
	DLog(@"");
	
	if (self = [super init]) 
	{
		request  = [req retain];
		response = nil;
	
		delegate = [del retain];
		
		tag = userdata;	
	}
	
	return self;
}

- (void)dealloc 
{
	DLog(@"");
	
	[request release];
	[response release];
	[delegate release];
	
	[super dealloc];
}
@end


@implementation JRConnectionManager
@synthesize connectionBuffers;

static JRConnectionManager* singleton = nil;

- (JRConnectionManager*)init
{
	if (self = [super init])
	{
		connectionBuffers = CFDictionaryCreateMutable(kCFAllocatorDefault, 0,
													  &kCFTypeDictionaryKeyCallBacks,
													  &kCFTypeDictionaryValueCallBacks);		
	}
	
	return self;	
}

+ (JRConnectionManager*)getJRConnectionManager
{
    if (singleton == nil) {
        singleton = [[super allocWithZone:NULL] init];
    }
	
    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self getJRConnectionManager] retain];
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

+ (NSUInteger)openConnections
{
	JRConnectionManager* connMan = [JRConnectionManager getJRConnectionManager];
	return [(NSDictionary*)connMan.connectionBuffers count];
}

- (void)startActivity
{
	UIApplication* app = [UIApplication sharedApplication]; 
	app.networkActivityIndicatorVisible = YES;
}

- (void)stopActivity
{
	if ([(NSDictionary*)connectionBuffers count] == 0)
	{
		UIApplication* app = [UIApplication sharedApplication]; 
		app.networkActivityIndicatorVisible = NO;
	}	
}

/* Hmmmm... now that I've set up a full singleton instance of this class, will this ever be called?
   Leaving it here in case I want to make this not a singleton, so that my library isn't eating memory. */
- (void)dealloc
{
	DLog(@"");
	ConnectionData2* connectionData = nil;
	
	for (NSURLConnection* connection in [(NSMutableDictionary*)connectionBuffers allKeys])
	{
		connectionData = (ConnectionData2*)CFDictionaryGetValue(connectionBuffers, connection);
		[connection cancel];
		
		if ([connectionData tag])
		{
			[[connectionData delegate] connectionWasStoppedWithTag:[connectionData tag]];
		}
			
		CFDictionaryRemoveValue(connectionBuffers, connection);
	}
	
	CFRelease(connectionBuffers);	
	[self stopActivity];
	
	[super dealloc];
}

+ (bool)createConnectionFromRequest:(NSURLRequest*)request forDelegate:(id<JRConnectionManagerDelegate>)delegate withTag:(void*)userdata
{		
	DLog(@"request: %@", [[request URL] absoluteString]);

	JRConnectionManager* connMan = [JRConnectionManager getJRConnectionManager];
	CFMutableDictionaryRef connectionBuffers = connMan.connectionBuffers;
	
	if (![NSURLConnection canHandleRequest:request])
		return NO;
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:connMan startImmediately:NO];
	
	if (!connection)
		return NO;
	
	ConnectionData2 *connectionData = [[ConnectionData2 alloc] initWithRequest:request forDelegate:delegate withTag:userdata];	
	CFDictionaryAddValue(connectionBuffers,
						 connection,
						 connectionData);
	
	[connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[connection start];
	
	[connMan startActivity];
	
	[connection release];
	[connectionData release];
	
	return YES;
}

+ (void)stopConnectionsForDelegate:(id<JRConnectionManagerDelegate>)delegate
{
	DLog(@"");
	
	JRConnectionManager* connMan = [JRConnectionManager getJRConnectionManager];
	CFMutableDictionaryRef connectionBuffers = connMan.connectionBuffers;
	ConnectionData2 *connectionData = nil;

	for (NSURLConnection* connection in [(NSMutableDictionary*)connectionBuffers allKeys])
	{
		connectionData = (ConnectionData2*)CFDictionaryGetValue(connectionBuffers, connection);
		
		if ([connectionData delegate] == delegate)
		{
			[connection cancel];
		
			if ([connectionData tag])
			{
				[delegate connectionWasStoppedWithTag:[connectionData tag]];
			}
		
			CFDictionaryRemoveValue(connectionBuffers, connection);
		}
	}
	
	[connMan stopActivity];
}	

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
	DLog(@"");
	[[(ConnectionData2*)CFDictionaryGetValue(connectionBuffers, connection) response] appendData:data];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response 
{
	DLog(@"");
	[(ConnectionData2*)CFDictionaryGetValue(connectionBuffers, connection) setResponse:[[[NSMutableData alloc] init] autorelease]];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection 
{
	DLog(@"");
	ConnectionData2 *connectionData = (ConnectionData2*)CFDictionaryGetValue(connectionBuffers, connection);
	
	NSURLRequest *request = [connectionData request];
	NSString *payload = [[[NSString alloc] initWithData:[connectionData response] encoding:NSASCIIStringEncoding] autorelease];	
	void* userdata = [connectionData tag];
	id<JRConnectionManagerDelegate> delegate = [connectionData delegate];
	
	DLog(@"request: %@", [[request URL] absoluteString]);
	
	[delegate connectionDidFinishLoadingWithPayload:payload request:request andTag:userdata];
	
	CFDictionaryRemoveValue(connectionBuffers, connection);

	[self stopActivity];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error 
{
	DLog(@"error message: %@", [error localizedDescription]);

	ConnectionData2 *connectionData = (ConnectionData2*)CFDictionaryGetValue(connectionBuffers, connection);
	
	NSURLRequest *request = [connectionData request];
	void* userdata = [connectionData tag];
	id<JRConnectionManagerDelegate> delegate = [connectionData delegate];
	
	[delegate connectionDidFailWithError:error request:request andTag:userdata];
	
	CFDictionaryRemoveValue(connectionBuffers, connection);
	
	[self stopActivity];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request 
														  redirectResponse:(NSURLResponse *)redirectResponse
{
	DLog(@"willSendRequest:  %@", [[request URL] absoluteString]);
	DLog(@"redirectResponse: %@", [[redirectResponse URL] absoluteString]);
	
	return request;
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge { DLog(@""); }
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge { DLog(@""); }
- (NSCachedURLResponse*)connection:(NSURLConnection*)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse { DLog(@""); return cachedResponse; }
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten 
											   totalBytesWritten:(NSInteger)totalBytesWritten 
									   totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite { DLog(@""); }

@end
