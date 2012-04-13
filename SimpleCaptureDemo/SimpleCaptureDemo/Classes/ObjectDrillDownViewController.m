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

#import <objc/runtime.h>
#import "ObjectDrillDownViewController.h"

//@interface NSObject (PerformSelector)
//- (void *)performSelector:(SEL)selector withValue:(void *)value;
//@end
//
//@implementation NSObject (PerformSelector)
//- (void *)performSelector:(SEL)selector withValue:(void *)value {
//    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
//    [invocation setSelector:selector];
//    [invocation setTarget:self];
//
//    if (value)
//        [invocation setArgument:value atIndex:2];
//
//    [invocation invoke];
//
//    NSUInteger length = [[invocation methodSignature] methodReturnLength];
//
//    // If method is non-void:
//    if (length > 0) {
//        void *buffer = (void *)malloc(length);
//        [invocation getReturnValue:buffer];
//        return buffer;
//    }
//
//    // If method is void:
//    return nil;
//}
//@end

//@interface PropertyUtil : NSObject
//+ (NSDictionary *)classPropsFor:(Class)klass;
//@end

///* Lilli: Originally got this code from orange80's answer on stackoverflow: http://stackoverflow.com/questions/754824/get-an-object-attributes-list-in-objective-c */
//@implementation PropertyUtil
//// ORIGINAL
////static const char * getPropertyType(objc_property_t property) {
//static NSString* getPropertyType(objc_property_t property) {
//    const char *attributes = property_getAttributes(property);
//    printf("attributes=%s\n", attributes);
//    char buffer[1 + strlen(attributes)];
//    strcpy(buffer, attributes);
//    char *state = buffer, *attribute;
//    while ((attribute = strsep(&state, ",")) != NULL) {
//        if (attribute[0] == 'T' && attribute[1] != '@') {
//            /* it's a C primitive type: */
//
//            /*
//                if you want a list of what will be returned for these primitives, search online for
//                "objective-c" "Property Attribute Description Examples"
//                apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
//
//                Lilli: found this: https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
//            */
//
//            // ORIGINAL
//            //return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
//
//            // MY FIRST
//            //return (const char *)[[NSData dataWithBytes:attribute length:strlen(attribute)] bytes];
//
//            return [[[NSString stringWithUTF8String:attribute] substringFromIndex:1] substringToIndex:strlen(attribute) - 1];
//        }
//        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
//            /* it's an ObjC id type: */
//            return @"id";
//        }
//        else if (attribute[0] == 'T' && attribute[1] == '@') {
//            /* it's another ObjC object type: */
//
//            // ORIGINAL
//            //return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
//
//            // MY FIRST
//            //return (const char *)[[NSData dataWithBytes:attribute length:strlen(attribute)] bytes];
//
//            return [[[NSString stringWithUTF8String:attribute] substringFromIndex:3] substringToIndex:strlen(attribute) - 4];
//        }
//    }
//
//    return @"";
//}
//
//+ (NSDictionary *)classPropsFor:(Class)klass
//{
//    if (klass == NULL) {
//        return nil;
//    }
//
//    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
//
//    unsigned int outCount, i;
//    objc_property_t *properties = class_copyPropertyList(klass, &outCount);
//    for (i = 0; i < outCount; i++) {
//        objc_property_t property = properties[i];
//        const char *propName = property_getName(property);
//        if(propName) {
//            // ORIGINAL
//            //const char *propType = getPropertyType(property);
//            //NSString *propertyName = [NSString stringWithUTF8String:propName];
//            //NSString *propertyType = [NSString stringWithUTF8String:propType];
//
//            NSString *propertyName = [NSString stringWithUTF8String:propName];
//            NSString *propertyType = getPropertyType(property);
//            [results setObject:propertyType forKey:propertyName];
//        }
//    }
//    free(properties);
//
//    DLog(@"%@", [results description]);
//    /* returning a copy here to make sure the dictionary is immutable */
//    return [NSDictionary dictionaryWithDictionary:results];
//}
//@end

typedef enum propertyTypes
{
    PTCaptureObject,
    PTSimpleArray,
    PTArray,
    PTString,
    PTNumber,
    PTDate,
    PTDateTime,
    PTBool,
    PTInteger,
    PTPassword,
    PTIpAddress,
    PTUuid,
    PTObjectId,
    PTJsonObject,
    PTUnknown,
} PropertyType;

