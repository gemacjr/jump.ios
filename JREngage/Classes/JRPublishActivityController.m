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
 
 File:	 JRPublishActivityController.m 
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, August 24, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#import "JRPublishActivityController.h"
#import "JREngage+CustomInterface.h"

@interface JRPublishActivityController ()
- (void)addProvidersToTabBar;
- (void)showActivityAsShared:(BOOL)shared;
- (void)showViewIsLoading:(BOOL)loading;
- (void)loadActivityToView;
- (void)loadUserNameAndProfilePicForUser:(JRAuthenticatedUser*)user forProvider:(NSString*)providerName;
@end

@implementation JRPublishActivityController
//@synthesize myBackgroundView;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil andCustomInterface:(NSDictionary*)_customInterface
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
    {
        customInterface = [_customInterface retain];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            iPad = YES;
        else
            iPad = NO;        
    }
    
    return self;
}

- (void)viewDidLoad 
{
    DLog(@"");
    
    [super viewDidLoad];

    alreadyShared = [[NSMutableSet alloc] initWithCapacity:4];
                        
	sessionData = [JRSessionData jrSessionData];
    activity = [[sessionData activity] retain];

    if ([[customInterface objectForKey:kJRSocialSharingTitleString] isKindOfClass:[NSString class]])
        self.title = [customInterface objectForKey:kJRSocialSharingTitleString];
    else
        self.title = @"Share";
    
    
    /** DEPRECATED - REMOVE LATER **/
    NSArray *backgroundColor = [customInterface objectForKey:kJRSocialSharingBackgroundColorRGBa];
    /** DEPRECATED - REMOVE LATER **/
    
    /* Load the custom background view, if there is one. */
    if ([customInterface objectForKey:kJRSocialSharingBackgroundImageView])
        [myBackgroundView addSubview:[customInterface objectForKey:kJRSocialSharingBackgroundImageView]];
    
    /** DEPRECATED - REMOVE LATER **/
    if ([customInterface objectForKey:kJRSocialSharingBackgroundImageName])
        [myBackgroundView addSubview:[[UIImageView alloc] initWithImage:
                                      [UIImage imageNamed:[customInterface objectForKey:kJRSocialSharingBackgroundImageName]]]];
    /** DEPRECATED - REMOVE LATER **/
    
    [myBackgroundView setAlpha:0.3];
    
    /* If there is a UIColor object set for the background color, use this */
    if ([customInterface objectForKey:kJRSocialSharingBackgroundColor])
        myBackgroundView.backgroundColor = [customInterface objectForKey:kJRSocialSharingBackgroundColor];
    else     /** DEPRECATED - REMOVE LATER **/
        if ([backgroundColor respondsToSelector:@selector(count)])
            if ([backgroundColor count] == 4)
                myBackgroundView.backgroundColor = 
                [UIColor colorWithRed:[(NSNumber*)[backgroundColor objectAtIndex:0] doubleValue]
                                green:[(NSNumber*)[backgroundColor objectAtIndex:1] doubleValue]
                                 blue:[(NSNumber*)[backgroundColor objectAtIndex:2] doubleValue]
                                alpha:[(NSNumber*)[backgroundColor objectAtIndex:3] doubleValue]];
    /** DEPRECATED - REMOVE LATER **/
            
    myContentView.backgroundColor = [UIColor clearColor];
        
    titleView = [customInterface objectForKey:kJRSocialSharingTitleView];
    
    if (titleView)
        self.navigationItem.titleView = titleView;
    
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] 
									  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
									  target:sessionData
									  action:@selector(triggerPublishingDidCancel:)] autorelease];
	
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
    
    if ([sessionData hidePoweredBy])
    {
        [myPoweredByLabel setHidden:YES];
        [myInfoButton setHidden:YES];
    }
    
    [self loadActivityToView];
    
 /* If the user calls the library before the session data object is done initializing - 
    because either the requests for the base URL or provider list haven't returned - 
    display the "Loading Providers" label and activity spinner. 
    sessionData = nil when the call to get the base URL hasn't returned
    [sessionData.configuredProviders count] = 0 when the provider list hasn't returned */
	if ([[sessionData socialProviders] count] == 0)
	{
        [self showViewIsLoading:YES];

     /* Since the method showViewIsLoading will disable the "Cancel" button and reset the loading label to "Sharing,
        change them to the preferred values for just this case. */
        myLoadingLabel.font = [UIFont systemFontOfSize:(0/*iPad*/) ? 48.0 : 18.0];
        myLoadingLabel.text = NSLocalizedString(@"Loading providers. Please wait...", @"");
        self.navigationItem.leftBarButtonItem.enabled = YES;
		
        /* Now poll every few milliseconds, for about 16 seconds, until the provider list is loaded or we time out. */
		timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkSessionDataAndProviders:) userInfo:nil repeats:NO];
	}
	else 
	{
        weAreReady = YES;
        [self addProvidersToTabBar];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
    DLog(@"");
    
    [super viewWillAppear:animated];
    
    self.contentSizeForViewInPopover = CGSizeMake(320, 416);
    
    // QTS: Am I doing this twice?
    if (weAreReady)
        [self loadActivityToView];
}

