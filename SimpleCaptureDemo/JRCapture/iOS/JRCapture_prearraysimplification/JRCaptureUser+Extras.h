//
//  Created by lillialexis on 2/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "JRCaptureUser.h"
#import "JRCaptureInterface.h"

@protocol JRCaptureUserDelegate <NSObject>
@optional
- (void)createCaptureUser:(JRCaptureUser *)user didSucceedWithResult:(NSString *)result;
- (void)createCaptureUser:(JRCaptureUser *)user didFailWithResult:(NSString *)result;
- (void)updateCaptureUser:(JRCaptureUser *)user didSucceedWithResult:(NSString *)result;
- (void)updateCaptureUser:(JRCaptureUser *)user didFailWithResult:(NSString *)result;
@end

@interface JRCaptureUser (Extras) <JRCaptureInterfaceDelegate>
@property (copy) NSString *accessToken;
@property (copy) NSString *creationToken;
- (void)updateForDelegate:(id<JRCaptureUserDelegate>)delegate;
- (void)createForDelegate:(id<JRCaptureUserDelegate>)delegate;
@end
