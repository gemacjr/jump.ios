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

 File:   JRPublishActivityController.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, August 24, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import <UIKit/UIKit.h>
#import "JRPublishActivityController.h"
#import "JREngage+CustomInterface.h"


@interface JRProvider (SOCIAL_SHARING_PROPERTIES)
- (BOOL)willThunkPublishToStatusForActivity:(JRActivityObject*)activity;
//- (BOOL)doesActivityUrlAffectCharacterCount;
- (BOOL)isActivityUrlPartOfUserContent;
- (BOOL)canShareRichDataForActivity:(JRActivityObject*)activity;
- (BOOL)doesContentReplaceAction;
- (NSInteger)maxCharactersForSetStatus;
- (NSInteger)maxCharactersForPublishActivity;
@end

@implementation JRProvider (SOCIAL_SHARING_PROPERTIES)
/* Right now, LinkedIn and Yahoo! */
- (BOOL)willThunkPublishToStatusForActivity:(JRActivityObject*)activity
{
 /* If the activity url is nil (or empty) certain providers will thunk from publish activity to set_status */
    return ((![activity url] || [[activity url] isEqualToString:@""]) &&
            [[self.socialSharingProperties objectForKey:@"uses_set_status_if_no_url"] isEqualToString:@"YES"]);
}

//- (BOOL)doesActivityUrlAffectCharacterCount
- (BOOL)isActivityUrlPartOfUserContent
{
    BOOL url_reduces_max_chars = [[self.socialSharingProperties objectForKey:@"url_reduces_max_chars"] isEqualToString:@"YES"];
    BOOL shows_url_as_url = [[self.socialSharingProperties objectForKey:@"shows_url_as"] isEqualToString:@"url"];

    /* Twitter/MySpace -> true */
    return (url_reduces_max_chars && shows_url_as_url);
}

- (BOOL)canShareRichDataForActivity:(JRActivityObject*)activity
{
 /* If the provider can share media (Facebook and LinkedIn) and we're not going to thunk
    to set_status (Yahoo! and LinkedIn when there's no activity url) */
    if ([[self.socialSharingProperties objectForKey:@"can_share_media"] isEqualToString:@"YES"] &&
        ![self willThunkPublishToStatusForActivity:activity])
        return YES;

    return NO;
}

- (BOOL)doesContentReplaceAction
{
    if ([[self.socialSharingProperties objectForKey:@"content_replaces_action"] isEqualToString:@"YES"])
        return YES;

    return NO;
}

- (NSInteger)maxCharactersForSetStatus
{
    return [((NSString*)[((NSDictionary*)[[self socialSharingProperties] objectForKey:@"set_status_properties"]) objectForKey:@"max_characters"]) intValue];
}

- (NSInteger)maxCharactersForPublishActivity
{
    return [((NSString*)[[self socialSharingProperties] objectForKey:@"max_characters"]) intValue];
}


@end

@implementation RoundedRectView
@synthesize outerStrokeColor;
@synthesize innerStrokeColor;
@synthesize outerFillColor;
@synthesize innerFillColor;
@synthesize outerStrokeWidth;
@synthesize innerStrokeWidth;
@synthesize outerCornerRadius;
@synthesize innerCornerRadius;
@synthesize drawInnerRect;

- (id)initWithCoder:(NSCoder *)decoder
{
    DLog(@"");
    if ((self = [super initWithCoder:decoder]))
    {
        self.outerStrokeColor  = OUTER_STROKE_COLOR;
        self.innerStrokeColor  = INNER_STROKE_COLOR;
        self.outerFillColor    = OUTER_FILL_COLOR;
        self.innerFillColor    = INNER_FILL_COLOR;
        self.outerStrokeWidth  = OUTER_STROKE_WIDTH;
        self.innerStrokeWidth  = INNER_STROKE_WIDTH;
        self.outerCornerRadius = OUTER_CORNER_RADIUS;
        self.innerCornerRadius = INNER_CORNER_RADIUS;
        self.backgroundColor   = [UIColor clearColor];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    DLog(@"");
    if ((self = [super initWithFrame:frame]))
    {
        self.opaque            = NO;
        self.outerStrokeColor  = OUTER_STROKE_COLOR;
        self.innerStrokeColor  = INNER_STROKE_COLOR;
        self.outerFillColor    = OUTER_FILL_COLOR;
        self.innerFillColor    = INNER_FILL_COLOR;
        self.outerStrokeWidth  = OUTER_STROKE_WIDTH;
        self.innerStrokeWidth  = INNER_STROKE_WIDTH;
        self.outerCornerRadius = OUTER_CORNER_RADIUS;
        self.innerCornerRadius = INNER_CORNER_RADIUS;
        self.backgroundColor   = [UIColor clearColor];
    }
    return self;
}
- (void)setBackgroundColor:(UIColor *)newBGColor
{
    // Ignore any attempt to set background color - backgroundColor must stay set to clearColor
    // We could throw an exception here, but that would cause problems with IB, since backgroundColor
    // is a palletized property, IB will attempt to set backgroundColor for any view that is loaded
    // from a nib, so instead, we just quietly ignore this.
    //
    // Alternatively, we could put an NSLog statement here to tell the programmer to set rectColor...
}
- (void)setOpaque:(BOOL)newIsOpaque
{
    // Ignore attempt to set opaque to YES.
}

- (void)drawRoundedRect:(CGRect)rrect withRadius:(CGFloat)radius
        strokeWidth:(CGFloat)strokeWidth strokeColor:(UIColor*)strokeColor andFillColor:(UIColor*)fillColor
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);

    CGFloat width = CGRectGetWidth(rrect);
    CGFloat height = CGRectGetHeight(rrect);

    // Make sure corner radius isn't larger than half the shorter side
    if (radius > width/2.0)
        radius = width/2.0;
    if (radius > height/2.0)
        radius = height/2.0;

    CGFloat minx = CGRectGetMinX(rrect);
    CGFloat midx = CGRectGetMidX(rrect);
    CGFloat maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect);
    CGFloat midy = CGRectGetMidY(rrect);
    CGFloat maxy = CGRectGetMaxY(rrect);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawRect:(CGRect)rect
{
    DLog(@"");

    [self drawRoundedRect:self.bounds
               withRadius:outerCornerRadius strokeWidth:outerStrokeWidth
              strokeColor:outerStrokeColor andFillColor:outerFillColor];

    if (drawInnerRect)
        [self drawRoundedRect:CGRectMake(INNER_RECT_INSET, INNER_RECT_INSET,
                                         self.bounds.size.width - (2 * INNER_RECT_INSET),
                                         self.bounds.size.height - (2 * INNER_RECT_INSET))
                   withRadius:innerCornerRadius strokeWidth:innerStrokeWidth
                  strokeColor:innerStrokeColor andFillColor:innerFillColor];
}

- (void)dealloc {
    [outerStrokeColor release];
    [innerStrokeColor release];
    [outerFillColor release];
    [innerFillColor release];
    [super dealloc];
}
@end

@interface JRPublishActivityController ()
- (void)addProvidersToTabBar;
- (void)determineIfWeCanShareViaEmailAndOrSMS;
- (void)loadActivityToViewForFirstTime;
- (void)sendEmail;
- (void)sendSMS;
- (void)showViewIsLoading:(BOOL)loading;
- (void)setProfilePicToDefaultPic;
- (void)fetchProfilePicFromUrl:(NSString*)profilePicUrl forProvider:(NSString*)providerName;
- (void)setButtonImage:(UIButton*)button toData:(NSData*)data andSetLoading:(UIActivityIndicatorView*)actIndicator toLoading:(BOOL)loading;
@property (retain) JRProvider *selectedProvider;
@property (retain) JRAuthenticatedUser *loggedInUser;
@end