- (void)viewDidAppear:(BOOL)animated
{
    DLog(@"");
	[super viewDidAppear:animated];

    if (weAreReady && !weAreCurrentlyPostingSomething)
        [self showViewIsLoading:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLog(@"");
    [sessionData triggerPublishingDidTimeOutConfiguration];
}

/* If the user calls the library before the session data object is done initializing - 
 because either the requests for the base URL or provider list haven't returned - 
 keep polling every few milliseconds, for about 16 seconds, 
 until the provider list is loaded or we time out. */
- (void)checkSessionDataAndProviders:(NSTimer*)theTimer
{
	static NSTimeInterval interval = 0.5;
	interval = interval + 0.5;
	
    timer = nil;
	    
    DLog (@"Social Providers so far: %d", [[sessionData socialProviders] count]);
    
 /* If we have our list of providers, stop the progress indicators and load the table. */
	if ([[sessionData socialProviders] count] > 0)
	{
        weAreReady = YES;
        
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
        return;
	}
	
	timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkSessionDataAndProviders:) userInfo:nil repeats:NO];
}

- (void)doneButtonPressed:(id)sender
{
    [myUserContentTextView resignFirstResponder];

    if (myUserContentTextView.text.length > 0)
        [myUserContentTextView scrollRangeToVisible:NSMakeRange(0, 1)];
}

- (void)editButtonPressed:(id)sender
{
    [myUserContentTextView becomeFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    DLog(@"");
    
 /* If the user hasn't entered their own content already, then clear the text view.
    Otherwise, just leave what they've already written. */
    if (!hasEditedUserContentForActivityAlready)
    {
        myUserContentTextView.text = @"";
        hasEditedUserContentForActivityAlready = YES;
    }
    
    [self showActivityAsShared:NO];
    
    if (!iPad)
    {   
        [UIView beginAnimations:@"editing" context:nil];
        [myUserContentTextView setFrame:CGRectMake(myUserContentTextView.frame.origin.x, 
                                                   myUserContentTextView.frame.origin.y, 
                                                   myUserContentTextView.frame.size.width, 
                                                   160)];
        [myUserContentBoundingBox setFrame:CGRectMake(myUserContentBoundingBox.frame.origin.x, 
                                                      myUserContentBoundingBox.frame.origin.y, 
                                                      myUserContentBoundingBox.frame.size.width, 
                                                      160)];
        [myMediaContentView setFrame:CGRectMake(myMediaContentView.frame.origin.x, 
                                                180,
                                                myMediaContentView.frame.size.width, 
                                                myMediaContentView.frame.size.height)];
        [UIView commitAnimations];
    }
    
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] 
									initWithBarButtonSystemItem:UIBarButtonSystemItemDone
									target:self
									action:@selector(doneButtonPressed:)] autorelease];
    
	self.navigationItem.rightBarButtonItem = doneButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;    
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    DLog(@"");

 /* If the user started to enter something, but didn't end up keeping anything, set
    the text back to what the activity's action was. */
    if (myUserContentTextView.text.length == 0)
    {
        myUserContentTextView.text = activity.action;
    }

    if (!iPad)
    {   
        [UIView beginAnimations:@"editing" context:nil];
        [myUserContentTextView setFrame:CGRectMake(myUserContentTextView.frame.origin.x,    
                                                   myUserContentTextView.frame.origin.y, 
                                                   myUserContentTextView.frame.size.width, 
                                                   94)];
        [myUserContentBoundingBox setFrame:CGRectMake(myUserContentBoundingBox.frame.origin.x, 
                                                      myUserContentBoundingBox.frame.origin.y, 
                                                      myUserContentBoundingBox.frame.size.width, 
                                                      100)];
        [myMediaContentView setFrame:CGRectMake(myMediaContentView.frame.origin.x, 
                                                120,
                                                myMediaContentView.frame.size.width, 
                                                myMediaContentView.frame.size.height)];    
        [UIView commitAnimations];
    }   
    
    UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] 
									initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
									target:self
									action:@selector(editButtonPressed:)] autorelease];
    
	self.navigationItem.rightBarButtonItem = editButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;    
    
    return YES;
}

