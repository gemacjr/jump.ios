//
//  ArrayDrillDownViewController.h
//  SimpleCaptureDemo
//
//  Created by Lilli Szafranski on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SharedData.h"
#import "JRCaptureObject.h"


@interface StringArrayDrillDownViewController : UIViewController <UINavigationBarDelegate, UITableViewDelegate,
                                                      UITableViewDataSource, UITextFieldDelegate, JRCaptureObjectDelegate>
{
    UITableView    *myTableView;
    NSMutableArray *objectDataArray;

    NSMutableArray *localCopyArray;

    BOOL isEditing;
    UITextField *firstResponder;
}
@property (nonatomic, strong) IBOutlet UITableView     *myTableView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *myUpdateButton;
@property (nonatomic, retain) IBOutlet UIToolbar       *myKeyboardToolbar;
- (IBAction)replaceButtonPressed:(id)sender;
- (IBAction)doneEditingTextButtonPressed:(id)sender;
- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil forArray:(NSArray*)array
  captureParentObject:(JRCaptureObject*)parentObject andKey:(NSString*)key;
@end
