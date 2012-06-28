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


#import <objc/runtime.h>
#import "UserDrillDownViewController.h"
#import "JRCaptureObject+Internal.h"


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


@interface xPropertyUtil : NSObject
+ (NSDictionary *)classPropsFor:(Class)klass;
@end

@implementation xPropertyUtil
static const char * getPropertyType(objc_property_t property) {
//static NSString* getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
                if you want a list of what will be returned for these primitives, search online for
                "objective-c" "Property Attribute Description Examples"
                apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
            */

//            char propType = attribute[1];
//            printf("%s", propType);
//
//            if (attribute[1] == 'i')
//                return "NSInteger";
//            else if (attribute[1] == 'b')
//                return "BOOL";
//            else
//                return "NO IDEA";

            return (const char *)[[NSData dataWithBytes:attribute length:strlen(attribute)] bytes];
//            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
//            return (const char *)[[NSData dataWithBytes:(attribute) length:strlen(attribute) - 1] bytes];
            //[[NSString stringWithCharacters:attribute length:1] substringFromIndex:1];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            return (const char *)[[NSData dataWithBytes:attribute length:strlen(attribute)] bytes];
//            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
//            /return (const char *)[[NSData dataWithBytes:(attribute) length:strlen(attribute) - 4] bytes];
//            return "Something else";
        }
    }
    return "";
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
            const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            NSString *propertyType = [NSString stringWithUTF8String:propType];
            [results setObject:propertyType forKey:propertyName];
        }
    }
    free(properties);

    // returning a copy here to make sure the dictionary is immutable
    return [NSDictionary dictionaryWithDictionary:results];
}
@end


@interface NSDictionary (OrderedKeys)
- (NSArray*)allKeysOrdered;
@end

@implementation NSDictionary (OrderedKeys)
- (NSArray*)allKeysOrdered
{
    NSArray *allKeys = [self allKeys];
    return [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}
@end

typedef enum propertyTypes
{
    PTString,
    PTDate,
    PTBool,
    PTNumber,
    PTInteger,
    PTArray,
    PTObject,
} PropertyType;

@interface EntityData : NSObject
@property (strong) UITextField *editValueTextField;
@property (strong) UILabel     *subtitleLabel;
@property (strong) UIButton    *addMoreButton;
@property          PropertyType propertyType;
@property (strong) NSString    *propertyKey;
@property (strong) NSString    *propertyValue;
@property          BOOL         canEdit;
@property          BOOL         canDrillDownToEdit;
@property          BOOL         wasChanged;
@end

@implementation EntityData
@synthesize editValueTextField;
@synthesize subtitleLabel;
@synthesize addMoreButton;
@synthesize propertyType;
@synthesize propertyKey;
@synthesize propertyValue;
@synthesize canEdit;
@synthesize canDrillDownToEdit;
@synthesize wasChanged;
@end

SEL xselectorFromKey(NSString *key)
{
    if (!key || [key length] < 1)
        return nil;

    return NSSelectorFromString([NSString stringWithFormat:@"set%@:",
                  [key stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                               withString:[[key substringToIndex:1] capitalizedString]]]);
}

Class xclassNameFromKey(NSString *key)
{
    if (!key || [key length] < 1)
        return nil;

    return NSClassFromString([NSString stringWithFormat:@"JR%@",
                  [key stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                               withString:[[key substringToIndex:1] capitalizedString]]]);
}

//SEL toDictionarySelector(NSString *objectName)
//{
//    if (!objectName || [objectName length] < 1)
//        return nil;
//
//    return NSSelectorFromString([NSString stringWithFormat:@"dictionaryFrom%@Object",
//                  [objectName stringByReplacingCharactersInRange:NSMakeRange(0,1)
//                                                      withString:[[objectName substringToIndex:1] capitalizedString]]]);
//}

typedef enum
{
    DataTypeNone,
    DataTypeObject,
    DataTypeArray,
} DataType;

@interface UserDrillDownViewController ()
@property          DataType         dataType;
@property          NSUInteger       dataCount;
@property (strong) JRCaptureObject *captureObject;
@property (strong) JRCaptureObject *parentCaptureObject;
@property (strong) NSObject *tableViewData;
@property (strong) NSString *tableViewHeader;
@property (strong) EntityData *currentlyEditingData;
@end

@implementation UserDrillDownViewController
@synthesize dataType;
@synthesize dataCount;
@synthesize captureObject;
@synthesize parentCaptureObject;
@synthesize tableViewHeader;
@synthesize tableViewData;
@synthesize myTableView;
@synthesize myUpdateButton;
@synthesize currentlyEditingData;


- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil forCaptureObject:(JRCaptureObject*)object
  captureParentObject:(JRCaptureObject*)parentObject andKey:(NSString*)key
{
    DLog(@"object: %@, parent: %@, key: %@", [captureObject description], [parentObject description], key);
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        self.captureObject       = object;
        self.parentCaptureObject = parentObject;

        if ([object isKindOfClass:[NSArray class]])
        {
            self.dataType = DataTypeArray;
            self.tableViewData = object;
            self.dataCount = [(NSArray *)tableViewData count];
        }
        else if ([NSStringFromClass([object superclass]) isEqualToString:@"JRCaptureObject"])
        {
            self.dataType = DataTypeObject;
            self.tableViewData = [object toDictionary];
            self.dataCount = [[(NSDictionary *)tableViewData allKeys] count];
        }
        else
        {
            self.dataType = DataTypeNone;
            self.tableViewData = nil;
            self.dataCount = 0;
        }

        self.tableViewHeader = key;
        propertyArray = [NSMutableArray arrayWithCapacity:dataCount];
    }

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

    for (EntityData *data in propertyArray)
    {
        if (data.canEdit || data.canDrillDownToEdit)
        {
            if (data.canDrillDownToEdit)
                data.addMoreButton.hidden = NO;
            else
                data.editValueTextField.hidden = NO;

            data.subtitleLabel.hidden = YES;
            //data.textField.placeholder = data.label.text;
        }
    }

    //myUpdateButton.enabled = NO;
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

    for (EntityData *data in propertyArray)
    {
        if (data.canEdit || data.canDrillDownToEdit)
        {
            if (data.canDrillDownToEdit)
                data.addMoreButton.hidden = YES;
            else
                data.editValueTextField.hidden = YES;

            data.subtitleLabel.hidden = NO;

//            if (data.textField.text && ![data.editValueTextField.text isEqualToString:@""])
//                data.label.text = data.textField.placeholder;
        }
    }

    //myUpdateButton.enabled = NO;
    isEditing = NO;

    [firstResponder resignFirstResponder], firstResponder = nil;
    [myTableView reloadData];
}

