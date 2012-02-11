
#import <Foundation/Foundation.h>
#import "JRCapture.h"

@interface JRAccounts : NSObject <NSCopying, JRJsonifying>
@property (nonatomic, copy) NSString *domain;  
@property                   BOOL primary;
@property (nonatomic, copy) NSString *userid;  
@property (nonatomic, copy) NSString *username;  
- (id)init;
+ (id)accounts;
+ (id)accountsObjectFromDictionary:(NSDictionary*)dictionary;
@end
