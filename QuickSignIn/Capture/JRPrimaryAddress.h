
#import <Foundation/Foundation.h>
#import "JRCapture.h"

@interface JRPrimaryAddress : NSObject <NSCopying, JRJsonifying>
@property (nonatomic, copy) NSString *address1;  
@property (nonatomic, copy) NSString *address2;  
@property (nonatomic, copy) NSString *city;  
@property (nonatomic, copy) NSString *company;  
@property (nonatomic, copy) NSString *mobile;  
@property (nonatomic, copy) NSString *phone;  
@property (nonatomic, copy) NSString *stateAbbreviation;  
@property (nonatomic, copy) NSString *zip;  
@property (nonatomic, copy) NSString *zipPlus4;  
- (id)init;
+ (id)primaryAddress;
+ (id)primaryAddressObjectFromDictionary:(NSDictionary*)dictionary;
@end
