//
//  JRPublishActivityController.h
//  JRAuthenticate
//
//  Created by lilli on 7/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRAuthenticate.h"
#import "JRInfoBar.h"
//#import "JRUserInterfaceMaestro.h"

//@protocol JRUserInterfaceDelegate;

@interface JRPublishActivityController : UIViewController <UINavigationBarDelegate, UITextViewDelegate, 
                                                           UITabBarDelegate, JRSessionDelegate,
                                                           JRConnectionManagerDelegate, JRUserInterfaceDelegate,
                                                           UIActionSheetDelegate>
{
	JRSessionData	*sessionData;

//    NSArray         *providers;

    JRProvider          *selectedProvider;
    JRAuthenticatedUser *loggedInUser;
    
//    NSMutableArray *authenticatedProviders;
    
    
	IBOutlet UITabBar *myTabBar;
    
    BOOL ready;
    BOOL justAuthenticated;
    
	UILabel		*title_label;
	JRInfoBar	*infoBar;
    
    JRActivityObject *activity;
    
    /* Activity Spinner and Label displayed while the list of configured providers is empty */
    NSTimer *timer;
    IBOutlet UILabel					*myLoadingLabel;
    IBOutlet UIActivityIndicatorView    *myLoadingActivitySpinner; 
    IBOutlet UIView                     *myLoadingGrayView;
    
    IBOutlet UITextView  *myUserContentTextView;
    IBOutlet UIButton    *myUserContentBoundingBox;
    
    IBOutlet UIImageView *myProviderIcon;
    IBOutlet UILabel     *myPoweredByLabel;
    
    IBOutlet UIView                  *myMediaContentView;
    IBOutlet UIView                  *myMediaViewBackgroundMiddle;
    IBOutlet UIImageView             *myMediaViewBackgroundTop;
    IBOutlet UIImageView             *myMediaViewBackgroundBottom;
    IBOutlet UIImageView             *myMediaThumbnailView;
    IBOutlet UIActivityIndicatorView *myMediaThumbnailActivityIndicator;
    IBOutlet UILabel                 *myTitleLabel;
    IBOutlet UILabel                 *myDescriptionLabel;
    
    IBOutlet UIView                  *myShareToView;
    IBOutlet UIImageView             *myTriangleIcon;
    IBOutlet UIImageView             *myProfilePic;
    IBOutlet UIActivityIndicatorView *myProfilePicActivityIndicator;
    IBOutlet UILabel                 *myUserName;
    IBOutlet UIButton                *myConnectAndShareButton;
    IBOutlet UIButton                *myJustShareButton;
    IBOutlet UIImageView             *mySharedCheckMark;
    IBOutlet UILabel                 *mySharedLabel;
    IBOutlet UIButton                *mySettingsButton;
    
    NSData *thumbnailData;
    NSData *profilePicData;
    
    UIToolbar *keyboardToolbar;
    UIBarItem *shareButton;
    
    BOOL hasEditedBefore;
    
//    UIBarButtonItem *editButton;
//    UIBarButtonItem *doneButton;
    
//    UIButton *hideKeyboardButton;
}

//@property (nonatomic, retain) IBOutlet UITabBar    *myTabBar;
//
//@property (nonatomic, retain) IBOutlet UILabel                  *myLoadingLabel;
//@property (nonatomic, retain) IBOutlet UIActivityIndicatorView  *myLoadingActivitySpinner;
//@property (nonatomic, retain) IBOutlet UIView                   *myLoadingGrayView;
//
//
//@property (nonatomic, retain) IBOutlet UITextView  *myUserContentTextView;
//@property (nonatomic, retain) IBOutlet UIButton    *myUserContentBoundingBox;
//
//@property (nonatomic, retain) IBOutlet UIImageView *myProviderIcon;
//@property (nonatomic, retain) IBOutlet UILabel     *myPoweredByLabel;
//     
//@property (nonatomic, retain) IBOutlet UIView      *myMediaContentView;
//@property (nonatomic, retain) IBOutlet UIView      *myMediaViewBackgroundMiddle;
//@property (nonatomic, retain) IBOutlet UIImageView *myMediaViewBackgroundTop;
//@property (nonatomic, retain) IBOutlet UIImageView *myMediaViewBackgroundBottom;
//@property (nonatomic, retain) IBOutlet UIImageView *myMediaThumbnailView;
//@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *myMediaThumbnailActivityIndicator;
//@property (nonatomic, retain) IBOutlet UILabel     *myTitleLabel;
//@property (nonatomic, retain) IBOutlet UILabel     *myDescriptionLabel;
//    
//@property (nonatomic, retain) IBOutlet UIView      *myShareToView;
//@property (nonatomic, retain) IBOutlet UIImageView *myTriangleIcon;
//@property (nonatomic, retain) IBOutlet UIImageView *myProfilePic;
//@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *myProfilePicActivityIndicator;
//@property (nonatomic, retain) IBOutlet UILabel     *myUserName;
//@property (nonatomic, retain) IBOutlet UIButton    *myConnectAndShareButton;
//@property (nonatomic, retain) IBOutlet UIButton    *myJustShareButton;
//@property (nonatomic, retain) IBOutlet UIImageView *mySharedCheckMark;
//@property (nonatomic, retain) IBOutlet UILabel     *mySharedLabel;


@property (nonatomic, retain) IBOutlet UIToolbar *keyboardToolbar;
@property (nonatomic, retain) IBOutlet UIBarItem *shareButton;
//@property (nonatomic, retain) IBOutlet UIBarItem *doneButton;

- (IBAction)settingsButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender; 
- (IBAction)doneButtonPressed:(id)sender; 
- (IBAction)editButtonPressed:(id)sender; 
@end
