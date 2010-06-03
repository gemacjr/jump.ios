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

 
 File:	 DemoViewControllerLevel2.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import "DemoViewControllerLevel2.h"


@implementation DemoViewControllerLevel2
@synthesize myTableView;
@synthesize myToolBarButton;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	selectedUser = [[[DemoUserModel getDemoUserModel] selectedUser] retain];
	NSString* identifier = [selectedUser objectForKey:@"identifier"];
	
	selectedUsersProfile = [[[[[DemoUserModel getDemoUserModel] userProfiles] objectForKey:identifier] objectForKey:@"profile"] retain];
	profileEntriesArray = [[selectedUsersProfile allKeys] retain];

	self.title = [DemoUserModel getDisplayNameFromProfile:selectedUsersProfile];
	
	myTableView.backgroundColor = [UIColor clearColor];	
	
#ifdef LILLI
	if ([[DemoUserModel getDemoUserModel] currentUser])
		[myToolBarButton setEnabled:YES];
	else
		[myToolBarButton setEnabled:NO];
#endif
	
	[myTableView reloadData];
}	

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];

	[selectedUser release];
	[selectedUsersProfile release];
	[profileEntriesArray release];
}	
	
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if (section == 0)
		return @"Identifier";
	else
		return @"Basic Profile Information";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section 
{
	switch (section)
	{
		case 0:
			return 1;
			break;
		case 1:
			return [profileEntriesArray count];
			break;
		default:
			return 0;
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSInteger keyLabelTag = 1;
	static NSInteger valueLabelTag = 2;

	UITableViewCellStyle style = (indexPath.section == 0) ? UITableViewCellStyleDefault : UITableViewCellStyleDefault;// UITableViewCellStyleSubtitle;
	NSString *reuseIdentifier = (indexPath.section == 0) ? @"cachedCellSection0" : @"cachedCellSection1";

	UITableViewCell *cell = 
		(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
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
		
		[cell.contentView addSubview:valueLabel];
		[valueLabel release];
    }
		
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	switch (indexPath.section)
	{
		case 0:
		{
			NSString *identifier = [selectedUsersProfile objectForKey:@"identifier"];
			
			cell.textLabel.text = identifier;
			cell.detailTextLabel.text = nil;	
			break;
		}	
		case 1:
		{
			UILabel *titleLabel = (UILabel*)[cell.contentView viewWithTag:keyLabelTag];
			UILabel *subtitleLabel = (UILabel*)[cell.contentView viewWithTag:valueLabelTag];

			NSString* cellTitle = [profileEntriesArray objectAtIndex:indexPath.row];
			NSString* subtitle = nil;
			
			if ([cellTitle isEqualToString:@"name"])
				subtitle = [DemoUserModel getDisplayNameFromProfile:selectedUsersProfile];
			else if ([cellTitle isEqualToString:@"address"])
				subtitle = [DemoUserModel getAddressFromProfile:selectedUsersProfile];
			else
				subtitle = [NSString stringWithFormat:@"%@", [selectedUsersProfile objectForKey:cellTitle]];
	
			titleLabel.text = cellTitle;
			subtitleLabel.text = subtitle;

			break;
		}
		default:
			break;
	}
	
	return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { }
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath { }

- (IBAction)signOutButtonPressed:(id)sender
{
	[[DemoUserModel getDemoUserModel] startSignUserOut:nil];
	[[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
	[selectedUser release];
	[selectedUsersProfile release];
	[profileEntriesArray release];
	
	[super dealloc];
}


@end

