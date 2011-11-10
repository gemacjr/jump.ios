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

#if DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


@interface ConnectionData : NSObject
{
    NSURLRequest    *_request;
    NSMutableData   *_response;
    NSURLResponse   *_fullResponse;

    BOOL _returnFullResponse;

    void *_tag;

    id<JRConnectionManagerDelegate> _delegate;
}

@property (retain) NSURLRequest     *request;
@property (retain) NSMutableData    *response;
@property (retain) NSURLResponse *fullResponse;
@property (readonly) BOOL returnFullResponse;
@property (readonly) void *tag;
@property (readonly) id<JRConnectionManagerDelegate> delegate;
@end

@implementation ConnectionData
@synthesize request            = _request;
@synthesize response           = _response;
@synthesize fullResponse       = _fullResponse;
@synthesize returnFullResponse = _returnFullResponse;
@synthesize tag                = _tag;
@synthesize delegate           = _delegate;

- (id)initWithRequest:(NSURLRequest*)request
          forDelegate:(id<JRConnectionManagerDelegate>)delegate
   returnFullResponse:(BOOL)returnFullResponse
              withTag:(void*)userdata
{
//  DLog(@"");

    if ((self = [super init]))
    {
        _request  = [request retain];
        _response = nil;
        _fullResponse = nil;

        _returnFullResponse = returnFullResponse;

        _delegate = [delegate retain];

        _tag = userdata;
    }

    return self;
}

- (void)dealloc
{
//  DLog(@"");

    [_request release];
    [_response release];
    [_fullResponse release];
    [_delegate release];

    [super dealloc];
}
@end


@implementation JRConnectionManager
@synthesize connectionBuffers;

static JRConnectionManager* singleton = nil;

- (JRConnectionManager*)init
{
    if ((self = [super init]))
    {
        connectionBuffers = CFDictionaryCreateMutable(kCFAllocatorDefault, 0,
                                                      &kCFTypeDictionaryKeyCallBacks,
                                                      &kCFTypeDictionaryValueCallBacks);
    }

    return self;
}

