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

 File:	 FeedReaderFeeds.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, August 24, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "FeedReaderFeeds.h"

@implementation FeedReaderFeeds
@synthesize feedButton;
@synthesize janrainLink;
//@synthesize layoutView;

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

    reader = [FeedReader feedReader];
    self.title = @"Home";

    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)] autorelease];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];

    self.navigationItem.titleView = titleLabel;

    titleLabel.text = NSLocalizedString(@"Quick Publish!", @"");

    if ([reader.allStories count] == 0)
        [feedButton setEnabled:NO];
    else
        [feedButton setEnabled:YES];

    janrainLink.titleLabel.textColor = [UIColor colorWithRed:0.05 green:0.19 blue:0.27 alpha:1.0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
//    switch (toInterfaceOrientation)
//    {
//        case UIInterfaceOrientationPortrait:
//            [layoutView setFrame:CGRectMake(, , , )
//            break;
//        default:
//            break;
//    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([reader.allStories count] == 0)
        [reader downloadFeed:self];
}

- (IBAction)janrainBlogSelected:(id)sender
{
    if ([reader.allStories count] == 0)
    {
        [reader downloadFeed:self];
    }
    else
    {
        [summaryViewController release];

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            summaryViewController = [[FeedReaderSummary alloc] initWithNibName:@"FeedReaderSummary-iPad"
                                                                        bundle:[NSBundle mainBundle]];
        else
            summaryViewController = [[FeedReaderSummary alloc] initWithNibName:@"FeedReaderSummary"
                                                                        bundle:[NSBundle mainBundle]];

        [self.navigationController pushViewController:summaryViewController animated:YES];
    }
}

- (IBAction)janrainLinkClicked:(id)sender
{
	NSURL *url = [NSURL URLWithString:@"http://www.janrain.com"];
	if (![[UIApplication sharedApplication] openURL:url])
		NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (void)feedDidFinishDownloading
{
    [feedButton setTitle:@"View Janrain Blog" forState:UIControlStateNormal];
    [feedButton setEnabled:YES];
}

- (void)feedDidFailToDownload
{
    if ([[FeedReader feedReader].allStories count] == 0)
    {
        UIAlertView * errorAlert = [[[UIAlertView alloc] initWithTitle:@"Error loading content"
                                                               message:@"There was an error downloading the Janrain Blog"
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil] autorelease];
        [errorAlert show];

        [feedButton setTitle:@"Reload Janrain Blog" forState:UIControlStateNormal];
        [feedButton setEnabled:YES];
    }
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
    [janrainLink release];
    [summaryViewController release];
    [feedButton release];

    [super dealloc];
}
@end
