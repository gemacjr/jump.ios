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


//@interface UITableViewUserLandingCell : UITableViewCell 
//{
//	UIImageView	*logo;
//	UILabel		*welcomeLabel;
//	UITextField *textField;
//	UIButton	*signInButton;
//	UIButton	*backToProvidersButton;
//	UIButton	*bigSignInButton;
//	UIButton	*forgetUserButton;
//}
//
//@property (retain) 	UIImageView	*logo;
//@property (retain) 	UILabel		*welcomeLabel;
//@property (retain) 	UITextField *textField;
//@property (retain) 	UIButton	*signInButton;
//@property (retain) 	UIButton	*backToProvidersButton;
//@property (retain) 	UIButton	*bigSignInButton;
//@property (retain) 	UIButton	*forgetUserButton;
//
//@end
//
//@implementation UITableViewUserLandingCell
//
//@synthesize logo;
//@synthesize welcomeLabel;
//@synthesize textField;
//@synthesize signInButton;
//@synthesize backToProvidersButton;
//@synthesize bigSignInButton;
//@synthesize forgetUserButton;
//
//// TODO: Move all this crap into the tableView: cellForRow... function and don't subclass 
//// UITableViewCell now that you figured out how to do this forever ago
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//											  targetForSelector:(id)targetForSelector
//{
//	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
//	{
//		logo = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 280, 63)];
//		[self addSubview:logo];
//				
//		welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 280, 25)];
//		welcomeLabel.adjustsFontSizeToFitWidth = YES;
//		welcomeLabel.font = [UIFont boldSystemFontOfSize:20];
//		welcomeLabel.textColor = [UIColor blackColor];
//		welcomeLabel.backgroundColor = [UIColor clearColor];
//		welcomeLabel.textAlignment = UITextAlignmentLeft;
//		[self addSubview:welcomeLabel];	
//						
//		textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 83, 280, 35)];
//		textField.adjustsFontSizeToFitWidth = YES;
//		textField.textColor = [UIColor blackColor];
//		textField.font = [UIFont systemFontOfSize:15.0];
//		textField.backgroundColor = [UIColor clearColor];
//		textField.borderStyle = UITextBorderStyleRoundedRect;
//		textField.textAlignment = UITextAlignmentLeft;
//		textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//		textField.clearsOnBeginEditing = YES;
//		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//		textField.autocorrectionType = UITextAutocorrectionTypeNo;
//		textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//		textField.keyboardType = UIKeyboardTypeURL;
//		textField.returnKeyType = UIReturnKeyDone;
//		textField.enablesReturnKeyAutomatically = YES;
//		
//		textField.delegate = targetForSelector;
//		
//		[textField setHidden:YES];
//		[self addSubview:textField];
//				
//		
//		signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
//		[signInButton setFrame:CGRectMake(165, 128, 135, 38)];
//		
//		[signInButton setBackgroundImage:[UIImage imageNamed:@"blue_button_135x38.png"] forState:UIControlStateNormal];
////		[signInButton setBackgroundImage:[UIImage imageNamed:@"blue_button.png"] forState:UIControlStateNormal];
//		signInButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
//		[signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
//		[signInButton setTitleColor:[UIColor whiteColor] 
//						   forState:UIControlStateNormal];
//		[signInButton setTitleShadowColor:[UIColor grayColor]
//								 forState:UIControlStateNormal];
//
//		[signInButton setTitle:@"Sign In" forState:UIControlStateSelected];
//		[signInButton setTitleColor:[UIColor whiteColor] 
//						   forState:UIControlStateSelected];	
//		[signInButton setTitleShadowColor:[UIColor grayColor]
//								 forState:UIControlStateSelected];	
//		[signInButton setReversesTitleShadowWhenHighlighted:YES];
//		
//		[signInButton addTarget:targetForSelector
//						 action:@selector(signInButtonTouchUpInside:) 
//			   forControlEvents:UIControlEventTouchUpInside];
//
//		[self addSubview:signInButton];
//				
//		
//		backToProvidersButton = [UIButton buttonWithType:UIButtonTypeCustom];
//		[backToProvidersButton setFrame:CGRectMake(20, 128, 135, 38)];
//		
//		[backToProvidersButton setBackgroundImage:[UIImage imageNamed:@"black_button.png"] forState:UIControlStateNormal];
//		backToProvidersButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
//		[backToProvidersButton setTitle:@"Switch Accounts" forState:UIControlStateNormal];
//		[backToProvidersButton setTitleColor:[UIColor whiteColor] 
//									forState:UIControlStateNormal];
//		[backToProvidersButton setTitleShadowColor:[UIColor grayColor]
//										  forState:UIControlStateNormal];
//		
//		[backToProvidersButton setTitle:@"Switch Accounts" forState:UIControlStateSelected];
//		[backToProvidersButton setTitleColor:[UIColor whiteColor] 
//									forState:UIControlStateSelected];
//		[backToProvidersButton setTitleShadowColor:[UIColor grayColor]
//										  forState:UIControlStateSelected];
//		[backToProvidersButton setReversesTitleShadowWhenHighlighted:YES];
//		
//
//		[backToProvidersButton addTarget:targetForSelector
//								  action:@selector(backToProvidersTouchUpInside) 
//						forControlEvents:UIControlEventTouchUpInside];	
//		[self addSubview:backToProvidersButton];
//		
//		bigSignInButton = [UIButton buttonWithType:UIButtonTypeCustom];
//		[bigSignInButton setFrame:CGRectMake(20, 128, 280, 38)];
//		
//		[bigSignInButton setBackgroundImage:[UIImage imageNamed:@"blue_button_280x38.png"] forState:UIControlStateNormal];
//		bigSignInButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
//		[bigSignInButton setTitle:@"Sign In" forState:UIControlStateNormal];
//		[bigSignInButton setTitleColor:[UIColor whiteColor] 
//						   forState:UIControlStateNormal];
//		[bigSignInButton setTitleShadowColor:[UIColor grayColor]
//								 forState:UIControlStateNormal];
//		
//		[bigSignInButton setTitle:@"Sign In" forState:UIControlStateSelected];
//		[bigSignInButton setTitleColor:[UIColor whiteColor] 
//						   forState:UIControlStateSelected];	
//		[bigSignInButton setTitleShadowColor:[UIColor grayColor]
//								 forState:UIControlStateSelected];	
//		[bigSignInButton setReversesTitleShadowWhenHighlighted:YES];
//		
//        [bigSignInButton addTarget:targetForSelector
//						 action:@selector(signInButtonTouchUpInside:) 
//			   forControlEvents:UIControlEventTouchUpInside];
//		
//		[bigSignInButton setHidden:YES];
//		[self addSubview:bigSignInButton];
//		
//		self.selectionStyle = UITableViewCellSelectionStyleNone;
//	}
//	
//	return self;
//}	
//
//- (void)dealloc
//{
//	DLog(@"");
//
//	[logo release];
//	[welcomeLabel release];
//	[textField release];
//	[signInButton release];
//	[backToProvidersButton release];
//	[bigSignInButton release];
//
//	[super dealloc];
//}
//@end

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

