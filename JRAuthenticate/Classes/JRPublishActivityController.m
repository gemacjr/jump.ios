//
//  JRPublishActivityController.m
//  JRAuthenticate
//
//  Created by lilli on 7/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define DEBUG
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


#import "JRPublishActivityController.h"

@interface JRPublishActivityController ()
- (void)addProvidersToTabBar;
- (void)showUserAsLoggedIn:(BOOL)loggedIn;
- (void)showActivityAsShared:(BOOL)shared;
- (void)showViewIsLoading:(BOOL)loading;
- (void)loadActivityToView;
- (void)setImageView:(UIImageView*)imageView toData:(NSData*)data andSetLoading:(UIActivityIndicatorView*)actIndicator toLoading:(BOOL)loading;
- (void)shareActivity;
- (void)loadUserNameAndProfilePicForUser:(JRAuthenticatedUser*)user atProviderIndex:(NSUInteger)index;
@end


@implementation JRPublishActivityController
@synthesize keyboardToolbar;
@synthesize shareButton;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    DLog(@"");
    
    [super viewDidLoad];

	sessionData = [JRSessionData jrSessionData];
	activity = [sessionData activity];
    
    [self loadActivityToView];
    
	/* If the user calls the library before the session data object is done initializing - 
     because either the requests for the base URL or provider list haven't returned - 
     display the "Loading Providers" label and activity spinner. 
     sessionData = nil when the call to get the base URL hasn't returned
     [sessionData.configuredProviders count] = 0 when the provider list hasn't returned */
	if (![sessionData configurationComplete] || !([[sessionData socialProviders] count] > 0))
	{
        [self showViewIsLoading:YES];
		
		/* Now poll every few milliseconds, for about 16 seconds, until the provider list is loaded or we time out. */
		timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkSessionDataAndProviders:) userInfo:nil repeats:NO];
	}
	else 
	{
        ready = YES;
        [self addProvidersToTabBar];
	}
    
    DLog(@"prov count = %d", [[sessionData socialProviders] count]);
	
	title_label = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    DLog(@"");
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardDidShow:) 
                                                 name:UIKeyboardDidShowNotification 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardDidHide:) 
                                                 name:UIKeyboardDidHideNotification 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];
    
 	self.title = @"Share";
	
	if (!title_label)
	{
		title_label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
		title_label.backgroundColor = [UIColor clearColor];
		title_label.font = [UIFont boldSystemFontOfSize:20.0];
		title_label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
		title_label.textAlignment = UITextAlignmentCenter;
		title_label.textColor = [UIColor whiteColor];
	}

	title_label.text = @"Share";
	self.navigationItem.titleView = title_label;
    
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] 
									  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
									  target:sessionData
									  action:@selector(publishingDidCancel:)] autorelease];
	
	self.navigationItem.leftBarButtonItem = cancelButton;
	self.navigationItem.leftBarButtonItem.enabled = YES;
	
	self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered;

    UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] 
									initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
									target:self
									action:@selector(editButtonPressed:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = editButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;

    [keyboardToolbar setFrame:CGRectMake(0, 416, 320, 44)];

    if (ready)
        [self loadActivityToView];
}

- (void)viewDidAppear:(BOOL)animated
{
    DLog(@"");
	[super viewDidAppear:animated];

    if (ready)
        [self showViewIsLoading:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLog(@"");
    [sessionData publishingDidCancelWithError];
}

/* If the user calls the library before the session data object is done initializing - 
 because either the requests for the base URL or provider list haven't returned - 
 keep polling every few milliseconds, for about 16 seconds, 
 until the provider list is loaded or we time out. */
- (void)checkSessionDataAndProviders:(NSTimer*)theTimer
{
	static NSTimeInterval interval = 0.125;
	interval = interval + 0.5;
	
	DLog(@"prov count = %d", [[sessionData socialProviders] count]);
	DLog(@"interval = %f", interval);
	      
    /* If we have our list of providers, stop the progress indicators and load the table. */
	if ([sessionData configurationComplete] || ([[sessionData socialProviders] count] > 0))
	{
        ready = YES;
        
        [self showViewIsLoading:NO];
		
        [self addProvidersToTabBar];
        [self loadActivityToView];
        
		return;
	}
	
	/* Otherwise, keep polling until we've timed out. */
	if (interval >= 16.0)
	{	
		DLog(@"No Available Providers");

        [self showViewIsLoading:NO];
        
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"No Available Providers" message:
                               
@"There are no available providers. \
Either there is a problem connecting \
or no providers have been configured. \
Please try again later."
                               
														delegate:self
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil] autorelease];

		[alert show];
        
        //[timer release];
        timer = nil;
		
        return;
	}
	
	timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkSessionDataAndProviders:) userInfo:nil repeats:NO];
}

