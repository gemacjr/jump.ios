//
//  Created by lillialexis on 2/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
//#import "JRCaptureApidInterface.h"
#import "JRCaptureUser.h"
#import "JREngage.h"
#import "JRCapture.h"

@protocol SignInDelegate <NSObject>
@optional
- (void)engageSignInDidSucceed;
- (void)engageSignInDidFailWithError:(NSError *)error;
- (void)captureSignInDidSucceed;
- (void)captureSignInDidFailWithError:(NSError *)error;
@end

@interface SharedData : NSObject <JREngageDelegate, JRCaptureAuthenticationDelegate>
@property (strong) NSMutableDictionary *engageUser;
@property (strong) JRCaptureUser       *captureUser;
@property (strong) NSString            *accessToken;
@property (strong) NSString            *creationToken;
@property          BOOL                 isNew;
@property          BOOL                 notYetCreated;
@property (strong) NSString            *currentDisplayName;
@property (strong) NSString            *currentProvider;
@property (weak)   id<SignInDelegate>   signInDelegate;
+ (SharedData *)sharedData;
- (void)startAuthenticationWithCustomInterface:(NSDictionary *)customInterface forDelegate:(id<SignInDelegate>)delegate;
- (void)resaveCaptureUser;
@end

