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
- (NSArray*)arrayOfGamesReplaceDictionariesFromGamesObjects;
@end

@implementation NSArray (GamesToFromDictionary)
- (NSArray*)arrayOfGamesObjectsFromGamesDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredGamesArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredGamesArray addObject:[JRGamesElement gamesObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredGamesArray;
}

- (NSArray*)arrayOfGamesDictionariesFromGamesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRGamesElement class]])
            [filteredDictionaryArray addObject:[(JRGamesElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfGamesReplaceDictionariesFromGamesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRGamesElement class]])
            [filteredDictionaryArray addObject:[(JRGamesElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (OnipLevelOneToFromDictionary)
- (NSArray*)arrayOfOnipLevelOneObjectsFromOnipLevelOneDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfOnipLevelOneDictionariesFromOnipLevelOneObjects;
- (NSArray*)arrayOfOnipLevelOneReplaceDictionariesFromOnipLevelOneObjects;
@end

@implementation NSArray (OnipLevelOneToFromDictionary)
- (NSArray*)arrayOfOnipLevelOneObjectsFromOnipLevelOneDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredOnipLevelOneArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredOnipLevelOneArray addObject:[JROnipLevelOneElement onipLevelOneObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredOnipLevelOneArray;
}

- (NSArray*)arrayOfOnipLevelOneDictionariesFromOnipLevelOneObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROnipLevelOneElement class]])
            [filteredDictionaryArray addObject:[(JROnipLevelOneElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfOnipLevelOneReplaceDictionariesFromOnipLevelOneObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROnipLevelOneElement class]])
            [filteredDictionaryArray addObject:[(JROnipLevelOneElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PhotosToFromDictionary)
- (NSArray*)arrayOfPhotosObjectsFromPhotosDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPhotosDictionariesFromPhotosObjects;
- (NSArray*)arrayOfPhotosReplaceDictionariesFromPhotosObjects;
@end

@implementation NSArray (PhotosToFromDictionary)
- (NSArray*)arrayOfPhotosObjectsFromPhotosDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredPhotosArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPhotosArray addObject:[JRPhotosElement photosObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredPhotosArray;
}

- (NSArray*)arrayOfPhotosDictionariesFromPhotosObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhotosElement class]])
            [filteredDictionaryArray addObject:[(JRPhotosElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPhotosReplaceDictionariesFromPhotosObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhotosElement class]])
            [filteredDictionaryArray addObject:[(JRPhotosElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PluralLevelOneToFromDictionary)
- (NSArray*)arrayOfPluralLevelOneObjectsFromPluralLevelOneDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPluralLevelOneDictionariesFromPluralLevelOneObjects;
- (NSArray*)arrayOfPluralLevelOneReplaceDictionariesFromPluralLevelOneObjects;
@end

@implementation NSArray (PluralLevelOneToFromDictionary)
- (NSArray*)arrayOfPluralLevelOneObjectsFromPluralLevelOneDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredPluralLevelOneArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPluralLevelOneArray addObject:[JRPluralLevelOneElement pluralLevelOneObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredPluralLevelOneArray;
}

- (NSArray*)arrayOfPluralLevelOneDictionariesFromPluralLevelOneObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralLevelOneElement class]])
            [filteredDictionaryArray addObject:[(JRPluralLevelOneElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPluralLevelOneReplaceDictionariesFromPluralLevelOneObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralLevelOneElement class]])
            [filteredDictionaryArray addObject:[(JRPluralLevelOneElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (ProfilesToFromDictionary)
- (NSArray*)arrayOfProfilesObjectsFromProfilesDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfProfilesDictionariesFromProfilesObjects;
- (NSArray*)arrayOfProfilesReplaceDictionariesFromProfilesObjects;
@end

@implementation NSArray (ProfilesToFromDictionary)
- (NSArray*)arrayOfProfilesObjectsFromProfilesDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredProfilesArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredProfilesArray addObject:[JRProfilesElement profilesObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredProfilesArray;
}

- (NSArray*)arrayOfProfilesDictionariesFromProfilesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfilesElement class]])
            [filteredDictionaryArray addObject:[(JRProfilesElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfProfilesReplaceDictionariesFromProfilesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfilesElement class]])
            [filteredDictionaryArray addObject:[(JRProfilesElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (StatusesToFromDictionary)
- (NSArray*)arrayOfStatusesObjectsFromStatusesDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfStatusesDictionariesFromStatusesObjects;
- (NSArray*)arrayOfStatusesReplaceDictionariesFromStatusesObjects;
@end

@implementation NSArray (StatusesToFromDictionary)
- (NSArray*)arrayOfStatusesObjectsFromStatusesDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredStatusesArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredStatusesArray addObject:[JRStatusesElement statusesObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredStatusesArray;
}

- (NSArray*)arrayOfStatusesDictionariesFromStatusesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRStatusesElement class]])
            [filteredDictionaryArray addObject:[(JRStatusesElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfStatusesReplaceDictionariesFromStatusesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRStatusesElement class]])
            [filteredDictionaryArray addObject:[(JRStatusesElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface JRCaptureUser ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRCaptureUser
{
    JRObjectId *_captureUserId;
    JRUuid *_uuid;
    JRDateTime *_created;
    JRDateTime *_lastUpdated;
    NSString *_aboutMe;
    JRDate *_birthday;
    NSString *_currentLocation;
    JRJsonObject *_display;
    NSString *_displayName;
    NSString *_email;
    JRDateTime *_emailVerified;
    NSString *_familyName;
    NSArray *_games;
    NSString *_gender;
    NSString *_givenName;
    JRDateTime *_lastLogin;
    NSString *_middleName;
    JRObjectLevelOne *_objectLevelOne;
    NSArray *_onipLevelOne;
    JRPassword *_password;
    NSArray *_photos;
    JRPinoLevelOne *_pinoLevelOne;
    NSArray *_pluralLevelOne;
    JRPrimaryAddress *_primaryAddress;
    NSArray *_profiles;
    NSArray *_statuses;
    JRBoolean *_testerBoolean;
    JRInteger *_testerInteger;
    JRIpAddress *_testerIpAddr;
    JRStringArray *_testerStringPlural;
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
@dynamic testerBoolean;
@dynamic testerInteger;
@dynamic testerIpAddr;
@dynamic testerStringPlural;
@synthesize canBeUpdatedOrReplaced;

- (JRObjectId *)captureUserId
{
    return _captureUserId;
}

- (void)setCaptureUserId:(JRObjectId *)newCaptureUserId
{
    [self.dirtyPropertySet addObject:@"captureUserId"];
    _captureUserId = [newCaptureUserId copy];
}

- (JRUuid *)uuid
{
    return _uuid;
}

- (void)setUuid:(JRUuid *)newUuid
{
    [self.dirtyPropertySet addObject:@"uuid"];
    _uuid = [newUuid copy];
}

- (JRDateTime *)created
{
    return _created;
}

- (void)setCreated:(JRDateTime *)newCreated
{
    [self.dirtyPropertySet addObject:@"created"];
    _created = [newCreated copy];
}

- (JRDateTime *)lastUpdated
{
    return _lastUpdated;
}

- (void)setLastUpdated:(JRDateTime *)newLastUpdated
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

- (JRDate *)birthday
{
    return _birthday;
}

- (void)setBirthday:(JRDate *)newBirthday
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

- (JRJsonObject *)display
{
    return _display;
}

- (void)setDisplay:(JRJsonObject *)newDisplay
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

- (JRDateTime *)emailVerified
{
    return _emailVerified;
}

- (void)setEmailVerified:(JRDateTime *)newEmailVerified
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
    [self.dirtyArraySet addObject:@"games"];
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

- (JRDateTime *)lastLogin
{
    return _lastLogin;
}

- (void)setLastLogin:(JRDateTime *)newLastLogin
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
    [self.dirtyArraySet addObject:@"onipLevelOne"];
    _onipLevelOne = [newOnipLevelOne copy];
}

- (JRPassword *)password
{
    return _password;
}

- (void)setPassword:(JRPassword *)newPassword
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
    [self.dirtyArraySet addObject:@"photos"];
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
    [self.dirtyArraySet addObject:@"pluralLevelOne"];
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
    [self.dirtyArraySet addObject:@"profiles"];
    _profiles = [newProfiles copy];
}

- (NSArray *)statuses
{
    return _statuses;
}

- (void)setStatuses:(NSArray *)newStatuses
{
    [self.dirtyArraySet addObject:@"statuses"];
    _statuses = [newStatuses copy];
}

- (JRBoolean *)testerBoolean
{
    return _testerBoolean;
}

- (void)setTesterBoolean:(JRBoolean *)newTesterBoolean
{
    [self.dirtyPropertySet addObject:@"testerBoolean"];
    _testerBoolean = [newTesterBoolean copy];
}

- (BOOL)getTesterBooleanBoolValue
{
    return [_testerBoolean boolValue];
}

- (void)setTesterBooleanWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"testerBoolean"];
    _testerBoolean = [NSNumber numberWithBool:boolVal];
}

