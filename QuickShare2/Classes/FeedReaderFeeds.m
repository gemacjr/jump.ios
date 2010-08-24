//
//  FeedReaderFeeds.m
//  QuickShare
//
//  Created by lilli on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FeedReaderFeeds.h"


@implementation FeedReaderFeeds

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

    FeedReader *reader = [FeedReader feedReader];
    self.title = @"Feeds";
    
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


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (IBAction)janrainBlogSelected:(id)sender
{
    summaryViewController = [[FeedReaderSummary alloc] initWithNibName:@"FeedReaderSummary" bundle:[NSBundle mainBundle]];
    
    [self.navigationController pushViewController:summaryViewController animated:YES];
}

- (IBAction)janrainLinkClicked:(id)sender
{
	NSURL *url = [NSURL URLWithString:@"http://www.janrain.com"];
	if (![[UIApplication sharedApplication] openURL:url])	
		NSLog(@"%@%@",@"Failed to open url:",[url description]);
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
    [feedButton release];
    [super dealloc];
}


@end
