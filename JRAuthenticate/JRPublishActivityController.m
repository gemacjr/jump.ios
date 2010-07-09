//
//  JRPublishActivityController.m
//  JRAuthenticate
//
//  Created by lilli on 7/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define DEBUG
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


#import "JRPublishActivityController.h"

@implementation JRPublishActivityController
@synthesize myTableView;
@synthesize keyboardToolbar;
@synthesize shareButton;
@synthesize doneButton;

//@synthesize cellDisplayNameAndAction;
//@synthesize cellContentTitle;
//@synthesize cellContentDescription;
//@synthesize cellImage;
//@synthesize cellUserContent;
//@synthesize myCell;


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

	jrAuth = [[JRAuthenticate jrAuthenticate] retain];
	sessionData = [[((JRModalNavigationController*)[[self navigationController] parentViewController]) sessionData] retain];
	activity = [[((JRModalNavigationController*)[[self navigationController] parentViewController]) activity] retain];

	label = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardDidShow:) 
                                                 name:UIKeyboardDidShowNotification 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardDidHide:) 
                                                 name:UIKeyboardDidHideNotification 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];
    
 	self.title = @"Publish Activity";
	
	if (!label)
	{
		label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont boldSystemFontOfSize:20.0];
		label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
		label.textAlignment = UITextAlignmentCenter;
		label.textColor = [UIColor whiteColor];
        
		self.navigationItem.titleView = label;
	}
	label.text = @"Publish Activity";
	
	if (!infoBar)
	{
		infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, 388, 320, 30) andStyle:[sessionData hidePoweredBy]];
		[self.view addSubview:infoBar];
	}
	[infoBar fadeIn];	
	
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] 
									  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
									  target:[self navigationController].parentViewController
									  action:@selector(cancelButtonPressed:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = cancelButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;
    
//    keyboardToolbar.alpha = 0.0;
//    [keyboardToolbar setFrame:CGRectMake(0, 416, 320, 44)];

    
	[myTableView reloadData];
}

- (void)keyboardWillShow:(NSNotification *)notif
{
//    [keyboardToolbar setHidden:NO];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];	

    [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
//    [UIView beginAnimations:@"show" context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView	setAnimationDelay:0.0];
//    [keyboardToolbar setFrame:CGRectMake(0, 156, 320, 44)];
//    [keyboardToolbar setAlpha:1.0];
//    [UIView commitAnimations];    
}

- (void)keyboardDidShow:(NSNotification *)notif
{
    
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];	
    
    [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
//    [UIView beginAnimations:@"show" context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView	setAnimationDelay:0.0];
//    [keyboardToolbar setFrame:CGRectMake(0, 416, 320, 44)];
//    [keyboardToolbar setAlpha:0.0];
//    [UIView commitAnimations];    
}

- (void)keyboardDidHide:(NSNotification *)notif
{
//    [keyboardToolbar setHidden:YES];
}


- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
 	NSString* tag = (NSString*)userdata; 
	[payload retain];
	
	DLog(@"request (retain count: %d): %@/n", [request retainCount], [[request URL] absoluteString]);
	DLog(@"payload (retain count: %d): %@/n", [payload retainCount], payload);
	DLog(@"tag     (retain count: %d): %@/n", [tag retainCount], tag);
    
	[tag release];	
}

- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(void*)userdata 
{
	NSString* tag = (NSString*)userdata;
	[tag release];	
    
    DLog("There was an error in sharing/n");    
}

- (void)connectionWasStoppedWithTag:(void*)userdata 
{
	[(NSString*)userdata release];
}


- (void)jrAuthenticateDidNotCompleteAuthentication:(JRAuthenticate*)jrAuth { }

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didFailWithError:(NSError*)error { }

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth callToTokenURL:(NSString*)tokenURL didFailWithError:(NSError*)error { }


