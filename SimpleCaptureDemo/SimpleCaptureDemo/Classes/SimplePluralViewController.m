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

#import "SimplePluralViewController.h"

typedef enum propertyTypes
{
    PTString,
    PTObjectId,
    PTUnknown,
} IdOrStringType;

@interface SimplePluralPropertyData : NSObject
@property          IdOrStringType propertyType;
@property (strong) NSString *propertyName;
@property          SEL       propertySetSelector;
@property          SEL       propertyGetSelector;
@property (strong) NSString *stringValue;
@property (strong) UILabel  *subtitleLabel;
@property (strong) UIView   *editingView;
@property          BOOL      canEdit;
@property          BOOL      canDrillDown;
- (void)printDescription;
@end

@implementation SimplePluralPropertyData
@synthesize propertyType;
@synthesize propertyName;
@synthesize propertySetSelector;
@synthesize propertyGetSelector;
@synthesize stringValue;
@synthesize subtitleLabel;
@synthesize editingView;
@synthesize canEdit;
@synthesize canDrillDown;

- (void)printDescription
{
    DLog("propertyType=%d, propertyName=%@, propertySetSelector=%d, propertyGetSelector=%d, stringValue=%@",
            propertyType, propertyName, propertySetSelector, propertyGetSelector, stringValue);
}
@end

static SEL getSetSelectorFromKey(NSString *key)
{
    if (!key || [key length] < 1)
        return nil;

    return NSSelectorFromString([NSString stringWithFormat:@"set%@:",
                  [key stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                               withString:[[key substringToIndex:1] capitalizedString]]]);
}

static SEL getGetSelectorFromKey(NSString *key)
{
    if (!key || [key length] < 1)
        return nil;

    return NSSelectorFromString(key);
}

static Class getClassFromKey(NSString *key)
{
    if (!key || [key length] < 1)
        return nil;

    return NSClassFromString([NSString stringWithFormat:@"JR%@",
                  [key stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                               withString:[[key substringToIndex:1] capitalizedString]]]);
}

@interface SimplePluralViewController ()
@property (strong) JRCaptureObject *captureObject;
@property (strong) JRCaptureObject *parentCaptureObject;
@property (strong) NSDictionary    *tableData;
@property (strong) NSString        *tableHeader;
@end

@implementation SimplePluralViewController
@synthesize captureObject;
@synthesize parentCaptureObject;
@synthesize tableHeader;
@synthesize tableData;
@synthesize myTableView;
@synthesize myUpdateButton;
@synthesize myKeyboardToolbar;

