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


 File:	 QSIViewControllerLevel1.m 
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import "QSIViewControllerLevel1.h"

@interface UITableViewCellSignInHistory : UITableViewCell 
{
	UIImageView *icon;
}
@property (nonatomic, retain) UIImageView *icon;
@end

@implementation UITableViewCellSignInHistory
@synthesize icon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		[self addSubview:icon];
	}
	
	return self;
}	

- (void) layoutSubviews 
{
	[super layoutSubviews];
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        self.imageView.frame = CGRectMake(30, 20, 60, 60);
//        self.textLabel.frame = CGRectMake(115, 15, 550, 35);
//        self.detailTextLabel.frame = CGRectMake(115, 60, 500, 25);
//        
//        self.textLabel.font = [UIFont systemFontOfSize:30];
//        self.detailTextLabel.font = [UIFont systemFontOfSize:20];
//    }
//    else
//    {
        self.imageView.frame = CGRectMake(10, 10, 30, 30);
        self.textLabel.frame = CGRectMake(50, 15, 100, 22);
        self.detailTextLabel.frame = CGRectMake(160, 20, 100, 15);
//    }
}
@end

@interface ViewControllerLevel1 ()
- (void)toggleTableHeaderVisibility:(BOOL)visible;
- (void)setSignOutButtonTitle:(NSString*)newTitle;
- (void)setEditToDone;
- (void)setDoneToEdit;
- (void)setEditButtonEnabled:(BOOL)disabled;
@end

@implementation ViewControllerLevel1
//@synthesize myTableView;
//@synthesize myToolBarButton;
//@synthesize myNotSignedInLabel;
//@synthesize myRightView;

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
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        iPad = YES;
    
    if (iPad)
        level2ViewController = [[ViewControllerLevel2 alloc] initWithNibName:@"QSIViewControllerLevel2-iPad" 
                                                                      bundle:[NSBundle mainBundle]];
    else
        level2ViewController = [[ViewControllerLevel2 alloc] initWithNibName:@"QSIViewControllerLevel2" 
                                                                      bundle:[NSBundle mainBundle]];	
    
    if (iPad)
    {
        [myRightView addSubview:level2ViewController.view];
        
        mySignOutButtonPad = 
            [[[UIBarButtonItem alloc] initWithTitle:@"Sign Out"
                                              style:UIBarButtonItemStyleBordered
                                             target:self
                                             action:@selector(signOutButtonPressed:)] autorelease];
        
        self.navigationItem.leftBarButtonItem = mySignOutButtonPad;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        
        UIView *buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(610, 0, 52, 44)];
        buttonContainer.backgroundColor = [UIColor clearColor];
        
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
        
        [buttonContainer addSubview:myDoneButtonPad];
        [buttonContainer addSubview:myEditButtonPad];
        
        [self.navigationController.navigationBar addSubview:buttonContainer];
    }        
    else
    {
        UIBarButtonItem *editButton = 
                            [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                           target:self
                                                                           action:@selector(editButtonPressed:)] autorelease];
        
        self.navigationItem.leftBarButtonItem = editButton;
        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered;  
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	self.title = @"Profiles";

	myTableView.backgroundColor = [UIColor clearColor];
	
    CGRect rect1 = self.view.frame;
    CGRect rect2 = [self.view convertRect:myTableView.frame toView:[[UIApplication sharedApplication] keyWindow]];
    
    NSLog(@"view 1:\t%f,\t%f,\t%f,\t%f", rect1.origin.x, rect1.origin.y, rect1.size.width, rect1.size.height);
    NSLog(@"v(t) 1:\t%f,\t%f,\t%f,\t%f", rect2.origin.x, rect2.origin.y, rect2.size.width, rect2.size.height);
    
	UIBarButtonItem *addAnotherButton = [[[UIBarButtonItem alloc] 
										  initWithTitle:@"Add a Profile" 
										  style:UIBarButtonItemStyleBordered
										  target:self
										  action:@selector(addAnotherButtonPressed:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = addAnotherButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	self.navigationItem.hidesBackButton = YES;
    
    [self setDoneToEdit];

	myTableView.tableHeaderView = myLabelContainerView;//myNotSignedInLabel;
        
    if ([[[UserModel getUserModel] signinHistory] count])
        [self setEditButtonEnabled:YES];
    else
        [self setEditButtonEnabled:NO];
    
    if (![[UserModel getUserModel] currentUser])
	{
		[self setSignOutButtonTitle:@"Home"];
        [self toggleTableHeaderVisibility:YES];
//        myTableView.tableHeaderView.alpha = 1.0;
	}
	else
	{
		[self setSignOutButtonTitle:@"Sign Out"];
        [self toggleTableHeaderVisibility:NO];
//		myTableView.tableHeaderView.alpha = 0.0;
	}		
    
	if ([[UserModel getUserModel] loadingUserData])
		myNotSignedInLabel.text = @"Completing Sign In...";
	else
		myNotSignedInLabel.text = @"You are not currently signed in.";

    if (iPad)
        [[UserModel getUserModel] setCustomInterface:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                      self.navigationItem.rightBarButtonItem,
                                                      kJRPopoverPresentationBarButtonItem, nil]];
    
    
    [self.view becomeFirstResponder];
	[myTableView setEditing:NO animated:NO];
	[myTableView reloadData];
}	

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)toggleTableHeaderVisibility:(BOOL)visible
{
    if (visible)
        myTableView.tableHeaderView.alpha = 1.0;//myTableView.tableHeaderView = myLabelContainerView;
    else
        myTableView.tableHeaderView.alpha = 0.0;//myTableView.tableHeaderView = nil;
    
//    myTableView.tableHeaderView.alpha = visible ? 1.0 : 0.0;
//    myTableView.tableHeaderView.frame.    
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
//        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered;	    
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
//        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered;    
    }

    if ([[[UserModel getUserModel] signinHistory] count])
        [self setEditButtonEnabled:YES];
    else
        [self setEditButtonEnabled:NO];
}

