/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2010, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "ArrayDrillDownViewController.h"
#import "ObjectDrillDownViewController.h"

typedef enum propertyTypes
{
    PTCaptureObject,
    PTArray,
    PTString,
    PTNumber,
    PTDate,
    PTBool,
    PTInteger,
    PTJsonObject,
    PTUnknown,
} PropertyType;

@interface ObjectData : NSObject
@property (strong) NSString *stringValue;
@property (strong) UILabel  *titleLabel;
@property (strong) UILabel  *subtitleLabel;
@property (strong) UIView   *editingView;
@end

@implementation ObjectData
@synthesize stringValue;
@synthesize titleLabel;
@synthesize subtitleLabel;
@synthesize editingView;
@end

static Class getClassFromKey(NSString *key)
{
    if (!key || [key length] < 1)
        return nil;

    return NSClassFromString([NSString stringWithFormat:@"JR%@",
                  [key stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                               withString:[[key substringToIndex:1] capitalizedString]]]);
}

@interface ArrayDrillDownViewController ()
@property (strong) JRCaptureObject *captureObject;
@property (strong) NSArray         *tableData;
@property (strong) NSMutableArray  *localCopyArray;
@property (strong) NSMutableArray  *objectDataArray;
@property (strong) NSString        *tableHeader;
- (void)setCellTextForObjectData:(ObjectData *)objectData atIndex:(NSUInteger)index;
- (void)createCellViewsForObjectData:(ObjectData *)objectData atIndex:(NSUInteger)index;
@end

@implementation ArrayDrillDownViewController
@synthesize captureObject;
@synthesize tableHeader;
@synthesize tableData;
@synthesize myTableView;
@synthesize myUpdateButton;
@synthesize localCopyArray;
@synthesize objectDataArray;

- (void)setTableDataWithArray:(NSArray *)array
{
    self.tableData       = array;
    self.localCopyArray = [[NSMutableArray alloc] initWithArray:tableData];
    self.objectDataArray = [[NSMutableArray alloc] initWithCapacity:[tableData count]];

    for (NSUInteger i = 0; i < [tableData count]; i++)
    {
        ObjectData *objectData = [[ObjectData alloc] init];

        [self createCellViewsForObjectData:objectData atIndex:i];
        [self setCellTextForObjectData:objectData atIndex:i];

        [objectDataArray addObject:objectData];
    }
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil forArray:(NSArray*)array
  captureParentObject:(JRCaptureObject*)parentObject andKey:(NSString*)key
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        self.captureObject = parentObject;
        self.tableHeader   = key;

        [self setTableDataWithArray:array];
    }

    DLog(@"%@", [tableData description]);

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                     target:self
                                                     action:@selector(editButtonPressed:)];

    self.navigationItem.rightBarButtonItem         = editButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;

    self.navigationItem.rightBarButtonItem.style   = UIBarButtonItemStyleBordered;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [myTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)editButtonPressed:(id)sender
{
    DLog(@"");
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                     target:self
                                                     action:@selector(doneButtonPressed:)];

    self.navigationItem.rightBarButtonItem         = doneButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;

    self.navigationItem.rightBarButtonItem.style   = UIBarButtonItemStyleBordered;

    isEditing = YES;

    [myTableView reloadData];
}

- (void)doneButtonPressed:(id)sender
{
    DLog(@"");
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                     target:self
                                                     action:@selector(editButtonPressed:)];

    self.navigationItem.rightBarButtonItem         = editButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;

    self.navigationItem.rightBarButtonItem.style   = UIBarButtonItemStyleBordered;

    isEditing = NO;

    [firstResponder resignFirstResponder], firstResponder = nil;
    [myTableView reloadData];
}

- (void)saveLocalArrayToCaptureObject
{
    SEL setArraySelector =
                NSSelectorFromString([NSString stringWithFormat:@"set%@:",
                          [tableHeader stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                               withString:[[tableHeader substringToIndex:1] capitalizedString]]]);

    [captureObject performSelector:setArraySelector withObject:[NSArray arrayWithArray:localCopyArray]];
}

- (IBAction)replaceButtonPressed:(id)sender
{
    DLog(@"");

    [self doneButtonPressed:nil];
    [self saveLocalArrayToCaptureObject];

    SEL replaceArraySelector =
                NSSelectorFromString([NSString stringWithFormat:@"replace%@ArrayOnCaptureForDelegate:withContext:",
                        [tableHeader stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                             withString:[[tableHeader substringToIndex:1] capitalizedString]]]);

    [captureObject performSelector:replaceArraySelector withObject:self withObject:nil];
}

