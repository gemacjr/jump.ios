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
- (void)loadUserNameAndProfilePic:(NSString*)user;
@end


@implementation JRPublishActivityController
@synthesize myLoadingLabel;
@synthesize myLoadingActivitySpinner; 
@synthesize myLoadingGrayView;
@synthesize myUserContentTextView;
@synthesize myUserContentBoundingBox;
@synthesize myProviderIcon;
@synthesize myPoweredByLabel;
@synthesize myMediaContentView;
@synthesize myMediaViewBackgroundMiddle;
@synthesize myMediaViewBackgroundTop;
@synthesize myMediaViewBackgroundBottom;
@synthesize myMediaThumbnailView;
@synthesize myMediaThumbnailActivityIndicator;
@synthesize myTitleLabel;
@synthesize myDescriptionLabel;
@synthesize myShareToView;
@synthesize myTriangleIcon;
@synthesize myProfilePic;
@synthesize myProfilePicActivityIndicator;
@synthesize myUserName;
@synthesize myConnectAndShareButton;
@synthesize myJustShareButton;
@synthesize mySharedCheckMark;
@synthesize mySharedLabel;
//@synthesize keyboardToolbar;
//@synthesize shareButton;
//@synthesize doneButton;

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

	jrAuth = [[JRAuthenticate jrAuthenticate] retain];
	sessionData = [[((JRModalNavigationController*)[[self navigationController] parentViewController]) sessionData] retain];
	activity = [[((JRModalNavigationController*)[[self navigationController] parentViewController]) activity] retain];
    
    providers = [sessionData.socialProviders retain];
        
	DLog(@"prov count = %d", [providers count]);
	
	/* If the user calls the library before the session data object is done initializing - 
     because either the requests for the base URL or provider list haven't returned - 
     display the "Loading Providers" label and activity spinner. 
     sessionData = nil when the call to get the base URL hasn't returned
     [sessionData.configuredProviders count] = 0 when the provider list hasn't returned */
	if (!sessionData || [providers count] == 0)
	{
        [self showViewIsLoading:YES];
		
		/* Now poll every few milliseconds, for about 16 seconds, until the provider list is loaded or we time out. */
		[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkSessionDataAndProviders:) userInfo:nil repeats:NO];
	}
	else 
	{
        ready = YES;
        [self addProvidersToTabBar];
        [self loadActivityToView];
	}
    
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
    
//	if (!infoBar)
//	{
//		infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, 388, 320, 30) andStyle:[sessionData hidePoweredBy]];
//		[self.view addSubview:infoBar];
//	}
//	[infoBar fadeIn];	
	
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] 
									  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
									  target:[self navigationController].parentViewController
									  action:@selector(cancelButtonPressed:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = cancelButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;

    UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] 
									initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
									target:self
									action:@selector(editButtonPressed:)] autorelease];
	
//	doneButton = [[[UIBarButtonItem alloc] 
//									initWithBarButtonSystemItem:UIBarButtonSystemItemDone
//									target:self
//									action:@selector(doneButtonPressed:)] autorelease];
	
	
	self.navigationItem.leftBarButtonItem = editButton;
	self.navigationItem.leftBarButtonItem.enabled = YES;
	
	self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered;

//    [myJustShareButton setTitle:@"Share" forState:UIControlStateNormal];
//    [myJustShareButton setTitle:@"Share" forState:UIControlStateSelected];
//    
//    [myConnectAndShareButton setTitle:@"Connect And Share" forState:UIControlStateNormal];
//    [myConnectAndShareButton setTitle:@"Connect And Share" forState:UIControlStateSelected];    
//    
//    
//    myJustShareButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
//    [myJustShareButton setTitleColor:[UIColor whiteColor] 
//                          forState:UIControlStateNormal];
//    [myJustShareButton setTitleShadowColor:[UIColor grayColor]
//                                forState:UIControlStateNormal];
    
//    keyboardToolbar.alpha = 0.0;
    [keyboardToolbar setFrame:CGRectMake(0, 416, 320, 44)];
//    myUserContentTextView.inputAccessoryView = keyboardToolbar;


    if (ready)
        [self loadActivityToView];
//        [myTableView reloadData];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLog(@"");
    [(JRModalNavigationController*)[self navigationController].parentViewController dismissModalNavigationController:NO];	
}

