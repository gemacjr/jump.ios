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

@interface NSObject (PerformSelector)
- (void *)performSelector:(SEL)selector withValue:(void *)value;
@end

@implementation NSObject (PerformSelector)
- (void *)performSelector:(SEL)selector withValue:(void *)value {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:self];

    if (value)
        [invocation setArgument:value atIndex:2];

    [invocation invoke];

    NSUInteger length = [[invocation methodSignature] methodReturnLength];

    // If method is non-void:
    if (length > 0) {
        void *buffer = (void *)malloc(length);
        [invocation getReturnValue:buffer];
        return buffer;
    }

    // If method is void:
    return NULL;
}
@end

@interface PropertyUtil : NSObject
+ (NSDictionary *)classPropsFor:(Class)klass;
@end

/* Lilli: Originally got this code from orange80's answer on stackoverflow: http://stackoverflow.com/questions/754824/get-an-object-attributes-list-in-objective-c */
@implementation PropertyUtil
// ORIGINAL
//static const char * getPropertyType(objc_property_t property) {
static NSString* getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            /* it's a C primitive type: */

            /*
                if you want a list of what will be returned for these primitives, search online for
                "objective-c" "Property Attribute Description Examples"
                apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.

                Lilli: found this: https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
            */

            // ORIGINAL
            //return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];

            // MY FIRST
            //return (const char *)[[NSData dataWithBytes:attribute length:strlen(attribute)] bytes];

            return [[[NSString stringWithUTF8String:attribute] substringFromIndex:1] substringToIndex:strlen(attribute) - 1];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            /* it's an ObjC id type: */
            return @"id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            /* it's another ObjC object type: */

            // ORIGINAL
            //return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];

            // MY FIRST
            //return (const char *)[[NSData dataWithBytes:attribute length:strlen(attribute)] bytes];

            return [[[NSString stringWithUTF8String:attribute] substringFromIndex:3] substringToIndex:strlen(attribute) - 4];
        }
    }

    return @"";
}

+ (NSDictionary *)classPropsFor:(Class)klass
{
    if (klass == NULL) {
        return nil;
    }

    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];

    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(klass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            // ORIGINAL
            //const char *propType = getPropertyType(property);
            //NSString *propertyName = [NSString stringWithUTF8String:propName];
            //NSString *propertyType = [NSString stringWithUTF8String:propType];

            NSString *propertyName = [NSString stringWithUTF8String:propName];
            NSString *propertyType = getPropertyType(property);
            [results setObject:propertyType forKey:propertyName];
        }
    }
    free(properties);

    DLog(@"%@", [results description]);
    /* returning a copy here to make sure the dictionary is immutable */
    return [NSDictionary dictionaryWithDictionary:results];
}
@end

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
@property          BOOL         wasChanged;
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
@synthesize wasChanged;
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
@synthesize currentlyEditingData;

- (PropertyType)getPropertyTypeFromString:(NSString *)propertyTypeString
{
    if ([propertyTypeString hasPrefix:@"JR"])
        return PTCaptureObject;                              // TODO: Will we ever need the mutable bit?
    else if ([propertyTypeString isEqualToString:@"NSArray"])// || [propertyTypeString isEqualToString:@"NSMutableArray"])
        return PTArray;
    else if ([propertyTypeString isEqualToString:@"NSString"])// || [propertyTypeString isEqualToString:@"NSMutableArray"])
        return PTString;
    else if ([propertyTypeString isEqualToString:@"NSNumber"])
        return PTNumber;
    else if ([propertyTypeString isEqualToString:@"NSDate"])
        return PTDate;
    else if ([propertyTypeString isEqualToString:@"NSObject"])
        return PTJsonObject;
    else if ([propertyTypeString isEqualToString:@"i"])
        return PTInteger;
    else if ([propertyTypeString isEqualToString:@"c"])
        return PTBool; // TODO: Seems as if BOOLs will return 'c'; should verify this

    return PTUnknown;
}

