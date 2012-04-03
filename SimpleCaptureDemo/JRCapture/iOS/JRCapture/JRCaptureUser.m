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


#import "JRCaptureUser.h"

@interface NSArray (GamesToFromDictionary)
- (NSArray*)arrayOfGamesObjectsFromGamesDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfGamesDictionariesFromGamesObjects;
- (NSArray*)arrayOfGamesUpdateDictionariesFromGamesObjects;
- (NSArray*)arrayOfGamesReplaceDictionariesFromGamesObjects;
@end

@implementation NSArray (GamesToFromDictionary)
- (NSArray*)arrayOfGamesObjectsFromGamesDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredGamesArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredGamesArray addObject:[JRGames gamesObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredGamesArray;
}

- (NSArray*)arrayOfGamesDictionariesFromGamesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRGames class]])
            [filteredDictionaryArray addObject:[(JRGames*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfGamesUpdateDictionariesFromGamesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRGames class]])
            [filteredDictionaryArray addObject:[(JRGames*)object toUpdateDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfGamesReplaceDictionariesFromGamesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRGames class]])
            [filteredDictionaryArray addObject:[(JRGames*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (OnipLevelOneToFromDictionary)
- (NSArray*)arrayOfOnipLevelOneObjectsFromOnipLevelOneDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfOnipLevelOneDictionariesFromOnipLevelOneObjects;
- (NSArray*)arrayOfOnipLevelOneUpdateDictionariesFromOnipLevelOneObjects;
- (NSArray*)arrayOfOnipLevelOneReplaceDictionariesFromOnipLevelOneObjects;
@end

@implementation NSArray (OnipLevelOneToFromDictionary)
- (NSArray*)arrayOfOnipLevelOneObjectsFromOnipLevelOneDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredOnipLevelOneArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredOnipLevelOneArray addObject:[JROnipLevelOne onipLevelOneObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredOnipLevelOneArray;
}

- (NSArray*)arrayOfOnipLevelOneDictionariesFromOnipLevelOneObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROnipLevelOne class]])
            [filteredDictionaryArray addObject:[(JROnipLevelOne*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfOnipLevelOneUpdateDictionariesFromOnipLevelOneObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROnipLevelOne class]])
            [filteredDictionaryArray addObject:[(JROnipLevelOne*)object toUpdateDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfOnipLevelOneReplaceDictionariesFromOnipLevelOneObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROnipLevelOne class]])
            [filteredDictionaryArray addObject:[(JROnipLevelOne*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PhotosToFromDictionary)
- (NSArray*)arrayOfPhotosObjectsFromPhotosDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPhotosDictionariesFromPhotosObjects;
- (NSArray*)arrayOfPhotosUpdateDictionariesFromPhotosObjects;
- (NSArray*)arrayOfPhotosReplaceDictionariesFromPhotosObjects;
@end

@implementation NSArray (PhotosToFromDictionary)
- (NSArray*)arrayOfPhotosObjectsFromPhotosDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredPhotosArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPhotosArray addObject:[JRPhotos photosObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredPhotosArray;
}

- (NSArray*)arrayOfPhotosDictionariesFromPhotosObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhotos class]])
            [filteredDictionaryArray addObject:[(JRPhotos*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPhotosUpdateDictionariesFromPhotosObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhotos class]])
            [filteredDictionaryArray addObject:[(JRPhotos*)object toUpdateDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPhotosReplaceDictionariesFromPhotosObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhotos class]])
            [filteredDictionaryArray addObject:[(JRPhotos*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PluralLevelOneToFromDictionary)
- (NSArray*)arrayOfPluralLevelOneObjectsFromPluralLevelOneDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPluralLevelOneDictionariesFromPluralLevelOneObjects;
- (NSArray*)arrayOfPluralLevelOneUpdateDictionariesFromPluralLevelOneObjects;
- (NSArray*)arrayOfPluralLevelOneReplaceDictionariesFromPluralLevelOneObjects;
@end

@implementation NSArray (PluralLevelOneToFromDictionary)
- (NSArray*)arrayOfPluralLevelOneObjectsFromPluralLevelOneDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredPluralLevelOneArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPluralLevelOneArray addObject:[JRPluralLevelOne pluralLevelOneObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredPluralLevelOneArray;
}

- (NSArray*)arrayOfPluralLevelOneDictionariesFromPluralLevelOneObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralLevelOne class]])
            [filteredDictionaryArray addObject:[(JRPluralLevelOne*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPluralLevelOneUpdateDictionariesFromPluralLevelOneObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralLevelOne class]])
            [filteredDictionaryArray addObject:[(JRPluralLevelOne*)object toUpdateDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPluralLevelOneReplaceDictionariesFromPluralLevelOneObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralLevelOne class]])
            [filteredDictionaryArray addObject:[(JRPluralLevelOne*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (ProfilesToFromDictionary)
- (NSArray*)arrayOfProfilesObjectsFromProfilesDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfProfilesDictionariesFromProfilesObjects;
- (NSArray*)arrayOfProfilesUpdateDictionariesFromProfilesObjects;
- (NSArray*)arrayOfProfilesReplaceDictionariesFromProfilesObjects;
@end

@implementation NSArray (ProfilesToFromDictionary)
- (NSArray*)arrayOfProfilesObjectsFromProfilesDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredProfilesArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredProfilesArray addObject:[JRProfiles profilesObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredProfilesArray;
}

- (NSArray*)arrayOfProfilesDictionariesFromProfilesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfiles class]])
            [filteredDictionaryArray addObject:[(JRProfiles*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfProfilesUpdateDictionariesFromProfilesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfiles class]])
            [filteredDictionaryArray addObject:[(JRProfiles*)object toUpdateDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfProfilesReplaceDictionariesFromProfilesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfiles class]])
            [filteredDictionaryArray addObject:[(JRProfiles*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (StatusesToFromDictionary)
- (NSArray*)arrayOfStatusesObjectsFromStatusesDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfStatusesDictionariesFromStatusesObjects;
- (NSArray*)arrayOfStatusesUpdateDictionariesFromStatusesObjects;
- (NSArray*)arrayOfStatusesReplaceDictionariesFromStatusesObjects;
@end

@implementation NSArray (StatusesToFromDictionary)
- (NSArray*)arrayOfStatusesObjectsFromStatusesDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredStatusesArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredStatusesArray addObject:[JRStatuses statusesObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredStatusesArray;
}

- (NSArray*)arrayOfStatusesDictionariesFromStatusesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRStatuses class]])
            [filteredDictionaryArray addObject:[(JRStatuses*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfStatusesUpdateDictionariesFromStatusesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRStatuses class]])
            [filteredDictionaryArray addObject:[(JRStatuses*)object toUpdateDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfStatusesReplaceDictionariesFromStatusesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRStatuses class]])
            [filteredDictionaryArray addObject:[(JRStatuses*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation JRCaptureUser
{
    NSInteger _captureUserId;
    NSString *_uuid;
    NSDate *_created;
    NSDate *_lastUpdated;
    NSString *_aboutMe;
    NSDate *_birthday;
    NSString *_currentLocation;
    NSObject *_display;
    NSString *_displayName;
    NSString *_email;
    NSDate *_emailVerified;
    NSString *_familyName;
    NSArray *_games;
    NSString *_gender;
    NSString *_givenName;
    NSDate *_lastLogin;
    NSString *_middleName;
    JRObjectLevelOne *_objectLevelOne;
    NSArray *_onipLevelOne;
    NSObject *_password;
    NSArray *_photos;
    JRPinoLevelOne *_pinoLevelOne;
    NSArray *_pluralLevelOne;
    JRPrimaryAddress *_primaryAddress;
    NSArray *_profiles;
    NSArray *_statuses;
}
@dynamic captureUserId;
@dynamic uuid;
@dynamic created;
@dynamic lastUpdated;
@dynamic aboutMe;
@dynamic birthday;
@dynamic currentLocation;
@dynamic display;
@dynamic displayName;
@dynamic email;
@dynamic emailVerified;
@dynamic familyName;
@dynamic games;
@dynamic gender;
@dynamic givenName;
@dynamic lastLogin;
@dynamic middleName;
@dynamic objectLevelOne;
@dynamic onipLevelOne;
@dynamic password;
@dynamic photos;
@dynamic pinoLevelOne;
@dynamic pluralLevelOne;
@dynamic primaryAddress;
@dynamic profiles;
@dynamic statuses;

- (NSInteger)captureUserId
{
    return _captureUserId;
}

- (void)setCaptureUserId:(NSInteger)newCaptureUserId
{
    [self.dirtyPropertySet addObject:@"captureUserId"];
    _captureUserId = newCaptureUserId;
}

- (NSString *)uuid
{
    return _uuid;
}

- (void)setUuid:(NSString *)newUuid
{
    [self.dirtyPropertySet addObject:@"uuid"];
    _uuid = [newUuid copy];
}

- (NSDate *)created
{
    return _created;
}

- (void)setCreated:(NSDate *)newCreated
{
    [self.dirtyPropertySet addObject:@"created"];
    _created = [newCreated copy];
}

- (NSDate *)lastUpdated
{
    return _lastUpdated;
}

- (void)setLastUpdated:(NSDate *)newLastUpdated
{
    [self.dirtyPropertySet addObject:@"lastUpdated"];
    _lastUpdated = [newLastUpdated copy];
}

- (NSString *)aboutMe
{
    return _aboutMe;
}

- (void)setAboutMe:(NSString *)newAboutMe
{
    [self.dirtyPropertySet addObject:@"aboutMe"];
    _aboutMe = [newAboutMe copy];
}

- (NSDate *)birthday
{
    return _birthday;
}

- (void)setBirthday:(NSDate *)newBirthday
{
    [self.dirtyPropertySet addObject:@"birthday"];
    _birthday = [newBirthday copy];
}

- (NSString *)currentLocation
{
    return _currentLocation;
}

- (void)setCurrentLocation:(NSString *)newCurrentLocation
{
    [self.dirtyPropertySet addObject:@"currentLocation"];
    _currentLocation = [newCurrentLocation copy];
}

- (NSObject *)display
{
    return _display;
}

- (void)setDisplay:(NSObject *)newDisplay
{
    [self.dirtyPropertySet addObject:@"display"];
    _display = [newDisplay copy];
}

- (NSString *)displayName
{
    return _displayName;
}

- (void)setDisplayName:(NSString *)newDisplayName
{
    [self.dirtyPropertySet addObject:@"displayName"];
    _displayName = [newDisplayName copy];
}

- (NSString *)email
{
    return _email;
}

- (void)setEmail:(NSString *)newEmail
{
    [self.dirtyPropertySet addObject:@"email"];
    _email = [newEmail copy];
}

- (NSDate *)emailVerified
{
    return _emailVerified;
}

- (void)setEmailVerified:(NSDate *)newEmailVerified
{
    [self.dirtyPropertySet addObject:@"emailVerified"];
    _emailVerified = [newEmailVerified copy];
}

- (NSString *)familyName
{
    return _familyName;
}

- (void)setFamilyName:(NSString *)newFamilyName
{
    [self.dirtyPropertySet addObject:@"familyName"];
    _familyName = [newFamilyName copy];
}

- (NSArray *)games
{
    return _games;
}

- (void)setGames:(NSArray *)newGames
{
    [self.dirtyPropertySet addObject:@"games"];
    _games = [newGames copy];
}

- (NSString *)gender
{
    return _gender;
}

- (void)setGender:(NSString *)newGender
{
    [self.dirtyPropertySet addObject:@"gender"];
    _gender = [newGender copy];
}

- (NSString *)givenName
{
    return _givenName;
}

- (void)setGivenName:(NSString *)newGivenName
{
    [self.dirtyPropertySet addObject:@"givenName"];
    _givenName = [newGivenName copy];
}

- (NSDate *)lastLogin
{
    return _lastLogin;
}

- (void)setLastLogin:(NSDate *)newLastLogin
{
    [self.dirtyPropertySet addObject:@"lastLogin"];
    _lastLogin = [newLastLogin copy];
}

- (NSString *)middleName
{
    return _middleName;
}

- (void)setMiddleName:(NSString *)newMiddleName
{
    [self.dirtyPropertySet addObject:@"middleName"];
    _middleName = [newMiddleName copy];
}

- (JRObjectLevelOne *)objectLevelOne
{
    return _objectLevelOne;
}

- (void)setObjectLevelOne:(JRObjectLevelOne *)newObjectLevelOne
{
    [self.dirtyPropertySet addObject:@"objectLevelOne"];
    _objectLevelOne = [newObjectLevelOne copy];
}

- (NSArray *)onipLevelOne
{
    return _onipLevelOne;
}

- (void)setOnipLevelOne:(NSArray *)newOnipLevelOne
{
    [self.dirtyPropertySet addObject:@"onipLevelOne"];
    _onipLevelOne = [newOnipLevelOne copy];
}

- (NSObject *)password
{
    return _password;
}

- (void)setPassword:(NSObject *)newPassword
{
    [self.dirtyPropertySet addObject:@"password"];
    _password = [newPassword copy];
}

- (NSArray *)photos
{
    return _photos;
}

- (void)setPhotos:(NSArray *)newPhotos
{
    [self.dirtyPropertySet addObject:@"photos"];
    _photos = [newPhotos copy];
}

- (JRPinoLevelOne *)pinoLevelOne
{
    return _pinoLevelOne;
}

- (void)setPinoLevelOne:(JRPinoLevelOne *)newPinoLevelOne
{
    [self.dirtyPropertySet addObject:@"pinoLevelOne"];
    _pinoLevelOne = [newPinoLevelOne copy];
}

- (NSArray *)pluralLevelOne
{
    return _pluralLevelOne;
}

- (void)setPluralLevelOne:(NSArray *)newPluralLevelOne
{
    [self.dirtyPropertySet addObject:@"pluralLevelOne"];
    _pluralLevelOne = [newPluralLevelOne copy];
}

- (JRPrimaryAddress *)primaryAddress
{
    return _primaryAddress;
}

- (void)setPrimaryAddress:(JRPrimaryAddress *)newPrimaryAddress
{
    [self.dirtyPropertySet addObject:@"primaryAddress"];
    _primaryAddress = [newPrimaryAddress copy];
}

- (NSArray *)profiles
{
    return _profiles;
}

- (void)setProfiles:(NSArray *)newProfiles
{
    [self.dirtyPropertySet addObject:@"profiles"];
    _profiles = [newProfiles copy];
}

- (NSArray *)statuses
{
    return _statuses;
}

- (void)setStatuses:(NSArray *)newStatuses
{
    [self.dirtyPropertySet addObject:@"statuses"];
    _statuses = [newStatuses copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/";
    }
    return self;
}

- (id)initWithEmail:(NSString *)newEmail
{
    if (!newEmail)
    {
        [self release];
        return nil;
     }

    if ((self = [super init]))
    {
        self.captureObjectPath = @"/";
        _email = [newEmail copy];
    }
    return self;
}

+ (id)captureUser
{
    return [[[JRCaptureUser alloc] init] autorelease];
}

+ (id)captureUserWithEmail:(NSString *)email
{
    return [[[JRCaptureUser alloc] initWithEmail:email] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRCaptureUser *captureUserCopy =
                [[JRCaptureUser allocWithZone:zone] initWithEmail:self.email];

    captureUserCopy.captureUserId = self.captureUserId;
    captureUserCopy.uuid = self.uuid;
    captureUserCopy.created = self.created;
    captureUserCopy.lastUpdated = self.lastUpdated;
    captureUserCopy.aboutMe = self.aboutMe;
    captureUserCopy.birthday = self.birthday;
    captureUserCopy.currentLocation = self.currentLocation;
    captureUserCopy.display = self.display;
    captureUserCopy.displayName = self.displayName;
    captureUserCopy.emailVerified = self.emailVerified;
    captureUserCopy.familyName = self.familyName;
    captureUserCopy.games = self.games;
    captureUserCopy.gender = self.gender;
    captureUserCopy.givenName = self.givenName;
    captureUserCopy.lastLogin = self.lastLogin;
    captureUserCopy.middleName = self.middleName;
    captureUserCopy.objectLevelOne = self.objectLevelOne;
    captureUserCopy.onipLevelOne = self.onipLevelOne;
    captureUserCopy.password = self.password;
    captureUserCopy.photos = self.photos;
    captureUserCopy.pinoLevelOne = self.pinoLevelOne;
    captureUserCopy.pluralLevelOne = self.pluralLevelOne;
    captureUserCopy.primaryAddress = self.primaryAddress;
    captureUserCopy.profiles = self.profiles;
    captureUserCopy.statuses = self.statuses;

    [captureUserCopy.dirtyPropertySet removeAllObjects];
    [captureUserCopy.dirtyPropertySet setSet:self.dirtyPropertySet];

    return captureUserCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:[NSNumber numberWithInt:self.captureUserId]
             forKey:@"id"];
    [dict setObject:(self.uuid ? self.uuid : [NSNull null])
             forKey:@"uuid"];
    [dict setObject:(self.created ? [self.created stringFromISO8601DateTime] : [NSNull null])
             forKey:@"created"];
    [dict setObject:(self.lastUpdated ? [self.lastUpdated stringFromISO8601DateTime] : [NSNull null])
             forKey:@"lastUpdated"];
    [dict setObject:(self.aboutMe ? self.aboutMe : [NSNull null])
             forKey:@"aboutMe"];
    [dict setObject:(self.birthday ? [self.birthday stringFromISO8601Date] : [NSNull null])
             forKey:@"birthday"];
    [dict setObject:(self.currentLocation ? self.currentLocation : [NSNull null])
             forKey:@"currentLocation"];
    [dict setObject:(self.display ? self.display : [NSNull null])
             forKey:@"display"];
    [dict setObject:(self.displayName ? self.displayName : [NSNull null])
             forKey:@"displayName"];
    [dict setObject:(self.email ? self.email : [NSNull null])
             forKey:@"email"];
    [dict setObject:(self.emailVerified ? [self.emailVerified stringFromISO8601DateTime] : [NSNull null])
             forKey:@"emailVerified"];
    [dict setObject:(self.familyName ? self.familyName : [NSNull null])
             forKey:@"familyName"];
    [dict setObject:(self.games ? [self.games arrayOfGamesDictionariesFromGamesObjects] : [NSNull null])
             forKey:@"games"];
    [dict setObject:(self.gender ? self.gender : [NSNull null])
             forKey:@"gender"];
    [dict setObject:(self.givenName ? self.givenName : [NSNull null])
             forKey:@"givenName"];
    [dict setObject:(self.lastLogin ? [self.lastLogin stringFromISO8601DateTime] : [NSNull null])
             forKey:@"lastLogin"];
    [dict setObject:(self.middleName ? self.middleName : [NSNull null])
             forKey:@"middleName"];
    [dict setObject:(self.objectLevelOne ? [self.objectLevelOne toDictionary] : [NSNull null])
             forKey:@"objectLevelOne"];
    [dict setObject:(self.onipLevelOne ? [self.onipLevelOne arrayOfOnipLevelOneDictionariesFromOnipLevelOneObjects] : [NSNull null])
             forKey:@"onipLevelOne"];
    [dict setObject:(self.password ? self.password : [NSNull null])
             forKey:@"password"];
    [dict setObject:(self.photos ? [self.photos arrayOfPhotosDictionariesFromPhotosObjects] : [NSNull null])
             forKey:@"photos"];
    [dict setObject:(self.pinoLevelOne ? [self.pinoLevelOne toDictionary] : [NSNull null])
             forKey:@"pinoLevelOne"];
    [dict setObject:(self.pluralLevelOne ? [self.pluralLevelOne arrayOfPluralLevelOneDictionariesFromPluralLevelOneObjects] : [NSNull null])
             forKey:@"pluralLevelOne"];
    [dict setObject:(self.primaryAddress ? [self.primaryAddress toDictionary] : [NSNull null])
             forKey:@"primaryAddress"];
    [dict setObject:(self.profiles ? [self.profiles arrayOfProfilesDictionariesFromProfilesObjects] : [NSNull null])
             forKey:@"profiles"];
    [dict setObject:(self.statuses ? [self.statuses arrayOfStatusesDictionariesFromStatusesObjects] : [NSNull null])
             forKey:@"statuses"];

    return dict;
}

+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    JRCaptureUser *captureUser = [JRCaptureUser captureUser];
//    captureUser.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"captureUser", captureUser.captureUserId];

    captureUser.captureObjectPath = @"";

    captureUser.captureUserId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [(NSNumber*)[dictionary objectForKey:@"id"] intValue] : 0;

    captureUser.uuid =
        [dictionary objectForKey:@"uuid"] != [NSNull null] ? 
        [dictionary objectForKey:@"uuid"] : nil;

    captureUser.created =
        [dictionary objectForKey:@"created"] != [NSNull null] ? 
        [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]] : nil;

    captureUser.lastUpdated =
        [dictionary objectForKey:@"lastUpdated"] != [NSNull null] ? 
        [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]] : nil;

    captureUser.aboutMe =
        [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
        [dictionary objectForKey:@"aboutMe"] : nil;

    captureUser.birthday =
        [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
        [NSDate dateFromISO8601DateString:[dictionary objectForKey:@"birthday"]] : nil;

    captureUser.currentLocation =
        [dictionary objectForKey:@"currentLocation"] != [NSNull null] ? 
        [dictionary objectForKey:@"currentLocation"] : nil;

    captureUser.display =
        [dictionary objectForKey:@"display"] != [NSNull null] ? 
        [dictionary objectForKey:@"display"] : nil;

    captureUser.displayName =
        [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
        [dictionary objectForKey:@"displayName"] : nil;

    captureUser.email =
        [dictionary objectForKey:@"email"] != [NSNull null] ? 
        [dictionary objectForKey:@"email"] : nil;

    captureUser.emailVerified =
        [dictionary objectForKey:@"emailVerified"] != [NSNull null] ? 
        [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"emailVerified"]] : nil;

    captureUser.familyName =
        [dictionary objectForKey:@"familyName"] != [NSNull null] ? 
        [dictionary objectForKey:@"familyName"] : nil;

    captureUser.games =
        [dictionary objectForKey:@"games"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"games"] arrayOfGamesObjectsFromGamesDictionariesWithPath:captureUser.captureObjectPath] : nil;

    captureUser.gender =
        [dictionary objectForKey:@"gender"] != [NSNull null] ? 
        [dictionary objectForKey:@"gender"] : nil;

    captureUser.givenName =
        [dictionary objectForKey:@"givenName"] != [NSNull null] ? 
        [dictionary objectForKey:@"givenName"] : nil;

    captureUser.lastLogin =
        [dictionary objectForKey:@"lastLogin"] != [NSNull null] ? 
        [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastLogin"]] : nil;

    captureUser.middleName =
        [dictionary objectForKey:@"middleName"] != [NSNull null] ? 
        [dictionary objectForKey:@"middleName"] : nil;

    captureUser.objectLevelOne =
        [dictionary objectForKey:@"objectLevelOne"] != [NSNull null] ? 
        [JRObjectLevelOne objectLevelOneObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"objectLevelOne"] withPath:captureUser.captureObjectPath] : nil;

    captureUser.onipLevelOne =
        [dictionary objectForKey:@"onipLevelOne"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"onipLevelOne"] arrayOfOnipLevelOneObjectsFromOnipLevelOneDictionariesWithPath:captureUser.captureObjectPath] : nil;

    captureUser.password =
        [dictionary objectForKey:@"password"] != [NSNull null] ? 
        [dictionary objectForKey:@"password"] : nil;

    captureUser.photos =
        [dictionary objectForKey:@"photos"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfPhotosObjectsFromPhotosDictionariesWithPath:captureUser.captureObjectPath] : nil;

    captureUser.pinoLevelOne =
        [dictionary objectForKey:@"pinoLevelOne"] != [NSNull null] ? 
        [JRPinoLevelOne pinoLevelOneObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"pinoLevelOne"] withPath:captureUser.captureObjectPath] : nil;

    captureUser.pluralLevelOne =
        [dictionary objectForKey:@"pluralLevelOne"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pluralLevelOne"] arrayOfPluralLevelOneObjectsFromPluralLevelOneDictionariesWithPath:captureUser.captureObjectPath] : nil;

    captureUser.primaryAddress =
        [dictionary objectForKey:@"primaryAddress"] != [NSNull null] ? 
        [JRPrimaryAddress primaryAddressObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"primaryAddress"] withPath:captureUser.captureObjectPath] : nil;

    captureUser.profiles =
        [dictionary objectForKey:@"profiles"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"profiles"] arrayOfProfilesObjectsFromProfilesDictionariesWithPath:captureUser.captureObjectPath] : nil;

    captureUser.statuses =
        [dictionary objectForKey:@"statuses"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"statuses"] arrayOfStatusesObjectsFromStatusesDictionariesWithPath:captureUser.captureObjectPath] : nil;

    [captureUser.dirtyPropertySet removeAllObjects];
    
    return captureUser;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

