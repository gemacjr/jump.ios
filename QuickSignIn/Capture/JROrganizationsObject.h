
#import <Foundation/Foundation.h>
#import "JRCapture.h"
#import "JRLocationObject.h"

@interface JROrganizationsObject : NSObject <NSCopying, JRJsonifying>
@property (nonatomic, copy) NSString *department;  
@property (nonatomic, copy) NSString *description;  
@property (nonatomic, copy) NSString *endDate;  
@property (nonatomic, copy) JRLocationObject *location;  
@property (nonatomic, copy) NSString *name;  
@property                   BOOL primary;
@property (nonatomic, copy) NSString *startDate;  
@property (nonatomic, copy) NSString *title;  
@property (nonatomic, copy) NSString *type;  
- (id)init;
+ (id)organizationsObject;
+ (id)organizationsObjectFromDictionary:(NSDictionary*)dictionary;
@end
