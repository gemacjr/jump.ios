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

@interface UITabBarItemCustomView : UITabBarItem
{
    UIActivityIndicatorView *loadingIndicator;
    UILabel                 *loadingLabel;
}

@property (readonly) UIActivityIndicatorView *loadingIndicator;
@property (readonly) UILabel                 *loadingLabel;

@end

@implementation UITabBarItemCustomView
@synthesize loadingLabel;
@synthesize loadingIndicator;

- (id)initWithTitle:(NSString*)title image:(UIImage*)image tag:(NSInteger)tag andStatus:(BOOL)connected
{
    DLog(@"");
	
	if (self = [super initWithTitle:title image:image tag:tag]) 
	{
        loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 45, 20)];
        loadingLabel.font = [UIFont systemFontOfSize:16];
        loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.highlightedTextColor = [UIColor blueColor];
        loadingLabel.text = (connected) ? @"Connected" : @"Not Connected";
        loadingLabel.textAlignment = UITextAlignmentCenter;
        loadingLabel.adjustsFontSizeToFitWidth;
        
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(5, 25, 20, 20)];
        loadingIndicator.hidesWhenStopped = TRUE;
        [loadingIndicator stopAnimating];
        
        [self addSubview:loadingIndicator];
		[self addSubview:loadingLabel];
	}		

    return self;
}

- (void)setHightlighted:(BOOL)highlighted
{
    [loadingLabel setHighlighted:highlighted];
}

- (void)setConnecting
{
    loadingLabel.text = @"Connecting";
    [loadingIndicator startAnimating];
}

- (void)setConnected:(BOOL)connected
{
    loadingLabel.text = (connected) ? @"Connected" : @"Not Connected";
}

@end






@implementation JRPublishActivityController
@synthesize myTableView;
@synthesize myLoadingLabel;
@synthesize myActivitySpinner;
@synthesize grayView;
@synthesize keyboardToolbar;
@synthesize shareButton;
@synthesize doneButton;

