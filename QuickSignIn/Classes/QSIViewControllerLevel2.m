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

 
 File:	 QSIViewControllerLevel2.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "QSIViewControllerLevel2.h"

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@implementation ViewControllerLevel2
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
- (void)animateAdditions
{
    static int i = 0;
    
    if (selectedUser)            
    {   
        [myTableView beginUpdates];
        [myTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,4)] 
                   withRowAnimation:UITableViewRowAnimationBottom];//((i++)%7)];
        [myTableView endUpdates];
    }
    else
    {
        [myTableView reloadData];
    }
    
    NSLog (@"i=%d",i);
}

- (void)loadUser:(BOOL)animated
{
    selectedUser = [[[UserModel getUserModel] selectedUser] retain];
	NSString* identifier = [selectedUser objectForKey:@"identifier"];
	
	profile = [[[[[UserModel getUserModel] userProfiles] objectForKey:identifier] objectForKey:@"profile"] retain];
	profileKeys = [[profile allKeys] retain];
    
    accessCredentials = [[[[[UserModel getUserModel] userProfiles] objectForKey:identifier] objectForKey:@"accessCredentials"] retain];
	accessCredentialsKeys = [[accessCredentials allKeys] retain];
    
    mergedPoco = [[[[[UserModel getUserModel] userProfiles] objectForKey:identifier] objectForKey:@"merged_poco"] retain];
	mergedPocoKeys = [[mergedPoco allKeys] retain];
    
    friends = [[[[[UserModel getUserModel] userProfiles] objectForKey:identifier] objectForKey:@"friends"] retain];   
	
    if (iPad && animated)
        [self animateAdditions];
    else
        [myTableView reloadData];
}

- (void)clearUser:(BOOL)animated
{
	[selectedUser release], selectedUser = nil;
	[profile release], profile = nil;
	[profileKeys release], profileKeys = nil;
    [accessCredentials release], accessCredentials = nil;
    [accessCredentialsKeys release], accessCredentialsKeys = nil;
    [mergedPoco release], mergedPoco = nil;
    [mergedPocoKeys release], mergedPocoKeys = nil;
    [friends release], friends = nil;
    [friendsKeys release], friendsKeys = nil;

    if (iPad && animated)
        [self animateAdditions];
    else
        [myTableView reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        iPad = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	    
    if (!iPad)
        self.title = [UserModel getDisplayNameFromProfile:profile];
	
    if ([[UserModel getUserModel] selectedUser])
        [self loadUser:YES];
    
	myTableView.backgroundColor = [UIColor clearColor];	
	
#ifdef LILLI
	if ([[UserModel getUserModel] currentUser])
		[myToolBarButton setEnabled:YES];
	else
		[myToolBarButton setEnabled:NO];
#endif
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
    
    [self clearUser:NO];
}	
	
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    if (!selectedUser)
        return 0;
    
    switch (section)
    {
        case 0:
            return @"Identifier";
        case 1:
            return @"Basic Profile Information";
        case 2:
            return @"Access Credentials";
        case 3:
            return @"Merged Portable Contacts";
        case 4:
            return @"Friends";
        default:
            return nil;
    }
    
//	if (section == 0)
//		return @"Identifier";
//	else
//		return @"Basic Profile Information";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
//    if (selectedUser)
        return 5;
//    else
//        return 0;
//	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section 
{
    if (!selectedUser)
        return 0;
    
	switch (section)
	{
		case 0:
			return 1;
		case 1:
			return [profileKeys count];
		case 2:
			return [accessCredentialsKeys count];
		case 3:
			return [mergedPocoKeys count];
		case 4:
			return [friends count];
		default:
			return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSInteger keyLabelTag = 1;
	static NSInteger valueLabelTag = 2;

	UITableViewCellStyle style = UITableViewCellStyleDefault;//(indexPath.section == 0) ? UITableViewCellStyleDefault : UITableViewCellStyleDefault;
	NSString *reuseIdentifier = @"cachedCellSection";//(indexPath.section == 0) ? @"cachedCellSection0" : @"cachedCellSection1";

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
	
    UILabel *titleLabel = (UILabel*)[cell.contentView viewWithTag:keyLabelTag];
    UILabel *subtitleLabel = (UILabel*)[cell.contentView viewWithTag:valueLabelTag];
    NSString* subtitle = nil;
    NSString* cellTitle = nil;
    
    switch (indexPath.section)
	{
		case 0:
		{
			NSString *identifier = [profile objectForKey:@"identifier"];
			
			cell.textLabel.text = identifier;
			cell.detailTextLabel.text = nil;	
			break;
		}	
		case 1:
		{
            cellTitle = [profileKeys objectAtIndex:indexPath.row];
			
			if ([cellTitle isEqualToString:@"name"])
				subtitle = [UserModel getDisplayNameFromProfile:profile];
			else if ([cellTitle isEqualToString:@"address"])
				subtitle = [UserModel getAddressFromProfile:profile];
			else
				subtitle = [profile objectForKey:cellTitle];//[NSString stringWithFormat:@"%@", [profile objectForKey:cellTitle]];
//			UILabel *titleLabel = (UILabel*)[cell.contentView viewWithTag:keyLabelTag];
//			UILabel *subtitleLabel = (UILabel*)[cell.contentView viewWithTag:valueLabelTag];
//
//			NSString* cellTitle = [profileKeys objectAtIndex:indexPath.row];
//			NSString* subtitle = nil;
//			
//			if ([cellTitle isEqualToString:@"name"])
//				subtitle = [UserModel getDisplayNameFromProfile:profile];
//			else if ([cellTitle isEqualToString:@"address"])
//				subtitle = [UserModel getAddressFromProfile:profile];
//			else
//				subtitle = [NSString stringWithFormat:@"%@", [profile objectForKey:cellTitle]];
//	
//			titleLabel.text = cellTitle;
//			subtitleLabel.text = subtitle;
            DLog (@"section: basic profile");
			break;
		}
		case 2:
		{
            DLog (@"section: access");
            cellTitle = [accessCredentialsKeys objectAtIndex:indexPath.row];
			subtitle = [accessCredentials objectForKey:cellTitle];
			break;
		}
		case 3:
		{
            DLog (@"section: merged");
            cellTitle = [mergedPocoKeys objectAtIndex:indexPath.row];
			subtitle = [mergedPoco objectForKey:cellTitle];
			break;
		}
		case 4:
		{
            DLog (@"section: friends");
            cellTitle = [friends objectAtIndex:indexPath.row];
			break;
		}
		default:
			break;
	}
	
    if (indexPath.section != 0)
    {
        DLog (@"title: %@", cellTitle);
        DLog (@"subtitle: %@", subtitle);
        
        if (![subtitle isKindOfClass:[NSString class]])
            subtitle = [NSString stringWithFormat:@"%@", subtitle];
        
        titleLabel.text = cellTitle;
        subtitleLabel.text = subtitle;
    }
    
	return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { }
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath { }

- (IBAction)signOutButtonPressed:(id)sender
{
	[[UserModel getUserModel] startSignUserOut:nil];
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
    [myTableView release];
    [myToolBarButton release];
//	[selectedUser release];
//	[selectedUsersProfile release];
//	[profileEntriesArray release];
	
	[super dealloc];
}


@end

