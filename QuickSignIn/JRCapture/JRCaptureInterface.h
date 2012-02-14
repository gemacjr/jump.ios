//
//  Created by lillialexis on 1/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "JRConnectionManager.h"
#import "JRCaptureUser.h"

@protocol JRCaptureInterfaceDelegate <NSObject>
@optional
- (void)createCaptureUserDidSucceed;
- (void)createCaptureUserDidFail;
@end

@interface JRCaptureInterface : NSObject <JRConnectionManagerDelegate>
{
    JRCaptureUser *captureUser;

    id<JRCaptureInterfaceDelegate> captureInterfaceDelegate;
}
+ (void)setCaptureUrlString:(NSString *)captureUrlString andEntityTypeName:(NSString *)entityTypeName;
+ (void)createCaptureUser:(NSDictionary *)user withCreationToken:(NSString *)creationToken
              forDelegate:(id<JRCaptureInterfaceDelegate>)delegate;
@end
