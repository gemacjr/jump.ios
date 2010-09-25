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
 
 File:	 FeedReaderDetail.m 
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, August 24, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


#import "FeedReaderDetail.h"


@implementation FeedReaderDetail

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    DLog(@"");
    [super viewWillAppear:animated];
    
    story = [[FeedReader feedReader].selectedStory retain];

    self.title = @"Article";//[NSString stringWithString:story.title];
    
    NSString *webViewContent = [NSString stringWithFormat:
                                    @"<html>                                    \
                                        <head>                                  \
                                            <style type=\"text/css\">           \
                                                                                \
                                                body                            \
                                                {                               \
                                                    width:300px;                \
                                                    font-family:\"Helvetica\";  \
                                                    color:#333333;              \
                                                    font-size:14px;             \
                                                    padding:0px;                \
                                                    margin:10px;                \
                                                }                               \
                                                                                \
                                                div.title                       \
                                                {                               \
                                                    font-size:16px;             \
                                                    color:#074764;              \
                                                }                               \
                                                                                \
                                                div.date                        \
                                                {                               \
                                                    font-size:12px;             \
                                                    color:#999999;              \
                                                }                               \
                                                                                \
                                                p                               \
                                                {                               \
                                                    color:#333333;              \
                                                    font-size:14px;             \
                                                }                               \
                                                                                \
                                                a:link    { color:#009DDC; }    \
                                                a:visited { color:#074764; }    \
                                                a:active  { color:#7AC143; }    \
                                                                                \
                                            </style>                            \
                                        </head>                                 \
                                                                                \
                                        <body>                                  \
                                            <div class=\"main\">                \
                                                <div class=\"title\">%@</div>   \
                                                <div class=\"date\">%@</div>    \
                                                %@                              \
                                            </div>                              \
                                        </body>                                 \
                                    </html>", 
                                story.title,
                                story.pubDate,
                                story.description];

    [webview loadHTMLString:webViewContent baseURL:[NSURL URLWithString:story.feed.link]];
//    webview.backgroundColor = [UIColor colorWithRed:(201/255) green:(234/255) blue:(237/255) alpha:1.0];

    
    UIBarButtonItem *shareButton = [[[UIBarButtonItem alloc] initWithTitle:@"Share" 
                                                                     style:UIBarButtonItemStyleBordered 
                                                                    target:self
                                                                    action:@selector(shareButtonPressed:)] autorelease];
									
	self.navigationItem.rightBarButtonItem = shareButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType 
{	
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        if (!feedReaderWebview)
            feedReaderWebview = [[FeedReaderWebView alloc] initWithNibName:@"FeedReaderWebView" bundle:[NSBundle mainBundle]];

        [feedReaderWebview setUrlRequest:request];
        
        [[self navigationController] pushViewController:feedReaderWebview animated:YES];
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView 
{ 
}

- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
}

- (IBAction)shareButtonPressed:(id)sender
{
    // QTS: What happens if someone passes in a straight (static) string, and not an NSString object?
    JRActivityObject *activity = [[[JRActivityObject alloc] 
                                  initWithAction:@"shared an article from the Janrain Blog."
                                  andUrl:story.link] autorelease];
    
    activity.title = story.title;
    activity.description = story.plainText;
    
    if ([story.storyImages count] > 0)
    {
        StoryImage *storyImage = [story.storyImages objectAtIndex:0];
    
        JRImageMediaObject *image = [[[JRImageMediaObject alloc] initWithSrc:storyImage.src andHref:story.feed.link] autorelease];
        [image setPreview:storyImage.image];
    
        [activity.media addObject:image];
    }
    
    [FeedReader feedReader].feedReaderDetail = self;
    [[[FeedReader feedReader] jrEngage] setCustomNavigationController:self.navigationController];
    [[[FeedReader feedReader] jrEngage] showSocialPublishingDialogWithActivity:activity];
}

//- (void)authenticationFailed:(NSError*)error
//{
//    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Sign in failed"
//                                                     message:@"There seems to have been a problem authenticating.  Please try again."
//                                                    delegate:nil
//                                           cancelButtonTitle:@"OK" 
//                                           otherButtonTitles:nil] autorelease];
//    [alert show];    
//}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [webview stopLoading];
	[webview loadHTMLString:@"" baseURL:[NSURL URLWithString:@"/"]];
}

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
    [story release];
    [webview release];
    [feedReaderWebview release];
    
    [super dealloc];
}


@end