+ (id)getJRConnectionManager
{
    if (singleton == nil) {
        singleton = [((JRConnectionManager*)[super allocWithZone:NULL]) init];
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
    return NSUIntegerMax;
}

- (oneway void)release { }

- (id)autorelease
{
    return self;
}

+ (NSUInteger)openConnections
{
    JRConnectionManager* connectionManager = [JRConnectionManager getJRConnectionManager];
    return [(NSDictionary*)connectionManager.connectionBuffers count];
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

/* Hmmmm... now that I've set up a full singleton instance of this class, will this ever be called? (No.)
   Leaving it here in case I want to make this not a singleton, so that my library isn't eating memory
   and I don't have to rewrite it. */
- (void)dealloc
{
//  DLog(@"");
    ConnectionData* connectionData;

    for (NSURLConnection* connection in [(NSMutableDictionary*)connectionBuffers allKeys])
    {
        connectionData = (ConnectionData*)CFDictionaryGetValue(connectionBuffers, connection);
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

+ (NSURLRequest*)aCopyOfTheRequestWithANonCrashingUserAgent:(NSURLRequest*)request
{
    // Question to self: Am I calling this every time, and if so, will this mess up any user-agent detection?
    NSMutableURLRequest* new_request = [request mutableCopyWithZone:nil];

    [new_request setValue:@"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.4) Gecko/20100527 Firefox/3.6.4 GTB7.1"
       forHTTPHeaderField:@"User-Agent"];

//    DLog(@"willSendNewRequest: %@", [[new_request URL] absoluteString]);

    return new_request;
}

+ (bool)createConnectionFromRequest:(NSURLRequest*)request
                        forDelegate:(id<JRConnectionManagerDelegate>)delegate
                 returnFullResponse:(BOOL)returnFullResponse
                            withTag:(void*)userdata
{
//    DLog(@"request: %@", [[request URL] absoluteString]);

    JRConnectionManager* connectionManager = [JRConnectionManager getJRConnectionManager];
    CFMutableDictionaryRef connectionBuffers = connectionManager.connectionBuffers;

    request = [[JRConnectionManager aCopyOfTheRequestWithANonCrashingUserAgent:request] autorelease];

    if (![NSURLConnection canHandleRequest:request])
        return NO;

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:connectionManager startImmediately:NO];

    if (!connection)
        return NO;

    ConnectionData *connectionData = [[ConnectionData alloc] initWithRequest:request
                                                                 forDelegate:delegate
                                                          returnFullResponse:returnFullResponse
                                                                     withTag:userdata];
    CFDictionaryAddValue(connectionBuffers,
                         connection,
                         connectionData);

    [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [connection start];

    [connectionManager startActivity];

    [connection release];
    [connectionData release];

    return YES;
}

+ (bool)createConnectionFromRequest:(NSURLRequest*)request
                        forDelegate:(id<JRConnectionManagerDelegate>)delegate
                            withTag:(void*)userdata
{
    return [JRConnectionManager createConnectionFromRequest:request forDelegate:delegate returnFullResponse:NO withTag:userdata];
}

+ (void)stopConnectionsForDelegate:(id<JRConnectionManagerDelegate>)delegate
{
//  DLog(@"");

    JRConnectionManager* connectionManager = [JRConnectionManager getJRConnectionManager];
    CFMutableDictionaryRef connectionBuffers = connectionManager.connectionBuffers;
    ConnectionData *connectionData = nil;

    for (NSURLConnection* connection in [(NSMutableDictionary*)connectionBuffers allKeys])
    {
        connectionData = (ConnectionData*)CFDictionaryGetValue(connectionBuffers, connection);

        if ([connectionData delegate] == delegate)
        {
            [connection cancel];

            if ([connectionData tag])
            {
                if ([delegate respondsToSelector:@selector(connectionWasStoppedWithTag:)])
                    [delegate connectionWasStoppedWithTag:[connectionData tag]];
            }

            CFDictionaryRemoveValue(connectionBuffers, connection);
        }
    }

    [connectionManager stopActivity];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //DLog(@"");
    [[(ConnectionData*)CFDictionaryGetValue(connectionBuffers, connection) response] appendData:data];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
  DLog(@"");

    ConnectionData *connectionData = (ConnectionData*)CFDictionaryGetValue(connectionBuffers, connection);

    [connectionData setResponse:[[[NSMutableData alloc] init] autorelease]];

    if ([connectionData returnFullResponse])
        connectionData.fullResponse = response;
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
  DLog(@"");
    ConnectionData *connectionData = (ConnectionData*)CFDictionaryGetValue(connectionBuffers, connection);

    NSURLRequest *request = [connectionData request];
    NSURLResponse *fullResponse = [connectionData fullResponse];
    NSData *responseBody = [connectionData response];
    void* userdata = [connectionData tag];
    id<JRConnectionManagerDelegate> delegate = [connectionData delegate];

    if ([connectionData fullResponse] == NO)
    {
        NSString *payload = [[[NSString alloc] initWithData:responseBody encoding:NSASCIIStringEncoding] autorelease];

        if ([delegate respondsToSelector:@selector(connectionDidFinishLoadingWithPayload:request:andTag:)])
            [delegate connectionDidFinishLoadingWithPayload:payload request:request andTag:userdata];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(connectionDidFinishLoadingWithFullResponse:unencodedPayload:request:andTag:)])
            [delegate connectionDidFinishLoadingWithFullResponse:fullResponse unencodedPayload:responseBody request:request andTag:userdata];
    }

    CFDictionaryRemoveValue(connectionBuffers, connection);

    [self stopActivity];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    DLog(@"error message: %@", [error localizedDescription]);

    ConnectionData *connectionData = (ConnectionData*)CFDictionaryGetValue(connectionBuffers, connection);

    NSURLRequest *request = [connectionData request];
    void* userdata = [connectionData tag];
    id<JRConnectionManagerDelegate> delegate = [connectionData delegate];

    if ([delegate respondsToSelector:@selector(connectionDidFailWithError:request:andTag:)])
        [delegate connectionDidFailWithError:error request:request andTag:userdata];

    CFDictionaryRemoveValue(connectionBuffers, connection);

    [self stopActivity];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request
                                                          redirectResponse:(NSURLResponse *)redirectResponse
{
    DLog(@"");
    ConnectionData *connectionData = (ConnectionData*)CFDictionaryGetValue(connectionBuffers, connection);

    if ([connectionData returnFullResponse])
        connectionData.fullResponse = redirectResponse;

    return [[JRConnectionManager aCopyOfTheRequestWithANonCrashingUserAgent:request] autorelease];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge  { DLog(@""); }
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge { DLog(@""); }
- (NSCachedURLResponse*)connection:(NSURLConnection*)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse       { DLog(@""); return cachedResponse; }
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten
                                               totalBytesWritten:(NSInteger)totalBytesWritten
                                       totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{ /*DLog(@"bytesWritten: %d, totalBytesWritten: %d, totalBytesExpected: %d", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);*/ }

@end