- (void)doneButtonPressed:(id)sender
{
	[myTableView setEditing:NO animated:YES];
	[self setDoneToEdit];
}

- (void)editButtonPressed:(id)sender
{
    if (iPad)
        [level2ViewController clearUser:YES];

	[myTableView setEditing:YES animated:YES];
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
	myNotSignedInLabel.text = @"Completing Sign In...";
	
//#ifdef LILLI	

    if (iPad)
        [level2ViewController clearUser:YES];

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

//#else
//	[[UserModel getUserModel] startSignUserOut:self];
//	[NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(delaySignIn:) userInfo:nil repeats:NO];
//#endif
}

- (IBAction)signOutButtonPressed:(id)sender
{
//#ifdef LILLI	
    if (iPad)// && [myTableView indexPathForSelectedRow].section == 0)
        [level2ViewController clearUser:YES];

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
//	[NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(delaySignOut:) userInfo:nil repeats:NO];
//	[[self navigationController] popToRootViewControllerAnimated:YES];
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
//	 myTableView.tableHeaderView.alpha = 0.0;
	[UIView commitAnimations];
}

- (void)userDidSignOut
{
	NSIndexSet *set0 = [[[NSIndexSet alloc] initWithIndex:0] autorelease];
	NSIndexSet *set1 = [[[NSIndexSet alloc] initWithIndex:1] autorelease];	
    
	[self doneButtonPressed:nil];

//	if (iPad)
//    {
//        [myTableView beginUpdates];
//        [myTableView reloadSections:set0 withRowAnimation:UITableViewRowAnimationLeft];
//        [myTableView insertSections:set1 withRowAnimation:UITableViewRowAnimationLeft];
//        [myTableView endUpdates];        
//    }
//    else
//    {
        [myTableView beginUpdates];
        [myTableView reloadSections:set0 withRowAnimation:UITableViewRowAnimationFade];
        [myTableView reloadSections:set1 withRowAnimation:UITableViewRowAnimationLeft];
        [myTableView endUpdates];
//    }
	
	[UIView beginAnimations:@"fade" context:nil];
	[self setSignOutButtonTitle:@"Home"];
    [self toggleTableHeaderVisibility:YES];
//	 myTableView.tableHeaderView.alpha = 1.0;
	[UIView commitAnimations];
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
	

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0 || section == 1)
        return 30.0;
//    else
//        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section == 0)// || last section)
        return 30.0;
//    else
//        return 0;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section { return nil; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
	if (section == 0)
		return ([[UserModel getUserModel] currentUser]) ? @"Currently Signed In As" : nil;
	else// if (section == 1)
		return ([[[UserModel getUserModel] signinHistory] count]) ? @"Previously Signed In As" : nil;