/* That is, cover the view with a transparent gray box and a large white activity indicator. */
- (void)showViewIsLoading:(BOOL)loading
{
    DLog(@"");
    
    myLoadingLabel.font = [UIFont systemFontOfSize:(0/*iPad*/) ? 56.0 : 24.0];
    myLoadingLabel.text = NSLocalizedString(@"Sharing...", @"");
    
 /* Don't let the user edit or cancel while the activity is being shared */
    self.navigationItem.leftBarButtonItem.enabled = !loading;
    self.navigationItem.rightBarButtonItem.enabled = !loading;
    
    UIApplication* app = [UIApplication sharedApplication]; 
    app.networkActivityIndicatorVisible = loading;
    
 /* Gray/un-gray out the window */
    [myLoadingGrayView setHidden:!loading];
    
 /* and start/stop the activity spinner */
    if (loading)
        [myLoadingActivitySpinner startAnimating];
    else
        [myLoadingActivitySpinner stopAnimating];    
}

- (void)showUserAsLoggedIn:(BOOL)loggedIn
{
    [UIView beginAnimations:@"buttonSlide" context:nil];

    [myJustShareButton setHidden:!loggedIn];
    [myConnectAndShareButton setHidden:loggedIn];
    
    [myTriangleIcon setFrame:CGRectMake(loggedIn ? 230 : 151, 0, 18, 18)];
    
    [myProfilePic setHidden:!loggedIn];
    [myUserName setHidden:!loggedIn];
    [mySignOutButton setHidden:!loggedIn];
    [UIView commitAnimations];
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
    
    [myTriangleIcon setFrame:CGRectMake(shared ? 25 : ((loggedInUser) ? 230 : 151), 0, 18, 18)];

    UIBarButtonItem *barButton;
    if (shared)
    {
        barButton = [[[UIBarButtonItem alloc] initWithTitle:@"Close" 
                                                      style:UIBarButtonItemStyleDone 
                                                     target:sessionData 
                                                     action:@selector(triggerPublishingDidComplete:)] autorelease];
    }
    else
    {
        barButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                   target:sessionData
                                                                   action:@selector(triggerPublishingDidCancel:)] autorelease];   
        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered;
    }

	self.navigationItem.leftBarButtonItem = barButton;
	self.navigationItem.leftBarButtonItem.enabled = YES;	
}

- (void)logUserOutForProvider:(NSString*)provider
{
    [sessionData forgetAuthenticatedUserForProvider:selectedProvider.name];
    [cachedProfilePics removeObjectForKey:selectedProvider.name];
    [loggedInUser release];
    loggedInUser = nil;    
    
    [self showUserAsLoggedIn:NO];
    [self showActivityAsShared:NO];
}

- (void)sendEmail
{
#if JRENGAGE_INCLUDE_EMAIL_SMS
    MFMailComposeViewController *email = [[[MFMailComposeViewController alloc] init] autorelease];
  
    if (!email)
        return;

    email.mailComposeDelegate = self;
    
    [email setSubject:activity.email.subject];
    [email setMessageBody:activity.email.messageBody isHTML:activity.email.isHtml];
  
    [self presentModalViewController:email animated:YES];
#endif
}

- (void)sendSMS
{
#if JRENGAGE_INCLUDE_EMAIL_SMS
    MFMessageComposeViewController *sms = [[[MFMessageComposeViewController alloc] init] autorelease];

    if (!sms)
        return;

    sms.messageComposeDelegate = self;
    sms.body = activity.sms.message;
    
    [self presentModalViewController:sms animated:YES];
    
#endif
}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            if (!userIsAttemptingToSignOut)
                [self sendEmail];
            else
                [self logUserOutForProvider:selectedProvider.name];
            break;
        case 1:
            if (!userIsAttemptingToSignOut)
                [self sendSMS];
            break;
        case 2:
            myTabBar.selectedItem = [myTabBar.items objectAtIndex:selectedTab];
            [self tabBar:myTabBar didSelectItem:[myTabBar.items objectAtIndex:selectedTab]];
        default:
            break;
    }
    
    userIsAttemptingToSignOut = NO;
}

- (void)actionSheetCancel:(UIActionSheet*)actionSheet
{
    if (!userIsAttemptingToSignOut)
    {
        myTabBar.selectedItem = [myTabBar.items objectAtIndex:selectedTab];
        [self tabBar:myTabBar didSelectItem:[myTabBar.items objectAtIndex:selectedTab]];
    }
    
    userIsAttemptingToSignOut = NO;
}

