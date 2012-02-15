
#import <Foundation/Foundation.h>
#import "JRCapture.h"

@interface JRPhoneNumbers : NSObject <NSCopying, JRJsonifying>
@property                   BOOL primary;
@property (nonatomic, copy) NSString *type;  
@property (nonatomic, copy) NSString *value;  
- (id)init;
+ (id)phoneNumbers;
+ (id)phoneNumbersObjectFromDictionary:(NSDictionary*)dictionary;
- (void)updateFromDictionary:(NSDictionary*)dictionary;
@end
