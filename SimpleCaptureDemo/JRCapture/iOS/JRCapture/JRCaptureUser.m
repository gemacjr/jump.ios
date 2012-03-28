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


#import "JRCaptureUser.h"

@interface NSArray (GamesToFromDictionary)
- (NSArray*)arrayOfGamesDictionariesFromGamesObjects;
- (NSArray*)arrayOfGamesObjectsFromGamesDictionaries;
@end

@implementation NSArray (GamesToFromDictionary)
- (NSArray*)arrayOfGamesDictionariesFromGamesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRGames class]])
            [filteredDictionaryArray addObject:[(JRGames*)object dictionaryFromGamesObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfGamesObjectsFromGamesDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRGames gamesObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (OnipLevelOneToFromDictionary)
- (NSArray*)arrayOfOnipLevelOneDictionariesFromOnipLevelOneObjects;
- (NSArray*)arrayOfOnipLevelOneObjectsFromOnipLevelOneDictionaries;
@end

@implementation NSArray (OnipLevelOneToFromDictionary)
- (NSArray*)arrayOfOnipLevelOneDictionariesFromOnipLevelOneObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROnipLevelOne class]])
            [filteredDictionaryArray addObject:[(JROnipLevelOne*)object dictionaryFromOnipLevelOneObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfOnipLevelOneObjectsFromOnipLevelOneDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JROnipLevelOne onipLevelOneObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PhotosToFromDictionary)
- (NSArray*)arrayOfPhotosDictionariesFromPhotosObjects;
- (NSArray*)arrayOfPhotosObjectsFromPhotosDictionaries;
@end

@implementation NSArray (PhotosToFromDictionary)
- (NSArray*)arrayOfPhotosDictionariesFromPhotosObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhotos class]])
            [filteredDictionaryArray addObject:[(JRPhotos*)object dictionaryFromPhotosObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPhotosObjectsFromPhotosDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRPhotos photosObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PluralLevelOneToFromDictionary)
- (NSArray*)arrayOfPluralLevelOneDictionariesFromPluralLevelOneObjects;
- (NSArray*)arrayOfPluralLevelOneObjectsFromPluralLevelOneDictionaries;
@end

@implementation NSArray (PluralLevelOneToFromDictionary)
- (NSArray*)arrayOfPluralLevelOneDictionariesFromPluralLevelOneObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralLevelOne class]])
            [filteredDictionaryArray addObject:[(JRPluralLevelOne*)object dictionaryFromPluralLevelOneObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPluralLevelOneObjectsFromPluralLevelOneDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRPluralLevelOne pluralLevelOneObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (ProfilesToFromDictionary)
- (NSArray*)arrayOfProfilesDictionariesFromProfilesObjects;
- (NSArray*)arrayOfProfilesObjectsFromProfilesDictionaries;
@end

@implementation NSArray (ProfilesToFromDictionary)
- (NSArray*)arrayOfProfilesDictionariesFromProfilesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfiles class]])
            [filteredDictionaryArray addObject:[(JRProfiles*)object dictionaryFromProfilesObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfProfilesObjectsFromProfilesDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRProfiles profilesObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (StatusesToFromDictionary)
- (NSArray*)arrayOfStatusesDictionariesFromStatusesObjects;
- (NSArray*)arrayOfStatusesObjectsFromStatusesDictionaries;
@end

@implementation NSArray (StatusesToFromDictionary)
- (NSArray*)arrayOfStatusesDictionariesFromStatusesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRStatuses class]])
            [filteredDictionaryArray addObject:[(JRStatuses*)object dictionaryFromStatusesObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfStatusesObjectsFromStatusesDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRStatuses statusesObjectFromDictionary:(NSDictionary*)dictionary]];

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

    if (!newUuid)
        _uuid = [NSNull null];
    else
        _uuid = [newUuid copy];
}

- (NSDate *)created
{
    return _created;
}

- (void)setCreated:(NSDate *)newCreated
{
    [self.dirtyPropertySet addObject:@"created"];

    if (!newCreated)
        _created = [NSNull null];
    else
        _created = [newCreated copy];
}

