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
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.autoresizingMask = UIViewAutoresizingNone |
                                 UIViewAutoresizingFlexibleWidth |
                                 UIViewAutoresizingFlexibleHeight;

    myTableView = [[[UITableView alloc] initWithFrame:[[self view] frame]
                                                style:UITableViewStyleGrouped] autorelease];
    myTableView.delegate   = self;
    myTableView.dataSource = self;

    myTableView.backgroundColor  = [UIColor clearColor];
    myTableView.autoresizingMask = UIViewAutoresizingNone |
                                   UIViewAutoresizingFlexibleWidth |
                                   UIViewAutoresizingFlexibleHeight;

    UIImageView *backgroundImage =
        [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease];

    backgroundImage.autoresizingMask = UIViewAutoresizingNone |
                                       UIViewAutoresizingFlexibleWidth |
                                       UIViewAutoresizingFlexibleHeight;


    [self.view addSubview:backgroundImage];
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
    if (tableViewHeader)
        return 30.0;
    return 0;
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

#define HIGHER_SUBTITLE 10
#define NORMAL_SUBTITLE 21
#define UP_A_LITTLE_HIGHER(r) CGRectMake(r.frame.origin.x, HIGHER_SUBTITLE, r.frame.size.width, r.frame.size.height)
#define WHERE_IT_SHOULD_BE(r) CGRectMake(r.frame.origin.x, NORMAL_SUBTITLE, r.frame.size.width, r.frame.size.height)

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
        frame.size.width  = (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? 280 : 440;;

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
    }
 /* If our data is a dictionary, */
    else if ([tableViewData isKindOfClass:[NSDictionary class]])
    {
     /* get the current key and item for that key */
        key   = [[((NSDictionary *)tableViewData) allKeysOrdered] objectAtIndex:(NSUInteger)indexPath.row];
        value = [((NSDictionary *)tableViewData) objectForKey:key];

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
        }
    }
 /* If our item is a string, */
    else if ([value isKindOfClass:[NSString class]])
    {/* set the subtitle as our value, or, if empty, say so. */
        if ([((NSString*)value) length])
            subtitle = (NSString*)value;
        else
            subtitle = [NSString stringWithFormat:@"No known %@", cellTitle];
    }
 /* If our item is a number, */
    else if ([value isKindOfClass:[NSNumber class]])
    {/* make it a string, and set the subtitle as that. */
        subtitle = [((NSNumber *)value) stringValue];
    }
    else { /* I dunno... Just hopin' it won't happen... */ }

    subtitleLabel.text = subtitle;
    titleLabel.text    = cellTitle;

    if (!cellTitle)
        subtitleLabel.frame = UP_A_LITTLE_HIGHER(subtitleLabel);
    else
        subtitleLabel.frame = WHERE_IT_SHOULD_BE(subtitleLabel);

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSString *key   = nil;
    NSObject *value = nil;

 /* Get the key, if there is one, and the value. */
    if ([tableViewData isKindOfClass:[NSArray class]])
    {
        value = [((NSArray *)tableViewData) objectAtIndex:(NSUInteger)indexPath.row];
    }
    else if ([tableViewData isKindOfClass:[NSDictionary class]])
    {
        key   = [[((NSDictionary *)tableViewData) allKeysOrdered] objectAtIndex:(NSUInteger)indexPath.row];
        value = [((NSDictionary *)tableViewData) objectForKey:key];
    }

 /* If our value isn't an array or dictionary, don't drill down. */
    if (![value isKindOfClass:[NSArray class]] && ![value isKindOfClass:[NSDictionary class]])
        return;

/* If our value is an *empty* array or dictionary, don't drill down. */
    if (![(NSArray *)value count]) /* Since we know value is either an array or dictionary, and both classes respond */
        return;                    /* to the 'count' selector, we just cast as an array to avoid IDE complaints */

    ProfileDrillDownViewController *drillDown =
            [[[ProfileDrillDownViewController alloc] initWithObject:value forKey:key] autorelease];

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
    [myTableView release];
    [tableViewHeader release], tableViewHeader = nil;
    [tableViewData release], tableViewData = nil;
    [super dealloc];
}
@end

