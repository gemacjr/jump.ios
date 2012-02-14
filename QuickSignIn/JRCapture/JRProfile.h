
#import <Foundation/Foundation.h>
#import "JRCapture.h"
#import "JRAccounts.h"
#import "JRAddresses.h"
#import "JRBodyType.h"
#import "JRCurrentLocation.h"
#import "JREmails.h"
#import "JRIms.h"
#import "JRName.h"
#import "JROrganizations.h"
#import "JRPhoneNumbers.h"
#import "JRPhotos.h"
#import "JRUrls.h"

@interface JRProfile : NSObject <NSCopying, JRJsonifying>
@property (nonatomic, copy) NSString *aboutMe;  
@property (nonatomic, copy) NSArray *accounts; /* This is an array of JRAccounts */ 
@property (nonatomic, copy) NSArray *addresses; /* This is an array of JRAddresses */ 
@property (nonatomic, copy) NSDate *anniversary;  
@property (nonatomic, copy) NSString *birthday;  
@property (nonatomic, copy) JRBodyType *bodyType;  
@property (nonatomic, copy) NSArray *books; /* This is an array of strings */ 
@property (nonatomic, copy) NSArray *cars; /* This is an array of strings */ 
@property (nonatomic, copy) NSArray *children; /* This is an array of strings */ 
@property (nonatomic, copy) JRCurrentLocation *currentLocation;  
@property (nonatomic, copy) NSString *displayName;  
@property (nonatomic, copy) NSString *drinker;  
@property (nonatomic, copy) NSArray *emails; /* This is an array of JREmails */ 
@property (nonatomic, copy) NSString *ethnicity;  
@property (nonatomic, copy) NSString *fashion;  
@property (nonatomic, copy) NSArray *food; /* This is an array of strings */ 
@property (nonatomic, copy) NSString *gender;  
@property (nonatomic, copy) NSString *happiestWhen;  
@property (nonatomic, copy) NSArray *heroes; /* This is an array of strings */ 
@property (nonatomic, copy) NSString *humor;  
@property (nonatomic, copy) NSArray *ims; /* This is an array of JRIms */ 
@property (nonatomic, copy) NSString *interestedInMeeting;  
@property (nonatomic, copy) NSArray *interests; /* This is an array of strings */ 
@property (nonatomic, copy) NSArray *jobInterests; /* This is an array of strings */ 
@property (nonatomic, copy) NSArray *languages; /* This is an array of strings */ 
@property (nonatomic, copy) NSArray *languagesSpoken; /* This is an array of strings */ 
@property (nonatomic, copy) NSString *livingArrangement;  
@property (nonatomic, copy) NSArray *lookingFor; /* This is an array of strings */ 
@property (nonatomic, copy) NSArray *movies; /* This is an array of strings */ 
@property (nonatomic, copy) NSArray *music; /* This is an array of strings */ 
@property (nonatomic, copy) JRName *name;  
@property (nonatomic, copy) NSString *nickname;  
@property (nonatomic, copy) NSString *note;  
@property (nonatomic, copy) NSArray *organizations; /* This is an array of JROrganizations */ 
@property (nonatomic, copy) NSArray *pets; /* This is an array of strings */ 
@property (nonatomic, copy) NSArray *phoneNumbers; /* This is an array of JRPhoneNumbers */ 
@property (nonatomic, copy) NSArray *photos; /* This is an array of JRPhotos */ 
@property (nonatomic, copy) NSString *politicalViews;  
@property (nonatomic, copy) NSString *preferredUsername;  
@property (nonatomic, copy) NSString *profileSong;  
@property (nonatomic, copy) NSString *profileUrl;  
@property (nonatomic, copy) NSString *profileVideo;  
@property (nonatomic, copy) NSDate *published;  
@property (nonatomic, copy) NSArray *quotes; /* This is an array of strings */ 
@property (nonatomic, copy) NSString *relationshipStatus;  
@property (nonatomic, copy) NSArray *relationships; /* This is an array of strings */ 
@property (nonatomic, copy) NSString *religion;  
@property (nonatomic, copy) NSString *romance;  
@property (nonatomic, copy) NSString *scaredOf;  
@property (nonatomic, copy) NSString *sexualOrientation;  
@property (nonatomic, copy) NSString *smoker;  
@property (nonatomic, copy) NSArray *sports; /* This is an array of strings */ 
@property (nonatomic, copy) NSString *status;  
@property (nonatomic, copy) NSArray *tags; /* This is an array of strings */ 
@property (nonatomic, copy) NSArray *turnOffs; /* This is an array of strings */ 
@property (nonatomic, copy) NSArray *turnOns; /* This is an array of strings */ 
@property (nonatomic, copy) NSArray *tvShows; /* This is an array of strings */ 
@property (nonatomic, copy) NSDate *updated;  
@property (nonatomic, copy) NSArray *urls; /* This is an array of JRUrls */ 
@property (nonatomic, copy) NSString *utcOffset;  
- (id)init;
+ (id)profile;
+ (id)profileObjectFromDictionary:(NSDictionary*)dictionary;
@end
