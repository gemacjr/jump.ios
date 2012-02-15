
#import <Foundation/Foundation.h>
#import "JRCapture.h"

@interface JRIms : NSObject <NSCopying, JRJsonifying>
@property                   BOOL primary;
@property (nonatomic, copy) NSString *type;  
@property (nonatomic, copy) NSString *value;  
- (id)init;
+ (id)ims;
+ (id)imsObjectFromDictionary:(NSDictionary*)dictionary;
- (void)updateFromDictionary:(NSDictionary*)dictionary;
@end
