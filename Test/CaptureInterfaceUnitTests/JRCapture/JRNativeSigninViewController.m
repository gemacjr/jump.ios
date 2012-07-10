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

 File:   EmbeddedNativeSignInViewController.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "JRNativeSigninViewController.h"

#define LOADING_VIEW_TAG         555
#define LOADING_VIEW_LABEL_TAG   666
#define LOADING_VIEW_SPINNER_TAG 777

@interface UIViewController (LoadingViewAnimation)
//- (void)startLoadingViewWithTag:(NSUInteger)tag;
//- (void)stopLoadingViewWithTag:(NSUInteger)tag;
@end

@implementation UIViewController (LoadingViewAnimation)
//- (void)startLoadingViewWithTag:(NSUInteger)tag
//{
//    UIView *loadingView =
//                   [self.view viewWithTag:LOADING_VIEW_TAG];
//    UIActivityIndicatorView *loadingSpinner =
//                  (UIActivityIndicatorView *)[loadingView viewWithTag:LOADING_VIEW_SPINNER_TAG];
//
//    [loadingView setHidden:NO];
//    [loadingSpinner startAnimating];
//
//    [UIView beginAnimations:@"fade" context:nil];
//    [UIView setAnimationDuration:0.2];
//    [UIView setAnimationDelay:0.0];
//    loadingView.alpha = 0.8;
//    [UIView commitAnimations];
//}
//
//- (void)stopLoadingViewWithTag:(NSUInteger)tag
//{
//    UIView *loadingView =
//                   [self.view viewWithTag:LOADING_VIEW_TAG];
//    UIActivityIndicatorView *loadingSpinner =
//                  (UIActivityIndicatorView *)[loadingView viewWithTag:LOADING_VIEW_SPINNER_TAG];
//
//    [UIView beginAnimations:@"fade" context:nil];
//    [UIView setAnimationDuration:0.2];
//    [UIView setAnimationDelay:0.0];
//    loadingView.alpha = 0.0;
//    [UIView commitAnimations];
//
//    [loadingView setHidden:YES];
//    [loadingSpinner stopAnimating];
//}
@end


@interface JRNativeSigninViewController ()
@property (retain) id<JRNativeSigninViewControllerDelegate> delegate;
@property (retain) NSString *titleString;
@property (retain) UIView   *titleView;
@property JRConventionalSigninType signinType;
@property (retain) UIView   *loadingView;
@end

@implementation JRNativeSigninViewController
@synthesize signinType;
@synthesize titleString;
@synthesize titleView;
@synthesize loadingView;
@synthesize delegate;

- (id)initWithNativeSigninType:(JRConventionalSigninType)theSigninType titleString:(NSString *)theTitleString
                     titleView:(UIView *)theTitleView delegate:(id<JRNativeSigninViewControllerDelegate>)theDelegate
{
    if ((self = [super init]))
    {
        signinType  = theSigninType;
        titleString = [theTitleString retain];
        titleView   = [theTitleView retain];
        delegate    = [theDelegate retain];
    }

    return self;
}

+ (id)nativeSigninViewControllerWithNativeSigninType:(JRConventionalSigninType)theSigninType titleString:(NSString *)theTitleString
                                           titleView:(UIView *)theTitleView delegate:(id<JRNativeSigninViewControllerDelegate>)theDelegate
{
    return [[[JRNativeSigninViewController alloc]
                    initWithNativeSigninType:theSigninType titleString:theTitleString
                                   titleView:theTitleView delegate:theDelegate] autorelease];
}