@implementation JRPublishActivityController
@synthesize hidesCancelButton;
@synthesize selectedProvider;
@synthesize loggedInUser;
@synthesize myBackgroundView, myTabBar, myLoadingLabel, myLoadingActivitySpinner, myLoadingGrayView,
            myPadGrayEditingViewTop, myPadGrayEditingViewBottom, myContentView, myScrollView, myUserCommentTextView,
            myUserCommentBoundingBox, myRemainingCharactersLabel, myEntirePreviewContainer, myPreviewContainerRoundedRect,
            myPreviewOfTheUserCommentLabel, myRichDataContainer, myMediaThumbnailView, myMediaThumbnailActivityIndicator,
            myTitleLabel, myDescriptionLabel, myInfoButton, myPoweredByLabel, myProviderIcon, myShareToView,
            myTriangleIcon, myConnectAndShareButton, myJustShareButton, myProfilePic, myProfilePicActivityIndicator,
            myUserName, mySignOutButton, mySharedCheckMark, mySharedLabel;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil andCustomInterface:(NSDictionary*)theCustomInterface
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        customInterface = [theCustomInterface retain];

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

    sessionData     = [JRSessionData jrSessionData];
    currentActivity = [[sessionData activity] retain];

 /* There's a slight chance that their capacities could be 0, but that's OK; they're mutable. */
    alreadyShared = [[NSMutableSet alloc] initWithCapacity:[[sessionData socialProviders] count]];
    cachedProfilePics = [[NSMutableDictionary alloc] initWithCapacity:[[sessionData socialProviders] count]];

    if ([[customInterface objectForKey:kJRSocialSharingTitleString] isKindOfClass:[NSString class]])
        self.title = NSLocalizedString([customInterface objectForKey:kJRSocialSharingTitleString], @"");
    else
        self.title = NSLocalizedString(@"Share", @"");

 /* Load the custom background view, if there is one. */
    if ([customInterface objectForKey:kJRSocialSharingBackgroundImageView])
        [myBackgroundView addSubview:[customInterface objectForKey:kJRSocialSharingBackgroundImageView]];

    [myBackgroundView setAlpha:0.3];

 /* If there is a UIColor object set for the background color, use this */
    if ([customInterface objectForKey:kJRSocialSharingBackgroundColor])
        myBackgroundView.backgroundColor = [customInterface objectForKey:kJRSocialSharingBackgroundColor];

    // TODO: WHY CAN'T I SET THIS IN THE NIB?
    myContentView.backgroundColor = [UIColor clearColor];

    titleView = [[customInterface objectForKey:kJRSocialSharingTitleView] retain];

    if (titleView)
        self.navigationItem.titleView = titleView;

    if (!hidesCancelButton)
    {
        UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                     target:sessionData
                                                     action:@selector(triggerPublishingDidCancel:)] autorelease];

        self.navigationItem.leftBarButtonItem         = cancelButton;
        self.navigationItem.leftBarButtonItem.enabled = YES;

        self.navigationItem.leftBarButtonItem.style   = UIBarButtonItemStyleBordered;
    }

    UIBarButtonItem *editButton = [[[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                     target:self
                                                     action:@selector(editButtonPressed:)] autorelease];

    self.navigationItem.rightBarButtonItem         = editButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;

    self.navigationItem.rightBarButtonItem.style   = UIBarButtonItemStyleBordered;

    if ([sessionData hidePoweredBy])
    {
        [myPoweredByLabel setHidden:YES];
        [myInfoButton setHidden:YES];
    }


//    [myPadGrayEditingViewTop setBackgroundColor:[UIColor redColor]];
//    [myPadGrayEditingViewBottom setBackgroundColor:[UIColor blueColor]];


 /* Set RoundedRect defaults */
    [myPreviewContainerRoundedRect setOuterFillColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
    [myPreviewContainerRoundedRect setDrawInnerRect:YES];
    [myRichDataContainer setOuterFillColor:[UIColor lightGrayColor]];
    [myRichDataContainer setOuterStrokeColor:[UIColor lightGrayColor]];
    [myRichDataContainer setOuterCornerRadius:5.0];
    [myUserCommentBoundingBox setOuterStrokeColor:[UIColor darkGrayColor]];
    [myUserCommentBoundingBox setOuterFillColor:[UIColor whiteColor]];
    [myUserCommentBoundingBox setOuterStrokeWidth:1.5];
    [myUserCommentBoundingBox setAlpha:0.3];
    [myPreviewContainerRoundedRect setNeedsDisplay];
    [myRichDataContainer setNeedsDisplay];
    [myUserCommentBoundingBox setNeedsDisplay];

    [myScrollView setContentSize:CGSizeMake(320, 264)];

    [self determineIfWeCanShareViaEmailAndOrSMS];
    [self loadActivityToViewForFirstTime];

 /* If the user calls the library before the session data object is done initializing -
    because either the requests for the base URL or provider list haven't returned -
    display the "Loading Providers" label and activity spinner.
    sessionData = nil when the call to get the base URL hasn't returned
    [sessionData.configuredProviders count] = 0 when the provider list hasn't returned */
    if ([[sessionData socialProviders] count] == 0)
    {
        DLog(@"[[sessionData socialProviders] count] == 0");
        weAreStillWaitingOnSocialProviders = YES;

        myLoadingLabel.font = [UIFont systemFontOfSize:18.0];
        myLoadingLabel.text = NSLocalizedString(@"Loading providers. Please wait...", @"");

     /* Since the method showViewIsLoading will disable the "Cancel" button, reenable it for this case */
        [self showViewIsLoading:YES];
        self.navigationItem.leftBarButtonItem.enabled = YES;

     /* Now poll every few milliseconds, for about 16 seconds, until the provider list is loaded or we time out. */
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkSessionDataAndProviders:) userInfo:nil repeats:NO];
    }
    else
    {
        weAreStillWaitingOnSocialProviders = NO;
        [self addProvidersToTabBar];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    DLog(@"");

    [super viewWillAppear:animated];

    self.contentSizeForViewInPopover = CGSizeMake(320, 416);

// /* We need to figure out if the user canceled authentication by hitting the back button or the cancel button,
//    or if it stopped because it failed or completed successfully on its own.  Assume that the user did hit the
//    back button until told otherwise. */
//  userHitTheBackButton = YES;

    // TODO: Why is this in viewWillAppear and not above in viewDidLoad??
    if (!titleView)
    {
        UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
        titleLabel.backgroundColor           = [UIColor clearColor];
        titleLabel.font                      = [UIFont boldSystemFontOfSize:20.0];
        titleLabel.shadowColor               = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleLabel.textAlignment             = UITextAlignmentCenter;
        titleLabel.textColor                 = [UIColor whiteColor];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.minimumFontSize           = 18.0;

        if ([customInterface objectForKey:kJRSocialSharingTitleString])
            titleLabel.text = NSLocalizedString([customInterface objectForKey:kJRSocialSharingTitleString], @"");
        else if (selectedProvider)
            titleLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Share on", @""), selectedProvider.friendlyName];
        else
            titleLabel.text = NSLocalizedString(@"Share", @"");

        titleView = [titleLabel retain];
        self.navigationItem.titleView = titleView;
    }

//    if (!weAreStillWaitingOnSocialProviders)
//        [self adjustRichDataContainer];
}