- (NSError*)setError:(NSString*)message withCode:(NSInteger)code andType:(NSString*)type
{
    DLog(@"");
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              message, NSLocalizedDescriptionKey,
                              type, @"type", nil];
    
    return [[NSError alloc] initWithDomain:@"JREngage"
                                      code:code
                                  userInfo:userInfo];
}

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
        NSError *error = [[self setError:@"There was an error authenticating with the selected provider."
                                withCode:JRAuthenticationFailedError
                                 andType:JRErrorTypeAuthenticationFailed] autorelease];
        
        [sessionData triggerAuthenticationDidFailWithError:error];        

        return;
    }
    
	self.title = [self customTitle];

	if (!label)
	{
		label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 156, 44)] autorelease];
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
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, 890, 768, 72) andStyle:[sessionData hidePoweredBy] | JRInfoBarStyleiPad];
        else
            infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, 388, 320, 30) andStyle:[sessionData hidePoweredBy]];

        [self.view addSubview:infoBar];
	}
	[infoBar fadeIn];	
	
//	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] 
//									  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//									  target:sessionData
//                                      action:@selector(triggerAuthenticationDidStartOver:)] autorelease];

//	self.navigationItem.rightBarButtonItem = cancelButton;
//	self.navigationItem.rightBarButtonItem.enabled = YES;
//	
//	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;

    self.navigationItem.backBarButtonItem.target = sessionData;
    self.navigationItem.backBarButtonItem.action = @selector(triggerAuthenticationDidStartOver:);
    
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
	
//	NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:0 inSection:0];
//	UITableViewUserLandingCell* cell = (UITableViewUserLandingCell*)[myTableView cellForRowAtIndexPath:indexPath];
//	
//    /* Only make the cell's text field the first responder (and show the keyboard) in certain situations */
//	if ([sessionData weShouldBeFirstResponder] && !cell.textField.text)
//		[cell.textField becomeFirstResponder];

	NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:0 inSection:0];
	UITableViewCell *cell = (UITableViewCell*)[myTableView cellForRowAtIndexPath:indexPath];
	UITextField *textField = [self getTextField:cell];
    
    /* Only make the cell's text field the first responder (and show the keyboard) in certain situations */
	if ([sessionData weShouldBeFirstResponder] && !textField.text)
		[textField becomeFirstResponder];
    
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