- (IBAction)shareButtonPressed:(id)sender
{
    if (userContent_textview.text)
        activity.user_generated_content = userContent_textview.text;
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionaryWithObject:activity.action forKey:@"action"];
    
    [jsonDict setValue:(activity.user_generated_content?activity.user_generated_content:nil) forKey:@"user_generated_content"];
    [jsonDict setValue:(activity.title?activity.title:nil) forKey:@"title"];
    [jsonDict setValue:(activity.description?activity.description:nil) forKey:@"description"];
                              
    NSString *content = [jsonDict JSONRepresentation];                          
    NSRange range = { 1, content.length-2 };
    content = [content substringWithRange:range];
    NSString *identifier = [[sessionData authenticatedIdentifierForProvider:sessionData.currentSocialProvider.name] retain];
    
    //NSString* content = [NSString stringWithFormat:@"\"action\" : { \"%@\" \
                                                     \""];
	
	NSMutableData* body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"identifier=%@", identifier] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"&content=%@", content] dataUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest* request = [[NSMutableURLRequest requestWithURL:
									 [NSURL URLWithString:@"http://social-tester.appspot.com/shareThis"]] retain];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:body];
	
    
	NSString* tag = [[NSString stringWithString:@"shareThis"] retain];
	
	[JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag];
	
	[request release];
    
}

- (IBAction)doneButtonPressed:(id)sender
{
    [hideKeyboardButton removeFromSuperview];
    [userContent_textview resignFirstResponder];    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//	return 200;
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 315;

    return 100;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (indexPath.section == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sectionTwo"];
        
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sectionTwo"] autorelease];
            UIView *view = cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 120)] autorelease];
            view.backgroundColor = cell.backgroundColor = [UIColor clearColor];
            
            UIButton *bigShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [bigShareButton setFrame:CGRectMake(10, 0, 280, 38)];
            
            [bigShareButton setBackgroundImage:[UIImage imageNamed:@"big_blue_button.png"] forState:UIControlStateNormal];
            bigShareButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
            [bigShareButton setTitle:@"Share" forState:UIControlStateNormal];
            [bigShareButton setTitleColor:[UIColor whiteColor] 
                                 forState:UIControlStateNormal];
            [bigShareButton setTitleShadowColor:[UIColor grayColor]
                                       forState:UIControlStateNormal];
            
            [bigShareButton setTitle:@"Share" forState:UIControlStateSelected];
            [bigShareButton setTitleColor:[UIColor whiteColor] 
                                 forState:UIControlStateSelected];	
            [bigShareButton setTitleShadowColor:[UIColor grayColor]
                                       forState:UIControlStateSelected];	
            [bigShareButton setReversesTitleShadowWhenHighlighted:YES];
            
            [bigShareButton addTarget:self
                               action:@selector(shareButtonPressed:) 
                     forControlEvents:UIControlEventTouchUpInside];
            
//            UILabel *shareLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 35)] autorelease];
//            shareLabel.font = [UIFont boldSystemFontOfSize:24.0];
//            shareLabel.textAlignment = UITextAlignmentCenter;
//            shareLabel.backgroundColor = [UIColor blueColor];
//            shareLabel.text = @"Share";
//            
            [cell.contentView addSubview:bigShareButton];
        
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;    
    }
    
    DLog(@"cell for %@", sessionData.currentSocialProvider.name);   
    
//  static NSInteger displayNameAndAction_tag = 1;
//	static NSInteger contentTitle_tag = 2;
//	static NSInteger contentDescription_tag = 3;
//	static NSInteger thumbnail_tag = 4;
//	static NSInteger userContent_tag = 5;
  
	UITableViewCellStyle style = UITableViewCellStyleDefault;
	NSString *reuseIdentifier = @"cachedCell";

    UITableViewCell *cell =
        (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
	if (cell == nil)
    {
		cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier] autorelease];
		CGRect frame;
		frame.origin.x = 10; 
		frame.origin.y = 5;
		frame.size.height = 345;
		frame.size.width = 280;
		
        displayNameAndAction_label  = [[[UITextView alloc] initWithFrame:CGRectMake(2, 0, 297, 26)] autorelease];
        contentTitle_label          = [[[UITextView alloc] initWithFrame:CGRectMake(97, 30, 203, 25)] autorelease];
        contentDescription_label    = [[[UITextView alloc] initWithFrame:CGRectMake(97, 45, 203, 75)] autorelease];
        thumbnail_imageview         = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 90, 90)] autorelease];
        userContent_textview        = [[[UITextView alloc] initWithFrame:CGRectMake(10, 128, 280, 177)] autorelease];
        
        UIButton *userContent_background = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [userContent_background setFrame:CGRectMake(10, 125, 280, 180)];
        
