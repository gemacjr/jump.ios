/* 
 Copyright (c) 2010, Janrain, Inc.
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer. 
 * Redistributions in binary
 form must reproduce the above copyright notice, this list of conditions and the
 following disclaimer in the documentation and/or other materials provided with
 the distribution. 
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
 */


#import "JRUserLandingController.h"

@interface UITableViewUserLandingCell : UITableViewCell 
{
	UIImageView	*logo;
	UILabel		*welcomeLabel;
	UITextField *textField;
	UIButton	*signInButton;
	UIButton	*backToProvidersButton;
	UIButton	*bigSignInButton;
	UIButton	*forgetUserButton;
}

@property (retain) 	UIImageView	*logo;
@property (retain) 	UILabel		*welcomeLabel;
@property (retain) 	UITextField *textField;
@property (retain) 	UIButton	*signInButton;
@property (retain) 	UIButton	*backToProvidersButton;
@property (retain) 	UIButton	*bigSignInButton;
@property (retain) 	UIButton	*forgetUserButton;

@end

@implementation UITableViewUserLandingCell

@synthesize logo;
@synthesize welcomeLabel;
@synthesize textField;
@synthesize signInButton;
@synthesize backToProvidersButton;
@synthesize bigSignInButton;
@synthesize forgetUserButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
											  targetForSelector:(id)targetForSelector
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		logo = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 280, 63)];
		[self addSubview:logo];
				
		welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 280, 25)];
		welcomeLabel.adjustsFontSizeToFitWidth = YES;
		welcomeLabel.font = [UIFont boldSystemFontOfSize:20];
		welcomeLabel.textColor = [UIColor blackColor];
		welcomeLabel.backgroundColor = [UIColor clearColor];
		welcomeLabel.textAlignment = UITextAlignmentLeft;
		[self addSubview:welcomeLabel];	
		
		
		forgetUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[forgetUserButton setFrame:CGRectMake(188, 62, 85, 33)];
		
		[forgetUserButton setBackgroundImage:[UIImage imageNamed:@"forget_me_button.png"] forState:UIControlStateNormal];
		[forgetUserButton setFont:[UIFont systemFontOfSize:13.0]];
		forgetUserButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 9, 0);
		[forgetUserButton setTitle:@"forget me" forState:UIControlStateNormal];
		[forgetUserButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.8]//blueColor] 
							  forState:UIControlStateNormal];
		[forgetUserButton setTitleShadowColor:[UIColor grayColor]
									forState:UIControlStateNormal];
		
		[forgetUserButton setBackgroundImage:[UIImage imageNamed:@"forget_me_button_down.png"] forState:UIControlStateHighlighted];
		[forgetUserButton setTitle:@"forget me" forState:UIControlStateHighlighted];
		[forgetUserButton setTitleColor:[UIColor whiteColor]
							  forState:UIControlStateHighlighted];	
		[forgetUserButton setTitleShadowColor:[UIColor grayColor]
									forState:UIControlStateHighlighted];	
		[forgetUserButton setReversesTitleShadowWhenHighlighted:YES];
		
		[forgetUserButton addTarget:targetForSelector
							action:@selector(forgetUserTouchUpInside) 
				  forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:forgetUserButton];
		
				
				
		textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 83, 280, 35)];
		textField.adjustsFontSizeToFitWidth = YES;
		textField.textColor = [UIColor blackColor];
		textField.font = [UIFont systemFontOfSize:15.0];
		textField.backgroundColor = [UIColor clearColor];
		textField.borderStyle = UITextBorderStyleRoundedRect;
		textField.textAlignment = UITextAlignmentLeft;
		textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		textField.clearsOnBeginEditing = YES;
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		textField.autocorrectionType = UITextAutocorrectionTypeNo;
		textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		textField.keyboardType = UIKeyboardTypeEmailAddress;
		textField.returnKeyType = UIReturnKeyDone;
		textField.enablesReturnKeyAutomatically = YES;
		
		textField.delegate = targetForSelector;
		
		[textField setHidden:YES];
		[self addSubview:textField];
				
		
		signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[signInButton setFrame:CGRectMake(165, 128, 135, 38)];
		
		[signInButton setBackgroundImage:[UIImage imageNamed:@"blue_button.png"] forState:UIControlStateNormal];
		[signInButton setFont:[UIFont boldSystemFontOfSize:20.0]];
		[signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
		[signInButton setTitleColor:[UIColor whiteColor] 
						   forState:UIControlStateNormal];
		[signInButton setTitleShadowColor:[UIColor grayColor]
								 forState:UIControlStateNormal];

		[signInButton setTitle:@"Sign In" forState:UIControlStateSelected];
		[signInButton setTitleColor:[UIColor whiteColor] 
						   forState:UIControlStateSelected];	
		[signInButton setTitleShadowColor:[UIColor grayColor]
								 forState:UIControlStateSelected];	
		[signInButton setReversesTitleShadowWhenHighlighted:YES];
		
		[signInButton addTarget:targetForSelector
						 action:@selector(signInButtonTouchUpInside:) 
			   forControlEvents:UIControlEventTouchUpInside];

		[self addSubview:signInButton];
		
		
		
		backToProvidersButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[backToProvidersButton setFrame:CGRectMake(20, 128, 135, 38)];
		
		[backToProvidersButton setBackgroundImage:[UIImage imageNamed:@"black_button.png"] forState:UIControlStateNormal];
		[backToProvidersButton setFont:[UIFont boldSystemFontOfSize:14.0]];
		[backToProvidersButton setTitle:@"Switch Accounts" forState:UIControlStateNormal];
		[backToProvidersButton setTitleColor:[UIColor whiteColor] 
									forState:UIControlStateNormal];
		[backToProvidersButton setTitleShadowColor:[UIColor grayColor]
										  forState:UIControlStateNormal];
		
		[backToProvidersButton setTitle:@"Switch Accounts" forState:UIControlStateSelected];
		[backToProvidersButton setTitleColor:[UIColor whiteColor] 
									forState:UIControlStateSelected];
		[backToProvidersButton setTitleShadowColor:[UIColor grayColor]
										  forState:UIControlStateSelected];
		[backToProvidersButton setReversesTitleShadowWhenHighlighted:YES];
		

		[backToProvidersButton addTarget:targetForSelector
								  action:@selector(backToProvidersTouchUpInside) 
						forControlEvents:UIControlEventTouchUpInside];	
		[self addSubview:backToProvidersButton];

		
		bigSignInButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[bigSignInButton setFrame:CGRectMake(20, 128, 280, 38)];
		
		[bigSignInButton setBackgroundImage:[UIImage imageNamed:@"big_blue_button.png"] forState:UIControlStateNormal];
		[bigSignInButton setFont:[UIFont boldSystemFontOfSize:20.0]];
		[bigSignInButton setTitle:@"Sign In" forState:UIControlStateNormal];
		[bigSignInButton setTitleColor:[UIColor whiteColor] 
						   forState:UIControlStateNormal];
		[bigSignInButton setTitleShadowColor:[UIColor grayColor]
								 forState:UIControlStateNormal];
		
		[bigSignInButton setTitle:@"Sign In" forState:UIControlStateSelected];
		[bigSignInButton setTitleColor:[UIColor whiteColor] 
						   forState:UIControlStateSelected];	
		[bigSignInButton setTitleShadowColor:[UIColor grayColor]
								 forState:UIControlStateSelected];	
		[bigSignInButton setReversesTitleShadowWhenHighlighted:YES];
		
		[bigSignInButton addTarget:targetForSelector
						 action:@selector(signInButtonTouchUpInside:) 
			   forControlEvents:UIControlEventTouchUpInside];
		
		[bigSignInButton setHidden:YES];
		[self addSubview:bigSignInButton];
	}
	
	return self;
}	