- (void)addObjectButtonPressed:(UIButton *)sender
{
    DLog(@"");

    NSObject *newCaptureElement = [[getClassFromKey(tableHeader) alloc] init];

    [localCopyArray addObject:newCaptureElement];

    ObjectData *objectData = [[ObjectData alloc] init];

    [self createCellViewsForObjectData:objectData atIndex:[objectDataArray count]];
    [self setCellTextForObjectData:objectData atIndex:[objectDataArray count]];

    [objectDataArray addObject:objectData];

    [self saveLocalArrayToCaptureObject];

    [myTableView beginUpdates];
    [myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[localCopyArray count] - 1
                                                                                    inSection:0]]
                       withRowAnimation:UITableViewRowAnimationLeft];
    [myTableView endUpdates];
}

#define EDITING_VIEW_OFFSET 100
#define LEFT_BUTTON_OFFSET  1000
#define RIGHT_BUTTON_OFFSET 2000
#define LEFT_LABEL_OFFSET   3000
#define DATE_PICKER_OFFSET  4000

- (void)editObjectButtonPressed:(UIButton *)sender
{
    DLog(@"");
    NSUInteger itemIndex = (NSUInteger) (sender.tag - RIGHT_BUTTON_OFFSET);

    JRCaptureObject *captureSubObject = [tableData objectAtIndex:itemIndex];
    JRCaptureObject *parentObject     = captureObject;

    ObjectDrillDownViewController *drillDown =
                [[ObjectDrillDownViewController alloc] initWithNibName:@"ObjectDrillDownViewController"
                                                                bundle:[NSBundle mainBundle]
                                                             forObject:captureSubObject
                                                   captureParentObject:parentObject
                                                                andKey:tableHeader];

    [[self navigationController] pushViewController:drillDown animated:YES];
}

- (void)calibrateIndices
{
    for (NSUInteger i = 0; i < [objectDataArray count]; i++)
    {
        ObjectData *objectData = [objectDataArray objectAtIndex:i];
        NSInteger oldIndex = objectData.editingView.tag - EDITING_VIEW_OFFSET;

        [objectData.editingView setTag:EDITING_VIEW_OFFSET + i];
        [[objectData.editingView viewWithTag:LEFT_BUTTON_OFFSET + oldIndex] setTag:LEFT_BUTTON_OFFSET + i];
        [[objectData.editingView viewWithTag:RIGHT_BUTTON_OFFSET + oldIndex] setTag:RIGHT_BUTTON_OFFSET + i];

        [self setCellTextForObjectData:objectData atIndex:i];
    }
}

- (void)deleteObjectButtonPressed:(UIButton *)sender
{
    DLog(@"");
    NSUInteger itemIndex = (NSUInteger) (sender.tag - LEFT_BUTTON_OFFSET);

    [localCopyArray removeObjectAtIndex:itemIndex];
    [objectDataArray removeObjectAtIndex:itemIndex];

    [self saveLocalArrayToCaptureObject];

    [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:itemIndex inSection:0]]
                       withRowAnimation:UITableViewRowAnimationLeft];

    [self calibrateIndices];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return tableHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableHeader)
        return 30.0;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (isEditing)
        return 260;
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [localCopyArray count] + 1;
}

