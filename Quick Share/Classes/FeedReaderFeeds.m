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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
    
    FeedReader *reader = [FeedReader initFeedReader];
    [reader addFeedForUrl:@"http://www.janrain.com/feed/blogs"];

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
    
    feedAdder.textAlignment = UITextAlignmentLeft;
    feedAdder.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    feedAdder.clearsOnBeginEditing = YES;
    feedAdder.clearButtonMode = UITextFieldViewModeWhileEditing;
    feedAdder.autocorrectionType = UITextAutocorrectionTypeNo;
    feedAdder.autocapitalizationType = UITextAutocapitalizationTypeNone;
    feedAdder.keyboardType = UIKeyboardTypeURL;
    feedAdder.returnKeyType = UIReturnKeyDone;
    feedAdder.enablesReturnKeyAutomatically = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //	TODO: Get this working
    //	UITableViewUserLandingCell* cell = (UITableViewUserLandingCell*)[myTableView cellForRowAtIndexPath:0];
    //	
    //	if (range.location == 0 && string.length == 0)
    //	{
    //		[cell.signInButton setEnabled:NO];
    //		[cell.bigSignInButton setEnabled:NO];
    //	}
    //	if (range.location == 0 && string.length != 0)
    //	{
    //		[cell.signInButton setEnabled:YES];
    //		[cell.bigSignInButton setEnabled:YES];
    //	}
	
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    //	TODO: Get this working
    //	UITableViewUserLandingCell* cell = (UITableViewUserLandingCell*)[myTableView cellForRowAtIndexPath:0];
    //	[cell.signInButton setEnabled:NO];
    //	[cell.bigSignInButton setEnabled:NO];
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[FeedReader feedReader] addFeedForUrl:textField.text];
    [feedAdder resignFirstResponder];
    
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}


- (IBAction)janrainBlogSelected:(id)sender
{
    FeedReaderSummary *summaryViewController = [[FeedReaderSummary alloc] initWithNibName:@"FeedReaderSummary" bundle:[NSBundle mainBundle]];
    
    //        detailViewController.story = [sortedStories objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:summaryViewController animated:YES];
    [summaryViewController release];
    
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


- (void)dealloc {
    [super dealloc];
}


@end
