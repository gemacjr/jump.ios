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




@interface JRPublishActivityController : UIViewController <UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource, 
                                                           UITabBarDelegate, JRSessionDelegate,
                                                           JRConnectionManagerDelegate>
{
	JRAuthenticate	*jrAuth;
	JRSessionData	*sessionData;

    NSArray         *providers;
    NSString        *selectedProvider;
    
	UITabBar *myTabBar;
    
    BOOL ready;
    
	UITableView	*myTableView;	
	UILabel		*label;
	JRInfoBar	*infoBar;
    
    JRActivityObject *activity;
    
    /* Activity Spinner and Label displayed while the list of configured providers is empty */
	UILabel					*myLoadingLabel;
	UIActivityIndicatorView *myActivitySpinner; 
    UIView                  *grayView;
    
    NSData *thumbnailData;
    
    UIButton *bigShareButton;
    UILabel  *buttonLabel;
    
    UITextView *displayNameAndAction_label;
    UITextView *contentTitle_label;
    UITextView *contentDescription_label;
    UIImageView *thumbnail_imageview;
    UITextView *userContent_textview;

    UIToolbar *keyboardToolbar;
    UIBarItem *shareButton;
    UIBarItem *doneButton;
    
    UIButton *hideKeyboardButton;
}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UITabBar    *myTabBar;

@property (nonatomic, retain) IBOutlet UILabel *myLoadingLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *myActivitySpinner;
@property (nonatomic, retain) IBOutlet UIView *grayView;

@property (nonatomic, retain) IBOutlet UIToolbar *keyboardToolbar;
@property (nonatomic, retain) IBOutlet UIBarItem *shareButton;
@property (nonatomic, retain) IBOutlet UIBarItem *doneButton;


- (IBAction)shareButtonPressed:(id)sender; 
- (IBAction)doneButtonPressed:(id)sender; 


//@property (nonatomic, retain) IBOutlet UILabel *cellDisplayNameAndAction;
//@property (nonatomic, retain) IBOutlet UILabel *cellContentTitle;
//@property (nonatomic, retain) IBOutlet UILabel *cellContentDescription;
//@property (nonatomic, retain) IBOutlet UIImageView *cellImage;
//@property (nonatomic, retain) IBOutlet UITextView *cellUserContent;
//@property (nonatomic, retain) IBOutlet UITableViewCell *myCell;
@end