//@synthesize cellDisplayNameAndAction;
//@synthesize cellContentTitle;
//@synthesize cellContentDescription;
//@synthesize cellImage;
//@synthesize cellUserContent;
//@synthesize myCell;


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
    
	/* Load the table with the list of providers. */
    //	[myTableView reloadData];    
    
	DLog(@"prov count = %d", [providers count]);
	
	/* If the user calls the library before the session data object is done initializing - 
     because either the requests for the base URL or provider list haven't returned - 
     display the "Loading Providers" label and activity spinner. 
     sessionData = nil when the call to get the base URL hasn't returned
     [sessionData.configuredProviders count] = 0 when the provider list hasn't returned */
	if (!sessionData || [providers count] == 0)
	{
		[myActivitySpinner setHidden:NO];
		[myLoadingLabel setHidden:NO];
		
		[myActivitySpinner startAnimating];
		
		/* Now poll every few milliseconds, for about 16 seconds, until the provider list is loaded or we time out. */
		[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkSessionDataAndProviders:) userInfo:nil repeats:NO];
	}
	else 
	{
        ready = YES;
        [self addProvidersToTabBar];
		[myTableView reloadData];
		[infoBar fadeIn];
	}
    
	label = nil;
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
    
 	self.title = @"Publish Activity";
	
	if (!label)
	{
		label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont boldSystemFontOfSize:20.0];
		label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
		label.textAlignment = UITextAlignmentCenter;
		label.textColor = [UIColor whiteColor];
	}

	label.text = @"Publish Activity";
	self.navigationItem.titleView = label;
    
	if (!infoBar)
	{
		infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, 388, 320, 30) andStyle:[sessionData hidePoweredBy]];
		[self.view addSubview:infoBar];
	}
	[infoBar fadeIn];	
	
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] 
									  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
									  target:[self navigationController].parentViewController
									  action:@selector(cancelButtonPressed:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = cancelButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;
    
    UIBarButtonItem *placeholderItem = [[[UIBarButtonItem alloc] 
                                         //initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                         initWithCustomView:[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 65, 44)] autorelease]] autorelease];
                                         //target:nil
                                         //action:nil] autorelease];
    
	placeholderItem.width = 25;
	self.navigationItem.leftBarButtonItem = placeholderItem;
   	self.navigationItem.leftBarButtonItem.enabled = YES;
    
//    keyboardToolbar.alpha = 0.0;
//    [keyboardToolbar setFrame:CGRectMake(0, 416, 320, 44)];


    if (ready)
        [myTableView reloadData];
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

//        UITabBarItemCustomContentView *contentView = [[UITabBarItemCustomContentView alloc] initWithFrame:providerTab.frame andStatus:NO];
//        
//        providerTab.contentView = contentView;
        
        [providerTabArr insertObject:providerTab atIndex:[providerTabArr count]];
    }
    
    [myTabBar setItems:providerTabArr animated:YES];
    myTabBar.selectedItem = [providerTabArr objectAtIndex:0];
    [self tabBar:myTabBar didSelectItem:[providerTabArr objectAtIndex:0]];
     
    [providerTabArr release];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    DLog(@"");
    selectedProvider = [[providers objectAtIndex:item.tag] retain];
    
    NSDictionary* provider_stats = [sessionData.providerInfo objectForKey:selectedProvider];
    
//    NSString *friendly_name = [provider_stats objectForKey:@"friendly_name"];
    NSString *imagePath1 = [NSString stringWithFormat:@"jrauth_%@_logo_share.png", selectedProvider];
    NSString *imagePath2 = [NSString stringWithFormat:@"jrauth_%@_logo_share_selected.png", selectedProvider];
    
    NSString *identifier = [[sessionData authenticatedIdentifierForProvider:selectedProvider] retain];

//    NSString *bigButtonTitle = nil;
    
    
    [UIView beginAnimations:@"sizecell" context:nil];
    buttonLabel.textColor = [UIColor whiteColor];
    
    if (!identifier)
        buttonLabel.text = [NSString stringWithFormat:@"Connect and Share"];
    else
        buttonLabel.text = [NSString stringWithFormat:@"Share"];
    
    [bigShareButton setBackgroundImage:[UIImage imageNamed:imagePath1] forState:UIControlStateNormal];
    [bigShareButton setBackgroundImage:[UIImage imageNamed:imagePath2] forState:UIControlStateSelected];
    
    [UIView commitAnimations];
    
    
    //[myTableView reloadData];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
        [myActivitySpinner stopAnimating];
		[myActivitySpinner setHidden:YES];
		[myLoadingLabel setHidden:YES];
		
        [self addProvidersToTabBar];
		[myTableView reloadData];
        
		return;
	}
	
	/* Otherwise, keep polling until we've timed out. */
	if (interval >= 8.0)
	{	
		DLog(@"No Available Providers");
        
		[myActivitySpinner setHidden:YES];
		[myLoadingLabel setHidden:YES];
		[myActivitySpinner stopAnimating];
		
		UIApplication* app = [UIApplication sharedApplication]; 
		app.networkActivityIndicatorVisible = YES;
        
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


- (void)keyboardWillShow:(NSNotification *)notif
{
//    [keyboardToolbar setHidden:NO];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];	

    [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
//    [UIView beginAnimations:@"show" context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView	setAnimationDelay:0.0];
//    [keyboardToolbar setFrame:CGRectMake(0, 156, 320, 44)];
//    [keyboardToolbar setAlpha:1.0];
//    [UIView commitAnimations];    
}

- (void)keyboardDidShow:(NSNotification *)notif
{
    
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];	
    
    [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
//    [UIView beginAnimations:@"show" context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView	setAnimationDelay:0.0];
//    [keyboardToolbar setFrame:CGRectMake(0, 416, 320, 44)];
//    [keyboardToolbar setAlpha:0.0];
//    [UIView commitAnimations];    
}

- (void)keyboardDidHide:(NSNotification *)notif
{
//    [keyboardToolbar setHidden:YES];
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

        [grayView setHidden:YES];
        [myLoadingLabel setHidden:YES];
        [myActivitySpinner stopAnimating];   
        buttonLabel.text = @"Shared";
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
    
    [grayView setHidden:YES];
    [myLoadingLabel setHidden:YES];
    [myActivitySpinner stopAnimating];   
    
    
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
    
    [grayView setHidden:NO];
    [myLoadingLabel setHidden:NO];
    [myActivitySpinner setHidden:NO];
    myLoadingLabel.text = @"Sharing...";
    [myActivitySpinner startAnimating];
    
    if ([jrAuth theTokenUrl])
        [sessionData makeCallToTokenUrl:[jrAuth theTokenUrl] WithToken:token];

}


- (void)jrAuthenticateDidReachTokenURL:(NSString*)tokenURL withPayload:(NSString*)tokenUrlPayload 
{ 
    DLog(@"");
    NSString *identifier = [[sessionData authenticatedIdentifierForProvider:selectedProvider] retain];
       
    if (identifier)
    {
        [self shareActivityForIdentifier:identifier];
    }
    else 
    {  
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Shared"
                                                         message:@"There was an error while sharing this activity: %@"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil] autorelease];
        [alert show];
        
        [grayView setHidden:YES];
        [myLoadingLabel setHidden:YES];
        [myActivitySpinner stopAnimating];   
    }


//    [grayView setHidden:YES];
//    [myLoadingLabel setHidden:YES];
//    myLoadingLabel.text = @"Sharing...";
//    [myActivitySpinner stopAnimating];    
    
    sessionData.delegate = jrAuth;
}

- (void)jrAuthenticationDidFailWithError:(NSError*)error { DLog(@""); }

- (void)jrAuthenticateCallToTokenURL:(NSString*)tokenURL didFailWithError:(NSError*)error { DLog(@""); }

- (void)jrAuthenticationDidCancel { DLog(@""); }


- (void)shareActivityForIdentifier:(NSString*)identifier
{
    DLog(@"");
    
    if (userContent_textview.text)
        activity.user_generated_content = userContent_textview.text;
    
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
    NSString *identifier = [[sessionData authenticatedIdentifierForProvider:selectedProvider] retain];
    
    
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

- (IBAction)doneButtonPressed:(id)sender
{
    [hideKeyboardButton removeFromSuperview];
    [userContent_textview resignFirstResponder];    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//	return 200;
//}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    if (!providers)
        return 0;

    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (!providers)
        return 0;

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 260;
    
    return 150;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    DLog(@"");
    
	if (indexPath.section == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sectionTwo"];
        
        if (cell == nil)
        {
            DLog(@"New cell");
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sectionTwo"] autorelease];
            UIView *view = cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 120)] autorelease];
            view.backgroundColor = cell.backgroundColor = [UIColor clearColor];
            
            buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 107, 40)];
            buttonLabel.text = @"Connect and Share";
            buttonLabel.font = [UIFont systemFontOfSize:16.0];
            buttonLabel.textAlignment = UITextAlignmentLeft;
            buttonLabel.textColor = [UIColor whiteColor];
            buttonLabel.lineBreakMode = UILineBreakModeWordWrap;
            buttonLabel.numberOfLines = 2;
            buttonLabel.backgroundColor = [UIColor clearColor];
            buttonLabel.shadowColor = [UIColor grayColor];
            buttonLabel.shadowOffset = CGSizeMake(-1, -1);
 
            if (!selectedProvider)
                selectedProvider = [[providers objectAtIndex:0] retain];

            DLog(@"selectedProvider: %@", selectedProvider);
            
            //    NSDictionary* provider_stats = [sessionData.providerInfo objectForKey:selectedProvider];
            
            //    NSString *friendly_name = [provider_stats objectForKey:@"friendly_name"];
            NSString *imagePath1 = [NSString stringWithFormat:@"jrauth_%@_logo_share.png", selectedProvider];
            NSString *imagePath2 = [NSString stringWithFormat:@"jrauth_%@_logo_share_selected.png", selectedProvider];
            
            NSString *identifier = [[sessionData authenticatedIdentifierForProvider:selectedProvider] retain];
            
            //    NSString *bigButtonTitle = nil;
            
            if (!identifier)
                buttonLabel.text = [NSString stringWithFormat:@"Connect and Share"];
            else
                buttonLabel.text = [NSString stringWithFormat:@"Share"];
            
            
            bigShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [bigShareButton setFrame:CGRectMake(0, 0, 300, 54)];
            
            [bigShareButton setBackgroundImage:[UIImage imageNamed:imagePath1] forState:UIControlStateNormal];
            [bigShareButton setBackgroundImage:[UIImage imageNamed:imagePath2] forState:UIControlStateSelected];
            
            
            
            
            //UIButton *facebook = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            [facebook setFrame:CGRectMake(10, 0, 60, 38)];
