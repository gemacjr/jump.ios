
#import <Foundation/Foundation.h>
#import "JRCapture.h"

@interface JRName : NSObject <NSCopying, JRJsonifying>
@property (nonatomic, copy) NSString *familyName;  
@property (nonatomic, copy) NSString *formatted;  
@property (nonatomic, copy) NSString *givenName;  
@property (nonatomic, copy) NSString *honorificPrefix;  
@property (nonatomic, copy) NSString *honorificSuffix;  
@property (nonatomic, copy) NSString *middleName;  
- (id)init;
+ (id)name;
+ (id)nameObjectFromDictionary:(NSDictionary*)dictionary;
- (void)updateFromDictionary:(NSDictionary*)dictionary;
@end
