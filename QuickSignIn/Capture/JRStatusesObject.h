
#import <Foundation/Foundation.h>
#import "JRCapture.h"

@interface JRStatusesObject : NSObject <NSCopying, JRJsonifying>
@property (nonatomic, copy) NSString *status;  
@property (nonatomic, copy) NSDate *statusCreated;  
- (id)init;
+ (id)statusesObject;
@end