/* If the user calls the library before the session data object is done initializing - 
 because either the requests for the base URL or provider list haven't returned - 
 keep polling every few milliseconds, for about 16 seconds, 
 until the provider list is loaded or we time out. */
- (void)checkSessionDataAndProviders:(NSTimer*)theTimer
{
	static NSTimeInterval interval = 0.125;
	interval = interval * 2;
	
	DLog(@"prov count = %d", [providers count]);
	DLog(@"interval = %f", interval);
	
	/* If sessionData was nil in viewDidLoad and viewWillAppear, but it isn't nil now, set the sessionData variable. */
	if (!sessionData && [((JRModalNavigationController*)[[self navigationController] parentViewController]) sessionData])
		sessionData = [[((JRModalNavigationController*)[[self navigationController] parentViewController]) sessionData] retain];	
    
	providers = [sessionData.socialProviders retain];
    
    /* If we have our list of providers, stop the progress indicators and load the table. */
	if ([providers count] != 0)
	{
		ready = YES;
        
        [self showViewIsLoading:NO];
		
        [self addProvidersToTabBar];
        [self loadActivityToView];
        
		return;
	}
	
	/* Otherwise, keep polling until we've timed out. */
	if (interval >= 8.0)
	{	
		DLog(@"No Available Providers");
        
        [self showViewIsLoading:NO];
        
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"No Available Providers"
														 message:@"There are no available providers. \
                               Either there is a problem connecting \
                               or no providers have been configured. \
                               Please try again later."
														delegate:self
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil] autorelease];
		[alert show];
		return;
	}
	
	[NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(checkSessionDataAndProviders:) userInfo:nil repeats:NO];
}

- (void)doneButtonPressed:(id)sender
{
    [myUserContentTextView resignFirstResponder];
    [myUserContentTextView scrollRectToVisible:CGRectMake(0, 0, 300, 125) animated:YES];
	
    UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] 
									initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
									target:self
									action:@selector(editButtonPressed:)] autorelease];
    
	self.navigationItem.leftBarButtonItem = editButton;
	self.navigationItem.leftBarButtonItem.enabled = YES;
	
	self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered;	
}

- (void)editButtonPressed:(id)sender
{
    [myUserContentTextView becomeFirstResponder];
    
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] 
									initWithBarButtonSystemItem:UIBarButtonSystemItemDone
									target:self
									action:@selector(doneButtonPressed:)] autorelease];
    
	self.navigationItem.leftBarButtonItem = doneButton;
	self.navigationItem.leftBarButtonItem.enabled = YES;
	
	self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered;
	
}

