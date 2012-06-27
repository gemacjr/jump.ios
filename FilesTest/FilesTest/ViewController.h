//
//  ViewController.h
//  FilesTest
//
//  Created by Lilli Szafranski on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JREngage.h"

@interface ViewController : UIViewController <JREngageDelegate>
{
    UIButton *myButton;
    JREngage *jrEngage;
}
@property (nonatomic, retain) IBOutlet UIButton *myButton;
- (IBAction)signinButtonPressed:(id)sender;
@end