- (IBAction)updateButtonPressed:(id)sender
{
    DLog(@"");
//    DLog(@"%@", [[captureObject dictionaryFromObject] description]);

//    parentCaptureObject.accessToken = [[SharedData sharedData] accessToken];
//    captureObject.accessToken = [[SharedData sharedData] accessToken];

//    if (parentCaptureObject)
//        [parentCaptureObject updateObjectOnCaptureForDelegate:self withContext:nil];
//    else
        [captureObject updateOnCaptureForDelegate:self context:nil];
}

- (void)updateCaptureEntity:(JRCaptureObject *)entity didFailWithResult:(NSString *)result
{
    DLog(@"");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:result
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)updateCaptureEntity:(JRCaptureObject *)entity didSucceedWithResult:(NSString *)result
{
    DLog(@"");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:result
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}


- (void)addMoreButtonPressed:(UIButton *)sender
{
    DLog(@"");
    NSUInteger itemIndex = (NSUInteger) (sender.tag - 200);
    currentlyEditingData = [propertyArray objectAtIndex:itemIndex];

    NSObject *propertyWithAddButton        =
                [captureObject performSelector:NSSelectorFromString(currentlyEditingData.propertyKey)];
    JRCaptureObject *newPropertySubObject  =
                [[xclassNameFromKey(currentlyEditingData.propertyKey) alloc] init];
    NSDictionary *newPropertySubProperties =
                [xPropertyUtil classPropsFor:xclassNameFromKey(currentlyEditingData.propertyKey)];

    for (NSString *propertyString in [newPropertySubProperties allKeys])
    {
        DLog(@"name: %@ type: %@", propertyString, [newPropertySubProperties objectForKey:propertyString]);

        // TODO: Check for all property types
        if ([(NSString*)[newPropertySubProperties objectForKey:propertyString] isEqualToString:@"T@\"NSString\""])
            [newPropertySubObject performSelector:xselectorFromKey(propertyString) withObject:@"xxx"];
    }

    DLog(@"%@", [[newPropertySubObject toDictionary] description]);

    JRCaptureObject *newParentObject;
    if ([propertyWithAddButton isKindOfClass:[NSArray class]])
    {
        newParentObject = captureObject;
        [captureObject performSelector:xselectorFromKey(currentlyEditingData.propertyKey)
                                  withObject:[NSArray arrayWithObject:newPropertySubObject]];
    }
    else if (dataType == DataTypeObject)
    {
        newParentObject = captureObject;
        [captureObject performSelector:xselectorFromKey(currentlyEditingData.propertyKey)
                            withObject:newPropertySubObject];
    }

    UserDrillDownViewController *drillDown =
                [[UserDrillDownViewController alloc] initWithNibName:@"UserDrillDownViewController"
                                                              bundle:[NSBundle mainBundle]
                                                    forCaptureObject:newPropertySubObject
                                                 captureParentObject:newParentObject
                                                              andKey:currentlyEditingData.propertyKey];

    [[self navigationController] pushViewController:drillDown animated:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    firstResponder = textField;

    NSUInteger itemIndex = (NSUInteger) (textField.tag - 100);
    currentlyEditingData = [propertyArray objectAtIndex:itemIndex];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSUInteger itemIndex = (NSUInteger) (textField.tag - 100);
    currentlyEditingData = [propertyArray objectAtIndex:itemIndex];

    if (![textField.text isEqualToString:currentlyEditingData.propertyValue])
    {
        currentlyEditingData.propertyValue = textField.text;

        SEL setKeySelector = xselectorFromKey(currentlyEditingData.propertyKey);
        if ([captureObject respondsToSelector:setKeySelector])
        {
            // TODO: Check for all property types
            [captureObject performSelector:setKeySelector withObject:currentlyEditingData.propertyValue];
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
    return tableViewHeader;
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
    if (tableViewHeader)
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
//    if ([tableViewData isKindOfClass:[NSArray class]])
//        return [((NSArray*)tableViewData) count];
//    else if ([tableViewData isKindOfClass:[NSDictionary class]])
//        return [[((NSDictionary*)tableViewData) allKeysOrdered] count];
//    else
//        return 0;
    return dataCount;
}

#define HIGHER_SUBTITLE 10
#define NORMAL_SUBTITLE 21
#define UP_A_LITTLE_HIGHER(r) CGRectMake(r.frame.origin.x, HIGHER_SUBTITLE, r.frame.size.width, r.frame.size.height)
#define WHERE_IT_SHOULD_BE(r) CGRectMake(r.frame.origin.x, NORMAL_SUBTITLE, r.frame.size.width, r.frame.size.height)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"");
    static NSInteger keyLabelTag   = 1;
    static NSInteger valueLabelTag = 2;
    NSInteger textFieldTag         = 100 + indexPath.row;
    NSInteger addMoreButtonTag     = 200 + indexPath.row;

    UITableViewCellStyle style = UITableViewCellStyleDefault;
    NSString *reuseIdentifier  = [NSString stringWithFormat:@"cachedCell_%d", indexPath.row];

    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];

        CGRect frame;
        frame.origin.x    = 10;
        frame.origin.y    = 5;
        frame.size.height = 18;
        frame.size.width  = (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? 280 : 440;;

        UILabel *keyLabel = [[UILabel alloc] initWithFrame:frame];
        keyLabel.tag      = keyLabelTag;

        keyLabel.backgroundColor = [UIColor clearColor];
        keyLabel.font            = [UIFont systemFontOfSize:13.0];
        keyLabel.textColor       = [UIColor grayColor];
        keyLabel.textAlignment   = UITextAlignmentLeft;

        [keyLabel setAutoresizingMask:UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth];

        [cell.contentView addSubview:keyLabel];

        frame.origin.y     += 16;
        frame.size.height  += 8;
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:frame];
        valueLabel.tag      = valueLabelTag;

        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.font            = [UIFont boldSystemFontOfSize:16.0];
        valueLabel.textColor       = [UIColor blackColor];
        valueLabel.textAlignment   = UITextAlignmentLeft;

        [valueLabel setAutoresizingMask:UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth];

        [cell.contentView addSubview:valueLabel];

        frame.origin.y     += 2;
        frame.size.height  -= 4;

        UIButton *addMoreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addMoreButton.frame     = frame;
        addMoreButton.tag       = addMoreButtonTag;

        [addMoreButton setTitle:@"Add" forState:UIControlStateNormal];
        [addMoreButton setTitleColor:[UIColor blackColor]
                                    forState:UIControlStateNormal];
        [addMoreButton setTitleShadowColor:[UIColor grayColor]
                                          forState:UIControlStateNormal];
        [addMoreButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [addMoreButton setHidden:YES];

        [addMoreButton addTarget:self
                          action:@selector(addObjectButtonPressed:)
                forControlEvents:UIControlEventTouchUpInside];

        [addMoreButton setAutoresizingMask:UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth];

        [cell.contentView addSubview:addMoreButton];

        UITextField *textField = [[UITextField alloc] initWithFrame:frame];
        textField.tag          = textFieldTag;

        textField.backgroundColor = [UIColor clearColor];
        textField.font            = [UIFont systemFontOfSize:14.0];
        textField.textColor       = [UIColor blackColor];
        textField.textAlignment   = UITextAlignmentLeft;
        textField.hidden          = YES;
        textField.borderStyle     = UITextBorderStyleLine;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate        = self;

        [textField setAutoresizingMask:UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth];

        [cell.contentView addSubview:textField];

        EntityData *data = [[EntityData alloc] init];
        [propertyArray insertObject:data atIndex:(NSUInteger)indexPath.row];
    }

    EntityData *data = [propertyArray objectAtIndex:(NSUInteger)indexPath.row];

    UILabel *titleLabel    = (UILabel*)[cell.contentView viewWithTag:keyLabelTag];
    UILabel *subtitleLabel = (UILabel*)[cell.contentView viewWithTag:valueLabelTag];
    UITextField *textField = (UITextField*)[cell.contentView viewWithTag:textFieldTag];
    UIButton    *button    = (UIButton*)[cell.contentView viewWithTag:addMoreButtonTag];

    NSString* subtitle  = nil;
    NSString* cellTitle = nil;

    cell.textLabel.text       = nil;
    cell.detailTextLabel.text = nil;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;

    NSString *key;
    NSObject *value = nil;

 /* If our data is an array, */
    if ([tableViewData isKindOfClass:[NSArray class]])
    {
     /* get the current item in our array */
        value = [((NSArray *)tableViewData) objectAtIndex:(NSUInteger)indexPath.row];

        if ([value respondsToSelector:@selector(toDictionary)])
            value = [(JRCaptureObject *)value toDictionary];
    }
 /* If our data is a dictionary, */
    else if ([tableViewData isKindOfClass:[NSDictionary class]])
    {
     /* get the current key and item for that key */
        key   = [[((NSDictionary *)tableViewData) allKeysOrdered] objectAtIndex:(NSUInteger)indexPath.row];
        value = [((NSDictionary *)tableViewData) objectForKey:key];

        if ([value respondsToSelector:@selector(toDictionary)])
            value = [(JRCaptureObject *)value toDictionary];

     /* and set the cell title as the key */
        cellTitle = key;
    }
    else { /* Shouldn't happen */ }

 /* If our item is an array or dictionary... */
    if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]])
    {
     /* If our array or dictionary has 1 or more items, add the accessory view and set the subtitle. */
        if ([((NSArray*)value) count])
        {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];

         /* Lets not say, "1 items".  That's just silly. */
            if ([((NSArray*)value) count] == 1)
                subtitle = @"1 item";
            else
                subtitle = [NSString stringWithFormat:@"%d items", [((NSDictionary*)value) count]];
        }
     /* And, if it's empty, let's indicate that as well. */
        else
        {/* cellTitle will be null if our data is an array, but why have an array of empty arrays? */
            subtitle = cellTitle ? [NSString stringWithFormat:@"No known %@", cellTitle] : @"[none]";
            data.canDrillDownToEdit = YES;
        }

        /* Also, if our item is an array ... */
        if ([value isKindOfClass:[NSArray class]])
        {
            data.propertyType       = PTArray;
            data.canEdit            = NO;
        }
        else /* if ([value isKindOfClass:[NSDictionary class]]) */
        {
            data.propertyType       = PTObject;
            data.canEdit            = NO;
        }
    }
 /* If our item is a string, */
    else if ([value isKindOfClass:[NSString class]])
    {/* set the subtitle as our value, or, if empty, say so. */
        if ([((NSString*)value) length])
            subtitle = (NSString*)value;
        else
            subtitle = [NSString stringWithFormat:@"No known %@", cellTitle];

        data.propertyType = PTString;
        data.canEdit      = YES;
        data.propertyValue    = subtitle;
        textField.placeholder = subtitle;
    }
 /* If our item is a number, */
    else if ([value isKindOfClass:[NSNumber class]])
    {/* make it a string, and set the subtitle as that. */
        subtitle = [((NSNumber *)value) stringValue];

        data.propertyType     = PTNumber;
        data.canEdit          = YES;
        data.propertyValue    = subtitle;
        textField.placeholder = subtitle;
    }
 /* If our item is set to [NSNull null], figure out what it really is, but for the UI pretend it's a string, */
    else if (value == [NSNull null]) // TODO: This will break stuff!!
    {
        subtitle = cellTitle ? [NSString stringWithFormat:@"No known %@", cellTitle] : @"[none]";

        data.propertyType     = PTString;
        data.canEdit          = YES;
        data.propertyValue    = subtitle;
        textField.placeholder = subtitle;
    }
    else { /* I dunno... Just hopin' it won't happen... */ }

    if (textField.text && ![textField.text isEqualToString:@""])
        subtitleLabel.text = textField.text;
    else
        subtitleLabel.text = subtitle;

    titleLabel.text    = cellTitle;

    if ([key isEqualToString:@"id"] || [key isEqualToString:@"uuid"] ||
        [key isEqualToString:@"created"] || [key isEqualToString:@"lastUpdated"])
        data.canEdit = NO;

    data.subtitleLabel      = subtitleLabel;
    data.editValueTextField = textField;
    data.addMoreButton      = button;
    data.propertyKey        = key;

    if (!cellTitle)
        subtitleLabel.frame = UP_A_LITTLE_HIGHER(subtitleLabel);
    else
        subtitleLabel.frame = WHERE_IT_SHOULD_BE(subtitleLabel);

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"");
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSString *key                  = nil;
    NSObject *value                = nil;
    JRCaptureObject *captureSubObj = nil;

 /* Get the key, if there is one, and the value. */
    if ([tableViewData isKindOfClass:[NSArray class]])
    {
        value         = [((NSArray *)tableViewData) objectAtIndex:(NSUInteger)indexPath.row];
        captureSubObj = [((NSArray *)tableViewData) objectAtIndex:(NSUInteger)indexPath.row];
    }
    else if ([tableViewData isKindOfClass:[NSDictionary class]])
    {
        key           = [[((NSDictionary *)tableViewData) allKeysOrdered] objectAtIndex:(NSUInteger)indexPath.row];
        value         = [((NSDictionary *)tableViewData) objectForKey:key];
        captureSubObj = [captureObject performSelector:NSSelectorFromString(key)];
    }

    if ([value respondsToSelector:@selector(toDictionary)])
        value = [(JRCaptureObject *)value toDictionary];

 /* If our value isn't an array or dictionary, don't drill down. */
    if (![value isKindOfClass:[NSArray class]] && ![value isKindOfClass:[NSDictionary class]])
        return;

 /* If our value is an *empty* array or dictionary, don't drill down. */
    if (![(NSArray *)value count]) /* Since we know value is either an array or dictionary, and both classes respond */
        return;                    /* to the 'count' selector, we just cast as an array to avoid IDE complaints */

    UserDrillDownViewController *drillDown =
                [[UserDrillDownViewController alloc] initWithNibName:@"UserDrillDownViewController"
                                                              bundle:[NSBundle mainBundle]
                                                    forCaptureObject:captureSubObj
                                                 captureParentObject:captureObject
                                                              andKey:key ? key : tableViewHeader];

//                                                       andDataObject:captureObj
//                                                              forKey:key];

    [[self navigationController] pushViewController:drillDown animated:YES];
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

