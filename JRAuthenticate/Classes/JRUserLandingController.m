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
 
 File:	 JRUserLandingController.m 
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "JRUserLandingController.h"

// TODO: Figure out why the -DDEBUG cflag isn't being set when Active Conf is set to debug
#define DEBUG
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


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
		textField.keyboardType = UIKeyboardTypeURL;
		textField.returnKeyType = UIReturnKeyDone;
		textField.enablesReturnKeyAutomatically = YES;
		
		textField.delegate = targetForSelector;
		
		[textField setHidden:YES];
		[self addSubview:textField];
				
		
		signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[signInButton setFrame:CGRectMake(165, 128, 135, 38)];
		
		[signInButton setBackgroundImage:[UIImage imageNamed:@"blue_button_135x38.png"] forState:UIControlStateNormal];
		signInButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
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
		backToProvidersButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
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
		
		[bigSignInButton setBackgroundImage:[UIImage imageNamed:@"blue_button_280x38.png"] forState:UIControlStateNormal];
		bigSignInButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
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
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return self;
}	

- (void)dealloc
{
	DLog(@"");

	[logo release];
	[welcomeLabel release];
	[textField release];
	[signInButton release];
	[backToProvidersButton release];
	[bigSignInButton release];

	[super dealloc];
}
@end

@interface JRUserLandingController ()
- (NSString*)customTitle;
- (void)callWebView:(UITextField *)textField;
@end

@implementation JRUserLandingController
@synthesize myTableView;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad 
{
	DLog(@"");
    [super viewDidLoad];
	
	sessionData = [JRSessionData jrSessionData];
	
	label = nil;
}

- (NSString*)customTitle
{
	DLog(@"");
	if (!sessionData.currentProvider.requiresInput)
		return [NSString stringWithString:@"Welcome Back!"];

	return sessionData.currentProvider.shortText;
}

