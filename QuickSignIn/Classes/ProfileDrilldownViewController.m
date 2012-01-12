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

-(NSArray *)allKeysOrdered;

@end

@implementation NSDictionary (OrderedKeys)

-(NSArray *)allKeysOrdered
{
    NSArray *allKeys = [self allKeys];
    return [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

@end

@implementation ProfileDrillDownViewController

@synthesize header;
@synthesize tableViewData;

- (id)initWithDictionary:(NSDictionary*)data header:(NSString*)header_
{
    if ((self = [super init]))
    {
        DLog(@"tVD %d, h %d", [data retainCount], [header_ retainCount]);
        [self setTableViewData:data];
        [self setHeader:header_];
        DLog(@"tVD %d, h %d ", [data retainCount], [header_ retainCount]);
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    myTableView = [[[UITableView alloc] initWithFrame:[[self view] frame]
                                                style:UITableViewStyleGrouped] autorelease];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    UIImage *image = [UIImage imageNamed:@"background.png"];
    [self.view addSubview:[[[UIImageView alloc] initWithImage:image] autorelease]];
    [self.view addSubview:myTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

    myTableView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return header;
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
    if ([self tableView:tableView titleForHeaderInSection:section])
        return 30.0;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self tableView:tableView titleForHeaderInSection:section])
        return 30.0;
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[tableViewData allKeysOrdered] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSInteger keyLabelTag = 1;
	static NSInteger valueLabelTag = 2;

	UITableViewCellStyle style = UITableViewCellStyleDefault;
	NSString *reuseIdentifier = @"cachedCellSection2";

	UITableViewCell *cell =
		[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc]
				 initWithStyle:style reuseIdentifier:reuseIdentifier] autorelease];

		CGRect frame;
		frame.origin.x = 10;
		frame.origin.y = 5;
		frame.size.height = 18;
		frame.size.width = 280;

		UILabel *keyLabel = [[UILabel alloc] initWithFrame:frame];
		keyLabel.tag = keyLabelTag;

		keyLabel.backgroundColor = [UIColor clearColor];
		keyLabel.font = [UIFont systemFontOfSize:13.0];
		keyLabel.textColor = [UIColor grayColor];
		keyLabel.textAlignment = UITextAlignmentLeft;

        [keyLabel setAutoresizingMask:UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth];

		[cell.contentView addSubview:keyLabel];
		[keyLabel release];

		frame.origin.y += 16;
		frame.size.height += 8;
		UILabel *valueLabel = [[UILabel alloc] initWithFrame:frame];
		valueLabel.tag = valueLabelTag;

		valueLabel.backgroundColor = [UIColor clearColor];
		valueLabel.font = [UIFont boldSystemFontOfSize:16.0];
		valueLabel.textColor = [UIColor blackColor];
		valueLabel.textAlignment = UITextAlignmentLeft;

        [valueLabel setAutoresizingMask:UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth];

		[cell.contentView addSubview:valueLabel];
		[valueLabel release];
    }

    UILabel *titleLabel = (UILabel*)[cell.contentView viewWithTag:keyLabelTag];
    UILabel *subtitleLabel = (UILabel*)[cell.contentView viewWithTag:valueLabelTag];

    NSString* subtitle = nil;
    NSString* cellTitle = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = nil;

    cellTitle = [[tableViewData allKeysOrdered] objectAtIndex:indexPath.row];
    NSObject *val = [tableViewData objectForKey:cellTitle];
    if ([val isKindOfClass:[NSDictionary class]] || [val isKindOfClass:[NSArray class]])
        subtitle = nil;
    else
        subtitle = [tableViewData objectForKey:cellTitle];

    if (subtitle == nil)
    {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];

        cell.textLabel.text = cellTitle;
        subtitleLabel.text = nil;
        titleLabel.text = nil;
    }
    else
    {
        if (![subtitle isKindOfClass:[NSString class]])
            subtitle = [NSString stringWithFormat:@"%@", subtitle];

        subtitleLabel.text = subtitle;
        titleLabel.text = cellTitle;
    }

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *header_ = [[tableViewData allKeysOrdered] objectAtIndex:indexPath.row];

    NSDictionary *dict;
    NSObject *val = [tableViewData objectForKey:header_];
    if ([val isKindOfClass:[NSDictionary class]])
    {
        dict = (NSDictionary *) val;
    }
    else if ([val isKindOfClass:[NSArray class]])
    {
        NSArray *val_ = (NSArray *)val;
        NSMutableDictionary *dict_ = [NSMutableDictionary dictionary];
        for (NSUInteger i=0; i<[val_ count]; i++)
        {
            [dict_ setObject:[val_ objectAtIndex:i] forKey:[NSString stringWithFormat:@"%d", i]];
        }
        dict = dict_;
    }
    else
    {
        return;
    }
    ProfileDrillDownViewController *drillDown =
            [[[ProfileDrillDownViewController alloc] initWithDictionary:dict header:header_] autorelease];
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
    [header release], header = nil;
    [tableViewData release], tableViewData = nil;
	[super dealloc];
}

@end