- (NSDate *)lastUpdated
{
    return _lastUpdated;
}

- (void)setLastUpdated:(NSDate *)newLastUpdated
{
    [self.dirtyPropertySet addObject:@"lastUpdated"];

    if (!newLastUpdated)
        _lastUpdated = [NSNull null];
    else
        _lastUpdated = [newLastUpdated copy];
}

- (NSString *)aboutMe
{
    return _aboutMe;
}

- (void)setAboutMe:(NSString *)newAboutMe
{
    [self.dirtyPropertySet addObject:@"aboutMe"];

    if (!newAboutMe)
        _aboutMe = [NSNull null];
    else
        _aboutMe = [newAboutMe copy];
}

- (NSDate *)birthday
{
    return _birthday;
}

- (void)setBirthday:(NSDate *)newBirthday
{
    [self.dirtyPropertySet addObject:@"birthday"];

    if (!newBirthday)
        _birthday = [NSNull null];
    else
        _birthday = [newBirthday copy];
}

- (NSString *)currentLocation
{
    return _currentLocation;
}

- (void)setCurrentLocation:(NSString *)newCurrentLocation
{
    [self.dirtyPropertySet addObject:@"currentLocation"];

    if (!newCurrentLocation)
        _currentLocation = [NSNull null];
    else
        _currentLocation = [newCurrentLocation copy];
}

- (NSObject *)display
{
    return _display;
}

- (void)setDisplay:(NSObject *)newDisplay
{
    [self.dirtyPropertySet addObject:@"display"];

    if (!newDisplay)
        _display = [NSNull null];
    else
        _display = [newDisplay copy];
}

- (NSString *)displayName
{
    return _displayName;
}

- (void)setDisplayName:(NSString *)newDisplayName
{
    [self.dirtyPropertySet addObject:@"displayName"];

    if (!newDisplayName)
        _displayName = [NSNull null];
    else
        _displayName = [newDisplayName copy];
}

- (NSString *)email
{
    return _email;
}

- (void)setEmail:(NSString *)newEmail
{
    [self.dirtyPropertySet addObject:@"email"];

    if (!newEmail)
        _email = [NSNull null];
    else
        _email = [newEmail copy];
}

- (NSDate *)emailVerified
{
    return _emailVerified;
}

- (void)setEmailVerified:(NSDate *)newEmailVerified
{
    [self.dirtyPropertySet addObject:@"emailVerified"];

    if (!newEmailVerified)
        _emailVerified = [NSNull null];
    else
        _emailVerified = [newEmailVerified copy];
}

- (NSString *)familyName
{
    return _familyName;
}

- (void)setFamilyName:(NSString *)newFamilyName
{
    [self.dirtyPropertySet addObject:@"familyName"];

    if (!newFamilyName)
        _familyName = [NSNull null];
    else
        _familyName = [newFamilyName copy];
}

- (NSArray *)games
{
    return _games;
}

- (void)setGames:(NSArray *)newGames
{
    [self.dirtyPropertySet addObject:@"games"];

    if (!newGames)
        _games = [NSNull null];
    else
        _games = [newGames copy];
}

- (NSString *)gender
{
    return _gender;
}

- (void)setGender:(NSString *)newGender
{
    [self.dirtyPropertySet addObject:@"gender"];

    if (!newGender)
        _gender = [NSNull null];
    else
        _gender = [newGender copy];
}

- (NSString *)givenName
{
    return _givenName;
}

- (void)setGivenName:(NSString *)newGivenName
{
    [self.dirtyPropertySet addObject:@"givenName"];

    if (!newGivenName)
        _givenName = [NSNull null];
    else
        _givenName = [newGivenName copy];
}

- (NSDate *)lastLogin
{
    return _lastLogin;
}

- (void)setLastLogin:(NSDate *)newLastLogin
{
    [self.dirtyPropertySet addObject:@"lastLogin"];

    if (!newLastLogin)
        _lastLogin = [NSNull null];
    else
        _lastLogin = [newLastLogin copy];
}

- (NSString *)middleName
{
    return _middleName;
}

