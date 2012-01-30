
#import <Foundation/Foundation.h>
#import "JRCapture.h"

@interface JRBodyTypeObject : NSObject <NSCopying, JRJsonifying>
@property (nonatomic, copy) NSString *build;  
@property (nonatomic, copy) NSString *color;  
@property (nonatomic, copy) NSString *eyeColor;  
@property (nonatomic, copy) NSString *hairColor;  
@property (nonatomic, copy) NSNumber *height;  
- (id)init;
+ (id)bodyTypeObject;
+ (id)bodyTypeObjectFromDictionary:(NSDictionary*)dictionary;
@end
