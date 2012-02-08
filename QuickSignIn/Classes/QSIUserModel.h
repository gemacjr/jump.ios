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


 File:   QSIUserModel.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>
#import "JREngage.h"
#import "JREngage+CustomInterface.h"
#import "QuickSignInAppDelegate.h"
#import "QSIEmbeddedTableViewController.h"

#define LILLI

@protocol UserModelDelegate <NSObject>
@optional
- (void)didFailToSignIn:(BOOL)showMessage;
- (void)didReceiveToken;
- (void)userDidSignIn;
- (void)userDidSignOut;
- (void)didReachTokenUrl;
- (void)didFailToReachTokenUrl;
@end

@protocol LibraryDialogDelegate <NSObject>
@optional
- (void)libraryDialogClosed;
@end

@class EmbeddedTableViewController;

@interface UserModel : NSObject <JREngageDelegate>
{
 /* Instance of the JRAuthenticate library */
	JREngage *jrEngage;

    NSMutableDictionary         *customInterface;
    UINavigationController      *navigationController;
    EmbeddedTableViewController *embeddedTable;

 /* Singleton instance of the NSUserDefaults class */
	NSUserDefaults *prefs;

 /* Session dictionary (and strings) containing the identifier, display name,
    current provider, and timestamp of the currently signed in user. */
	NSDictionary	*currentUser;
	NSString		*identifier;
	NSString		*displayName;
	NSString		*currentProvider;

 /* Boolean variable to tell the View Controller classes whether or not the
    Model is signing in a user. */
	BOOL loadingUserData;

 /* Boolean variable to indicate to View Controller classes whether or not the
    Model is waiting on the call to the token URL, so they can add/remove themselves as
    the tokenUrlDelegate if they appear/disappear during the network call. */
    BOOL pendingCallToTokenUrl;

 /* A place to store the specific profile a user selects in the ViewControllerLevel1
    to load in ViewControllerLevel2. */
	NSDictionary	*selectedUser;

 /* This unsigned int holds a snapshot of the max size reached by the
    sign-in history array, so that once a user deletes half of the saved sessions,
    the Model will go through and clean out the userProfiles dictionary.
    The dictionary of profiles is unordered and has one entry per user, but the
    sign-in history array is ordered, and may have a many-to-one mapping of sessions
    to profiles. */
	NSUInteger historyCountSnapShot;

 /* Delegates for the UserModelDelegate protocol. */
	id<UserModelDelegate> signInDelegate;
	id<UserModelDelegate> signOutDelegate;
    id<UserModelDelegate> tokenUrlDelegate;

 /* Delegate for the LibraryDialogDelegate protocol. */
    id <LibraryDialogDelegate> libraryDialogDelegate;

    BOOL iPad;
}
@property (retain) id<UserModelDelegate>     tokenUrlDelegate;
@property (retain) id<LibraryDialogDelegate> libraryDialogDelegate;

@property            BOOL pendingCallToTokenUrl;

@property (readonly) BOOL loadingUserData;
@property (readonly) NSDictionary *currentUser;
@property (retain)	 NSDictionary *selectedUser;
@property (retain)   NSMutableDictionary *customInterface;
@property (retain)   UINavigationController *navigationController;

/* This is a dictionary of dictionaries, where each dictionary represents the
   full profile returned by the token URL on http://jrauthenticate.appspot.com/login.
   Each time a new user is signed in, an entry is added to the userProfiles
   dictionary and saved to the NSUserDefaults class. The dictionary of profiles
   is unordered, has one entry per user, and is indexed by the identifier. */
@property (readonly) NSDictionary *userProfiles;

/* This is an array of dictionaries, where each dictionary represents a unique session
   for any user.  Each dictionary contains the identifier, display name, current provider,
   and timestamp for that specific session. The signinHistory array is ordered, and each
   session's user has a profile in the userProfiles dictionary, indexed by identifier. */
@property (readonly) NSArray *signinHistory;

@property (readonly) BOOL iPad;
/* Function that removes specific sessions from the signinHistory array, and
   periodically purges the removed profiles from the userProfile dictionary. */
- (void)removeUserFromHistory:(int)index;

/* Functions to initiate signing in/out of a user. */
- (void)startSignUserIn:(id<UserModelDelegate>)interestedPartySignIn
		   afterSignOut:(id<UserModelDelegate>)interestedPartySignOut;
- (void)startSignUserIn:(id<UserModelDelegate>)interestedParty;
- (void)startSignUserOut:(id<UserModelDelegate>)interestedParty;

- (void)triggerAuthenticationDidCancel:(id)sender;

//- (void)setNavigationController:(UINavigationController*)navigationController;

/* Returns singleton instance of class. */
+ (UserModel*)getUserModel;

/* Misc functions that nicely format profile data. */
+ (NSString*)getDisplayNameFromProfile:(NSDictionary*)profile;
+ (NSString*)getAddressFromProfile:(NSDictionary*)profile;
@end
