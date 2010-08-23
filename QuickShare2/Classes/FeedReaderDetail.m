//
//  FeedReaderDetail.m
//  Quick Share
//
//  Created by lilli on 8/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

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

    self.title = [NSString stringWithString:story.title];
    
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
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;
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

- (void)shareButtonPressed:(id)sender
{
    JRActivityObject *activity = [[[JRActivityObject alloc] 
                                  initWithAction:[NSString stringWithFormat:@"wants to share an article from the %@ rss feed.", story.feed.title]
                                  andUrl:story.link] autorelease];
    
    activity.title = story.title;
    activity.description = [story.plainText substringToIndex:100];
    
    if ([story.storyImages count] > 0)
    {
        StoryImage *storyImage = [story.storyImages objectAtIndex:0];
    
        JRImageMediaObject *image = [[[JRImageMediaObject alloc] initWithSrc:storyImage.src andHref:story.feed.link] autorelease];
        [image setPreview:storyImage.image];
    
        [activity.media addObject:image];
    }
    
    [FeedReader feedReader].feedReaderDetail = self;
    [[[FeedReader feedReader] jrAuthenticate] setCustomNavigationController:self.navigationController];
    [[[FeedReader feedReader] jrAuthenticate] showPublishingDialogWithActivity:activity];
}

- (void)authenticationFailed:(NSError*)error
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Sign in failed"
                                                     message:@"There seems to have been a problem authenticating.  Please try again."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK" 
                                           otherButtonTitles:nil] autorelease];
    [alert show];    
}

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