- (void)addProvidersToTabBar
{
    DLog(@"");
    NSMutableArray *providerTabArr = [[NSMutableArray alloc] initWithCapacity:[[sessionData socialProviders] count]];
    NSInteger indexOfLastUsedProvider = 0;
    
    for (int i = 0; i < [[sessionData socialProviders] count]; i++)
    {
        JRProvider *provider = [[sessionData getSocialProviderAtIndex:i] retain];
        
        if (!provider)
            break;
        
        NSString *imagePath = [NSString stringWithFormat:@"jrauth_%@_greyscale.png", provider.name];
        UITabBarItem *providerTab = [[[UITabBarItem alloc] initWithTitle:provider.friendlyName 
                                                                   image:[UIImage imageNamed:imagePath]
                                                                     tag:[providerTabArr count]] autorelease];
        
        [providerTabArr insertObject:providerTab atIndex:[providerTabArr count]];
        
        if ([provider isEqualToProvider:[sessionData returningSocialProvider]])
            indexOfLastUsedProvider = i;
        
        [provider release];
    }
    
    [myTabBar setItems:providerTabArr animated:YES];
    
    // TODO: Make this be the provider most commonly used
    // TODO: Do we need both of these?
    if ([providerTabArr count])
    {
        myTabBar.selectedItem = [providerTabArr objectAtIndex:indexOfLastUsedProvider];
        [self tabBar:myTabBar didSelectItem:[providerTabArr objectAtIndex:indexOfLastUsedProvider]];
    }
    
    [providerTabArr release];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    DLog(@"");
    [selectedProvider release];
    [loggedInUser release];
    
    selectedProvider = [[sessionData getSocialProviderAtIndex:item.tag] retain];
    [sessionData setCurrentProvider:selectedProvider];
    
    loggedInUser = [[sessionData authenticatedUserForProvider:selectedProvider] retain];
    
    activity.user_generated_content = myUserContentTextView.text;
    
    if (loggedInUser)
    {
        [self showUserAsLoggedIn:YES];
        [self loadUserNameAndProfilePicForUser:loggedInUser atProviderIndex:item.tag];
    }
    else
    {
        [self showUserAsLoggedIn:NO];
    }
    
    myProviderIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"jrauth_%@_icon.png", selectedProvider.name]];
    
    [self loadActivityToView];
    [self showActivityAsShared:NO];
}

- (void)doneButtonPressed:(id)sender
{
    [myUserContentTextView resignFirstResponder];
    [myUserContentTextView scrollRangeToVisible:NSRangeFromString(myUserContentTextView.text)];
    //    [myUserContentTextView scrollRectToVisible:CGRectMake(0, 0, 300, 125) animated:YES];
	
    UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] 
									initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
									target:self
									action:@selector(editButtonPressed:)] autorelease];
    
	self.navigationItem.rightBarButtonItem = editButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;	
}

- (void)editButtonPressed:(id)sender
{
    [myUserContentTextView becomeFirstResponder];
    
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] 
									initWithBarButtonSystemItem:UIBarButtonSystemItemDone
									target:self
									action:@selector(doneButtonPressed:)] autorelease];
    
	self.navigationItem.rightBarButtonItem = doneButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;
}

