//
//  ObjectDrillDownViewControllerViewController.h
//  SimpleCaptureDemo
//
//  Created by Lilli Szafranski on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SharedData.h"
#import "ArrayDrillDownViewController.h"
#import "JRCapture.h"

@interface ObjectDrillDownViewController : UIViewController <UINavigationBarDelegate, UITableViewDelegate,
                                                    UITableViewDataSource, UITextFieldDelegate, JRCaptureObjectDelegate>
{
    UITableView    *myTableView;
    NSMutableArray *propertyDataArray;

    CGFloat tableWidth;
    CGFloat tableHeight;

    BOOL isEditing;
    UITextField *firstResponder;

    UIDatePicker *myDatePicker;
    UIView       *myPickerView;
}
@property (nonatomic, strong) IBOutlet UITableView     *myTableView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *myUpdateButton;
@property (nonatomic, retain) IBOutlet UIDatePicker    *myDatePicker;
//@property (nonatomic, retain) IBOutlet UIToolbar       *myPickerToolbar;
@property (nonatomic, retain) IBOutlet UIView          *myPickerView;
@property (nonatomic, retain) IBOutlet UIToolbar       *myKeyboardToolbar;
- (IBAction)updateButtonPressed:(id)sender;
- (IBAction)datePickerChanged:(id)sender;
//- (void)changeDateButtonPressed:(id)sender;
- (IBAction)hidePickerButtonPressed:(id)sender;
- (IBAction)doneEditingTextButtonPressed:(id)sender;
- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil forObject:(JRCaptureObject*)object
  captureParentObject:(JRCaptureObject*)parentObject andKey:(NSString*)key;
@end