- (void)viewDidAppear:(BOOL)animated
{
    DLog(@"");
    [super viewDidAppear:animated];

    if (!weAreStillWaitingOnSocialProviders && !weAreCurrentlyPostingSomething)
        [self showViewIsLoading:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLog(@"");
    [sessionData triggerPublishingDidTimeOutConfiguration];
}

#define CONFIGURATION_TIMEOUT 32.0

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
        weAreStillWaitingOnSocialProviders = NO;

        [self showViewIsLoading:NO];

     /* Set the loading label font/text back to default "Sharing..." */
        myLoadingLabel.font = [UIFont systemFontOfSize:24.0];
        myLoadingLabel.text = NSLocalizedString(@"Sharing...", @"");

        [self addProvidersToTabBar];

        return;
    }

 /* Otherwise, keep polling until we've timed out. */
    if (interval >= CONFIGURATION_TIMEOUT)
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

/* That is, cover the view with a transparent gray box and a large white activity indicator. */
- (void)showViewIsLoading:(BOOL)loading
{
    DLog(@"");

    /* Don't let the user edit or cancel while the activity is being shared */
    self.navigationItem.leftBarButtonItem.enabled  = !loading;
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
    if (loggedIn)
        [myPreviewOfTheUserCommentLabel setUsername:loggedInUser.preferredUsername];
    else
        [myPreviewOfTheUserCommentLabel setUsername:@"You"];

    [UIView beginAnimations:@"buttonSlide" context:nil];
    [myJustShareButton setHidden:!loggedIn];
    [myConnectAndShareButton setHidden:loggedIn];

    [myTriangleIcon setFrame:CGRectMake(loggedIn ?
            ([myTriangleIcon superview].frame.size.width - 90) :
            ([myTriangleIcon superview].frame.size.width / 2) - 9, 0, 18, 18)];

//    [myTriangleIcon setFrame:CGRectMake(loggedIn ? 230 : 151, 0, 18, 18)];

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

    [myTriangleIcon setFrame:CGRectMake(shared ? 25 : ((loggedInUser) ?
            ([myTriangleIcon superview].frame.size.width - 90) :
            ([myTriangleIcon superview].frame.size.width / 2) - 9), 0, 18, 18)];

//    [myTriangleIcon setFrame:CGRectMake(shared ? 25 : ((loggedInUser) ? 230 : 151), 0, 18, 18)];

    if (!hidesCancelButton)
    {
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

        self.navigationItem.leftBarButtonItem         = barButton;
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}

- (void)updatePreviewTextWhenContentReplacesAction
{
    DLog(@"");
    NSString *username = (loggedInUser) ?
                                loggedInUser.preferredUsername :
                                @"You";

    NSString *url      = (shortenedActivityUrl) ?
                                shortenedActivityUrl :
                                @"shortening url...";

    NSString *text     = (![[myUserCommentTextView text] isEqualToString:@""]) ?
                                [myUserCommentTextView text] :
                                [currentActivity action];

    [myPreviewOfTheUserCommentLabel setUsername:username];
    [myPreviewOfTheUserCommentLabel setUsertext:text];

//    if ([self doesActivityUrlAffectCharacterCountForSelectedProvider:nil])
    if ([selectedProvider isActivityUrlPartOfUserContent])
    { /* Twitter/MySpace -> true */

        // TODO: Add ability to set colors to preview label (Janrain blue for links)
        // TODO: Fix size of url when long and on own line (shouldn't trunk at 3/4)
        [myPreviewOfTheUserCommentLabel setUrl:url];
    }
    else
    {
        [myPreviewOfTheUserCommentLabel setUrl:nil];
    }
}

- (void)updatePreviewTextWhenContentDoesNotReplaceAction
{
    DLog(@"");
    NSString *username = (loggedInUser) ? loggedInUser.preferredUsername : @"You";
    NSString *text     = currentActivity.action;

    [myPreviewOfTheUserCommentLabel setUsername:username];
    [myPreviewOfTheUserCommentLabel setUsertext:text];
    [myPreviewOfTheUserCommentLabel setUrl:nil];
}

- (BOOL)shouldHideRemainingCharacterCount
{
    if (maxCharacters == -1 || maxCharacters > 500)
        return YES;

    return NO;
}

- (void)updateCharacterCount
{
    // TODO: verify correctness of the 0 remaining characters edge case
    NSString *characterCountText;

    if ([self shouldHideRemainingCharacterCount])
        return;

    int chars_remaining = 0;
    if ([selectedProvider doesContentReplaceAction])
    {
        /* Twitter, MySpace, LinkedIn */
        if ([selectedProvider isActivityUrlPartOfUserContent] && shortenedActivityUrl == nil)
        {
            /* Twitter, MySpace */
            characterCountText = @"Calculating remaining characters";
        }
        else
        {
            int preview_length = [[myPreviewOfTheUserCommentLabel text] length];
            chars_remaining    = maxCharacters - preview_length;

            characterCountText = [NSString stringWithFormat:@"Remaining characters: %d", chars_remaining]; // TODO: Make just character number red
        }
    }
    else
    { /* Facebook, Yahoo */
        int comment_length = [[myUserCommentTextView text] length];
        chars_remaining    = maxCharacters - comment_length;

        characterCountText = [NSString stringWithFormat:@"Remaining characters: %d", chars_remaining]; // TODO: Make just character number red
    }

    [myRemainingCharactersLabel setText:characterCountText];

    if (chars_remaining < 0)
        [myRemainingCharactersLabel setTextColor:[UIColor redColor]]; // TODO: Make just character number red with attributed label
    else
        [myRemainingCharactersLabel setTextColor:[UIColor darkGrayColor]];

    DLog(@"updateCharacterCount: %@", characterCountText);
}

- (void)adjustRichDataContainerVisibility
{
    DLog(@"");

    // TODO: Move somewhere else!!  Did I already??
    //    if (!hasEditedUserContentForActivityAlready)
    //        myUserContentTextView.text = _activity.action;
    //    else
    //        myUserContentTextView.text = _activity.user_generated_content;

    if ([selectedProvider canShareRichDataForActivity:currentActivity] && activityHasRichData)
    {
        [myEntirePreviewContainer setFrame:CGRectMake(myEntirePreviewContainer.frame.origin.x,
                                                      myEntirePreviewContainer.frame.origin.y,
                                                      myEntirePreviewContainer.frame.size.width,
                                                      mediaBoxHeight + previewLabelHeight + 32.0)];
        [myRichDataContainer setHidden:NO];
    }
    else
    {
        [myRichDataContainer setHidden:YES];
        [myEntirePreviewContainer setFrame:CGRectMake(myEntirePreviewContainer.frame.origin.x,
                                                myEntirePreviewContainer.frame.origin.y,
                                                myEntirePreviewContainer.frame.size.width,
                                                previewLabelHeight + 28.0)];
    }

    [myPreviewContainerRoundedRect setNeedsDisplay];
}

- (void)loadUserNameAndProfilePicForUser:(JRAuthenticatedUser*)user forProvider:(NSString*)providerName
{
    DLog(@"");
    myUserName.text = user.preferredUsername;

    NSData *cachedProfilePic = [cachedProfilePics objectForKey:providerName];

    if (cachedProfilePic)
        [self setButtonImage:myProfilePic toData:cachedProfilePic andSetLoading:myProfilePicActivityIndicator toLoading:NO];
    else if (user.photo)
        [self fetchProfilePicFromUrl:user.photo forProvider:providerName];
    else
        [self setProfilePicToDefaultPic];
}

#define EDITING_HEIGHT_OFFSET                     24
#define USER_CONTENT_TEXT_VIEW_DEFAULT_HEIGHT     72
#define USER_CONTENT_BOUNDING_BOX_DEFAULT_HEIGHT  78
#define CHARACTER_COUNT_DEFAULT_Y_ORIGIN          90
#define PREVIEW_BOX_DEFAULT_Y_ORIGIN              97
#define USER_CONTENT_TEXT_VIEW_EDITING_HEIGHT    (USER_CONTENT_TEXT_VIEW_DEFAULT_HEIGHT    + EDITING_HEIGHT_OFFSET)
#define USER_CONTENT_BOUNDING_BOX_EDITING_HEIGHT (USER_CONTENT_BOUNDING_BOX_DEFAULT_HEIGHT + EDITING_HEIGHT_OFFSET)
#define CHARACTER_COUNT_EDITING_Y_ORIGIN         (CHARACTER_COUNT_DEFAULT_Y_ORIGIN         + EDITING_HEIGHT_OFFSET)
#define PREVIEW_BOX_EDITING_Y_ORIGIN             (PREVIEW_BOX_DEFAULT_Y_ORIGIN             + EDITING_HEIGHT_OFFSET)
#define SCROLL_VIEW_DEFAULT_HEIGHT_PORTRAIT       264
#define SCROLL_VIEW_DEFAULT_HEIGHT_LANDSCAPE      116
#define SCROLL_VIEW_EDITING_HEIGHT_PORTRAIT       200
#define SCROLL_VIEW_EDITING_HEIGHT_LANDSCAPE      106

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    DLog(@"");

#if JRENGAGE_INCLUDE_EMAIL_SMS
    if (item.tag == [[sessionData socialProviders] count])
    {
        UIActionSheet *action;
        switch (emailAndOrSmsIndex)
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
        //        [selectedProvider release];
        //        [loggedInUser release];

        self.selectedProvider = [sessionData getSocialProviderAtIndex:item.tag];
        [sessionData setCurrentProvider:selectedProvider];

        self.loggedInUser = [sessionData authenticatedUserForProvider:selectedProvider];

        selectedTab = item.tag;

        NSArray *colorArray = [selectedProvider.socialSharingProperties objectForKey:@"color_values"];
        if ([colorArray count] == 4)
        {
            myShareToView.backgroundColor = [UIColor colorWithRed:[((NSString*)[colorArray objectAtIndex:0]) floatValue]
                                                            green:[((NSString*)[colorArray objectAtIndex:1]) floatValue]
                                                             blue:[((NSString*)[colorArray objectAtIndex:2]) floatValue]
                                                            alpha:0.2];

            myPreviewContainerRoundedRect.innerStrokeColor = [UIColor colorWithRed:[((NSString*)[colorArray objectAtIndex:0]) floatValue]
                                                                    green:[((NSString*)[colorArray objectAtIndex:1]) floatValue]
                                                                     blue:[((NSString*)[colorArray objectAtIndex:2]) floatValue]
                                                                    alpha:1.0];
            [myPreviewContainerRoundedRect setNeedsDisplay];
        }

        [myConnectAndShareButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:
                                                                         @"button_%@_280x40.png",
                                                                         selectedProvider.name]]
                                           forState:UIControlStateNormal];

        [myJustShareButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:
                                                                   @"button_%@_135x40.png",
                                                                   selectedProvider.name]]
                                     forState:UIControlStateNormal];

        myProviderIcon.image = [UIImage imageNamed:[NSString stringWithFormat:
                                                    @"icon_%@_30x30.png",
                                                    selectedProvider.name]];

        if (![customInterface objectForKey:kJRSocialSharingTitleString] &&
            ![customInterface objectForKey:kJRSocialSharingTitleView])
            ((UILabel*)titleView).text = [NSString stringWithFormat:@"%@ %@",
                                          NSLocalizedString(@"Share on", @""),
                                          selectedProvider.friendlyName];

        // Here because you can switch tabs while editing on the iPad, yes??
        currentActivity.user_generated_content = myUserCommentTextView.text;

        if (loggedInUser)
        {
            [self showUserAsLoggedIn:YES];
            [self loadUserNameAndProfilePicForUser:loggedInUser forProvider:selectedProvider.name];
        }
        else
        {
            [self showUserAsLoggedIn:NO];
        }

        if ([selectedProvider willThunkPublishToStatusForActivity:currentActivity])
            maxCharacters = [selectedProvider maxCharactersForSetStatus];
        else
            maxCharacters = [selectedProvider maxCharactersForPublishActivity];

        NSUInteger foo = (weAreCurrentlyEditing ? PREVIEW_BOX_EDITING_Y_ORIGIN : PREVIEW_BOX_DEFAULT_Y_ORIGIN);
        if ([self shouldHideRemainingCharacterCount])
        {
            [myRemainingCharactersLabel setHidden:YES];
            [myEntirePreviewContainer setFrame:
                    CGRectMake(myEntirePreviewContainer.frame.origin.x,
                               (weAreCurrentlyEditing ? PREVIEW_BOX_EDITING_Y_ORIGIN : PREVIEW_BOX_DEFAULT_Y_ORIGIN),
                               myEntirePreviewContainer.frame.size.width,
                               myEntirePreviewContainer.frame.size.height)];
        }
        else
        {
            [myRemainingCharactersLabel setHidden:NO];
            [myEntirePreviewContainer setFrame:
                    CGRectMake(myEntirePreviewContainer.frame.origin.x,
                               (weAreCurrentlyEditing ? PREVIEW_BOX_EDITING_Y_ORIGIN : PREVIEW_BOX_DEFAULT_Y_ORIGIN) + 10,
                               myEntirePreviewContainer.frame.size.width,
                               myEntirePreviewContainer.frame.size.height)];
        }

        if ([selectedProvider doesContentReplaceAction] || [selectedProvider willThunkPublishToStatusForActivity:currentActivity])
            [self updatePreviewTextWhenContentReplacesAction];
        else
            [self updatePreviewTextWhenContentDoesNotReplaceAction];

        [self updateCharacterCount];

        [self adjustRichDataContainerVisibility];
        [self showActivityAsShared:([alreadyShared containsObject:selectedProvider.name] ? YES : NO)];
    }
}

