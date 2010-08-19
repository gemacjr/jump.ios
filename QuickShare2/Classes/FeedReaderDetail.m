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
                                                div.main                        \
                                                {                               \
                                                    width:300px;                \
                                                    font-family:\"Helvetica\";  \
                                                }                               \
                                                                                \
                                                body                            \
                                                {                               \
                                                    #background-color:c3e8f7;   \
                                                  #  margin:0px; \
                                                }                               \
                                                                                \
                                                h1                              \
                                                {                               \
                                                    font-size:20px;             \
                                                    padding:0px;                \
                                                    margin:3px;                 \
                                                }                               \
                                                                                \
                                                h2                              \
                                                {                               \
                                                    font-size:16px;             \
                                                    padding:0px;                \
                                                    margin:3px;                 \
                                                }                               \
                                                                                \
                                                p                               \
                                                {                               \
                                                    font-size:18px;            \
                                                    padding:0px;                \
                                                    margin:3px;                 \
                                                }                               \
                                                                                \
                                                img                             \
                                                {                               \
                                                    #max-width:100\%;            \
                                                    #max-height:100\%;           \
                                                    padding:0px;                \
                                                    margin:3px;                 \
                                                }                               \
                                                                                \
                                            </style>                            \
                                        </head>                                 \
                                                                                \
                                        <body>                                  \
                                            <div class=\"main\">                \
                                                <h1>%@</h1>                     \
                                                <h2>%@</h2>                     \
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
        FeedReaderWebView *feedReaderWebview = [[FeedReaderWebView alloc] init];
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
    JRActivityObject *activity = [[JRActivityObject alloc] 
                                  initWithAction:[NSString stringWithFormat:@"wants to share an article from the %@ rss feed.", story.feed.title]
                                  andUrl:story.link];
    
    activity.title = story.title;
    activity.description = [story.plainText substringToIndex:100];
    
    if ([story.storyImages count] > 0)
    {
        StoryImage *storyImage = [story.storyImages objectAtIndex:0];
    
        JRImageMediaObject *image = [[JRImageMediaObject alloc] initWithSrc:storyImage.src andHref:story.feed.link];
        [image setPreview:storyImage.image];
    
        [activity.media addObject:image];
    }
    
    [[[FeedReader feedReader] jrAuthenticate] showPublishingDialogWithActivity:activity];
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
    [super dealloc];
}


@end