- (void)fetchProfilePicFromUrl:(NSString*)profilePicUrl forToken:(NSString*)sessionToken
{
    DLog(@"");
    [self setImageView:myProfilePic toData:nil andSetLoading:myProfilePicActivityIndicator toLoading:YES];
    
    NSURL        *url = [NSURL URLWithString:profilePicUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSString     *tag = [[NSString alloc] initWithFormat:@"getProfilePic"];
    
    [JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag stringEncodeData:NO];
    
    [request release];
}


- (void)showUserAsLoggedIn:(BOOL)loggedIn
{
    [UIView beginAnimations:@"buttonSlide" context:nil];

    [myJustShareButton setHidden:!loggedIn];
    [myConnectAndShareButton setHidden:loggedIn];
    
    [myProfilePic setHidden:!loggedIn];
    [myUserName setHidden:!loggedIn];
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

- (void)loadActivityToView
{
    DLog(@"");
    myUserContentTextView.text = activity.user_generated_content;
    
    if (([activity.media count] > 0) && ([self providerCanShareMedia:selectedProvider]))
    {
        [myMediaContentView setHidden:NO];
        
        myTitleLabel.text = activity.title;
        myDescriptionLabel.text = activity.description;
        
        JRMediaObject *media = [activity.media objectAtIndex:0];
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
    }
}

- (void)addProvidersToTabBar
{
    DLog(@"");
    NSMutableArray *providerTabArr = [[NSMutableArray alloc] initWithCapacity:[providers count]];
    
    for (NSString *provider in providers)
    {
        
        NSDictionary* provider_stats = [sessionData.providerInfo objectForKey:provider];
        
        NSString *friendly_name = [provider_stats objectForKey:@"friendly_name"];
        NSString *imagePath = [NSString stringWithFormat:@"jrauth_%@_greyscale.png", provider];
        
        UITabBarItem *providerTab = [[UITabBarItem alloc] initWithTitle:friendly_name 
                                                                  image:[UIImage imageNamed:imagePath]
                                                                    tag:[providerTabArr count]];
        
        [providerTabArr insertObject:providerTab atIndex:[providerTabArr count]];
    }
    
    [myTabBar setItems:providerTabArr animated:YES];
    
    // TODO: Make this be the provider most commonly used
    // TODO: Do we need both of these?
    myTabBar.selectedItem = [providerTabArr objectAtIndex:0];
    [self tabBar:myTabBar didSelectItem:[providerTabArr objectAtIndex:0]];
     
    [providerTabArr release];
}

- (void)queryServerForUserNameAndProfilePicUrl
{
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@:%@", loggedInUser, @"profilePicUrl"]];

    myProfilePic.image = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@:%@", loggedInUser, @"profilePic"]] retain];
    myUserName.text = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@:%@", loggedInUser, @"userName"]];
        
    [self fetchProfilePicFromUrl:url forToken:loggedInUser];
}

- (void)loadUserNameAndProfilePic:(NSString*)user
{
//    UIImage *pic = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@:%@", loggedInUser, @"profilePic"]] retain];
    
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@:%@", loggedInUser, @"userName"]];
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@:%@", loggedInUser, @"profilePicUrl"]];
    
    if (!name || !url)
    {
        [self queryServerForUserNameAndProfilePicUrl];
    }
    else
    {
        myProfilePic.image = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@:%@", loggedInUser, @"profilePic"]] retain];
        myUserName.text = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@:%@", loggedInUser, @"userName"]];

        [self fetchProfilePicFromUrl:url forToken:loggedInUser];
    }
}



- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    DLog(@"");
    selectedProvider = [[providers objectAtIndex:item.tag] retain];

    myProviderIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"jrauth_%@_icon.png", selectedProvider]];
    
    loggedInUser = [sessionData sessionTokenForProvider:selectedProvider];
    if (loggedInUser)
    {
        [self showUserAsLoggedIn:YES];
        [self loadUserNameAndProfilePic:loggedInUser];
    }
    else
    {
        [self showUserAsLoggedIn:NO];
    }


    [self loadActivityToView];
    [self showActivityAsShared:NO];
}





- (void)keyboardWillShow:(NSNotification *)notif
{
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];	

//    [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];    
    
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
    
	self.navigationItem.leftBarButtonItem = doneButton;
	self.navigationItem.leftBarButtonItem.enabled = YES;
	
	self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered; 
}

- (void)keyboardDidShow:(NSNotification *)notif
{
    
}

- (void)keyboardWillHide:(NSNotification *)notif
{
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];	
    
//    [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
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
    
	self.navigationItem.leftBarButtonItem = editButton;
	self.navigationItem.leftBarButtonItem.enabled = YES;
	
	self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered;    
    
    return YES;
}

- (void)keyboardDidHide:(NSNotification *)notif
{
//    [keyboardToolbar setHidden:YES];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
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
    
	self.navigationItem.leftBarButtonItem = doneButton;
	self.navigationItem.leftBarButtonItem.enabled = YES;
	
	self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered;    
    
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
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
    
	self.navigationItem.leftBarButtonItem = editButton;
	self.navigationItem.leftBarButtonItem.enabled = YES;
	
	self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered;    
    
    return YES;
}



- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
 	NSString* tag = (NSString*)userdata; 
	[payload retain];
	
	DLog(@"request (retain count: %d): %@", [request retainCount], [[request URL] absoluteString]);
	DLog(@"payload (retain count: %d): %@", [payload retainCount], payload);
	DLog(@"tag     (retain count: %d): %@", [tag retainCount], tag);
    
    if ([tag isEqualToString:@"shareThis"])
    {
        NSRange subStr = [payload rangeOfString:@"\"stat\":\"ok\""];
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Shared"
                                                         message:((subStr.length) ? 
                                                                  @"You have successfully shared this activity" :
                                                                  [NSString stringWithFormat:
                                                                   @"There was an error while sharing this activity: %@", payload ])
                                                        delegate:nil
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil] autorelease];
        [alert show];

        [self showViewIsLoading:NO];
        [self showActivityAsShared:YES];
    }
    
	[tag release];	
}