#pragma mark Table view methods

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 386;
    else
        return 176;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

enum
{
    LOGO_TAG = 1,
    WELCOME_LABEL_TAG,
    TEXT_FIELD_TAG,
    SIGN_IN_BUTTON_TAG,
    BACK_TO_PROVIDERS_BUTTON_TAG,
    BIG_SIGN_IN_BUTTON_TAG
};

- (UIImageView*)getLogo:(UITableViewCell*)cell
{
    if (cell)
        return (UIImageView*)[cell.contentView viewWithTag:LOGO_TAG];
    
    UIImageView *logo;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        logo = [[UIImageView alloc] initWithFrame:CGRectMake(60, 40, 558, 125)];// autorelease];
    else
        logo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 280, 63)];// autorelease];

    logo.tag = LOGO_TAG;

    return logo;
}

- (UILabel*)getWelcomeLabel:(UITableViewCell*)cell 
{     
    if (cell)
        return (UILabel*)[cell.contentView viewWithTag:WELCOME_LABEL_TAG];

    UILabel *welcomeLabel;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 195, 558, 50)];// autorelease];
    else
        welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 280, 25)];// autorelease];

    welcomeLabel.font = [UIFont boldSystemFontOfSize:
                         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                         ? 36.0 : 20.0];
    
    welcomeLabel.adjustsFontSizeToFitWidth = YES;
    welcomeLabel.textColor = [UIColor blackColor];
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.textAlignment = UITextAlignmentLeft;
    
    welcomeLabel.tag = WELCOME_LABEL_TAG;

    return welcomeLabel;
}

- (UITextField*)getTextField:(UITableViewCell*)cell 
{
    if (cell)
        return (UITextField*)[cell.contentView viewWithTag:TEXT_FIELD_TAG];
    
    UITextField *textField;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        textField = [[UITextField alloc] initWithFrame:CGRectMake(60, 185, 558, 70)]; //autorelease];
    else
        textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 83, 280, 35)]; //autorelease];

    textField.font = [UIFont systemFontOfSize:
                      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                      ? 30.0 : 15.0];
    
    
    textField.adjustsFontSizeToFitWidth = YES;
    textField.textColor = [UIColor blackColor];
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

    textField.delegate = self;

    [textField setHidden:YES];  
        
    textField.tag = TEXT_FIELD_TAG;
    return textField;
}

- (UIButton*)getSignInButton:(UITableViewCell*)cell 
{     
    if (cell)         
        return (UIButton*)[cell.contentView viewWithTag:SIGN_IN_BUTTON_TAG];
    
    UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeCustom];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [signInButton setFrame:CGRectMake(367, 275, 251, 71)];
    else
        [signInButton setFrame:CGRectMake(155, 128, 135, 38)];

    [signInButton setBackgroundImage:[UIImage imageNamed:@"blue_button_135x38.png"] forState:UIControlStateNormal];
    
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

    signInButton.titleLabel.font = [UIFont boldSystemFontOfSize:
                                    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                                                                ? 36.0 : 20.0];
    

    [signInButton addTarget:self
                     action:@selector(signInButtonTouchUpInside:) 
           forControlEvents:UIControlEventTouchUpInside];

    signInButton.tag = SIGN_IN_BUTTON_TAG;
    
    return signInButton;
}

