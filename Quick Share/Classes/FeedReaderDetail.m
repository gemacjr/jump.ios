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

    NSString *webViewContent = [NSString stringWithFormat:
                                    @"<html>                                    \
                                        <head>                                  \
                                            <style type=\"text/css\">           \
                                                div.main                        \
                                                {                               \
                                                    width:300px;                \
                                                    font-family:\"Helvetica\";  \
                                                }                               \
                                                body                        \
                                                {                               \
                                                width:300px;                \
                                                }                               \
                                                                                \
                                                h1                              \
                                                {                               \
                                                    font-size:18px;             \
                                                    padding:0px;                \
                                                    margin:3px;                 \
                                                    border:1px solid red; \
                                                }                               \
                                                                                \
                                                h2                              \
                                                {                               \
                                                    font-size:15px;             \
                                                    padding:0px;                \
                                                    margin:3px;                 \
                                                    border:1px solid green; \
                                                }                               \
                                                                                \
                                                p                               \
                                                {                               \
                                                    #font-size:12px;            \
                                                    padding:0px;                \
                                                    margin:3px;                 \
                                                    border:1px solid blue; \
                                                }                               \
                                                                                \
                                                img                             \
                                                {                               \
                                                    max-width:100\%;            \
                                                    #max-height:100\%            \
                                                }                               \
                                                                                \
                                            </style>                            \
                                        </head>                                 \
                                                                                \
                                        <body>                                  \
                                            <!--div class=\"main\"-->                \
                                                <h1>%@</h1>                     \
                                                <h2>%@</h2>                     \
                                                %@                              \
                                            <!--/div-->                              \
                                        </body>                                 \
                                    </html>", 
                                story.title,
                                story.pubDate,
                                story.description];

    [webview loadHTMLString:webViewContent baseURL:[NSURL URLWithString:story.feed.link]];
    
//    storyTitle.text = story.title;
//    storyDate.text = story.pubDate;
//
//    NSString *path = [[NSBundle mainBundle] bundlePath];
//    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
//  NSString *webViewContent = [NSString stringWithFormat:
//                                @"  <div id=\"image\" style=\"float:left;width:200px\">\
//                                        <img src=\"share_button.png\" style=/>\
//                                    </div>\
//                                    <div id=\"content\">\
//                                        %@\
//                                    </div>", 
//                                story.description];
  
//    [storyContent loadHTMLString:webViewContent baseURL:baseURL];
//    [storyContent loadHTMLString:story.description baseURL:[NSURL URLWithString:story.feed.link]];
    
//    storySection3.text = story.description;

//   storySection3.numberOfLines = 0;
//    [storySection3 sizeToFit];
    
//    CGRect frame = contentView.frame;
//    NSUInteger newHeight = storySection3.frame.origin.y + storySection3.frame.size.height + 10;
//    [contentView setFrame:CGRectMake(0, 0, 320, newHeight)];
//    [scrollView scrollRectToVisible:CGRectMake(0, 384, 320, 416) animated:YES];
    
//    frame = contentView.frame;
//    [scrollView setContentSize:frame.size];
    
    //[scrollView sizeToFit];
    
    
//    storyDescription.text = [NSString stringWithString:story.description];
//  storyMedia.backgroundColor = [UIColor blueColor];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [scrollView scrollRectToVisible:CGRectMake(0, 384, 320, 416) animated:YES];
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
