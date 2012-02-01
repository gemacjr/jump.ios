//
//  Created by lillialexis on 1/31/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "JREngage.h"

@class JRUserInterfaceMaestro;
@protocol JRCaptureDelegate <JREngageDelegate>

@end
@interface JREngage (Capture)
+ (id)jrEngageWithAppId:(NSString*)appId andTokenUrl:(NSString*)tokenUrl delegate:(id<JREngageDelegate>)delegate;
@end
