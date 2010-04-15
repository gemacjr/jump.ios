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
- (void)handleSuccessfulAuthentication:(NSString*)tok;
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
	
	jrAuth = [[JRAuthenticate jrAuthenticate] retain];
	sessionData = [[((JRModalNavigationController*)[[self navigationController] parentViewController]) sessionData] retain];
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
		infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, 388, 320, 30)];
		[self.view addSubview:infoBar];
	}
	[infoBar fadeIn];
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
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { }

- (void)startProgress
{ 
	UIApplication* app = [UIApplication sharedApplication]; 
	app.networkActivityIndicatorVisible = YES;
	[infoBar startProgress];
}

- (void)stopProgress
{
	UIApplication* app = [UIApplication sharedApplication]; 
	app.networkActivityIndicatorVisible = NO;
	[infoBar stopProgress];
}
	

- (void)handleSuccessfulAuthentication:(NSString*)tok
{
	DLog(@"token: %@", tok);
	
	[sessionData authenticationDidCompleteWithToken:tok];
}

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
	NSString* tag = (NSString*)userdata;
	
	DLog(@"payload: %@", payload);
	DLog(@"tag:     %@", tag);
		
	if ([tag isEqualToString:@"rpx_result"])
	{
		NSDictionary *payloadDict = [payload JSONValue];
		
		if(!payloadDict) { /* ERROR */ }
		
		payloadDict = [payloadDict objectForKey:@"rpx_result"];
		
		if ([[payloadDict objectForKey:@"stat"] isEqualToString:@"ok"])
		{
			[self handleSuccessfulAuthentication:[payloadDict objectForKey:@"token"]];
		}
		else 
		{
			if ([[payloadDict objectForKey:@"error"] isEqualToString:@"Discovery failed for the OpenID you entered"])
			{
				NSString *message = nil;
				if (sessionData.currentProvider.providerRequiresInput)
					message = [NSString stringWithFormat:@"The %@ you entered was not valid. Please try again.", sessionData.currentProvider.shortText];
				else
					message = @"There was a problem authenticating with this provider. Please try again.";
				
				DLog(@"Discovery failed for the OpenID you entered.\n%@", message);
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input"
																message:message
															   delegate:self
													  cancelButtonTitle:@"OK" 
													  otherButtonTitles:nil];
				
				[[self navigationController] popViewControllerAnimated:YES];

				[alert show];
			}
		}
	}

	[tag release];	
	[self stopProgress];	
}

- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(void*)userdata 
{
	NSString* tag = (NSString*)userdata;
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
	
	NSString *thatURL = [NSString stringWithFormat:@"%@/signin/device", jrAuth.theBaseUrl];
	
//	if ([[[request URL] absoluteString] hasPrefix:@"https://jrauthenticate.rpxnow.com/signin/device"])
	if ([[[request URL] absoluteString] hasPrefix:thatURL])
	{
		DLog(@"request url has prefix: %@", jrAuth.theBaseUrl);
		
		NSString* tag = [[NSString stringWithFormat:@"rpx_result"] retain];
		[JRConnectionManager createConnectionFromRequest:[request retain] forDelegate:self withTag:tag];
		
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
	[self stopProgress];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
	DLog(@"error message: %@", [error localizedDescription]); 

	[sessionData authenticationDidFailWithError:error];
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
	
	[jrAuth release];
	[sessionData release];

	[myWebView release];
	[infoBar release];
		
    [super dealloc];
}
@end