//    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"captureUser", self.captureUserId];

    self.captureObjectPath = @"";

    if ([dictionary objectForKey:@"id"])
        _captureUserId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
            [(NSNumber*)[dictionary objectForKey:@"id"] intValue] : 0;

    if ([dictionary objectForKey:@"uuid"])
        _uuid = [dictionary objectForKey:@"uuid"] != [NSNull null] ? 
            [dictionary objectForKey:@"uuid"] : nil;

    if ([dictionary objectForKey:@"created"])
        _created = [dictionary objectForKey:@"created"] != [NSNull null] ? 
            [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]] : nil;

    if ([dictionary objectForKey:@"lastUpdated"])
        _lastUpdated = [dictionary objectForKey:@"lastUpdated"] != [NSNull null] ? 
            [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]] : nil;

    if ([dictionary objectForKey:@"aboutMe"])
        _aboutMe = [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
            [dictionary objectForKey:@"aboutMe"] : nil;

    if ([dictionary objectForKey:@"birthday"])
        _birthday = [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
            [NSDate dateFromISO8601DateString:[dictionary objectForKey:@"birthday"]] : nil;

    if ([dictionary objectForKey:@"currentLocation"])
        _currentLocation = [dictionary objectForKey:@"currentLocation"] != [NSNull null] ? 
            [dictionary objectForKey:@"currentLocation"] : nil;

    if ([dictionary objectForKey:@"display"])
        _display = [dictionary objectForKey:@"display"] != [NSNull null] ? 
            [dictionary objectForKey:@"display"] : nil;

    if ([dictionary objectForKey:@"displayName"])
        _displayName = [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
            [dictionary objectForKey:@"displayName"] : nil;

    if ([dictionary objectForKey:@"email"])
        _email = [dictionary objectForKey:@"email"] != [NSNull null] ? 
            [dictionary objectForKey:@"email"] : nil;

    if ([dictionary objectForKey:@"emailVerified"])
        _emailVerified = [dictionary objectForKey:@"emailVerified"] != [NSNull null] ? 
            [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"emailVerified"]] : nil;

    if ([dictionary objectForKey:@"familyName"])
        _familyName = [dictionary objectForKey:@"familyName"] != [NSNull null] ? 
            [dictionary objectForKey:@"familyName"] : nil;

    if ([dictionary objectForKey:@"games"])
        _games = [dictionary objectForKey:@"games"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"games"] arrayOfGamesObjectsFromGamesDictionariesWithPath:self.captureObjectPath] : nil;

    if ([dictionary objectForKey:@"gender"])
        _gender = [dictionary objectForKey:@"gender"] != [NSNull null] ? 
            [dictionary objectForKey:@"gender"] : nil;

    if ([dictionary objectForKey:@"givenName"])
        _givenName = [dictionary objectForKey:@"givenName"] != [NSNull null] ? 
            [dictionary objectForKey:@"givenName"] : nil;

    if ([dictionary objectForKey:@"lastLogin"])
        _lastLogin = [dictionary objectForKey:@"lastLogin"] != [NSNull null] ? 
            [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastLogin"]] : nil;

    if ([dictionary objectForKey:@"middleName"])
        _middleName = [dictionary objectForKey:@"middleName"] != [NSNull null] ? 
            [dictionary objectForKey:@"middleName"] : nil;

    if ([dictionary objectForKey:@"objectLevelOne"])
        _objectLevelOne = [dictionary objectForKey:@"objectLevelOne"] != [NSNull null] ? 
            [JRObjectLevelOne objectLevelOneObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"objectLevelOne"] withPath:self.captureObjectPath] : nil;

    if ([dictionary objectForKey:@"onipLevelOne"])
        _onipLevelOne = [dictionary objectForKey:@"onipLevelOne"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"onipLevelOne"] arrayOfOnipLevelOneObjectsFromOnipLevelOneDictionariesWithPath:self.captureObjectPath] : nil;

    if ([dictionary objectForKey:@"password"])
        _password = [dictionary objectForKey:@"password"] != [NSNull null] ? 
            [dictionary objectForKey:@"password"] : nil;

    if ([dictionary objectForKey:@"photos"])
        _photos = [dictionary objectForKey:@"photos"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfPhotosObjectsFromPhotosDictionariesWithPath:self.captureObjectPath] : nil;

    if ([dictionary objectForKey:@"pinoLevelOne"])
        _pinoLevelOne = [dictionary objectForKey:@"pinoLevelOne"] != [NSNull null] ? 
            [JRPinoLevelOne pinoLevelOneObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"pinoLevelOne"] withPath:self.captureObjectPath] : nil;

    if ([dictionary objectForKey:@"pluralLevelOne"])
        _pluralLevelOne = [dictionary objectForKey:@"pluralLevelOne"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"pluralLevelOne"] arrayOfPluralLevelOneObjectsFromPluralLevelOneDictionariesWithPath:self.captureObjectPath] : nil;

    if ([dictionary objectForKey:@"primaryAddress"])
        _primaryAddress = [dictionary objectForKey:@"primaryAddress"] != [NSNull null] ? 
            [JRPrimaryAddress primaryAddressObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"primaryAddress"] withPath:self.captureObjectPath] : nil;

    if ([dictionary objectForKey:@"profiles"])
        _profiles = [dictionary objectForKey:@"profiles"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"profiles"] arrayOfProfilesObjectsFromProfilesDictionariesWithPath:self.captureObjectPath] : nil;

    if ([dictionary objectForKey:@"statuses"])
        _statuses = [dictionary objectForKey:@"statuses"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"statuses"] arrayOfStatusesObjectsFromStatusesDictionariesWithPath:self.captureObjectPath] : nil;
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

