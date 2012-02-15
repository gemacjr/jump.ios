
#import <Foundation/Foundation.h>
#import "JRCapture.h"

@interface JRUrls : NSObject <NSCopying, JRJsonifying>
@property                   BOOL primary;
@property (nonatomic, copy) NSString *type;  
@property (nonatomic, copy) NSString *value;  
- (id)init;
+ (id)urls;
+ (id)urlsObjectFromDictionary:(NSDictionary*)dictionary;
- (void)updateFromDictionary:(NSDictionary*)dictionary;
@end
