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
@property (strong) UILabel  *subtitleLabel;
@property (strong) UIView   *editingView;
@end

@implementation ObjectData
@synthesize stringValue;
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
@property (strong) NSString        *tableHeader;
@end

@implementation ArrayDrillDownViewController
@synthesize captureObject;
@synthesize tableHeader;
@synthesize tableData;
@synthesize myTableView;
@synthesize myUpdateButton;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil forObject:(NSArray*)object
  captureParentObject:(JRCaptureObject*)parentObject andKey:(NSString*)key
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        self.captureObject = parentObject;
        self.tableData     = object;
        self.tableHeader   = key;

        newArray = [[NSMutableArray alloc] initWithArray:tableData];
        rowCount = [newArray count] + 1;

        objectDataArray = [[NSMutableArray alloc] initWithCapacity:[tableData count]];
        for (NSUInteger i = 0; i < [tableData count]; i++)
            [objectDataArray addObject:[[ObjectData alloc] init]];
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

    for (ObjectData *data in objectDataArray)
    {
        data.editingView.hidden   = NO;
        data.subtitleLabel.hidden = YES;
    }

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

    for (ObjectData *data in objectDataArray)
    {
        data.editingView.hidden   = YES;
        data.subtitleLabel.hidden = NO;
    }

    isEditing = NO;

    [firstResponder resignFirstResponder], firstResponder = nil;
    [myTableView reloadData];
}

- (IBAction)updateButtonPressed:(id)sender
{
    DLog(@"");
    [captureObject updateObjectOnCaptureForDelegate:self withContext:nil];
}

- (void)addObjectButtonPressed:(UIButton *)sender
{
    DLog(@"");

    JRCaptureObject *newCaptureObject = [[getClassFromKey(tableHeader) alloc] init];
    JRCaptureObject *parentObject     = captureObject;

    [newArray addObject:newCaptureObject];
    [objectDataArray addObject:[[ObjectData alloc] init]];

    [myTableView beginUpdates];
    [myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[newArray count] - 1
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

- (void)deleteObjectButtonPressed:(UIButton *)sender
{
    DLog(@"");
    NSUInteger itemIndex = (NSUInteger) (sender.tag - LEFT_BUTTON_OFFSET);

    [newArray removeObjectAtIndex:itemIndex];
    [objectDataArray removeObjectAtIndex:itemIndex];

    [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:itemIndex inSection:0]]
                       withRowAnimation:UITableViewRowAnimationLeft];
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
    DLog(@"%d rows", rowCount);
    //return rowCount;//[newArray count] + 1;

    return [newArray count] + 1;

//    if (section == 0)
//        return [newArray count] + 1;
//    else
//        return 1;
}