- (IBAction)signOutButtonPressed:(id)sender
{
    DLog(@"");
    
    userIsAttemptingToSignOut = YES;
    
	UIActionSheet *action = [[[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:
                                                                   @"You are currently signed in to %@%@. Would you like to sign out?",
                                                                   selectedProvider.friendlyName, 
                                                                   (loggedInUser.preferred_username) ? 
                                                                   [NSString stringWithFormat:@" as %@", loggedInUser.preferred_username] : @""]
														 delegate:self
												cancelButtonTitle:@"Cancel"  
										   destructiveButtonTitle:@"Sign Out"
												otherButtonTitles:nil] autorelease];
	action.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [action showFromTabBar:myTabBar];
}

- (void)setButtonImage:(UIButton*)button toData:(NSData*)data andSetLoading:(UIActivityIndicatorView*)actIndicator toLoading:(BOOL)loading
{
    DLog (@"");

    if (!data && !loading)
        DLog (@"Problem downloading image");
    
    if (!data)
    {
        [button setImage:nil forState:UIControlStateNormal];
        button.backgroundColor = [UIColor darkGrayColor];
    }
    else
    {
        [button setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        button.backgroundColor = [UIColor whiteColor];
    }
    
    if (loading)
        [actIndicator startAnimating];
    else
        [actIndicator stopAnimating];
}

- (BOOL)providerCanShareMedia:(JRProvider*)provider
{
    DLog(@"");
    
    if ([[provider.socialPublishingProperties objectForKey:@"can_share_media"] isEqualToString:@"YES"])
        return YES;
    
    return NO;
}

- (void)loadActivityToView:(JRActivityObject*)_activity
{
    DLog(@"");
    
    if (!hasEditedUserContentForActivityAlready) 
        myUserContentTextView.text = _activity.action;
    else
        myUserContentTextView.text = _activity.user_generated_content;
    
    if ((weAreReady) && ([_activity.media count] > 0) && ([self providerCanShareMedia:selectedProvider]))
    {
        [myMediaContentView setHidden:NO];
        
        myTitleLabel.text = _activity.title;
        myDescriptionLabel.text = _activity.description;
        
        JRMediaObject *media = [_activity.media objectAtIndex:0];
        if ([media isKindOfClass:[JRImageMediaObject class]])
        {
            DLog (@"Downloading image thumbnail: %@", ((JRImageMediaObject*)media).src);
            [self setButtonImage:myMediaThumbnailView toData:nil andSetLoading:myMediaThumbnailActivityIndicator toLoading:YES];
            
            NSURL        *url = [NSURL URLWithString:((JRImageMediaObject*)media).src];
            NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url] autorelease];
            NSString     *tag = [[NSString alloc] initWithFormat:@"getThumbnail"];
            
            if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self returnFullResponse:YES withTag:tag])
                [self setButtonImage:myMediaThumbnailView toData:nil andSetLoading:myMediaThumbnailActivityIndicator toLoading:NO];
        }   
    }
    else 
    {
        [myMediaContentView setHidden:YES];
    }
}

/* Not the best way to do this, but if this function is called, it calls loadActivityToView: with just 
   the current activity instance variable.  If, like in the case where the view is closing, we 
   want to load an empty activity, loadActivityToView: can be called directly with _activity=nil.
   Maybe it's because I thought calling an instance method with an instance variable was redundant or something... */
- (void)loadActivityToView
{
    [self loadActivityToView:activity];
}

- (void)setProfilePicToDefaultPic
{
    [myProfilePic setImage:[UIImage imageNamed:@"profilepic_placeholder.png"] forState:UIControlStateNormal];
    myProfilePic.backgroundColor = [UIColor clearColor];
    [myProfilePicActivityIndicator stopAnimating];
}

- (void)fetchProfilePicFromUrl:(NSString*)profilePicUrl forProvider:(NSString*)providerName
{
    DLog(@"");
    [self setButtonImage:myProfilePic toData:nil andSetLoading:myProfilePicActivityIndicator toLoading:YES];
    
    NSURL        *url = [NSURL URLWithString:profilePicUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSString     *tag = [providerName retain];
    
    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self returnFullResponse:YES withTag:tag])
        [self setProfilePicToDefaultPic];
    
    [request release];
}

