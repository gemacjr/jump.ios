//
//  Created by lillialexis on 1/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "JRConnectionManager.h"
#import "JRCaptureUser.h"

@protocol CaptureInterfaceDelegate <NSObject>
@optional
- (void)createCaptureUserDidSucceed;
- (void)createCaptureUserDidFail;
@end

@interface CaptureInterface : NSObject <JRConnectionManagerDelegate>
{
    JRCaptureUser *captureUser;

    id<CaptureInterfaceDelegate> captureInterfaceDelegate;
}
+ (void)createCaptureUser:(NSDictionary *)user withCreationToken:(NSString *)creationToken
              forDelegate:(id<CaptureInterfaceDelegate>)delegate;
//+ (void)captureUserObjectFromDictionary:(NSDictionary *)dictionary;
+ (void)setCaptureUrlString:(NSString *)captureUrlString andEntityTypeName:(NSString *)entityTypeName;
@end
