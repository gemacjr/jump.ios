//
//  DemoUserModel.h
//  Demo
//
//  Created by lilli on 5/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRAuthenticate.h"

#define LILLI

@protocol DemoUserModelDelegate <NSObject>
- (void)didFailToSignIn:(NSError*)error;
- (void)didReceiveToken;
- (void)userDidSignIn;
- (void)userDidSignOut;
@end

@interface DemoUserModel : NSObject <JRAuthenticateDelegate>
{
	JRAuthenticate *jrAuthenticate;
	NSUserDefaults *prefs;
	
	NSString		*identifier;
	NSString		*displayName;
	NSString		*currentProvider;
	NSDictionary	*currentUser;

	BOOL loadingUserData;

	NSDictionary	*selectedUser;
	
	NSUInteger historyCountSnapShot;
	
	id<DemoUserModelDelegate> signInDelegate;
	id<DemoUserModelDelegate> signOutDelegate;
}

@property (readonly) BOOL loadingUserData;

@property (readonly) NSDictionary *currentUser;
@property (retain)	 NSDictionary *selectedUser;

@property (readonly) NSDictionary *userProfiles;
@property (readonly) NSArray *signinHistory;

- (void)removeUserFromHistory:(int)index;

- (void)startSignUserIn:(id<DemoUserModelDelegate>)interestedPartySignIn afterSignOut:(id<DemoUserModelDelegate>)interestedPartySignOut;
- (void)startSignUserIn:(id<DemoUserModelDelegate>)interestedParty;
- (void)startSignUserOut:(id<DemoUserModelDelegate>)interestedParty;

+ (DemoUserModel*)getDemoUserModel;

+ (NSString*)getDisplayNameFromProfile:(NSDictionary*)profile;
+ (NSString*)getAddressFromProfile:(NSDictionary*)profile;
@end
