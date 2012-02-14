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
+ (void)setCaptureDomain:(NSString *)newCaptureDomain clientId:(NSString *)newClientId
       andEntityTypeName:(NSString *)newEntityTypeName;
+ (void)createCaptureUser:(NSDictionary *)user withCreationToken:(NSString *)creationToken
              forDelegate:(id<JRCaptureInterfaceDelegate>)delegate;
+ (NSString *)captureMobileEndpointUrl;
@end
