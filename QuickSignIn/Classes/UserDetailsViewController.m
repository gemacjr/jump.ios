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


 File:   QSIViewControllerLevel2.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "UserDetailsViewController.h"

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

@interface UserDetailsViewController ()
@end

@implementation UserDetailsViewController

/*
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        iPad = YES;

    if (iPad)
        myTableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 448, 30)] autorelease];

    PROFILE_SECTION_INDEX             = -1;
    ACCESS_CREDENTIALS_SECTION_INDEX  = -1;
    MERGED_POCO_SECTION_INDEX         = -1;
    FRIENDS_SECTION_INDEX             = -1;
    CAPTURE_PROFILE_SECTION_INDEX     = -1;
    CAPTURE_CREDENTIALS_SECTION_INDEX = -1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([[UserModel getUserModel] pendingCallToTokenUrl])
        [[UserModel getUserModel] setTokenUrlDelegate:self];
}

- (void)toggleLabelShow:(BOOL)show withAnimation:(BOOL)animated
{
    if (animated)
        [UIView beginAnimations:@"fade" context:nil];

    [myLabel setAlpha:(show ? 1.0 : 0.0)];

    if (animated)
        [UIView commitAnimations];
}

- (void)animateAdditions
{
    if (selectedUser)
    {
        [myTableView beginUpdates];
        [myTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]
                   withRowAnimation:UITableViewRowAnimationBottom];
        [myTableView endUpdates];
    }
    else
    {
        [myTableView reloadData];
    }
}

- (void)dynamicallyDetermineTableSections
{
    NSInteger sectionIndexCounter = 1;

    if ([profileKeys count])
        PROFILE_SECTION_INDEX = sectionIndexCounter;
    if ([accessCredentialsKeys count])
        ACCESS_CREDENTIALS_SECTION_INDEX = ++sectionIndexCounter;//++;
    if ([mergedPocoKeys count])
        MERGED_POCO_SECTION_INDEX = ++sectionIndexCounter;//++;
    if ([friends count])
        FRIENDS_SECTION_INDEX = ++sectionIndexCounter;//++;
    if ([captureProfileOrderedKeys count])
        CAPTURE_PROFILE_SECTION_INDEX = ++sectionIndexCounter;//++;
    if ([captureCredentialsOrderedKeys count])
        CAPTURE_CREDENTIALS_SECTION_INDEX = ++sectionIndexCounter;//++;

    numberOfSections = sectionIndexCounter + 1;
}

- (void)loadUser:(BOOL)animated
{
    animated = NO;

    NSLog (@"loading user, %@", animated ? @"animated" : @"not animated");

    selectedUser         = [[[UserModel getUserModel] selectedUser] retain];
    NSString *identifier = [selectedUser objectForKey:@"identifier"];
    NSDictionary *user   = [[[UserModel getUserModel] userProfiles] objectForKey:identifier];

    profile     = [[user objectForKey:@"profile"] retain];
    profileKeys = [[profile allKeys] retain];

    accessCredentials     = [[user objectForKey:@"accessCredentials"] retain];
    accessCredentialsKeys = [[accessCredentials allKeys] retain];

    mergedPoco     = [[user objectForKey:@"merged_poco"] retain];
    mergedPocoKeys = [[mergedPoco allKeys] retain];

    friends = [[user objectForKey:@"friends"] retain];

    captureProfile            = [[user objectForKey:@"captureProfile"] retain];
    captureProfileOrderedKeys = [[captureProfile allKeysOrdered] retain];

    captureCredentials            = [[user objectForKey:@"captureCredentials"] retain];
    captureCredentialsOrderedKeys = [[captureCredentials allKeysOrdered] retain];

    [self dynamicallyDetermineTableSections];

    NSLog (@"section 1, %d rows", [profileKeys count]);
    NSLog (@"section 2, %d rows", [accessCredentialsKeys count]);

    self.title = [UserModel getDisplayNameFromProfile:profile];

    if (iPad && animated)
        [self animateAdditions];
    else
        [myTableView reloadData];

    if (iPad)
        [self toggleLabelShow:NO withAnimation:NO];
}

- (void)clearUser:(BOOL)animated
{
    animated = NO;

    NSLog (@"clearing user, %@", animated ? @"animated" : @"not animated");

    [selectedUser release], selectedUser = nil;
    [profile release], profile = nil;
    [profileKeys release], profileKeys = nil;
    [accessCredentials release], accessCredentials = nil;
    [accessCredentialsKeys release], accessCredentialsKeys = nil;
    [mergedPoco release], mergedPoco = nil;
    [mergedPocoKeys release], mergedPocoKeys = nil;
    [friends release], friends = nil;
    [friendsKeys release], friendsKeys = nil;
    [captureProfile release], captureCredentials = nil;
    [captureProfileOrderedKeys release], captureProfileOrderedKeys = nil;
    [captureCredentials release], captureCredentials = nil;
    [captureCredentialsOrderedKeys release], captureCredentialsOrderedKeys = nil;

    PROFILE_SECTION_INDEX             = -1;
    ACCESS_CREDENTIALS_SECTION_INDEX  = -1;
    MERGED_POCO_SECTION_INDEX         = -1;
    FRIENDS_SECTION_INDEX             = -1;
    CAPTURE_PROFILE_SECTION_INDEX     = -1;
    CAPTURE_CREDENTIALS_SECTION_INDEX = -1;

    if (iPad && animated)
        [self animateAdditions];
    else
        [myTableView reloadData];

    if (iPad)
        [self toggleLabelShow:YES withAnimation:animated];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (!selectedUser)
        return nil;

//    switch (section)
//    {
        if (section == 0)//case 0:
            return @"Engage Identifier";
        /*case*/ else if (section == PROFILE_SECTION_INDEX)//://1:
            //if ([profileKeys count])
                return @"Engage Profile Information";
            //return nil;
        /*case*/ else if (section == ACCESS_CREDENTIALS_SECTION_INDEX)//://2:
            //if ([accessCredentials count])
                return @"Engage Access Credentials";
            //return nil;
        /*case*/ else if (section == MERGED_POCO_SECTION_INDEX)//://3:
            //if ([mergedPocoKeys count])
                return @"Engage Merged Portable Contacts";
            //return nil;
        /*case*/ else if (section == FRIENDS_SECTION_INDEX)//://4:
            //if ([friends count])
                return @"Engage Friends";
            //return nil;
        /*case*/ else if (section == CAPTURE_PROFILE_SECTION_INDEX)//://5:
            //if ([captureProfileOrderedKeys count])//([[captureProfile allKeysOrdered] count])
                return @"Capture Profile Information";
            //return nil;
        /*case*/ else if (section == CAPTURE_CREDENTIALS_SECTION_INDEX)//://6:
            //if ([captureCredentialsOrderedKeys count])//([[captureCredentials allKeysOrdered] count])
                return @"Capture Access Credentials";
            //return nil;
        else //default:
            return nil;
   // }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return numberOfSections;
    //return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if ([self tableView:tableView titleForHeaderInSection:section])
        return 30.0;