@interface PropertyData : NSObject
@property          PropertyType propertyType;
@property (strong) NSString    *propertyName;
@property          SEL          propertySetSelector;
@property          SEL          propertyGetSelector;
@property (strong) NSString    *stringValue;
@property (strong) UILabel     *subtitleLabel;
@property (strong) UIView      *editingView;
@property          BOOL         canEdit;
@property          BOOL         canDrillDown;
- (void)printDescription;
@end

@implementation PropertyData
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

typedef enum
{
    DataTypeNone,
    DataTypeObject,
    DataTypeArray,
} DataType;

@interface ObjectDrillDownViewController ()
@property (strong) JRCaptureObject *captureObject;
@property (strong) JRCaptureObject *parentCaptureObject;
@property (strong) NSDictionary    *tableData;
@property (strong) NSString        *tableHeader;
@end

@implementation ObjectDrillDownViewController
@synthesize captureObject;
@synthesize parentCaptureObject;
@synthesize tableHeader;
@synthesize tableData;
@synthesize myTableView;
@synthesize myUpdateButton;
@synthesize myKeyboardToolbar;
@synthesize myPickerView;
//@synthesize myPickerToolbar;
@synthesize myDatePicker;


- (void)printPArrayDescription
{
    for (PropertyData *pd in propertyDataArray)
        [pd printDescription];
}

- (PropertyType)getPropertyTypeFromString:(NSString *)propertyTypeString
{                                                       // TODO: Will we ever need the mutable bit?
    if ([propertyTypeString isEqualToString:@"NSArray"])// || [propertyTypeString isEqualToString:@"NSMutableArray"])
        return PTArray;
    else if ([propertyTypeString isEqualToString:@"JRSimpleArray"])
        return PTSimpleArray;
    else if ([propertyTypeString isEqualToString:@"NSString"])// || [propertyTypeString isEqualToString:@"NSMutableString"])
        return PTString;
    else if ([propertyTypeString isEqualToString:@"NSNumber"])
        return PTNumber;
    else if ([propertyTypeString isEqualToString:@"JRDate"])
        return PTDate;
    else if ([propertyTypeString isEqualToString:@"JRDateTime"])
        return PTDateTime;
    else if ([propertyTypeString isEqualToString:@"JRBoolean"])
        return PTBool;
    else if ([propertyTypeString isEqualToString:@"JRInteger"])
        return PTInteger;
    else if ([propertyTypeString isEqualToString:@"JRPassword"])
        return PTPassword;
    else if ([propertyTypeString isEqualToString:@"JRIpAddress"])
        return PTIpAddress;
    else if ([propertyTypeString isEqualToString:@"JRUuid"])
        return PTUuid;
    else if ([propertyTypeString isEqualToString:@"JRObjectId"])
        return PTObjectId;
    else if ([propertyTypeString isEqualToString:@"JRPassword"])
        return PTPassword;
    else if ([propertyTypeString isEqualToString:@"JRJsonObject"])
        return PTJsonObject;
    else if ([propertyTypeString hasPrefix:@"JR"])
        return PTCaptureObject;

    return PTUnknown;
}

