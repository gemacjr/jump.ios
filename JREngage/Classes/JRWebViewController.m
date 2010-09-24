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
	
	sessionData = [JRSessionData jrSessionData];
}

- (void)viewWillAppear:(BOOL)animated 
{
	DLog(@"");
    [super viewWillAppear:animated];
    
	self.title = [NSString stringWithFormat:@"%@", (sessionData.currentProvider) ? sessionData.currentProvider.friendlyName : @"Loading"];
	
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] 
									  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
									  target:self
                                      action:@selector(cancelButtonPressed:)] autorelease];

	self.navigationItem.rightBarButtonItem = cancelButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;
	
    self.navigationItem.backBarButtonItem.target = sessionData;
    self.navigationItem.backBarButtonItem.action = @selector(triggerAuthenticationDidStartOver:);
    
	if (!infoBar)
	{
		infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, 388, 320, 30) andStyle:[sessionData hidePoweredBy]];
        
        if ([sessionData hidePoweredBy] == JRInfoBarStyleShowPoweredBy)
            [myWebView setFrame:CGRectMake(myWebView.frame.origin.x, myWebView.frame.origin.y, myWebView.frame.size.width, myWebView.frame.size.height - 74)];

		[self.view addSubview:infoBar];
	}
	[infoBar fadeIn];
}

- (void)viewDidAppear:(BOOL)animated 
{
	DLog(@"");
	[super viewDidAppear:animated];

	NSArray *vcs = [self navigationController].viewControllers;
	for (NSObject *vc in vcs)
	{
		DLog(@"view controller: %@", [vc description]);
	}

 /* We need to figure out if the user canceled authentication by hitting the back button or the cancel button,
    or if it stopped because it failed or completed successfully on its own.  Assume that the user did hit the
    back button until told otherwise. */
	userHitTheBackButton = YES;
    
    if (!sessionData.currentProvider)
    {
        // TODO: Rewrite error
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"TODO REWRITE ERROR!! Authentication failed."
                                                             forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"JRAuthenticate"
                                             code:100
                                         userInfo:userInfo];
        
        [sessionData triggerAuthenticationDidFailWithError:error];        
        
        return;
    }    
    
	[self webViewWithUrl:[sessionData startUrlForCurrentProvider]];
	[myWebView becomeFirstResponder];
}

- (void)cancelButtonPressed:(id)sender
{
    userHitTheBackButton = NO;
    [sessionData triggerAuthenticationDidStartOver:sender];
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
//	DLog(@"");
	UIApplication* app = [UIApplication sharedApplication]; 
	app.networkActivityIndicatorVisible = YES;
	[infoBar startProgress];
}

- (void)stopProgress
{
//	DLog(@"");
	if ([JRConnectionManager openConnections] == 0)
	{
		UIApplication* app = [UIApplication sharedApplication]; 
		app.networkActivityIndicatorVisible = NO;
	}
	
	keepProgress = NO;
	[infoBar stopProgress];
}
	