- (JRInteger *)testerInteger
{
    return _testerInteger;
}

- (void)setTesterInteger:(JRInteger *)newTesterInteger
{
    [self.dirtyPropertySet addObject:@"testerInteger"];
    _testerInteger = [newTesterInteger copy];
}

- (NSInteger)getTesterIntegerIntegerValue
{
    return [_testerInteger integerValue];
}

- (void)setTesterIntegerWithInteger:(NSInteger)integerVal
{
    [self.dirtyPropertySet addObject:@"testerInteger"];
    _testerInteger = [NSNumber numberWithInteger:integerVal];
}

- (JRIpAddress *)testerIpAddr
{
    return _testerIpAddr;
}

- (void)setTesterIpAddr:(JRIpAddress *)newTesterIpAddr
{
    [self.dirtyPropertySet addObject:@"testerIpAddr"];
    _testerIpAddr = [newTesterIpAddr copy];
}

- (NSArray *)testerStringPlural
{
    return _testerStringPlural;
}

- (void)setTesterStringPlural:(NSArray *)newTesterStringPlural
{
    [self.dirtyArraySet addObject:@"testerStringPlural"];
    _testerStringPlural = [newTesterStringPlural copyArrayOfStringPluralElementsWithType:@"stringPluralItem"];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"";
        self.canBeUpdatedOrReplaced = YES;
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
        self.captureObjectPath = @"";
        self.canBeUpdatedOrReplaced = YES;
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

    captureUserCopy.captureObjectPath = self.captureObjectPath;

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
    captureUserCopy.testerBoolean = self.testerBoolean;
    captureUserCopy.testerInteger = self.testerInteger;
    captureUserCopy.testerIpAddr = self.testerIpAddr;
    captureUserCopy.testerStringPlural = self.testerStringPlural;
    // TODO: Necessary??
    captureUserCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    // TODO: Necessary??
    [captureUserCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [captureUserCopy.dirtyArraySet setSet:self.dirtyArraySet];

    return captureUserCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.captureUserId ? [NSNumber numberWithInteger:[self.captureUserId integerValue]] : [NSNull null])
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
    [dict setObject:(self.testerBoolean ? [NSNumber numberWithBool:[self.testerBoolean boolValue]] : [NSNull null])
             forKey:@"testerBoolean"];
    [dict setObject:(self.testerInteger ? [NSNumber numberWithInteger:[self.testerInteger integerValue]] : [NSNull null])
             forKey:@"testerInteger"];
    [dict setObject:(self.testerIpAddr ? self.testerIpAddr : [NSNull null])
             forKey:@"testerIpAddr"];
    [dict setObject:(self.testerStringPlural ? [self.testerStringPlural arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"testerStringPlural"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRCaptureUser *captureUser = [JRCaptureUser captureUser];


    captureUser.captureUserId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    captureUser.uuid =
        [dictionary objectForKey:@"uuid"] != [NSNull null] ? 
        [dictionary objectForKey:@"uuid"] : nil;

    captureUser.created =
        [dictionary objectForKey:@"created"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]] : nil;

    captureUser.lastUpdated =
        [dictionary objectForKey:@"lastUpdated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]] : nil;

    captureUser.aboutMe =
        [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
        [dictionary objectForKey:@"aboutMe"] : nil;

    captureUser.birthday =
        [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
        [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"birthday"]] : nil;

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
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"emailVerified"]] : nil;

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
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastLogin"]] : nil;

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

    captureUser.testerBoolean =
        [dictionary objectForKey:@"testerBoolean"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"testerBoolean"] boolValue]] : nil;

    captureUser.testerInteger =
        [dictionary objectForKey:@"testerInteger"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"testerInteger"] integerValue]] : nil;

    captureUser.testerIpAddr =
        [dictionary objectForKey:@"testerIpAddr"] != [NSNull null] ? 
        [dictionary objectForKey:@"testerIpAddr"] : nil;

    captureUser.testerStringPlural =
        [dictionary objectForKey:@"testerStringPlural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"testerStringPlural"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"stringPluralItem" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/testerStringPlural", captureUser.captureObjectPath]] : nil;

    [captureUser.dirtyPropertySet removeAllObjects];
    [captureUser.dirtyArraySet removeAllObjects];
    
    return captureUser;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

    if ([dictionary objectForKey:@"id"])
        self.captureUserId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
            [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    if ([dictionary objectForKey:@"uuid"])
        self.uuid = [dictionary objectForKey:@"uuid"] != [NSNull null] ? 
            [dictionary objectForKey:@"uuid"] : nil;

    if ([dictionary objectForKey:@"created"])
        self.created = [dictionary objectForKey:@"created"] != [NSNull null] ? 
            [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]] : nil;

    if ([dictionary objectForKey:@"lastUpdated"])
        self.lastUpdated = [dictionary objectForKey:@"lastUpdated"] != [NSNull null] ? 
            [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]] : nil;

    if ([dictionary objectForKey:@"aboutMe"])
        self.aboutMe = [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
            [dictionary objectForKey:@"aboutMe"] : nil;

    if ([dictionary objectForKey:@"birthday"])
        self.birthday = [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
            [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"birthday"]] : nil;

    if ([dictionary objectForKey:@"currentLocation"])
        self.currentLocation = [dictionary objectForKey:@"currentLocation"] != [NSNull null] ? 
            [dictionary objectForKey:@"currentLocation"] : nil;

    if ([dictionary objectForKey:@"display"])
        self.display = [dictionary objectForKey:@"display"] != [NSNull null] ? 
            [dictionary objectForKey:@"display"] : nil;

    if ([dictionary objectForKey:@"displayName"])
        self.displayName = [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
            [dictionary objectForKey:@"displayName"] : nil;

    if ([dictionary objectForKey:@"email"])
        self.email = [dictionary objectForKey:@"email"] != [NSNull null] ? 
            [dictionary objectForKey:@"email"] : nil;

    if ([dictionary objectForKey:@"emailVerified"])
        self.emailVerified = [dictionary objectForKey:@"emailVerified"] != [NSNull null] ? 
            [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"emailVerified"]] : nil;

    if ([dictionary objectForKey:@"familyName"])
        self.familyName = [dictionary objectForKey:@"familyName"] != [NSNull null] ? 
            [dictionary objectForKey:@"familyName"] : nil;

    if ([dictionary objectForKey:@"gender"])
        self.gender = [dictionary objectForKey:@"gender"] != [NSNull null] ? 
            [dictionary objectForKey:@"gender"] : nil;

    if ([dictionary objectForKey:@"givenName"])
        self.givenName = [dictionary objectForKey:@"givenName"] != [NSNull null] ? 
            [dictionary objectForKey:@"givenName"] : nil;

    if ([dictionary objectForKey:@"lastLogin"])
        self.lastLogin = [dictionary objectForKey:@"lastLogin"] != [NSNull null] ? 
            [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastLogin"]] : nil;

    if ([dictionary objectForKey:@"middleName"])
        self.middleName = [dictionary objectForKey:@"middleName"] != [NSNull null] ? 
            [dictionary objectForKey:@"middleName"] : nil;

    if ([dictionary objectForKey:@"objectLevelOne"] == [NSNull null])
        self.objectLevelOne = nil;
    else if ([dictionary objectForKey:@"objectLevelOne"])
        [self.objectLevelOne updateFromDictionary:[dictionary objectForKey:@"objectLevelOne"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"password"])
        self.password = [dictionary objectForKey:@"password"] != [NSNull null] ? 
            [dictionary objectForKey:@"password"] : nil;

    if ([dictionary objectForKey:@"pinoLevelOne"] == [NSNull null])
        self.pinoLevelOne = nil;
    else if ([dictionary objectForKey:@"pinoLevelOne"])
        [self.pinoLevelOne updateFromDictionary:[dictionary objectForKey:@"pinoLevelOne"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"primaryAddress"] == [NSNull null])
        self.primaryAddress = nil;
    else if ([dictionary objectForKey:@"primaryAddress"])
        [self.primaryAddress updateFromDictionary:[dictionary objectForKey:@"primaryAddress"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"testerBoolean"])
        self.testerBoolean = [dictionary objectForKey:@"testerBoolean"] != [NSNull null] ? 
            [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"testerBoolean"] boolValue]] : nil;

    if ([dictionary objectForKey:@"testerInteger"])
        self.testerInteger = [dictionary objectForKey:@"testerInteger"] != [NSNull null] ? 
            [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"testerInteger"] integerValue]] : nil;

    if ([dictionary objectForKey:@"testerIpAddr"])
        self.testerIpAddr = [dictionary objectForKey:@"testerIpAddr"] != [NSNull null] ? 
            [dictionary objectForKey:@"testerIpAddr"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

    self.captureUserId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.uuid =
        [dictionary objectForKey:@"uuid"] != [NSNull null] ? 
        [dictionary objectForKey:@"uuid"] : nil;

    self.created =
        [dictionary objectForKey:@"created"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]] : nil;

    self.lastUpdated =
        [dictionary objectForKey:@"lastUpdated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]] : nil;

    self.aboutMe =
        [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
        [dictionary objectForKey:@"aboutMe"] : nil;

    self.birthday =
        [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
        [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"birthday"]] : nil;

    self.currentLocation =
        [dictionary objectForKey:@"currentLocation"] != [NSNull null] ? 
        [dictionary objectForKey:@"currentLocation"] : nil;

    self.display =
        [dictionary objectForKey:@"display"] != [NSNull null] ? 
        [dictionary objectForKey:@"display"] : nil;

    self.displayName =
        [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
        [dictionary objectForKey:@"displayName"] : nil;

    self.email =
        [dictionary objectForKey:@"email"] != [NSNull null] ? 
        [dictionary objectForKey:@"email"] : nil;

    self.emailVerified =
        [dictionary objectForKey:@"emailVerified"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"emailVerified"]] : nil;

    self.familyName =
        [dictionary objectForKey:@"familyName"] != [NSNull null] ? 
        [dictionary objectForKey:@"familyName"] : nil;

    self.games =
        [dictionary objectForKey:@"games"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"games"] arrayOfGamesObjectsFromGamesDictionariesWithPath:self.captureObjectPath] : nil;

    self.gender =
        [dictionary objectForKey:@"gender"] != [NSNull null] ? 
        [dictionary objectForKey:@"gender"] : nil;

    self.givenName =
        [dictionary objectForKey:@"givenName"] != [NSNull null] ? 
        [dictionary objectForKey:@"givenName"] : nil;

    self.lastLogin =
        [dictionary objectForKey:@"lastLogin"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastLogin"]] : nil;

    self.middleName =
        [dictionary objectForKey:@"middleName"] != [NSNull null] ? 
        [dictionary objectForKey:@"middleName"] : nil;

    if (![dictionary objectForKey:@"objectLevelOne"] || [dictionary objectForKey:@"objectLevelOne"] == [NSNull null])
        self.objectLevelOne = nil;
    else
        [self.objectLevelOne replaceFromDictionary:[dictionary objectForKey:@"objectLevelOne"] withPath:self.captureObjectPath];

    self.onipLevelOne =
        [dictionary objectForKey:@"onipLevelOne"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"onipLevelOne"] arrayOfOnipLevelOneObjectsFromOnipLevelOneDictionariesWithPath:self.captureObjectPath] : nil;

    self.password =
        [dictionary objectForKey:@"password"] != [NSNull null] ? 
        [dictionary objectForKey:@"password"] : nil;

    self.photos =
        [dictionary objectForKey:@"photos"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfPhotosObjectsFromPhotosDictionariesWithPath:self.captureObjectPath] : nil;

    if (![dictionary objectForKey:@"pinoLevelOne"] || [dictionary objectForKey:@"pinoLevelOne"] == [NSNull null])
        self.pinoLevelOne = nil;
    else
        [self.pinoLevelOne replaceFromDictionary:[dictionary objectForKey:@"pinoLevelOne"] withPath:self.captureObjectPath];

    self.pluralLevelOne =
        [dictionary objectForKey:@"pluralLevelOne"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pluralLevelOne"] arrayOfPluralLevelOneObjectsFromPluralLevelOneDictionariesWithPath:self.captureObjectPath] : nil;

    if (![dictionary objectForKey:@"primaryAddress"] || [dictionary objectForKey:@"primaryAddress"] == [NSNull null])
        self.primaryAddress = nil;
    else
        [self.primaryAddress replaceFromDictionary:[dictionary objectForKey:@"primaryAddress"] withPath:self.captureObjectPath];

    self.profiles =
        [dictionary objectForKey:@"profiles"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"profiles"] arrayOfProfilesObjectsFromProfilesDictionariesWithPath:self.captureObjectPath] : nil;

    self.statuses =
        [dictionary objectForKey:@"statuses"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"statuses"] arrayOfStatusesObjectsFromStatusesDictionariesWithPath:self.captureObjectPath] : nil;

    self.testerBoolean =
        [dictionary objectForKey:@"testerBoolean"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"testerBoolean"] boolValue]] : nil;

    self.testerInteger =
        [dictionary objectForKey:@"testerInteger"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"testerInteger"] integerValue]] : nil;

    self.testerIpAddr =
        [dictionary objectForKey:@"testerIpAddr"] != [NSNull null] ? 
        [dictionary objectForKey:@"testerIpAddr"] : nil;

    self.testerStringPlural =
        [dictionary objectForKey:@"testerStringPlural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"testerStringPlural"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"stringPluralItem" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/testerStringPlural", self.captureObjectPath]] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
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

    if ([self.dirtyPropertySet containsObject:@"gender"])
        [dict setObject:(self.gender ? self.gender : [NSNull null]) forKey:@"gender"];

    if ([self.dirtyPropertySet containsObject:@"givenName"])
        [dict setObject:(self.givenName ? self.givenName : [NSNull null]) forKey:@"givenName"];

    if ([self.dirtyPropertySet containsObject:@"lastLogin"])
        [dict setObject:(self.lastLogin ? [self.lastLogin stringFromISO8601DateTime] : [NSNull null]) forKey:@"lastLogin"];

    if ([self.dirtyPropertySet containsObject:@"middleName"])
        [dict setObject:(self.middleName ? self.middleName : [NSNull null]) forKey:@"middleName"];

    if ([self.dirtyPropertySet containsObject:@"objectLevelOne"])
        [dict setObject:(self.objectLevelOne ?
                              [self.objectLevelOne toUpdateDictionary] :
                              [[JRObjectLevelOne objectLevelOne] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"objectLevelOne"];

    if ([self.dirtyPropertySet containsObject:@"password"])
        [dict setObject:(self.password ? self.password : [NSNull null]) forKey:@"password"];

    if ([self.dirtyPropertySet containsObject:@"pinoLevelOne"])
        [dict setObject:(self.pinoLevelOne ?
                              [self.pinoLevelOne toUpdateDictionary] :
                              [[JRPinoLevelOne pinoLevelOne] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"pinoLevelOne"];

    if ([self.dirtyPropertySet containsObject:@"primaryAddress"])
        [dict setObject:(self.primaryAddress ?
                              [self.primaryAddress toUpdateDictionary] :
                              [[JRPrimaryAddress primaryAddress] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"primaryAddress"];

    if ([self.dirtyPropertySet containsObject:@"testerBoolean"])
        [dict setObject:(self.testerBoolean ? [NSNumber numberWithBool:[self.testerBoolean boolValue]] : [NSNull null]) forKey:@"testerBoolean"];

    if ([self.dirtyPropertySet containsObject:@"testerInteger"])
        [dict setObject:(self.testerInteger ? [NSNumber numberWithInteger:[self.testerInteger integerValue]] : [NSNull null]) forKey:@"testerInteger"];

    if ([self.dirtyPropertySet containsObject:@"testerIpAddr"])
        [dict setObject:(self.testerIpAddr ? self.testerIpAddr : [NSNull null]) forKey:@"testerIpAddr"];

    return dict;
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
    [dict setObject:(self.games ? [self.games arrayOfGamesReplaceDictionariesFromGamesObjects] : [NSArray array]) forKey:@"games"];
    [dict setObject:(self.gender ? self.gender : [NSNull null]) forKey:@"gender"];
    [dict setObject:(self.givenName ? self.givenName : [NSNull null]) forKey:@"givenName"];
    [dict setObject:(self.lastLogin ? [self.lastLogin stringFromISO8601DateTime] : [NSNull null]) forKey:@"lastLogin"];
    [dict setObject:(self.middleName ? self.middleName : [NSNull null]) forKey:@"middleName"];
    [dict setObject:(self.objectLevelOne ?
                          [self.objectLevelOne toReplaceDictionary] :
                          [[JRObjectLevelOne objectLevelOne] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"objectLevelOne"];
    [dict setObject:(self.onipLevelOne ? [self.onipLevelOne arrayOfOnipLevelOneReplaceDictionariesFromOnipLevelOneObjects] : [NSArray array]) forKey:@"onipLevelOne"];
    [dict setObject:(self.password ? self.password : [NSNull null]) forKey:@"password"];
    [dict setObject:(self.photos ? [self.photos arrayOfPhotosReplaceDictionariesFromPhotosObjects] : [NSArray array]) forKey:@"photos"];
    [dict setObject:(self.pinoLevelOne ?
                          [self.pinoLevelOne toReplaceDictionary] :
                          [[JRPinoLevelOne pinoLevelOne] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"pinoLevelOne"];
    [dict setObject:(self.pluralLevelOne ? [self.pluralLevelOne arrayOfPluralLevelOneReplaceDictionariesFromPluralLevelOneObjects] : [NSArray array]) forKey:@"pluralLevelOne"];
    [dict setObject:(self.primaryAddress ?
                          [self.primaryAddress toReplaceDictionary] :
                          [[JRPrimaryAddress primaryAddress] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"primaryAddress"];
    [dict setObject:(self.profiles ? [self.profiles arrayOfProfilesReplaceDictionariesFromProfilesObjects] : [NSArray array]) forKey:@"profiles"];
    [dict setObject:(self.statuses ? [self.statuses arrayOfStatusesReplaceDictionariesFromStatusesObjects] : [NSArray array]) forKey:@"statuses"];
    [dict setObject:(self.testerBoolean ? [NSNumber numberWithBool:[self.testerBoolean boolValue]] : [NSNull null]) forKey:@"testerBoolean"];
    [dict setObject:(self.testerInteger ? [NSNumber numberWithInteger:[self.testerInteger integerValue]] : [NSNull null]) forKey:@"testerInteger"];
    [dict setObject:(self.testerIpAddr ? self.testerIpAddr : [NSNull null]) forKey:@"testerIpAddr"];
    [dict setObject:(self.testerStringPlural ? [self.testerStringPlural arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"testerStringPlural"];

    return dict;
}

- (void)replaceGamesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.games named:@"games"
                    forDelegate:delegate withContext:context];
}

- (void)replaceOnipLevelOneArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.onipLevelOne named:@"onipLevelOne"
                    forDelegate:delegate withContext:context];
}

- (void)replacePhotosArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.photos named:@"photos"
                    forDelegate:delegate withContext:context];
}

- (void)replacePluralLevelOneArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pluralLevelOne named:@"pluralLevelOne"
                    forDelegate:delegate withContext:context];
}

- (void)replaceProfilesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.profiles named:@"profiles"
                    forDelegate:delegate withContext:context];
}

- (void)replaceStatusesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.statuses named:@"statuses"
                    forDelegate:delegate withContext:context];
}

- (void)replaceTesterStringPluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.testerStringPlural ofType:@"stringPluralItem" named:@"testerStringPlural"
                          forDelegate:delegate withContext:context];
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"JRObjectId" forKey:@"captureUserId"];
    [dict setObject:@"JRUuid" forKey:@"uuid"];
    [dict setObject:@"JRDateTime" forKey:@"created"];
    [dict setObject:@"JRDateTime" forKey:@"lastUpdated"];
    [dict setObject:@"NSString" forKey:@"aboutMe"];
    [dict setObject:@"JRDate" forKey:@"birthday"];
    [dict setObject:@"NSString" forKey:@"currentLocation"];
    [dict setObject:@"JRJsonObject" forKey:@"display"];
    [dict setObject:@"NSString" forKey:@"displayName"];
    [dict setObject:@"NSString" forKey:@"email"];
    [dict setObject:@"JRDateTime" forKey:@"emailVerified"];
    [dict setObject:@"NSString" forKey:@"familyName"];
    [dict setObject:@"NSArray" forKey:@"games"];
    [dict setObject:@"NSString" forKey:@"gender"];
    [dict setObject:@"NSString" forKey:@"givenName"];
    [dict setObject:@"JRDateTime" forKey:@"lastLogin"];
    [dict setObject:@"NSString" forKey:@"middleName"];
    [dict setObject:@"JRObjectLevelOne" forKey:@"objectLevelOne"];
    [dict setObject:@"NSArray" forKey:@"onipLevelOne"];
    [dict setObject:@"JRPassword" forKey:@"password"];
    [dict setObject:@"NSArray" forKey:@"photos"];
    [dict setObject:@"JRPinoLevelOne" forKey:@"pinoLevelOne"];
    [dict setObject:@"NSArray" forKey:@"pluralLevelOne"];
    [dict setObject:@"JRPrimaryAddress" forKey:@"primaryAddress"];
    [dict setObject:@"NSArray" forKey:@"profiles"];
    [dict setObject:@"NSArray" forKey:@"statuses"];
    [dict setObject:@"JRBoolean" forKey:@"testerBoolean"];
    [dict setObject:@"JRInteger" forKey:@"testerInteger"];
    [dict setObject:@"JRIpAddress" forKey:@"testerIpAddr"];
    [dict setObject:@"JRStringArray" forKey:@"testerStringPlural"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_captureUserId release];
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
    [_testerBoolean release];
    [_testerInteger release];
    [_testerIpAddr release];
    [_testerStringPlural release];

    [super dealloc];
}
@end
