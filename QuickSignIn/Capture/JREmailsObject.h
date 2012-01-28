
#import <Foundation/Foundation.h>
#import "JRCapture.h"

@interface JREmailsObject : NSObject <NSCopying, JRJsonifying>
@property                   BOOL primary;
@property (nonatomic, copy) NSString *type;  
@property (nonatomic, copy) NSString *value;  
- (id)init;
+ (id)emailsObject;
@end
