//
//  Created by lillialexis on 2/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "JRCaptureUser.h"
#import "JRCapture.h"

@protocol SignInDelegate <NSObject>
@optional
- (void)engageSignInDidSucceed;
- (void)engageSignInDidFailWithError:(NSError *)error;
- (void)captureSignInDidSucceed;
- (void)captureSignInDidFailWithError:(NSError *)error;
@end

@interface SharedData : NSObject <JRCaptureSigninDelegate>
+ (JRCaptureUser *)captureUser;
+ (BOOL)isNew;
+ (BOOL)notYetCreated;
+ (NSString *)currentDisplayName;
+ (NSString *)currentProvider;
+ (void)startAuthenticationWithCustomInterface:(NSDictionary *)customInterface forDelegate:(id<SignInDelegate>)delegate;
+ (void)resaveCaptureUser;
+ (void)signoutCurrentUser;
@end