- (NSArray *)createPropertyArrayFromObject:(JRStringPluralElement *)object
{
    SimplePluralPropertyData *propertyDataId = [[SimplePluralPropertyData alloc] init];

    propertyDataId.propertyType = PTObjectId;
    propertyDataId.propertyName = @"elementId";

    propertyDataId.propertySetSelector = getSetSelectorFromKey(propertyDataId.propertyName);
    propertyDataId.propertyGetSelector = getGetSelectorFromKey(propertyDataId.propertyName);
    propertyDataId.canEdit = NO;

    SimplePluralPropertyData *propertyDataValue = [[SimplePluralPropertyData alloc] init];

    propertyDataValue.propertyType = PTString;
    propertyDataValue.propertyName = [object type];

    propertyDataValue.propertySetSelector = getSetSelectorFromKey(@"value");
    propertyDataValue.propertyGetSelector = getGetSelectorFromKey(@"value");
    propertyDataValue.canEdit = YES;

    return [NSArray arrayWithObjects:propertyDataId, propertyDataValue, nil];
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil forObject:(JRStringPluralElement*)object
  captureParentObject:(JRCaptureObject*)parentObject andKey:(NSString*)key
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        self.captureObject       = object;
        self.parentCaptureObject = parentObject;

        self.tableData = [object toDictionary];

        self.tableHeader = key;
        propertyDataArray = [self createPropertyArrayFromObject:object];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    tableWidth  = myTableView.frame.size.width;
    tableHeight = myTableView.frame.size.height;

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

#define EDITING_VIEW_OFFSET 100
//#define LEFT_BUTTON_OFFSET  1000
//#define RIGHT_BUTTON_OFFSET 2000
//#define LEFT_LABEL_OFFSET   3000
//#define DATE_PICKER_OFFSET  4000

- (void)scrollTableViewToRect:(CGRect)rect
{
    [myTableView scrollRectToVisible:rect animated:YES];
}

- (IBAction)doneEditingTextButtonPressed:(id)sender
{
    [firstResponder resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!firstResponder)
    {
        [self scrollTableViewToRect:CGRectMake(0, textField.superview.frame.origin.y - 45,
                (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? 320 : 480,
                (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? 416 : 256)];
    }

    firstResponder = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSUInteger itemIndex = (NSUInteger) (textField.tag - EDITING_VIEW_OFFSET);
    SimplePluralPropertyData *currentPropertyData = [propertyDataArray objectAtIndex:itemIndex];

    if ([textField.text isEqualToString:@""])
        textField.text = nil;

    if (![textField.text isEqualToString:currentPropertyData.stringValue])
    {
        if ([captureObject respondsToSelector:currentPropertyData.propertySetSelector])
        {
            [captureObject performSelector:currentPropertyData.propertySetSelector
                                withObject:textField.text];
            currentPropertyData.stringValue = textField.text;
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
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
    return [[tableData allKeys] count];
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

//    for (SimplePluralPropertyData *data in propertyDataArray)
//    {
//        if (data.canEdit)
//        {
//            data.editingView.hidden   = NO;
//            data.subtitleLabel.hidden = YES;
//        }
//    }

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

//    for (SimplePluralPropertyData *data in propertyDataArray)
//    {
//        if (data.canEdit)
//        {
//            data.editingView.hidden   = YES;
//            data.subtitleLabel.hidden = NO;
//        }
//    }

    isEditing = NO;

    [firstResponder resignFirstResponder], firstResponder = nil;
    [myTableView reloadData];
}

- (IBAction)updateButtonPressed:(id)sender
{
    DLog(@"");
    [self doneButtonPressed:nil];
    [captureObject updateObjectOnCaptureForDelegate:self withContext:nil];
}

#define HIGHER_SUBTITLE 10
#define NORMAL_SUBTITLE 21
#define UP_A_LITTLE_HIGHER(r) CGRectMake(r.frame.origin.x, HIGHER_SUBTITLE, r.frame.size.width, r.frame.size.height)
#define WHERE_IT_SHOULD_BE(r) CGRectMake(r.frame.origin.x, NORMAL_SUBTITLE, r.frame.size.width, r.frame.size.height)

- (UIView *)getTextFieldWithKeyboardType:(UIKeyboardType)keyboardType
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 23,
            (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? 280 : 440, 22)];

    textField.backgroundColor = [UIColor clearColor];
    textField.font            = [UIFont systemFontOfSize:14.0];
    textField.textColor       = [UIColor blackColor];
    textField.textAlignment   = UITextAlignmentLeft;
    textField.hidden          = YES;
    textField.borderStyle     = UITextBorderStyleLine;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate        = self;
    textField.keyboardType    = keyboardType;

    [textField setInputAccessoryView:myKeyboardToolbar];
    [textField setAutoresizingMask:UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth];

    return textField;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSInteger keyLabelTag    = 1;
    static NSInteger valueLabelTag  = 2;
           NSInteger editingViewTag = EDITING_VIEW_OFFSET + indexPath.row;

    UITableViewCellStyle style = UITableViewCellStyleDefault;
    NSString *reuseIdentifier  = [NSString stringWithFormat:@"cachedCell_%d", indexPath.row];

    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    SimplePluralPropertyData *propertyData = [propertyDataArray objectAtIndex:(NSUInteger)indexPath.row];

    DLog(@"%@", propertyData.propertyName);
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
        valueLabel.textColor        = [UIColor blackColor];
        valueLabel.textAlignment    = UITextAlignmentLeft;
        valueLabel.autoresizingMask = UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth;

        [cell.contentView addSubview:valueLabel];

        UIView *editingView;

        if (propertyData.propertyType == PTString)
            editingView = [self getTextFieldWithKeyboardType:UIKeyboardTypeDefault];

        [editingView setTag:editingViewTag];
        [editingView setAutoresizingMask:UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth];

        [propertyData setEditingView:editingView];
        [propertyData setSubtitleLabel:valueLabel];

        [cell.contentView addSubview:editingView];
    }

    UILabel *titleLabel    = (UILabel*)[cell.contentView viewWithTag:keyLabelTag];
    UILabel *subtitleLabel = (UILabel*)[cell.contentView viewWithTag:valueLabelTag];
    UIView  *editingView   = [cell.contentView viewWithTag:editingViewTag];//propertyData.editingView;

    NSString* subtitle  = nil;
    NSString* cellTitle = nil;

    cell.textLabel.text       = nil;
    cell.detailTextLabel.text = nil;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;

    NSString *key   = propertyData.propertyName;
    NSObject *value = nil;

    value     = [captureObject performSelector:propertyData.propertyGetSelector];
    cellTitle = key;

 /* If our item is a string... */
    if (propertyData.propertyType == PTString)
    {/* If our value is null, */
        if (!value || [value isKindOfClass:[NSNull class]])
        {/* indicate that in the subtitle, */
            subtitle = [NSString stringWithFormat:@"No %@ available", cellTitle];
        }
        else if ([(NSString *)value isEqualToString:@""])
        {/* or if it's empty, say that, */
            subtitle = @"<empty string>";
        }
        else
        {/* and, if it's not null, set the subtitle to our value.*/
            subtitle = (NSString*)value;
            ((UITextField *)editingView).placeholder = propertyData.stringValue = subtitle;
        }
    }

 /* If our item is a number... */
    else if (propertyData.propertyType == PTObjectId)
    {/* If our value is null, */
        if (!value || [value isKindOfClass:[NSNull class]])
        {/* indicate that */
            subtitle = @"Object does not yet have an id";
        }
        else
        {/* and, if it's not null, make it a string, and set the subtitle as that. */
            subtitle = [((NSNumber *)value) stringValue];
        }
    }

    else { DLog(@"??????????? %d", propertyData.propertyType); /* I dunno... Just hopin' it won't happen... */ }

    if (!propertyData.canEdit)
    {
        [editingView setHidden:YES];
        if (isEditing)
            [subtitleLabel setTextColor:[UIColor grayColor]];
        else
            [subtitleLabel setTextColor:[UIColor blackColor]];
    }
    else
    {
        [editingView setHidden:!isEditing];
        [subtitleLabel setHidden:isEditing];
    }

// TODO: Is this needed for editing and stuff?
//    if (textField.text && ![textField.text isEqualToString:@""])
//        subtitleLabel.text = textField.text;
//    else
        subtitleLabel.text = subtitle;

    titleLabel.text    = cellTitle;

//    if (!cellTitle)
//        subtitleLabel.frame = UP_A_LITTLE_HIGHER(subtitleLabel);
//    else
//        subtitleLabel.frame = WHERE_IT_SHOULD_BE(subtitleLabel);

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"");
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    [[SharedData sharedData] resaveCaptureUser];

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
    [[SharedData sharedData] resaveCaptureUser];

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:result
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [myTableView reloadData];
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