- (void)showUserAsLoggedIn:(BOOL)loggedIn
{
    [UIView beginAnimations:@"buttonSlide" context:nil];

    [myJustShareButton setHidden:!loggedIn];
    [myConnectAndShareButton setHidden:loggedIn];
    
//    [mySharedLabel setHidden:loggedIn];
//    [mySharedCheckMark setHidden:loggedIn];
    
    [myProfilePic setHidden:!loggedIn];
    [myUserName setHidden:!loggedIn];
    [mySettingsButton setHidden:!loggedIn];
    [UIView commitAnimations];
    
    
//    [UIView setAnimationDuration:2];
//    if (loggedIn)
//    {
//        [myConnectAndShareButton setFrame:CGRectMake(165,//myConnectAndShareButton.frame.origin.x,// + 155,
//                                                     myConnectAndShareButton.frame.origin.y, 
//                                                     145,//myConnectAndShareButton.frame.size.width, 
//                                                     myConnectAndShareButton.frame.size.height)];
//        [myConnectAndShareButton setBackgroundImage:[UIImage imageNamed:@"blue_button_145x37.png"] forState:UIControlStateNormal];
//        [myConnectAndShareButton setBackgroundImage:[UIImage imageNamed:@"blue_button_145x37.png"] forState:UIControlStateSelected];
//        [myConnectAndShareButton setTitle:@"Share" forState:UIControlStateNormal];
//        [myConnectAndShareButton setTitle:@"Share" forState:UIControlStateSelected];
//    }
//    else
//    {
//        [UIView setAnimationRepeatAutoreverses:YES];
//        [myConnectAndShareButton setFrame:CGRectMake(10,//myConnectAndShareButton.frame.origin.x,// - 155,
//                                                     myConnectAndShareButton.frame.origin.y, 
//                                                     300,//myConnectAndShareButton.frame.size.width,
//                                                     myConnectAndShareButton.frame.size.height)];
//        [myConnectAndShareButton setBackgroundImage:[UIImage imageNamed:@"blue_button_300x37.png"] forState:UIControlStateNormal];
//        [myConnectAndShareButton setBackgroundImage:[UIImage imageNamed:@"blue_button_300x37.png"] forState:UIControlStateSelected];
//        [myConnectAndShareButton setTitle:@"Connect and Share" forState:UIControlStateNormal];
//        [myConnectAndShareButton setTitle:@"Connect and Share" forState:UIControlStateSelected];
//    } 
}

- (void)showActivityAsShared:(BOOL)shared
{
    DLog(@"");
    [mySharedLabel setHidden:!shared];
    [mySharedCheckMark setHidden:!shared];
    
    if (loggedInUser)
        [myJustShareButton setHidden:shared];
    else
        [myConnectAndShareButton setHidden:shared];
    
    UIBarButtonItem *barButton;
    if (shared)
    {
        barButton = [[[UIBarButtonItem alloc] initWithTitle:@"Close" 
                                                      style:UIBarButtonItemStyleBordered 
                                                     target:sessionData 
                                                     action:@selector(publishingDidComplete:)] autorelease];
    }
    else
    {
        barButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                   target:sessionData
                                                                   action:@selector(publishingDidCancel:)] autorelease];   
        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered;
    }

	self.navigationItem.leftBarButtonItem = barButton;
	self.navigationItem.leftBarButtonItem.enabled = YES;	
}

- (BOOL)providerCanShareMedia:(NSString*)provider
{
    DLog(@"");
    if ([provider isEqualToString:@"facebook"])
         return YES;
         
    return NO;
}

- (void)showViewIsLoading:(BOOL)loading
{
    DLog(@"");
    UIApplication* app = [UIApplication sharedApplication]; 
    app.networkActivityIndicatorVisible = loading;
    
    [myLoadingGrayView setHidden:!loading];
    
    if (loading)
        [myLoadingActivitySpinner startAnimating];
    else
        [myLoadingActivitySpinner stopAnimating];    
}