- (void)viewWillAppear:(BOOL)animated 
{
	DLog(@"");
    [super viewWillAppear:animated];

    if (!sessionData.currentProvider)
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"TODO REWRITE ERROR!! Authentication failed."
                                                             forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"JRAuthenticate"
                                             code:100
                                         userInfo:userInfo];
        
        [sessionData authenticationDidFailWithError:error];        

        return;
    }
    
	self.title = [self customTitle];
	
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
	label.text = [NSString stringWithString:sessionData.currentProvider.friendlyName];
	
	if (!infoBar)
	{
		infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, 388, 320, 30) andStyle:[sessionData hidePoweredBy]];
		[self.view addSubview:infoBar];
	}
	[infoBar fadeIn];	
	
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] 
									  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
									  target:sessionData//[self navigationController].parentViewController
                                      action:@selector(authenticationDidRestart:)] autorelease];// @selector(cancelButtonPressed:)] autorelease];

	self.navigationItem.rightBarButtonItem = cancelButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;

	[myTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated 
{
	DLog(@"");
	[super viewDidAppear:animated];

	NSArray *vcs = [self navigationController].viewControllers;
	for (NSObject *vc in vcs)
	{
		DLog(@"view controller: %@", [vc description]);
	}
	
	NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:0 inSection:0];
	UITableViewUserLandingCell* cell = (UITableViewUserLandingCell*)[myTableView cellForRowAtIndexPath:indexPath];
	
	if ([sessionData gatheringInfo])
		[cell.textField becomeFirstResponder];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 // return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}
 

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewWillDisappear:(BOOL)animated 
{
	DLog(@"");
	[infoBar fadeOut];
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated 
{
	DLog(@"");
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload 
{
	DLog(@"");
    [super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { }


//- (NSString*)getWelcomeMessageFromCookieString:(NSString*)cookieString
//{
//	NSArray *strArr = [cookieString componentsSeparatedByString:@"%22"];
//	
//	if ([strArr count] <= 1)
//		return @"Welcome, user!";
//	
//	return [[NSString stringWithFormat:@"Sign in as %@?", (NSString*)[strArr objectAtIndex:5]] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
//}

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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    DLog(@"");
    DLog(@"cell for %@", sessionData.currentProvider.name);   
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewUserLandingCell *cell = 
	(UITableViewUserLandingCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
        cell = [[[UITableViewUserLandingCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault 
				 reuseIdentifier:CellIdentifier
				 targetForSelector:self] autorelease];
    }
    
	NSString *imagePath = [NSString stringWithFormat:@"jrauth_%@_logo.png", sessionData.currentProvider.name];
	cell.logo.image = [UIImage imageNamed:imagePath];
	
    /* If the provider requires input, we need to enable the textField, and set the text/placeholder text to the apropriate string */
	if (sessionData.currentProvider.requiresInput)
	{
		DLog(@"current provider requires input");
		
        // TODO: Now that I'm using JRProvider *s, do I need to do this step, or will these just be the same object?
		if ([sessionData.currentProvider isEqualToProvider:sessionData.returningBasicProvider])
			[sessionData.currentProvider setUserInput:[NSString stringWithString:sessionData.returningBasicProvider.userInput]];
		else
			[cell.bigSignInButton setHidden:NO];
				
		if (sessionData.currentProvider.userInput)
			cell.textField.text = [NSString stringWithString:sessionData.currentProvider.userInput];
		else
			cell.textField.text = nil;
		
		cell.textField.placeholder = [NSString stringWithString:sessionData.currentProvider.placeholderText];
		
		[cell.textField setHidden:NO];
		[cell.textField setEnabled:YES];
		[cell.welcomeLabel setHidden:YES];
		[cell.forgetUserButton setHidden:YES];
	}
	else /* If the provider doesn't require input, then we are here because this is the return experience screen and only for basic providers */
	{
		DLog(@"current provider does not require input");
		
		[cell.textField setHidden:YES];
		[cell.textField setEnabled:NO];
		[cell.welcomeLabel setHidden:NO];
		[cell.bigSignInButton setHidden:YES];

//		welcomeMsg = [self getWelcomeMessageFromCookieString:sessionData.returningBasicProvider.welcomeString];
		cell.welcomeLabel.text = sessionData.currentProvider.welcomeString;//welcomeMsg;
		
		DLog(@"welcomeMsg: %@", sessionData.currentProvider.welcomeString);//welcomeMsg);
	}

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
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
	DLog(@"");
	[self callWebView:textField];
	
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	DLog(@"");
    [textField becomeFirstResponder];
}

- (void)callWebView:(UITextField *)textField
{
    DLog(@"");
    DLog(@"user input: %@", textField.text);
	if (sessionData.currentProvider.requiresInput)
	{
		if (textField.text.length > 0)
		{
			[textField resignFirstResponder];
			
			sessionData.currentProvider.userInput = [NSString stringWithString:textField.text];
		}
		else
		{
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Invalid Input"
															 message:@"The input you have entered is not valid. Please try again."
															delegate:self
												   cancelButtonTitle:@"OK" 
												   otherButtonTitles:nil] autorelease];
			[alert show];
			return;
		}
	}

	[[self navigationController] pushViewController:[JRUserInterfaceMaestro jrUserInterfaceMaestro].myWebViewController
										   animated:YES]; 
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	DLog(@"");
    [textField resignFirstResponder];
}

- (void)backToProvidersTouchUpInside
{
	DLog(@"");
    
    /* This should work, because this button will only be visible during the return experience of a basic provider */
//	[sessionData setBasicProvider:nil];
//	[sessionData setReturningBasicProviderToNewBasicProvider:nil];
    [sessionData setCurrentProvider:nil];
    [sessionData setReturningBasicProviderToNil];
    
    sessionData.forceReauth = YES;
		
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)signInButtonTouchUpInside:(UIButton*)button
{
	DLog(@"");
	UITableViewUserLandingCell* cell = (UITableViewUserLandingCell*)[button superview];
	UITextField *textField = cell.textField;

	[self callWebView:textField];
}

- (void)userInterfaceWillClose { }
- (void)userInterfaceDidClose { }

- (void)dealloc 
{
	DLog(@"");

	[sessionData release];
	[infoBar release];
	
    [super dealloc];
}
@end

