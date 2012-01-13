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
#import "ProfileDrillDownViewController.h"

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

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

@implementation ProfileDrillDownViewController
@synthesize tableViewHeader;
@synthesize tableViewData;

- (id)initWithObject:(NSObject*)object forKey:(NSString*)key
{
    if ((self = [super init]))
    {
        self.tableViewData   = object;
        self.tableViewHeader = key;
        //DLog(@"tVD %d, h %d", [object retainCount], [key retainCount]);
        //[self setTableViewData:object];
        //[self setHeader:key];
        //DLog(@"tVD %d, h %d ", [data retainCount], [header_ retainCount]);
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    myTableView = [[[UITableView alloc] initWithFrame:[[self view] frame]
                                                style:UITableViewStyleGrouped] autorelease];
    myTableView.delegate   = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = [UIColor clearColor];

    UIImage *image = [UIImage imageNamed:@"background.png"];

    [self.view addSubview:[[[UIImageView alloc] initWithImage:image] autorelease]];
    [self.view addSubview:myTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableViewData isKindOfClass:[NSArray class]])
        return [((NSArray*)tableViewData) count];
    else if ([tableViewData isKindOfClass:[NSDictionary class]])
        return [[((NSDictionary*)tableViewData) allKeysOrdered] count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSInteger keyLabelTag   = 1;
    static NSInteger valueLabelTag = 2;

    UITableViewCellStyle style = UITableViewCellStyleDefault;
    NSString *reuseIdentifier  = @"cachedCellSection2";

    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:style reuseIdentifier:reuseIdentifier] autorelease];

        CGRect frame;
        frame.origin.x    = 10;
        frame.origin.y    = 5;
        frame.size.height = 18;
        frame.size.width  = 280;

        UILabel *keyLabel = [[UILabel alloc] initWithFrame:frame];
        keyLabel.tag      = keyLabelTag;

        keyLabel.backgroundColor = [UIColor clearColor];
        keyLabel.font            = [UIFont systemFontOfSize:13.0];
        keyLabel.textColor       = [UIColor grayColor];
        keyLabel.textAlignment   = UITextAlignmentLeft;

        [keyLabel setAutoresizingMask:UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth];

        [cell.contentView addSubview:keyLabel];
        [keyLabel release];

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
        [valueLabel release];
    }

    UILabel *titleLabel    = (UILabel*)[cell.contentView viewWithTag:keyLabelTag];
    UILabel *subtitleLabel = (UILabel*)[cell.contentView viewWithTag:valueLabelTag];
    NSString* subtitle  = nil;
    NSString* cellTitle = nil;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.textLabel.text = nil;

    NSString *key = nil;
    NSObject *value = nil;
    if ([tableViewData isKindOfClass:[NSArray class]])
    {
        value = [((NSArray *)tableViewData) objectAtIndex:indexPath.row];

        if ([value isKindOfClass:[NSString class]])
            cellTitle = (NSString *) value;
    }
    else if ([tableViewData isKindOfClass:[NSDictionary class]])
    {
        key   = [[((NSDictionary *)tableViewData) allKeysOrdered] objectAtIndex:indexPath.row];
        value = [((NSDictionary *)tableViewData) objectForKey:key];

        cellTitle = key;

        if ([value isKindOfClass:[NSString class]])
            subtitle = (NSString *) value;
    }

    if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]])
    {
        if ([((NSArray *)value) count])
        {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];
            subtitle = nil;
        }
        else
        {
            subtitle = @"[none]";
        }
    }

    subtitleLabel.text = subtitle;
    titleLabel.text    = cellTitle;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

//    if (![tableViewData isKindOfClass:[NSArray class]] && ![tableViewData isKindOfClass:[NSDictionary class]])
//        return;

    NSString *key   = nil;
    NSObject *value = nil;
    if ([tableViewData isKindOfClass:[NSArray class]])
    {
        value = [((NSArray *)tableViewData) objectAtIndex:indexPath.row];
    }
    else if ([tableViewData isKindOfClass:[NSDictionary class]])
    {
        key   = [[((NSDictionary *)tableViewData) allKeysOrdered] objectAtIndex:indexPath.row];
        value = [((NSDictionary *)tableViewData) objectForKey:key];
    }

//    NSString *key   = [[((NSDictionary *)tableViewData) allKeysOrdered] objectAtIndex:indexPath.row];
//    NSObject *value = [((NSDictionary *)tableViewData) objectForKey:key];

    if (![value isKindOfClass:[NSArray class]] && ![value isKindOfClass:[NSDictionary class]])
        return;

    if (![value respondsToSelector:@selector(count)])
        return;

    if (![(NSArray *)value count])
        return;

    ProfileDrillDownViewController *drillDown =
            [[[ProfileDrillDownViewController alloc] initWithObject:value forKey:key] autorelease];

    [[self navigationController] pushViewController:drillDown animated:YES];
}

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath { }

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
}

- (void)dealloc
{
    [myTableView release];
    [tableViewHeader release], tableViewHeader = nil;
    [tableViewData release], tableViewData = nil;
    [super dealloc];
}

@end