- (UIButton *)getLeftButtonWithTitle:(NSString *)title tag:(NSInteger)tag andSelector:(SEL)selector
{
    CGRect frame = CGRectMake(0, 0, (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? 125 : 205, 22);

    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButton.frame  = frame;

    [leftButton setTitle:title forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor]
                     forState:UIControlStateNormal];
    [leftButton setTitleShadowColor:[UIColor grayColor]
                           forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [leftButton setHidden:NO];
    [leftButton setTag:tag + LEFT_BUTTON_OFFSET];

    [leftButton addTarget:self
                   action:selector
         forControlEvents:UIControlEventTouchUpInside];

    [leftButton setAutoresizingMask:UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth];

    return leftButton;
}

- (UIView *)getRightButtonWithTitle:(NSString *)title tag:(NSInteger)tag andSelector:(SEL)selector
{
    CGRect frame = CGRectMake((UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? 135 : 215, 0,
                              (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? 125 : 205, 22);

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButton.frame  = frame;

    [rightButton setTitle:title forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor]
                      forState:UIControlStateNormal];
    [rightButton setTitleShadowColor:[UIColor grayColor]
                            forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [rightButton setHidden:NO];
    [rightButton setTag:tag + RIGHT_BUTTON_OFFSET];

    [rightButton addTarget:self
                    action:selector
          forControlEvents:UIControlEventTouchUpInside];

    [rightButton setAutoresizingMask:UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth];

    return rightButton;
}

- (UIView *)getButtonBox
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 23, (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? 270 : 430, 22)];

    view.backgroundColor = [UIColor clearColor];

    return view;
}

- (void)setCellTextForObjectData:(ObjectData *)objectData atIndex:(NSUInteger)index
{
    NSString *key   = [NSString stringWithFormat:@"%@[%d]", tableHeader, index];
    NSObject *value = [localCopyArray objectAtIndex:index];

    objectData.titleLabel.text    = key;
    objectData.subtitleLabel.text = [[(JRCaptureObject *)value toDictionary] JSONString];
}

- (void)createCellViewsForObjectData:(ObjectData *)objectData atIndex:(NSUInteger)index
{
    NSInteger editingViewTag = EDITING_VIEW_OFFSET + index;

    CGRect frame = CGRectMake(10, 5, (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? 280 : 440, 18);

    UILabel *keyLabel = [[UILabel alloc] initWithFrame:frame];

    keyLabel.backgroundColor  = [UIColor clearColor];
    keyLabel.font             = [UIFont systemFontOfSize:13.0];
    keyLabel.textColor        = [UIColor grayColor];
    keyLabel.textAlignment    = UITextAlignmentLeft;
    keyLabel.autoresizingMask = UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth;

    [objectData setTitleLabel:keyLabel];

    frame.origin.y     += 16;
    frame.size.height  += 8;

    UILabel *valueLabel = [[UILabel alloc] initWithFrame:frame];

    valueLabel.backgroundColor  = [UIColor clearColor];
    valueLabel.font             = [UIFont boldSystemFontOfSize:16.0];
    valueLabel.textColor        = [UIColor grayColor];
    valueLabel.textAlignment    = UITextAlignmentLeft;
    valueLabel.autoresizingMask = UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth;

    [objectData setSubtitleLabel:valueLabel];

    UIView *editingView = [self getButtonBox];
    [editingView addSubview:[self getLeftButtonWithTitle:@"Delete"
                                                     tag:index
                                             andSelector:@selector(deleteObjectButtonPressed:)]];
    [editingView addSubview:[self getRightButtonWithTitle:@"Edit"
                                                      tag:index
                                              andSelector:@selector(editObjectButtonPressed:)]];

    [editingView setTag:editingViewTag];
    [editingView setAutoresizingMask:UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth];

    [objectData setEditingView:editingView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"");

    UITableViewCellStyle style = UITableViewCellStyleDefault;
    NSString *reuseIdentifier  = (indexPath.row == [localCopyArray count]) ? @"lastCell" : @"cachedCell";

    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (indexPath.row == [localCopyArray count])
    {
        cell.textLabel.text = [NSString stringWithFormat:@"Add another %@ object", tableHeader];
    }
    else
    {
        ObjectData *objectData = [objectDataArray objectAtIndex:(NSUInteger)indexPath.row];

        for (UIView *view in [cell.contentView subviews])
            [view removeFromSuperview];

        UILabel *titleLabel    = objectData.titleLabel;
        UILabel *subtitleLabel = objectData.subtitleLabel;
        UIView  *editingView   = objectData.editingView;

        [cell.contentView addSubview:titleLabel];
        [cell.contentView addSubview:subtitleLabel];
        [cell.contentView addSubview:editingView];

        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];

        [editingView setHidden:!isEditing];
        [subtitleLabel setHidden:isEditing];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"");
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (indexPath.row == [localCopyArray count])
    {
        [self addObjectButtonPressed:nil];
    }
    else
    {
        NSString *newHeader = [NSString stringWithFormat:@"%@[%d]", tableHeader, indexPath.row];
        NSObject *newObject = [localCopyArray objectAtIndex:(NSUInteger) indexPath.row];

        UIViewController *drillDown =
                [[ObjectDrillDownViewController alloc] initWithNibName:@"ObjectDrillDownViewController"
                                                                bundle:[NSBundle mainBundle]
                                                             forObject:(JRCaptureObject *) newObject
                                                   captureParentObject:captureObject
                                                                andKey:newHeader];

        [[self navigationController] pushViewController:drillDown animated:YES];
    }
}

- (void)replaceArrayNamed:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result
                  context:(NSObject *)context
{
    DLog(@"");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:result
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
    [alertView show];
}


- (void)replaceArray:(NSArray *)newArray named:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object
didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    DLog(@"");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:result
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];

    //SEL getArraySelector = NSSelectorFromString(tableHeader);
    //NSArray *array       = [object performSelector:getArraySelector];

    [self setTableDataWithArray:newArray];
    [myTableView reloadData];
}

//- (void)replaceCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
//{
//    DLog(@"");
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                        message:result
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Dismiss"
//                                              otherButtonTitles:nil];
//    [alertView show];
//}
//
//- (void)replaceCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
//{
//    DLog(@"");
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
//                                                        message:result
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//    [alertView show];
//
//    SEL getArraySelector = NSSelectorFromString(tableHeader);
//    NSArray *array       = [object performSelector:getArraySelector];
//
//    [self setTableDataWithArray:array];
//}
//
//- (void)updateCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
//{
//    DLog(@"");
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                        message:result
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Dismiss"
//                                              otherButtonTitles:nil];
//    [alertView show];
//}
//
//- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
//{
//    DLog(@"");
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
//                                                        message:result
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//    [alertView show];
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
}
@end