- (void)loadUserNameAndProfilePicForUser:(JRAuthenticatedUser*)user forProvider:(NSString*)providerName
{   
    DLog(@"");
    myUserName.text = user.preferred_username;
    
    NSData *cachedProfilePic = [cachedProfilePics objectForKey:providerName];
    
    if (cachedProfilePic)
        [self setButtonImage:myProfilePic toData:cachedProfilePic andSetLoading:myProfilePicActivityIndicator toLoading:NO];
    else if (user.photo)
        [self fetchProfilePicFromUrl:user.photo forProvider:providerName];
    else
        [self setProfilePicToDefaultPic];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    DLog(@"");
    
#if JRENGAGE_INCLUDE_EMAIL_SMS
    if (item.tag == [[sessionData socialProviders] count])
    {
        UIActionSheet *action;
        switch (emailOrSms)
        {
            case EMAIL_ONLY:
                [self sendEmail];
                break;
            case SMS_ONLY:
                [self sendSMS];
                break;
            case EMAIL_AND_SMS:
                action = [[[UIActionSheet alloc] initWithTitle:@"Share with Email or SMS"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"  
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Email", @"SMS", nil] autorelease];
                action.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
                [action showFromTabBar:myTabBar];
                break;
            default:
                break;
        }
    }
    else
#endif
    {        
        [selectedProvider release];
        [loggedInUser release];
        
        selectedProvider = [[sessionData getSocialProviderAtIndex:item.tag] retain];
        [sessionData setCurrentProvider:selectedProvider];
        
        selectedTab = item.tag;
        
        NSArray *colorArray = [selectedProvider.socialPublishingProperties objectForKey:@"color_values"];
        if ([colorArray count] == 4)
            myShareToView.backgroundColor = [UIColor colorWithRed:[[colorArray objectAtIndex:0] doubleValue]
                                                            green:[[colorArray objectAtIndex:1] doubleValue] 
                                                             blue:[[colorArray objectAtIndex:2] doubleValue]
                                                            alpha:0.2];

        [myConnectAndShareButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:
                                                                         @"button_%@_280x40%@.png", 
                                                                         selectedProvider.name, 
                                                                         (iPad) ? @"@2x" : @""]]
                                           forState:UIControlStateNormal];
        
        [myJustShareButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:
                                                                   @"button_%@_135x40%@.png", 
                                                                   selectedProvider.name, 
                                                                   (iPad) ? @"@2x" : @""]]
                                     forState:UIControlStateNormal];
        
        myProviderIcon.image = [UIImage imageNamed:[NSString stringWithFormat:
                                                    @"icon_%@_30x30%@.png", 
                                                    selectedProvider.name, 
                                                    (iPad) ? @"@2x" : @"" ]];
        
        loggedInUser = [[sessionData authenticatedUserForProvider:selectedProvider] retain];
        
        activity.user_generated_content = myUserContentTextView.text;
        
        if (loggedInUser)
        {
            [self showUserAsLoggedIn:YES];
            [self loadUserNameAndProfilePicForUser:loggedInUser forProvider:selectedProvider.name];
        }
        else
        {
            [self showUserAsLoggedIn:NO];
        }
        
        [self loadActivityToView];
        [self showActivityAsShared:([alreadyShared containsObject:selectedProvider.name] ? YES : NO)];
    }
}

- (BOOL)canSendMailOrSMS
{
#if JRENGAGE_INCLUDE_EMAIL_SMS
#else
    return NO;
#endif
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
 /* Check if the activity has an email object, sms string, or both and if we can send either or both.
    If so, emailOrSms will be 0, 1, 2, or 3, accordingly. */
    if (activity.email && [mailClass canSendMail])  /* Add 1. */
        emailOrSms += EMAIL;
    if (activity.sms && [messageClass canSendText]) /* Add 2. */
        emailOrSms += SMS;
  
    return emailOrSms;
}