//                        
//            UIButton *twitter = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            [twitter setFrame:CGRectMake(80, 0, 60, 38)];
//                        
//            UIButton *yahoo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            [yahoo setFrame:CGRectMake(150, 0, 60, 38)];
//            
//            facebook.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
//            [facebook setTitle:@"Facebook\nConnect" forState:UIControlStateNormal];
//            twitter.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
//            [twitter setTitle:@"Twitter\nConnect" forState:UIControlStateNormal];
//            yahoo.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
//            [yahoo setTitle:@"Yahoo!\nConnect" forState:UIControlStateNormal];
//
//            [facebook addTarget:self
//                               action:@selector(shareButtonPressed:) 
//                     forControlEvents:UIControlEventTouchUpInside];
            
  
            //[bigShareButton setBackgroundImage:[UIImage imageNamed:@"big_blue_button.png"] forState:UIControlStateNormal];
            //          [bigShareButton setBackgroundImage:[UIImage imageNamed:@"jrauth_share_default.png"] forState:UIControlStateNormal];
//            bigShareButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
//            [bigShareButton setTitle:@"Share" forState:UIControlStateNormal];
//            [bigShareButton setTitleColor:[UIColor whiteColor] 
//                                 forState:UIControlStateNormal];
//            [bigShareButton setTitleShadowColor:[UIColor grayColor]
//                                       forState:UIControlStateNormal];
//            
//            [bigShareButton setTitle:@"Share" forState:UIControlStateSelected];
//            [bigShareButton setTitleColor:[UIColor whiteColor] 
//                                 forState:UIControlStateSelected];	
//            [bigShareButton setTitleShadowColor:[UIColor grayColor]
//                                       forState:UIControlStateSelected];	
//            [bigShareButton setReversesTitleShadowWhenHighlighted:YES];
            
            [bigShareButton addTarget:self
                               action:@selector(shareButtonPressed:) 
                     forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *shareLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 35)] autorelease];
            shareLabel.font = [UIFont boldSystemFontOfSize:24.0];
            shareLabel.textAlignment = UITextAlignmentCenter;
            shareLabel.backgroundColor = [UIColor blueColor];
            shareLabel.text = @"Share";
            
            [cell.contentView addSubview:bigShareButton];
            [cell.contentView addSubview:buttonLabel];