//    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"captureUser", self.captureUserId];

    self.captureObjectPath = @"";

    _captureUserId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [(NSNumber*)[dictionary objectForKey:@"id"] intValue] : 0;

    _uuid =
        [dictionary objectForKey:@"uuid"] != [NSNull null] ? 
        [dictionary objectForKey:@"uuid"] : nil;

    _created =
        [dictionary objectForKey:@"created"] != [NSNull null] ? 
        [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]] : nil;

    _lastUpdated =
        [dictionary objectForKey:@"lastUpdated"] != [NSNull null] ? 
        [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]] : nil;

    _aboutMe =
        [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
        [dictionary objectForKey:@"aboutMe"] : nil;

    _birthday =
        [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
        [NSDate dateFromISO8601DateString:[dictionary objectForKey:@"birthday"]] : nil;

    _currentLocation =
        [dictionary objectForKey:@"currentLocation"] != [NSNull null] ? 
        [dictionary objectForKey:@"currentLocation"] : nil;

    _display =
        [dictionary objectForKey:@"display"] != [NSNull null] ? 
        [dictionary objectForKey:@"display"] : nil;

    _displayName =
        [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
        [dictionary objectForKey:@"displayName"] : nil;

    _email =
        [dictionary objectForKey:@"email"] != [NSNull null] ? 
        [dictionary objectForKey:@"email"] : nil;

    _emailVerified =
        [dictionary objectForKey:@"emailVerified"] != [NSNull null] ? 
        [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"emailVerified"]] : nil;

    _familyName =
        [dictionary objectForKey:@"familyName"] != [NSNull null] ? 
        [dictionary objectForKey:@"familyName"] : nil;

    _games =
        [dictionary objectForKey:@"games"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"games"] arrayOfGamesObjectsFromGamesDictionariesWithPath:self.captureObjectPath] : nil;

    _gender =
        [dictionary objectForKey:@"gender"] != [NSNull null] ? 
        [dictionary objectForKey:@"gender"] : nil;

    _givenName =
        [dictionary objectForKey:@"givenName"] != [NSNull null] ? 
        [dictionary objectForKey:@"givenName"] : nil;

    _lastLogin =
        [dictionary objectForKey:@"lastLogin"] != [NSNull null] ? 
        [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastLogin"]] : nil;

    _middleName =
        [dictionary objectForKey:@"middleName"] != [NSNull null] ? 
        [dictionary objectForKey:@"middleName"] : nil;

    _objectLevelOne =
        [dictionary objectForKey:@"objectLevelOne"] != [NSNull null] ? 
        [JRObjectLevelOne objectLevelOneObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"objectLevelOne"] withPath:self.captureObjectPath] : nil;

    _onipLevelOne =
        [dictionary objectForKey:@"onipLevelOne"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"onipLevelOne"] arrayOfOnipLevelOneObjectsFromOnipLevelOneDictionariesWithPath:self.captureObjectPath] : nil;

    _password =
        [dictionary objectForKey:@"password"] != [NSNull null] ? 
        [dictionary objectForKey:@"password"] : nil;

    _photos =
        [dictionary objectForKey:@"photos"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfPhotosObjectsFromPhotosDictionariesWithPath:self.captureObjectPath] : nil;

    _pinoLevelOne =
        [dictionary objectForKey:@"pinoLevelOne"] != [NSNull null] ? 
        [JRPinoLevelOne pinoLevelOneObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"pinoLevelOne"] withPath:self.captureObjectPath] : nil;

    _pluralLevelOne =
        [dictionary objectForKey:@"pluralLevelOne"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pluralLevelOne"] arrayOfPluralLevelOneObjectsFromPluralLevelOneDictionariesWithPath:self.captureObjectPath] : nil;

    _primaryAddress =
        [dictionary objectForKey:@"primaryAddress"] != [NSNull null] ? 
        [JRPrimaryAddress primaryAddressObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"primaryAddress"] withPath:self.captureObjectPath] : nil;

    _profiles =
        [dictionary objectForKey:@"profiles"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"profiles"] arrayOfProfilesObjectsFromProfilesDictionariesWithPath:self.captureObjectPath] : nil;

    _statuses =
        [dictionary objectForKey:@"statuses"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"statuses"] arrayOfStatusesObjectsFromStatusesDictionariesWithPath:self.captureObjectPath] : nil;
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"aboutMe"])
        [dict setObject:(self.aboutMe ? self.aboutMe : [NSNull null]) forKey:@"aboutMe"];

    if ([self.dirtyPropertySet containsObject:@"birthday"])
        [dict setObject:(self.birthday ? [self.birthday stringFromISO8601Date] : [NSNull null]) forKey:@"birthday"];

    if ([self.dirtyPropertySet containsObject:@"currentLocation"])
        [dict setObject:(self.currentLocation ? self.currentLocation : [NSNull null]) forKey:@"currentLocation"];

    if ([self.dirtyPropertySet containsObject:@"display"])
        [dict setObject:(self.display ? self.display : [NSNull null]) forKey:@"display"];

    if ([self.dirtyPropertySet containsObject:@"displayName"])
        [dict setObject:(self.displayName ? self.displayName : [NSNull null]) forKey:@"displayName"];

    if ([self.dirtyPropertySet containsObject:@"email"])
        [dict setObject:(self.email ? self.email : [NSNull null]) forKey:@"email"];

    if ([self.dirtyPropertySet containsObject:@"emailVerified"])
        [dict setObject:(self.emailVerified ? [self.emailVerified stringFromISO8601DateTime] : [NSNull null]) forKey:@"emailVerified"];

    if ([self.dirtyPropertySet containsObject:@"familyName"])
        [dict setObject:(self.familyName ? self.familyName : [NSNull null]) forKey:@"familyName"];

    if ([self.dirtyPropertySet containsObject:@"games"])
        [dict setObject:(self.games ? [self.games arrayOfGamesUpdateDictionariesFromGamesObjects] : [NSNull null]) forKey:@"games"];

    if ([self.dirtyPropertySet containsObject:@"gender"])
        [dict setObject:(self.gender ? self.gender : [NSNull null]) forKey:@"gender"];

    if ([self.dirtyPropertySet containsObject:@"givenName"])
        [dict setObject:(self.givenName ? self.givenName : [NSNull null]) forKey:@"givenName"];

    if ([self.dirtyPropertySet containsObject:@"lastLogin"])
        [dict setObject:(self.lastLogin ? [self.lastLogin stringFromISO8601DateTime] : [NSNull null]) forKey:@"lastLogin"];

    if ([self.dirtyPropertySet containsObject:@"middleName"])
        [dict setObject:(self.middleName ? self.middleName : [NSNull null]) forKey:@"middleName"];

    if ([self.dirtyPropertySet containsObject:@"objectLevelOne"])
        [dict setObject:(self.objectLevelOne ? [self.objectLevelOne toUpdateDictionary] : [NSNull null]) forKey:@"objectLevelOne"];

    if ([self.dirtyPropertySet containsObject:@"onipLevelOne"])
        [dict setObject:(self.onipLevelOne ? [self.onipLevelOne arrayOfOnipLevelOneUpdateDictionariesFromOnipLevelOneObjects] : [NSNull null]) forKey:@"onipLevelOne"];

    if ([self.dirtyPropertySet containsObject:@"password"])
        [dict setObject:(self.password ? self.password : [NSNull null]) forKey:@"password"];

    if ([self.dirtyPropertySet containsObject:@"photos"])
        [dict setObject:(self.photos ? [self.photos arrayOfPhotosUpdateDictionariesFromPhotosObjects] : [NSNull null]) forKey:@"photos"];

    if ([self.dirtyPropertySet containsObject:@"pinoLevelOne"])
        [dict setObject:(self.pinoLevelOne ? [self.pinoLevelOne toUpdateDictionary] : [NSNull null]) forKey:@"pinoLevelOne"];

    if ([self.dirtyPropertySet containsObject:@"pluralLevelOne"])
        [dict setObject:(self.pluralLevelOne ? [self.pluralLevelOne arrayOfPluralLevelOneUpdateDictionariesFromPluralLevelOneObjects] : [NSNull null]) forKey:@"pluralLevelOne"];

    if ([self.dirtyPropertySet containsObject:@"primaryAddress"])
        [dict setObject:(self.primaryAddress ? [self.primaryAddress toUpdateDictionary] : [NSNull null]) forKey:@"primaryAddress"];

    if ([self.dirtyPropertySet containsObject:@"profiles"])
        [dict setObject:(self.profiles ? [self.profiles arrayOfProfilesUpdateDictionariesFromProfilesObjects] : [NSNull null]) forKey:@"profiles"];

    if ([self.dirtyPropertySet containsObject:@"statuses"])
        [dict setObject:(self.statuses ? [self.statuses arrayOfStatusesUpdateDictionariesFromStatusesObjects] : [NSNull null]) forKey:@"statuses"];

    return dict;
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:[self toUpdateDictionary]
                                     withId:self.captureUserId
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.aboutMe ? self.aboutMe : [NSNull null]) forKey:@"aboutMe"];
    [dict setObject:(self.birthday ? [self.birthday stringFromISO8601Date] : [NSNull null]) forKey:@"birthday"];
    [dict setObject:(self.currentLocation ? self.currentLocation : [NSNull null]) forKey:@"currentLocation"];
    [dict setObject:(self.display ? self.display : [NSNull null]) forKey:@"display"];
    [dict setObject:(self.displayName ? self.displayName : [NSNull null]) forKey:@"displayName"];
    [dict setObject:(self.email ? self.email : [NSNull null]) forKey:@"email"];
    [dict setObject:(self.emailVerified ? [self.emailVerified stringFromISO8601DateTime] : [NSNull null]) forKey:@"emailVerified"];
    [dict setObject:(self.familyName ? self.familyName : [NSNull null]) forKey:@"familyName"];
    [dict setObject:(self.games ? [self.games arrayOfGamesReplaceDictionariesFromGamesObjects] : [NSNull null]) forKey:@"games"];
    [dict setObject:(self.gender ? self.gender : [NSNull null]) forKey:@"gender"];
    [dict setObject:(self.givenName ? self.givenName : [NSNull null]) forKey:@"givenName"];
    [dict setObject:(self.lastLogin ? [self.lastLogin stringFromISO8601DateTime] : [NSNull null]) forKey:@"lastLogin"];
    [dict setObject:(self.middleName ? self.middleName : [NSNull null]) forKey:@"middleName"];
    [dict setObject:(self.objectLevelOne ? [self.objectLevelOne toReplaceDictionary] : [NSNull null]) forKey:@"objectLevelOne"];
    [dict setObject:(self.onipLevelOne ? [self.onipLevelOne arrayOfOnipLevelOneReplaceDictionariesFromOnipLevelOneObjects] : [NSNull null]) forKey:@"onipLevelOne"];
    [dict setObject:(self.password ? self.password : [NSNull null]) forKey:@"password"];
    [dict setObject:(self.photos ? [self.photos arrayOfPhotosReplaceDictionariesFromPhotosObjects] : [NSNull null]) forKey:@"photos"];
    [dict setObject:(self.pinoLevelOne ? [self.pinoLevelOne toReplaceDictionary] : [NSNull null]) forKey:@"pinoLevelOne"];
    [dict setObject:(self.pluralLevelOne ? [self.pluralLevelOne arrayOfPluralLevelOneReplaceDictionariesFromPluralLevelOneObjects] : [NSNull null]) forKey:@"pluralLevelOne"];
    [dict setObject:(self.primaryAddress ? [self.primaryAddress toReplaceDictionary] : [NSNull null]) forKey:@"primaryAddress"];
    [dict setObject:(self.profiles ? [self.profiles arrayOfProfilesReplaceDictionariesFromProfilesObjects] : [NSNull null]) forKey:@"profiles"];
    [dict setObject:(self.statuses ? [self.statuses arrayOfStatusesReplaceDictionariesFromStatusesObjects] : [NSNull null]) forKey:@"statuses"];

    return dict;
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:[self toReplaceDictionary]
                                      withId:self.captureUserId
                                      atPath:self.captureObjectPath
                                   withToken:[JRCaptureData accessToken]
                                 forDelegate:self
                                 withContext:newContext];
}

- (void)dealloc
{
    [_uuid release];
    [_created release];
    [_lastUpdated release];
    [_aboutMe release];
    [_birthday release];
    [_currentLocation release];
    [_display release];
    [_displayName release];
    [_email release];
    [_emailVerified release];
    [_familyName release];
    [_games release];
    [_gender release];
    [_givenName release];
    [_lastLogin release];
    [_middleName release];
    [_objectLevelOne release];
    [_onipLevelOne release];
    [_password release];
    [_photos release];
    [_pinoLevelOne release];
    [_pluralLevelOne release];
    [_primaryAddress release];
    [_profiles release];
    [_statuses release];

    [super dealloc];
}
@end
