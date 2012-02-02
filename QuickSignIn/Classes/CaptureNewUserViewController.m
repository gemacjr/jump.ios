//
//  CaptureNewUserViewController.m
//  QuickSignIn
//
//  Created by Lilli Szafranski on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "CaptureNewUserViewController.h"

@interface CaptureNewUserViewController ()
@property (nonatomic, retain) NSMutableDictionary *newUser;
@property (nonatomic, retain) UITextView          *firstResponder;
@end

@implementation CaptureNewUserViewController
@synthesize myLocationTextView;
@synthesize myGenderIdentitySegControl;
@synthesize myBirthdayButton;
@synthesize myBirthdayPicker;
@synthesize myPickerToolbar;
@synthesize newUser;
@synthesize myAboutMeTextView;
@synthesize myPickerView;
@synthesize myScrollView;
@synthesize myKeyboardToolbar;
@synthesize firstResponder;

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

    NSDictionary *user   = [[UserModel getUserModel] currentUser];
    NSString *identifier = [user objectForKey:@"identifier"];
    self.newUser         = [NSMutableDictionary dictionaryWithDictionary:
                                   [[[UserModel getUserModel] userProfiles] objectForKey:identifier]];


    [myPickerView setFrame:CGRectMake(0, 416, 320, 260)];
    [self.view addSubview:myPickerView];

    [myAboutMeTextView setInputAccessoryView:myKeyboardToolbar];
    [myLocationTextView setInputAccessoryView:myKeyboardToolbar];

    
    //[myBirthdayButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    //[myBirthdayButton.titleLabel setTextAlignment:UITextAlignmentRight];
}

- (void)slidePickerUp
{
    [UIView beginAnimations:@"slidePickerUp" context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationDelay:0.9];
    [myPickerView setFrame:CGRectMake(0, 156, 320, 260)];
    [UIView commitAnimations];
}

- (void)sliderPickerDown
{
    [UIView beginAnimations:@"slidePickerDown" context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationDelay:0.9];
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

- (IBAction)birthdayButtonClicked:(id)sender
{
    [self slidePickerUp];
    [self scrollUpBy:40];
}

- (IBAction)hidePickerButtonPressed:(id)sender
{
    [self sliderPickerDown];
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
        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    }

    NSDate   *pickerDate = myBirthdayPicker.date;
    NSString *dateString = [dateFormatter stringFromDate:pickerDate];

    [myBirthdayButton setTitle:dateString forState:UIControlStateNormal];
}

- (IBAction)doneEditingButtonPressed:(id)sender
{
    [firstResponder resignFirstResponder];
    [self setFirstResponder:nil];
}

- (IBAction)doneButtonPressed:(id)sender
{
    DLog(@"");

    //    NSMutableDictionary *newCaptureStuff =
    //                                [NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                                                            myHometownTextView.text, @"hometown",
    //                                                            myBirthdayButton.titleLabel.text, @"birthday",
    //                                                            myGenderIdentitySegControl.selectedSegmentIndex ?
    //                                                                    @"male" : @"female", @"gender", nil];
    //    [newUser setObject:newCaptureStuff forKey:@"captureAdditions"];

    [CaptureInterface createCaptureUser:newUser
                            forDelegate:self];
}

#define LOCATION_TEXT_VIEW_TAG 10
#define ABOUT_ME_TEXT_VIEW_TAG 20


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


- (void)createCaptureUserDidSucceed
{
    ;
}

- (void)createCaptureUserDidFail
{
    ;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

- (void)viewDidUnload { [super viewDidUnload]; }

- (void)dealloc
{
    [myLocationTextView release];
    [myGenderIdentitySegControl release];
    [myBirthdayButton release];
    [myBirthdayPicker release];
    [myPickerToolbar release];
    [myAboutMeTextView release];
    [newUser release];
    [myPickerView release];
    [myScrollView release];
    [myKeyboardToolbar release];
    [firstResponder release];
    [super dealloc];
}
@end