- (void)setImageView:(UIImageView*)imageView toData:(NSData*)data andSetLoading:(UIActivityIndicatorView*)actIndicator toLoading:(BOOL)loading
{
    DLog(@"");
    if (!data)
        imageView.image = nil;
    else 
        imageView.image = [UIImage imageWithData:data];
    
    if (loading)
        [actIndicator startAnimating];
    else
        [actIndicator stopAnimating];
}

- (void)connectionDidFinishLoadingWithUnEncodedPayload:(NSData*)payload request:(NSURLRequest*)request andTag:(void*)userdata
{
 	NSString* tag = (NSString*)userdata; 
	
	DLog(@"request (retain count: %d): %@", [request retainCount], [[request URL] absoluteString]);
	DLog(@"tag     (retain count: %d): %@", [tag retainCount], tag);
    
    if ([tag isEqualToString:@"getThumbnail"])
    {
        [self setImageView:myMediaThumbnailView toData:payload andSetLoading:myMediaThumbnailActivityIndicator toLoading:NO];
    }
    else if ([tag isEqualToString:@"getProfilePic"])
    {
        [self setImageView:myProfilePic toData:payload andSetLoading:myProfilePicActivityIndicator toLoading:NO];
    }

	[tag release];	    
}

- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(void*)userdata 
{
	NSString* tag = (NSString*)userdata;
	[tag release];	
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Shared"
                                                     message:@"There was an error while sharing this activity: %@"
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


- (void)jrAuthenticationDidCompleteWithToken:(NSString*)token andProvider:(NSString*)provider 
{
    DLog(@"");
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
    
    [self showViewIsLoading:YES];
    myLoadingLabel.text = @"Sharing...";
    
    if ([jrAuth theTokenUrl])
        [sessionData makeCallToTokenUrl:[jrAuth theTokenUrl] WithToken:token];
}

- (NSString*)getDisplayNameFromProfile:(NSDictionary*)profile
{
	NSString *name = nil;
	
	if ([profile objectForKey:@"preferredUsername"])
		name = [NSString stringWithFormat:@"%@", [profile objectForKey:@"preferredUsername"]];
	else if ([[profile objectForKey:@"name"] objectForKey:@"formatted"])
		name = [NSString stringWithFormat:@"%@", 
				[[profile objectForKey:@"name"] objectForKey:@"formatted"]];					 
	else 
		name = [NSString stringWithFormat:@"%@%@%@%@%@",
				([[profile objectForKey:@"name"] objectForKey:@"honorificPrefix"]) ? 
				[NSString stringWithFormat:@"%@ ", 
				 [[profile objectForKey:@"name"] objectForKey:@"honorificPrefix"]] : @"",
				([[profile objectForKey:@"name"] objectForKey:@"givenName"]) ? 
				[NSString stringWithFormat:@"%@ ", 
				 [[profile objectForKey:@"name"] objectForKey:@"givenName"]] : @"",
				([[profile objectForKey:@"name"] objectForKey:@"middleName"]) ? 
				[NSString stringWithFormat:@"%@ ", 
				 [[profile objectForKey:@"name"] objectForKey:@"middleName"]] : @"",
				([[profile objectForKey:@"name"] objectForKey:@"familyName"]) ? 
				[NSString stringWithFormat:@"%@ ", 
				 [[profile objectForKey:@"name"] objectForKey:@"familyName"]] : @"",
				([[profile objectForKey:@"name"] objectForKey:@"honorificSuffix"]) ? 
				[NSString stringWithFormat:@"%@ ", 
				 [[profile objectForKey:@"name"] objectForKey:@"honorificSuffix"]] : @""];
	
	return name;
}

- (void)jrAuthenticateDidReachTokenURL:(NSString*)tokenURL withPayload:(NSString*)tokenUrlPayload 
{ 
    DLog(@"");
    
    loggedInUser = [[sessionData sessionTokenForProvider:selectedProvider] retain];
    
    NSRange found = [tokenUrlPayload rangeOfString:@"{"];
	
	if (found.length == 0)// Then there was an error
		return; // TODO: Manage error
	
	NSString *userStr = [tokenUrlPayload substringFromIndex:found.location];
	NSDictionary* user = [userStr JSONValue];

	/* Get the display name */
	NSString *displayName = [[self getDisplayNameFromProfile:[user objectForKey:@"profile"]] retain];
    
    if (displayName)
        [[NSUserDefaults standardUserDefaults] setObject:displayName forKey:[NSString stringWithFormat:@"%@:%@", loggedInUser, @"userName"]];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"http:\/\/graph.facebook.com\/1905641\/picture?type=large" forKey:[NSString stringWithFormat:@"%@:%@", loggedInUser, @"profilePicUrl"]];
    
    if (loggedInUser)//(identifier)
    {
        [self loadUserNameAndProfilePic:loggedInUser];
        [self showUserAsLoggedIn:YES];
        
        [self shareActivityForIdentifier:loggedInUser];
    }
    else 
    {  
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Shared"
                                                         message:@"There was an error while sharing this activity: %@"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil] autorelease];
        [alert show];
        [self showViewIsLoading:NO];
    }

    sessionData.delegate = jrAuth;
}