- (void)addProvidersToTabBar
{
    DLog(@"");
    
    NSInteger numberOfTabs = [[sessionData socialProviders] count];
    NSInteger indexOfLastUsedProvider = 0;
    BOOL canSendEmailAndText = [self canSendMailOrSMS];

    if (canSendEmailAndText) 
        numberOfTabs++;
    
    NSMutableArray *providerTabArr = [[NSMutableArray alloc] initWithCapacity:numberOfTabs];
    
    for (int i = 0; i < [[sessionData socialProviders] count]; i++)
    {
        JRProvider *provider = [[sessionData getSocialProviderAtIndex:i] retain];
        
        if (!provider)
            break;
        
        NSString *imagePath = [NSString stringWithFormat:@"icon_bw_%@_30x30.png", provider.name];//, (iPad) ? @"@2x" : @"" ];
        UITabBarItem *providerTab = [[[UITabBarItem alloc] initWithTitle:provider.friendlyName 
                                                                   image:[UIImage imageNamed:imagePath]
                                                                     tag:[providerTabArr count]] autorelease];
        
        [providerTabArr insertObject:providerTab atIndex:[providerTabArr count]];
        
        if ([provider isEqualToReturningProvider:[sessionData returningSocialProvider]])
            indexOfLastUsedProvider = i;
        
        [provider release];
    }
    
    if (canSendEmailAndText)
    {

        NSString *simpleStrArray[6] = { @"Email", @"Sms", @"Email/SMS", @"mail", @"sms", @"mail_sms" };

        UITabBarItem *emailTab =  [[[UITabBarItem alloc] initWithTitle:simpleStrArray[((int)emailOrSms - 1)] 
                                                                 image:[UIImage imageNamed:
                                                                        [NSString stringWithFormat:
                                                                         @"icon_bw_%@_30x30.png", 
                                                                         simpleStrArray[((int)emailOrSms +2)]]]
                                                                   tag:[providerTabArr count]] autorelease];
        
        [providerTabArr insertObject:emailTab atIndex:[providerTabArr count]];
    }
    
    cachedProfilePics = [[NSMutableDictionary alloc] initWithCapacity:[[sessionData socialProviders] count]];
    [myTabBar setItems:providerTabArr animated:YES];
    
    // QTS: Should we make the default selected social provider be the provider most commonly used
    if ([providerTabArr count])
    {
        myTabBar.selectedItem = [providerTabArr objectAtIndex:indexOfLastUsedProvider];
        [self tabBar:myTabBar didSelectItem:[providerTabArr objectAtIndex:indexOfLastUsedProvider]];
        selectedTab = indexOfLastUsedProvider;
    }
    
    [providerTabArr release];
}

- (void)shareActivity
{
    DLog(@"");
    
    [sessionData shareActivityForUser:loggedInUser];
}