- (NSMutableArray *)createPropertyArrayFromObject:(JRCaptureObject *)object
{
    NSDictionary   *propertyNamesAndTypes = [PropertyUtil classPropsFor:[object class]];
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

        if (propertyData.propertyType == PTCaptureObject || propertyData.propertyType == PTArray)
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
        //self.dataCount = [[tableData allKeys] count];

        self.tableHeader = key;
        propertyDataArray = [self createPropertyArrayFromObject:object];
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
    NSUInteger itemIndex = (NSUInteger) (sender.tag - 2000);
    PropertyData *currentPropertyData = [propertyDataArray objectAtIndex:itemIndex];

    JRCaptureObject *newCaptureObject = [[getClassFromKey(currentPropertyData.propertyName) alloc] init];

    [captureObject performSelector:currentPropertyData.propertySetSelector
                        withObject:newCaptureObject];

    [sender setTitle:@"Edit"
            forState:UIControlStateNormal];
    [sender addTarget:self
               action:@selector(editObjectButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
}

- (void)deleteObjectButtonPressed:(UIButton *)sender
{

}

- (void)editObjectButtonPressed:(UIButton *)sender
{
    NSUInteger itemIndex = (NSUInteger) (sender.tag - 2000);
    PropertyData *currentPropertyData = [propertyDataArray objectAtIndex:itemIndex];

    JRCaptureObject *newCaptureObject = [captureObject performSelector:currentPropertyData.propertyGetSelector];
    JRCaptureObject *parentObject = captureObject;

    ObjectDrillDownViewController *drillDown =
                [[ObjectDrillDownViewController alloc] initWithNibName:@"ObjectDrillDownViewController"
                                                                bundle:[NSBundle mainBundle]
                                                             forObject:newCaptureObject
                                                   captureParentObject:parentObject
                                                                andKey:currentPropertyData.propertyName];

    [[self navigationController] pushViewController:drillDown animated:YES];
}

- (void)changeDataButtonPressed:(UIButton *)sender
{

}

- (void)switchChanged:(UIButton *)sender
{

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    firstResponder = textField;

    NSUInteger itemIndex = (NSUInteger) (textField.tag - 100);
    currentlyEditingData = [propertyDataArray objectAtIndex:itemIndex];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSUInteger itemIndex = (NSUInteger) (textField.tag - 100);
    PropertyData *currentPropertyData = [propertyDataArray objectAtIndex:itemIndex];

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
    [leftButton setTag:tag + 1000];

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
    [rightButton setTag:tag + 2000];

    [rightButton addTarget:self
                    action:selector
          forControlEvents:UIControlEventTouchUpInside];

    [rightButton setAutoresizingMask:UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth];

    return rightButton;
}

- (UIView *)getTextField
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 23, (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? 280 : 440, 22)];

    textField.backgroundColor = [UIColor clearColor];
    textField.font            = [UIFont systemFontOfSize:14.0];
    textField.textColor       = [UIColor blackColor];
    textField.textAlignment   = UITextAlignmentLeft;
    textField.hidden          = YES;
    textField.borderStyle     = UITextBorderStyleLine;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate        = self;

    [textField setAutoresizingMask:UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth];

    return textField;
}

- (UIView *)getButtonBox
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 23, (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? 270 : 430, 22)];

    view.backgroundColor = [UIColor clearColor];

    return view;
}

