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


#import "JRConnectionManager.h"

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
	if (req == nil || del == nil)
	{
		[self release];
		return nil;
	}
	
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
	[request release];
	[response release];
	[delegate release];
	
	[super dealloc];
}
@end


@implementation JRConnectionManager
@synthesize connectionBuffers;

static JRConnectionManager* singleton = nil;
+ (JRConnectionManager*)jrConnectionManager
{
	return singleton;
}

+ (void)setJRConnectionManager:(JRConnectionManager*)connMan 
{
	singleton = connMan;
}

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
	if (singleton)
		return singleton;
	
	return [[JRConnectionManager alloc] init];
}

- (void)dealloc
{
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
	
	[super dealloc];
}

+ (bool)createConnectionFromRequest:(NSURLRequest*)request forDelegate:(id<JRConnectionManagerDelegate>)delegate withTag:(void*)userdata
{		
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
	
	[request release];
	[connection release];
	[connectionData release];
	
	return YES;
}

+ (void)stopConnectionsForDelegate:(id<JRConnectionManagerDelegate>)delegate
{
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
}	

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
	[[(ConnectionData2*)CFDictionaryGetValue(connectionBuffers, connection) response] appendData:data];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response 
{
	[(ConnectionData2*)CFDictionaryGetValue(connectionBuffers, connection) setResponse:[[NSMutableData alloc] init]];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection 
{
	ConnectionData2 *connectionData = (ConnectionData2*)CFDictionaryGetValue(connectionBuffers, connection);
	
	NSURLRequest *request = [connectionData request];
	NSString *payload = [[NSString alloc] initWithData:[connectionData response] encoding:NSASCIIStringEncoding];	
	void* userdata = [connectionData tag];
	id<JRConnectionManagerDelegate> delegate = [connectionData delegate];
	
	[delegate connectionDidFinishLoadingWithPayload:payload request:request andTag:userdata];
	
	
	CFDictionaryRemoveValue(connectionBuffers, connection);
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error 
{
	printf("\nconnection(%p) didFailWithError\n", connection);
	ConnectionData2 *connectionData = (ConnectionData2*)CFDictionaryGetValue(connectionBuffers, connection);
	
	NSURLRequest *request = [connectionData request];
	void* userdata = [connectionData tag];
	id<JRConnectionManagerDelegate> delegate = [connectionData delegate];
	
	[delegate connectionDidFailWithError:error request:request andTag:userdata];
	
	CFDictionaryRemoveValue(connectionBuffers, connection);
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request 
														  redirectResponse:(NSURLResponse *)redirectResponse
{
	printf("\nconnection(%p) willSendRequest redirectResponse\n", connection);
	printf("willSendRequest: %s\n", [[[request URL] absoluteString] cStringUsingEncoding:NSUTF8StringEncoding]);
	printf("redirectResponse: %s\n", [[[redirectResponse URL] absoluteString] cStringUsingEncoding:NSUTF8StringEncoding]);
	
	return request;
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge { }
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge { }
- (NSCachedURLResponse*)connection:(NSURLConnection*)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse { return cachedResponse; }
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten 
											   totalBytesWritten:(NSInteger)totalBytesWritten 
									   totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite { }

@end