- (void)doneButtonPressed:(id)sender
{
    [myUserCommentTextView resignFirstResponder];

//    if (myUserContentTextView.text.length > 0)
//        [myUserContentTextView scrollRangeToVisible:NSMakeRange(0, 1)];
}

- (void)editButtonPressed:(id)sender
{
    [myUserCommentTextView becomeFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    DLog(@"");

    weAreCurrentlyEditing = YES;

 /* If the user hasn't entered their own content already, then clear the text view.
    Otherwise, just leave what they've already written. */
    if (!hasEditedUserContentForActivityAlready)
    {
        myUserCommentTextView.text = @"";
        hasEditedUserContentForActivityAlready = YES;
    }

    CGFloat remainingCharacterOffset =
                ([self shouldHideRemainingCharacterCount] ? 0 : 10);

    [alreadyShared removeAllObjects];
    [self showActivityAsShared:NO];

    [UIView beginAnimations:@"editing" context:nil];

    [myUserCommentTextView setFrame:
            CGRectMake(myUserCommentTextView.frame.origin.x,
                       myUserCommentTextView.frame.origin.y,
                       myUserCommentTextView.frame.size.width,
                       USER_CONTENT_TEXT_VIEW_EDITING_HEIGHT)];

    [myUserCommentBoundingBox setFrame:
            CGRectMake(myUserCommentBoundingBox.frame.origin.x,
                       myUserCommentBoundingBox.frame.origin.y,
                       myUserCommentBoundingBox.frame.size.width,
                       USER_CONTENT_BOUNDING_BOX_EDITING_HEIGHT)];

    [myRemainingCharactersLabel setFrame:
            CGRectMake(myRemainingCharactersLabel.frame.origin.x,
                       CHARACTER_COUNT_EDITING_Y_ORIGIN,
                       myRemainingCharactersLabel.frame.size.width,
                       myRemainingCharactersLabel.frame.size.height)];

    [myEntirePreviewContainer setFrame:
            CGRectMake(myEntirePreviewContainer.frame.origin.x,
                       PREVIEW_BOX_EDITING_Y_ORIGIN + remainingCharacterOffset,
                       myEntirePreviewContainer.frame.size.width,
                       myEntirePreviewContainer.frame.size.height)];

    CGFloat scrollViewContentHeight = myEntirePreviewContainer.frame.origin.y +
                                      myEntirePreviewContainer.frame.size.height + 10;

    [myPadGrayEditingViewTop setFrame:
            CGRectMake(myPadGrayEditingViewTop.frame.origin.x,
                       myPadGrayEditingViewTop.frame.origin.y,
                       myPadGrayEditingViewTop.frame.size.width,
                       scrollViewContentHeight)];

    [myScrollView setContentSize:CGSizeMake(myScrollView.frame.size.width, scrollViewContentHeight)];

    DLog(@"scrollViewContentHeight: %f", scrollViewContentHeight);

    if (!iPad)
    {
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
            [myScrollView setFrame:
                CGRectMake(myScrollView.frame.origin.x, myScrollView.frame.origin.y,
                           myScrollView.frame.size.width, SCROLL_VIEW_EDITING_HEIGHT_PORTRAIT)];
        else
            [myScrollView setFrame:
                CGRectMake(myScrollView.frame.origin.x, myScrollView.frame.origin.y,
                           myScrollView.frame.size.width, SCROLL_VIEW_EDITING_HEIGHT_LANDSCAPE)];

        [UIView commitAnimations];
    }
    else
    {
        [myPadGrayEditingViewTop setHidden:NO];
        [myPadGrayEditingViewBottom setHidden:NO];
        [myPadGrayEditingViewTop setAlpha:0.6];
        [myPadGrayEditingViewBottom setAlpha:0.6];
        [myUserCommentBoundingBox setAlpha:1.0];
        [UIView commitAnimations];
    }

    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                             target:self
                                             action:@selector(doneButtonPressed:)] autorelease];

    self.navigationItem.rightBarButtonItem         = doneButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.style   = UIBarButtonItemStyleDone;

    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    DLog(@"");

    weAreCurrentlyEditing = NO;

 /* If the user started to enter something, but didn't end up keeping anything, set
    the text back to what the activity's action was. (Aside: We could also set
    hasEditedUserContentForActivityAlready to "NO", clearing the action the next time
    they go to edit.  Currently, on second edit, the action stays, which I kinda like) */
    if (myUserCommentTextView.text.length == 0)
    {
        myUserCommentTextView.text = currentActivity.action;
    }

    CGFloat remainingCharacterOffset =
                ([self shouldHideRemainingCharacterCount] ? 0 : 10);

    [UIView beginAnimations:@"editing" context:nil];
    [myUserCommentTextView setFrame:
            CGRectMake(myUserCommentTextView.frame.origin.x,
                       myUserCommentTextView.frame.origin.y,
                       myUserCommentTextView.frame.size.width,
                       USER_CONTENT_TEXT_VIEW_DEFAULT_HEIGHT)];

    [myUserCommentBoundingBox setFrame:
            CGRectMake(myUserCommentBoundingBox.frame.origin.x,
                       myUserCommentBoundingBox.frame.origin.y,
                       myUserCommentBoundingBox.frame.size.width,
                       USER_CONTENT_BOUNDING_BOX_DEFAULT_HEIGHT)];

    [myRemainingCharactersLabel setFrame:
            CGRectMake(myRemainingCharactersLabel.frame.origin.x,
                       CHARACTER_COUNT_DEFAULT_Y_ORIGIN,
                       myRemainingCharactersLabel.frame.size.width,
                       myRemainingCharactersLabel.frame.size.height)];

    [myEntirePreviewContainer setFrame:
            CGRectMake(myEntirePreviewContainer.frame.origin.x,
                       PREVIEW_BOX_DEFAULT_Y_ORIGIN + remainingCharacterOffset,
                       myEntirePreviewContainer.frame.size.width,
                       myEntirePreviewContainer.frame.size.height)];

    CGFloat scrollViewContentHeight = myEntirePreviewContainer.frame.origin.y +
                                      myEntirePreviewContainer.frame.size.height + 10;

    DLog(@"scrollViewContentHeight: %f", scrollViewContentHeight);

    [myPadGrayEditingViewTop setFrame:
             CGRectMake(myPadGrayEditingViewTop.frame.origin.x,
                        myPadGrayEditingViewTop.frame.origin.y,
                        myPadGrayEditingViewTop.frame.size.width,
                        scrollViewContentHeight)];

    [myScrollView setContentSize:CGSizeMake(myScrollView.frame.size.width, scrollViewContentHeight)];

    if (!iPad)
    {
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
            [myScrollView setFrame:
                CGRectMake(myScrollView.frame.origin.x, myScrollView.frame.origin.y,
                           myScrollView.frame.size.width, SCROLL_VIEW_DEFAULT_HEIGHT_PORTRAIT)];
        else
            [myScrollView setFrame:
                CGRectMake(myScrollView.frame.origin.x, myScrollView.frame.origin.y,
                           myScrollView.frame.size.width, SCROLL_VIEW_DEFAULT_HEIGHT_LANDSCAPE)];

        [UIView commitAnimations];
    }
    else
    {
        [myPadGrayEditingViewTop setHidden:YES];
        [myPadGrayEditingViewBottom setHidden:YES];
        [myPadGrayEditingViewTop setAlpha:0.0];
        [myPadGrayEditingViewBottom setAlpha:0.0];
        [myUserCommentBoundingBox setAlpha:0.3];
        [UIView commitAnimations];
    }

    [myPreviewContainerRoundedRect setNeedsDisplay];

    UIBarButtonItem *editButton = [[[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                             target:self
                                             action:@selector(editButtonPressed:)] autorelease];

    self.navigationItem.rightBarButtonItem         = editButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.style   = UIBarButtonItemStyleBordered;

    if (myUserCommentTextView.text.length > 0)
        [myUserCommentTextView scrollRangeToVisible:NSMakeRange(0, 1)];

    currentActivity.user_generated_content = myUserCommentTextView.text;

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([selectedProvider doesContentReplaceAction] || [selectedProvider willThunkPublishToStatusForActivity:currentActivity])
        [self updatePreviewTextWhenContentReplacesAction];
    else
        [self updatePreviewTextWhenContentDoesNotReplaceAction];

    [self updateCharacterCount];
}