- (void)jrAuthenticationDidFailWithError:(NSError*)error { DLog(@""); }

- (void)jrAuthenticateCallToTokenURL:(NSString*)tokenURL didFailWithError:(NSError*)error { DLog(@""); }

- (void)jrAuthenticationDidCancel { DLog(@""); }


- (void)shareActivityForIdentifier:(NSString*)identifier
{
    DLog(@"");
    
    if (myUserContentTextView.text)
        activity.user_generated_content = myUserContentTextView.text;
    
//    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionaryWithObject:activity.action forKey:@"action"];
//    
//    [jsonDict setValue:(activity.user_generated_content?activity.user_generated_content:nil) forKey:@"user_generated_content"];
//    [jsonDict setValue:(activity.title?activity.title:nil) forKey:@"title"];
//    [jsonDict setValue:(activity.description?activity.description:nil) forKey:@"description"];

    NSDictionary *jsonDict = [[activity dictionaryForObject] retain];
    
    NSString *content = [jsonDict JSONRepresentation];                          
    
    
    NSRange range = { 1, content.length-2 };
    content = [content substringWithRange:range];
//    NSString *identifier = [[sessionData authenticatedIdentifierForProvider:sessionData.currentSocialProvider.name] retain];
    
    //NSString* content = [NSString stringWithFormat:@"\"action\" : { \"%@\" \
    \""];
    
 //   content = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DLog(@"json: %@", content);

    
    NSMutableData* body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"identifier=%@", identifier] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&content=%@", content] dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest* request = [[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:@"http://social-tester.appspot.com/shareThis"]] retain];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
    
    NSString* tag = [[NSString stringWithString:@"shareThis"] retain];
    
    [JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag];
    
    [request release];    
}

- (IBAction)shareButtonPressed:(id)sender
{
    DLog(@"");
    
    [sessionData setSocialProvider:selectedProvider];
    NSString *identifier = [[sessionData identifierForProvider:selectedProvider] retain];
    
    if (!identifier)
    {
        sessionData.delegate = self;
        
        /* If the selected provider requires input from the user, go to the user landing view.
         Or if the user started on the user landing page, went back to the list of providers, then selected 
         the same provider as their last-used provider, go back to the user landing view. */
        if (sessionData.currentSocialProvider.providerRequiresInput || [selectedProvider isEqualToString:sessionData.returningProvider.name]) 
        {	
            [[self navigationController] pushViewController:((JRModalNavigationController*)[self navigationController].parentViewController).myUserLandingController
                                                   animated:YES]; 
        }
        /* Otherwise, go straight to the web view. */
        else
        {
            [[self navigationController] pushViewController:((JRModalNavigationController*)[self navigationController].parentViewController).myWebViewController
                                                   animated:YES]; 
        }
    }
    else
    {
        [self shareActivityForIdentifier:identifier];
    }
}

//- (IBAction)doneButtonPressed:(id)sender
//{
//    DLog(@"");
//    //    [hideKeyboardButton removeFromSuperview];
//    [myUserContentTextView resignFirstResponder];    
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//	return 200;
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

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    DLog(@"");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
