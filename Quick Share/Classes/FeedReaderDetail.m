//
//  FeedReaderDetail.m
//  Quick Share
//
//  Created by lilli on 8/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

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
    [super viewWillAppear:animated];
    
    story = [[FeedReader feedReader].selectedStory retain];

    self.title = [NSString stringWithString:story.title];
    
    NSError *error;
    NSRegularExpression *regexHeight = [NSRegularExpression regularExpressionWithPattern:@"<img(.*?)(height:.*?;)(.*?)>"
                                                                                 options:0
                                                                                   error:&error];
    if (error)
        return;    

    NSRegularExpression *regexWidth = [NSRegularExpression regularExpressionWithPattern:@"<img(.*?)(width:.*?;)(.*?)>"
                                                                                 options:0
                                                                                   error:&error];
    if (error)
        return;    
    
    NSString *string1 = [regexHeight stringByReplacingMatchesInString:story.description
                                                              options:0
                                                                range:NSMakeRange(0, [story.description length])
                                                         withTemplate:@"<img$1$3>"];
    
    NSString *string2 = [regexWidth stringByReplacingMatchesInString:string1
                                                             options:0
                                                               range:NSMakeRange(0, [string1 length])
                                                        withTemplate:@"<img$1$3>"];
                                
 
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
                                                h1                              \
                                                {                               \
                                                    font-size:18px;             \
                                                    padding:0px;                \
                                                    margin:3px;                 \
                                                }                               \
                                                                                \
                                                h2                              \
                                                {                               \
                                                    font-size:15px;             \
                                                    padding:0px;                \
                                                    margin:3px;                 \
                                                }                               \
                                                                                \
                                                p                               \
                                                {                               \
                                                    #font-size:12px;            \
                                                    padding:0px;                \
                                                    margin:3px;                 \
                                                }                               \
                                                                                \
                                                img                             \
                                                {                               \
                                                    max-width:100\%;            \
                                                    max-height:100\%;           \
                                                    padding:0px;                \
                                                    margin:3px;                 \
                                                    border:1px solid blue; \
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
                                string2];

    [webview loadHTMLString:webViewContent baseURL:[NSURL URLWithString:story.feed.link]];
    
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
    
    [[[FeedReader feedReader] jrAuthenticate] showPublishingDialogWithActivity:activity];
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


- (void)dealloc {
    [super dealloc];
}


@end