- (void)loadActivityToView:(JRActivityObject*)_activity
{
    DLog(@"");
    
    if (!hasEditedBefore) 
        myUserContentTextView.text = _activity.action;
    else
        myUserContentTextView.text = _activity.user_generated_content;
    
//    NSInteger mediaOffset = 53;
    
    if ((ready) && ([_activity.media count] > 0) && ([self providerCanShareMedia:selectedProvider.name]))
    {
        [myMediaContentView setHidden:NO];
        
//        [myTitleLabel setFrame:CGRectMake(63, //myTitleLabel.frame.origin.x + mediaOffset, 
//                                          myTitleLabel.frame.origin.y,
//                                          227, //myTitleLabel.frame.size.width - mediaOffset, 
//                                          myTitleLabel.frame.size.height)];
//        [myDescriptionLabel setFrame:CGRectMake(63, //myDescriptionLabel.frame.origin.x + mediaOffset, 
//                                                myDescriptionLabel.frame.origin.y,
//                                                227, //myDescriptionLabel.frame.size.width - mediaOffset, 
//                                                myDescriptionLabel.frame.size.height)];        
        
        myTitleLabel.text = _activity.title;
        myDescriptionLabel.text = _activity.description;
        
        JRMediaObject *media = [_activity.media objectAtIndex:0];
        if ([media isKindOfClass:[JRImageMediaObject class]])
        {
            [self setImageView:myMediaThumbnailView toData:nil andSetLoading:myMediaThumbnailActivityIndicator toLoading:YES];

            NSURL        *url = [NSURL URLWithString:((JRImageMediaObject*)media).src];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
            NSString     *tag = [[NSString alloc] initWithFormat:@"getThumbnail"];
            
            [JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag stringEncodeData:NO];
            
            [request release];            
        }   
    }
    else 
    {
        [myMediaContentView setHidden:YES];
//        [myMediaContentView setHidden:NO];
//        
//        [myTitleLabel setFrame:CGRectMake(10, //myTitleLabel.frame.origin.x - mediaOffset, 
//                                          myTitleLabel.frame.origin.y,
//                                          280, //myTitleLabel.frame.size.width + mediaOffset, 
//                                          myTitleLabel.frame.size.height)];
//        [myDescriptionLabel setFrame:CGRectMake(10, //myDescriptionLabel.frame.origin.x - mediaOffset, 
//                                                myDescriptionLabel.frame.origin.y,
//                                                280, //myDescriptionLabel.frame.size.width + mediaOffset, 
//                                                myDescriptionLabel.frame.size.height)];
//        
//        myTitleLabel.text = activity.title;
//        myDescriptionLabel.text = activity.description;
    }
}


- (void)loadActivityToView
{
    [self loadActivityToView:activity];
}