- (IBAction)shareButtonPressed:(id)sender
{
    DLog(@"");
    
    weAreCurrentlyPostingSomething = YES;
    
    if (myUserContentTextView.text && hasEditedUserContentForActivityAlready)
        activity.user_generated_content = myUserContentTextView.text;
    
    [sessionData setCurrentProvider:selectedProvider];
    [self showViewIsLoading:YES];
    
    if (!loggedInUser)
    {
     /* Set weHaveJustAuthenticated to YES, so that when this view returns (for whatever reason... successful auth
    `   user canceled, etc), the view will know that we just went through the authentication process. */
        weHaveJustAuthenticated = YES;
        
     /* If the selected provider requires input from the user, go to the user landing view. Or if 
        the user started on the user landing page, went back to the list of providers, then selected 
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

- (IBAction)infoButtonPressed:(id)sender
{
    NSDictionary *infoPlist = [NSDictionary dictionaryWithContentsOfFile: 
                               [[[NSBundle mainBundle] resourcePath] 
                                stringByAppendingPathComponent:@"/JREngage-Info.plist"]];
    
    NSString *version = [infoPlist objectForKey:@"CFBundleShortVersionString"];
    
 /* So long as I always number the versions v#.#.#, this will always trim the leading 'v', leaving just the numbers.
    Also, if my script accidentally adds a trailing '\n', this gets trimmed too. */
    version = [[version stringByTrimmingCharactersInSet:[NSCharacterSet lowercaseLetterCharacterSet]]
               stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
	UIActionSheet *action = [[[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:
                                                                   @"Janrain Engage for iPhone Library\nVersion %@\nwww.janrain.com", version]
														 delegate:nil
												cancelButtonTitle:@"OK"  
										   destructiveButtonTitle:nil
												otherButtonTitles:nil] autorelease];
	action.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[action showFromTabBar:myTabBar];
}

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
    [(NSString*)userdata release];	
}

- (void)connectionDidFinishLoadingWithFullResponse:(NSURLResponse*)fullResponse unencodedPayload:(NSData*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
    DLog(@"");
    NSString* tag = (NSString*)userdata; 
	
    if ([tag isEqualToString:@"getThumbnail"])
    {
        [self setButtonImage:myMediaThumbnailView toData:payload andSetLoading:myMediaThumbnailActivityIndicator toLoading:NO];
    }
    else 
    {
        if ([tag isEqualToString:selectedProvider.name])
        {
            [self setButtonImage:myProfilePic toData:payload andSetLoading:myProfilePicActivityIndicator toLoading:NO];
        }

        [cachedProfilePics setValue:payload forKey:tag];
    }

	[tag release];	    
}

- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(void*)userdata 
{
    DLog(@"");
    NSString* tag = (NSString*)userdata; 
	
    if ([tag isEqualToString:@"getThumbnail"])
    {
        [self setButtonImage:myMediaThumbnailView toData:nil andSetLoading:myMediaThumbnailActivityIndicator toLoading:NO];
    }
    else 
    {
        if ([tag isEqualToString:selectedProvider.name])
        {
            [self setProfilePicToDefaultPic];
        }
    }
    
	[tag release];	        
}

- (void)connectionWasStoppedWithTag:(void*)userdata 
{
    [(NSString*)userdata release];
}

- (void)authenticationDidRestart 
{
    weAreCurrentlyPostingSomething = NO; 
    weHaveJustAuthenticated = NO; 
}

- (void)authenticationDidCancel 
{
    weAreCurrentlyPostingSomething = NO; 
    weHaveJustAuthenticated = NO; 
}

- (void)authenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider 
{
    weHaveJustAuthenticated = NO; 
    weAreCurrentlyPostingSomething = NO; 
}

- (void)authenticationDidCompleteWithToken:(NSString*)token forProvider:(NSString*)provider 
{
    DLog(@"");
    
    myLoadingLabel.text = @"Sharing...";
    
    loggedInUser = [[sessionData authenticatedUserForProvider:selectedProvider] retain];
    
    // QTS: Would we ever expect this to not be the case?
    if (loggedInUser)
    {
        [self showViewIsLoading:YES];
        [self loadUserNameAndProfilePicForUser:loggedInUser forProvider:provider];
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
        weAreCurrentlyPostingSomething = NO;
        weHaveJustAuthenticated = NO; 
    }
}

- (void)authenticationDidCompleteForUser:(NSDictionary*)profile forProvider:(NSString*)provider
{
    DLog(@"");
    
    myLoadingLabel.text = @"Sharing...";
    
    loggedInUser = [[sessionData authenticatedUserForProvider:selectedProvider] retain];
    
    // QTS: Would we ever expect this to not be the case?
    if (loggedInUser)
    {
        [self showViewIsLoading:YES];
        [self loadUserNameAndProfilePicForUser:loggedInUser forProvider:provider];
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
        weAreCurrentlyPostingSomething = NO;
        weHaveJustAuthenticated = NO; 
    }    
}

- (void)publishingActivityDidSucceed:(JRActivityObject*)_activity forProvider:(NSString*)provider;
{
    DLog(@"");
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Shared"
                                                     message:[NSString stringWithFormat:
                                                              @"You have successfully shared this activity."]
                                                    delegate:nil
                                           cancelButtonTitle:@"OK" 
                                           otherButtonTitles:nil] autorelease];
    [alert show];
    
    [alreadyShared addObject:provider];
    
    [self showViewIsLoading:NO];
    [self showActivityAsShared:YES];
    
    weAreCurrentlyPostingSomething = NO;
    weHaveJustAuthenticated = NO; 
}

- (void)publishingDidRestart { weAreCurrentlyPostingSomething = NO; }
- (void)publishingDidCancel { weAreCurrentlyPostingSomething = NO; }
- (void)publishingDidComplete { weAreCurrentlyPostingSomething = NO; }

