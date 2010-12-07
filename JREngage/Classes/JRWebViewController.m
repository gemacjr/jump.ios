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
@synthesize myBackgroundView;
@synthesize myWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andCustomUI:(NSDictionary*)_customUI
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
    {
        customUI = [_customUI retain];
    }

    return self;
}

- (NSError*)setError:(NSString*)message withCode:(NSInteger)code andType:(NSString*)type
{
    DLog(@"");
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              message, NSLocalizedDescriptionKey,
                              type, @"type", nil];
    
    return [[NSError alloc] initWithDomain:@"JREngage"
                                      code:code
                                  userInfo:userInfo];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	DLog(@"");
	[super viewDidLoad];
	
	sessionData = [JRSessionData jrSessionData];
    
    NSString *iPadSuffix = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"-iPad" : @"";
    NSArray *backgroundColor = [customUI objectForKey:@"BackgroundColor"];
    
//    /* Load the custom background view, if there is one. */
//    if ([customUI objectForKey:[NSString stringWithFormat:@"%@%@", kJRWebViewBackgroundView, iPadSuffix]])
//        self.myBackgroundView = [customUI objectForKey:[NSString stringWithFormat:@"%@%@", kJRWebViewBackgroundView, iPadSuffix]];
//    else /* Otherwise, set the background view to the provided color, if any. */
//        if ([[customUI objectForKey:@"BackgroundColor"] respondsToSelector:@selector(count)])
//            if ([[customUI objectForKey:@"BackgroundColor"] count] == 4)
//                self.myBackgroundView.backgroundColor = 
//                [UIColor colorWithRed:[(NSNumber*)[backgroundColor objectAtIndex:0] doubleValue]
//                                green:[(NSNumber*)[backgroundColor objectAtIndex:1] doubleValue]
//                                 blue:[(NSNumber*)[backgroundColor objectAtIndex:2] doubleValue]
//                                alpha:[(NSNumber*)[backgroundColor objectAtIndex:3] doubleValue]];
    
//    titleView = [customUI objectForKey:[NSString stringWithFormat:@"%@%@", kJRTitleViewForProvidersTable, iPadSuffix]];
    
    self.navigationItem.backBarButtonItem.target = sessionData;
    self.navigationItem.backBarButtonItem.action = @selector(triggerAuthenticationDidStartOver:);
    
	if (!infoBar)
	{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, 890, 768, 72) andStyle:[sessionData hidePoweredBy] | JRInfoBarStyleiPad];
        else
            infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, 386, 320, 30) andStyle:[sessionData hidePoweredBy]];
        
        if ([sessionData hidePoweredBy] == JRInfoBarStyleShowPoweredBy)
            [myWebView setFrame:CGRectMake(myWebView.frame.origin.x, 
                                           myWebView.frame.origin.y, 
                                           myWebView.frame.size.width, 
                                           myWebView.frame.size.height - infoBar.frame.size.height)];
        
		[self.view addSubview:infoBar];
	}
    
	[infoBar fadeIn];    
}

- (void)viewWillAppear:(BOOL)animated 
{
	DLog(@"");
    [super viewWillAppear:animated];
    
	self.title = [NSString stringWithFormat:@"%@", (sessionData.currentProvider) ? sessionData.currentProvider.friendlyName : @"Loading"];
}

- (void)viewDidAppear:(BOOL)animated 
{
	DLog(@"");
	[super viewDidAppear:animated];

 /* We need to figure out if the user canceled authentication by hitting the back button or the cancel button,
    or if it stopped because it failed or completed successfully on its own.  Assume that the user did hit the
    back button until told otherwise. */
	userHitTheBackButton = YES;
    
    if (!sessionData.currentProvider)
    {
        NSError *error = [[self setError:@"There was an error authenticating with the selected provider."
                                withCode:JRAuthenticationFailedError
                                 andType:JRErrorTypeAuthenticationFailed] autorelease];
        
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
	
- (void)connectionDidFinishLoadingWithUnEncodedPayload:(NSData*)payload request:(NSURLRequest*)request andTag:(void*)userdata { }

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
	DLog(@"");
	[self stopProgress];
	
	NSString* tag = [(NSString*)userdata retain];
			
	if ([tag isEqualToString:@"rpx_result"])
	{
    	DLog(@"payload: %@", payload);
        DLog(@"tag:     %@", tag);
    
        if (![payload respondsToSelector:@selector(JSONValue)]) { /* TODO: Error */ }
        
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
				NSError *error = [[self setError:[NSString stringWithFormat:@"Authentication failed: %@", payload]
                                        withCode:JRAuthenticationFailedError
                                         andType:JRErrorTypeAuthenticationFailed] autorelease];
                
                userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
				[sessionData triggerAuthenticationDidFailWithError:error];
			}
			else
			{
				NSError *error = [[self setError:[NSString stringWithFormat:@"Authentication failed: %@", payload]
                                        withCode:JRAuthenticationFailedError
                                         andType:JRErrorTypeAuthenticationFailed] autorelease];
                
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
    else if ([tag isEqualToString:@"request"])
    {
        connectionDataAlreadyDownloadedThis = YES;
        [myWebView loadHTMLString:payload baseURL:[request URL]];
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
	else if ([tag isEqualToString:@"request"])
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

#define SKIP_THIS_WORK_AROUND 0
#define WEBVIEW_SHOULDNT_LOAD 0
- (BOOL)webviewShouldntLoadRequestDueToTheWindowsLiveFix:(NSURLRequest*)request
{
    if (![[sessionData currentProvider].name isEqualToString:@"live_id"]) 
        return SKIP_THIS_WORK_AROUND;
    
    if (connectionDataAlreadyDownloadedThis)
    {
        connectionDataAlreadyDownloadedThis = NO;
        return SKIP_THIS_WORK_AROUND;
    }
    
    DLog("Sending request to connection manager: %@", request);
    
	[JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:[NSString stringWithString:@"request"]];
    return YES;
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

	if ([self webviewShouldntLoadRequestDueToTheWindowsLiveFix:request])
        return WEBVIEW_SHOULDNT_LOAD;
    
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
        [self stopProgress];
        
        NSError *_error = [[self setError:[NSString stringWithFormat:@"Authentication failed: %@", [error localizedDescription]]
                                withCode:JRAuthenticationFailedError
                                 andType:JRErrorTypeAuthenticationFailed] autorelease];
        
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Log In Failed"
                                                         message:@"An error occurred while attempting to sign you in.  Please try again."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil] autorelease];
        [alert show];
        
        userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
        [sessionData triggerAuthenticationDidFailWithError:_error];
    }
}

- (void)webViewWithUrl:(NSURL*)url
{
	DLog(@"");
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[myWebView loadRequest:request];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    // return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
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
	
	[JRConnectionManager stopConnectionsForDelegate:self];
	[self stopProgress];
	
	[infoBar fadeOut];
	
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

    [super viewWillDisappear:animated];	
}

- (void)viewDidDisappear:(BOOL)animated
{
	DLog(@"");
    
    [myWebView loadHTMLString:@"" baseURL:[NSURL URLWithString:@"/"]];

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
	
    [customUI release];
    [myBackgroundView release];
	[myWebView release];
	[infoBar release];
		
    [super dealloc];
}
@end