- (void)fetchProfilePicFromUrl:(NSString*)profilePicUrl atProviderIndex:(NSUInteger)index
{
    DLog(@"");
    [self setImageView:myProfilePic toData:nil andSetLoading:myProfilePicActivityIndicator toLoading:YES];
    
    NSURL        *url = [NSURL URLWithString:profilePicUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSString     *tag = [[NSString alloc] initWithFormat:@"getProfilePic_%u", index];
    
    [JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag stringEncodeData:NO];
    
    [request release];
}

- (UIImage*)getCachedImageForUser:(JRAuthenticatedUser*)user
{
    // TODO: Implement this!!
    return nil;
}

- (void)setProfilePicToDefaultPic:(UIImageView*)imageView atProviderIndex:(NSUInteger)index
{
    imageView.image = nil;
    imageView.backgroundColor = [UIColor darkGrayColor];
    [myProfilePicActivityIndicator stopAnimating];
}

- (void)loadUserNameAndProfilePicForUser:(JRAuthenticatedUser*)user atProviderIndex:(NSUInteger)index
{   
    DLog(@"");
    myUserName.text = user.preferred_username;
    [myUserName setFrame:CGRectMake(65, 10, 80, 37)];
    
    if (user.photo)
        [self fetchProfilePicFromUrl:user.photo atProviderIndex:index];    
    else
        [self setProfilePicToDefaultPic:myProfilePic atProviderIndex:index];
}

- (void)shareActivity
{
    DLog(@"");
    
    if (myUserContentTextView.text && hasEditedBefore)
        activity.user_generated_content = myUserContentTextView.text;
    
    [sessionData shareActivity:activity forUser:loggedInUser];
}

- (IBAction)shareButtonPressed:(id)sender
{
    DLog(@"");
    
    [sessionData setCurrentProvider:selectedProvider];
    [self showViewIsLoading:YES];
    
    if (!loggedInUser)
    {
        justAuthenticated = YES;
        
        /* If the selected provider requires input from the user, go to the user landing view.
         Or if the user started on the user landing page, went back to the list of providers, then selected 
         the same provider as their last-used provider, go back to the user landing view. */
        if (selectedProvider.requiresInput)
        {	
            [[self navigationController] pushViewController:[JRUserInterfaceMaestro jrUserInterfaceMaestro].myUserLandingController
                                                   animated:YES]; 
        }
        /* Otherwise, go straight to the web view. */
        else
        {
            [[self navigationController] pushViewController:[JRUserInterfaceMaestro jrUserInterfaceMaestro].myWebViewController
                                                   animated:YES]; 
        }
    }
    else
    {
        [self shareActivity];
    }
}

- (void)keyboardWillShow:(NSNotification *)notif
{
    DLog(@"");
    [UIView beginAnimations:@"editing" context:nil];
    [myUserContentTextView setFrame:CGRectMake(myUserContentTextView.frame.origin.x, 
                                               myUserContentTextView.frame.origin.y, 
                                               myUserContentTextView.frame.size.width, 
                                               myUserContentTextView.frame.size.height + 60)];
    [myUserContentBoundingBox setFrame:CGRectMake(myUserContentBoundingBox.frame.origin.x, 
                                                  myUserContentBoundingBox.frame.origin.y, 
                                                  myUserContentBoundingBox.frame.size.width, 
                                                  myUserContentBoundingBox.frame.size.height + 60)];
    [myMediaContentView setFrame:CGRectMake(myMediaContentView.frame.origin.x, 
                                            myMediaContentView.frame.origin.y + 60, 
                                            myMediaContentView.frame.size.width, 
                                            myMediaContentView.frame.size.height)];
    
    //myUserContentTextView.frame.size.height = myUserContentTextView.frame.size.height + 40;
    //myMediaContentView.frame.origin.y = myMediaContentView.frame.origin.y + 40;
    [UIView commitAnimations];
    
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] 
									initWithBarButtonSystemItem:UIBarButtonSystemItemDone
									target:self
									action:@selector(doneButtonPressed:)] autorelease];
    
	self.navigationItem.rightBarButtonItem = doneButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered; 
}

- (void)keyboardDidShow:(NSNotification *)notif
{
    
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    DLog(@"");
    [UIView beginAnimations:@"editing" context:nil];
    [myUserContentTextView setFrame:CGRectMake(myUserContentTextView.frame.origin.x, 
                                               myUserContentTextView.frame.origin.y, 
                                               myUserContentTextView.frame.size.width, 
                                               myUserContentTextView.frame.size.height - 60)];
    [myUserContentBoundingBox setFrame:CGRectMake(myUserContentBoundingBox.frame.origin.x, 
                                               myUserContentBoundingBox.frame.origin.y, 
                                               myUserContentBoundingBox.frame.size.width, 
                                               myUserContentBoundingBox.frame.size.height - 60)];
    [myMediaContentView setFrame:CGRectMake(myMediaContentView.frame.origin.x, 
                                            myMediaContentView.frame.origin.y - 60, 
                                            myMediaContentView.frame.size.width, 
                                            myMediaContentView.frame.size.height)];    
    [UIView commitAnimations];
    
    UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] 
									initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
									target:self
									action:@selector(editButtonPressed:)] autorelease];
    
	self.navigationItem.rightBarButtonItem = editButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;    
}

