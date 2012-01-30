
#import <Foundation/Foundation.h>
#import "JRCapture.h"
#import "JRProfileObject.h"

@interface JRProfilesObject : NSObject <NSCopying, JRJsonifying>
@property (nonatomic, copy) NSString *accessCredentials;  
@property (nonatomic, copy) NSString *domain;  
@property (nonatomic, copy) NSArray *friends; /* This is an array of strings */ 
@property (nonatomic, copy) NSString *identifier;  
@property (nonatomic, copy) JRProfileObject *profile;  
@property (nonatomic, copy) NSString *provider;  
@property (nonatomic, copy) NSString *remote_key;  
- (id)initWithDomain:(NSString *)newDomain andIdentifier:(NSString *)newIdentifier;
+ (id)profilesObjectWithDomain:(NSString *)domain andIdentifier:(NSString *)identifier;
+ (id)profilesObjectFromDictionary:(NSDictionary*)dictionary;
@end
