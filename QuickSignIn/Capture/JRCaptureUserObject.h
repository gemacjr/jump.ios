
#import <Foundation/Foundation.h>
#import "JRCapture.h"
#import "JRPhotosObject.h"
#import "JRPrimaryAddressObject.h"
#import "JRProfilesObject.h"
#import "JRStatusesObject.h"

@interface JRCaptureUserObject : NSObject <NSCopying, JRJsonifying>
@property (nonatomic, copy) NSString *aboutMe;  
@property (nonatomic, copy) NSDate *birthday;  
@property (nonatomic, copy) NSString *currentLocation;  
@property (nonatomic, copy) NSString *display;  
@property (nonatomic, copy) NSString *displayName;  
@property (nonatomic, copy) NSString *email;  
@property (nonatomic, copy) NSDate *emailVerified;  
@property (nonatomic, copy) NSString *familyName;  
@property (nonatomic, copy) NSString *gender;  
@property (nonatomic, copy) NSString *givenName;  
@property (nonatomic, copy) NSDate *lastLogin;  
@property (nonatomic, copy) NSString *middleName;  
@property (nonatomic, copy) NSString *password;  
@property (nonatomic, copy) NSArray *photos; /* This is an array of JRPhotosObjects */ 
@property (nonatomic, copy) JRPrimaryAddressObject *primaryAddress;  
@property (nonatomic, copy) NSArray *profiles; /* This is an array of JRProfilesObjects */ 
@property (nonatomic, copy) NSArray *statuses; /* This is an array of JRStatusesObjects */ 
- (id)init;
+ (id)captureUserObject;
+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary;
@end