- (void)keyboardDidHide:(NSNotification *)notif
{
//    [keyboardToolbar setHidden:YES];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    DLog(@"");
    if (!hasEditedBefore)
    {
        myUserContentTextView.text = @"";
        hasEditedBefore = YES;
    }
    
    
    [UIView beginAnimations:@"editing" context:nil];
    [myUserContentTextView setFrame:CGRectMake(myUserContentTextView.frame.origin.x, 
                                               myUserContentTextView.frame.origin.y, 
                                               myUserContentTextView.frame.size.width, 
                                               myUserContentTextView.frame.size.height + 40)];
    [myMediaContentView setFrame:CGRectMake(myMediaContentView.frame.origin.x, 
                                            myMediaContentView.frame.origin.y + 40, 
                                            myMediaContentView.frame.size.width, 
                                            myMediaContentView.frame.size.height)];

    //myUserContentTextView.frame.size.height = myUserContentTextView.frame.size.height + 40;
    //myMediaContentView.frame.origin.y = myMediaContentView.frame.origin.y + 40;
    [UIView commitAnimations];

    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] 
									initWithBarButtonSystemItem:UIBarButtonSystemItemDone
									target:self
									action:@selector(doneButtonPressed:)] autorelease];
    
	self.navigationItem.rightBarButtonItem = doneButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;    
    
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    DLog(@"");
    [UIView beginAnimations:@"editing" context:nil];
    [myUserContentTextView setFrame:CGRectMake(myUserContentTextView.frame.origin.x, 
                                               myUserContentTextView.frame.origin.y, 
                                               myUserContentTextView.frame.size.width, 
                                               myUserContentTextView.frame.size.height - 40)];
    [myMediaContentView setFrame:CGRectMake(myMediaContentView.frame.origin.x, 
                                            myMediaContentView.frame.origin.y - 40, 
                                            myMediaContentView.frame.size.width, 
                                            myMediaContentView.frame.size.height)];    
    [UIView commitAnimations];
    
    UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] 
									initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
									target:self
									action:@selector(editButtonPressed:)] autorelease];
    
	self.navigationItem.rightBarButtonItem = editButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;    
    
    return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [sessionData forgetAuthenticatedUserForProvider:selectedProvider.name];
            [loggedInUser release];
            loggedInUser = nil;
            [self showUserAsLoggedIn:NO];
            [self showActivityAsShared:NO];
            break;
        default:
            break;
    }
}


- (IBAction)settingsButtonPressed:(id)sender
{
    DLog(@"");
    
	UIActionSheet *action = [[[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:
                                                                   @"You are currently signed in to %@%@. Would you like to sign out?",
                                                                   selectedProvider.friendlyName, 
                                                                   (loggedInUser.preferred_username) ? 
                                                                   [NSString stringWithFormat:@" as %@", loggedInUser.preferred_username] : @""]
														 delegate:self
												cancelButtonTitle:@"Cancel"  
										   destructiveButtonTitle:@"OK"
												otherButtonTitles:nil] autorelease];
	action.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[action showInView:self.view];
}

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
    DLog(@"");
    NSString* tag = (NSString*)userdata; 
	[payload retain];
	
	DLog(@"request (retain count: %d): %@", [request retainCount], [[request URL] absoluteString]);
	DLog(@"payload (retain count: %d): %@", [payload retainCount], payload);
	DLog(@"tag     (retain count: %d): %@", [tag retainCount], tag);
    
    
	[tag release];	
}

- (void)setImageView:(UIImageView*)imageView toData:(NSData*)data andSetLoading:(UIActivityIndicatorView*)actIndicator toLoading:(BOOL)loading
{
    DLog(@"");
    DLog(@"data retain count: %d", [data retainCount]);    
    
    if (!data)
    {
        imageView.image = nil;
        imageView.backgroundColor = [UIColor darkGrayColor];
    }
    else
    {
        imageView.image = [UIImage imageWithData:data];
        imageView.backgroundColor = [UIColor whiteColor];
    }
    
    if (loading)
        [actIndicator startAnimating];
    else
        [actIndicator stopAnimating];
    
    DLog(@"data retain count: %d", [data retainCount]);
}