- (void)setMiddleName:(NSString *)newMiddleName
{
    [self.dirtyPropertySet addObject:@"middleName"];

    if (!newMiddleName)
        _middleName = [NSNull null];
    else
        _middleName = [newMiddleName copy];
}

- (JRObjectLevelOne *)objectLevelOne
{
    return _objectLevelOne;
}

- (void)setObjectLevelOne:(JRObjectLevelOne *)newObjectLevelOne
{
    [self.dirtyPropertySet addObject:@"objectLevelOne"];

    if (!newObjectLevelOne)
        _objectLevelOne = [NSNull null];
    else
        _objectLevelOne = [newObjectLevelOne copy];
}

- (NSArray *)onipLevelOne
{
    return _onipLevelOne;
}

- (void)setOnipLevelOne:(NSArray *)newOnipLevelOne
{
    [self.dirtyPropertySet addObject:@"onipLevelOne"];

    if (!newOnipLevelOne)
        _onipLevelOne = [NSNull null];
    else
        _onipLevelOne = [newOnipLevelOne copy];
}

- (NSObject *)password
{
    return _password;
}

- (void)setPassword:(NSObject *)newPassword
{
    [self.dirtyPropertySet addObject:@"password"];

    if (!newPassword)
        _password = [NSNull null];
    else
        _password = [newPassword copy];
}

- (NSArray *)photos
{
    return _photos;
}

- (void)setPhotos:(NSArray *)newPhotos
{
    [self.dirtyPropertySet addObject:@"photos"];

    if (!newPhotos)
        _photos = [NSNull null];
    else
        _photos = [newPhotos copy];
}

- (JRPinoLevelOne *)pinoLevelOne
{
    return _pinoLevelOne;
}

- (void)setPinoLevelOne:(JRPinoLevelOne *)newPinoLevelOne
{
    [self.dirtyPropertySet addObject:@"pinoLevelOne"];

    if (!newPinoLevelOne)
        _pinoLevelOne = [NSNull null];
    else
        _pinoLevelOne = [newPinoLevelOne copy];
}

- (NSArray *)pluralLevelOne
{
    return _pluralLevelOne;
}

- (void)setPluralLevelOne:(NSArray *)newPluralLevelOne
{
    [self.dirtyPropertySet addObject:@"pluralLevelOne"];

    if (!newPluralLevelOne)
        _pluralLevelOne = [NSNull null];
    else
        _pluralLevelOne = [newPluralLevelOne copy];
}

- (JRPrimaryAddress *)primaryAddress
{
    return _primaryAddress;
}

- (void)setPrimaryAddress:(JRPrimaryAddress *)newPrimaryAddress
{
    [self.dirtyPropertySet addObject:@"primaryAddress"];

    if (!newPrimaryAddress)
        _primaryAddress = [NSNull null];
    else
        _primaryAddress = [newPrimaryAddress copy];
}

- (NSArray *)profiles
{
    return _profiles;
}

- (void)setProfiles:(NSArray *)newProfiles
{
    [self.dirtyPropertySet addObject:@"profiles"];

    if (!newProfiles)
        _profiles = [NSNull null];
    else
        _profiles = [newProfiles copy];
}

- (NSArray *)statuses
{
    return _statuses;
}

