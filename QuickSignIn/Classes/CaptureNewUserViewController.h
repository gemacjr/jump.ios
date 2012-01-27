//
//  CaptureNewUserViewController.h
//  QuickSignIn
//
//  Created by Lilli Szafranski on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSIUserModel.h"
#import "CaptureInterface.h"

@interface CaptureNewUserViewController : UIViewController <CaptureInterfaceDelegate>
{
    NSDictionary    *newUser;

    UIDatePicker *myBirthdayPicker;
    UIButton     *myBirthdayButton;

    UIToolbar    *myPickerToolbar;
}
@property (nonatomic, retain) IBOutlet UITextView         *myHometownTextView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *myGenderIdentitySegControl;
@property (nonatomic, retain) IBOutlet UIButton           *myBirthdayButton;
@property (nonatomic, retain) IBOutlet UIDatePicker       *myBirthdayPicker;
@property (nonatomic, retain) IBOutlet UIToolbar          *myPickerToolbar;
@property (nonatomic, retain) IBOutlet UISwitch           *myAgreeSwitch;
- (IBAction)birthdayButtonClicked:(id)sender;
- (IBAction)birthdayPickerChanged:(id)sender;
- (IBAction)hidePickerButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
@end