- (void)previewLabel:(JRPreviewLabel*)previewLabel didChangeContentHeightFrom:(CGFloat)fromHeight to:(CGFloat)toHeight;
{
    DLog(@"fromHeight: %f toHeight: %f", fromHeight, toHeight);
    previewLabelHeight = toHeight;
    [myRichDataContainer setFrame:CGRectMake(myRichDataContainer.frame.origin.x,
                                             myRichDataContainer.frame.origin.y + (toHeight - fromHeight),
                                             myRichDataContainer.frame.size.width,
                                             myRichDataContainer.frame.size.height)];
    [self adjustRichDataContainerVisibility];

    CGFloat scrollViewContentHeight = myEntirePreviewContainer.frame.origin.y +
                                      myEntirePreviewContainer.frame.size.height + 10;

    [myScrollView setContentSize:CGSizeMake(myScrollView.frame.size.width, scrollViewContentHeight)];
}

- (void)sendEmail
{
#if JRENGAGE_INCLUDE_EMAIL_SMS
    MFMailComposeViewController *email = [[[MFMailComposeViewController alloc] init] autorelease];

    if (!email)
        return;

    email.mailComposeDelegate = self;

    [email setSubject:currentActivity.email.subject];
    [email setMessageBody:currentActivity.email.messageBody isHTML:currentActivity.email.isHtml];

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
    sms.body = currentActivity.sms.message;

    [self presentModalViewController:sms animated:YES];

#endif
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

- (IBAction)signOutButtonPressed:(id)sender
{
    DLog(@"");

    userIsAttemptingToSignOut = YES;

    UIActionSheet *action = [[[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:
                                                                   @"You are currently signed in to %@%@. Would you like to sign out?",
                                                                   selectedProvider.friendlyName,
                                                                   (loggedInUser.preferredUsername) ?
                                                                   [NSString stringWithFormat:@" as %@", loggedInUser.preferredUsername] : @""]
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:@"Sign Out"
                                                otherButtonTitles:nil] autorelease];
    action.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [action showFromTabBar:myTabBar];
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

- (void)setButtonImage:(UIButton*)button toData:(NSData*)data andSetLoading:(UIActivityIndicatorView*)actIndicator toLoading:(BOOL)loading
{
    DLog (@"");

    if (!data && !loading)
        DLog (@"Problem downloading image");

    if (!data)
    {
        [button setImage:nil forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor darkGrayColor]];
    }
    else
    {
        [button setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [button setBackgroundColor:[UIColor whiteColor]];
    }

    if (loading)
        [actIndicator startAnimating];
    else
        [actIndicator stopAnimating];
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

    NSURL        *url     = [NSURL URLWithString:profilePicUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSString     *tag     = [providerName retain];

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self returnFullResponse:YES withTag:tag])
        [self setProfilePicToDefaultPic];

    [request release];
}

- (void)downloadMediaThumbnailsForActivity
{
    JRMediaObject *media = [currentActivity.media objectAtIndex:0];
    if ([media isKindOfClass:[JRImageMediaObject class]])
    {
        DLog (@"Downloading image thumbnail: %@", ((JRImageMediaObject*)media).src);
        [self setButtonImage:myMediaThumbnailView toData:nil andSetLoading:myMediaThumbnailActivityIndicator toLoading:YES];

        NSURL        *url     = [NSURL URLWithString:((JRImageMediaObject *) media).src];
        NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url] autorelease];
        NSString     *tag     = [[NSString alloc] initWithFormat:@"getThumbnail"];

        if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self returnFullResponse:YES withTag:tag])
            [self setButtonImage:myMediaThumbnailView toData:nil andSetLoading:myMediaThumbnailActivityIndicator toLoading:NO];
    }
    else if ([media isKindOfClass:[JRFlashMediaObject class]])
    {
        DLog (@"Downloading image thumbnail: %@", ((JRFlashMediaObject*)media).imgsrc);
        [self setButtonImage:myMediaThumbnailView toData:nil andSetLoading:myMediaThumbnailActivityIndicator toLoading:YES];

        NSURL        *url     = [NSURL URLWithString:((JRFlashMediaObject *) media).imgsrc];
        NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url] autorelease];
        NSString     *tag     = [[NSString alloc] initWithFormat:@"getThumbnail"];

        if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self returnFullResponse:YES withTag:tag])
            [self setButtonImage:myMediaThumbnailView toData:nil andSetLoading:myMediaThumbnailActivityIndicator toLoading:NO];
    }
    else
    {
        [self setButtonImage:myMediaThumbnailView
                      toData:UIImagePNGRepresentation([UIImage imageNamed:@"music_note.jpg"])
               andSetLoading:myMediaThumbnailActivityIndicator
                   toLoading:NO];
    }
}