- (void)setStatuses:(NSArray *)newStatuses
{
    [self.dirtyPropertySet addObject:@"statuses"];

    if (!newStatuses)
        _statuses = [NSNull null];
    else
        _statuses = [newStatuses copy];
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

+ (id)captureUserWithEmail:(NSString *)email
{
    return [[[JRCaptureUser alloc] initWithEmail:email] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
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

    return captureUserCopy;
}

+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary
{
    JRCaptureUser *captureUser =
        [JRCaptureUser captureUserWithEmail:[dictionary objectForKey:@"email"]];

    captureUser.captureUserId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    captureUser.uuid = [dictionary objectForKey:@"uuid"];
    captureUser.created = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]];
    captureUser.lastUpdated = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]];
    captureUser.aboutMe = [dictionary objectForKey:@"aboutMe"];
    captureUser.birthday = [NSDate dateFromISO8601DateString:[dictionary objectForKey:@"birthday"]];
    captureUser.currentLocation = [dictionary objectForKey:@"currentLocation"];
    captureUser.display = [dictionary objectForKey:@"display"];
    captureUser.displayName = [dictionary objectForKey:@"displayName"];
    captureUser.emailVerified = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"emailVerified"]];
    captureUser.familyName = [dictionary objectForKey:@"familyName"];
    captureUser.games = [(NSArray*)[dictionary objectForKey:@"games"] arrayOfGamesObjectsFromGamesDictionaries];
    captureUser.gender = [dictionary objectForKey:@"gender"];
    captureUser.givenName = [dictionary objectForKey:@"givenName"];
    captureUser.lastLogin = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastLogin"]];
    captureUser.middleName = [dictionary objectForKey:@"middleName"];
    captureUser.objectLevelOne = [JRObjectLevelOne objectLevelOneObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"objectLevelOne"]];
    captureUser.onipLevelOne = [(NSArray*)[dictionary objectForKey:@"onipLevelOne"] arrayOfOnipLevelOneObjectsFromOnipLevelOneDictionaries];
    captureUser.password = [dictionary objectForKey:@"password"];
    captureUser.photos = [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfPhotosObjectsFromPhotosDictionaries];
    captureUser.pinoLevelOne = [JRPinoLevelOne pinoLevelOneObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"pinoLevelOne"]];
    captureUser.pluralLevelOne = [(NSArray*)[dictionary objectForKey:@"pluralLevelOne"] arrayOfPluralLevelOneObjectsFromPluralLevelOneDictionaries];
    captureUser.primaryAddress = [JRPrimaryAddress primaryAddressObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"primaryAddress"]];
    captureUser.profiles = [(NSArray*)[dictionary objectForKey:@"profiles"] arrayOfProfilesObjectsFromProfilesDictionaries];
    captureUser.statuses = [(NSArray*)[dictionary objectForKey:@"statuses"] arrayOfStatusesObjectsFromStatusesDictionaries];

    return captureUser;
}