//            [cell.contentView addSubview:facebook];
//            [cell.contentView addSubview:yahoo];
//            [cell.contentView addSubview:twitter];
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;    
    }
    
//    DLog(@"cell for %@", sessionData.currentSocialProvider.name);   
    
//  static NSInteger displayNameAndAction_tag = 1;
//	static NSInteger contentTitle_tag = 2;
//	static NSInteger contentDescription_tag = 3;
//	static NSInteger thumbnail_tag = 4;
//	static NSInteger userContent_tag = 5;
  
	UITableViewCellStyle style = UITableViewCellStyleDefault;
	NSString *reuseIdentifier = @"cachedCell";

    UITableViewCell *cell =
        (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
	if (cell == nil)
    {
		cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier] autorelease];
//		CGRect frame;
//		frame.origin.x = 10; 
//		frame.origin.y = 5;
//		frame.size.height = 345;
//		frame.size.width = 280;
		
        displayNameAndAction_label  = [[[UITextView alloc] initWithFrame:CGRectMake(2, 0, 297, 26)] autorelease];
        contentTitle_label          = [[[UITextView alloc] initWithFrame:CGRectMake(97, 30, 203, 25)] autorelease];
        contentDescription_label    = [[[UITextView alloc] initWithFrame:CGRectMake(97, 45, 203, 75)] autorelease];
        thumbnail_imageview         = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 90, 90)] autorelease];
        userContent_textview        = [[[UITextView alloc] initWithFrame:CGRectMake(10, 128, 280, 122)] autorelease];
        
        UIButton *userContent_background = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [userContent_background setFrame:CGRectMake(10, 125, 280, 125)];
        