- (void)determineIfWeCanShareViaEmailAndOrSMS
{
#if JRENGAGE_INCLUDE_EMAIL_SMS
#else
    return;
#endif

    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));

    /* Check if the activity has an email object, sms string, or both and if we can send either or both.
     If so, emailOrSms will be 0, 1, 2, or 3, accordingly. */
    if (currentActivity.email && [mailClass canSendMail])  /* Add 1. */
        emailAndOrSmsIndex += EMAIL;
    if (currentActivity.sms && [messageClass canSendText]) /* Add 2. */
        emailAndOrSmsIndex += SMS;

    return;// emailAndOrSmsIndex;
}

/* MBC = Media Box Content */
/* Max height of the whole box is 83 (including title and description heights,
   5 px top/bottom padding, and 2 px interior padding).  The MBC max height is
   73 (max height minus the padding) */
#define MBC_MAX_HEIGHT       73.0
#define MBC_EXTERIOR_PADDING 10.0
#define MBC_INTERIOR_PADDING 2.0
- (void)loadActivityToViewForFirstTime//:(JRActivityObject*)newActivity
{
    DLog(@"");

 /* If the activity doesn't have a url, set the shortened url to an empty string,
  * otherwise, if it's nil, the updatePreviewText func will say "shortening url..." */
    if (!currentActivity.url)
        shortenedActivityUrl = @"";

 /* Set the user-comment text view's text and preview label to the activity's action.
  * We are safe using "updatePreviewTextWhenContentReplacesAction" here, because at
  * this point the content IS the action*/
    myUserCommentTextView.text = currentActivity.action;
    [self updatePreviewTextWhenContentReplacesAction];

 /* Determine if the activity has rich data (media, a title, or a description) or not */
    if ((!currentActivity.title || [currentActivity.title isEqualToString:@""]) &&
        (!currentActivity.description || [currentActivity.description isEqualToString:@""]) &&
        ([currentActivity.media count] == 0 || mediaThumbnailFailedToDownload))
        activityHasRichData = NO;
    else
        activityHasRichData = YES;

 /* If it doesn't, we're done */
    if (activityHasRichData == NO)
    {
        [myRichDataContainer setHidden:YES];
        return;
    }

 /* Now, determine the sizes and appearance of the media box components (title, description, and media) based on
    their size and presense */

 /* Set up the default coordinates for the title and description and default height of the media box */
    CGFloat title_x = 46.0, title_y = 5.0, title_w = 224.0, title_h = 15.0;
    CGFloat descr_x = 46.0, descr_y = 22.0, descr_w = 224.0, descr_h = 56.0;
    mediaBoxHeight = 48.0; /* This is the minimum height of the media box needed for the media thumbnail and padding
                              If the title and descr are large enough, this size grows, and if there is no media
                              and the title and descr are small, it shrinks. */

 /* If we have media, and downloading its thumbnail hasn't failed, download it */
    if ([currentActivity.media count] > 0 && !mediaThumbnailFailedToDownload)
    {
        [self downloadMediaThumbnailsForActivity];
    }

 /* Otherwise, reposition the title and descr so that their x position equals 8.0 and their width is 262.0 */
    else
    {
        title_x = descr_x = 8.0;
        title_w = descr_w = 262.0;
    }

 /* If there is a title, set the title label's text and determine how much space the
    activity's title will potentially need */
    CGFloat shouldBeTitleHeight = 0;
    if (currentActivity.title)
    {
        myTitleLabel.text = currentActivity.title;

        CGSize shouldBeTitleSize =
                       [myTitleLabel.text sizeWithFont:myTitleLabel.font                        // TODO: Verify change made below
                                     constrainedToSize:CGSizeMake(title_w, MBC_MAX_HEIGHT)//([currentActivity.media count] > 0 && !mediaThumbnailFailedToDownload) ? 224 : 262, 73)
                                         lineBreakMode:UILineBreakModeTailTruncation];
        shouldBeTitleHeight = shouldBeTitleSize.height;
    }

 /* If there is a description, set the description label's text and determine how much
    space the activity's description will potentially need */
    CGFloat shouldBeDescriptionHeight = 0;
    if (currentActivity.description)
    {
        myDescriptionLabel.text = currentActivity.description;

        CGSize shouldBeDescriptionSize =
                       [myDescriptionLabel.text sizeWithFont:myDescriptionLabel.font
                                           constrainedToSize:CGSizeMake(descr_w, MBC_MAX_HEIGHT)//([currentActivity.media count] > 0 && !mediaThumbnailFailedToDownload) ? 224 : 262, 73)
                                               lineBreakMode:UILineBreakModeTailTruncation];
        shouldBeDescriptionHeight = shouldBeDescriptionSize.height;
    }

    /* There is no title or description */
    if (shouldBeTitleHeight == 0 && shouldBeDescriptionHeight == 0)
    {
        [myTitleLabel setHidden:YES];
        [myDescriptionLabel setHidden:YES];

        //return;
    }

    /* There is no title but there is a description */
    else if (shouldBeTitleHeight == 0 && shouldBeDescriptionHeight != 0 )
    {
        descr_y = 5.0;

        if (shouldBeDescriptionHeight <= MBC_MAX_HEIGHT)
            descr_h = shouldBeDescriptionHeight;
        else
            descr_h = 70.0; /* The height of 5 lines of 11.0 pt. font, which is the most we can fit when we
                               don't have a title */

        /* If the descr label is taller than our media thumbnail, or if we don't have a media thumbnail, set the media
        box height to the descr label plus padding */
        if ((descr_h > 38.0) || ([currentActivity.media count] == 0))
            mediaBoxHeight = descr_h + MBC_EXTERIOR_PADDING; /* The padding above and below the title/description */

        [myTitleLabel setHidden:YES];
    }

    /* There is no description but there is a title */
    else if (shouldBeDescriptionHeight == 0 && shouldBeTitleHeight != 0 )
    {
        if (shouldBeTitleHeight <= MBC_MAX_HEIGHT)
            title_h = shouldBeTitleHeight;
        else
            title_h = 60.0; /* The height of 4 lines of 12.0 pt. bold font, which is the most we can fit when we
                               don't have a title */

     /* If the title label is taller than our media thumbnail, or if we don't have a media thumbnail, set the media
        box height to the title label plus padding */
        if ((title_h > 38.0) || ([currentActivity.media count] == 0))
            mediaBoxHeight = title_h + MBC_EXTERIOR_PADDING; /* The padding above and below the title/description */

        [myDescriptionLabel setHidden:YES];
    }

    /* There is a title and a description*/
    else /* if (shouldBeDescriptionHeight != 0 && shouldBeTitleHeight !=0 ) */
    {
        /* If both the title and descr labels fit into the media box content height */
        if (shouldBeTitleHeight + shouldBeDescriptionHeight + MBC_INTERIOR_PADDING < MBC_MAX_HEIGHT) //71)
        {
          /* Let them keep their heights, and position the descr label */
            title_h = shouldBeTitleHeight;
            descr_h = shouldBeDescriptionHeight;
            descr_y = shouldBeTitleHeight + 7.0; /* Title height + top padding + interior padding */

         /* If the title label and descr labels are together taller than our media thumbnail, or if we don't
            have a media thumbnail, set the media box height to the title label height plus the descr label
            height plus padding */
            if ((shouldBeTitleHeight + shouldBeDescriptionHeight > 38.0) || ([currentActivity.media count] == 0))
                mediaBoxHeight = shouldBeTitleHeight + shouldBeDescriptionHeight + MBC_EXTERIOR_PADDING + MBC_INTERIOR_PADDING;
        }

        /* If both the title and descr labels DON'T fit into the media box content height */
        else if (shouldBeTitleHeight + shouldBeDescriptionHeight + MBC_INTERIOR_PADDING >= MBC_MAX_HEIGHT)
        {
         /* If the title height is taller than one line of text and the descr height is taller than four lines... */
            if (shouldBeTitleHeight >= 15 && shouldBeDescriptionHeight >= 56)
            {
                /* ... then keep things as they are (i.e., 1 line and 4 lines) */
            }

         /* If the title height is taller than one line of text and the descr height is SHORTER than four lines... */
            else if (shouldBeTitleHeight >= 15 && shouldBeDescriptionHeight < 56)
            {
                /* ... then make the descr as tall as it needs to be and adjust the title to fit (e.g., 2 lines and 3 lines) */
                CGSize shouldBeTitleSize =
                               [myTitleLabel.text sizeWithFont:myTitleLabel.font
                                             constrainedToSize:CGSizeMake(title_w, MBC_MAX_HEIGHT - MBC_INTERIOR_PADDING - shouldBeDescriptionHeight)//([currentActivity.media count] > 0 && !mediaThumbnailFailedToDownload) ? 224 : 262, 71 - shouldBeDescriptionHeight)
                                                 lineBreakMode:UILineBreakModeTailTruncation];
                shouldBeTitleHeight = shouldBeTitleSize.height;

                title_h = shouldBeTitleHeight;
                descr_h = shouldBeDescriptionHeight;
                descr_y = shouldBeTitleHeight + 7.0; /* Title height + top padding + interior padding */
            }
            else if (shouldBeTitleHeight < 15 && shouldBeDescriptionHeight >= 56)
            {
                /* only happens if there is no title */
            }
            else if (shouldBeTitleHeight < 15 && shouldBeDescriptionHeight < 56)
            {
                /* moot case */
            }

         /* Because when we have both a title and descr, their combined height will always be more than 30?? */
            mediaBoxHeight = title_h + descr_h + 12.0;
        }
    }

 /* Now actually set the frames */
    [myTitleLabel setFrame:CGRectMake(title_x, title_y, title_w, title_h)];
    [myDescriptionLabel setFrame:CGRectMake(descr_x, descr_y, descr_w, descr_h)];
    [myRichDataContainer setFrame:CGRectMake(myRichDataContainer.frame.origin.x,
                                             previewLabelHeight + 20.0,
                                             myRichDataContainer.frame.size.width,
                                             mediaBoxHeight)];
    [myRichDataContainer setNeedsDisplay];
    [myEntirePreviewContainer setFrame:CGRectMake(myEntirePreviewContainer.frame.origin.x,
                                            myEntirePreviewContainer.frame.origin.y,
                                            myEntirePreviewContainer.frame.size.width,
                                            mediaBoxHeight + previewLabelHeight + 37.0)];

    [self adjustRichDataContainerVisibility];
}