- (NSDictionary*)dictionaryFromCaptureUserObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:self.email forKey:@"email"];

    if (self.captureUserId)
        [dict setObject:[NSNumber numberWithInt:self.captureUserId] forKey:@"id"];

    if (self.uuid && self.uuid != [NSNull null])
        [dict setObject:self.uuid forKey:@"uuid"];
    else
        [dict setObject:[NSNull null] forKey:@"uuid"];

    if (self.created && self.created != [NSNull null])
        [dict setObject:[self.created stringFromISO8601DateTime] forKey:@"created"];
    else
        [dict setObject:[NSNull null] forKey:@"created"];

    if (self.lastUpdated && self.lastUpdated != [NSNull null])
        [dict setObject:[self.lastUpdated stringFromISO8601DateTime] forKey:@"lastUpdated"];
    else
        [dict setObject:[NSNull null] forKey:@"lastUpdated"];

    if (self.aboutMe && self.aboutMe != [NSNull null])
        [dict setObject:self.aboutMe forKey:@"aboutMe"];
    else
        [dict setObject:[NSNull null] forKey:@"aboutMe"];

    if (self.birthday && self.birthday != [NSNull null])
        [dict setObject:[self.birthday stringFromISO8601Date] forKey:@"birthday"];
    else
        [dict setObject:[NSNull null] forKey:@"birthday"];

    if (self.currentLocation && self.currentLocation != [NSNull null])
        [dict setObject:self.currentLocation forKey:@"currentLocation"];
    else
        [dict setObject:[NSNull null] forKey:@"currentLocation"];

    if (self.display && self.display != [NSNull null])
        [dict setObject:self.display forKey:@"display"];
    else
        [dict setObject:[NSNull null] forKey:@"display"];

    if (self.displayName && self.displayName != [NSNull null])
        [dict setObject:self.displayName forKey:@"displayName"];
    else
        [dict setObject:[NSNull null] forKey:@"displayName"];

    if (self.emailVerified && self.emailVerified != [NSNull null])
        [dict setObject:[self.emailVerified stringFromISO8601DateTime] forKey:@"emailVerified"];
    else
        [dict setObject:[NSNull null] forKey:@"emailVerified"];

    if (self.familyName && self.familyName != [NSNull null])
        [dict setObject:self.familyName forKey:@"familyName"];
    else
        [dict setObject:[NSNull null] forKey:@"familyName"];

    if (self.games && self.games != [NSNull null])
        [dict setObject:[self.games arrayOfGamesDictionariesFromGamesObjects] forKey:@"games"];
    else
        [dict setObject:[NSNull null] forKey:@"games"];

    if (self.gender && self.gender != [NSNull null])
        [dict setObject:self.gender forKey:@"gender"];
    else
        [dict setObject:[NSNull null] forKey:@"gender"];

    if (self.givenName && self.givenName != [NSNull null])
        [dict setObject:self.givenName forKey:@"givenName"];
    else
        [dict setObject:[NSNull null] forKey:@"givenName"];

    if (self.lastLogin && self.lastLogin != [NSNull null])
        [dict setObject:[self.lastLogin stringFromISO8601DateTime] forKey:@"lastLogin"];
    else
        [dict setObject:[NSNull null] forKey:@"lastLogin"];

    if (self.middleName && self.middleName != [NSNull null])
        [dict setObject:self.middleName forKey:@"middleName"];
    else
        [dict setObject:[NSNull null] forKey:@"middleName"];

    if (self.objectLevelOne && self.objectLevelOne != [NSNull null])
        [dict setObject:[self.objectLevelOne dictionaryFromObjectLevelOneObject] forKey:@"objectLevelOne"];
    else
        [dict setObject:[NSNull null] forKey:@"objectLevelOne"];

    if (self.onipLevelOne && self.onipLevelOne != [NSNull null])
        [dict setObject:[self.onipLevelOne arrayOfOnipLevelOneDictionariesFromOnipLevelOneObjects] forKey:@"onipLevelOne"];
    else
        [dict setObject:[NSNull null] forKey:@"onipLevelOne"];

    if (self.password && self.password != [NSNull null])
        [dict setObject:self.password forKey:@"password"];
    else
        [dict setObject:[NSNull null] forKey:@"password"];

    if (self.photos && self.photos != [NSNull null])
        [dict setObject:[self.photos arrayOfPhotosDictionariesFromPhotosObjects] forKey:@"photos"];
    else
        [dict setObject:[NSNull null] forKey:@"photos"];

    if (self.pinoLevelOne && self.pinoLevelOne != [NSNull null])
        [dict setObject:[self.pinoLevelOne dictionaryFromPinoLevelOneObject] forKey:@"pinoLevelOne"];
    else
        [dict setObject:[NSNull null] forKey:@"pinoLevelOne"];

    if (self.pluralLevelOne && self.pluralLevelOne != [NSNull null])
        [dict setObject:[self.pluralLevelOne arrayOfPluralLevelOneDictionariesFromPluralLevelOneObjects] forKey:@"pluralLevelOne"];
    else
        [dict setObject:[NSNull null] forKey:@"pluralLevelOne"];

    if (self.primaryAddress && self.primaryAddress != [NSNull null])
        [dict setObject:[self.primaryAddress dictionaryFromPrimaryAddressObject] forKey:@"primaryAddress"];
    else
        [dict setObject:[NSNull null] forKey:@"primaryAddress"];

    if (self.profiles && self.profiles != [NSNull null])
        [dict setObject:[self.profiles arrayOfProfilesDictionariesFromProfilesObjects] forKey:@"profiles"];
    else
        [dict setObject:[NSNull null] forKey:@"profiles"];

    if (self.statuses && self.statuses != [NSNull null])
        [dict setObject:[self.statuses arrayOfStatusesDictionariesFromStatusesObjects] forKey:@"statuses"];
    else
        [dict setObject:[NSNull null] forKey:@"statuses"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"id"])
        _captureUserId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"uuid"])
        _uuid = [dictionary objectForKey:@"uuid"];

    if ([dictionary objectForKey:@"created"])
        _created = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]];

    if ([dictionary objectForKey:@"lastUpdated"])
        _lastUpdated = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]];

    if ([dictionary objectForKey:@"aboutMe"])
        _aboutMe = [dictionary objectForKey:@"aboutMe"];

    if ([dictionary objectForKey:@"birthday"])
        _birthday = [NSDate dateFromISO8601DateString:[dictionary objectForKey:@"birthday"]];

    if ([dictionary objectForKey:@"currentLocation"])
        _currentLocation = [dictionary objectForKey:@"currentLocation"];

    if ([dictionary objectForKey:@"display"])
        _display = [dictionary objectForKey:@"display"];

    if ([dictionary objectForKey:@"displayName"])
        _displayName = [dictionary objectForKey:@"displayName"];

    if ([dictionary objectForKey:@"email"])
        _email = [dictionary objectForKey:@"email"];

    if ([dictionary objectForKey:@"emailVerified"])
        _emailVerified = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"emailVerified"]];

    if ([dictionary objectForKey:@"familyName"])
        _familyName = [dictionary objectForKey:@"familyName"];

    if ([dictionary objectForKey:@"games"])
        _games = [(NSArray*)[dictionary objectForKey:@"games"] arrayOfGamesObjectsFromGamesDictionaries];

    if ([dictionary objectForKey:@"gender"])
        _gender = [dictionary objectForKey:@"gender"];

    if ([dictionary objectForKey:@"givenName"])
        _givenName = [dictionary objectForKey:@"givenName"];

    if ([dictionary objectForKey:@"lastLogin"])
        _lastLogin = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastLogin"]];

    if ([dictionary objectForKey:@"middleName"])
        _middleName = [dictionary objectForKey:@"middleName"];

    if ([dictionary objectForKey:@"objectLevelOne"])
        _objectLevelOne = [JRObjectLevelOne objectLevelOneObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"objectLevelOne"]];

    if ([dictionary objectForKey:@"onipLevelOne"])
        _onipLevelOne = [(NSArray*)[dictionary objectForKey:@"onipLevelOne"] arrayOfOnipLevelOneObjectsFromOnipLevelOneDictionaries];

    if ([dictionary objectForKey:@"password"])
        _password = [dictionary objectForKey:@"password"];

    if ([dictionary objectForKey:@"photos"])
        _photos = [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfPhotosObjectsFromPhotosDictionaries];

    if ([dictionary objectForKey:@"pinoLevelOne"])
        _pinoLevelOne = [JRPinoLevelOne pinoLevelOneObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"pinoLevelOne"]];

    if ([dictionary objectForKey:@"pluralLevelOne"])
        _pluralLevelOne = [(NSArray*)[dictionary objectForKey:@"pluralLevelOne"] arrayOfPluralLevelOneObjectsFromPluralLevelOneDictionaries];

    if ([dictionary objectForKey:@"primaryAddress"])
        _primaryAddress = [JRPrimaryAddress primaryAddressObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"primaryAddress"]];

    if ([dictionary objectForKey:@"profiles"])
        _profiles = [(NSArray*)[dictionary objectForKey:@"profiles"] arrayOfProfilesObjectsFromProfilesDictionaries];

    if ([dictionary objectForKey:@"statuses"])
        _statuses = [(NSArray*)[dictionary objectForKey:@"statuses"] arrayOfStatusesObjectsFromStatusesDictionaries];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    _captureUserId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    _uuid = [dictionary objectForKey:@"uuid"];
    _created = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]];
    _lastUpdated = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]];
    _aboutMe = [dictionary objectForKey:@"aboutMe"];
    _birthday = [NSDate dateFromISO8601DateString:[dictionary objectForKey:@"birthday"]];
    _currentLocation = [dictionary objectForKey:@"currentLocation"];
    _display = [dictionary objectForKey:@"display"];
    _displayName = [dictionary objectForKey:@"displayName"];
    _email = [dictionary objectForKey:@"email"];
    _emailVerified = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"emailVerified"]];
    _familyName = [dictionary objectForKey:@"familyName"];
    _games = [(NSArray*)[dictionary objectForKey:@"games"] arrayOfGamesObjectsFromGamesDictionaries];
    _gender = [dictionary objectForKey:@"gender"];
    _givenName = [dictionary objectForKey:@"givenName"];
    _lastLogin = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastLogin"]];
    _middleName = [dictionary objectForKey:@"middleName"];
    _objectLevelOne = [JRObjectLevelOne objectLevelOneObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"objectLevelOne"]];
    _onipLevelOne = [(NSArray*)[dictionary objectForKey:@"onipLevelOne"] arrayOfOnipLevelOneObjectsFromOnipLevelOneDictionaries];
    _password = [dictionary objectForKey:@"password"];
    _photos = [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfPhotosObjectsFromPhotosDictionaries];
    _pinoLevelOne = [JRPinoLevelOne pinoLevelOneObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"pinoLevelOne"]];
    _pluralLevelOne = [(NSArray*)[dictionary objectForKey:@"pluralLevelOne"] arrayOfPluralLevelOneObjectsFromPluralLevelOneDictionaries];
    _primaryAddress = [JRPrimaryAddress primaryAddressObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"primaryAddress"]];
    _profiles = [(NSArray*)[dictionary objectForKey:@"profiles"] arrayOfProfilesObjectsFromProfilesDictionaries];
    _statuses = [(NSArray*)[dictionary objectForKey:@"statuses"] arrayOfStatusesObjectsFromStatusesDictionaries];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"captureUserId"])
        [dict setObject:[NSNumber numberWithInt:self.captureUserId] forKey:@"id"];

    if ([self.dirtyPropertySet containsObject:@"uuid"])
        [dict setObject:self.uuid forKey:@"uuid"];

    if ([self.dirtyPropertySet containsObject:@"created"])
        [dict setObject:[self.created stringFromISO8601DateTime] forKey:@"created"];

    if ([self.dirtyPropertySet containsObject:@"lastUpdated"])
        [dict setObject:[self.lastUpdated stringFromISO8601DateTime] forKey:@"lastUpdated"];

    if ([self.dirtyPropertySet containsObject:@"aboutMe"])
        [dict setObject:self.aboutMe forKey:@"aboutMe"];

    if ([self.dirtyPropertySet containsObject:@"birthday"])
        [dict setObject:[self.birthday stringFromISO8601Date] forKey:@"birthday"];

    if ([self.dirtyPropertySet containsObject:@"currentLocation"])
        [dict setObject:self.currentLocation forKey:@"currentLocation"];

    if ([self.dirtyPropertySet containsObject:@"display"])
        [dict setObject:self.display forKey:@"display"];

    if ([self.dirtyPropertySet containsObject:@"displayName"])
        [dict setObject:self.displayName forKey:@"displayName"];

    if ([self.dirtyPropertySet containsObject:@"email"])
        [dict setObject:self.email forKey:@"email"];

    if ([self.dirtyPropertySet containsObject:@"emailVerified"])
        [dict setObject:[self.emailVerified stringFromISO8601DateTime] forKey:@"emailVerified"];

    if ([self.dirtyPropertySet containsObject:@"familyName"])
        [dict setObject:self.familyName forKey:@"familyName"];

    if ([self.dirtyPropertySet containsObject:@"games"])
        [dict setObject:[self.games arrayOfGamesDictionariesFromGamesObjects] forKey:@"games"];

    if ([self.dirtyPropertySet containsObject:@"gender"])
        [dict setObject:self.gender forKey:@"gender"];

    if ([self.dirtyPropertySet containsObject:@"givenName"])
        [dict setObject:self.givenName forKey:@"givenName"];

    if ([self.dirtyPropertySet containsObject:@"lastLogin"])
        [dict setObject:[self.lastLogin stringFromISO8601DateTime] forKey:@"lastLogin"];

    if ([self.dirtyPropertySet containsObject:@"middleName"])
        [dict setObject:self.middleName forKey:@"middleName"];

    if ([self.dirtyPropertySet containsObject:@"objectLevelOne"])
        [dict setObject:[self.objectLevelOne dictionaryFromObjectLevelOneObject] forKey:@"objectLevelOne"];

    if ([self.dirtyPropertySet containsObject:@"onipLevelOne"])
        [dict setObject:[self.onipLevelOne arrayOfOnipLevelOneDictionariesFromOnipLevelOneObjects] forKey:@"onipLevelOne"];

    if ([self.dirtyPropertySet containsObject:@"password"])
        [dict setObject:self.password forKey:@"password"];

    if ([self.dirtyPropertySet containsObject:@"photos"])
        [dict setObject:[self.photos arrayOfPhotosDictionariesFromPhotosObjects] forKey:@"photos"];

    if ([self.dirtyPropertySet containsObject:@"pinoLevelOne"])
        [dict setObject:[self.pinoLevelOne dictionaryFromPinoLevelOneObject] forKey:@"pinoLevelOne"];

    if ([self.dirtyPropertySet containsObject:@"pluralLevelOne"])
        [dict setObject:[self.pluralLevelOne arrayOfPluralLevelOneDictionariesFromPluralLevelOneObjects] forKey:@"pluralLevelOne"];

    if ([self.dirtyPropertySet containsObject:@"primaryAddress"])
        [dict setObject:[self.primaryAddress dictionaryFromPrimaryAddressObject] forKey:@"primaryAddress"];

    if ([self.dirtyPropertySet containsObject:@"profiles"])
        [dict setObject:[self.profiles arrayOfProfilesDictionariesFromProfilesObjects] forKey:@"profiles"];

    if ([self.dirtyPropertySet containsObject:@"statuses"])
        [dict setObject:[self.statuses arrayOfStatusesDictionariesFromStatusesObjects] forKey:@"statuses"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:dict
                                     withId:0
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:[NSNumber numberWithInt:self.captureUserId] forKey:@"id"];
    [dict setObject:self.uuid forKey:@"uuid"];
    [dict setObject:[self.created stringFromISO8601DateTime] forKey:@"created"];
    [dict setObject:[self.lastUpdated stringFromISO8601DateTime] forKey:@"lastUpdated"];
    [dict setObject:self.aboutMe forKey:@"aboutMe"];
    [dict setObject:[self.birthday stringFromISO8601Date] forKey:@"birthday"];
    [dict setObject:self.currentLocation forKey:@"currentLocation"];
    [dict setObject:self.display forKey:@"display"];
    [dict setObject:self.displayName forKey:@"displayName"];
    [dict setObject:self.email forKey:@"email"];
    [dict setObject:[self.emailVerified stringFromISO8601DateTime] forKey:@"emailVerified"];
    [dict setObject:self.familyName forKey:@"familyName"];
    [dict setObject:[self.games arrayOfGamesDictionariesFromGamesObjects] forKey:@"games"];
    [dict setObject:self.gender forKey:@"gender"];
    [dict setObject:self.givenName forKey:@"givenName"];
    [dict setObject:[self.lastLogin stringFromISO8601DateTime] forKey:@"lastLogin"];
    [dict setObject:self.middleName forKey:@"middleName"];
    [dict setObject:[self.objectLevelOne dictionaryFromObjectLevelOneObject] forKey:@"objectLevelOne"];
    [dict setObject:[self.onipLevelOne arrayOfOnipLevelOneDictionariesFromOnipLevelOneObjects] forKey:@"onipLevelOne"];
    [dict setObject:self.password forKey:@"password"];
    [dict setObject:[self.photos arrayOfPhotosDictionariesFromPhotosObjects] forKey:@"photos"];
    [dict setObject:[self.pinoLevelOne dictionaryFromPinoLevelOneObject] forKey:@"pinoLevelOne"];
    [dict setObject:[self.pluralLevelOne arrayOfPluralLevelOneDictionariesFromPluralLevelOneObjects] forKey:@"pluralLevelOne"];
    [dict setObject:[self.primaryAddress dictionaryFromPrimaryAddressObject] forKey:@"primaryAddress"];
    [dict setObject:[self.profiles arrayOfProfilesDictionariesFromProfilesObjects] forKey:@"profiles"];
    [dict setObject:[self.statuses arrayOfStatusesDictionariesFromStatusesObjects] forKey:@"statuses"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:dict
                                      withId:0
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
