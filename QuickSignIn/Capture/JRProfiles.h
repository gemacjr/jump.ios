
#import <Foundation/Foundation.h>
#import "JRCapture.h"
#import "JRProfile.h"

@interface JRProfiles : NSObject <NSCopying, JRJsonifying, JRProfilesAssumedPresence>
@property (nonatomic, copy) NSObject *accessCredentials; /* This is a property of type 'json', and therefore can be an NSDictionary, NSArray, NSString, etc. */ 
@property (nonatomic, copy) NSString *domain;  
@property (nonatomic, copy) NSArray *followers; /* This is an array of strings */ 
@property (nonatomic, copy) NSArray *following; /* This is an array of strings */ 
@property (nonatomic, copy) NSArray *friends; /* This is an array of strings */ 
@property (nonatomic, copy) NSString *identifier;  
@property (nonatomic, copy) JRProfile *profile;  
@property (nonatomic, copy) NSObject *provider; /* This is a property of type 'json', and therefore can be an NSDictionary, NSArray, NSString, etc. */ 
@property (nonatomic, copy) NSString *remote_key;  
- (id)initWithDomain:(NSString *)newDomain andIdentifier:(NSString *)newIdentifier;
+ (id)profilesWithDomain:(NSString *)domain andIdentifier:(NSString *)identifier;
+ (id)profilesObjectFromDictionary:(NSDictionary*)dictionary;
@end
