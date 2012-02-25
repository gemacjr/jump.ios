//
//  Created by lillialexis on 2/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "JRCaptureUser.h"
@protocol JRCaptureUserDelegate <NSObject>
@optional
- (void)captureUserCreated:(JRCaptureUser *)user withResult:(NSString *)result;
- (void)captureUserUpdated:(JRCaptureUser *)user withResult:(NSString *)result;
@end

@interface JRCaptureUser (Extras) <JRCaptureInterfaceDelegate>
@property (copy) NSString *accessToken;
@property (copy) NSString *creationToken;
- (void)updateForDelegate:(id<JRCaptureUserDelegate>)delegate;
- (void)createForDelegate:(id<JRCaptureUserDelegate>)delegate;
@end
