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

    JRProvider          *selectedProvider;
    JRAuthenticatedUser *loggedInUser;
    
    NSDictionary *colorsDictionary;
    
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
    IBOutlet UIButton                *myMediaThumbnailView;
    IBOutlet UIActivityIndicatorView *myMediaThumbnailActivityIndicator;
    IBOutlet UILabel                 *myTitleLabel;
    IBOutlet UILabel                 *myDescriptionLabel;
    
    IBOutlet UIView                  *myShareToView;
    IBOutlet UIImageView             *myTriangleIcon;
    IBOutlet UIButton                *myProfilePic;
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
}

@property (nonatomic, retain) IBOutlet UIToolbar *keyboardToolbar;
@property (nonatomic, retain) IBOutlet UIBarItem *shareButton;

- (IBAction)settingsButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender; 
- (IBAction)doneButtonPressed:(id)sender; 
- (IBAction)editButtonPressed:(id)sender; 
@end