#define HIGHER_SUBTITLE 10
#define NORMAL_SUBTITLE 21
#define UP_A_LITTLE_HIGHER(r) CGRectMake(r.frame.origin.x, HIGHER_SUBTITLE, r.frame.size.width, r.frame.size.height)
#define WHERE_IT_SHOULD_BE(r) CGRectMake(r.frame.origin.x, NORMAL_SUBTITLE, r.frame.size.width, r.frame.size.height)

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"");
    static NSInteger keyLabelTag    = 1;
    static NSInteger valueLabelTag  = 2;
           NSInteger editingViewTag = EDITING_VIEW_OFFSET + indexPath.row;

    UITableViewCellStyle style = UITableViewCellStyleDefault;
    NSString *reuseIdentifier  = [NSString stringWithFormat:@"cachedCell_%d", indexPath.row];

    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    if (indexPath.row == [newArray count])
    {
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];
        }

        cell.textLabel.text = [NSString stringWithFormat:@"Add another %@ object", tableHeader];
    }
    else
    {
        ObjectData *objectData = [objectDataArray objectAtIndex:(NSUInteger)indexPath.row];

        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];

            CGRect frame = CGRectMake(10, 5, (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? 280 : 440, 18);

            UILabel *keyLabel = [[UILabel alloc] initWithFrame:frame];
            keyLabel.tag      = keyLabelTag;

            keyLabel.backgroundColor  = [UIColor clearColor];
            keyLabel.font             = [UIFont systemFontOfSize:13.0];
            keyLabel.textColor        = [UIColor grayColor];
            keyLabel.textAlignment    = UITextAlignmentLeft;
            keyLabel.autoresizingMask = UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth;

            [cell.contentView addSubview:keyLabel];

            frame.origin.y     += 16;
            frame.size.height  += 8;

            UILabel *valueLabel = [[UILabel alloc] initWithFrame:frame];
            valueLabel.tag      = valueLabelTag;

            valueLabel.backgroundColor  = [UIColor clearColor];
            valueLabel.font             = [UIFont boldSystemFontOfSize:16.0];
            valueLabel.textColor        = [UIColor grayColor];
            valueLabel.textAlignment    = UITextAlignmentLeft;
            valueLabel.autoresizingMask = UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth;

            [cell.contentView addSubview:valueLabel];

            UIView *editingView = [self getButtonBox];
            [editingView addSubview:[self getLeftButtonWithTitle:@"Delete"
                                                             tag:indexPath.row
                                                     andSelector:@selector(deleteObjectButtonPressed:)]];
            [editingView addSubview:[self getRightButtonWithTitle:@"Edit"
                                                              tag:indexPath.row
                                                      andSelector:@selector(editObjectButtonPressed:)]];

            [editingView setTag:editingViewTag];
            [editingView setHidden:YES];
            [editingView setAutoresizingMask:UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth];

            [objectData setEditingView:editingView];
            [objectData setSubtitleLabel:valueLabel];
            [cell addSubview:editingView];
        }

        UILabel *titleLabel    = (UILabel*)[cell.contentView viewWithTag:keyLabelTag];
        UILabel *subtitleLabel = (UILabel*)[cell.contentView viewWithTag:valueLabelTag];
        UIView  *editingView   = [cell.contentView viewWithTag:editingViewTag];

        NSString* subtitle  = nil;
        NSString* cellTitle = nil;

        cell.textLabel.text       = nil;
        cell.detailTextLabel.text = nil;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;

        NSString *key;
        NSObject *value = nil;

        key   = [NSString stringWithFormat:@"%@[%d]", tableHeader, indexPath.row];
        value = [newArray objectAtIndex:(NSUInteger) indexPath.row];

        cellTitle = key;
        subtitle  = [[(JRCaptureObject *)value toDictionary] JSONString];

        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];

        subtitleLabel.text = subtitle;
        titleLabel.text    = cellTitle;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"");
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (indexPath.row == [newArray count])
    {
        [self addObjectButtonPressed:nil];
//        [myTableView insertRowsAtIndexPaths:
//                             [NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row
//                                                                         inSection:indexPath.section]]
//                           withRowAnimation:UITableViewRowAnimationLeft];
    }
    else
    {
        NSString *newHeader = [NSString stringWithFormat:@"%@[%d]", tableHeader, indexPath.row];
        NSObject *newObject = [newArray objectAtIndex:(NSUInteger) indexPath.row];

        UIViewController *drillDown;

        if ([newObject isKindOfClass:[JRStringPluralElement class]])
            drillDown = [[SimplePluralViewController alloc] initWithNibName:@"SimplePluralViewController"
                                                                     bundle:[NSBundle mainBundle]
                                                                  forObject:(JRStringPluralElement *) newObject
                                                        captureParentObject:captureObject
                                                                     andKey:newHeader];
        else
            drillDown = [[ObjectDrillDownViewController alloc] initWithNibName:@"ObjectDrillDownViewController"
                                                                        bundle:[NSBundle mainBundle]
                                                                     forObject:(JRCaptureObject *) newObject
                                                           captureParentObject:captureObject
                                                                        andKey:newHeader];

        [[self navigationController] pushViewController:drillDown animated:YES];
    }
}

- (void)replaceCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{
    DLog(@"");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:result
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)replaceCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    DLog(@"");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:result
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)updateCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
{
    DLog(@"");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:result
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    DLog(@"");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:result
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

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
//    tableViewHeader, tableViewHeader = nil;
//    tableViewData, tableViewData = nil;
}
@end

