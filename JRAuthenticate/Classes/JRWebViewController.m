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
 
 File:	 JRWebViewController.m 
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "JRWebViewController.h"

// TODO: Figure out why the -DDEBUG cflag isn't being set when Active Conf is set to debug
#define DEBUG
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@interface JRWebViewController ()
- (void)webViewWithUrl:(NSURL*)url;
@end

@implementation JRWebViewController
@synthesize myWebView;

/*
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		jrAuth = [[JRAuthenticate jrAuthenticate] retain];
		
		delegates = [NSArray arrayByAddingObject:jrAuth];
		// Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	DLog(@"");
	[super viewDidLoad];
	
//	jrAuth = [[JRAuthenticate jrAuthenticate] retain];
	sessionData = [JRSessionData jrSessionData];//[[((JRModalNavigationController*)[[self navigationController] parentViewController]) sessionData] retain];
}

- (void)viewWillAppear:(BOOL)animated 
{
	DLog(@"");
    [super viewWillAppear:animated];
	
	self.title = [NSString stringWithFormat:@"%@", sessionData.currentProvider.friendlyName];
	
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] 
									  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
									  target:[self navigationController].parentViewController
									  action:@selector(cancelButtonPressed:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = cancelButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;
	
	if (!infoBar)
	{
		infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, 388, 320, 30) andStyle:[sessionData hidePoweredBy]];
		[self.view addSubview:infoBar];
	}
	[infoBar fadeIn];

	userStopped = NO;
}


- (void)viewDidAppear:(BOOL)animated 
{
	[super viewDidAppear:animated];

	NSArray *vcs = [self navigationController].viewControllers;
	DLog(@"");
	for (NSObject *vc in vcs)
	{
		DLog(@"view controller: %@", [vc description]);
	}
  	
	[self webViewWithUrl:[sessionData startURL]];
	[myWebView becomeFirstResponder];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    // return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { }

- (void)startProgress
{ 
	UIApplication* app = [UIApplication sharedApplication]; 
	app.networkActivityIndicatorVisible = YES;
	[infoBar startProgress];
}

- (void)stopProgress
{
	if ([JRConnectionManager openConnections] == 0)
	{
		UIApplication* app = [UIApplication sharedApplication]; 
		app.networkActivityIndicatorVisible = NO;
	}
	
	keepProgress = NO;
	[infoBar stopProgress];
}
	

//- (void)handleSuccessfulAuthentication:(NSString*)token
//{
//	DLog(@"token: %@", tok);
//#ifdef SOCIAL_PUBLISHING
//    [sessionData authenticationDidCompleteWithAuthenticationToken:token andSessionToken:[sessionData currentProvider.name]];
//#else
//	[sessionData authenticationDidCompleteWithToken:token];
//#endif
//}

- (void)connectionDidFinishLoadingWithUnEncodedPayload:(NSData*)payload request:(NSURLRequest*)request andTag:(void*)userdata { }

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
	[self stopProgress];
	
	NSString* tag = [(NSString*)userdata retain];
	[payload retain];
	
	DLog(@"payload: %@", payload);
	DLog(@"tag:     %@", tag);
		
	if ([tag isEqualToString:@"rpx_result"])
	{
        
        if (![payload respondsToSelector:@selector(JSONValue)]) { /* TODO: Error */}
        
		NSDictionary *payloadDict = [payload JSONValue];
		
		if(!payloadDict) {  /* TODO: Error */ }
		
		if ([[[payloadDict objectForKey:@"rpx_result"] objectForKey:@"stat"] isEqualToString:@"ok"])
		{
            [sessionData authenticationDidCompleteWithPayload:payloadDict];
            
//			[self handleSuccessfulAuthentication:[payloadDict objectForKey:@"token"]];
//#ifdef SOCIAL_PUBLISHING
//            [sessionData authenticationDidCompleteWithAuthenticationToken:[payloadDict objectForKey:@"token"] 
//                                                           andDeviceToken:sessionData.currentProvider.name];
//                                                        //andSessionToken:[payloadDict objectForKey:@"device_token"]];
//#else
//            [sessionData authenticationDidCompleteWithToken:[payloadDict objectForKey:@"token"]];
//#endif
            
		}
		else 
		{
			if ([[payloadDict objectForKey:@"error"] isEqualToString:@"Discovery failed for the OpenID you entered"])
			{
				NSString *message = nil;
				if (sessionData.currentProvider.requiresInput)
					message = [NSString stringWithFormat:@"The %@ you entered was not valid. Please try again.", sessionData.currentProvider.shortText];
				else
					message = @"There was a problem authenticating with this provider. Please try again.";
				
				DLog(@"Discovery failed for the OpenID you entered.\n%@", message);
				
				UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Invalid Input"
																 message:message
																delegate:self
													   cancelButtonTitle:@"OK" 
													   otherButtonTitles:nil] autorelease];
				
				[[self navigationController] popViewControllerAnimated:YES];

				[alert show];
			}
			else if ([[payloadDict objectForKey:@"error"] isEqualToString:@"Please enter your OpenID"])
			{
				NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Authentication failed: %@", payload]
																	 forKey:NSLocalizedDescriptionKey];
				NSError *error = [NSError errorWithDomain:@"JRAuthenticate"
													 code:100
												 userInfo:userInfo];
				
				[sessionData authenticationDidFailWithError:error];
			}
			else
			{
				NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Authentication failed: %@", payload]
																	 forKey:NSLocalizedDescriptionKey];
				NSError *error = [NSError errorWithDomain:@"JRAuthenticate"
													 code:100
												 userInfo:userInfo];
				
				[sessionData authenticationDidFailWithError:error];
			}
		}
	}

	[payload release];
	[tag release];	

}

- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(void*)userdata 
{
	NSString* tag = [(NSString*)userdata retain];
	DLog(@"tag:     %@", tag);
	
	if ([tag isEqualToString:@"rpx_result"])
	{
		[sessionData authenticationDidFailWithError:error];
	}
	
	[tag release];	
	[self stopProgress];
}

- (void)connectionWasStoppedWithTag:(void*)userdata 
{
	[(NSString*)userdata release];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
												 navigationType:(UIWebViewNavigationType)navigationType 
{	
	DLog(@"request: %@", [[request URL] absoluteString]);
	DLog(@"navigation type: %d", navigationType);
	
	NSString *thatURL = [NSString stringWithFormat:@"%@/signin/device", [sessionData baseUrl]];
	
	if ([[[request URL] absoluteString] hasPrefix:thatURL])
	{
		DLog(@"request url has prefix: %@", [sessionData baseUrl]);
		
		NSString* tag = [[NSString stringWithFormat:@"rpx_result"] retain];
		[JRConnectionManager createConnectionFromRequest:[request retain] forDelegate:self withTag:tag];

		keepProgress = YES;
		return NO;
	}

	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView 
{ 
	DLog(@"");
	[self startProgress];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
	DLog(@"");
	if (!keepProgress)
		[self stopProgress];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
	DLog(@"error message: %@", [error localizedDescription]); 

	if (!userStopped)
		[sessionData authenticationDidFailWithError:error];
	userStopped = NO;
	
	[self stopProgress];
}

- (void)webViewWithUrl:(NSURL*)url
{
	DLog(@"");
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[myWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewWillDisappear:(BOOL)animated
{
	DLog(@"");
	
	userStopped = YES;
	[myWebView stopLoading];
	[myWebView loadHTMLString:@"" baseURL:[NSURL URLWithString:@"/"]];
	
	[JRConnectionManager stopConnectionsForDelegate:self];
	[self stopProgress];
	
	[infoBar fadeOut];
	[super viewWillDisappear:animated];	
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	DLog(@"");
	
//	[jrAuth release];
	[sessionData release];

	[myWebView release];
	[infoBar release];
		
    [super dealloc];
}
@end
