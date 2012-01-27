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
@end

@implementation CaptureNewUserViewController
@synthesize myHometownTextView;
@synthesize myGenderIdentitySegControl;
@synthesize myBirthdayButton;
@synthesize myBirthdayPicker;
@synthesize myPickerToolbar;
@synthesize myAgreeSwitch;
@synthesize newUser;


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
}

- (IBAction)birthdayButtonClicked:(id)sender
{

}

- (IBAction)birthdayPickerChanged:(id)sender
{

}

- (IBAction)hidePickerButtonPressed:(id)sender
{

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
    [myHometownTextView release];
    [myGenderIdentitySegControl release];
    [myBirthdayButton release];
    [myBirthdayPicker release];
    [myAgreeSwitch release];
    [myPickerToolbar release];
    [newUser release];
    [super dealloc];
}
@end