//        displayNameAndAction_label.tag  = displayNameAndAction_tag;
//        contentTitle_label.tag          = contentTitle_tag;
//        contentDescription_label.tag    = contentDescription_tag;
//        thumbnail_imageview.tag         = thumbnail_tag;
//        userContent_textview.tag        = userContent_tag;
        
        displayNameAndAction_label.backgroundColor  = [UIColor clearColor];
        contentTitle_label.backgroundColor          = [UIColor clearColor];
        contentDescription_label.backgroundColor    = [UIColor clearColor];
        thumbnail_imageview.backgroundColor         = [UIColor clearColor];
        userContent_textview.backgroundColor        = [UIColor clearColor];
        
        userContent_background.userInteractionEnabled = FALSE;
//        [userContent_background ssetButtonType:UIButtonTypeRoundedRect];    
        
        displayNameAndAction_label.scrollEnabled = FALSE;
        displayNameAndAction_label.userInteractionEnabled = FALSE;
        displayNameAndAction_label.font = [UIFont systemFontOfSize:14.0];
//        displayNameAndAction_label.minimumFontSize = 10.0;
//        displayNameAndAction_label.numberOfLines = 2;
//        [displayNameAndAction_label setAdjustsFontSizeToFitWidth:YES];
        
        contentTitle_label.scrollEnabled = FALSE;
        contentTitle_label.userInteractionEnabled = FALSE;
        contentTitle_label.font = [UIFont systemFontOfSize:12.0];
//        contentTitle_label.minimumFontSize = 8.0;
//        contentTitle_label.numberOfLines = 1;
//        [contentTitle_label setAdjustsFontSizeToFitWidth:YES];
        
        contentDescription_label.scrollEnabled = FALSE;
        contentDescription_label.userInteractionEnabled = FALSE;
        contentDescription_label.font = [UIFont systemFontOfSize:12.0];
//        contentDescription_label.minimumFontSize = 8.0;
//        contentDescription_label.numberOfLines = 3;
//        [contentDescription_label setAdjustsFontSizeToFitWidth:YES];
        
        thumbnail_imageview.image = [UIImage imageNamed:@"lilli.jpg"];
        
        userContent_textview.keyboardType = UIKeyboardTypeDefault;
        userContent_textview.inputAccessoryView = keyboardToolbar;
//        userContent_textview.returnKeyType = UIReturnKeyReturn;
//        userContent_textview.enablesReturnKeyAutomatically = YES;
//        userContent_textview.keyboardAppearance = UIKeyboardAppearanceAlert;
//        [userContent_textview canResignFirstResponder:YES];
        
        [cell.contentView addSubview:userContent_background];
        [cell.contentView addSubview:displayNameAndAction_label];
        [cell.contentView addSubview:contentTitle_label];
        [cell.contentView addSubview:contentDescription_label];
        [cell.contentView addSubview:thumbnail_imageview];
        [cell.contentView addSubview:userContent_textview];

        displayNameAndAction_label.text = [NSString stringWithFormat:@"%@ %@", activity.display_name, activity.action];
        contentTitle_label.text = [NSString stringWithFormat:@"%@", activity.title];
        contentDescription_label.text = [NSString stringWithFormat:@"%@", activity.description];
        userContent_textview.text = [NSString stringWithFormat:@"%@", activity.user_generated_content];        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }        
	
    
	return cell;
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