//    else
//        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//	if (iPad)
//        return 100;
    
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
//    if (iPad)
//        return [[[UserModel getUserModel] signinHistory] count] + 1;
//    else
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
//    if (iPad)
//        return 1;
    
	switch (section)
	{
		case 0:
			if ([[UserModel getUserModel] currentUser])
				return 1;
			else 
				return 0;
			break;
		case 1:
			return [[[UserModel getUserModel] signinHistory] count];
			break;
		default:
			return 0;
			break;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCellSignInHistory *cell = 
	(UITableViewCellSignInHistory*)[tableView dequeueReusableCellWithIdentifier:@"cachedCell"];

//    NSInteger userIndex = (iPad) ? (indexPath.section - 1) : indexPath.row;
	
	if (!cell || indexPath.section == 0) 
		cell = [[[UITableViewCell alloc] 
			 initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cachedCell"] autorelease];
	
	
	NSDictionary *userForCell = (indexPath.section == 0) ? 
									[[UserModel getUserModel] currentUser] : 
									[[[UserModel getUserModel] signinHistory] objectAtIndex:indexPath.row/*userIndex*/];

	NSString *identifier = [userForCell objectForKey:@"identifier"];
	NSDictionary* userProfile = [[[[UserModel getUserModel] userProfiles] objectForKey:identifier] objectForKey:@"profile"];
	
	
	NSString* displayName = [UserModel getDisplayNameFromProfile:userProfile];
	NSString* subtitle = [userForCell objectForKey:@"timestamp"];
	NSString *imagePath = [NSString stringWithFormat:@"icon_%@_30x30.png",//@"icon_%@_30x30%@.png", 
                           [userForCell objectForKey:@"provider"]];//, 
//                            (iPad) ? @"@2x" : @"" ];
	
	cell.textLabel.text = displayName;
	cell.detailTextLabel.text = subtitle;
	cell.imageView.image = [UIImage imageNamed:imagePath];
	
//    if (iPad)
//    {
//        cell.textLabel.font = [UIFont systemFontOfSize:30];
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:20];
//    }
    
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UserModel *model = [UserModel getUserModel];
//    NSInteger userIndex = (iPad) ? (indexPath.section - 1) : indexPath.row;

	if (indexPath.section == 0)
		[model setSelectedUser:[model currentUser]];
	else
		[model setSelectedUser:[[model signinHistory] objectAtIndex:indexPath.row/*userIndex*/]];
	
    if (iPad)
    {
        [level2ViewController clearUser:NO];
        [level2ViewController loadUser:YES];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [[self navigationController] pushViewController:level2ViewController animated:YES];
    }
}
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath { }

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
//    NSInteger userIndex = (iPad) ? (indexPath.section - 1) : indexPath.row;

	if (editingStyle == UITableViewCellEditingStyleDelete)
	{/* Remove this profile from the Model's saved history. */ 
		[[UserModel getUserModel] removeUserFromHistory:indexPath.row/*userIndex*/];
			
     /* If that profile was the last one in the list of previous users... */
		if (![[[UserModel getUserModel] signinHistory] count])
		{
			if (![[UserModel getUserModel] currentUser]) 
			{
				[[self navigationController] popViewControllerAnimated:YES];
			}

			[self setDoneToEdit];
//			UIBarButtonItem *fillerButton = [[[UIBarButtonItem alloc]
//											initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//											target:nil
//											action:nil] autorelease];
//						
//			[self.navigationItem setLeftBarButtonItem:fillerButton animated:YES];

			[myTableView beginUpdates];
			[myTableView reloadSections:[NSIndexSet indexSetWithIndex:1] 
					   withRowAnimation:UITableViewRowAnimationTop];
			[myTableView endUpdates];
			
			[myTableView setEditing:NO animated:YES];
		}
		else
		{
//			if (iPad)
//                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
//            else
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];		
		}
		
		myTableView.tableHeaderView.alpha = headerAlpha;
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (iPad)
    {
        [level2ViewController clearUser:YES];
        [myEditButtonPad setHidden:YES];
        [myDoneButtonPad setHidden:YES];
    }
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc 
{       
    [myTableView release];
    [mySignOutButtonPhone release];
    [myNotSignedInLabel release];
	[level2ViewController release];	
	
	[super dealloc];
}
@end