//        displayNameAndAction_label.tag  = displayNameAndAction_tag;
//        contentTitle_label.tag          = contentTitle_tag;
//        contentDescription_label.tag    = contentDescription_tag;
//        thumbnail_imageview.tag         = thumbnail_tag;
//        userContent_textview.tag        = userContent_tag;
        
        displayNameAndAction_label.backgroundColor  = [UIColor clearColor];
        contentTitle_label.backgroundColor          = [UIColor clearColor];
        contentDescription_label.backgroundColor    = [UIColor clearColor];
        thumbnail_imageview.backgroundColor         = [UIColor clearColor];
        userContent_textview.backgroundColor        = [UIColor clearColor];
        
        userContent_background.userInteractionEnabled = FALSE;
//        [userContent_background ssetButtonType:UIButtonTypeRoundedRect];    
        
        displayNameAndAction_label.scrollEnabled = FALSE;
        displayNameAndAction_label.userInteractionEnabled = FALSE;
        displayNameAndAction_label.font = [UIFont systemFontOfSize:14.0];
//        displayNameAndAction_label.minimumFontSize = 10.0;
//        displayNameAndAction_label.numberOfLines = 2;
//        [displayNameAndAction_label setAdjustsFontSizeToFitWidth:YES];
        
        contentTitle_label.scrollEnabled = FALSE;
        contentTitle_label.userInteractionEnabled = FALSE;
        contentTitle_label.font = [UIFont systemFontOfSize:12.0];
//        contentTitle_label.minimumFontSize = 8.0;
//        contentTitle_label.numberOfLines = 1;
//        [contentTitle_label setAdjustsFontSizeToFitWidth:YES];
        
        contentDescription_label.scrollEnabled = FALSE;
        contentDescription_label.userInteractionEnabled = FALSE;
        contentDescription_label.font = [UIFont systemFontOfSize:12.0];
//        contentDescription_label.minimumFontSize = 8.0;
//        contentDescription_label.numberOfLines = 3;
//        [contentDescription_label setAdjustsFontSizeToFitWidth:YES];
        
        thumbnail_imageview.image = [UIImage imageNamed:@"lilli.jpg"];
        
        userContent_textview.keyboardType = UIKeyboardTypeDefault;
        userContent_textview.inputAccessoryView = keyboardToolbar;
//        userContent_textview.returnKeyType = UIReturnKeyReturn;
//        userContent_textview.enablesReturnKeyAutomatically = YES;
//        userContent_textview.keyboardAppearance = UIKeyboardAppearanceAlert;
//        [userContent_textview canResignFirstResponder:YES];
        
        [cell.contentView addSubview:userContent_background];
        [cell.contentView addSubview:displayNameAndAction_label];
        [cell.contentView addSubview:contentTitle_label];
        [cell.contentView addSubview:contentDescription_label];
        [cell.contentView addSubview:thumbnail_imageview];
        [cell.contentView addSubview:userContent_textview];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }        

    displayNameAndAction_label.text = [NSString stringWithFormat:@"%@ %@", activity.display_name, activity.action];
    contentTitle_label.text = [NSString stringWithFormat:@"%@", activity.title];
    contentDescription_label.text = [NSString stringWithFormat:@"%@", activity.description];
    userContent_textview.text = [NSString stringWithFormat:@"%@", activity.user_generated_content];        
	
    
	return cell;
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