- (void)connectionDidFinishLoadingWithUnEncodedPayload:(NSData*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
    DLog(@"");
    NSString* tag = (NSString*)userdata; 
	
	DLog(@"request (retain count: %d): %@", [request retainCount], [[request URL] absoluteString]);
	DLog(@"tag     (retain count: %d): %@", [tag retainCount], tag);
    DLog(@"data retain count: %d", [payload retainCount]);
    
    if ([tag isEqualToString:@"getThumbnail"])
    {
        [self setImageView:myMediaThumbnailView toData:payload andSetLoading:myMediaThumbnailActivityIndicator toLoading:NO];
    }
    else if ([tag isEqualToString:[NSString stringWithFormat:@"getProfilePic_%d", [myTabBar selectedItem].tag]])
    {
        [self setImageView:myProfilePic toData:payload andSetLoading:myProfilePicActivityIndicator toLoading:NO];
    }

	[tag release];	    
    DLog(@"data retain count: %d", [payload retainCount]);
}

- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(void*)userdata 
{
    DLog(@"");
    NSString* tag = (NSString*)userdata;
	[tag release];	
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Shared"
                                                     message:@"There was an error while sharing this activity."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK" 
                                           otherButtonTitles:nil] autorelease];
    [alert show];
    
    [self showViewIsLoading:NO];
    
    
    DLog("There was an error in sharing/n");    
}

- (void)connectionWasStoppedWithTag:(void*)userdata 
{
	DLog(@"");
    [(NSString*)userdata release];
}

- (void)authenticationDidRestart { DLog(@""); } 
- (void)authenticationDidCancel { DLog(@""); justAuthenticated = NO; }
- (void)authenticationDidCompleteWithToken:(NSString*)token forProvider:(NSString*)provider 
{
    DLog(@"");
    
    // TODO: Will this work with the custom view controller?!?!?!
    //[[self navigationController] popToRootViewControllerAnimated:YES];
    
    myLoadingLabel.text = @"Sharing...";
    
    loggedInUser = [[sessionData authenticatedUserForProvider:selectedProvider] retain];
    
    if (loggedInUser)
    {
        [self showViewIsLoading:YES];
        [self loadUserNameAndProfilePicForUser:loggedInUser atProviderIndex:[myTabBar selectedItem].tag];
        [self showUserAsLoggedIn:YES];
        
        [self shareActivity];
    }
    else 
    {  
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Shared"
                                                         message:@"There was an error while sharing this activity."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil] autorelease];
        [alert show];
        [self showViewIsLoading:NO];
    }
}

- (void)authenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider { DLog(@""); justAuthenticated = NO; }
- (void)authenticateDidReachTokenUrl:(NSString*)tokenUrl withPayload:(NSString*)tokenUrlPayload forProvider:(NSString*)provider { DLog(@""); }
- (void)authenticateCallToTokenUrl:(NSString*)tokenUrl didFailWithError:(NSError*)error forProvider:(NSString*)provider { DLog(@""); }


- (void)publishingActivityDidSucceed:(JRActivityObject*)activity forProvider:(NSString*)provider;
{
    DLog(@"");
    
//    NSMutableArray *remainingProviders = [[NSMutableArray alloc] initWithCapacity:5];
//    NSMutableString *remainingProviderNames = [[NSMutableString alloc] initWithFormat:@""];
//
//    for (NSString* remainingProviderName in sessionData.socialProviders)
//    {
//        JRProvider *remainingProvider = [sessionData.allProviders objectForKey:remainingProviderName];
//        if ([sessionData authenticatedUserForProvider:remainingProvider] && ![remainingProvider.name isEqualToString:provider])
//        {
//            [remainingProviders addObject:remainingProvider];
//            [remainingProviderNames appendFormat:@"%@, ", remainingProvider.friendlyName];
//        }
//    }
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Shared"
                                                     message:[NSString stringWithFormat:
                                                              @"You have successfully shared this activity."]// on %@.\nWould you like to share it on %@ as well?", 
                                                                //provider, remainingProviderNames]
                                                    delegate:nil//self
                                           cancelButtonTitle:@"OK" 
                                           otherButtonTitles:nil] autorelease];//@"No thanks", nil] autorelease];
    [alert show];
    
    [self showViewIsLoading:NO];
    [self showActivityAsShared:YES];
    
    justAuthenticated = NO;
    // TODO: Move this to somewhere more logical -- hack for now    
    //    [sessionData setSocial:NO];
    //    [sessionData removeDelegate:self];
}

