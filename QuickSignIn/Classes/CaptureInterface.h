//
//  Created by lillialexis on 1/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "JRConnectionManager.h"

@protocol CaptureInterfaceDelegate <NSObject>
@optional
- (void)createCaptureUserDidSucceed;
- (void)createCaptureUserDidFail;
@end

@interface CaptureInterface : NSObject <JRConnectionManagerDelegate>
{
    NSArray *acceptibleAttributes;
    id<CaptureInterfaceDelegate> captureInterfaceDelegate;
}
+ (void)createCaptureUser:(NSDictionary*)user forDelegate:(id<CaptureInterfaceDelegate>)delegate;
@end