- (void)createLoadingView
{
    self.loadingView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];

    [self.loadingView setBackgroundColor:[UIColor grayColor]];

    UILabel *loadingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 180, 320, 30)] autorelease];

    [loadingLabel setText:@"Completing Sign-In..."];
    [loadingLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [loadingLabel setTextColor:[UIColor whiteColor]];
    [loadingLabel setAutoresizingMask:UIViewAutoresizingNone |
                                      UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleBottomMargin |
                                      UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleLeftMargin];

    UIActivityIndicatorView *loadingSpinner =
            [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];

    [loadingSpinner setFrame:CGRectMake(142, 220, 37, 37)];
    [loadingLabel setAutoresizingMask:UIViewAutoresizingNone |
                                          UIViewAutoresizingFlexibleTopMargin |
                                          UIViewAutoresizingFlexibleBottomMargin |
                                          UIViewAutoresizingFlexibleRightMargin |
                                          UIViewAutoresizingFlexibleLeftMargin];

    [loadingLabel setTag:LOADING_VIEW_LABEL_TAG];
    [loadingSpinner setTag:LOADING_VIEW_SPINNER_TAG];

    [loadingView addSubview:loadingLabel];
    [loadingView addSubview:loadingSpinner];

    [loadingView setTag:LOADING_VIEW_TAG];
    //[loadingView setHidden:YES];
    [loadingView setAlpha:0.8];

    [self.view addSubview:loadingView];
}

- (void)loadView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 170)
                                               style:UITableViewStyleGrouped];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.scrollEnabled   = NO;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    [button setFrame:CGRectMake(10, 2, 300, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"button_janrain_280x40.png"]
                      forState:UIControlStateNormal];

    [button setTitle:@"Sign In" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];

    button.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];

    [button addTarget:self
               action:@selector(signInButtonTouchUpInside:)
     forControlEvents:UIControlEventTouchUpInside];

    UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] autorelease];
    [footerView addSubview:button];

    myTableView.tableFooterView = footerView;
    myTableView.dataSource = self;
    myTableView.delegate = self;

    self.view = myTableView;

    [self.view setClipsToBounds:NO];

//    [self createLoadingView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [myTableView reloadData];
}

#pragma mark -
#pragma mark Table view data source


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.titleView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.titleString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (titleView)
        return titleView.frame.size.height;

    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITextField *textField;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

        textField = [[[UITextField alloc] initWithFrame:CGRectMake(10, 7, 280, 26)] autorelease];

        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;

        [cell.contentView addSubview:textField];

        if (indexPath.row == 0)
        {
            textField.placeholder =
                    (self.signinType == JRConventionalSigninEmailPassword ?
                            @"enter your email":
                            @"enter your username");
        }
        else
        {
            textField.placeholder = @"enter your password";
            textField.secureTextEntry = YES;
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)startLoadingView//WithTag:(NSUInteger)tag
{
//    UIView *loadingView =
//                   [self.view viewWithTag:LOADING_VIEW_TAG];
    UIActivityIndicatorView *loadingSpinner =
                  (UIActivityIndicatorView *)[loadingView viewWithTag:LOADING_VIEW_SPINNER_TAG];

    [loadingView setHidden:NO];
    [loadingSpinner startAnimating];

    [UIView beginAnimations:@"fade" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.0];
    loadingView.alpha = 0.8;
    [UIView commitAnimations];
}

- (void)stopLoadingView//WithTag:(NSUInteger)tag
{
//    UIView *loadingView =
//                   [self.view viewWithTag:LOADING_VIEW_TAG];
    UIActivityIndicatorView *loadingSpinner =
                  (UIActivityIndicatorView *)[loadingView viewWithTag:LOADING_VIEW_SPINNER_TAG];

    [UIView beginAnimations:@"fade" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.0];
    loadingView.alpha = 0.0;
    [UIView commitAnimations];

    [loadingView setHidden:YES];
    [loadingSpinner stopAnimating];
}

- (void)signInButtonTouchUpInside:(UIButton*)button
{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Button pressed"
                                                         message:@"yo"
                                                        delegate:nil
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil] autorelease];
    [alertView show];

    [self startLoadingView];//WithTag:LOADING_VIEW_TAG];
//    [[self.view.superview viewWithTag:LOADING_VIEW_LABEL_TAG] setHidden:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)dealloc
{
    [myTableView release];
    [delegate release];
    [titleView release];
    [titleString release];
    [loadingView release];
    [super dealloc];
}
@end

