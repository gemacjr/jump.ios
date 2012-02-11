
#import <Foundation/Foundation.h>
#import "JRCapture.h"

@interface JRLocation : NSObject <NSCopying, JRJsonifying>
@property (nonatomic, copy) NSString *country;  
@property (nonatomic, copy) NSString *extendedAddress;  
@property (nonatomic, copy) NSString *formatted;  
@property (nonatomic, copy) NSNumber *latitude;  
@property (nonatomic, copy) NSString *locality;  
@property (nonatomic, copy) NSNumber *longitude;  
@property (nonatomic, copy) NSString *poBox;  
@property (nonatomic, copy) NSString *postalCode;  
@property (nonatomic, copy) NSString *region;  
@property (nonatomic, copy) NSString *streetAddress;  
@property (nonatomic, copy) NSString *type;  
- (id)init;
+ (id)location;
+ (id)locationObjectFromDictionary:(NSDictionary*)dictionary;
@end