- (void)connectionDidFinishLoadingWithUnEncodedPayload:(NSData*)payload request:(NSURLRequest*)request andTag:(void*)userdata { }

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
	DLog(@"");
	[self stopProgress];
	
	NSString* tag = [(NSString*)userdata retain];
	
	DLog(@"payload: %@", payload);
	DLog(@"tag:     %@", tag);
		
	if ([tag isEqualToString:@"rpx_result"])
	{
        
        if (![payload respondsToSelector:@selector(JSONValue)]) { /* TODO: Error */}
        
        NSDictionary *payloadDict = [payload JSONValue];
		
		if(!payloadDict) {  /* TODO: Error */ }
		
		if ([[[payloadDict objectForKey:@"rpx_result"] objectForKey:@"stat"] isEqualToString:@"ok"])
		{
            userHitTheBackButton = NO; /* Because authentication completed successfully. */
            [sessionData triggerAuthenticationDidCompleteWithPayload:payloadDict];
		}
		else 
		{
			if ([[[payloadDict objectForKey:@"rpx_result"] objectForKey:@"error"] isEqualToString:@"Discovery failed for the OpenID you entered"])
			{
				NSString *message = nil;
				if (sessionData.currentProvider.requiresInput)
					message = [NSString stringWithFormat:@"The %@ you entered was not valid. Please try again.", sessionData.currentProvider.shortText];
				else
					message = @"There was a problem authenticating with this provider. Please try again.";
				
				DLog(@"Discovery failed for the OpenID you entered: %@", message);
				
				UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Invalid Input"
																 message:message
																delegate:self
													   cancelButtonTitle:@"OK" 
													   otherButtonTitles:nil] autorelease];

                userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
				[[self navigationController] popViewControllerAnimated:YES];

				[alert show];
			}
            else if ([[[payloadDict objectForKey:@"rpx_result"] objectForKey:@"error"] isEqualToString:@"The URL you entered does not appear to be an OpenID"])
			{
				NSString *message = nil;
				if (sessionData.currentProvider.requiresInput)
					message = [NSString stringWithFormat:@"The %@ you entered was not valid. Please try again.", sessionData.currentProvider.shortText];
				else
					message = @"There was a problem authenticating with this provider. Please try again.";
				
				DLog(@"The URL you entered does not appear to be an OpenID: %@", message);
				
				UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Invalid Input"
																 message:message
																delegate:self
													   cancelButtonTitle:@"OK" 
													   otherButtonTitles:nil] autorelease];
                
                userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
				[[self navigationController] popViewControllerAnimated:YES];
                
				[alert show];
			}
			else if ([[[payloadDict objectForKey:@"rpx_result"] objectForKey:@"error"] isEqualToString:@"Please enter your OpenID"])
			{
				NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Authentication failed: %@", payload]
																	 forKey:NSLocalizedDescriptionKey];
				NSError *error = [NSError errorWithDomain:@"JRAuthenticate"
													 code:100
												 userInfo:userInfo];
				
                userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
				[sessionData triggerAuthenticationDidFailWithError:error];
			}
			else
			{
				NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Authentication failed: %@", payload]
																	 forKey:NSLocalizedDescriptionKey];
				NSError *error = [NSError errorWithDomain:@"JRAuthenticate"
													 code:100
												 userInfo:userInfo];
				
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Log In Failed"
                                                                 message:@"An error occurred while attempting to sign you in.  Please try again."
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil] autorelease];
                [alert show];
                
                userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
				[sessionData triggerAuthenticationDidFailWithError:error];
			}
		}
	}

	[tag release];	
}

- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(void*)userdata 
{
	DLog(@"");
	NSString* tag = [(NSString*)userdata retain];
	DLog(@"tag:     %@", tag);
	
    [self stopProgress];
    
	if ([tag isEqualToString:@"rpx_result"])
	{
        userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
		[sessionData triggerAuthenticationDidFailWithError:error];
	}
	
	[tag release];	
}

- (void)connectionWasStoppedWithTag:(void*)userdata 
{
	DLog(@"");
	[(NSString*)userdata release];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
												 navigationType:(UIWebViewNavigationType)navigationType 
{	
	DLog(@"request: %@", [[request URL] absoluteString]);
	
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
	DLog(@"");
	DLog(@"error message: %@", [error localizedDescription]); 
    
    if (error.code != NSURLErrorCancelled) /* Error code -999 */
    {
//        if (!userCanceledAuthentication)
//            [sessionData triggerAuthenticationDidFailWithError:error];
//        else
//            [sessionData triggerAuthenticationDidStartOver:nil];
//
//        userCanceledAuthentication = YES;
        
        [self stopProgress];
    }
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

 /* The webview disappears when authentication completes successfully or fails or if the user cancels by hitting
    the "back" button or the "cancel" button.  We don't know when a user hits the back button, but we do 
    know when all the other events occur, so we keep track of those events by changing the "userHitTheBackButton" 
    variable to "NO".
 
    If the view is disappearing because the user hit the cancel button, we already to send sessionData the 
    triggerAuthenticationDidStartOver event.  What we need to do it send the triggerAuthenticationDidStartOver 
    message if we're popping to the publishActivity controller (i.e., if we're publishing an activity), so that 
    the publishActivity controller gets the message from sessionData, and can hide the grayed-out activity indicator
    view.  
 
    If the userHitTheBackButton variable is set to "YES" and we're publishing an activity ([sessionData social] is "YES"),
    send the triggerAuthenticationDidStartOver message.  Otherwise, hitting the back button should just pop back 
    to the last controller, the providers or userLanding controller (i.e., behave normally) */
    if (userHitTheBackButton && [sessionData social])
        [sessionData triggerAuthenticationDidStartOver:nil];
 
	[myWebView stopLoading];
	[myWebView loadHTMLString:@"" baseURL:[NSURL URLWithString:@"/"]];
	
	[JRConnectionManager stopConnectionsForDelegate:self];
	[self stopProgress];
	
	[infoBar fadeOut];
	[super viewWillDisappear:animated];	
}

- (void)viewDidDisappear:(BOOL)animated
{
	DLog(@"");
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload {
	DLog(@"");
    [super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)userInterfaceWillClose { }
- (void)userInterfaceDidClose { }

- (void)dealloc {
	DLog(@"");
	
	[sessionData release];

	[myWebView release];
	[infoBar release];
		
    [super dealloc];
}
@end
