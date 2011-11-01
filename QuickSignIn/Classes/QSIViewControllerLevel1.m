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


 File:   QSIViewControllerLevel1.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <UIKit/UIKit.h>
#import "QSIViewControllerLevel1.h"
#import "QSIUserModel.h"

@interface UITableViewCellSignInHistory : UITableViewCell
{
//  UIImageView *icon;
}
//@property (nonatomic, retain) UIImageView *icon;
@end

@implementation UITableViewCellSignInHistory
//@synthesize icon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
//      [self addSubview:icon];
    }

    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];

//    CGRect mframe = self.frame;
//    CGRect cframe = self.contentView.frame;

//    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x,
//                                        self.contentView.frame.origin.y,
//                                        self.frame.size.width,
//                                        self.frame.size.height);

    CGFloat titleWidth = ((self.contentView.frame.size.width - 70) * 4) / 8;
    CGFloat subtitleWidth = ((self.contentView.frame.size.width - 70) * 4) / 8;

    self.imageView.frame = CGRectMake(10, 10, 30, 30);
    self.textLabel.frame = CGRectMake(50, 15, titleWidth, 22);
    self.detailTextLabel.frame = CGRectMake(titleWidth + 60, 20, subtitleWidth, 15);

//    [self.textLabel setBackgroundColor:[UIColor redColor]];
//    [self.detailTextLabel setBackgroundColor:[UIColor redColor]];
//    [self.contentView setBackgroundColor:[UIColor yellowColor]];
}
@end

@interface ViewControllerLevel1 ()
- (void)fadeCustomNavigationBarItems:(CGFloat)alpha;
- (void)toggleTableHeaderVisibility:(BOOL)visible;
- (void)setSignOutButtonTitle:(NSString*)newTitle;
- (void)setEditToDone;
- (void)setDoneToEdit;
- (void)setEditButtonEnabled:(BOOL)disabled;
- (void)readjustNavBarForPadRotation:(UIInterfaceOrientation)toInterfaceOrientation;
@end