- (void)addProvidersToTabBar
{
    DLog(@"");

    NSUInteger numberOfTabs = [[sessionData socialProviders] count];
    NSUInteger indexOfLastUsedProvider = 0;
    BOOL weShouldAddTabForEmailAndOrSms = (BOOL)emailAndOrSmsIndex;

    if (weShouldAddTabForEmailAndOrSms)
        numberOfTabs++;

    NSMutableArray *providerTabArr = [[NSMutableArray alloc] initWithCapacity:numberOfTabs];

    for (NSUInteger i = 0; i < [[sessionData socialProviders] count]; i++)
    {
        JRProvider *provider = [[sessionData getSocialProviderAtIndex:i] retain];

        if (!provider)
            break;

        NSString *imagePath = [NSString stringWithFormat:@"icon_bw_%@_30x30.png", provider.name];
        UITabBarItem *providerTab = [[[UITabBarItem alloc] initWithTitle:provider.friendlyName
                                                                   image:[UIImage imageNamed:imagePath]
                                                                     tag:[providerTabArr count]] autorelease];

        [providerTabArr insertObject:providerTab atIndex:[providerTabArr count]];

        if ([provider isEqualToReturningProvider:[sessionData returningSocialProvider]])
            indexOfLastUsedProvider = i;

        [provider release];
    }

    if (weShouldAddTabForEmailAndOrSms)
    {

        NSString *simpleStrArray[6] = { @"Email", @"Sms", @"Email/SMS", @"mail", @"sms", @"mail_sms" };

        UITabBarItem *emailTab =  [[[UITabBarItem alloc] initWithTitle:simpleStrArray[((int)emailAndOrSmsIndex - 1)]
                                                                 image:[UIImage imageNamed:
                                                                        [NSString stringWithFormat:@"icon_bw_%@_30x30.png",
                                                                         simpleStrArray[((int)emailAndOrSmsIndex + 2)]]]
                                                                   tag:[providerTabArr count]] autorelease];

        [providerTabArr insertObject:emailTab atIndex:[providerTabArr count]];
    }

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

    if ([selectedProvider willThunkPublishToStatusForActivity:currentActivity])
        [sessionData setStatusForUser:loggedInUser];
    else
        [sessionData shareActivityForUser:loggedInUser];
}