//    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if ([self tableView:tableView titleForHeaderInSection:section])
        return 30.0;
//    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!selectedUser)
        return 0;

//  switch (section)
//  {
        /*case*/ if (section == 0)//:
//          NSLog (@"section 0: 1 row");
            return 1;
        /*case*/ else if (section == PROFILE_SECTION_INDEX)//://1:
            return [profileKeys count];
        /*case*/ else if (section == ACCESS_CREDENTIALS_SECTION_INDEX)//://2:
            return [accessCredentialsKeys count];
        /*case*/ else if (section == MERGED_POCO_SECTION_INDEX)//://3:
            return [mergedPocoKeys count];
        /*case*/ else if (section == FRIENDS_SECTION_INDEX)//://4:
            return [friends count];
        /*case*/ else if (section == CAPTURE_PROFILE_SECTION_INDEX)//://5:
            return [captureProfileOrderedKeys count];//[[captureProfile allKeysOrdered] count];
        /*case*/ else if (section == CAPTURE_CREDENTIALS_SECTION_INDEX)//://6:
            return [captureCredentialsOrderedKeys count];//[[captureCredentials allKeysOrdered] count];
        /*default:*/ else
            return 0;
    //}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSInteger keyLabelTag   = 1;
    static NSInteger valueLabelTag = 2;

    UITableViewCellStyle style = UITableViewCellStyleDefault;
    NSString *reuseIdentifier  = @"cachedCellSection";

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
        keyLabel.tag = keyLabelTag;

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
    NSString *subtitle     = nil;
    NSString *cellTitle    = nil;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.textLabel.text = nil;

    NSInteger section = indexPath.section;
