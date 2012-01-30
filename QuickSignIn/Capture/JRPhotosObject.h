
#import <Foundation/Foundation.h>
#import "JRCapture.h"

@interface JRPhotosObject : NSObject <NSCopying, JRJsonifying>
@property                   BOOL primary;
@property (nonatomic, copy) NSString *type;  
@property (nonatomic, copy) NSString *value;  
- (id)init;
+ (id)photosObject;
+ (id)photosObjectFromDictionary:(NSDictionary*)dictionary;
@end