- (NSMutableArray *)createPropertyArrayFromObject:(JRCaptureObject *)object
{
    NSDictionary   *propertyNamesAndTypes = [object objectProperties];//[PropertyUtil classPropsFor:[object class]];
    NSArray        *propertyNames         = [propertyNamesAndTypes allKeys];
    NSMutableArray *propertyArray         = [[NSMutableArray alloc] initWithCapacity:[propertyNames count]];

    for (NSString *propertyName in propertyNames)
    {
        PropertyData *propertyData = [[PropertyData alloc] init];

        propertyData.propertyType = [self getPropertyTypeFromString:[propertyNamesAndTypes objectForKey:propertyName]];
        propertyData.propertyName = propertyName;

        propertyData.propertySetSelector = getSetSelectorFromKey(propertyName);
        propertyData.propertyGetSelector = getGetSelectorFromKey(propertyName);

        if ([propertyName hasSuffix:@"Id"] || [propertyName isEqualToString:@"uuid"] ||
            [propertyName isEqualToString:@"created"] || [propertyName isEqualToString:@"lastUpdated"] ||
            [propertyName hasSuffix:@"Password"] || [propertyName hasSuffix:@"password"])
            propertyData.canEdit = NO;
        else
            propertyData.canEdit = YES;

        if (propertyData.propertyType == PTCaptureObject ||
            propertyData.propertyType == PTArray ||
            propertyData.propertyType == PTSimpleArray)
                propertyData.canDrillDown = YES;

        [propertyArray addObject:propertyData];
    }

    return propertyArray;
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil forObject:(JRCaptureObject*)object
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

//    DLog(@"%@", [tableData description]);
    [self printPArrayDescription];
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

    [myPickerView setFrame:CGRectMake(0, 416, 320, 260)];
    [self.view addSubview:myPickerView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#define EDITING_VIEW_OFFSET 100
#define LEFT_BUTTON_OFFSET  1000
#define RIGHT_BUTTON_OFFSET 2000
#define LEFT_LABEL_OFFSET   3000
#define DATE_PICKER_OFFSET  4000

typedef enum
{
    EBSAddObject,
    EBSEditDeleteObject,
} EditingButtonState;

- (void)setEditingButtonsToState:(EditingButtonState)state withinEditingView:(UIView *)editingView
{
    NSInteger tag = (editingView.tag - EDITING_VIEW_OFFSET);
    UIButton *lButton = (UIButton *) [editingView viewWithTag:(tag + LEFT_BUTTON_OFFSET)];
    UIButton *rButton = (UIButton *) [editingView viewWithTag:(tag + RIGHT_BUTTON_OFFSET)];

    switch (state)
    {
        case EBSAddObject:
            [rButton setTitle:@"Add"
                     forState:UIControlStateNormal];
            [rButton addTarget:self
                        action:@selector(addObjectButtonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
            [lButton setHidden:YES];
            break;
        case EBSEditDeleteObject:
            [rButton setTitle:@"Edit"
                     forState:UIControlStateNormal];
            [rButton addTarget:self
                       action:@selector(editObjectButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
            [lButton setHidden:NO];
            break;
    }
}

- (void)addObjectButtonPressed:(UIButton *)sender
{
    DLog(@"");
    NSUInteger itemIndex = (NSUInteger) (sender.tag - RIGHT_BUTTON_OFFSET);
    PropertyData *currentPropertyData = [propertyDataArray objectAtIndex:itemIndex];

    JRCaptureObject *newCaptureObject = [[getClassFromKey(currentPropertyData.propertyName) alloc] init];

    [captureObject performSelector:currentPropertyData.propertySetSelector
                        withObject:newCaptureObject];

    [self setEditingButtonsToState:EBSEditDeleteObject withinEditingView:sender.superview];
}

- (void)deleteObjectButtonPressed:(UIButton *)sender
{
    NSUInteger itemIndex = (NSUInteger) (sender.tag - EDITING_VIEW_OFFSET);
    PropertyData *currentPropertyData = [propertyDataArray objectAtIndex:itemIndex];

    if ([captureObject respondsToSelector:currentPropertyData.propertySetSelector])
         [captureObject performSelector:currentPropertyData.propertySetSelector
                             withObject:nil];

    [self setEditingButtonsToState:EBSAddObject withinEditingView:sender.superview];
}

- (void)editObjectButtonPressed:(UIButton *)sender
{
    NSUInteger itemIndex = (NSUInteger) (sender.tag - RIGHT_BUTTON_OFFSET);
    PropertyData *currentPropertyData = [propertyDataArray objectAtIndex:itemIndex];

    NSObject *newCaptureObject    = [captureObject performSelector:currentPropertyData.propertyGetSelector];
    JRCaptureObject *parentObject = captureObject;

    UIViewController *drillDown = nil;

//    if (!newCaptureObject || [newCaptureObject isKindOfClass:[NSNull class]])
//        return;

    if (currentPropertyData.propertyType == PTArray || currentPropertyData.propertyType == PTSimpleArray)
    {
        if (!newCaptureObject || [newCaptureObject isKindOfClass:[NSNull class]])
        {
            newCaptureObject = [[NSArray alloc] init];
            [captureObject performSelector:currentPropertyData.propertySetSelector
                                withObject:newCaptureObject];
        }

        drillDown = [[ArrayDrillDownViewController alloc] initWithNibName:@"ArrayDrillDownViewController"
                                                                   bundle:[NSBundle mainBundle]
                                                                forObject:(NSArray *) newCaptureObject
                                                      captureParentObject:parentObject
                                                                   andKey:currentPropertyData.propertyName];
    }
    else /* if (propertyData.propertyType == PTCaptureObject) */
    {
        drillDown = [[ObjectDrillDownViewController alloc] initWithNibName:@"ObjectDrillDownViewController"
                                                                    bundle:[NSBundle mainBundle]
                                                                 forObject:(JRCaptureObject *) newCaptureObject
                                                       captureParentObject:parentObject
                                                                    andKey:currentPropertyData.propertyName];

    }

    [[self navigationController] pushViewController:drillDown animated:YES];
}

- (void)slidePickerUp
{
    [myTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)]];
    [myTableView setScrollEnabled:NO];

    [UIView beginAnimations:@"slidePickerUp" context:nil];
    [myPickerView setFrame:CGRectMake(0, 156, 320, 260)];
    [UIView commitAnimations];
}

- (void)slidePickerDown
{
    [myTableView setTableFooterView:nil];
    [myTableView setScrollEnabled:YES];

    [UIView beginAnimations:@"slidePickerDown" context:nil];
    [myPickerView setFrame:CGRectMake(0, 416, 320, 260)];
    [UIView commitAnimations];
}

//- (void)scrollUpBy:(CGFloat)scrollOffset
//{
//    [myTableView setContentOffset:<#(CGPoint)contentOffset#> animated:<#(BOOL)animated#>];
//    [myTableView setContentOffset:CGPointMake(0, scrollOffset)];
////    [myTableView setContentSize:CGSizeMake(tableWidth, tableHeight + scrollOffset)];
//}
//
//- (void)scrollBack
//{
//    [myTableView setContentOffset:CGPointZero];
//    //[myTableView setContentSize:CGSizeMake(tableWidth, tableHeight)];
//}

- (void)scrollTableViewToRect:(CGRect)rect
{
    [myTableView scrollRectToVisible:rect animated:YES];
}

- (IBAction)hidePickerButtonPressed:(id)sender
{
    [self slidePickerDown];
}

- (IBAction)datePickerChanged:(UIDatePicker *)sender
{
    DLog(@"");
    NSUInteger itemIndex = (NSUInteger) (sender.tag - DATE_PICKER_OFFSET);
    PropertyData *currentPropertyData = [propertyDataArray objectAtIndex:itemIndex];
    UILabel *label = (UILabel *) [currentPropertyData.editingView viewWithTag:(itemIndex + LEFT_LABEL_OFFSET)];

    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    }

    NSDate   *pickerDate = myDatePicker.date;
    NSString *dateString = [dateFormatter stringFromDate:pickerDate];

    [label setText:dateString];

    [captureObject performSelector:currentPropertyData.propertySetSelector withObject:pickerDate];
}

- (void)changeDateButtonPressed:(UIButton *)sender
{
    NSUInteger itemIndex = (NSUInteger) (sender.tag - RIGHT_BUTTON_OFFSET);
    PropertyData *currentPropertyData = [propertyDataArray objectAtIndex:itemIndex];

    NSDate *date = [captureObject performSelector:currentPropertyData.propertyGetSelector];

    if (date && [date isKindOfClass:[NSDate class]])
        myDatePicker.date = date;

    if (currentPropertyData.propertyType == PTDate)
        myDatePicker.datePickerMode = UIDatePickerModeDate;
    else
        myDatePicker.datePickerMode = UIDatePickerModeTime;

    myDatePicker.tag = itemIndex + DATE_PICKER_OFFSET;

    [self scrollTableViewToRect:CGRectMake(0, sender.superview.superview.frame.origin.y - 45,
            (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? 320 : 480,
            (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? 416 : 256)];

    [self slidePickerUp];
}

- (void)switchChanged:(UIButton *)sender
{
    DLog(@"%f %f", sender.frame.size.width, sender.frame.size.height);
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
    PropertyData *currentPropertyData = [propertyDataArray objectAtIndex:itemIndex];

    if ([textField.text isEqualToString:@""])
        textField.text = nil;

    if (![textField.text isEqualToString:currentPropertyData.stringValue])
    {
        if ([captureObject respondsToSelector:currentPropertyData.propertySetSelector])
        {
            switch (currentPropertyData.propertyType)
            {
                case PTInteger:
                case PTNumber:
                {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

                    NSNumber *number = [formatter numberFromString:textField.text];

                    if (!number) // TODO: What if you are trying to delete the number?
                        return;

                    [captureObject performSelector:currentPropertyData.propertySetSelector
                                        withObject:number];
                    break;
                }
                case PTJsonObject:
                {
                    NSObject *jsonVal = [currentPropertyData.stringValue objectFromJSONString];

                    if (!jsonVal) // TODO: What if you are trying to delete the value?
                        return;

                    [captureObject performSelector:currentPropertyData.propertySetSelector
                                        withObject:jsonVal];
                    break;
                }
                default:
                {
                    [captureObject performSelector:currentPropertyData.propertySetSelector
                                        withObject:textField.text];
                    break;
                }
            }

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

    for (PropertyData *data in propertyDataArray)
    {
        if (data.canEdit)
        {
            data.editingView.hidden   = NO;
            data.subtitleLabel.hidden = YES;
        }
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

    for (PropertyData *data in propertyDataArray)
    {
        if (data.canEdit)// || data.canDrillDownToEdit)
        {
            data.editingView.hidden   = YES;
            data.subtitleLabel.hidden = NO;
        }
    }

    isEditing = NO;

    [firstResponder resignFirstResponder], firstResponder = nil;
    [self slidePickerDown];
    [myTableView reloadData];
}

- (IBAction)updateButtonPressed:(id)sender
{
    DLog(@"");
    [captureObject updateObjectOnCaptureForDelegate:self withContext:nil];
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

- (UIView *)getLeftLabelWithTag:(NSInteger)tag
{
    CGRect frame = CGRectMake(0, 0, (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? 125 : 205, 22);

    UILabel *leftLabel = [[UILabel alloc] initWithFrame:frame];
    leftLabel.frame  = frame;

    leftLabel.backgroundColor  = [UIColor clearColor];
    leftLabel.font             = [UIFont boldSystemFontOfSize:16.0];
    leftLabel.textColor        = [UIColor blackColor];
    leftLabel.textAlignment    = UITextAlignmentLeft;

    [leftLabel setHidden:NO];
    [leftLabel setTag:tag + LEFT_LABEL_OFFSET];

    [leftLabel setAutoresizingMask:UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth];

    return leftLabel;
}

- (UIView *)getButtonBox
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 23,
            (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? 270 : 430, 22)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

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

- (UIView *)getBooleanSwitcher
{
    UISwitch *switcher = [[UISwitch alloc] initWithFrame:CGRectMake(221, 12, 100, 27)];
    [switcher addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    return switcher;
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

    PropertyData *propertyData = [propertyDataArray objectAtIndex:(NSUInteger)indexPath.row];

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

        switch (propertyData.propertyType)
        {
            case PTInteger:
            case PTNumber:
            case PTIpAddress:
                editingView = [self getTextFieldWithKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
                break;
            case PTString:
            case PTJsonObject:
                editingView = [self getTextFieldWithKeyboardType:UIKeyboardTypeDefault];
                break;
            case PTCaptureObject:
                editingView = [self getButtonBox];
                [editingView addSubview:[self getLeftButtonWithTitle:@"Delete"
                                                                 tag:indexPath.row
                                                         andSelector:@selector(deleteObjectButtonPressed:)]];
                [editingView addSubview:[self getRightButtonWithTitle:@"Edit"
                                                                  tag:indexPath.row
                                                          andSelector:@selector(editObjectButtonPressed:)]];
                break;
            case PTBool:
//                frame.size.width -= 65;
//                keyLabel.frame = frame;
//                keyLabel.backgroundColor = [UIColor redColor];
                editingView = [self getBooleanSwitcher];
                break;
            case PTDate:
            case PTDateTime:
                editingView = [self getButtonBox];
                [editingView addSubview:[self getLeftLabelWithTag:indexPath.row]];
                [editingView addSubview:[self getRightButtonWithTitle:@"Change"
                                                                  tag:indexPath.row
                                                          andSelector:@selector(changeDateButtonPressed:)]];
                break;
            case PTArray:
            case PTSimpleArray:
                editingView = [self getButtonBox];
                [editingView addSubview:[self getRightButtonWithTitle:@"Edit"
                                                                  tag:indexPath.row
                                                          andSelector:@selector(editObjectButtonPressed:)]];
                break;
        }

        [editingView setTag:editingViewTag];
        [editingView setAutoresizingMask:UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth];

        [propertyData setEditingView:editingView];
        [propertyData setSubtitleLabel:valueLabel];

//        [editingView setHidden:!isEditing];
//        [valueLabel setHidden:isEditing];

        [cell addSubview:editingView];
    }

    UILabel *titleLabel    = (UILabel*)[cell.contentView viewWithTag:keyLabelTag];
    UILabel *subtitleLabel = (UILabel*)[cell.contentView viewWithTag:valueLabelTag];
    UIView  *editingView   = propertyData.editingView;//[cell.contentView viewWithTag:editingViewTag];

    NSString* subtitle  = nil;
    NSString* cellTitle = nil;

    cell.textLabel.text       = nil;
    cell.detailTextLabel.text = nil;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;

    NSString *key   = propertyData.propertyName;
    NSObject *value = nil;
    int *primValue  = 0;

//    if (propertyData.propertyType == PTInteger || propertyData.propertyType == PTBool)
//        primValue = [captureObject performSelector:propertyData.propertyGetSelector withValue:nil];
//    else
        value = [captureObject performSelector:propertyData.propertyGetSelector];

    cellTitle = key;

 /* If our item is an array... */
    if (propertyData.propertyType == PTArray || propertyData.propertyType == PTSimpleArray)
    {/* If our object is null, */
        if (!value || [value isKindOfClass:[NSNull class]])
        {/* indicate that in the subtitle, */
            subtitle = [NSString stringWithFormat:@"Empty array of %@", cellTitle];
        }
        else
        {/* If our array has 1 or more items, add the accessory view and set the subtitle, */
            if ([((NSArray*)value) count])
            {
                if (!isEditing)
                {
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                }

             /* (Lets not say, "1 items". That's just silly.) */
                if ([((NSArray*)value) count] == 1)
                    subtitle = @"1 item";
                else
                    subtitle = [NSString stringWithFormat:@"%d %@ items", [((NSArray*)value) count], cellTitle];
            }
            else
            {/* and, if it's empty, let's indicate that as well. */
               subtitle = [NSString stringWithFormat:@"Empty array of %@", cellTitle];
            }
        }
    }

 /* If our item is a dictionary... */
    else if (propertyData.propertyType == PTCaptureObject)
    {/* If our object is null, */
       if (!value || [value isKindOfClass:[NSNull class]])
       {/* indicate that in the subtitle, */
           subtitle = [NSString stringWithFormat:@"No %@ object added", cellTitle];
           subtitleLabel.textColor = [UIColor blackColor];

           [self setEditingButtonsToState:EBSAddObject withinEditingView:editingView];
       }
       else
       {/* and, if it's not null, let's indicate that as well. */
           subtitle = [[(JRCaptureObject *)value toDictionary] JSONString];
           subtitleLabel.textColor = [UIColor grayColor];

           if (!isEditing)
           {
               [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
               [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];
           }

           [self setEditingButtonsToState:EBSEditDeleteObject withinEditingView:editingView];
       }
    }

 /* If our item is a string... */
    else if (propertyData.propertyType == PTString || propertyData.propertyType == PTIpAddress)
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
    else if (propertyData.propertyType == PTNumber || propertyData.propertyType == PTInteger)
    {/* If our value is null, */
        if (!value || [value isKindOfClass:[NSNull class]])
        {/* indicate that */
            subtitle = [NSString stringWithFormat:@"No %@ available", cellTitle];
        }
        else
        {/* and, if it's not null, make it a string, and set the subtitle as that. */
            subtitle = [((NSNumber *)value) stringValue];
            ((UITextField *)editingView).placeholder = propertyData.stringValue = subtitle;
        }
    }

// /* If our item is an integer... */
//    else if (propertyData.propertyType == PTInteger)
//    {
//        int intValue = *primValue;
//        subtitle = [NSString stringWithFormat:@"%d", intValue];
//        ((UITextField *)editingView).placeholder = propertyData.stringValue = subtitle;
//    }

 /* If our item is an bool... */
    else if (propertyData.propertyType == PTBool)
    {/* If our value is null, */
        if (!value || [value isKindOfClass:[NSNull class]])
        {/* just pretend that it's 0 */
            subtitle = [NSString stringWithFormat:@"No %@ available", cellTitle];
        }
        else
        {/* and, if it's not null, find out if it's true or false, and set the subtitle as that. */
            BOOL boolValue = [(NSNumber *)value boolValue];
            if (boolValue)
            {
                subtitle = @"TRUE";
                ((UISwitch *)editingView).on = YES;
            }
            else
            {
                subtitle = @"FALSE";
                ((UISwitch *)editingView).on = NO;
            }
        }
    }

 /* If our item is a date... */
    else if (propertyData.propertyType == PTDate)
    {/* If our value is null, */
        if (!value || [value isKindOfClass:[NSNull class]])
        {/* indicate that */
            subtitle = @"No date set";
        }
        else
        {/* and, if it's not null, it should be a string, so set the subtitle as that. */
            subtitle = [(JRDate*)value stringFromISO8601Date];

            UILabel *label = (UILabel *) [editingView viewWithTag:indexPath.row + LEFT_LABEL_OFFSET];
            label.text = propertyData.stringValue = subtitle;
        }
    }

 /* If our item is a dateTime... */
    else if (propertyData.propertyType == PTDateTime)
    {/* If our value is null, */
        if (!value || [value isKindOfClass:[NSNull class]])
        {/* indicate that */
            subtitle = @"No date/time set";
        }
        else
        {/* and, if it's not null, it should be a string, so set the subtitle as that. */
            subtitle = [(JRDate*)value stringFromISO8601DateTime];

            UILabel *label = (UILabel *) [editingView viewWithTag:indexPath.row + LEFT_LABEL_OFFSET];
            label.text = propertyData.stringValue = subtitle;
        }
    }

 /* If our item is a date... */
    else if (propertyData.propertyType == PTJsonObject)
    {/* If our value is null, */
        if (!value || [value isKindOfClass:[NSNull class]])
        {/* indicate that */
            subtitle = @"No data set";
        }
        else
        {/* and, if it's not null, it should be a string, so set the subtitle as that. */
            if ([value isKindOfClass:[NSString class]])
                subtitle = (NSString *)value;
            else if ([value isKindOfClass:[NSDictionary class]])
                subtitle = [(NSDictionary *)value JSONString];
            else ; // TODO: ???

            ((UITextField *)editingView).placeholder = propertyData.stringValue = subtitle;
        }
    }

    else { DLog(@"???????????"); /* I dunno... Just hopin' it won't happen... */ }

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

    PropertyData *propertyData = [propertyDataArray objectAtIndex:(NSUInteger) indexPath.row];

    if (!propertyData.canDrillDown)
        return;

    NSString *key    = propertyData.propertyName;
    NSObject *value  = [tableData objectForKey:key];
    NSObject *subObj = [captureObject performSelector:propertyData.propertyGetSelector];

    UIViewController *drillDown = nil;

    if ([value isKindOfClass:[NSNull class]])
        return;

    if (propertyData.propertyType == PTArray || propertyData.propertyType == PTSimpleArray)
    {
      /* If our value is an *empty* array, don't drill down. */
         if (![(NSArray *)value count])
             return;

         drillDown = [[ArrayDrillDownViewController alloc] initWithNibName:@"ArrayDrillDownViewController"
                                                                    bundle:[NSBundle mainBundle]
                                                                 forObject:(NSArray *) subObj
                                                       captureParentObject:captureObject
                                                                    andKey:key];

    }
    else /* if (propertyData.propertyType == PTCaptureObject) */
    {
         drillDown = [[ObjectDrillDownViewController alloc] initWithNibName:@"ObjectDrillDownViewController"
                                                                     bundle:[NSBundle mainBundle]
                                                                  forObject:(JRCaptureObject *) subObj
                                                        captureParentObject:captureObject
                                                                     andKey:key];

    }

    [[self navigationController] pushViewController:drillDown animated:YES];
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

