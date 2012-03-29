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


#import "JRProfile.h"

@interface NSArray (AccountsToFromDictionary)
- (NSArray*)arrayOfAccountsObjectsFromAccountsDictionaries;
- (NSArray*)arrayOfAccountsDictionariesFromAccountsObjects;
- (NSArray*)arrayOfAccountsUpdateDictionariesFromAccountsObjects;
- (NSArray*)arrayOfAccountsReplaceDictionariesFromAccountsObjects;
@end

@implementation NSArray (AccountsToFromDictionary)
- (NSArray*)arrayOfAccountsObjectsFromAccountsDictionaries
{
    NSMutableArray *filteredAccountsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredAccountsArray addObject:[JRAccounts accountsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredAccountsArray;
}

- (NSArray*)arrayOfAccountsDictionariesFromAccountsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRAccounts class]])
            [filteredDictionaryArray addObject:[(JRAccounts*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfAccountsUpdateDictionariesFromAccountsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRAccounts class]])
            [filteredDictionaryArray addObject:[(JRAccounts*)object toUpdateDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfAccountsReplaceDictionariesFromAccountsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRAccounts class]])
            [filteredDictionaryArray addObject:[(JRAccounts*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (AddressesToFromDictionary)
- (NSArray*)arrayOfAddressesObjectsFromAddressesDictionaries;
- (NSArray*)arrayOfAddressesDictionariesFromAddressesObjects;
- (NSArray*)arrayOfAddressesUpdateDictionariesFromAddressesObjects;
- (NSArray*)arrayOfAddressesReplaceDictionariesFromAddressesObjects;
@end

@implementation NSArray (AddressesToFromDictionary)
- (NSArray*)arrayOfAddressesObjectsFromAddressesDictionaries
{
    NSMutableArray *filteredAddressesArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredAddressesArray addObject:[JRAddresses addressesObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredAddressesArray;
}

- (NSArray*)arrayOfAddressesDictionariesFromAddressesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRAddresses class]])
            [filteredDictionaryArray addObject:[(JRAddresses*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfAddressesUpdateDictionariesFromAddressesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRAddresses class]])
            [filteredDictionaryArray addObject:[(JRAddresses*)object toUpdateDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfAddressesReplaceDictionariesFromAddressesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRAddresses class]])
            [filteredDictionaryArray addObject:[(JRAddresses*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (EmailsToFromDictionary)
- (NSArray*)arrayOfEmailsObjectsFromEmailsDictionaries;
- (NSArray*)arrayOfEmailsDictionariesFromEmailsObjects;
- (NSArray*)arrayOfEmailsUpdateDictionariesFromEmailsObjects;
- (NSArray*)arrayOfEmailsReplaceDictionariesFromEmailsObjects;
@end

@implementation NSArray (EmailsToFromDictionary)
- (NSArray*)arrayOfEmailsObjectsFromEmailsDictionaries
{
    NSMutableArray *filteredEmailsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredEmailsArray addObject:[JREmails emailsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredEmailsArray;
}

- (NSArray*)arrayOfEmailsDictionariesFromEmailsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JREmails class]])
            [filteredDictionaryArray addObject:[(JREmails*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfEmailsUpdateDictionariesFromEmailsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JREmails class]])
            [filteredDictionaryArray addObject:[(JREmails*)object toUpdateDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfEmailsReplaceDictionariesFromEmailsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JREmails class]])
            [filteredDictionaryArray addObject:[(JREmails*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (ImsToFromDictionary)
- (NSArray*)arrayOfImsObjectsFromImsDictionaries;
- (NSArray*)arrayOfImsDictionariesFromImsObjects;
- (NSArray*)arrayOfImsUpdateDictionariesFromImsObjects;
- (NSArray*)arrayOfImsReplaceDictionariesFromImsObjects;
@end

@implementation NSArray (ImsToFromDictionary)
- (NSArray*)arrayOfImsObjectsFromImsDictionaries
{
    NSMutableArray *filteredImsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredImsArray addObject:[JRIms imsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredImsArray;
}

- (NSArray*)arrayOfImsDictionariesFromImsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRIms class]])
            [filteredDictionaryArray addObject:[(JRIms*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfImsUpdateDictionariesFromImsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRIms class]])
            [filteredDictionaryArray addObject:[(JRIms*)object toUpdateDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfImsReplaceDictionariesFromImsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRIms class]])
            [filteredDictionaryArray addObject:[(JRIms*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (OrganizationsToFromDictionary)
- (NSArray*)arrayOfOrganizationsObjectsFromOrganizationsDictionaries;
- (NSArray*)arrayOfOrganizationsDictionariesFromOrganizationsObjects;
- (NSArray*)arrayOfOrganizationsUpdateDictionariesFromOrganizationsObjects;
- (NSArray*)arrayOfOrganizationsReplaceDictionariesFromOrganizationsObjects;
@end

@implementation NSArray (OrganizationsToFromDictionary)
- (NSArray*)arrayOfOrganizationsObjectsFromOrganizationsDictionaries
{
    NSMutableArray *filteredOrganizationsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredOrganizationsArray addObject:[JROrganizations organizationsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredOrganizationsArray;
}

- (NSArray*)arrayOfOrganizationsDictionariesFromOrganizationsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROrganizations class]])
            [filteredDictionaryArray addObject:[(JROrganizations*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfOrganizationsUpdateDictionariesFromOrganizationsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROrganizations class]])
            [filteredDictionaryArray addObject:[(JROrganizations*)object toUpdateDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfOrganizationsReplaceDictionariesFromOrganizationsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROrganizations class]])
            [filteredDictionaryArray addObject:[(JROrganizations*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PhoneNumbersToFromDictionary)
- (NSArray*)arrayOfPhoneNumbersObjectsFromPhoneNumbersDictionaries;
- (NSArray*)arrayOfPhoneNumbersDictionariesFromPhoneNumbersObjects;
- (NSArray*)arrayOfPhoneNumbersUpdateDictionariesFromPhoneNumbersObjects;
- (NSArray*)arrayOfPhoneNumbersReplaceDictionariesFromPhoneNumbersObjects;
@end

@implementation NSArray (PhoneNumbersToFromDictionary)
- (NSArray*)arrayOfPhoneNumbersObjectsFromPhoneNumbersDictionaries
{
    NSMutableArray *filteredPhoneNumbersArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPhoneNumbersArray addObject:[JRPhoneNumbers phoneNumbersObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredPhoneNumbersArray;
}

- (NSArray*)arrayOfPhoneNumbersDictionariesFromPhoneNumbersObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhoneNumbers class]])
            [filteredDictionaryArray addObject:[(JRPhoneNumbers*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPhoneNumbersUpdateDictionariesFromPhoneNumbersObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhoneNumbers class]])
            [filteredDictionaryArray addObject:[(JRPhoneNumbers*)object toUpdateDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPhoneNumbersReplaceDictionariesFromPhoneNumbersObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhoneNumbers class]])
            [filteredDictionaryArray addObject:[(JRPhoneNumbers*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (ProfilePhotosToFromDictionary)
- (NSArray*)arrayOfProfilePhotosObjectsFromProfilePhotosDictionaries;
- (NSArray*)arrayOfProfilePhotosDictionariesFromProfilePhotosObjects;
- (NSArray*)arrayOfProfilePhotosUpdateDictionariesFromProfilePhotosObjects;
- (NSArray*)arrayOfProfilePhotosReplaceDictionariesFromProfilePhotosObjects;
@end

@implementation NSArray (ProfilePhotosToFromDictionary)
- (NSArray*)arrayOfProfilePhotosObjectsFromProfilePhotosDictionaries
{
    NSMutableArray *filteredProfilePhotosArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredProfilePhotosArray addObject:[JRProfilePhotos profilePhotosObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredProfilePhotosArray;
}

- (NSArray*)arrayOfProfilePhotosDictionariesFromProfilePhotosObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfilePhotos class]])
            [filteredDictionaryArray addObject:[(JRProfilePhotos*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfProfilePhotosUpdateDictionariesFromProfilePhotosObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfilePhotos class]])
            [filteredDictionaryArray addObject:[(JRProfilePhotos*)object toUpdateDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfProfilePhotosReplaceDictionariesFromProfilePhotosObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfilePhotos class]])
            [filteredDictionaryArray addObject:[(JRProfilePhotos*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (UrlsToFromDictionary)
- (NSArray*)arrayOfUrlsObjectsFromUrlsDictionaries;
- (NSArray*)arrayOfUrlsDictionariesFromUrlsObjects;
- (NSArray*)arrayOfUrlsUpdateDictionariesFromUrlsObjects;
- (NSArray*)arrayOfUrlsReplaceDictionariesFromUrlsObjects;
@end

@implementation NSArray (UrlsToFromDictionary)
- (NSArray*)arrayOfUrlsObjectsFromUrlsDictionaries
{
    NSMutableArray *filteredUrlsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredUrlsArray addObject:[JRUrls urlsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredUrlsArray;
}

- (NSArray*)arrayOfUrlsDictionariesFromUrlsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRUrls class]])
            [filteredDictionaryArray addObject:[(JRUrls*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfUrlsUpdateDictionariesFromUrlsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRUrls class]])
            [filteredDictionaryArray addObject:[(JRUrls*)object toUpdateDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfUrlsReplaceDictionariesFromUrlsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRUrls class]])
            [filteredDictionaryArray addObject:[(JRUrls*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation JRProfile
{
    NSString *_aboutMe;
    NSArray *_accounts;
    NSArray *_addresses;
    NSDate *_anniversary;
    NSString *_birthday;
    JRBodyType *_bodyType;
    NSArray *_books;
    NSArray *_cars;
    NSArray *_children;
    JRCurrentLocation *_currentLocation;
    NSString *_displayName;
    NSString *_drinker;
    NSArray *_emails;
    NSString *_ethnicity;
    NSString *_fashion;
    NSArray *_food;
    NSString *_gender;
    NSString *_happiestWhen;
    NSArray *_heroes;
    NSString *_humor;
    NSArray *_ims;
    NSString *_interestedInMeeting;
    NSArray *_interests;
    NSArray *_jobInterests;
    NSArray *_languages;
    NSArray *_languagesSpoken;
    NSString *_livingArrangement;
    NSArray *_lookingFor;
    NSArray *_movies;
    NSArray *_music;
    JRName *_name;
    NSString *_nickname;
    NSString *_note;
    NSArray *_organizations;
    NSArray *_pets;
    NSArray *_phoneNumbers;
    NSArray *_profilePhotos;
    NSString *_politicalViews;
    NSString *_preferredUsername;
    NSString *_profileSong;
    NSString *_profileUrl;
    NSString *_profileVideo;
    NSDate *_published;
    NSArray *_quotes;
    NSString *_relationshipStatus;
    NSArray *_relationships;
    NSString *_religion;
    NSString *_romance;
    NSString *_scaredOf;
    NSString *_sexualOrientation;
    NSString *_smoker;
    NSArray *_sports;
    NSString *_status;
    NSArray *_tags;
    NSArray *_turnOffs;
    NSArray *_turnOns;
    NSArray *_tvShows;
    NSDate *_updated;
    NSArray *_urls;
    NSString *_utcOffset;
}
@dynamic aboutMe;
@dynamic accounts;
@dynamic addresses;
@dynamic anniversary;
@dynamic birthday;
@dynamic bodyType;
@dynamic books;
@dynamic cars;
@dynamic children;
@dynamic currentLocation;
@dynamic displayName;
@dynamic drinker;
@dynamic emails;
@dynamic ethnicity;
@dynamic fashion;
@dynamic food;
@dynamic gender;
@dynamic happiestWhen;
@dynamic heroes;
@dynamic humor;
@dynamic ims;
@dynamic interestedInMeeting;
@dynamic interests;
@dynamic jobInterests;
@dynamic languages;
@dynamic languagesSpoken;
@dynamic livingArrangement;
@dynamic lookingFor;
@dynamic movies;
@dynamic music;
@dynamic name;
@dynamic nickname;
@dynamic note;
@dynamic organizations;
@dynamic pets;
@dynamic phoneNumbers;
@dynamic profilePhotos;
@dynamic politicalViews;
@dynamic preferredUsername;
@dynamic profileSong;
@dynamic profileUrl;
@dynamic profileVideo;
@dynamic published;
@dynamic quotes;
@dynamic relationshipStatus;
@dynamic relationships;
@dynamic religion;
@dynamic romance;
@dynamic scaredOf;
@dynamic sexualOrientation;
@dynamic smoker;
@dynamic sports;
@dynamic status;
@dynamic tags;
@dynamic turnOffs;
@dynamic turnOns;
@dynamic tvShows;
@dynamic updated;
@dynamic urls;
@dynamic utcOffset;

- (NSString *)aboutMe
{
    return _aboutMe;
}

- (void)setAboutMe:(NSString *)newAboutMe
{
    [self.dirtyPropertySet addObject:@"aboutMe"];
    _aboutMe = [newAboutMe copy];
}

- (NSArray *)accounts
{
    return _accounts;
}

- (void)setAccounts:(NSArray *)newAccounts
{
    [self.dirtyPropertySet addObject:@"accounts"];
    _accounts = [newAccounts copy];
}

- (NSArray *)addresses
{
    return _addresses;
}

- (void)setAddresses:(NSArray *)newAddresses
{
    [self.dirtyPropertySet addObject:@"addresses"];
    _addresses = [newAddresses copy];
}

- (NSDate *)anniversary
{
    return _anniversary;
}

- (void)setAnniversary:(NSDate *)newAnniversary
{
    [self.dirtyPropertySet addObject:@"anniversary"];
    _anniversary = [newAnniversary copy];
}

- (NSString *)birthday
{
    return _birthday;
}

- (void)setBirthday:(NSString *)newBirthday
{
    [self.dirtyPropertySet addObject:@"birthday"];
    _birthday = [newBirthday copy];
}

- (JRBodyType *)bodyType
{
    return _bodyType;
}

- (void)setBodyType:(JRBodyType *)newBodyType
{
    [self.dirtyPropertySet addObject:@"bodyType"];
    _bodyType = [newBodyType copy];
}

- (NSArray *)books
{
    return _books;
}

- (void)setBooks:(NSArray *)newBooks
{
    [self.dirtyPropertySet addObject:@"books"];
    _books = [newBooks copyArrayOfStringPluralElementsWithType:@"book"];
}

- (NSArray *)cars
{
    return _cars;
}

- (void)setCars:(NSArray *)newCars
{
    [self.dirtyPropertySet addObject:@"cars"];
    _cars = [newCars copyArrayOfStringPluralElementsWithType:@"car"];
}

- (NSArray *)children
{
    return _children;
}

- (void)setChildren:(NSArray *)newChildren
{
    [self.dirtyPropertySet addObject:@"children"];
    _children = [newChildren copyArrayOfStringPluralElementsWithType:@"value"];
}

- (JRCurrentLocation *)currentLocation
{
    return _currentLocation;
}

- (void)setCurrentLocation:(JRCurrentLocation *)newCurrentLocation
{
    [self.dirtyPropertySet addObject:@"currentLocation"];
    _currentLocation = [newCurrentLocation copy];
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

- (NSString *)drinker
{
    return _drinker;
}

- (void)setDrinker:(NSString *)newDrinker
{
    [self.dirtyPropertySet addObject:@"drinker"];
    _drinker = [newDrinker copy];
}

- (NSArray *)emails
{
    return _emails;
}

- (void)setEmails:(NSArray *)newEmails
{
    [self.dirtyPropertySet addObject:@"emails"];
    _emails = [newEmails copy];
}

- (NSString *)ethnicity
{
    return _ethnicity;
}

- (void)setEthnicity:(NSString *)newEthnicity
{
    [self.dirtyPropertySet addObject:@"ethnicity"];
    _ethnicity = [newEthnicity copy];
}

- (NSString *)fashion
{
    return _fashion;
}

- (void)setFashion:(NSString *)newFashion
{
    [self.dirtyPropertySet addObject:@"fashion"];
    _fashion = [newFashion copy];
}

- (NSArray *)food
{
    return _food;
}

- (void)setFood:(NSArray *)newFood
{
    [self.dirtyPropertySet addObject:@"food"];
    _food = [newFood copyArrayOfStringPluralElementsWithType:@"food"];
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

- (NSString *)happiestWhen
{
    return _happiestWhen;
}

- (void)setHappiestWhen:(NSString *)newHappiestWhen
{
    [self.dirtyPropertySet addObject:@"happiestWhen"];
    _happiestWhen = [newHappiestWhen copy];
}

- (NSArray *)heroes
{
    return _heroes;
}

- (void)setHeroes:(NSArray *)newHeroes
{
    [self.dirtyPropertySet addObject:@"heroes"];
    _heroes = [newHeroes copyArrayOfStringPluralElementsWithType:@"hero"];
}

- (NSString *)humor
{
    return _humor;
}

- (void)setHumor:(NSString *)newHumor
{
    [self.dirtyPropertySet addObject:@"humor"];
    _humor = [newHumor copy];
}

- (NSArray *)ims
{
    return _ims;
}

- (void)setIms:(NSArray *)newIms
{
    [self.dirtyPropertySet addObject:@"ims"];
    _ims = [newIms copy];
}

- (NSString *)interestedInMeeting
{
    return _interestedInMeeting;
}

- (void)setInterestedInMeeting:(NSString *)newInterestedInMeeting
{
    [self.dirtyPropertySet addObject:@"interestedInMeeting"];
    _interestedInMeeting = [newInterestedInMeeting copy];
}

- (NSArray *)interests
{
    return _interests;
}

- (void)setInterests:(NSArray *)newInterests
{
    [self.dirtyPropertySet addObject:@"interests"];
    _interests = [newInterests copyArrayOfStringPluralElementsWithType:@"interest"];
}

- (NSArray *)jobInterests
{
    return _jobInterests;
}

- (void)setJobInterests:(NSArray *)newJobInterests
{
    [self.dirtyPropertySet addObject:@"jobInterests"];
    _jobInterests = [newJobInterests copyArrayOfStringPluralElementsWithType:@"jobInterest"];
}

- (NSArray *)languages
{
    return _languages;
}

- (void)setLanguages:(NSArray *)newLanguages
{
    [self.dirtyPropertySet addObject:@"languages"];
    _languages = [newLanguages copyArrayOfStringPluralElementsWithType:@"language"];
}

- (NSArray *)languagesSpoken
{
    return _languagesSpoken;
}

- (void)setLanguagesSpoken:(NSArray *)newLanguagesSpoken
{
    [self.dirtyPropertySet addObject:@"languagesSpoken"];
    _languagesSpoken = [newLanguagesSpoken copyArrayOfStringPluralElementsWithType:@"languageSpoken"];
}

- (NSString *)livingArrangement
{
    return _livingArrangement;
}

- (void)setLivingArrangement:(NSString *)newLivingArrangement
{
    [self.dirtyPropertySet addObject:@"livingArrangement"];
    _livingArrangement = [newLivingArrangement copy];
}

- (NSArray *)lookingFor
{
    return _lookingFor;
}

- (void)setLookingFor:(NSArray *)newLookingFor
{
    [self.dirtyPropertySet addObject:@"lookingFor"];
    _lookingFor = [newLookingFor copyArrayOfStringPluralElementsWithType:@"value"];
}

- (NSArray *)movies
{
    return _movies;
}

- (void)setMovies:(NSArray *)newMovies
{
    [self.dirtyPropertySet addObject:@"movies"];
    _movies = [newMovies copyArrayOfStringPluralElementsWithType:@"movie"];
}

- (NSArray *)music
{
    return _music;
}

- (void)setMusic:(NSArray *)newMusic
{
    [self.dirtyPropertySet addObject:@"music"];
    _music = [newMusic copyArrayOfStringPluralElementsWithType:@"music"];
}

- (JRName *)name
{
    return _name;
}

- (void)setName:(JRName *)newName
{
    [self.dirtyPropertySet addObject:@"name"];
    _name = [newName copy];
}

- (NSString *)nickname
{
    return _nickname;
}

- (void)setNickname:(NSString *)newNickname
{
    [self.dirtyPropertySet addObject:@"nickname"];
    _nickname = [newNickname copy];
}

- (NSString *)note
{
    return _note;
}

- (void)setNote:(NSString *)newNote
{
    [self.dirtyPropertySet addObject:@"note"];
    _note = [newNote copy];
}

- (NSArray *)organizations
{
    return _organizations;
}

- (void)setOrganizations:(NSArray *)newOrganizations
{
    [self.dirtyPropertySet addObject:@"organizations"];
    _organizations = [newOrganizations copy];
}

- (NSArray *)pets
{
    return _pets;
}

- (void)setPets:(NSArray *)newPets
{
    [self.dirtyPropertySet addObject:@"pets"];
    _pets = [newPets copyArrayOfStringPluralElementsWithType:@"value"];
}

- (NSArray *)phoneNumbers
{
    return _phoneNumbers;
}

- (void)setPhoneNumbers:(NSArray *)newPhoneNumbers
{
    [self.dirtyPropertySet addObject:@"phoneNumbers"];
    _phoneNumbers = [newPhoneNumbers copy];
}

- (NSArray *)profilePhotos
{
    return _profilePhotos;
}

- (void)setProfilePhotos:(NSArray *)newProfilePhotos
{
    [self.dirtyPropertySet addObject:@"profilePhotos"];
    _profilePhotos = [newProfilePhotos copy];
}

- (NSString *)politicalViews
{
    return _politicalViews;
}

- (void)setPoliticalViews:(NSString *)newPoliticalViews
{
    [self.dirtyPropertySet addObject:@"politicalViews"];
    _politicalViews = [newPoliticalViews copy];
}

- (NSString *)preferredUsername
{
    return _preferredUsername;
}

- (void)setPreferredUsername:(NSString *)newPreferredUsername
{
    [self.dirtyPropertySet addObject:@"preferredUsername"];
    _preferredUsername = [newPreferredUsername copy];
}

- (NSString *)profileSong
{
    return _profileSong;
}

- (void)setProfileSong:(NSString *)newProfileSong
{
    [self.dirtyPropertySet addObject:@"profileSong"];
    _profileSong = [newProfileSong copy];
}

- (NSString *)profileUrl
{
    return _profileUrl;
}

- (void)setProfileUrl:(NSString *)newProfileUrl
{
    [self.dirtyPropertySet addObject:@"profileUrl"];
    _profileUrl = [newProfileUrl copy];
}

- (NSString *)profileVideo
{
    return _profileVideo;
}

- (void)setProfileVideo:(NSString *)newProfileVideo
{
    [self.dirtyPropertySet addObject:@"profileVideo"];
    _profileVideo = [newProfileVideo copy];
}

- (NSDate *)published
{
    return _published;
}

- (void)setPublished:(NSDate *)newPublished
{
    [self.dirtyPropertySet addObject:@"published"];
    _published = [newPublished copy];
}

- (NSArray *)quotes
{
    return _quotes;
}

- (void)setQuotes:(NSArray *)newQuotes
{
    [self.dirtyPropertySet addObject:@"quotes"];
    _quotes = [newQuotes copyArrayOfStringPluralElementsWithType:@"quote"];
}

- (NSString *)relationshipStatus
{
    return _relationshipStatus;
}

- (void)setRelationshipStatus:(NSString *)newRelationshipStatus
{
    [self.dirtyPropertySet addObject:@"relationshipStatus"];
    _relationshipStatus = [newRelationshipStatus copy];
}

- (NSArray *)relationships
{
    return _relationships;
}

- (void)setRelationships:(NSArray *)newRelationships
{
    [self.dirtyPropertySet addObject:@"relationships"];
    _relationships = [newRelationships copyArrayOfStringPluralElementsWithType:@"relationship"];
}

- (NSString *)religion
{
    return _religion;
}

- (void)setReligion:(NSString *)newReligion
{
    [self.dirtyPropertySet addObject:@"religion"];
    _religion = [newReligion copy];
}

- (NSString *)romance
{
    return _romance;
}

- (void)setRomance:(NSString *)newRomance
{
    [self.dirtyPropertySet addObject:@"romance"];
    _romance = [newRomance copy];
}

- (NSString *)scaredOf
{
    return _scaredOf;
}

- (void)setScaredOf:(NSString *)newScaredOf
{
    [self.dirtyPropertySet addObject:@"scaredOf"];
    _scaredOf = [newScaredOf copy];
}

- (NSString *)sexualOrientation
{
    return _sexualOrientation;
}

- (void)setSexualOrientation:(NSString *)newSexualOrientation
{
    [self.dirtyPropertySet addObject:@"sexualOrientation"];
    _sexualOrientation = [newSexualOrientation copy];
}

- (NSString *)smoker
{
    return _smoker;
}

- (void)setSmoker:(NSString *)newSmoker
{
    [self.dirtyPropertySet addObject:@"smoker"];
    _smoker = [newSmoker copy];
}

- (NSArray *)sports
{
    return _sports;
}

- (void)setSports:(NSArray *)newSports
{
    [self.dirtyPropertySet addObject:@"sports"];
    _sports = [newSports copyArrayOfStringPluralElementsWithType:@"sport"];
}

- (NSString *)status
{
    return _status;
}

- (void)setStatus:(NSString *)newStatus
{
    [self.dirtyPropertySet addObject:@"status"];
    _status = [newStatus copy];
}

- (NSArray *)tags
{
    return _tags;
}

- (void)setTags:(NSArray *)newTags
{
    [self.dirtyPropertySet addObject:@"tags"];
    _tags = [newTags copyArrayOfStringPluralElementsWithType:@"tag"];
}

- (NSArray *)turnOffs
{
    return _turnOffs;
}

- (void)setTurnOffs:(NSArray *)newTurnOffs
{
    [self.dirtyPropertySet addObject:@"turnOffs"];
    _turnOffs = [newTurnOffs copyArrayOfStringPluralElementsWithType:@"turnOff"];
}

- (NSArray *)turnOns
{
    return _turnOns;
}

- (void)setTurnOns:(NSArray *)newTurnOns
{
    [self.dirtyPropertySet addObject:@"turnOns"];
    _turnOns = [newTurnOns copyArrayOfStringPluralElementsWithType:@"turnOn"];
}

- (NSArray *)tvShows
{
    return _tvShows;
}

- (void)setTvShows:(NSArray *)newTvShows
{
    [self.dirtyPropertySet addObject:@"tvShows"];
    _tvShows = [newTvShows copyArrayOfStringPluralElementsWithType:@"tvShow"];
}

- (NSDate *)updated
{
    return _updated;
}

- (void)setUpdated:(NSDate *)newUpdated
{
    [self.dirtyPropertySet addObject:@"updated"];
    _updated = [newUpdated copy];
}

- (NSArray *)urls
{
    return _urls;
}

- (void)setUrls:(NSArray *)newUrls
{
    [self.dirtyPropertySet addObject:@"urls"];
    _urls = [newUrls copy];
}

- (NSString *)utcOffset
{
    return _utcOffset;
}

- (void)setUtcOffset:(NSString *)newUtcOffset
{
    [self.dirtyPropertySet addObject:@"utcOffset"];
    _utcOffset = [newUtcOffset copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile";
    }
    return self;
}

+ (id)profile
{
    return [[[JRProfile alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRProfile *profileCopy =
                [[JRProfile allocWithZone:zone] init];

    profileCopy.aboutMe = self.aboutMe;
    profileCopy.accounts = self.accounts;
    profileCopy.addresses = self.addresses;
    profileCopy.anniversary = self.anniversary;
    profileCopy.birthday = self.birthday;
    profileCopy.bodyType = self.bodyType;
    profileCopy.books = self.books;
    profileCopy.cars = self.cars;
    profileCopy.children = self.children;
    profileCopy.currentLocation = self.currentLocation;
    profileCopy.displayName = self.displayName;
    profileCopy.drinker = self.drinker;
    profileCopy.emails = self.emails;
    profileCopy.ethnicity = self.ethnicity;
    profileCopy.fashion = self.fashion;
    profileCopy.food = self.food;
    profileCopy.gender = self.gender;
    profileCopy.happiestWhen = self.happiestWhen;
    profileCopy.heroes = self.heroes;
    profileCopy.humor = self.humor;
    profileCopy.ims = self.ims;
    profileCopy.interestedInMeeting = self.interestedInMeeting;
    profileCopy.interests = self.interests;
    profileCopy.jobInterests = self.jobInterests;
    profileCopy.languages = self.languages;
    profileCopy.languagesSpoken = self.languagesSpoken;
    profileCopy.livingArrangement = self.livingArrangement;
    profileCopy.lookingFor = self.lookingFor;
    profileCopy.movies = self.movies;
    profileCopy.music = self.music;
    profileCopy.name = self.name;
    profileCopy.nickname = self.nickname;
    profileCopy.note = self.note;
    profileCopy.organizations = self.organizations;
    profileCopy.pets = self.pets;
    profileCopy.phoneNumbers = self.phoneNumbers;
    profileCopy.profilePhotos = self.profilePhotos;
    profileCopy.politicalViews = self.politicalViews;
    profileCopy.preferredUsername = self.preferredUsername;
    profileCopy.profileSong = self.profileSong;
    profileCopy.profileUrl = self.profileUrl;
    profileCopy.profileVideo = self.profileVideo;
    profileCopy.published = self.published;
    profileCopy.quotes = self.quotes;
    profileCopy.relationshipStatus = self.relationshipStatus;
    profileCopy.relationships = self.relationships;
    profileCopy.religion = self.religion;
    profileCopy.romance = self.romance;
    profileCopy.scaredOf = self.scaredOf;
    profileCopy.sexualOrientation = self.sexualOrientation;
    profileCopy.smoker = self.smoker;
    profileCopy.sports = self.sports;
    profileCopy.status = self.status;
    profileCopy.tags = self.tags;
    profileCopy.turnOffs = self.turnOffs;
    profileCopy.turnOns = self.turnOns;
    profileCopy.tvShows = self.tvShows;
    profileCopy.updated = self.updated;
    profileCopy.urls = self.urls;
    profileCopy.utcOffset = self.utcOffset;

    [profileCopy.dirtyPropertySet removeAllObjects];
    [profileCopy.dirtyPropertySet setSet:self.dirtyPropertySet];

    return profileCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.aboutMe ? self.aboutMe : [NSNull null])
             forKey:@"aboutMe"];
    [dict setObject:(self.accounts ? [self.accounts arrayOfAccountsDictionariesFromAccountsObjects] : [NSNull null])
             forKey:@"accounts"];
    [dict setObject:(self.addresses ? [self.addresses arrayOfAddressesDictionariesFromAddressesObjects] : [NSNull null])
             forKey:@"addresses"];
    [dict setObject:(self.anniversary ? [self.anniversary stringFromISO8601Date] : [NSNull null])
             forKey:@"anniversary"];
    [dict setObject:(self.birthday ? self.birthday : [NSNull null])
             forKey:@"birthday"];
    [dict setObject:(self.bodyType ? [self.bodyType toDictionary] : [NSNull null])
             forKey:@"bodyType"];
    [dict setObject:(self.books ? [self.books arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"books"];
    [dict setObject:(self.cars ? [self.cars arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"cars"];
    [dict setObject:(self.children ? [self.children arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"children"];
    [dict setObject:(self.currentLocation ? [self.currentLocation toDictionary] : [NSNull null])
             forKey:@"currentLocation"];
    [dict setObject:(self.displayName ? self.displayName : [NSNull null])
             forKey:@"displayName"];
    [dict setObject:(self.drinker ? self.drinker : [NSNull null])
             forKey:@"drinker"];
    [dict setObject:(self.emails ? [self.emails arrayOfEmailsDictionariesFromEmailsObjects] : [NSNull null])
             forKey:@"emails"];
    [dict setObject:(self.ethnicity ? self.ethnicity : [NSNull null])
             forKey:@"ethnicity"];
    [dict setObject:(self.fashion ? self.fashion : [NSNull null])
             forKey:@"fashion"];
    [dict setObject:(self.food ? [self.food arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"food"];
    [dict setObject:(self.gender ? self.gender : [NSNull null])
             forKey:@"gender"];
    [dict setObject:(self.happiestWhen ? self.happiestWhen : [NSNull null])
             forKey:@"happiestWhen"];
    [dict setObject:(self.heroes ? [self.heroes arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"heroes"];
    [dict setObject:(self.humor ? self.humor : [NSNull null])
             forKey:@"humor"];
    [dict setObject:(self.ims ? [self.ims arrayOfImsDictionariesFromImsObjects] : [NSNull null])
             forKey:@"ims"];
    [dict setObject:(self.interestedInMeeting ? self.interestedInMeeting : [NSNull null])
             forKey:@"interestedInMeeting"];
    [dict setObject:(self.interests ? [self.interests arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"interests"];
    [dict setObject:(self.jobInterests ? [self.jobInterests arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"jobInterests"];
    [dict setObject:(self.languages ? [self.languages arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"languages"];
    [dict setObject:(self.languagesSpoken ? [self.languagesSpoken arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"languagesSpoken"];
    [dict setObject:(self.livingArrangement ? self.livingArrangement : [NSNull null])
             forKey:@"livingArrangement"];
    [dict setObject:(self.lookingFor ? [self.lookingFor arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"lookingFor"];
    [dict setObject:(self.movies ? [self.movies arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"movies"];
    [dict setObject:(self.music ? [self.music arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"music"];
    [dict setObject:(self.name ? [self.name toDictionary] : [NSNull null])
             forKey:@"name"];
    [dict setObject:(self.nickname ? self.nickname : [NSNull null])
             forKey:@"nickname"];
    [dict setObject:(self.note ? self.note : [NSNull null])
             forKey:@"note"];
    [dict setObject:(self.organizations ? [self.organizations arrayOfOrganizationsDictionariesFromOrganizationsObjects] : [NSNull null])
             forKey:@"organizations"];
    [dict setObject:(self.pets ? [self.pets arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"pets"];
    [dict setObject:(self.phoneNumbers ? [self.phoneNumbers arrayOfPhoneNumbersDictionariesFromPhoneNumbersObjects] : [NSNull null])
             forKey:@"phoneNumbers"];
    [dict setObject:(self.profilePhotos ? [self.profilePhotos arrayOfProfilePhotosDictionariesFromProfilePhotosObjects] : [NSNull null])
             forKey:@"photos"];
    [dict setObject:(self.politicalViews ? self.politicalViews : [NSNull null])
             forKey:@"politicalViews"];
    [dict setObject:(self.preferredUsername ? self.preferredUsername : [NSNull null])
             forKey:@"preferredUsername"];
    [dict setObject:(self.profileSong ? self.profileSong : [NSNull null])
             forKey:@"profileSong"];
    [dict setObject:(self.profileUrl ? self.profileUrl : [NSNull null])
             forKey:@"profileUrl"];
    [dict setObject:(self.profileVideo ? self.profileVideo : [NSNull null])
             forKey:@"profileVideo"];
    [dict setObject:(self.published ? [self.published stringFromISO8601DateTime] : [NSNull null])
             forKey:@"published"];
    [dict setObject:(self.quotes ? [self.quotes arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"quotes"];
    [dict setObject:(self.relationshipStatus ? self.relationshipStatus : [NSNull null])
             forKey:@"relationshipStatus"];
    [dict setObject:(self.relationships ? [self.relationships arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"relationships"];
    [dict setObject:(self.religion ? self.religion : [NSNull null])
             forKey:@"religion"];
    [dict setObject:(self.romance ? self.romance : [NSNull null])
             forKey:@"romance"];
    [dict setObject:(self.scaredOf ? self.scaredOf : [NSNull null])
             forKey:@"scaredOf"];
    [dict setObject:(self.sexualOrientation ? self.sexualOrientation : [NSNull null])
             forKey:@"sexualOrientation"];
    [dict setObject:(self.smoker ? self.smoker : [NSNull null])
             forKey:@"smoker"];
    [dict setObject:(self.sports ? [self.sports arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"sports"];
    [dict setObject:(self.status ? self.status : [NSNull null])
             forKey:@"status"];
    [dict setObject:(self.tags ? [self.tags arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"tags"];
    [dict setObject:(self.turnOffs ? [self.turnOffs arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"turnOffs"];
    [dict setObject:(self.turnOns ? [self.turnOns arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"turnOns"];
    [dict setObject:(self.tvShows ? [self.tvShows arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"tvShows"];
    [dict setObject:(self.updated ? [self.updated stringFromISO8601DateTime] : [NSNull null])
             forKey:@"updated"];
    [dict setObject:(self.urls ? [self.urls arrayOfUrlsDictionariesFromUrlsObjects] : [NSNull null])
             forKey:@"urls"];
    [dict setObject:(self.utcOffset ? self.utcOffset : [NSNull null])
             forKey:@"utcOffset"];

    return dict;
}

+ (id)profileObjectFromDictionary:(NSDictionary*)dictionary
{
    JRProfile *profile = [JRProfile profile];

    profile.aboutMe =
        [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
        [dictionary objectForKey:@"aboutMe"] : nil;

    profile.accounts =
        [dictionary objectForKey:@"accounts"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"accounts"] arrayOfAccountsObjectsFromAccountsDictionaries] : nil;

    profile.addresses =
        [dictionary objectForKey:@"addresses"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"addresses"] arrayOfAddressesObjectsFromAddressesDictionaries] : nil;

    profile.anniversary =
        [dictionary objectForKey:@"anniversary"] != [NSNull null] ? 
        [NSDate dateFromISO8601DateString:[dictionary objectForKey:@"anniversary"]] : nil;

    profile.birthday =
        [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
        [dictionary objectForKey:@"birthday"] : nil;

    profile.bodyType =
        [dictionary objectForKey:@"bodyType"] != [NSNull null] ? 
        [JRBodyType bodyTypeObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"bodyType"]] : nil;

    profile.books =
        [dictionary objectForKey:@"books"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"books"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"book"] : nil;

    profile.cars =
        [dictionary objectForKey:@"cars"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"cars"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"car"] : nil;

    profile.children =
        [dictionary objectForKey:@"children"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"children"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"value"] : nil;

    profile.currentLocation =
        [dictionary objectForKey:@"currentLocation"] != [NSNull null] ? 
        [JRCurrentLocation currentLocationObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"currentLocation"]] : nil;

    profile.displayName =
        [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
        [dictionary objectForKey:@"displayName"] : nil;

    profile.drinker =
        [dictionary objectForKey:@"drinker"] != [NSNull null] ? 
        [dictionary objectForKey:@"drinker"] : nil;

    profile.emails =
        [dictionary objectForKey:@"emails"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"emails"] arrayOfEmailsObjectsFromEmailsDictionaries] : nil;

    profile.ethnicity =
        [dictionary objectForKey:@"ethnicity"] != [NSNull null] ? 
        [dictionary objectForKey:@"ethnicity"] : nil;

    profile.fashion =
        [dictionary objectForKey:@"fashion"] != [NSNull null] ? 
        [dictionary objectForKey:@"fashion"] : nil;

    profile.food =
        [dictionary objectForKey:@"food"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"food"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"food"] : nil;

    profile.gender =
        [dictionary objectForKey:@"gender"] != [NSNull null] ? 
        [dictionary objectForKey:@"gender"] : nil;

    profile.happiestWhen =
        [dictionary objectForKey:@"happiestWhen"] != [NSNull null] ? 
        [dictionary objectForKey:@"happiestWhen"] : nil;

    profile.heroes =
        [dictionary objectForKey:@"heroes"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"heroes"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"hero"] : nil;

    profile.humor =
        [dictionary objectForKey:@"humor"] != [NSNull null] ? 
        [dictionary objectForKey:@"humor"] : nil;

    profile.ims =
        [dictionary objectForKey:@"ims"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"ims"] arrayOfImsObjectsFromImsDictionaries] : nil;

    profile.interestedInMeeting =
        [dictionary objectForKey:@"interestedInMeeting"] != [NSNull null] ? 
        [dictionary objectForKey:@"interestedInMeeting"] : nil;

    profile.interests =
        [dictionary objectForKey:@"interests"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"interests"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"interest"] : nil;

    profile.jobInterests =
        [dictionary objectForKey:@"jobInterests"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"jobInterests"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"jobInterest"] : nil;

    profile.languages =
        [dictionary objectForKey:@"languages"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"languages"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"language"] : nil;

    profile.languagesSpoken =
        [dictionary objectForKey:@"languagesSpoken"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"languagesSpoken"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"languageSpoken"] : nil;

    profile.livingArrangement =
        [dictionary objectForKey:@"livingArrangement"] != [NSNull null] ? 
        [dictionary objectForKey:@"livingArrangement"] : nil;

    profile.lookingFor =
        [dictionary objectForKey:@"lookingFor"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"lookingFor"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"value"] : nil;

    profile.movies =
        [dictionary objectForKey:@"movies"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"movies"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"movie"] : nil;

    profile.music =
        [dictionary objectForKey:@"music"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"music"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"music"] : nil;

    profile.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [JRName nameObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"name"]] : nil;

    profile.nickname =
        [dictionary objectForKey:@"nickname"] != [NSNull null] ? 
        [dictionary objectForKey:@"nickname"] : nil;

    profile.note =
        [dictionary objectForKey:@"note"] != [NSNull null] ? 
        [dictionary objectForKey:@"note"] : nil;

    profile.organizations =
        [dictionary objectForKey:@"organizations"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"organizations"] arrayOfOrganizationsObjectsFromOrganizationsDictionaries] : nil;

    profile.pets =
        [dictionary objectForKey:@"pets"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pets"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"value"] : nil;

    profile.phoneNumbers =
        [dictionary objectForKey:@"phoneNumbers"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"phoneNumbers"] arrayOfPhoneNumbersObjectsFromPhoneNumbersDictionaries] : nil;

    profile.profilePhotos =
        [dictionary objectForKey:@"photos"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfProfilePhotosObjectsFromProfilePhotosDictionaries] : nil;

    profile.politicalViews =
        [dictionary objectForKey:@"politicalViews"] != [NSNull null] ? 
        [dictionary objectForKey:@"politicalViews"] : nil;

    profile.preferredUsername =
        [dictionary objectForKey:@"preferredUsername"] != [NSNull null] ? 
        [dictionary objectForKey:@"preferredUsername"] : nil;

    profile.profileSong =
        [dictionary objectForKey:@"profileSong"] != [NSNull null] ? 
        [dictionary objectForKey:@"profileSong"] : nil;

    profile.profileUrl =
        [dictionary objectForKey:@"profileUrl"] != [NSNull null] ? 
        [dictionary objectForKey:@"profileUrl"] : nil;

    profile.profileVideo =
        [dictionary objectForKey:@"profileVideo"] != [NSNull null] ? 
        [dictionary objectForKey:@"profileVideo"] : nil;

    profile.published =
        [dictionary objectForKey:@"published"] != [NSNull null] ? 
        [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"published"]] : nil;

    profile.quotes =
        [dictionary objectForKey:@"quotes"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"quotes"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"quote"] : nil;

    profile.relationshipStatus =
        [dictionary objectForKey:@"relationshipStatus"] != [NSNull null] ? 
        [dictionary objectForKey:@"relationshipStatus"] : nil;

    profile.relationships =
        [dictionary objectForKey:@"relationships"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"relationships"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"relationship"] : nil;

    profile.religion =
        [dictionary objectForKey:@"religion"] != [NSNull null] ? 
        [dictionary objectForKey:@"religion"] : nil;

    profile.romance =
        [dictionary objectForKey:@"romance"] != [NSNull null] ? 
        [dictionary objectForKey:@"romance"] : nil;

    profile.scaredOf =
        [dictionary objectForKey:@"scaredOf"] != [NSNull null] ? 
        [dictionary objectForKey:@"scaredOf"] : nil;

    profile.sexualOrientation =
        [dictionary objectForKey:@"sexualOrientation"] != [NSNull null] ? 
        [dictionary objectForKey:@"sexualOrientation"] : nil;

    profile.smoker =
        [dictionary objectForKey:@"smoker"] != [NSNull null] ? 
        [dictionary objectForKey:@"smoker"] : nil;

    profile.sports =
        [dictionary objectForKey:@"sports"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"sports"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"sport"] : nil;

    profile.status =
        [dictionary objectForKey:@"status"] != [NSNull null] ? 
        [dictionary objectForKey:@"status"] : nil;

    profile.tags =
        [dictionary objectForKey:@"tags"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"tags"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"tag"] : nil;

    profile.turnOffs =
        [dictionary objectForKey:@"turnOffs"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"turnOffs"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"turnOff"] : nil;

    profile.turnOns =
        [dictionary objectForKey:@"turnOns"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"turnOns"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"turnOn"] : nil;

    profile.tvShows =
        [dictionary objectForKey:@"tvShows"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"tvShows"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"tvShow"] : nil;

    profile.updated =
        [dictionary objectForKey:@"updated"] != [NSNull null] ? 
        [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"updated"]] : nil;

    profile.urls =
        [dictionary objectForKey:@"urls"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"urls"] arrayOfUrlsObjectsFromUrlsDictionaries] : nil;

    profile.utcOffset =
        [dictionary objectForKey:@"utcOffset"] != [NSNull null] ? 
        [dictionary objectForKey:@"utcOffset"] : nil;

    [profile.dirtyPropertySet removeAllObjects];
    
    return profile;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"aboutMe"])
        _aboutMe = [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
            [dictionary objectForKey:@"aboutMe"] : nil;

    if ([dictionary objectForKey:@"accounts"])
        _accounts = [dictionary objectForKey:@"accounts"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"accounts"] arrayOfAccountsObjectsFromAccountsDictionaries] : nil;

    if ([dictionary objectForKey:@"addresses"])
        _addresses = [dictionary objectForKey:@"addresses"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"addresses"] arrayOfAddressesObjectsFromAddressesDictionaries] : nil;

    if ([dictionary objectForKey:@"anniversary"])
        _anniversary = [dictionary objectForKey:@"anniversary"] != [NSNull null] ? 
            [NSDate dateFromISO8601DateString:[dictionary objectForKey:@"anniversary"]] : nil;

    if ([dictionary objectForKey:@"birthday"])
        _birthday = [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
            [dictionary objectForKey:@"birthday"] : nil;

    if ([dictionary objectForKey:@"bodyType"])
        _bodyType = [dictionary objectForKey:@"bodyType"] != [NSNull null] ? 
            [JRBodyType bodyTypeObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"bodyType"]] : nil;

    if ([dictionary objectForKey:@"books"])
        _books = [dictionary objectForKey:@"books"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"books"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"book"] : nil;

    if ([dictionary objectForKey:@"cars"])
        _cars = [dictionary objectForKey:@"cars"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"cars"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"car"] : nil;

    if ([dictionary objectForKey:@"children"])
        _children = [dictionary objectForKey:@"children"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"children"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"value"] : nil;

    if ([dictionary objectForKey:@"currentLocation"])
        _currentLocation = [dictionary objectForKey:@"currentLocation"] != [NSNull null] ? 
            [JRCurrentLocation currentLocationObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"currentLocation"]] : nil;

    if ([dictionary objectForKey:@"displayName"])
        _displayName = [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
            [dictionary objectForKey:@"displayName"] : nil;

    if ([dictionary objectForKey:@"drinker"])
        _drinker = [dictionary objectForKey:@"drinker"] != [NSNull null] ? 
            [dictionary objectForKey:@"drinker"] : nil;

    if ([dictionary objectForKey:@"emails"])
        _emails = [dictionary objectForKey:@"emails"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"emails"] arrayOfEmailsObjectsFromEmailsDictionaries] : nil;

    if ([dictionary objectForKey:@"ethnicity"])
        _ethnicity = [dictionary objectForKey:@"ethnicity"] != [NSNull null] ? 
            [dictionary objectForKey:@"ethnicity"] : nil;

    if ([dictionary objectForKey:@"fashion"])
        _fashion = [dictionary objectForKey:@"fashion"] != [NSNull null] ? 
            [dictionary objectForKey:@"fashion"] : nil;

    if ([dictionary objectForKey:@"food"])
        _food = [dictionary objectForKey:@"food"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"food"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"food"] : nil;

    if ([dictionary objectForKey:@"gender"])
        _gender = [dictionary objectForKey:@"gender"] != [NSNull null] ? 
            [dictionary objectForKey:@"gender"] : nil;

    if ([dictionary objectForKey:@"happiestWhen"])
        _happiestWhen = [dictionary objectForKey:@"happiestWhen"] != [NSNull null] ? 
            [dictionary objectForKey:@"happiestWhen"] : nil;

    if ([dictionary objectForKey:@"heroes"])
        _heroes = [dictionary objectForKey:@"heroes"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"heroes"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"hero"] : nil;

    if ([dictionary objectForKey:@"humor"])
        _humor = [dictionary objectForKey:@"humor"] != [NSNull null] ? 
            [dictionary objectForKey:@"humor"] : nil;

    if ([dictionary objectForKey:@"ims"])
        _ims = [dictionary objectForKey:@"ims"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"ims"] arrayOfImsObjectsFromImsDictionaries] : nil;

    if ([dictionary objectForKey:@"interestedInMeeting"])
        _interestedInMeeting = [dictionary objectForKey:@"interestedInMeeting"] != [NSNull null] ? 
            [dictionary objectForKey:@"interestedInMeeting"] : nil;

    if ([dictionary objectForKey:@"interests"])
        _interests = [dictionary objectForKey:@"interests"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"interests"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"interest"] : nil;

    if ([dictionary objectForKey:@"jobInterests"])
        _jobInterests = [dictionary objectForKey:@"jobInterests"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"jobInterests"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"jobInterest"] : nil;

    if ([dictionary objectForKey:@"languages"])
        _languages = [dictionary objectForKey:@"languages"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"languages"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"language"] : nil;

    if ([dictionary objectForKey:@"languagesSpoken"])
        _languagesSpoken = [dictionary objectForKey:@"languagesSpoken"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"languagesSpoken"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"languageSpoken"] : nil;

    if ([dictionary objectForKey:@"livingArrangement"])
        _livingArrangement = [dictionary objectForKey:@"livingArrangement"] != [NSNull null] ? 
            [dictionary objectForKey:@"livingArrangement"] : nil;

    if ([dictionary objectForKey:@"lookingFor"])
        _lookingFor = [dictionary objectForKey:@"lookingFor"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"lookingFor"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"value"] : nil;

    if ([dictionary objectForKey:@"movies"])
        _movies = [dictionary objectForKey:@"movies"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"movies"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"movie"] : nil;

    if ([dictionary objectForKey:@"music"])
        _music = [dictionary objectForKey:@"music"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"music"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"music"] : nil;

    if ([dictionary objectForKey:@"name"])
        _name = [dictionary objectForKey:@"name"] != [NSNull null] ? 
            [JRName nameObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"name"]] : nil;

    if ([dictionary objectForKey:@"nickname"])
        _nickname = [dictionary objectForKey:@"nickname"] != [NSNull null] ? 
            [dictionary objectForKey:@"nickname"] : nil;

    if ([dictionary objectForKey:@"note"])
        _note = [dictionary objectForKey:@"note"] != [NSNull null] ? 
            [dictionary objectForKey:@"note"] : nil;

    if ([dictionary objectForKey:@"organizations"])
        _organizations = [dictionary objectForKey:@"organizations"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"organizations"] arrayOfOrganizationsObjectsFromOrganizationsDictionaries] : nil;

    if ([dictionary objectForKey:@"pets"])
        _pets = [dictionary objectForKey:@"pets"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"pets"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"value"] : nil;

    if ([dictionary objectForKey:@"phoneNumbers"])
        _phoneNumbers = [dictionary objectForKey:@"phoneNumbers"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"phoneNumbers"] arrayOfPhoneNumbersObjectsFromPhoneNumbersDictionaries] : nil;

    if ([dictionary objectForKey:@"photos"])
        _profilePhotos = [dictionary objectForKey:@"photos"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfProfilePhotosObjectsFromProfilePhotosDictionaries] : nil;

    if ([dictionary objectForKey:@"politicalViews"])
        _politicalViews = [dictionary objectForKey:@"politicalViews"] != [NSNull null] ? 
            [dictionary objectForKey:@"politicalViews"] : nil;

    if ([dictionary objectForKey:@"preferredUsername"])
        _preferredUsername = [dictionary objectForKey:@"preferredUsername"] != [NSNull null] ? 
            [dictionary objectForKey:@"preferredUsername"] : nil;

    if ([dictionary objectForKey:@"profileSong"])
        _profileSong = [dictionary objectForKey:@"profileSong"] != [NSNull null] ? 
            [dictionary objectForKey:@"profileSong"] : nil;

    if ([dictionary objectForKey:@"profileUrl"])
        _profileUrl = [dictionary objectForKey:@"profileUrl"] != [NSNull null] ? 
            [dictionary objectForKey:@"profileUrl"] : nil;

    if ([dictionary objectForKey:@"profileVideo"])
        _profileVideo = [dictionary objectForKey:@"profileVideo"] != [NSNull null] ? 
            [dictionary objectForKey:@"profileVideo"] : nil;

    if ([dictionary objectForKey:@"published"])
        _published = [dictionary objectForKey:@"published"] != [NSNull null] ? 
            [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"published"]] : nil;

    if ([dictionary objectForKey:@"quotes"])
        _quotes = [dictionary objectForKey:@"quotes"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"quotes"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"quote"] : nil;

    if ([dictionary objectForKey:@"relationshipStatus"])
        _relationshipStatus = [dictionary objectForKey:@"relationshipStatus"] != [NSNull null] ? 
            [dictionary objectForKey:@"relationshipStatus"] : nil;

    if ([dictionary objectForKey:@"relationships"])
        _relationships = [dictionary objectForKey:@"relationships"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"relationships"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"relationship"] : nil;

    if ([dictionary objectForKey:@"religion"])
        _religion = [dictionary objectForKey:@"religion"] != [NSNull null] ? 
            [dictionary objectForKey:@"religion"] : nil;

    if ([dictionary objectForKey:@"romance"])
        _romance = [dictionary objectForKey:@"romance"] != [NSNull null] ? 
            [dictionary objectForKey:@"romance"] : nil;

    if ([dictionary objectForKey:@"scaredOf"])
        _scaredOf = [dictionary objectForKey:@"scaredOf"] != [NSNull null] ? 
            [dictionary objectForKey:@"scaredOf"] : nil;

    if ([dictionary objectForKey:@"sexualOrientation"])
        _sexualOrientation = [dictionary objectForKey:@"sexualOrientation"] != [NSNull null] ? 
            [dictionary objectForKey:@"sexualOrientation"] : nil;

    if ([dictionary objectForKey:@"smoker"])
        _smoker = [dictionary objectForKey:@"smoker"] != [NSNull null] ? 
            [dictionary objectForKey:@"smoker"] : nil;

    if ([dictionary objectForKey:@"sports"])
        _sports = [dictionary objectForKey:@"sports"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"sports"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"sport"] : nil;

    if ([dictionary objectForKey:@"status"])
        _status = [dictionary objectForKey:@"status"] != [NSNull null] ? 
            [dictionary objectForKey:@"status"] : nil;

    if ([dictionary objectForKey:@"tags"])
        _tags = [dictionary objectForKey:@"tags"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"tags"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"tag"] : nil;

    if ([dictionary objectForKey:@"turnOffs"])
        _turnOffs = [dictionary objectForKey:@"turnOffs"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"turnOffs"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"turnOff"] : nil;

    if ([dictionary objectForKey:@"turnOns"])
        _turnOns = [dictionary objectForKey:@"turnOns"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"turnOns"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"turnOn"] : nil;

    if ([dictionary objectForKey:@"tvShows"])
        _tvShows = [dictionary objectForKey:@"tvShows"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"tvShows"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"tvShow"] : nil;

    if ([dictionary objectForKey:@"updated"])
        _updated = [dictionary objectForKey:@"updated"] != [NSNull null] ? 
            [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"updated"]] : nil;

    if ([dictionary objectForKey:@"urls"])
        _urls = [dictionary objectForKey:@"urls"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"urls"] arrayOfUrlsObjectsFromUrlsDictionaries] : nil;

    if ([dictionary objectForKey:@"utcOffset"])
        _utcOffset = [dictionary objectForKey:@"utcOffset"] != [NSNull null] ? 
            [dictionary objectForKey:@"utcOffset"] : nil;
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary
{
    _aboutMe =
        [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
        [dictionary objectForKey:@"aboutMe"] : nil;

    _accounts =
        [dictionary objectForKey:@"accounts"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"accounts"] arrayOfAccountsObjectsFromAccountsDictionaries] : nil;

    _addresses =
        [dictionary objectForKey:@"addresses"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"addresses"] arrayOfAddressesObjectsFromAddressesDictionaries] : nil;

    _anniversary =
        [dictionary objectForKey:@"anniversary"] != [NSNull null] ? 
        [NSDate dateFromISO8601DateString:[dictionary objectForKey:@"anniversary"]] : nil;

    _birthday =
        [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
        [dictionary objectForKey:@"birthday"] : nil;

    _bodyType =
        [dictionary objectForKey:@"bodyType"] != [NSNull null] ? 
        [JRBodyType bodyTypeObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"bodyType"]] : nil;

    _books =
        [dictionary objectForKey:@"books"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"books"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"book"] : nil;

    _cars =
        [dictionary objectForKey:@"cars"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"cars"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"car"] : nil;

    _children =
        [dictionary objectForKey:@"children"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"children"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"value"] : nil;

    _currentLocation =
        [dictionary objectForKey:@"currentLocation"] != [NSNull null] ? 
        [JRCurrentLocation currentLocationObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"currentLocation"]] : nil;

    _displayName =
        [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
        [dictionary objectForKey:@"displayName"] : nil;

    _drinker =
        [dictionary objectForKey:@"drinker"] != [NSNull null] ? 
        [dictionary objectForKey:@"drinker"] : nil;

    _emails =
        [dictionary objectForKey:@"emails"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"emails"] arrayOfEmailsObjectsFromEmailsDictionaries] : nil;

    _ethnicity =
        [dictionary objectForKey:@"ethnicity"] != [NSNull null] ? 
        [dictionary objectForKey:@"ethnicity"] : nil;

    _fashion =
        [dictionary objectForKey:@"fashion"] != [NSNull null] ? 
        [dictionary objectForKey:@"fashion"] : nil;

    _food =
        [dictionary objectForKey:@"food"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"food"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"food"] : nil;

    _gender =
        [dictionary objectForKey:@"gender"] != [NSNull null] ? 
        [dictionary objectForKey:@"gender"] : nil;

    _happiestWhen =
        [dictionary objectForKey:@"happiestWhen"] != [NSNull null] ? 
        [dictionary objectForKey:@"happiestWhen"] : nil;

    _heroes =
        [dictionary objectForKey:@"heroes"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"heroes"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"hero"] : nil;

    _humor =
        [dictionary objectForKey:@"humor"] != [NSNull null] ? 
        [dictionary objectForKey:@"humor"] : nil;

    _ims =
        [dictionary objectForKey:@"ims"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"ims"] arrayOfImsObjectsFromImsDictionaries] : nil;

    _interestedInMeeting =
        [dictionary objectForKey:@"interestedInMeeting"] != [NSNull null] ? 
        [dictionary objectForKey:@"interestedInMeeting"] : nil;

    _interests =
        [dictionary objectForKey:@"interests"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"interests"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"interest"] : nil;

    _jobInterests =
        [dictionary objectForKey:@"jobInterests"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"jobInterests"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"jobInterest"] : nil;

    _languages =
        [dictionary objectForKey:@"languages"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"languages"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"language"] : nil;

    _languagesSpoken =
        [dictionary objectForKey:@"languagesSpoken"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"languagesSpoken"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"languageSpoken"] : nil;

    _livingArrangement =
        [dictionary objectForKey:@"livingArrangement"] != [NSNull null] ? 
        [dictionary objectForKey:@"livingArrangement"] : nil;

    _lookingFor =
        [dictionary objectForKey:@"lookingFor"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"lookingFor"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"value"] : nil;

    _movies =
        [dictionary objectForKey:@"movies"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"movies"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"movie"] : nil;

    _music =
        [dictionary objectForKey:@"music"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"music"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"music"] : nil;

    _name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [JRName nameObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"name"]] : nil;

    _nickname =
        [dictionary objectForKey:@"nickname"] != [NSNull null] ? 
        [dictionary objectForKey:@"nickname"] : nil;

    _note =
        [dictionary objectForKey:@"note"] != [NSNull null] ? 
        [dictionary objectForKey:@"note"] : nil;

    _organizations =
        [dictionary objectForKey:@"organizations"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"organizations"] arrayOfOrganizationsObjectsFromOrganizationsDictionaries] : nil;

    _pets =
        [dictionary objectForKey:@"pets"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pets"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"value"] : nil;

    _phoneNumbers =
        [dictionary objectForKey:@"phoneNumbers"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"phoneNumbers"] arrayOfPhoneNumbersObjectsFromPhoneNumbersDictionaries] : nil;

    _profilePhotos =
        [dictionary objectForKey:@"photos"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfProfilePhotosObjectsFromProfilePhotosDictionaries] : nil;

    _politicalViews =
        [dictionary objectForKey:@"politicalViews"] != [NSNull null] ? 
        [dictionary objectForKey:@"politicalViews"] : nil;

    _preferredUsername =
        [dictionary objectForKey:@"preferredUsername"] != [NSNull null] ? 
        [dictionary objectForKey:@"preferredUsername"] : nil;

    _profileSong =
        [dictionary objectForKey:@"profileSong"] != [NSNull null] ? 
        [dictionary objectForKey:@"profileSong"] : nil;

    _profileUrl =
        [dictionary objectForKey:@"profileUrl"] != [NSNull null] ? 
        [dictionary objectForKey:@"profileUrl"] : nil;

    _profileVideo =
        [dictionary objectForKey:@"profileVideo"] != [NSNull null] ? 
        [dictionary objectForKey:@"profileVideo"] : nil;

    _published =
        [dictionary objectForKey:@"published"] != [NSNull null] ? 
        [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"published"]] : nil;

    _quotes =
        [dictionary objectForKey:@"quotes"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"quotes"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"quote"] : nil;

    _relationshipStatus =
        [dictionary objectForKey:@"relationshipStatus"] != [NSNull null] ? 
        [dictionary objectForKey:@"relationshipStatus"] : nil;

    _relationships =
        [dictionary objectForKey:@"relationships"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"relationships"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"relationship"] : nil;

    _religion =
        [dictionary objectForKey:@"religion"] != [NSNull null] ? 
        [dictionary objectForKey:@"religion"] : nil;

    _romance =
        [dictionary objectForKey:@"romance"] != [NSNull null] ? 
        [dictionary objectForKey:@"romance"] : nil;

    _scaredOf =
        [dictionary objectForKey:@"scaredOf"] != [NSNull null] ? 
        [dictionary objectForKey:@"scaredOf"] : nil;

    _sexualOrientation =
        [dictionary objectForKey:@"sexualOrientation"] != [NSNull null] ? 
        [dictionary objectForKey:@"sexualOrientation"] : nil;

    _smoker =
        [dictionary objectForKey:@"smoker"] != [NSNull null] ? 
        [dictionary objectForKey:@"smoker"] : nil;

    _sports =
        [dictionary objectForKey:@"sports"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"sports"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"sport"] : nil;

    _status =
        [dictionary objectForKey:@"status"] != [NSNull null] ? 
        [dictionary objectForKey:@"status"] : nil;

    _tags =
        [dictionary objectForKey:@"tags"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"tags"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"tag"] : nil;

    _turnOffs =
        [dictionary objectForKey:@"turnOffs"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"turnOffs"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"turnOff"] : nil;

    _turnOns =
        [dictionary objectForKey:@"turnOns"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"turnOns"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"turnOn"] : nil;

    _tvShows =
        [dictionary objectForKey:@"tvShows"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"tvShows"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"tvShow"] : nil;

    _updated =
        [dictionary objectForKey:@"updated"] != [NSNull null] ? 
        [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"updated"]] : nil;

    _urls =
        [dictionary objectForKey:@"urls"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"urls"] arrayOfUrlsObjectsFromUrlsDictionaries] : nil;

    _utcOffset =
        [dictionary objectForKey:@"utcOffset"] != [NSNull null] ? 
        [dictionary objectForKey:@"utcOffset"] : nil;
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"aboutMe"])
        [dict setObject:(self.aboutMe ? self.aboutMe : [NSNull null]) forKey:@"aboutMe"];

    if ([self.dirtyPropertySet containsObject:@"accounts"])
        [dict setObject:(self.accounts ? [self.accounts arrayOfAccountsUpdateDictionariesFromAccountsObjects] : [NSNull null]) forKey:@"accounts"];

    if ([self.dirtyPropertySet containsObject:@"addresses"])
        [dict setObject:(self.addresses ? [self.addresses arrayOfAddressesUpdateDictionariesFromAddressesObjects] : [NSNull null]) forKey:@"addresses"];

    if ([self.dirtyPropertySet containsObject:@"anniversary"])
        [dict setObject:(self.anniversary ? [self.anniversary stringFromISO8601Date] : [NSNull null]) forKey:@"anniversary"];

    if ([self.dirtyPropertySet containsObject:@"birthday"])
        [dict setObject:(self.birthday ? self.birthday : [NSNull null]) forKey:@"birthday"];

    if ([self.dirtyPropertySet containsObject:@"bodyType"])
        [dict setObject:(self.bodyType ? [self.bodyType toUpdateDictionary] : [NSNull null]) forKey:@"bodyType"];

    if ([self.dirtyPropertySet containsObject:@"books"])
        [dict setObject:(self.books ? [self.books arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"books"];

    if ([self.dirtyPropertySet containsObject:@"cars"])
        [dict setObject:(self.cars ? [self.cars arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"cars"];

    if ([self.dirtyPropertySet containsObject:@"children"])
        [dict setObject:(self.children ? [self.children arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"children"];

    if ([self.dirtyPropertySet containsObject:@"currentLocation"])
        [dict setObject:(self.currentLocation ? [self.currentLocation toUpdateDictionary] : [NSNull null]) forKey:@"currentLocation"];

    if ([self.dirtyPropertySet containsObject:@"displayName"])
        [dict setObject:(self.displayName ? self.displayName : [NSNull null]) forKey:@"displayName"];

    if ([self.dirtyPropertySet containsObject:@"drinker"])
        [dict setObject:(self.drinker ? self.drinker : [NSNull null]) forKey:@"drinker"];

    if ([self.dirtyPropertySet containsObject:@"emails"])
        [dict setObject:(self.emails ? [self.emails arrayOfEmailsUpdateDictionariesFromEmailsObjects] : [NSNull null]) forKey:@"emails"];

    if ([self.dirtyPropertySet containsObject:@"ethnicity"])
        [dict setObject:(self.ethnicity ? self.ethnicity : [NSNull null]) forKey:@"ethnicity"];

    if ([self.dirtyPropertySet containsObject:@"fashion"])
        [dict setObject:(self.fashion ? self.fashion : [NSNull null]) forKey:@"fashion"];

    if ([self.dirtyPropertySet containsObject:@"food"])
        [dict setObject:(self.food ? [self.food arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"food"];

    if ([self.dirtyPropertySet containsObject:@"gender"])
        [dict setObject:(self.gender ? self.gender : [NSNull null]) forKey:@"gender"];

    if ([self.dirtyPropertySet containsObject:@"happiestWhen"])
        [dict setObject:(self.happiestWhen ? self.happiestWhen : [NSNull null]) forKey:@"happiestWhen"];

    if ([self.dirtyPropertySet containsObject:@"heroes"])
        [dict setObject:(self.heroes ? [self.heroes arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"heroes"];

    if ([self.dirtyPropertySet containsObject:@"humor"])
        [dict setObject:(self.humor ? self.humor : [NSNull null]) forKey:@"humor"];

    if ([self.dirtyPropertySet containsObject:@"ims"])
        [dict setObject:(self.ims ? [self.ims arrayOfImsUpdateDictionariesFromImsObjects] : [NSNull null]) forKey:@"ims"];

    if ([self.dirtyPropertySet containsObject:@"interestedInMeeting"])
        [dict setObject:(self.interestedInMeeting ? self.interestedInMeeting : [NSNull null]) forKey:@"interestedInMeeting"];

    if ([self.dirtyPropertySet containsObject:@"interests"])
        [dict setObject:(self.interests ? [self.interests arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"interests"];

    if ([self.dirtyPropertySet containsObject:@"jobInterests"])
        [dict setObject:(self.jobInterests ? [self.jobInterests arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"jobInterests"];

    if ([self.dirtyPropertySet containsObject:@"languages"])
        [dict setObject:(self.languages ? [self.languages arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"languages"];

    if ([self.dirtyPropertySet containsObject:@"languagesSpoken"])
        [dict setObject:(self.languagesSpoken ? [self.languagesSpoken arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"languagesSpoken"];

    if ([self.dirtyPropertySet containsObject:@"livingArrangement"])
        [dict setObject:(self.livingArrangement ? self.livingArrangement : [NSNull null]) forKey:@"livingArrangement"];

    if ([self.dirtyPropertySet containsObject:@"lookingFor"])
        [dict setObject:(self.lookingFor ? [self.lookingFor arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"lookingFor"];

    if ([self.dirtyPropertySet containsObject:@"movies"])
        [dict setObject:(self.movies ? [self.movies arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"movies"];

    if ([self.dirtyPropertySet containsObject:@"music"])
        [dict setObject:(self.music ? [self.music arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"music"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:(self.name ? [self.name toUpdateDictionary] : [NSNull null]) forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"nickname"])
        [dict setObject:(self.nickname ? self.nickname : [NSNull null]) forKey:@"nickname"];

    if ([self.dirtyPropertySet containsObject:@"note"])
        [dict setObject:(self.note ? self.note : [NSNull null]) forKey:@"note"];

    if ([self.dirtyPropertySet containsObject:@"organizations"])
        [dict setObject:(self.organizations ? [self.organizations arrayOfOrganizationsUpdateDictionariesFromOrganizationsObjects] : [NSNull null]) forKey:@"organizations"];

    if ([self.dirtyPropertySet containsObject:@"pets"])
        [dict setObject:(self.pets ? [self.pets arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"pets"];

    if ([self.dirtyPropertySet containsObject:@"phoneNumbers"])
        [dict setObject:(self.phoneNumbers ? [self.phoneNumbers arrayOfPhoneNumbersUpdateDictionariesFromPhoneNumbersObjects] : [NSNull null]) forKey:@"phoneNumbers"];

    if ([self.dirtyPropertySet containsObject:@"profilePhotos"])
        [dict setObject:(self.profilePhotos ? [self.profilePhotos arrayOfProfilePhotosUpdateDictionariesFromProfilePhotosObjects] : [NSNull null]) forKey:@"photos"];

    if ([self.dirtyPropertySet containsObject:@"politicalViews"])
        [dict setObject:(self.politicalViews ? self.politicalViews : [NSNull null]) forKey:@"politicalViews"];

    if ([self.dirtyPropertySet containsObject:@"preferredUsername"])
        [dict setObject:(self.preferredUsername ? self.preferredUsername : [NSNull null]) forKey:@"preferredUsername"];

    if ([self.dirtyPropertySet containsObject:@"profileSong"])
        [dict setObject:(self.profileSong ? self.profileSong : [NSNull null]) forKey:@"profileSong"];

    if ([self.dirtyPropertySet containsObject:@"profileUrl"])
        [dict setObject:(self.profileUrl ? self.profileUrl : [NSNull null]) forKey:@"profileUrl"];

    if ([self.dirtyPropertySet containsObject:@"profileVideo"])
        [dict setObject:(self.profileVideo ? self.profileVideo : [NSNull null]) forKey:@"profileVideo"];

    if ([self.dirtyPropertySet containsObject:@"published"])
        [dict setObject:(self.published ? [self.published stringFromISO8601DateTime] : [NSNull null]) forKey:@"published"];

    if ([self.dirtyPropertySet containsObject:@"quotes"])
        [dict setObject:(self.quotes ? [self.quotes arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"quotes"];

    if ([self.dirtyPropertySet containsObject:@"relationshipStatus"])
        [dict setObject:(self.relationshipStatus ? self.relationshipStatus : [NSNull null]) forKey:@"relationshipStatus"];

    if ([self.dirtyPropertySet containsObject:@"relationships"])
        [dict setObject:(self.relationships ? [self.relationships arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"relationships"];

    if ([self.dirtyPropertySet containsObject:@"religion"])
        [dict setObject:(self.religion ? self.religion : [NSNull null]) forKey:@"religion"];

    if ([self.dirtyPropertySet containsObject:@"romance"])
        [dict setObject:(self.romance ? self.romance : [NSNull null]) forKey:@"romance"];

    if ([self.dirtyPropertySet containsObject:@"scaredOf"])
        [dict setObject:(self.scaredOf ? self.scaredOf : [NSNull null]) forKey:@"scaredOf"];

    if ([self.dirtyPropertySet containsObject:@"sexualOrientation"])
        [dict setObject:(self.sexualOrientation ? self.sexualOrientation : [NSNull null]) forKey:@"sexualOrientation"];

    if ([self.dirtyPropertySet containsObject:@"smoker"])
        [dict setObject:(self.smoker ? self.smoker : [NSNull null]) forKey:@"smoker"];

    if ([self.dirtyPropertySet containsObject:@"sports"])
        [dict setObject:(self.sports ? [self.sports arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"sports"];

    if ([self.dirtyPropertySet containsObject:@"status"])
        [dict setObject:(self.status ? self.status : [NSNull null]) forKey:@"status"];

    if ([self.dirtyPropertySet containsObject:@"tags"])
        [dict setObject:(self.tags ? [self.tags arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"tags"];

    if ([self.dirtyPropertySet containsObject:@"turnOffs"])
        [dict setObject:(self.turnOffs ? [self.turnOffs arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"turnOffs"];

    if ([self.dirtyPropertySet containsObject:@"turnOns"])
        [dict setObject:(self.turnOns ? [self.turnOns arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"turnOns"];

    if ([self.dirtyPropertySet containsObject:@"tvShows"])
        [dict setObject:(self.tvShows ? [self.tvShows arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"tvShows"];

    if ([self.dirtyPropertySet containsObject:@"updated"])
        [dict setObject:(self.updated ? [self.updated stringFromISO8601DateTime] : [NSNull null]) forKey:@"updated"];

    if ([self.dirtyPropertySet containsObject:@"urls"])
        [dict setObject:(self.urls ? [self.urls arrayOfUrlsUpdateDictionariesFromUrlsObjects] : [NSNull null]) forKey:@"urls"];

    if ([self.dirtyPropertySet containsObject:@"utcOffset"])
        [dict setObject:(self.utcOffset ? self.utcOffset : [NSNull null]) forKey:@"utcOffset"];

    return dict;
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:[self toUpdateDictionary]
                                     withId:0
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
    [dict setObject:(self.accounts ? [self.accounts arrayOfAccountsReplaceDictionariesFromAccountsObjects] : [NSNull null]) forKey:@"accounts"];
    [dict setObject:(self.addresses ? [self.addresses arrayOfAddressesReplaceDictionariesFromAddressesObjects] : [NSNull null]) forKey:@"addresses"];
    [dict setObject:(self.anniversary ? [self.anniversary stringFromISO8601Date] : [NSNull null]) forKey:@"anniversary"];
    [dict setObject:(self.birthday ? self.birthday : [NSNull null]) forKey:@"birthday"];
    [dict setObject:(self.bodyType ? [self.bodyType toReplaceDictionary] : [NSNull null]) forKey:@"bodyType"];
    [dict setObject:(self.books ? [self.books arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"books"];
    [dict setObject:(self.cars ? [self.cars arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"cars"];
    [dict setObject:(self.children ? [self.children arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"children"];
    [dict setObject:(self.currentLocation ? [self.currentLocation toReplaceDictionary] : [NSNull null]) forKey:@"currentLocation"];
    [dict setObject:(self.displayName ? self.displayName : [NSNull null]) forKey:@"displayName"];
    [dict setObject:(self.drinker ? self.drinker : [NSNull null]) forKey:@"drinker"];
    [dict setObject:(self.emails ? [self.emails arrayOfEmailsReplaceDictionariesFromEmailsObjects] : [NSNull null]) forKey:@"emails"];
    [dict setObject:(self.ethnicity ? self.ethnicity : [NSNull null]) forKey:@"ethnicity"];
    [dict setObject:(self.fashion ? self.fashion : [NSNull null]) forKey:@"fashion"];
    [dict setObject:(self.food ? [self.food arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"food"];
    [dict setObject:(self.gender ? self.gender : [NSNull null]) forKey:@"gender"];
    [dict setObject:(self.happiestWhen ? self.happiestWhen : [NSNull null]) forKey:@"happiestWhen"];
    [dict setObject:(self.heroes ? [self.heroes arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"heroes"];
    [dict setObject:(self.humor ? self.humor : [NSNull null]) forKey:@"humor"];
    [dict setObject:(self.ims ? [self.ims arrayOfImsReplaceDictionariesFromImsObjects] : [NSNull null]) forKey:@"ims"];
    [dict setObject:(self.interestedInMeeting ? self.interestedInMeeting : [NSNull null]) forKey:@"interestedInMeeting"];
    [dict setObject:(self.interests ? [self.interests arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"interests"];
    [dict setObject:(self.jobInterests ? [self.jobInterests arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"jobInterests"];
    [dict setObject:(self.languages ? [self.languages arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"languages"];
    [dict setObject:(self.languagesSpoken ? [self.languagesSpoken arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"languagesSpoken"];
    [dict setObject:(self.livingArrangement ? self.livingArrangement : [NSNull null]) forKey:@"livingArrangement"];
    [dict setObject:(self.lookingFor ? [self.lookingFor arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"lookingFor"];
    [dict setObject:(self.movies ? [self.movies arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"movies"];
    [dict setObject:(self.music ? [self.music arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"music"];
    [dict setObject:(self.name ? [self.name toReplaceDictionary] : [NSNull null]) forKey:@"name"];
    [dict setObject:(self.nickname ? self.nickname : [NSNull null]) forKey:@"nickname"];
    [dict setObject:(self.note ? self.note : [NSNull null]) forKey:@"note"];
    [dict setObject:(self.organizations ? [self.organizations arrayOfOrganizationsReplaceDictionariesFromOrganizationsObjects] : [NSNull null]) forKey:@"organizations"];
    [dict setObject:(self.pets ? [self.pets arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"pets"];
    [dict setObject:(self.phoneNumbers ? [self.phoneNumbers arrayOfPhoneNumbersReplaceDictionariesFromPhoneNumbersObjects] : [NSNull null]) forKey:@"phoneNumbers"];
    [dict setObject:(self.profilePhotos ? [self.profilePhotos arrayOfProfilePhotosReplaceDictionariesFromProfilePhotosObjects] : [NSNull null]) forKey:@"photos"];
    [dict setObject:(self.politicalViews ? self.politicalViews : [NSNull null]) forKey:@"politicalViews"];
    [dict setObject:(self.preferredUsername ? self.preferredUsername : [NSNull null]) forKey:@"preferredUsername"];
    [dict setObject:(self.profileSong ? self.profileSong : [NSNull null]) forKey:@"profileSong"];
    [dict setObject:(self.profileUrl ? self.profileUrl : [NSNull null]) forKey:@"profileUrl"];
    [dict setObject:(self.profileVideo ? self.profileVideo : [NSNull null]) forKey:@"profileVideo"];
    [dict setObject:(self.published ? [self.published stringFromISO8601DateTime] : [NSNull null]) forKey:@"published"];
    [dict setObject:(self.quotes ? [self.quotes arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"quotes"];
    [dict setObject:(self.relationshipStatus ? self.relationshipStatus : [NSNull null]) forKey:@"relationshipStatus"];
    [dict setObject:(self.relationships ? [self.relationships arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"relationships"];
    [dict setObject:(self.religion ? self.religion : [NSNull null]) forKey:@"religion"];
    [dict setObject:(self.romance ? self.romance : [NSNull null]) forKey:@"romance"];
    [dict setObject:(self.scaredOf ? self.scaredOf : [NSNull null]) forKey:@"scaredOf"];
    [dict setObject:(self.sexualOrientation ? self.sexualOrientation : [NSNull null]) forKey:@"sexualOrientation"];
    [dict setObject:(self.smoker ? self.smoker : [NSNull null]) forKey:@"smoker"];
    [dict setObject:(self.sports ? [self.sports arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"sports"];
    [dict setObject:(self.status ? self.status : [NSNull null]) forKey:@"status"];
    [dict setObject:(self.tags ? [self.tags arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"tags"];
    [dict setObject:(self.turnOffs ? [self.turnOffs arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"turnOffs"];
    [dict setObject:(self.turnOns ? [self.turnOns arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"turnOns"];
    [dict setObject:(self.tvShows ? [self.tvShows arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"tvShows"];
    [dict setObject:(self.updated ? [self.updated stringFromISO8601DateTime] : [NSNull null]) forKey:@"updated"];
    [dict setObject:(self.urls ? [self.urls arrayOfUrlsReplaceDictionariesFromUrlsObjects] : [NSNull null]) forKey:@"urls"];
    [dict setObject:(self.utcOffset ? self.utcOffset : [NSNull null]) forKey:@"utcOffset"];

    return dict;
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:[self toReplaceDictionary]
                                      withId:0
                                      atPath:self.captureObjectPath
                                   withToken:[JRCaptureData accessToken]
                                 forDelegate:self
                                 withContext:newContext];
}

- (void)dealloc
{
    [_aboutMe release];
    [_accounts release];
    [_addresses release];
    [_anniversary release];
    [_birthday release];
    [_bodyType release];
    [_books release];
    [_cars release];
    [_children release];
    [_currentLocation release];
    [_displayName release];
    [_drinker release];
    [_emails release];
    [_ethnicity release];
    [_fashion release];
    [_food release];
    [_gender release];
    [_happiestWhen release];
    [_heroes release];
    [_humor release];
    [_ims release];
    [_interestedInMeeting release];
    [_interests release];
    [_jobInterests release];
    [_languages release];
    [_languagesSpoken release];
    [_livingArrangement release];
    [_lookingFor release];
    [_movies release];
    [_music release];
    [_name release];
    [_nickname release];
    [_note release];
    [_organizations release];
    [_pets release];
    [_phoneNumbers release];
    [_profilePhotos release];
    [_politicalViews release];
    [_preferredUsername release];
    [_profileSong release];
    [_profileUrl release];
    [_profileVideo release];
    [_published release];
    [_quotes release];
    [_relationshipStatus release];
    [_relationships release];
    [_religion release];
    [_romance release];
    [_scaredOf release];
    [_sexualOrientation release];
    [_smoker release];
    [_sports release];
    [_status release];
    [_tags release];
    [_turnOffs release];
    [_turnOns release];
    [_tvShows release];
    [_updated release];
    [_urls release];
    [_utcOffset release];

    [super dealloc];
}
@end
