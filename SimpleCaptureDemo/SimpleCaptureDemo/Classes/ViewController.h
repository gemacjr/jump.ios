//
//  ViewController.h
//  SimpleCaptureDemo
//
//  Created by lilli on 02/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedData.h"
#import "JREngage+CustomInterface.h"
#import "CaptureNewUserViewController.h"
#import "UserDrillDownViewController.h"
#import "ObjectDrillDownViewController.h"
//#import "JREngage.h"
//#import "JRCaptureInterface.h"


@interface ViewController : UIViewController <SignInDelegate, JRCaptureObjectDelegate>
- (IBAction)browseButtonPressed:(id)sender;
- (IBAction)updateButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)signInButtonPressed:(id)sender;

@property (weak) IBOutlet UILabel *currentUserLabel;
@property (weak) IBOutlet UIImageView *currentUserProviderIcon;
@end
