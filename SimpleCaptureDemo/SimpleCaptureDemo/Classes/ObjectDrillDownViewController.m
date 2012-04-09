//
//  ObjectDrillDownViewControllerViewController.m
//  SimpleCaptureDemo
//
//  Created by Lilli Szafranski on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectDrillDownViewController.h"


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

@interface OEntityData : NSObject
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

@implementation OEntityData
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

typedef enum
{
    DataTypeNone,
    DataTypeObject,
    DataTypeArray,
} DataType;

@interface ObjectDrillDownViewController ()
@property          DataType         dataType;
@property          NSUInteger       dataCount;
@property (strong) JRCaptureObject *captureObject;
@property (strong) JRCaptureObject *parentCaptureObject;
@property (strong) NSObject *tableViewData;
@property (strong) NSString *tableViewHeader;
@property (strong) OEntityData *currentlyEditingData;
@end

@implementation ObjectDrillDownViewController
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Configure the cell...

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