- (IBAction)shareButtonPressed:(id)sender
{
    DLog(@"");

    weAreCurrentlyPostingSomething = YES;

    if (myUserCommentTextView.text && hasEditedUserContentForActivityAlready)
        currentActivity.user_generated_content = myUserCommentTextView.text;

    [sessionData setCurrentProvider:selectedProvider];
    [self showViewIsLoading:YES];

    if (!loggedInUser)
    {
     /* Set weHaveJustAuthenticated to YES, so that when this view returns (for whatever reason... successful auth
        user canceled, etc), the view will know that we just went through the authentication process. */
        weHaveJustAuthenticated = YES;

//        userHitTheBackButton = NO;

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
        mediaThumbnailFailedToDownload = YES;
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

- (void)urlShortenedToNewUrl:(NSString*)url forActivity:(JRActivityObject*)activity
{
    DLog(@"");
    if (currentActivity == activity && url != nil)
    {
        shortenedActivityUrl = url;

        if (selectedProvider == nil)
            return;

        if ([selectedProvider doesContentReplaceAction] || [selectedProvider willThunkPublishToStatusForActivity:currentActivity])
            [self updatePreviewTextWhenContentReplacesAction];
        else
            [self updatePreviewTextWhenContentDoesNotReplaceAction];

        [self updateCharacterCount];
    }
}

- (void)authenticationDidRestart
{
    weAreCurrentlyPostingSomething = NO;
    weHaveJustAuthenticated = NO;
}

// TODO: Probably need to comment this out, as authenticationDidCancel is something that publish activity
// should never have to worry about
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

- (void)publishingActivityDidSucceed:(JRActivityObject*)theActivity forProvider:(NSString*)provider;
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

- (void)publishingDidRestart  { weAreCurrentlyPostingSomething = NO; }
- (void)publishingDidCancel   { weAreCurrentlyPostingSomething = NO; }
- (void)publishingDidComplete { weAreCurrentlyPostingSomething = NO; }

- (void)publishingActivity:(JRActivityObject*)activity didFailWithError:(NSError*)error forProvider:(NSString*)provider
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
        case JRPublishErrorCharacterLimitExceeded: /* ... was "JRPublishErrorLinkedInCharacterExceeded" */
            errorMessage = [NSString stringWithFormat:
                            @"There was an error while sharing this activity: Status was too long."];
            break;
        case JRPublishErrorMissingApiKey:
            errorMessage = [NSString stringWithFormat:
                            @"There was an error while sharing this activity."];
            reauthenticate = YES;
            break;
        case JRPublishErrorInvalidFacebookSession:  /* ... was "JRPublishErrorInvalidOauthKey" */
            errorMessage = [NSString stringWithFormat:
                            @"There was an error while sharing this activity."];
            reauthenticate = YES;
            break;
        case JRPublishErrorMissingParameter:
            errorMessage = [NSString stringWithFormat:
                            @"There was an error while sharing this activity."];
            break;
        default:
         /* JRPublishErrorBadConnection,
            JRPublishErrorActivityNil,
            JRPublishErrorFacebookGeneric,
            JRPublishErrorInvalidFacebookSession,
            JRPublishErrorInvalidFacebookMedia,
            JRPublishErrorTwitterGeneric,
            JRPublishErrorLinkedInGeneric,
            JRPublishErrorMyspaceGeneric,
            JRPublishErrorYahooGeneric */

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (sessionData.canRotate)
        return YES;

    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [myTriangleIcon setFrame:CGRectMake([alreadyShared containsObject:selectedProvider.name] ?
            25 :
            ((loggedInUser) ?
                ([myTriangleIcon superview].frame.size.width - 90) :
                ([myTriangleIcon superview].frame.size.width / 2) - 9), 0, 18, 18)];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [myUserCommentBoundingBox setNeedsDisplay];
    [myPreviewContainerRoundedRect setNeedsDisplay];
    [myRichDataContainer setNeedsDisplay];
}

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

//    if (hidesCancelButton && userHitTheBackButton)
//        [sessionData triggerPublishingDidCancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    DLog(@"");
    [super viewDidUnload];
}

- (void)userInterfaceWillClose
{
    DLog(@"");

    [self showViewIsLoading:NO];
    [timer invalidate];

    // TODO: Make this empty the activity!!!
    [self loadActivityToViewForFirstTime];
}

- (void)userInterfaceDidClose { }

- (void)dealloc
{
    DLog(@"");

    [selectedProvider release];
    [loggedInUser release];
    [currentActivity release];
    [customInterface release];
    [colorsDictionary release];
    [myBackgroundView release];
    [myTabBar release];
    [myLoadingLabel release];
    [myLoadingActivitySpinner release];
    [myLoadingGrayView release];
    [myPadGrayEditingViewTop release];
    [myPadGrayEditingViewBottom release];
    [myContentView release];
    [myScrollView release];
    [myRemainingCharactersLabel release];
    [myPreviewContainerRoundedRect release];
    [myPreviewOfTheUserCommentLabel release];
    [myUserCommentTextView release];
    [myUserCommentBoundingBox release];
    [myProviderIcon release];
    [myInfoButton release];
    [myPoweredByLabel release];
    [myEntirePreviewContainer release];
    [myRichDataContainer release];
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
    [titleView release];

    [super dealloc];
}
@end