@implementation ViewControllerLevel1

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (void)setUpNavigationBarForPad
{
    [myRightView addSubview:level2ViewController.view];

    mySignOutButtonPad =
    [[UIBarButtonItem alloc] initWithTitle:@"Sign Out"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(signOutButtonPressed:)];

    self.navigationItem.leftBarButtonItem = mySignOutButtonPad;
    self.navigationItem.leftBarButtonItem.enabled = YES;

//    if (self.interfaceOrientation == UIInterfaceOrientationPortrait ||
//        self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
//        myTitlePad = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 44)];
//    else
//        myTitlePad = [[UILabel alloc] initWithFrame:CGRectMake(153, 0, 120, 44)];

    if (self.interfaceOrientation == UIInterfaceOrientationPortrait ||
        self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        myTitlePad = [[UILabel alloc] initWithFrame:CGRectMake(95, 0, 130, 44)];
    else
        myTitlePad = [[UILabel alloc] initWithFrame:CGRectMake(148, 0, 130, 44)];

    [myTitlePad setFont:[UIFont boldSystemFontOfSize:20.0]];
    [myTitlePad setBackgroundColor:[UIColor clearColor]];
    [myTitlePad setTextColor:[UIColor whiteColor]];
    [myTitlePad setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [myTitlePad setTextAlignment:UITextAlignmentCenter];
    [myTitlePad setAlpha:0.0];
    [myTitlePad setAutoresizingMask:UIViewAutoresizingNone];

    [myTitlePad setText:@"Profiles"];

    if (self.interfaceOrientation == UIInterfaceOrientationPortrait ||
        self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        myEditButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(262, 0, 52, 44)];
    else
        myEditButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(368, 0, 52, 44)];

    [myEditButtonContainer setBackgroundColor:[UIColor clearColor]];
    [myEditButtonContainer setAlpha:0.0];

    myEditButtonPad = [UIButton buttonWithType:UIButtonTypeCustom];
    [myEditButtonPad setFrame:CGRectMake(0, 7, 52, 30)];
    [myEditButtonPad setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    [myEditButtonPad setImage:[UIImage imageNamed:@"edit_selected.png"] forState:UIControlStateHighlighted];
    [myEditButtonPad setImage:[UIImage imageNamed:@"edit_disabled.png"] forState:UIControlStateDisabled];

    [myEditButtonPad addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    myDoneButtonPad = [UIButton buttonWithType:UIButtonTypeCustom];
    [myDoneButtonPad setFrame:CGRectMake(0, 7, 52, 30)];
    [myDoneButtonPad setImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateNormal];
    [myDoneButtonPad setImage:[UIImage imageNamed:@"done_selected.png"] forState:UIControlStateHighlighted];

    [myDoneButtonPad addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [myDoneButtonPad setHidden:YES];

    [myEditButtonContainer addSubview:myDoneButtonPad];
    [myEditButtonContainer addSubview:myEditButtonPad];

    if (self.interfaceOrientation == UIInterfaceOrientationPortrait ||
        self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        mySplitViewPad = [[UIImageView alloc] initWithFrame:CGRectMake(316, 0, 7, 44)];
    else
        mySplitViewPad = [[UIImageView alloc] initWithFrame:CGRectMake(422, 0, 7, 44)];

    [mySplitViewPad setImage:[UIImage imageNamed:@"nav_split.png"]];
    [mySplitViewPad setBackgroundColor:[UIColor clearColor]];
    [mySplitViewPad setAlpha:0.0];

    if (self.interfaceOrientation == UIInterfaceOrientationPortrait ||
        self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        mySelectedProfilePad = [[UILabel alloc] initWithFrame:CGRectMake(426, 0, 236, 44)];
    else
        mySelectedProfilePad = [[UILabel alloc] initWithFrame:CGRectMake(532, 0, 386, 44)];

    [mySelectedProfilePad setFont:[UIFont boldSystemFontOfSize:20.0]];
    [mySelectedProfilePad setBackgroundColor:[UIColor clearColor]];
    [mySelectedProfilePad setTextColor:[UIColor whiteColor]];
    [mySelectedProfilePad setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [mySelectedProfilePad setTextAlignment:UITextAlignmentCenter];
    [mySelectedProfilePad setAlpha:0.0];

    [self.navigationController.navigationBar addSubview:myTitlePad];
    [self.navigationController.navigationBar addSubview:mySplitViewPad];
    [self.navigationController.navigationBar addSubview:myEditButtonContainer];
    [self.navigationController.navigationBar addSubview:mySelectedProfilePad];
}

- (void)setUpNavigationBarForPhone
{
    UIBarButtonItem *editButton =
    [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                   target:self
                                                   action:@selector(editButtonPressed:)] autorelease];

    self.navigationItem.leftBarButtonItem = editButton;
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        iPad = YES;

    if (iPad)
        level2ViewController = [[ViewControllerLevel2 alloc] initWithNibName:@"QSIViewControllerLevel2-iPad"
                                                                      bundle:[NSBundle mainBundle]];
    else
        level2ViewController = [[ViewControllerLevel2 alloc] initWithNibName:@"QSIViewControllerLevel2"
                                                                      bundle:[NSBundle mainBundle]];

    if (iPad)
        [self setUpNavigationBarForPad];
    else
        [self setUpNavigationBarForPhone];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (!iPad)
        self.title = @"Profiles";

    myTableView.backgroundColor = [UIColor clearColor];

    UIBarButtonItem *addAnotherButton = [[[UIBarButtonItem alloc]
                                          initWithTitle:@"Add a Profile"
                                                  style:UIBarButtonItemStyleBordered
                                                 target:self
                                                 action:@selector(addAnotherButtonPressed:)] autorelease];

    self.navigationItem.rightBarButtonItem = addAnotherButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.hidesBackButton = YES;

    [self setDoneToEdit];

    myTableView.tableHeaderView = myLabelContainerView;

    if ([[[UserModel getUserModel] signinHistory] count])
        [self setEditButtonEnabled:YES];
    else
        [self setEditButtonEnabled:NO];

    if (![[UserModel getUserModel] currentUser])
    {
        [self setSignOutButtonTitle:@"Home"];
        [self toggleTableHeaderVisibility:YES];
    }
    else
    {
        [self setSignOutButtonTitle:@"Sign Out"];
        [self toggleTableHeaderVisibility:NO];
    }

    if ([[UserModel getUserModel] loadingUserData])
        myNotSignedInLabel.text = @"Completing Sign In...";
    else
        myNotSignedInLabel.text = @"You are not currently signed in.";

    if (iPad)
    {
        [[UserModel getUserModel] setCustomInterface:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                      self.navigationItem.rightBarButtonItem,
                                                      kJRPopoverPresentationBarButtonItem,
                                                      [NSNumber numberWithInt:UIPopoverArrowDirectionAny],
                                                      kJRPopoverPresentationArrowDirection, nil]];

        [self readjustNavBarForPadRotation:self.interfaceOrientation];
    }

    [self.view becomeFirstResponder];
    [myTableView setEditing:NO animated:NO];
    [myTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (iPad)
    {
//        [self readjustNavBarForPadRotation:self.interfaceOrientation];
        [self fadeCustomNavigationBarItems:1.0];
    }

    if ([[UserModel getUserModel] pendingCallToTokenUrl])
        [[UserModel getUserModel] setTokenUrlDelegate:self];
}

- (void)readjustNavBarForPadRotation:(UIInterfaceOrientation)toInterfaceOrientation
{
    switch (toInterfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            [myTitlePad setFrame:CGRectMake(95, 0, 130, 44)];
            [myEditButtonContainer setFrame:CGRectMake(260, 0, 52, 44)];
            [mySplitViewPad setFrame:CGRectMake(316, 0, 7, 44)];
            [mySelectedProfilePad setFrame:CGRectMake(426, 0, 236, 44)];
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            [myTitlePad setFrame:CGRectMake(148, 0, 130, 44)];
            [myEditButtonContainer setFrame:CGRectMake(368, 0, 52, 44)];
            [mySplitViewPad setFrame:CGRectMake(422, 0, 7, 44)];
            [mySelectedProfilePad setFrame:CGRectMake(532, 0, 386, 44)];
            break;
        default:
            break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
//    return YES;

    if (iPad)
        return YES;

    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (!iPad)
        return;

    [self readjustNavBarForPadRotation:toInterfaceOrientation];
}

- (void)clearSelectedProfile
{
    if (iPad)
    {
        [level2ViewController clearUser:YES];
        [mySelectedProfilePad setText:nil];
    }
}

- (void)fadeCustomNavigationBarItems:(CGFloat)alpha
{
    [UIView beginAnimations:@"fade" context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelay:0.0];
    [myTitlePad setAlpha:alpha];
    [mySplitViewPad setAlpha:alpha];
    [myEditButtonContainer setAlpha:alpha];
    [mySelectedProfilePad setAlpha:alpha];
    [UIView commitAnimations];
}

- (void)toggleTableHeaderVisibility:(BOOL)visible
{
    if (visible)
        myTableView.tableHeaderView.alpha = 1.0;
    else
        myTableView.tableHeaderView.alpha = 0.0;
}

- (void)setSignOutButtonTitle:(NSString*)newTitle
{
    if (iPad)
        self.navigationItem.leftBarButtonItem.title = newTitle;
    else
        mySignOutButtonPhone.title = newTitle;
}

- (void)setEditButtonEnabled:(BOOL)enabled
{
    if (iPad)
        myEditButtonPad.enabled = enabled;
    else
        self.navigationItem.leftBarButtonItem.enabled = enabled;
}

- (void)setDoneToEdit
{
    if (iPad)
    {
        [myEditButtonPad setHidden:NO];
        [myDoneButtonPad setHidden:YES];
    }
    else
    {
        UIBarButtonItem *editButton = [[[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                        target:self
                                        action:@selector(editButtonPressed:)] autorelease];

        self.navigationItem.leftBarButtonItem = editButton;
    }

    if ([[[UserModel getUserModel] signinHistory] count])
        [self setEditButtonEnabled:YES];
    else
        [self setEditButtonEnabled:NO];
}

- (void)setEditToDone
{
    if (iPad)
    {
        [myEditButtonPad setHidden:YES];
        [myDoneButtonPad setHidden:NO];
    }
    else
    {
        UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                        target:self
                                        action:@selector(doneButtonPressed:)] autorelease];

        self.navigationItem.leftBarButtonItem = doneButton;
    }

    if ([[[UserModel getUserModel] signinHistory] count])
        [self setEditButtonEnabled:YES];
    else
        [self setEditButtonEnabled:NO];
}

- (void)doneButtonPressed:(id)sender
{
    [myTableView setEditing:NO animated:YES];
    [self clearSelectedProfile];
    [self setDoneToEdit];
}

- (void)editButtonPressed:(id)sender
{
    [myTableView setEditing:YES animated:YES];
    [self clearSelectedProfile];
    [self setEditToDone];
}

- (void)delaySignIn:(NSTimer*)theTimer
{
    [[UserModel getUserModel] startSignUserIn:self];
}

- (void)delaySignOut:(NSTimer*)theTimer
{
    [[UserModel getUserModel] startSignUserOut:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { }

- (void)addAnotherButtonPressed:(id)sender
{
    [self doneButtonPressed:nil];

    myNotSignedInLabel.text = @"Completing Sign In...";

//#ifdef LILLI
    [self clearSelectedProfile];

    [myTableView deselectRowAtIndexPath:[myTableView indexPathForSelectedRow] animated:YES];

    if ([[UserModel getUserModel] currentUser])
    {
        [[UserModel getUserModel] startSignUserOut:self];

        if (!iPad)
            [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(delaySignIn:) userInfo:nil repeats:NO];
        else
            [[UserModel getUserModel] startSignUserIn:self];
    }
    else
    {
        [[UserModel getUserModel] startSignUserIn:self];
    }

    if (iPad)
    {
        libraryDialogShowing = YES;
        [[UserModel getUserModel] setLibraryDialogDelegate:self];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }


//#else
//  [[UserModel getUserModel] startSignUserOut:self];
//  [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(delaySignIn:) userInfo:nil repeats:NO];
//#endif
}

- (IBAction)signOutButtonPressed:(id)sender
{
//#ifdef LILLI
    [self clearSelectedProfile];

    if ([[UserModel getUserModel] currentUser])
    {
        myNotSignedInLabel.text = @"You are not currently signed in.";
        [[UserModel getUserModel] startSignUserOut:self];
    }
    else
    {
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }

//#else
//  [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(delaySignOut:) userInfo:nil repeats:NO];
//  [[self navigationController] popToRootViewControllerAnimated:YES];
//#endif

}

- (void)userDidSignIn
{
    NSArray *insIndexPaths = [NSArray arrayWithObjects:
                             [NSIndexPath indexPathForRow:0 inSection:0], nil];
    NSIndexSet *set = [[[NSIndexSet alloc] initWithIndex:0] autorelease];

    [myTableView beginUpdates];
    [myTableView insertRowsAtIndexPaths:insIndexPaths withRowAnimation:UITableViewRowAnimationRight];
    [myTableView endUpdates];

    [myTableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];

    [UIView beginAnimations:@"fade" context:nil];
    [self setSignOutButtonTitle:@"Sign Out"];
    [self toggleTableHeaderVisibility:NO];
    [UIView commitAnimations];
}

- (void)userDidSignOut
{
    NSIndexSet *set0 = [[[NSIndexSet alloc] initWithIndex:0] autorelease];
    NSIndexSet *set1 = [[[NSIndexSet alloc] initWithIndex:1] autorelease];

    [self doneButtonPressed:nil];

    [myTableView beginUpdates];
    [myTableView reloadSections:set0 withRowAnimation:UITableViewRowAnimationFade];
    [myTableView reloadSections:set1 withRowAnimation:UITableViewRowAnimationLeft];
    [myTableView endUpdates];

    [UIView beginAnimations:@"fade" context:nil];
    [self setSignOutButtonTitle:@"Home"];
    [self toggleTableHeaderVisibility:YES];
    [UIView commitAnimations];
}

- (void)libraryDialogClosed
{
    libraryDialogShowing = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)didReceiveToken { }
- (void)didFailToSignIn:(BOOL)showMessage
{
    if (showMessage)
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Log In Failed"
                                                         message:@"An error occurred while attempting to sign you in.  Please try again."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil] autorelease];
        [alert show];
    }

#ifdef LILLI
    [UIView beginAnimations:@"fade" context:nil];
    [self setSignOutButtonTitle:@"Home"];
     myNotSignedInLabel.text = @"You are not currently signed in.";
    [UIView commitAnimations];
#else
    [[self navigationController] popToRootViewControllerAnimated:YES];
#endif
}

- (void)didReachTokenUrl
{
//    DLog(@"");
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return ([[UserModel getUserModel] currentUser]) ? @"Currently Signed In As" : nil;
    else
        return ([[[UserModel getUserModel] signinHistory] count]) ? @"Previously Signed In As" : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            if ([[UserModel getUserModel] currentUser])
                return 1;
            else
                return 0;
        case 1:
            return [[[UserModel getUserModel] signinHistory] count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellSignInHistory *cell =
        (UITableViewCellSignInHistory*)[tableView dequeueReusableCellWithIdentifier:@"cachedCell"];

    if (!cell || indexPath.section == 0)
        cell = [[[UITableViewCellSignInHistory alloc]
             initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cachedCell"] autorelease];

    NSDictionary *userForCell = (indexPath.section == 0) ?
                                    [[UserModel getUserModel] currentUser] :
                                    [[[UserModel getUserModel] signinHistory] objectAtIndex:indexPath.row];

    NSString *identifier = [userForCell objectForKey:@"identifier"];
    NSDictionary* userProfile = [[[[UserModel getUserModel] userProfiles] objectForKey:identifier] objectForKey:@"profile"];


    NSString* displayName = [UserModel getDisplayNameFromProfile:userProfile];
    NSString* subtitle = [userForCell objectForKey:@"timestamp"];
    NSString *imagePath = [NSString stringWithFormat:@"icon_%@_30x30.png",
                           [userForCell objectForKey:@"provider"]];

    cell.textLabel.text = displayName;
    cell.detailTextLabel.text = subtitle;
    cell.imageView.image = [UIImage imageNamed:imagePath];

    if (!iPad)
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserModel *model = [UserModel getUserModel];

    if (indexPath.section == 0)
        [model setSelectedUser:[model currentUser]];
    else
        [model setSelectedUser:[[model signinHistory] objectAtIndex:indexPath.row]];

    if (iPad)
    {
        [level2ViewController clearUser:NO];
        [level2ViewController loadUser:YES];
        [mySelectedProfilePad setText:level2ViewController.title];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [[self navigationController] pushViewController:level2ViewController animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return NO;

    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat headerAlpha = myTableView.tableHeaderView.alpha;

    if (editingStyle == UITableViewCellEditingStyleDelete)
    {/* Remove this profile from the Model's saved history. */
        [[UserModel getUserModel] removeUserFromHistory:indexPath.row];

     /* If that profile was the last one in the list of previous users... */
        if (![[[UserModel getUserModel] signinHistory] count])
        {
            if (![[UserModel getUserModel] currentUser])
            {
                [[self navigationController] popViewControllerAnimated:YES];
            }

            [self setDoneToEdit];

            [myTableView beginUpdates];
            [myTableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                       withRowAnimation:UITableViewRowAnimationTop];
            [myTableView endUpdates];

            [myTableView setEditing:NO animated:YES];
        }
        else
        {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }

        myTableView.tableHeaderView.alpha = headerAlpha;
    }
}

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (iPad)
    {
        [level2ViewController clearUser:YES];
        [self fadeCustomNavigationBarItems:0.0];

        if (libraryDialogShowing)
            [[UserModel getUserModel] triggerAuthenticationDidCancel:self];
    }

    if ([[UserModel getUserModel] pendingCallToTokenUrl])
        [[UserModel getUserModel] setTokenUrlDelegate:nil];
}

- (void)viewDidUnload { [super viewDidUnload]; }

- (void)dealloc
{
    [myTableView release];
    [myLabelContainerView release];
    [myNotSignedInLabel release];
    [mySignOutButtonPhone release];
    [mySignOutButtonPad release];
    [myEditButtonContainer release];
    [myEditButtonPad release];
    [myDoneButtonPad release];
    [myTitlePad release];
    [mySplitViewPad release];
    [mySelectedProfilePad release];
    [myRightView release];
    [level2ViewController release];

    [super dealloc];
}
@end
