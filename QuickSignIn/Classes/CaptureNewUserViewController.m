//
//  CaptureNewUserViewController.m
//  QuickSignIn
//
//  Created by Lilli Szafranski on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CaptureNewUserViewController.h"

@implementation CaptureNewUserViewController
@synthesize myHometownTextView;
@synthesize myGenderIdentitySegControl;
@synthesize myBirthdayButton;
@synthesize myBirthdayPicker;
@synthesize myPickerToolbar;
@synthesize myAgreeSwitch;

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
    [super dealloc];
}
@end
