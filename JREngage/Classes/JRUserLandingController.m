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

 File:   JRUserLandingController.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "JRUserLandingController.h"
#import "JREngage+CustomInterface.h"

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define frame_x(a) a.frame.origin.x
#define frame_y(a) a.frame.origin.y
#define frame_w(a) a.frame.size.width
#define frame_h(a) a.frame.size.height

#define frame_a(a) frame_x(a), frame_y(a), frame_w(a), frame_h(a)

@interface JRUserLandingController ()
- (NSString*)customTitle;
- (void)callWebView:(UITextField*)textField;
- (UITextField*)getTextField:(UITableViewCell*)cell;
- (UITableViewCell*)getTableCell;
- (void)adjustTableViewFrame;
@end

@implementation JRUserLandingController
@synthesize myBackgroundView;
@synthesize myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andCustomInterface:(NSDictionary*)theCustomInterface
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        customInterface = [theCustomInterface retain];

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            iPad = YES;
        else
            iPad = NO;
    }

    return self;
}

- (void)viewDidLoad
{
    DLog(@"");
    [super viewDidLoad];

    sessionData = [JRSessionData jrSessionData];

///*** * * DEPRECATED * * ***/
///**/NSArray *backgroundColor = [customInterface objectForKey:kJRAuthenticationBackgroundColorRGBa];
///*** * * DEPRECATED * * ***/

 /* If there is a UIColor object set for the background color, use this */
    if ([customInterface objectForKey:kJRAuthenticationBackgroundColor])
        myBackgroundView.backgroundColor = [customInterface objectForKey:kJRAuthenticationBackgroundColor];
//    else
///*** * * * * * * DEPRECATED * * * * * * ***/
///**/    if ([backgroundColor respondsToSelector:@selector(count)])
///**/        if ([backgroundColor count] == 4)
///**/            myBackgroundView.backgroundColor =
///**/                [UIColor colorWithRed:[(NSNumber*)[backgroundColor objectAtIndex:0] doubleValue]
///**/                                green:[(NSNumber*)[backgroundColor objectAtIndex:1] doubleValue]
///**/                                 blue:[(NSNumber*)[backgroundColor objectAtIndex:2] doubleValue]
///**/                                alpha:[(NSNumber*)[backgroundColor objectAtIndex:3] doubleValue]];
///*** * * * * * * DEPRECATED * * * * * * ***/

    myTableView.backgroundColor = [UIColor clearColor];

    if (!infoBar)
    {
        infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, frame_h(self.view) - 30, frame_w(self.view), 30)
                                          andStyle:((JRInfoBarStyle)[sessionData hidePoweredBy])];

        [self.view addSubview:infoBar];
    }

    if (!self.navigationController.navigationBar.backItem)
    {
        UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                 target:sessionData
                                                 action:@selector(triggerAuthenticationDidCancel:)] autorelease];

        self.navigationItem.rightBarButtonItem         = cancelButton;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.style   = UIBarButtonItemStyleBordered;
    }
    else
    {
        self.navigationItem.backBarButtonItem.target = sessionData;
        self.navigationItem.backBarButtonItem.action = @selector(triggerAuthenticationDidStartOver:);
    }
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

///*** * * * * * * DEPRECATED * * * * * * ***/
///**/if ([customInterface objectForKey:kJRUserLandingBackgroundImageName])
///**/    [myBackgroundView addSubview:[[[UIImageView alloc] initWithImage:
///**/                                   [UIImage imageNamed:[customInterface objectForKey:kJRUserLandingBackgroundImageName]]] autorelease]];
///*** * * * * * * DEPRECATED * * * * * * ***/

 /* Load the custom background view, if there is one. */
    if ([customInterface objectForKey:kJRAuthenticationBackgroundImageView])
        [myBackgroundView addSubview:[customInterface objectForKey:kJRAuthenticationBackgroundImageView]];

    if (!sessionData.currentProvider)
    {
        NSError *error = [JRError setError:@"There was an error authenticating with the selected provider."
                                  withCode:JRAuthenticationFailedError];

        [sessionData triggerAuthenticationDidFailWithError:error];

        return;
    }

    self.title = [self customTitle];

    if (!titleView)
    {
        titleView                 = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 156, 44)] autorelease];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font            = [UIFont boldSystemFontOfSize:20.0];
        titleView.shadowColor     = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleView.textAlignment   = UITextAlignmentCenter;
        titleView.textColor       = [UIColor whiteColor];
    }

    titleView.text                = [NSString stringWithString:sessionData.currentProvider.friendlyName];
    self.navigationItem.titleView = titleView;

    [myTableView reloadData];
    [self adjustTableViewFrame];
}

