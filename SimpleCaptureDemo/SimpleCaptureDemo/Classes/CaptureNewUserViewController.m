/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

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

 File:   CaptureNewUserViewController.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Thursday, January 26, 2012
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "CaptureNewUserViewController.h"
#import "SharedData.h"

@interface CaptureNewUserViewController ()
@property (nonatomic, retain) id             firstResponder;
@property (nonatomic, retain) NSDate        *myBirthdate;
@property (nonatomic, strong) JRCaptureUser *captureUser;
@end

@implementation CaptureNewUserViewController
@synthesize myEmailTextField;
@synthesize myGenderIdentitySegControl;
@synthesize myBirthdayButton;
@synthesize myBirthdayPicker;
@synthesize myPickerToolbar;
@synthesize myAboutMeTextView;
@synthesize myPickerView;
@synthesize myScrollView;
@synthesize myKeyboardToolbar;
@synthesize firstResponder;
@synthesize myBirthdate;
@synthesize captureUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [myPickerView setFrame:CGRectMake(0, 416, 320, 260)];
    [self.view addSubview:myPickerView];

    [myAboutMeTextView setInputAccessoryView:myKeyboardToolbar];
    [myEmailTextField setInputAccessoryView:myKeyboardToolbar];

    self.captureUser = [SharedData captureUser];

    if (captureUser.email)
        myEmailTextField.text  = captureUser.email;
    if (captureUser.aboutMe)
        myAboutMeTextView.text = captureUser.aboutMe;
    if ([[captureUser.gender lowercaseString] isEqualToString:[@"F" lowercaseString]] ||
        [[captureUser.gender lowercaseString] isEqualToString:[@"female" lowercaseString]] ||
        [[captureUser.gender lowercaseString] isEqualToString:[@"girl" lowercaseString]] ||
        [[captureUser.gender lowercaseString] isEqualToString:[@"woman" lowercaseString]]) /* Blah, blah, loose test... */
        [myGenderIdentitySegControl setSelectedSegmentIndex:0];
    if (captureUser.birthday)
        [myBirthdayPicker setDate:captureUser.birthday];
}

- (void)slidePickerUp
{
    [UIView beginAnimations:@"slidePickerUp" context:nil];
    [myPickerView setFrame:CGRectMake(0, 156, 320, 260)];
    [UIView commitAnimations];
}

- (void)slidePickerDown
{
    [UIView beginAnimations:@"slidePickerDown" context:nil];
    [myPickerView setFrame:CGRectMake(0, 416, 320, 260)];
    [UIView commitAnimations];
}

- (void)scrollUpBy:(NSInteger)scrollOffset
{
    [myScrollView setContentOffset:CGPointMake(0, scrollOffset)];
    [myScrollView setContentSize:CGSizeMake(320, 416 + scrollOffset)];
}

- (void)scrollBack
{
    [myScrollView setContentOffset:CGPointZero];
    [myScrollView setContentSize:CGSizeMake(320, 416)];
}

- (IBAction)emailTextFieldClicked:(id)sender
{
    [myEmailTextField becomeFirstResponder];
}

- (IBAction)birthdayButtonClicked:(id)sender
{
    [self slidePickerUp];
    [self scrollUpBy:40];
}

- (IBAction)hidePickerButtonPressed:(id)sender
{
    [self slidePickerDown];
    [self scrollBack];
}

- (IBAction)birthdayPickerChanged:(id)sender
{
    DLog(@"");
    [myBirthdayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    }

    NSDate   *pickerDate = myBirthdayPicker.date;
    NSString *dateString = [dateFormatter stringFromDate:pickerDate];

    [myBirthdayButton setTitle:dateString forState:UIControlStateNormal];

    self.myBirthdate = pickerDate;
}

- (IBAction)doneEditingButtonPressed:(id)sender
{
    [firstResponder resignFirstResponder];
    [self setFirstResponder:nil];
}

- (IBAction)doneButtonPressed:(id)sender
{
    captureUser.aboutMe  = myAboutMeTextView.text;
    captureUser.birthday = myBirthdate;
    captureUser.email    = myEmailTextField.text;

    if (myGenderIdentitySegControl.selectedSegmentIndex == 0)
        captureUser.gender = @"female";
    else if (myGenderIdentitySegControl.selectedSegmentIndex == 1)
        captureUser.gender = @"male";

    if ([SharedData notYetCreated])
        [captureUser createOnCaptureForDelegate:self context:nil];
    else
        [captureUser updateOnCaptureForDelegate:self context:nil];
}

#define LOCATION_TEXT_VIEW_TAG 10
#define ABOUT_ME_TEXT_VIEW_TAG 20

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.firstResponder = textField;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.firstResponder = textView;
    if (textView.tag == ABOUT_ME_TEXT_VIEW_TAG)
    {
        [self scrollUpBy:210];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self scrollBack];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text { return YES; }
- (void)textViewDidChange:(UITextView *)textView { }
- (void)textViewDidChangeSelection:(UITextView *)textView { }
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView { return YES; }
- (BOOL)textViewShouldEndEditing:(UITextView *)textView { return YES; }

- (void)handleSuccessWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"OK", nil];
    [alert show];

    [self.navigationController popViewControllerAnimated:YES];

    [SharedData resaveCaptureUser];
}

- (void)handleFailureWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:@"Dismiss"
                                           otherButtonTitles:nil];
    [alert show];

//    [self.navigationController popViewControllerAnimated:YES];
//
//    [SharedData resaveCaptureUser];
}

- (void)createDidSucceedForUser:(JRCaptureUser *)user context:(NSObject *)context
{
    [self handleSuccessWithMessage:@"Profile created"];
}

- (void)createDidFailForUser:(JRCaptureUser *)user withError:(NSError *)error context:(NSObject *)context
{
    [self handleFailureWithMessage:@"Profile not created"];
}

- (void)updateDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context
{
    [self handleSuccessWithMessage:@"Profile updated"];
}

- (void)updateDidFailForObject:(JRCaptureObject *)object withError:(NSError *)error context:(NSObject *)context
{
    [self handleFailureWithMessage:@"Profile not updated"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

- (void)viewDidUnload { [super viewDidUnload]; }

@end