//    switch (indexPath.section)
//  {
        /*case*/ if (section == 0)//:
        {
            NSString *identifier = [profile objectForKey:@"identifier"];

            cell.textLabel.text       = identifier;
            cell.detailTextLabel.text = nil;
//          break;
        }
        /*case*/ else if (section == PROFILE_SECTION_INDEX)//://1:
        {
            cellTitle = [profileKeys objectAtIndex:indexPath.row];

            if ([cellTitle isEqualToString:@"name"])
                subtitle = [UserModel getDisplayNameFromProfile:profile];
            else if ([cellTitle isEqualToString:@"address"])
                subtitle = [UserModel getAddressFromProfile:profile];
            else
                subtitle = [profile objectForKey:cellTitle];
//          break;
        }
        /*case*/ else if (section == ACCESS_CREDENTIALS_SECTION_INDEX)//://2:
        {
            cellTitle = [accessCredentialsKeys objectAtIndex:indexPath.row];
            subtitle = [accessCredentials objectForKey:cellTitle];
//          break;
        }
        /*case*/ else if (section == MERGED_POCO_SECTION_INDEX)//://3:
        {
            cellTitle = [mergedPocoKeys objectAtIndex:indexPath.row];
            subtitle = [mergedPoco objectForKey:cellTitle];
//          break;
        }
        /*case*/ else if (section == FRIENDS_SECTION_INDEX)//://4:
        {
            cellTitle = [friends objectAtIndex:indexPath.row];
//          break;
        }
        /*case*/ else if (section == CAPTURE_PROFILE_SECTION_INDEX)//://5:
        {
            cellTitle = [captureProfileOrderedKeys objectAtIndex:indexPath.row];

            NSObject *value = [captureProfile objectForKey:cellTitle];
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

//                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//                [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];
//                subtitle = nil;
            }
            else
            {
                subtitle = [captureProfile objectForKey:cellTitle];
            }
//            break;
        }
        /*case*/ else if (section == CAPTURE_CREDENTIALS_SECTION_INDEX)//://6:
        {
            cellTitle = [captureCredentialsOrderedKeys objectAtIndex:indexPath.row];
            subtitle = [captureCredentials objectForKey:cellTitle];
//            break;
        }
        else;//default:
//          break;
//  }

    if (indexPath.section != 0)
    {
//        if (subtitle == nil)
//        {
//            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//            [cell setSelectionStyle: UITableViewCellSelectionStyleBlue];
//            cell.textLabel.text = cellTitle;
//            subtitleLabel.text = nil;
//            titleLabel.text = nil;
//        }
//        else
//        {


        if (subtitle && ![subtitle isKindOfClass:[NSString class]])
            subtitle = [NSString stringWithFormat:@"%@", [subtitle description]];

        subtitleLabel.text = subtitle;
        titleLabel.text    = cellTitle;
//        }

    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if ([indexPath section] != CAPTURE_PROFILE_SECTION_INDEX) return;

    NSString *key   = [captureProfileOrderedKeys objectAtIndex:indexPath.row];
    NSObject *value = [captureProfile objectForKey:key];

    if (![value isKindOfClass:[NSArray class]] && ![value isKindOfClass:[NSDictionary class]])
        return;

    if (![value respondsToSelector:@selector(count)])
        return;

    if (![(NSArray *)value count])
        return;

    ProfileDrillDownViewController *drillDown =
            [[[ProfileDrillDownViewController alloc] initWithObject:value forKey:key] autorelease];

    [[self navigationController] pushViewController:drillDown animated:YES];

//
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//
//
//    if ([value isKindOfClass:[NSDictionary class]])
//    {
//        dict = (NSDictionary *) value;
//    }
//    else if ([value isKindOfClass:[NSArray class]])
//    {
//        NSArray *val_ = (NSArray *)value;
//        NSMutableDictionary *dict_ = [NSMutableDictionary dictionary];
//        for (NSUInteger i=0; i<[val_ count]; i++)
//        {
//            [dict_ setObject:[val_ objectAtIndex:i] forKey:[NSString stringWithFormat:@"%d", i]];
//        }
//        dict = dict_;
//    }
//    else
//    {
//        return;
//    }
//
//    ProfileDrillDownViewController *drillDown =
//            [[ProfileDrillDownViewController alloc] initWithDictionary:dict header:key];
//    [[self navigationController] pushViewController:drillDown animated:YES];
}

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath { }

- (IBAction)signOutButtonPressed:(id)sender
{
    [[UserModel getUserModel] startSignUserOut:nil];
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void)didReachTokenUrl
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Sign-In Complete"
                                                     message:@"You have successfully signed-in to the Quick Sign-In application and server."
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
    [alert show];
}

- (void)didFailToReachTokenUrl
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Sign-In Error"
                                                     message:@"An error occurred while attempting to sign you in to the Quick Sign-In server."
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
    [alert show];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (iPad)
        return YES;

    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if ([[UserModel getUserModel] pendingCallToTokenUrl])
        [[UserModel getUserModel] setTokenUrlDelegate:nil];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [self clearUser:NO];
}

- (void)viewDidUnload
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
    [captureProfile release], captureProfile = nil;
    [captureCredentials release], captureCredentials = nil;
}

- (void)dealloc
{
    [myTableView release];
    [myToolBarButton release];
    [myLabel release];

    [profile release];
    [profileKeys release];
    [accessCredentials release];
    [accessCredentialsKeys release];
    [mergedPoco release];
    [mergedPocoKeys release];
    [friends release];
    [captureProfile release];
    [captureProfileOrderedKeys release];
    [captureCredentials release];
    [captureCredentialsOrderedKeys release];
    [selectedUser release];

    [super dealloc];
}
@end