- (void)publishingActivityDidFail:(JRActivityObject*)activity forProvider:(NSString*)provider { }

- (void)publishingDidRestart { }
- (void)publishingDidCancel { DLog(@""); }
- (void)publishingDidComplete { DLog(@""); }
- (void)publishingDidFailWithError:(NSError*)error forProvider:(NSString*)provider { }

- (void)publishingActivity:(JRActivityObject*)activity didFailWithError:(NSError*)error
{
    DLog(@"");
    NSString *errorMessage = nil;
//    BOOL closeDialog = NO;
    BOOL reauthenticate = NO;

    [self showViewIsLoading:NO];
    
    switch (error.code)
    {
        case JRPublishFailedError:
            errorMessage = [NSString stringWithFormat:
                            @"There was an error while sharing this activity: %@", (error) ? [error localizedDescription] : @""];
//            closeDialog = YES;
            break;
        case JRPublishErrorDuplicateTwitter:
            errorMessage = [NSString stringWithFormat:
                            @"There was an error while sharing this activity: Twitter does not allow duplicate status updates."];
//            closeDialog = NO;
            break;
        case JRPublishErrorLinkedInCharacterExceded:
            errorMessage = [NSString stringWithFormat:
                            @"There was an error while sharing this activity: Status was too long."];
//            closeDialog = NO;
            break;
        case JRPublishErrorMissingApiKey:
            errorMessage = [NSString stringWithFormat:
                            @"There was an error while sharing this activity: %@", (error) ? [error localizedDescription] : @""];
            reauthenticate = YES;
            break;
        case JRPublishErrorInvalidOauthToken:
            errorMessage = [NSString stringWithFormat:
                            @"There was an error while sharing this activity: %@", (error) ? [error localizedDescription] : @""];
            reauthenticate = YES;
            break;
        default:
            errorMessage = [NSString stringWithFormat:
                            @"There was an error while sharing this activity: %@", (error) ? [error localizedDescription] : @""];
//            closeDialog = YES;
            break;
    }    

    /* OK, if this gets called right after authentication succeeds, then the navigation controller won't be done
       animating back to this view.  If this view isn't loaded yet, and we call shareButtonPressed, then the library
       will end up trying to push the webview controller onto the navigation controller while the navigation controller 
       is still trying to pop the webview.  This creates craziness, hence we check for [self isViewLoaded].
       Also, this prevents an infinite loop of reauthing-failed publishing-reauthing-failed publishing.
       So, only try and reauthenticate is the publishing activity view is already loaded, which will only happen if we didn't
       JUST try and authorize, or if sharing took longer than the time it takes to pop the view controller. */
    if (reauthenticate && !justAuthenticated)
    {
        [sessionData forgetAuthenticatedUserForProvider:selectedProvider.name];
        [loggedInUser release];
        loggedInUser = nil;
        
        [self showUserAsLoggedIn:NO];
        [self shareButtonPressed:nil];

        return;
    }
    
    justAuthenticated = NO;
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Shared"
                                                     message:errorMessage
                                                    delegate:nil
                                           cancelButtonTitle:@"OK" 
                                           otherButtonTitles:nil] autorelease];
    [alert show];
    
}



//- (IBAction)doneButtonPressed:(id)sender
//{
//    DLog(@"");
//    //    [hideKeyboardButton removeFromSuperview];
//    [myUserContentTextView resignFirstResponder];    
//}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillDisappear:(BOOL)animated
{
    DLog(@"");
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    DLog(@"");
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    DLog(@"");
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)userInterfaceWillClose
{
    DLog(@"");
    [self showViewIsLoading:NO];
    
    // TODO: Verify that this won't cause issues if set and the dialog closes for various reasons
    [timer invalidate];
    
    [self loadActivityToView:nil];
}

- (void)userInterfaceDidClose
{
    
}

- (void)dealloc
{
    DLog(@"");
    
    [super dealloc];
}

@end
