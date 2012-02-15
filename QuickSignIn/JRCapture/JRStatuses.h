
#import <Foundation/Foundation.h>
#import "JRCapture.h"

@interface JRStatuses : NSObject <NSCopying, JRJsonifying>
@property (nonatomic, copy) NSString *status;  
@property (nonatomic, copy) NSDate *statusCreated;  
- (id)init;
+ (id)statuses;
+ (id)statusesObjectFromDictionary:(NSDictionary*)dictionary;
- (void)updateFromDictionary:(NSDictionary*)dictionary;
@end
