//
//  FeedReaderWebView.m
//  QuickShare
//
//  Created by lilli on 8/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FeedReaderWebView.h"


@implementation FeedReaderWebView
@synthesize urlRequest;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [webview loadRequest:urlRequest];    
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

- (void)webViewDidStartLoad:(UIWebView *)webView 
{ 
	[self startProgress];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
    [self stopProgress];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
    [self stopProgress];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [webview loadHTMLString:@"" baseURL:[NSURL URLWithString:@"/"]];
    
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [urlRequest release];
    [super dealloc];
}


@end
