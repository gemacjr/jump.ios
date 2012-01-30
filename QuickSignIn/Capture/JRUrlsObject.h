
#import <Foundation/Foundation.h>
#import "JRCapture.h"

@interface JRUrlsObject : NSObject <NSCopying, JRJsonifying>
@property                   BOOL primary;
@property (nonatomic, copy) NSString *type;  
@property (nonatomic, copy) NSString *value;  
- (id)init;
+ (id)urlsObject;
+ (id)urlsObjectFromDictionary:(NSDictionary*)dictionary;
@end
