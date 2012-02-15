
#import <Foundation/Foundation.h>
#import "JRCapture.h"
#import "JRLocation.h"

@interface JROrganizations : NSObject <NSCopying, JRJsonifying>
@property (nonatomic, copy) NSString *department;  
@property (nonatomic, copy) NSString *description;  
@property (nonatomic, copy) NSString *endDate;  
@property (nonatomic, copy) JRLocation *location;  
@property (nonatomic, copy) NSString *name;  
@property                   BOOL primary;
@property (nonatomic, copy) NSString *startDate;  
@property (nonatomic, copy) NSString *title;  
@property (nonatomic, copy) NSString *type;  
- (id)init;
+ (id)organizations;
+ (id)organizationsObjectFromDictionary:(NSDictionary*)dictionary;
- (void)updateFromDictionary:(NSDictionary*)dictionary;
@end
