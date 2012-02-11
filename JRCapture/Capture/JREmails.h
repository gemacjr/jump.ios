
#import <Foundation/Foundation.h>
#import "JRCapture.h"

@interface JREmails : NSObject <NSCopying, JRJsonifying>
@property                   BOOL primary;
@property (nonatomic, copy) NSString *type;  
@property (nonatomic, copy) NSString *value;  
- (id)init;
+ (id)emails;
+ (id)emailsObjectFromDictionary:(NSDictionary*)dictionary;
@end
