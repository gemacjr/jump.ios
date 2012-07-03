//
//  ViewController.h
//  SimpleCaptureDemo
//
//  Created by lilli on 02/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedData.h"
#import "JRCaptureObject.h"

@interface ViewController : UIViewController <SignInDelegate, JRCaptureObjectDelegate>
- (IBAction)browseButtonPressed:(id)sender;
- (IBAction)updateButtonPressed:(id)sender;
- (IBAction)testerButtonPressed:(id)sender;
- (IBAction)signInButtonPressed:(id)sender;
@property (weak) IBOutlet UILabel *currentUserLabel;
@property (weak) IBOutlet UIImageView *currentUserProviderIcon;
@property (weak) IBOutlet UIButton *browseButton;
@property (weak) IBOutlet UIButton *updateButton;
@property (weak) IBOutlet UIButton *testerButton;
@property (weak) IBOutlet UIButton *signinButton;
@end
