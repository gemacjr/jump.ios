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

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        iPad = YES;
}

static NSString *iPadStyle = @" \
body                            \
{                               \
    /*width:680px;*/            \
    font-family:\"Helvetica\";  \
    color:#333333;              \
    font-size:20px;             \
    padding:0px;                \
    margin:44px;                \
}                               \
                                \
div.title                       \
{                               \
    font-size:24px;             \
    color:#074764;              \
}                               \
                                \
div.date                        \
{                               \
    font-size:16px;             \
    color:#999999;              \
}                               \
                                \
p                               \
{                               \
    color:#333333;              \
    font-size:20px;             \
}";

static NSString *iPhoneStyle = @"\
body                            \
{                               \
    /*width:300px;*/            \
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
}";

static NSString *commonStyle = @"\
a:link    { color:#009DDC; }     \
a:visited { color:#074764; }     \
a:active  { color:#7AC143; }";


- (void)viewWillAppear:(BOOL)animated
{
    DLog(@"");
    [super viewWillAppear:animated];

    story = [[FeedReader feedReader].selectedStory retain];

    self.title = @"Article";

    webViewContent = [[NSString stringWithFormat:
                        @"<html>                                    \
                            <head>                                  \
                                <style type=\"text/css\">           \
                                    %@                              \
                                    %@                              \
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
                        iPad ? iPadStyle : iPhoneStyle,
                        commonStyle,
                        story.title,
                        story.pubDate,
                        story.description] retain];

    DLog("%@", webViewContent);

    [webview loadHTMLString:webViewContent baseURL:[NSURL URLWithString:story.feedUrl]];

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
        {
            if (iPad)
                feedReaderWebview = [[FeedReaderWebView alloc] initWithNibName:@"FeedReaderWebView-iPad"
                                                                        bundle:[NSBundle mainBundle]];
            else
                feedReaderWebview = [[FeedReaderWebView alloc] initWithNibName:@"FeedReaderWebView"
                                                                        bundle:[NSBundle mainBundle]];
        }

        [feedReaderWebview setUrlRequest:request];

        [[self navigationController] pushViewController:feedReaderWebview animated:YES];

        return NO;
    }

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView { }

- (void)webViewDidFinishLoad:(UIWebView *)webView { }

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error { }

- (IBAction)shareButtonPressed:(id)sender
{
    JRActivityObject *activity = [[[JRActivityObject alloc]
                                  initWithAction:@"shared an article from the Janrain Blog."
                                  andUrl:story.link] autorelease];

    activity.title = story.title;

    NSInteger trunk = /*(iPad)*/ 0 ? 300 : 200;
    activity.description = [story.plainText substringToIndex:
                            ((story.plainText.length < trunk) ? story.plainText.length : trunk)];

    if ([story.storyImages count] > 0)
    {
        StoryImage *storyImage = [story.storyImages objectAtIndex:0];

        // TODO: Shouldn't I be setting the preview in the library?
        JRImageMediaObject *image = [[[JRImageMediaObject alloc] initWithSrc:storyImage.src andHref:story.feedUrl] autorelease];
        [image setPreview:storyImage.image];

        activity.media = [NSArray arrayWithObject:image];
    }

    activity.email = [JREmailObject emailObjectWithSubject:@"Check out this article from the Janrain Blog!"
                                            andMessageBody:[NSString stringWithFormat:@"<html><body><br /> \
                                                            I found this article on Janrain's Blog, \
                                                            and I thought you might be interested! \
                                                            <br /><a href=\"%@\">Click here to read it.</a><br /> \
                                                            <br /></body></html>%@",
                                                            story.link, webViewContent]
                                                    isHtml:YES
                                      andUrlsToBeShortened:[NSArray arrayWithObjects:story.link, nil]];
    activity.sms = [JRSmsObject smsObjectWithMessage:[NSString stringWithFormat:@"Check out this article from the Janrain Blog!\n\n%@", story.link]
                                andUrlsToBeShortened:[NSArray arrayWithObjects:story.link, nil]];

    // TODO: Why are we setting this??
//    [FeedReader feedReader].feedReaderDetail = self;

//    if (!iPad)
//        [[[FeedReader feedReader] jrEngage] setCustomNavigationController:self.navigationController];

    NSDictionary *custom = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.navigationItem.rightBarButtonItem, kJRPopoverPresentationBarButtonItem, 
                            self.navigationController, kJRApplicationNavigationController, nil];

    [[[FeedReader feedReader] jrEngage] showSocialPublishingDialogWithActivity:activity andCustomInterface:custom];
//    [[[FeedReader feedReader] jrEngage] showAuthenticationDialogWithCustomInterfaceOverrides:custom];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

//    [[[FeedReader feedReader] jrEngage] cancelPublishing];

    [webview stopLoading];
	[webview loadHTMLString:@"" baseURL:[NSURL URLWithString:@"/"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [story release];
    [webview release];
    [feedReaderWebview release];

    [super dealloc];
}
@end