- (void)viewDidAppear:(BOOL)animated
{
    DLog(@"");
    [super viewDidAppear:animated];

    self.contentSizeForViewInPopover = CGSizeMake(320, 416);

    UITableViewCell *cell = [self getTableCell];
    UITextField     *textField = [self getTextField:cell];

 /* Only make the cell's text field the first responder (and show the keyboard) in certain situations */
    if ([sessionData weShouldBeFirstResponder] && !textField.text)
        [textField becomeFirstResponder];

    [infoBar fadeIn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { }

#pragma mark Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

#define LOGO_FRAME                      10,     10,     280,    65
#define WELCOME_LABEL_FRAME             10,     90,     280,    25
#define TEXT_FIELD_FRAME                10,     85,     280,    35
#define BUTTON_SUBVIEW_FRAME            10,     130,    280,    40
#define BIG_SIGN_IN_BUTTON_FRAME        0,      0,      280,    40
#define BACK_TO_PROVIDERS_BUTTON_FRAME  0,      0,      135,    40
#define SMALL_SIGN_IN_BUTTON_FRAME      145,    0,      135,    40

- (UITableViewCell*)getTableCell
{
    return [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (UIImageView*)getLogo:(UITableViewCell*)cell
{
    if (cell)
        return (UIImageView*)[cell.contentView viewWithTag:LOGO_TAG];

    UIImageView *logo = [[[UIImageView alloc] initWithFrame:CGRectMake(LOGO_FRAME)] autorelease];

    logo.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
                            UIViewAutoresizingFlexibleLeftMargin;
//    logo.contentMode      = UIViewContentModeCenter;

    logo.tag = LOGO_TAG;

    return logo;
}

- (UILabel*)getWelcomeLabel:(UITableViewCell*)cell
{
    if (cell)
        return (UILabel*)[cell.contentView viewWithTag:WELCOME_LABEL_TAG];

    UILabel *welcomeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(WELCOME_LABEL_FRAME)] autorelease];

    welcomeLabel.font                      = [UIFont boldSystemFontOfSize:20.0];

    welcomeLabel.adjustsFontSizeToFitWidth = YES;
    welcomeLabel.textColor                 = [UIColor blackColor];
    welcomeLabel.backgroundColor           = [UIColor clearColor];
    welcomeLabel.autoresizingMask          = UIViewAutoresizingFlexibleRightMargin |
                                             UIViewAutoresizingFlexibleLeftMargin;

    welcomeLabel.tag = WELCOME_LABEL_TAG;

    return welcomeLabel;
}

- (UITextField*)getTextField:(UITableViewCell*)cell
{
    if (cell)
        return (UITextField*)[cell.contentView viewWithTag:TEXT_FIELD_TAG];

    UITextField *textField = [[[UITextField alloc] initWithFrame:CGRectMake(TEXT_FIELD_FRAME)] autorelease];

    textField.font = [UIFont systemFontOfSize:15.0];

    textField.adjustsFontSizeToFitWidth     = YES;
    textField.textColor                     = [UIColor blackColor];
    textField.borderStyle                   = UITextBorderStyleRoundedRect;
    textField.contentVerticalAlignment      = UIControlContentVerticalAlignmentCenter;
    textField.clearsOnBeginEditing          = YES;
    textField.clearButtonMode               = UITextFieldViewModeWhileEditing;
    textField.autocorrectionType            = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType        = UITextAutocapitalizationTypeNone;
    textField.keyboardType                  = UIKeyboardTypeURL;
    textField.returnKeyType                 = UIReturnKeyDone;
    textField.enablesReturnKeyAutomatically = YES;
    textField.autoresizingMask              = UIViewAutoresizingFlexibleRightMargin |
                                              UIViewAutoresizingFlexibleLeftMargin;

    textField.delegate = self;
    textField.tag      = TEXT_FIELD_TAG;

    [textField setHidden:YES];

    return textField;
}

- (UIButton*)getSignInButton:(UITableViewCell*)cell
{
    if (cell)
        return (UIButton*)[cell.contentView viewWithTag:SIGN_IN_BUTTON_TAG];

    UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [signInButton setFrame:CGRectMake(SMALL_SIGN_IN_BUTTON_FRAME)];
    [signInButton setBackgroundImage:[UIImage imageNamed:@"button_iosblue_135x40.png"]
                            forState:UIControlStateNormal];

    [signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
    [signInButton setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
    [signInButton setTitleShadowColor:[UIColor grayColor]
                             forState:UIControlStateNormal];

    [signInButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];

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

    [backToProvidersButton setFrame:CGRectMake(BACK_TO_PROVIDERS_BUTTON_FRAME)];
    [backToProvidersButton setBackgroundImage:[UIImage imageNamed:@"button_black_135x40.png"]
                                     forState:UIControlStateNormal];

    [backToProvidersButton setTitle:@"Switch Accounts" forState:UIControlStateNormal];
    [backToProvidersButton setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
    [backToProvidersButton setTitleShadowColor:[UIColor grayColor]
                                      forState:UIControlStateNormal];

    [backToProvidersButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];

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

    [bigSignInButton setFrame:CGRectMake(BIG_SIGN_IN_BUTTON_FRAME)];
    [bigSignInButton setBackgroundImage:[UIImage imageNamed:@"button_iosblue_280x40.png"]
                               forState:UIControlStateNormal];

    [bigSignInButton setTitle:@"Sign In" forState:UIControlStateNormal];
    [bigSignInButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
    [bigSignInButton setTitleShadowColor:[UIColor grayColor]
                                forState:UIControlStateNormal];

    [bigSignInButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];

    [bigSignInButton addTarget:self
                        action:@selector(signInButtonTouchUpInside:)
              forControlEvents:UIControlEventTouchUpInside];

    [bigSignInButton setHidden:YES];

    bigSignInButton.tag = BIG_SIGN_IN_BUTTON_TAG;
    return bigSignInButton;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"");

    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"cachedCell"];

    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cachedCell"] autorelease];

        [cell.contentView setFrame:CGRectMake(10, 0, 300, 180)];

        UIView *buttonSubview = [[[UIView alloc] initWithFrame:CGRectMake(BUTTON_SUBVIEW_FRAME)] autorelease];

        [buttonSubview setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin |
                                           UIViewAutoresizingFlexibleLeftMargin];

        [buttonSubview addSubview:[self getSignInButton:nil]];
        [buttonSubview addSubview:[self getBackToProvidersButton:nil]];
        [buttonSubview addSubview:[self getBigSignInButton:nil]];

        [cell.contentView addSubview:[self getLogo:nil]];
        [cell.contentView addSubview:[self getWelcomeLabel:nil]];
        [cell.contentView addSubview:[self getTextField:nil]];

        [cell.contentView addSubview:buttonSubview];

        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    }

    NSString *imagePath = [NSString stringWithFormat:@"logo_%@_280x65.png", sessionData.currentProvider.name];

    [self getLogo:cell].image = [UIImage imageNamed:imagePath];

    UITextField *textField       = [self getTextField:cell];
    UIButton    *bigSignInButton = [self getBigSignInButton:cell];
    UILabel     *welcomeLabel    = [self getWelcomeLabel:cell];

 /* If the provider requires input, we need to enable the textField, and set the text/placeholder text to the appropriate string */
    if (sessionData.currentProvider.requiresInput)
    {
        DLog(@"current provider requires input");

        if (sessionData.currentProvider.userInput)
        {
            [textField resignFirstResponder];
            [textField setText:[NSString stringWithString:sessionData.currentProvider.userInput]];
        }
        else
        {
            [textField setText:nil];
        }

        textField.placeholder = [NSString stringWithString:sessionData.currentProvider.placeholderText];

        [textField setHidden:NO];
        [textField setEnabled:YES];
        [welcomeLabel setHidden:YES];
        [bigSignInButton setHidden:NO];
    }
    else /* If the provider doesn't require input, then we are here because this is the return experience screen and only for basic providers */
    {
        DLog(@"current provider does not require input");

        [textField setHidden:YES];
        [textField setEnabled:NO];
        [welcomeLabel setHidden:NO];
        [bigSignInButton setHidden:YES];

        welcomeLabel.text = [sessionData authenticatedUserForProvider:sessionData.currentProvider].welcomeString;
    }

    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (sessionData.canRotate)
        return YES;

    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#define TABLE_VIEW_FRAME_LANDSCAPE_SMALL    0,  0,  480,  120
#define TABLE_VIEW_FRAME_LANDSCAPE_BIG      0,  0,  480,  268
#define TABLE_VIEW_FRAME_PORTRAIT           0,  0,  320,  416

- (void)shrinkTableViewLandscape
{
    [myTableView setFrame:CGRectMake(TABLE_VIEW_FRAME_LANDSCAPE_SMALL)];
    [myTableView scrollRectToVisible:CGRectMake(BUTTON_SUBVIEW_FRAME) animated:YES];
}

- (void)growTableViewLandscape
{
    [myTableView setFrame:CGRectMake(TABLE_VIEW_FRAME_LANDSCAPE_BIG)];
}

- (void)growTableViewPortrait
{
    [myTableView setFrame:CGRectMake(TABLE_VIEW_FRAME_PORTRAIT)];
}

- (void)adjustTableViewFrame
{
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        if ([[self getTextField:[self getTableCell]] isFirstResponder])
            [self shrinkTableViewLandscape];
        else
            [self growTableViewLandscape];
    }
    else
    {
        [self growTableViewPortrait];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self adjustTableViewFrame];
}

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
    [self adjustTableViewFrame];
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
            [self adjustTableViewFrame];

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
    [self adjustTableViewFrame];
}

- (void)backToProvidersTouchUpInside
{
    DLog(@"");

 /* This should work, because this button will only be visible during the return experience of a basic provider */
    sessionData.currentProvider.forceReauth = YES;

    [sessionData setCurrentProvider:nil];
    [sessionData setReturningBasicProviderToNil];

    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)signInButtonTouchUpInside:(UIButton*)button
{
    DLog(@"");
    [self callWebView:[self getTextField:[self getTableCell]]];
}

- (void)userInterfaceWillClose { }
- (void)userInterfaceDidClose { }

- (void)dealloc
{
    DLog(@"");

    [customInterface release];
    [myBackgroundView release];
    [myTableView release];
    [sessionData release];
    [infoBar release];

    [super dealloc];
}
@end
