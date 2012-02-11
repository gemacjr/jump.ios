//
//  CaptureNewUserViewController.h
//  QuickSignIn
//
//  Created by Lilli Szafranski on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "JRCaptureInterface.h"

@interface CaptureNewUserViewController : UIViewController <JRCaptureInterfaceDelegate, UITextViewDelegate,
        UIAlertViewDelegate>
{
    NSMutableDictionary *engageUser;
    UIScrollView *myScrollView;

    NSDate       *myBirthdate;
    UIButton     *myBirthdayButton;

    UIDatePicker *myBirthdayPicker;
    UIToolbar    *myPickerToolbar;
    UIView       *myPickerView;
}
@property (nonatomic, retain) IBOutlet UITextView         *myLocationTextView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *myGenderIdentitySegControl;
@property (nonatomic, retain) IBOutlet UIButton           *myBirthdayButton;
@property (nonatomic, retain) IBOutlet UIDatePicker       *myBirthdayPicker;
@property (nonatomic, retain) IBOutlet UIToolbar          *myPickerToolbar;
@property (nonatomic, retain) IBOutlet UITextView         *myAboutMeTextView;
@property (nonatomic, retain) IBOutlet UIView             *myPickerView;
@property (nonatomic, retain) IBOutlet UIScrollView       *myScrollView;
@property (nonatomic, retain) IBOutlet UIToolbar          *myKeyboardToolbar;
- (IBAction)birthdayButtonClicked:(id)sender;
- (IBAction)birthdayPickerChanged:(id)sender;
- (IBAction)hidePickerButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)doneEditingButtonPressed:(id)sender;
@end