- (void)publishingActivity:(JRActivityObject*)_activity didFailWithError:(NSError*)error forProvider:(NSString*)provider
{
    DLog(@"");
    NSString *errorMessage = nil;
    BOOL reauthenticate = NO;

    [self showViewIsLoading:NO];
    
    switch (error.code)
    {
        case JRPublishFailedError:
            errorMessage = [NSString stringWithFormat:
                            @"There was an error while sharing this activity."];
            break;
        case JRPublishErrorDuplicateTwitter:
            errorMessage = [NSString stringWithFormat:
                            @"There was an error while sharing this activity: Twitter does not allow duplicate status updates."];
            break;
        case JRPublishErrorLinkedInCharacterExceded:
            errorMessage = [NSString stringWithFormat:
                            @"There was an error while sharing this activity: Status was too long."];
            break;
        case JRPublishErrorMissingApiKey:
            errorMessage = [NSString stringWithFormat:
                            @"There was an error while sharing this activity."];
            reauthenticate = YES;
            break;
        case JRPublishErrorInvalidOauthToken:
            errorMessage = [NSString stringWithFormat:
                            @"There was an error while sharing this activity."];
            reauthenticate = YES;
            break;
        default:
            errorMessage = [NSString stringWithFormat:
                            @"There was an error while sharing this activity."];
            break;
    }    

 /* OK, if this gets called right after authentication succeeds, then the navigation controller won't be done
    animating back to this view.  If this view isn't loaded yet, and we call shareButtonPressed, then the library
    will end up trying to push the webview controller onto the navigation controller while the navigation controller 
    is still trying to pop the webview.  This creates craziness, hence we check for [self isViewLoaded].
    Also, this prevents an infinite loop of reauthing-failed publishing-reauthing-failed publishing.
    So, only try and reauthenticate is the publishing activity view is already loaded, which will only happen if we didn't
    JUST try and authorize, or if sharing took longer than the time it takes to pop the view controller. */
    if (reauthenticate && !weHaveJustAuthenticated)
    {
        [self logUserOutForProvider:provider];
        [self shareButtonPressed:nil];
        
        return;
    }
    
    weAreCurrentlyPostingSomething = NO;
    weHaveJustAuthenticated = NO; 
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:errorMessage
                                                    delegate:nil
                                           cancelButtonTitle:@"OK" 
                                           otherButtonTitles:nil] autorelease];
    [alert show];    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
    UIAlertView *alert;
    switch (result)
    {
//        case MFMailComposeResultCancelled:
//            break;
//        case MFMailComposeResultSaved:
//            break;
        case MFMailComposeResultSent:
            [sessionData triggerEmailSharingDidComplete];
            alert = [[[UIAlertView alloc] initWithTitle:@"Success"
                                                message:@"You have successfully sent this email."
                                               delegate:nil
                                      cancelButtonTitle:@"OK" 
                                      otherButtonTitles:nil] autorelease];
            [alert show];    
            break;
        case MFMailComposeResultFailed:
            alert = [[[UIAlertView alloc] initWithTitle:@"Error"
                                                message:@"Could not send email.  Please try again later."
                                               delegate:nil
                                      cancelButtonTitle:@"OK" 
                                      otherButtonTitles:nil] autorelease];
            [alert show];    
            break;
        default:
            break;
    }

    myTabBar.selectedItem = [myTabBar.items objectAtIndex:selectedTab];
    [self tabBar:myTabBar didSelectItem:[myTabBar.items objectAtIndex:selectedTab]];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result 
{
    UIAlertView *alert;
    switch (result)
    {
//        case MessageComposeResultCancelled:
//            break;
        case MessageComposeResultSent:
            [sessionData triggerSmsSharingDidComplete];
            alert = [[[UIAlertView alloc] initWithTitle:@"Success"
                                                message:@"You have successfully sent this text."
                                               delegate:nil
                                      cancelButtonTitle:@"OK" 
                                      otherButtonTitles:nil] autorelease];
            [alert show];    
            break;
        case MessageComposeResultFailed:
            alert = [[[UIAlertView alloc] initWithTitle:@"Error"
                                                message:@"Could not send text.  Please try again later."
                                               delegate:nil
                                      cancelButtonTitle:@"OK" 
                                      otherButtonTitles:nil] autorelease];
            [alert show];    
            break;
        default:
            break;
    }

    myTabBar.selectedItem = [myTabBar.items objectAtIndex:selectedTab];
    [self tabBar:myTabBar didSelectItem:[myTabBar.items objectAtIndex:selectedTab]];
    
    [self dismissModalViewControllerAnimated:YES];
}

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
    [timer invalidate];
    [self loadActivityToView:nil];
}

- (void)userInterfaceDidClose { }

- (void)dealloc
{
    DLog(@"");
 
    [selectedProvider release];
    [loggedInUser release];
    [activity release];
    [customInterface release];
    [colorsDictionary release];
    [myBackgroundView release];
    [myTabBar release];
    [myLoadingLabel release];
    [myLoadingActivitySpinner release]; 
    [myLoadingGrayView release];
    [myUserContentTextView release];
    [myUserContentBoundingBox release];
    [myProviderIcon release];
    [myInfoButton release];
    [myPoweredByLabel release];
    [myMediaContentView release];
    [myMediaViewBackgroundMiddle release];
    [myMediaViewBackgroundTop release];
    [myMediaViewBackgroundBottom release];
    [myMediaThumbnailView release];
    [myMediaThumbnailActivityIndicator release];
    [myTitleLabel release];
    [myDescriptionLabel release];
    [myShareToView release];
    [myTriangleIcon release];
    [myProfilePic release];
    [myProfilePicActivityIndicator release];
    [myUserName release];
    [myConnectAndShareButton release];
    [myJustShareButton release];
    [mySharedCheckMark release];
    [mySharedLabel release];
    [mySignOutButton release];
    [cachedProfilePics release];
    [alreadyShared release];
    
    [super dealloc];
}
@end
