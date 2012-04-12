/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


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
#import "JRProfilePhotos.h"
#import "JRUrls.h"

@interface JRProfile : JRCaptureObject
@property (nonatomic, copy) NSString *aboutMe;  
@property (nonatomic, copy) JRArray *accounts; /* This is an array of JRAccounts */ 
@property (nonatomic, copy) JRArray *addresses; /* This is an array of JRAddresses */ 
@property (nonatomic, copy) JRDate *anniversary; /* This is a property of type 'date', which is a typedef of NSDate, etc. The accepted format should be an ISO8601 date string (e.g., yyyy-MM-dd) */ 
@property (nonatomic, copy) NSString *birthday;  
@property (nonatomic, copy) JRBodyType *bodyType;  
@property (nonatomic, copy) JRSimpleArray *books; /* This is an array of JRStringPluralElements with type book */ 
@property (nonatomic, copy) JRSimpleArray *cars; /* This is an array of JRStringPluralElements with type car */ 
@property (nonatomic, copy) JRSimpleArray *children; /* This is an array of JRStringPluralElements with type value */ 
@property (nonatomic, copy) JRCurrentLocation *currentLocation;  
@property (nonatomic, copy) NSString *displayName;  
@property (nonatomic, copy) NSString *drinker;  
@property (nonatomic, copy) JRArray *emails; /* This is an array of JREmails */ 
@property (nonatomic, copy) NSString *ethnicity;  
@property (nonatomic, copy) NSString *fashion;  
@property (nonatomic, copy) JRSimpleArray *food; /* This is an array of JRStringPluralElements with type food */ 
@property (nonatomic, copy) NSString *gender;  
@property (nonatomic, copy) NSString *happiestWhen;  
@property (nonatomic, copy) JRSimpleArray *heroes; /* This is an array of JRStringPluralElements with type hero */ 
@property (nonatomic, copy) NSString *humor;  
@property (nonatomic, copy) JRArray *ims; /* This is an array of JRIms */ 
@property (nonatomic, copy) NSString *interestedInMeeting;  
@property (nonatomic, copy) JRSimpleArray *interests; /* This is an array of JRStringPluralElements with type interest */ 
@property (nonatomic, copy) JRSimpleArray *jobInterests; /* This is an array of JRStringPluralElements with type jobInterest */ 
@property (nonatomic, copy) JRSimpleArray *languages; /* This is an array of JRStringPluralElements with type language */ 
@property (nonatomic, copy) JRSimpleArray *languagesSpoken; /* This is an array of JRStringPluralElements with type languageSpoken */ 
@property (nonatomic, copy) NSString *livingArrangement;  
@property (nonatomic, copy) JRSimpleArray *lookingFor; /* This is an array of JRStringPluralElements with type value */ 
@property (nonatomic, copy) JRSimpleArray *movies; /* This is an array of JRStringPluralElements with type movie */ 
@property (nonatomic, copy) JRSimpleArray *music; /* This is an array of JRStringPluralElements with type music */ 
@property (nonatomic, copy) JRName *name;  
@property (nonatomic, copy) NSString *nickname;  
@property (nonatomic, copy) NSString *note;  
@property (nonatomic, copy) JRArray *organizations; /* This is an array of JROrganizations */ 
@property (nonatomic, copy) JRSimpleArray *pets; /* This is an array of JRStringPluralElements with type value */ 
@property (nonatomic, copy) JRArray *phoneNumbers; /* This is an array of JRPhoneNumbers */ 
@property (nonatomic, copy) JRArray *profilePhotos; /* This is an array of JRProfilePhotos */ 
@property (nonatomic, copy) NSString *politicalViews;  
@property (nonatomic, copy) NSString *preferredUsername;  
@property (nonatomic, copy) NSString *profileSong;  
@property (nonatomic, copy) NSString *profileUrl;  
@property (nonatomic, copy) NSString *profileVideo;  
@property (nonatomic, copy) JRDateTime *published; /* This is a property of type 'dateTime', which is a typedef of NSDate, etc. The accepted format should be an ISO8601 dateTime string (e.g., yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ) */ 
@property (nonatomic, copy) JRSimpleArray *quotes; /* This is an array of JRStringPluralElements with type quote */ 
@property (nonatomic, copy) NSString *relationshipStatus;  
@property (nonatomic, copy) JRSimpleArray *relationships; /* This is an array of JRStringPluralElements with type relationship */ 
@property (nonatomic, copy) NSString *religion;  
@property (nonatomic, copy) NSString *romance;  
@property (nonatomic, copy) NSString *scaredOf;  
@property (nonatomic, copy) NSString *sexualOrientation;  
@property (nonatomic, copy) NSString *smoker;  
@property (nonatomic, copy) JRSimpleArray *sports; /* This is an array of JRStringPluralElements with type sport */ 
@property (nonatomic, copy) NSString *status;  
@property (nonatomic, copy) JRSimpleArray *tags; /* This is an array of JRStringPluralElements with type tag */ 
@property (nonatomic, copy) JRSimpleArray *turnOffs; /* This is an array of JRStringPluralElements with type turnOff */ 
@property (nonatomic, copy) JRSimpleArray *turnOns; /* This is an array of JRStringPluralElements with type turnOn */ 
@property (nonatomic, copy) JRSimpleArray *tvShows; /* This is an array of JRStringPluralElements with type tvShow */ 
@property (nonatomic, copy) JRDateTime *updated; /* This is a property of type 'dateTime', which is a typedef of NSDate, etc. The accepted format should be an ISO8601 dateTime string (e.g., yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ) */ 
@property (nonatomic, copy) JRArray *urls; /* This is an array of JRUrls */ 
@property (nonatomic, copy) NSString *utcOffset;  
- (id)init;
+ (id)profile;
+ (id)profileObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;
- (NSDictionary*)toDictionary;
- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;
- (NSDictionary*)objectProperties;
@end