- (UIButton*)getBackToProvidersButton:(UITableViewCell*)cell 
{
    if (cell)
        return (UIButton*)[cell.contentView viewWithTag:BACK_TO_PROVIDERS_BUTTON_TAG];
    
    UIButton *backToProvidersButton = [UIButton buttonWithType:UIButtonTypeCustom];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [backToProvidersButton setFrame:CGRectMake(60, 275, 251, 71)];
    else
        [backToProvidersButton setFrame:CGRectMake(10, 128, 135, 38)];

    [backToProvidersButton setBackgroundImage:[UIImage imageNamed:@"black_button.png"] forState:UIControlStateNormal];

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

    backToProvidersButton.titleLabel.font = [UIFont boldSystemFontOfSize:
                                             (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                                             ? 28.0 : 14.0];

    [backToProvidersButton addTarget:self
                              action:@selector(backToProvidersTouchUpInside) 
                    forControlEvents:UIControlEventTouchUpInside];	

    backToProvidersButton.tag = BACK_TO_PROVIDERS_BUTTON_TAG;
    return backToProvidersButton;
}

- (UIButton*)getBigSignInButton:(UITableViewCell*)cell 
{
    if (cell)         
        return (UIButton*)[cell.contentView viewWithTag:BIG_SIGN_IN_BUTTON_TAG];
    
    UIButton *bigSignInButton = [UIButton buttonWithType:UIButtonTypeCustom];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [bigSignInButton setFrame:CGRectMake(60, 275, 558, 71)];
    else
        [bigSignInButton setFrame:CGRectMake(10, 128, 280, 38)];

    [bigSignInButton setBackgroundImage:[UIImage imageNamed:@"blue_button_280x38.png"] forState:UIControlStateNormal];
    
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

    bigSignInButton.titleLabel.font = [UIFont boldSystemFontOfSize:
                                       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                                       ? 36.0 : 20.0];
    
    [bigSignInButton addTarget:self
                        action:@selector(signInButtonTouchUpInside:) 
              forControlEvents:UIControlEventTouchUpInside];

    [bigSignInButton setHidden:YES];

    bigSignInButton.tag = BIG_SIGN_IN_BUTTON_TAG;
    return bigSignInButton;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    DLog(@"");
    DLog(@"cell for %@", sessionData.currentProvider.name);   

	UITableViewCell *cell = 
        [tableView dequeueReusableCellWithIdentifier:@"cachedCell"];
	
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cachedCell"];// autorelease];
        
		[cell.contentView addSubview:[self getLogo:nil]];
        [cell.contentView addSubview:[self getWelcomeLabel:nil]];	
        [cell.contentView addSubview:[self getTextField:nil]];
        [cell.contentView addSubview:[self getSignInButton:nil]];
        [cell.contentView addSubview:[self getBackToProvidersButton:nil]];
		[cell.contentView addSubview:[self getBigSignInButton:nil]];
		
        cell.backgroundColor = [UIColor whiteColor];
      
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *imagePath = [NSString stringWithFormat:@"jrauth_%@_logo.png", sessionData.currentProvider.name];
	[self getLogo:cell].image = [UIImage imageNamed:imagePath];

    UITextField *textField = [self getTextField:cell];
    UIButton    *bigSignInButton = [self getBigSignInButton:cell];
    UILabel     *welcomeLabel = [self getWelcomeLabel:cell];
    
 /* If the provider requires input, we need to enable the textField, and set the text/placeholder text to the apropriate string */
	if (sessionData.currentProvider.requiresInput)
	{
		DLog(@"current provider requires input");
		
//      if ([sessionData.currentProvider isEqualToReturningProvider:sessionData.returningBasicProvider])
//			[sessionData.currentProvider setUserInput:sessionData.currentProvider.userInput];//[NSString stringWithString:sessionData.returningBasicProvider.userInput]];
//		else
//			[cell.bigSignInButton setHidden:NO];
				
		if (sessionData.currentProvider.userInput)
        {
            [textField resignFirstResponder];
			textField.text = [NSString stringWithString:sessionData.currentProvider.userInput];
			[bigSignInButton setHidden:YES];
		}
        else
		{	
            textField.text = nil;
			[bigSignInButton setHidden:NO];
        }
		
		textField.placeholder = [NSString stringWithString:sessionData.currentProvider.placeholderText];
		
		[textField setHidden:NO];
		[textField setEnabled:YES];
		[welcomeLabel setHidden:YES];
	}
	else /* If the provider doesn't require input, then we are here because this is the return experience screen and only for basic providers */
	{
		DLog(@"current provider does not require input");
		
		[textField setHidden:YES];
		[textField setEnabled:NO];
		[welcomeLabel setHidden:NO];
		[bigSignInButton setHidden:YES];

		welcomeLabel.text = sessionData.currentProvider.welcomeString;
		
		DLog(@"welcomeMsg: %@", sessionData.currentProvider.welcomeString);
	}
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range 
replacementString:(NSString *)string { return YES; }

- (BOOL)textFieldShouldClear:(UITextField *)textField { return YES; }

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
    sessionData.currentProvider.forceReauth = YES;
    
    [sessionData setCurrentProvider:nil];
    [sessionData setReturningBasicProviderToNil];
    
    //sessionData.forceReauth = YES;
		
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)signInButtonTouchUpInside:(UIButton*)button
{
	DLog(@"");
//	UITableViewUserLandingCell* cell = (UITableViewUserLandingCell*)[button superview];
	UITableViewCell* cell = (UITableViewCell*)[[button superview] superview];
	UITextField *textField = [self getTextField:cell];//cell.textField;

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

