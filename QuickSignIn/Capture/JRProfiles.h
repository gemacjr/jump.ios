
#import <Foundation/Foundation.h>
#import "JRCapture.h"
#import "JRProfile.h"

@interface JRProfiles : NSObject <NSCopying, JRJsonifying>
@property (nonatomic, copy) NSString *accessCredentials;  
@property (nonatomic, copy) NSString *domain;  
@property (nonatomic, copy) NSArray *friends; /* This is an array of strings */ 
@property (nonatomic, copy) NSString *identifier;  
@property (nonatomic, copy) JRProfile *profile;  
@property (nonatomic, copy) NSString *provider;  
@property (nonatomic, copy) NSString *remote_key;  
- (id)initWithDomain:(NSString *)newDomain andIdentifier:(NSString *)newIdentifier;
+ (id)profilesWithDomain:(NSString *)domain andIdentifier:(NSString *)identifier;
+ (id)profilesObjectFromDictionary:(NSDictionary*)dictionary;
@end