- (UIView *)getBooleanSwitcher
{
    UISwitch *switcher = [[UISwitch alloc] initWithFrame:CGRectMake(200, 23, 100, 22)];
    return switcher;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSInteger keyLabelTag    = 1;
    static NSInteger valueLabelTag  = 2;
           NSInteger editingViewTag = 100 + indexPath.row;

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
            case PTString:
            case PTJsonObject:
                editingView = [self getTextField];
                break;
            case PTCaptureObject:
                editingView = [self getButtonBox];
                [editingView addSubview:[self getLeftButtonWithTitle:@"Delete"
                                                                 tag:editingViewTag
                                                         andSelector:@selector(addObjectButtonPressed:)]];
                [editingView addSubview:[self getRightButtonWithTitle:@"Add"
                                                                  tag:editingViewTag
                                                          andSelector:@selector(addObjectButtonPressed:)]];
                break;
            case PTBool:
                editingView = [self getBooleanSwitcher];
                break;
            case PTDate:
                editingView = [self getButtonBox];
                [editingView addSubview:[self getRightButtonWithTitle:@"Change"
                                                                  tag:editingViewTag
                                                          andSelector:@selector(addObjectButtonPressed:)]];
                break;
            case PTArray:
                editingView = [self getButtonBox];
                [editingView addSubview:[self getRightButtonWithTitle:@"Edit"
                                                                  tag:editingViewTag
                                                          andSelector:@selector(addObjectButtonPressed:)]];
                break;

        }

        [editingView setTag:editingViewTag];
        [editingView setHidden:YES];
        [editingView setAutoresizingMask:UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth];

        [propertyData setEditingView:editingView];
        [propertyData setSubtitleLabel:valueLabel];
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

    NSString *key   = propertyData.propertyName;
    NSObject *value = nil;
    int *primValue  = 0;

    if (propertyData.propertyType == PTInteger || propertyData.propertyType == PTBool)
        primValue = [captureObject performSelector:propertyData.propertyGetSelector withValue:nil];
    else
        value = [captureObject performSelector:propertyData.propertyGetSelector];

    cellTitle = key;

 /* If our item is an array... */
    if (propertyData.propertyType == PTArray)
    {/* If our object is null, */
        if (!value || [value isKindOfClass:[NSNull class]])
        {/* indicate that in the subtitle, */
            subtitle = [NSString stringWithFormat:@"Empty array of %@", cellTitle];
        }
        else
        {/* If our array has 1 or more items, add the accessory view and set the subtitle, */
            if ([((NSArray*)value) count])
            {
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];

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
       }
       else
       {/* and, if it's not null, let's indicate that as well. */
           subtitle = [[(JRCaptureObject *)value toDictionary] JSONString];
           subtitleLabel.textColor = [UIColor grayColor];

           [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
           [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];
       }
    }

 /* If our item is a string... */
    else if (propertyData.propertyType == PTString)
    {/* If our value is null, */
        if (!value || [value isKindOfClass:[NSNull class]])
        {/* indicate that in the subtitle, */
            subtitle = [NSString stringWithFormat:@"No %@ available", cellTitle];
        }
        else
        {/* and, if it's not null, set the subtitle to our value.*/
            subtitle = (NSString*)value;
            ((UITextField *)editingView).placeholder = propertyData.stringValue = subtitle;
        }
    }

 /* If our item is a number... */
    else if (propertyData.propertyType == PTNumber)// || propertyData.propertyType == PTInteger)
    {/* If our value is null, */
        if (!value || [value isKindOfClass:[NSNull class]])
        {/* just pretend that it's 0 */
            subtitle = @"0";
        }
        else
        {/* and, if it's not null, make it a string, and set the subtitle as that. */
            subtitle = [((NSNumber *)value) stringValue];
            ((UITextField *)editingView).placeholder = propertyData.stringValue = subtitle;
        }
    }

 /* If our item is an bool... */
    else if (propertyData.propertyType == PTInteger)
    {
        int intValue = *primValue;
        subtitle = [NSString stringWithFormat:@"%d", intValue];
    }

 /* If our item is an bool... */
    else if (propertyData.propertyType == PTBool)
    {
        int boolValue = *primValue;
        if (boolValue)//([(NSNumber *)value boolValue])
            subtitle = @"TRUE";
        else
            subtitle = @"FALSE";
    }

 /* If our item is a date... */
    else if (propertyData.propertyType == PTDate)
    {/* If our value is null, */
        if (!value || [value isKindOfClass:[NSNull class]])
        {/* indicate that */
            subtitle = @"No data set";
        }
        else
        {/* and, if it's not null, it should be a string, so set the subtitle as that. */
            subtitle = [(NSDate*)value stringFromISO8601Date];

            if (!subtitle)
                subtitle = [(NSDate *) value stringFromISO8601DateTime];

            ((UITextField *)editingView).placeholder = propertyData.stringValue = subtitle;
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

// TODO: Is this needed for editing and stuff?
//    if (textField.text && ![textField.text isEqualToString:@""])
//        subtitleLabel.text = textField.text;
//    else
        subtitleLabel.text = subtitle;

    titleLabel.text    = cellTitle;

//    data.subtitleLabel      = subtitleLabel;
//    data.editValueTextField = textField;
//    data.addMoreButton      = button;
//    data.propertyKey        = key;

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

    if (propertyData.propertyType == PTArray)
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