- (void)dealloc
{
	[logo release];
	[welcomeLabel release];
	[textField release];
	[signInButton release];
	[backToProvidersButton release];
	[bigSignInButton release];

	[super dealloc];
}
@end


@implementation JRUserLandingController

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
	
	jrAuth = [[JRAuthenticate jrAuthenticate] retain];

	sessionData = [[((JRModalNavigationController*)[[self navigationController] parentViewController]) sessionData] retain];
	
	label = nil;
	bar = nil;
	powered_by = nil;
	
    requiresInput = FALSE;
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSString*)customTitle
{
	if (!sessionData.currentProvider.provider_requires_input)
		return [NSString stringWithString:@"Welcome Back!"];
	
	NSArray *arr = [[sessionData.currentProvider.placeholder_text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@" "];
	NSRange subArr = {[arr count] - 2, 2};
	
	NSArray *newArr = [arr subarrayWithRange:subArr];
	return [newArr componentsJoinedByString:@" "];	
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];

	int yPos = (self.view.frame.size.height - 20);
	
	self.title = [self customTitle];
	
	if (!label)
	{
		label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont boldSystemFontOfSize:20.0];
		label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
		label.textAlignment = UITextAlignmentCenter;
		label.textColor = [UIColor whiteColor];
		label.text = [NSString stringWithString:sessionData.currentProvider.friendly_name];
					//  [[sessionData.allProviders objectForKey:sessionData.provider] objectForKey:@"friendly_name"]];
		
		self.navigationItem.titleView = label;
	}
	
	if (!bar)
	{
		bar = [[UIImageView alloc] initWithFrame:CGRectMake(0, yPos, 320, 20)];
		bar.image = [UIImage imageNamed:@"info_bar.png"];
		[self.view addSubview:bar];
	}
	
	if (!powered_by)
	{
		powered_by = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, 320, 20)];
		powered_by.backgroundColor = [UIColor clearColor];
		powered_by.font = [UIFont italicSystemFontOfSize:14.0];
		powered_by.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
		powered_by.shadowColor = [UIColor colorWithWhite:0.8 alpha:0.8];
		powered_by.shadowOffset = CGSizeMake(1.0, 1.0);
		powered_by.textAlignment = UITextAlignmentCenter;
		powered_by.text = @"Powered by RPX";
		[self.view addSubview:powered_by];
	}
	
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] 
									  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
									  target:[self navigationController].parentViewController
									  action:@selector(cancelButtonPressed:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = cancelButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;
	
	[myTableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//	[[self navigationController].parentViewController dismissModalNavigationController:NO];	
}



- (NSString*)getWelcomeMessageFromCookieString:(NSString*)cookieString
{
	NSArray *strArr = [cookieString componentsSeparatedByString:@"%22"];
	
	if ([strArr count] <= 1)
		return @"Welcome, user!";
	
	
	return [[NSString stringWithFormat:@"Sign in as %@?", (NSString*)[strArr objectAtIndex:5]] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

#pragma mark Table view methods

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 176;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewUserLandingCell *cell = 
	(UITableViewUserLandingCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
        cell = [[[UITableViewUserLandingCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault 
				 reuseIdentifier:CellIdentifier
				 targetForSelector:self] autorelease];
    }
    
	NSString *welcomeMsg = nil;

	NSString *imagePath = [NSString stringWithFormat:@"jrauth_%@_logo.png", sessionData.currentProvider.name];
	cell.logo.image = [UIImage imageNamed:imagePath];
	

	if (sessionData.currentProvider.provider_requires_input/* || sessionData.returning_user_input*/)
	{
//		requiresInput = TRUE;
		if ([sessionData.currentProvider.name isEqualToString:sessionData.returningProvider.name])
			[sessionData.currentProvider setUser_input:[NSString stringWithString:sessionData.returningProvider.user_input]];
		else
			[cell.bigSignInButton setHidden:NO];
		
		if (sessionData.currentProvider.user_input)
			cell.textField.text = [NSString stringWithString:sessionData.currentProvider.user_input];
		else
			cell.textField.text = nil;
		
		cell.textField.placeholder = [NSString stringWithString:sessionData.currentProvider.placeholder_text];
		
		[cell.textField setHidden:NO];
		[cell.welcomeLabel setHidden:YES];
		[cell.forgetUserButton setHidden:YES];
		[cell.textField isFirstResponder];
	}
	else 
	{
		welcomeMsg = [self getWelcomeMessageFromCookieString:sessionData.returningProvider.welcome_string];
		cell.welcomeLabel.text = welcomeMsg;
	}

    // Set up the cell...
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (NSString*)validateText:(NSString*)textFieldText
{
	return textFieldText;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	UITableViewUserLandingCell* cell = (UITableViewUserLandingCell*)[myTableView cellForRowAtIndexPath:0];
	
	if (range.location == 0 && string.length == 0)
	{
		[cell.signInButton setEnabled:NO];
	}
	if (range.location == 0 && string.length != 0)
	{
		[cell.signInButton setEnabled:YES];
	}
	
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
	UITableViewUserLandingCell* cell = (UITableViewUserLandingCell*)[myTableView cellForRowAtIndexPath:0];
	[cell.signInButton setEnabled:NO];
	
	return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[textField becomeFirstResponder];
}

- (void)callWebView:(UITextField *)textField
{
	if (sessionData.currentProvider.provider_requires_input)
	{
		if (textField.text.length > 0)
		{
			[textField resignFirstResponder];
			
			sessionData.currentProvider.user_input = [NSString stringWithString:textField.text];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input"
															message:@"The input you have entered is not valid. Please try again."
														   delegate:self
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			[alert show];
			return;
		}
	}
	
	myWebViewController = [JRWebViewController alloc];
	
	[[self navigationController] pushViewController:myWebViewController animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	[self callWebView:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//	sessionData.user_input = [NSString stringWithString:textField.text];
//	[sessionData.user_input retain];
	[textField resignFirstResponder];
	return YES;
}

- (void)forgetUserTouchUpInside
{
	NSString *urlStr = [NSString stringWithFormat:@".%@.com", sessionData.returningProvider.name];
	NSHTTPCookieStorage* cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray *cookies = [cookieStore cookies];
	
	for (NSHTTPCookie *cookie in cookies) 
	{
		if ([cookie.domain hasSuffix:urlStr])
			[cookieStore deleteCookie:cookie];
		
		if ([jrAuth.theAppName hasSuffix:cookie.domain] &&
			([cookie.name isEqualToString:@"login_tab"] || 
			 [cookie.name isEqualToString:@"user_input"]))
			[cookieStore deleteCookie:cookie];
	}	

	[sessionData setProvider:nil];
//	sessionData.user_input = nil;
	
	[[self navigationController] popViewControllerAnimated:YES];
}



- (void)backToProvidersTouchUpInside
{
	[sessionData setProvider:nil];
//	sessionData.user_input = nil;
		
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)signInButtonTouchUpInside:(UIButton*)button
{
	UITableViewUserLandingCell* cell = (UITableViewUserLandingCell*)[button superview];// (UITableViewUserLandingCell*)[myTableView cellForRowAtIndexPath:0];
	UITextField *textField = cell.textField;

	if ([textField isFirstResponder])
		[self.view endEditing:YES];
	else
		[self callWebView:textField];
}



- (void)dealloc 
{
	[jrAuth	release];
	[myTableView release];
	[myWebViewController release];
	[provider release];
	
    [super dealloc];
}


@end

