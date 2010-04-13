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

@interface JRWebViewController ()
- (void)handleSuccessfulAuthentication:(NSString*)tok;
- (void)makeCallToTokenUrlWithToken:(NSString*)tok;
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

- (void)viewDidAppear:(BOOL)animated {
	NSArray *vcs = [self navigationController].viewControllers;
	printf("\nvc list\n");	
	for (NSObject *vc in vcs)
	{
		printf("vc: %s\n", [[vc description] cString] );
	}
    
	[self webViewWithUrl:[sessionData startURL]];
	
	[super viewDidAppear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	jrAuth = [[JRAuthenticate jrAuthenticate] retain];
	sessionData = [[((JRModalNavigationController*)[[self navigationController] parentViewController]) sessionData] retain];

	delegates = [[[NSArray alloc] init] arrayByAddingObject:jrAuth];
	[delegates retain];
	
	bar = nil;
	powered_by = nil;		
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	
	self.title = [NSString stringWithFormat:@"%@", sessionData.currentProvider.friendlyName];
		
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] 
									  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
									  target:[self navigationController].parentViewController
									  action:@selector(cancelButtonPressed:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = cancelButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;

	int yPos = (self.view.frame.size.height - 20);
	
	if (!bar)
	{
		bar = [[UIImageView alloc] initWithFrame:CGRectMake(0, yPos, 320, 20)];
		bar.image = [UIImage imageNamed:@"info_bar.png"];
		[self.view addSubview:bar];
	}
	
	if (!powered_by)
	{
		powered_by = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, 320, 20)];
		powered_by.backgroundColor = [UIColor clearColor];
		powered_by.font = [UIFont italicSystemFontOfSize:14.0];
		powered_by.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
		powered_by.shadowColor = [UIColor colorWithWhite:0.8 alpha:0.8];
		powered_by.shadowOffset = CGSizeMake(1.0, 1.0);
		powered_by.textAlignment = UITextAlignmentCenter;
		powered_by.text = @"Powered by RPX";
		[self.view addSubview:powered_by];
	}
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

- (void)startProgress
{ 
	UIApplication* app = [UIApplication sharedApplication]; 
	app.networkActivityIndicatorVisible = YES;
}

- (void)stopProgress
{
	UIApplication* app = [UIApplication sharedApplication]; 
	app.networkActivityIndicatorVisible = NO;
}
	

- (void)handleSuccessfulAuthentication:(NSString*)tok
{
	token = [NSString stringWithString:tok];
	
	for (id<JRWebViewControllerDelegate> delegate in delegates) 
	{
		[delegate didReceiveToken:token];
	}
	
	if (jrAuth.theTokenUrl)
		[self makeCallToTokenUrlWithToken:token];
	
	
	NSHTTPCookieStorage *cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	
	[cookieStore setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
	NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:604800];

	NSHTTPCookie	*cookie = nil;
	
	[sessionData setReturningProviderToProvider:sessionData.currentProvider];
	//sessionData.returning_provider = [NSString stringWithString:sessionData.provider];
	
	cookie = [NSHTTPCookie cookieWithProperties:
				[NSDictionary dictionaryWithObjectsAndKeys:
					sessionData.returningProvider.name, NSHTTPCookieValue,
					@"login_tab", NSHTTPCookieName,
					@"jrauthenticate.rpxnow.com", NSHTTPCookieDomain,
					@"/", NSHTTPCookiePath,
					@"FALSE", NSHTTPCookieDiscard,
					date, NSHTTPCookieExpires, nil]];
	[cookieStore setCookie:cookie];
	
	cookie = [NSHTTPCookie cookieWithProperties:
				[NSDictionary dictionaryWithObjectsAndKeys:
					sessionData.returningProvider.userInput, NSHTTPCookieValue,
					@"user_input", NSHTTPCookieName,
					@"jrauthenticate.rpxnow.com", NSHTTPCookieDomain,
					@"/", NSHTTPCookiePath,
					@"FALSE", NSHTTPCookieDiscard,
					date, NSHTTPCookieExpires, nil]];
	[cookieStore setCookie:cookie];
}



- (void)makeCallToTokenUrlWithToken:(NSString*)tok
{
	NSMutableData* body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"token=%@", tok] dataUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest* request = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[jrAuth theTokenUrl]]] retain];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:body];

	NSString* tag = [NSString stringWithFormat:@"token_url_payload"];
	[tag retain];
	
	[JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag];
	
	[self startProgress];
}

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
	NSString* tag = (NSString*)userdata;
	
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
	else if ([tag isEqualToString:@"token_url_payload"])
	{
		for (id<JRWebViewControllerDelegate> delegate in delegates) 
		{
			[delegate didReachTokenURL:payload];
		}		
		
		finished = YES;
	}
	
	[tag release];	
	[self stopProgress];

//	if (finished)
		

}

- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(void*)userdata 
{
	NSString* tag = (NSString*)userdata;
	
	if ([tag isEqualToString:@"rpx_result"])
	{
	}
	else if ([tag isEqualToString:@"token_url_payload"])
	{
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
	printf("\nwebView shouldStartLoadingWithRequest and navigation:%d\n", navigationType);
		
	if ([[[request URL] absoluteString] hasPrefix:@"https://jrauthenticate.rpxnow.com/signin/device"])
	{
		NSString* tag = [[NSString stringWithFormat:@"rpx_result"] retain];
		[JRConnectionManager createConnectionFromRequest:[request retain] forDelegate:self withTag:tag];
		
		return NO;
	}

	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView 
{ 
	printf("\nwebViewDidStartLoad\n"); 

	[self startProgress];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
	printf("\nwebViewDidFinishLoad\n");
	
	[self stopProgress];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
	printf("\nwebViewDidFailLoadWithError: %s\n", [[error localizedDescription] cStringUsingEncoding:NSUTF8StringEncoding]); 

	for (id<JRWebViewControllerDelegate> delegate in delegates) 
	{
		[delegate didFailWithError:[error localizedDescription]];
	}
	[self stopProgress];
}

- (void)webViewWithUrl:(NSURL*)url
{
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[myWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[myWebView stopLoading];
	[myWebView loadHTMLString:@"" baseURL:[NSURL URLWithString:@"/"]];
	
	[JRConnectionManager stopConnectionsForDelegate:self];
	
	[super viewWillDisappear:animated];	
}

- (void)dealloc {
	[myWebView release];
	[jrAuth release];
	
    [super dealloc];
}


@end
