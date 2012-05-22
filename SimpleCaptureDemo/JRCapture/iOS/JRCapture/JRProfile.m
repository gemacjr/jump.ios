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


#import "JRProfile.h"

@interface NSArray (AccountsToFromDictionary)
- (NSArray*)arrayOfAccountsObjectsFromAccountsDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfAccountsDictionariesFromAccountsObjects;
- (NSArray*)arrayOfAccountsReplaceDictionariesFromAccountsObjects;
@end

@implementation NSArray (AccountsToFromDictionary)
- (NSArray*)arrayOfAccountsObjectsFromAccountsDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredAccountsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredAccountsArray addObject:[JRAccountsElement accountsObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredAccountsArray;
}

- (NSArray*)arrayOfAccountsDictionariesFromAccountsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRAccountsElement class]])
            [filteredDictionaryArray addObject:[(JRAccountsElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfAccountsReplaceDictionariesFromAccountsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRAccountsElement class]])
            [filteredDictionaryArray addObject:[(JRAccountsElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (AddressesToFromDictionary)
- (NSArray*)arrayOfAddressesObjectsFromAddressesDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfAddressesDictionariesFromAddressesObjects;
- (NSArray*)arrayOfAddressesReplaceDictionariesFromAddressesObjects;
@end

@implementation NSArray (AddressesToFromDictionary)
- (NSArray*)arrayOfAddressesObjectsFromAddressesDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredAddressesArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredAddressesArray addObject:[JRAddressesElement addressesObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredAddressesArray;
}

- (NSArray*)arrayOfAddressesDictionariesFromAddressesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRAddressesElement class]])
            [filteredDictionaryArray addObject:[(JRAddressesElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfAddressesReplaceDictionariesFromAddressesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRAddressesElement class]])
            [filteredDictionaryArray addObject:[(JRAddressesElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (EmailsToFromDictionary)
- (NSArray*)arrayOfEmailsObjectsFromEmailsDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfEmailsDictionariesFromEmailsObjects;
- (NSArray*)arrayOfEmailsReplaceDictionariesFromEmailsObjects;
@end

@implementation NSArray (EmailsToFromDictionary)
- (NSArray*)arrayOfEmailsObjectsFromEmailsDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredEmailsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredEmailsArray addObject:[JREmailsElement emailsObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredEmailsArray;
}

- (NSArray*)arrayOfEmailsDictionariesFromEmailsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JREmailsElement class]])
            [filteredDictionaryArray addObject:[(JREmailsElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfEmailsReplaceDictionariesFromEmailsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JREmailsElement class]])
            [filteredDictionaryArray addObject:[(JREmailsElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (ImsToFromDictionary)
- (NSArray*)arrayOfImsObjectsFromImsDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfImsDictionariesFromImsObjects;
- (NSArray*)arrayOfImsReplaceDictionariesFromImsObjects;
@end

@implementation NSArray (ImsToFromDictionary)
- (NSArray*)arrayOfImsObjectsFromImsDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredImsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredImsArray addObject:[JRImsElement imsObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredImsArray;
}

- (NSArray*)arrayOfImsDictionariesFromImsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRImsElement class]])
            [filteredDictionaryArray addObject:[(JRImsElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfImsReplaceDictionariesFromImsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRImsElement class]])
            [filteredDictionaryArray addObject:[(JRImsElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (OrganizationsToFromDictionary)
- (NSArray*)arrayOfOrganizationsObjectsFromOrganizationsDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfOrganizationsDictionariesFromOrganizationsObjects;
- (NSArray*)arrayOfOrganizationsReplaceDictionariesFromOrganizationsObjects;
@end

@implementation NSArray (OrganizationsToFromDictionary)
- (NSArray*)arrayOfOrganizationsObjectsFromOrganizationsDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredOrganizationsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredOrganizationsArray addObject:[JROrganizationsElement organizationsObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredOrganizationsArray;
}

- (NSArray*)arrayOfOrganizationsDictionariesFromOrganizationsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROrganizationsElement class]])
            [filteredDictionaryArray addObject:[(JROrganizationsElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfOrganizationsReplaceDictionariesFromOrganizationsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROrganizationsElement class]])
            [filteredDictionaryArray addObject:[(JROrganizationsElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PhoneNumbersToFromDictionary)
- (NSArray*)arrayOfPhoneNumbersObjectsFromPhoneNumbersDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPhoneNumbersDictionariesFromPhoneNumbersObjects;
- (NSArray*)arrayOfPhoneNumbersReplaceDictionariesFromPhoneNumbersObjects;
@end

@implementation NSArray (PhoneNumbersToFromDictionary)
- (NSArray*)arrayOfPhoneNumbersObjectsFromPhoneNumbersDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredPhoneNumbersArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPhoneNumbersArray addObject:[JRPhoneNumbersElement phoneNumbersObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredPhoneNumbersArray;
}

- (NSArray*)arrayOfPhoneNumbersDictionariesFromPhoneNumbersObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhoneNumbersElement class]])
            [filteredDictionaryArray addObject:[(JRPhoneNumbersElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPhoneNumbersReplaceDictionariesFromPhoneNumbersObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhoneNumbersElement class]])
            [filteredDictionaryArray addObject:[(JRPhoneNumbersElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (ProfilePhotosToFromDictionary)
- (NSArray*)arrayOfProfilePhotosObjectsFromProfilePhotosDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfProfilePhotosDictionariesFromProfilePhotosObjects;
- (NSArray*)arrayOfProfilePhotosReplaceDictionariesFromProfilePhotosObjects;
@end

@implementation NSArray (ProfilePhotosToFromDictionary)
- (NSArray*)arrayOfProfilePhotosObjectsFromProfilePhotosDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredProfilePhotosArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredProfilePhotosArray addObject:[JRProfilePhotosElement profilePhotosObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredProfilePhotosArray;
}

- (NSArray*)arrayOfProfilePhotosDictionariesFromProfilePhotosObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfilePhotosElement class]])
            [filteredDictionaryArray addObject:[(JRProfilePhotosElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfProfilePhotosReplaceDictionariesFromProfilePhotosObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfilePhotosElement class]])
            [filteredDictionaryArray addObject:[(JRProfilePhotosElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (UrlsToFromDictionary)
- (NSArray*)arrayOfUrlsObjectsFromUrlsDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfUrlsDictionariesFromUrlsObjects;
- (NSArray*)arrayOfUrlsReplaceDictionariesFromUrlsObjects;
@end

@implementation NSArray (UrlsToFromDictionary)
- (NSArray*)arrayOfUrlsObjectsFromUrlsDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredUrlsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredUrlsArray addObject:[JRUrlsElement urlsObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredUrlsArray;
}

- (NSArray*)arrayOfUrlsDictionariesFromUrlsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRUrlsElement class]])
            [filteredDictionaryArray addObject:[(JRUrlsElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfUrlsReplaceDictionariesFromUrlsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRUrlsElement class]])
            [filteredDictionaryArray addObject:[(JRUrlsElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface JRProfile ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRProfile
{
    NSString *_aboutMe;
    NSArray *_accounts;
    NSArray *_addresses;
    JRDate *_anniversary;
    NSString *_birthday;
    JRBodyType *_bodyType;
    JRStringArray *_books;
    JRStringArray *_cars;
    JRStringArray *_children;
    JRCurrentLocation *_currentLocation;
    NSString *_displayName;
    NSString *_drinker;
    NSArray *_emails;
    NSString *_ethnicity;
    NSString *_fashion;
    JRStringArray *_food;
    NSString *_gender;
    NSString *_happiestWhen;
    JRStringArray *_heroes;
    NSString *_humor;
    NSArray *_ims;
    NSString *_interestedInMeeting;
    JRStringArray *_interests;
    JRStringArray *_jobInterests;
    JRStringArray *_languages;
    JRStringArray *_languagesSpoken;
    NSString *_livingArrangement;
    JRStringArray *_lookingFor;
    JRStringArray *_movies;
    JRStringArray *_music;
    JRName *_name;
    NSString *_nickname;
    NSString *_note;
    NSArray *_organizations;
    JRStringArray *_pets;
    NSArray *_phoneNumbers;
    NSArray *_profilePhotos;
    NSString *_politicalViews;
    NSString *_preferredUsername;
    NSString *_profileSong;
    NSString *_profileUrl;
    NSString *_profileVideo;
    JRDateTime *_published;
    JRStringArray *_quotes;
    NSString *_relationshipStatus;
    JRStringArray *_relationships;
    NSString *_religion;
    NSString *_romance;
    NSString *_scaredOf;
    NSString *_sexualOrientation;
    NSString *_smoker;
    JRStringArray *_sports;
    NSString *_status;
    JRStringArray *_tags;
    JRStringArray *_turnOffs;
    JRStringArray *_turnOns;
    JRStringArray *_tvShows;
    JRDateTime *_updated;
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
@synthesize canBeUpdatedOrReplaced;

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
    [self.dirtyArraySet addObject:@"accounts"];
    _accounts = [newAccounts copy];
}

- (NSArray *)addresses
{
    return _addresses;
}

- (void)setAddresses:(NSArray *)newAddresses
{
    [self.dirtyArraySet addObject:@"addresses"];
    _addresses = [newAddresses copy];
}

- (JRDate *)anniversary
{
    return _anniversary;
}

- (void)setAnniversary:(JRDate *)newAnniversary
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
    [self.dirtyArraySet addObject:@"books"];
    _books = [newBooks copyArrayOfStringPluralElementsWithType:@"book"];
}

- (NSArray *)cars
{
    return _cars;
}

- (void)setCars:(NSArray *)newCars
{
    [self.dirtyArraySet addObject:@"cars"];
    _cars = [newCars copyArrayOfStringPluralElementsWithType:@"car"];
}

- (NSArray *)children
{
    return _children;
}

- (void)setChildren:(NSArray *)newChildren
{
    [self.dirtyArraySet addObject:@"children"];
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
    [self.dirtyArraySet addObject:@"emails"];
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
    [self.dirtyArraySet addObject:@"food"];
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
    [self.dirtyArraySet addObject:@"heroes"];
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
    [self.dirtyArraySet addObject:@"ims"];
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
    [self.dirtyArraySet addObject:@"interests"];
    _interests = [newInterests copyArrayOfStringPluralElementsWithType:@"interest"];
}

- (NSArray *)jobInterests
{
    return _jobInterests;
}

- (void)setJobInterests:(NSArray *)newJobInterests
{
    [self.dirtyArraySet addObject:@"jobInterests"];
    _jobInterests = [newJobInterests copyArrayOfStringPluralElementsWithType:@"jobInterest"];
}

- (NSArray *)languages
{
    return _languages;
}

- (void)setLanguages:(NSArray *)newLanguages
{
    [self.dirtyArraySet addObject:@"languages"];
    _languages = [newLanguages copyArrayOfStringPluralElementsWithType:@"language"];
}

- (NSArray *)languagesSpoken
{
    return _languagesSpoken;
}

- (void)setLanguagesSpoken:(NSArray *)newLanguagesSpoken
{
    [self.dirtyArraySet addObject:@"languagesSpoken"];
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
    [self.dirtyArraySet addObject:@"lookingFor"];
    _lookingFor = [newLookingFor copyArrayOfStringPluralElementsWithType:@"value"];
}

- (NSArray *)movies
{
    return _movies;
}

- (void)setMovies:(NSArray *)newMovies
{
    [self.dirtyArraySet addObject:@"movies"];
    _movies = [newMovies copyArrayOfStringPluralElementsWithType:@"movie"];
}

- (NSArray *)music
{
    return _music;
}

- (void)setMusic:(NSArray *)newMusic
{
    [self.dirtyArraySet addObject:@"music"];
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
    [self.dirtyArraySet addObject:@"organizations"];
    _organizations = [newOrganizations copy];
}

- (NSArray *)pets
{
    return _pets;
}

- (void)setPets:(NSArray *)newPets
{
    [self.dirtyArraySet addObject:@"pets"];
    _pets = [newPets copyArrayOfStringPluralElementsWithType:@"value"];
}

- (NSArray *)phoneNumbers
{
    return _phoneNumbers;
}

- (void)setPhoneNumbers:(NSArray *)newPhoneNumbers
{
    [self.dirtyArraySet addObject:@"phoneNumbers"];
    _phoneNumbers = [newPhoneNumbers copy];
}

- (NSArray *)profilePhotos
{
    return _profilePhotos;
}

- (void)setProfilePhotos:(NSArray *)newProfilePhotos
{
    [self.dirtyArraySet addObject:@"profilePhotos"];
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

- (JRDateTime *)published
{
    return _published;
}

- (void)setPublished:(JRDateTime *)newPublished
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
    [self.dirtyArraySet addObject:@"quotes"];
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
    [self.dirtyArraySet addObject:@"relationships"];
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
    [self.dirtyArraySet addObject:@"sports"];
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
    [self.dirtyArraySet addObject:@"tags"];
    _tags = [newTags copyArrayOfStringPluralElementsWithType:@"tag"];
}

- (NSArray *)turnOffs
{
    return _turnOffs;
}

- (void)setTurnOffs:(NSArray *)newTurnOffs
{
    [self.dirtyArraySet addObject:@"turnOffs"];
    _turnOffs = [newTurnOffs copyArrayOfStringPluralElementsWithType:@"turnOff"];
}

- (NSArray *)turnOns
{
    return _turnOns;
}

- (void)setTurnOns:(NSArray *)newTurnOns
{
    [self.dirtyArraySet addObject:@"turnOns"];
    _turnOns = [newTurnOns copyArrayOfStringPluralElementsWithType:@"turnOn"];
}

- (NSArray *)tvShows
{
    return _tvShows;
}

- (void)setTvShows:(NSArray *)newTvShows
{
    [self.dirtyArraySet addObject:@"tvShows"];
    _tvShows = [newTvShows copyArrayOfStringPluralElementsWithType:@"tvShow"];
}

- (JRDateTime *)updated
{
    return _updated;
}

- (void)setUpdated:(JRDateTime *)newUpdated
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
    [self.dirtyArraySet addObject:@"urls"];
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
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;
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

    profileCopy.captureObjectPath = self.captureObjectPath;

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
    // TODO: Necessary??
    profileCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    // TODO: Necessary??
    [profileCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [profileCopy.dirtyArraySet setSet:self.dirtyArraySet];

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

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)profileObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRProfile *profile = [JRProfile profile];

    profile.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"profile"];
// TODO: Is this safe to assume?
    profile.canBeUpdatedOrReplaced = YES;

    profile.aboutMe =
        [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
        [dictionary objectForKey:@"aboutMe"] : nil;

    profile.accounts =
        [dictionary objectForKey:@"accounts"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"accounts"] arrayOfAccountsObjectsFromAccountsDictionariesWithPath:profile.captureObjectPath] : nil;

    profile.addresses =
        [dictionary objectForKey:@"addresses"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"addresses"] arrayOfAddressesObjectsFromAddressesDictionariesWithPath:profile.captureObjectPath] : nil;

    profile.anniversary =
        [dictionary objectForKey:@"anniversary"] != [NSNull null] ? 
        [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"anniversary"]] : nil;

    profile.birthday =
        [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
        [dictionary objectForKey:@"birthday"] : nil;

    profile.bodyType =
        [dictionary objectForKey:@"bodyType"] != [NSNull null] ? 
        [JRBodyType bodyTypeObjectFromDictionary:[dictionary objectForKey:@"bodyType"] withPath:profile.captureObjectPath] : nil;

    profile.books =
        [dictionary objectForKey:@"books"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"books"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"book" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/books", profile.captureObjectPath]] : nil;

    profile.cars =
        [dictionary objectForKey:@"cars"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"cars"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"car" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/cars", profile.captureObjectPath]] : nil;

    profile.children =
        [dictionary objectForKey:@"children"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"children"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"value" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/children", profile.captureObjectPath]] : nil;

    profile.currentLocation =
        [dictionary objectForKey:@"currentLocation"] != [NSNull null] ? 
        [JRCurrentLocation currentLocationObjectFromDictionary:[dictionary objectForKey:@"currentLocation"] withPath:profile.captureObjectPath] : nil;

    profile.displayName =
        [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
        [dictionary objectForKey:@"displayName"] : nil;

    profile.drinker =
        [dictionary objectForKey:@"drinker"] != [NSNull null] ? 
        [dictionary objectForKey:@"drinker"] : nil;

    profile.emails =
        [dictionary objectForKey:@"emails"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"emails"] arrayOfEmailsObjectsFromEmailsDictionariesWithPath:profile.captureObjectPath] : nil;

    profile.ethnicity =
        [dictionary objectForKey:@"ethnicity"] != [NSNull null] ? 
        [dictionary objectForKey:@"ethnicity"] : nil;

    profile.fashion =
        [dictionary objectForKey:@"fashion"] != [NSNull null] ? 
        [dictionary objectForKey:@"fashion"] : nil;

    profile.food =
        [dictionary objectForKey:@"food"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"food"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"food" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/food", profile.captureObjectPath]] : nil;

    profile.gender =
        [dictionary objectForKey:@"gender"] != [NSNull null] ? 
        [dictionary objectForKey:@"gender"] : nil;

    profile.happiestWhen =
        [dictionary objectForKey:@"happiestWhen"] != [NSNull null] ? 
        [dictionary objectForKey:@"happiestWhen"] : nil;

    profile.heroes =
        [dictionary objectForKey:@"heroes"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"heroes"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"hero" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/heroes", profile.captureObjectPath]] : nil;

    profile.humor =
        [dictionary objectForKey:@"humor"] != [NSNull null] ? 
        [dictionary objectForKey:@"humor"] : nil;

    profile.ims =
        [dictionary objectForKey:@"ims"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"ims"] arrayOfImsObjectsFromImsDictionariesWithPath:profile.captureObjectPath] : nil;

    profile.interestedInMeeting =
        [dictionary objectForKey:@"interestedInMeeting"] != [NSNull null] ? 
        [dictionary objectForKey:@"interestedInMeeting"] : nil;

    profile.interests =
        [dictionary objectForKey:@"interests"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"interests"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"interest" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/interests", profile.captureObjectPath]] : nil;

    profile.jobInterests =
        [dictionary objectForKey:@"jobInterests"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"jobInterests"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"jobInterest" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/jobInterests", profile.captureObjectPath]] : nil;

    profile.languages =
        [dictionary objectForKey:@"languages"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"languages"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"language" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/languages", profile.captureObjectPath]] : nil;

    profile.languagesSpoken =
        [dictionary objectForKey:@"languagesSpoken"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"languagesSpoken"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"languageSpoken" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/languagesSpoken", profile.captureObjectPath]] : nil;

    profile.livingArrangement =
        [dictionary objectForKey:@"livingArrangement"] != [NSNull null] ? 
        [dictionary objectForKey:@"livingArrangement"] : nil;

    profile.lookingFor =
        [dictionary objectForKey:@"lookingFor"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"lookingFor"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"value" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/lookingFor", profile.captureObjectPath]] : nil;

    profile.movies =
        [dictionary objectForKey:@"movies"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"movies"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"movie" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/movies", profile.captureObjectPath]] : nil;

    profile.music =
        [dictionary objectForKey:@"music"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"music"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"music" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/music", profile.captureObjectPath]] : nil;

    profile.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [JRName nameObjectFromDictionary:[dictionary objectForKey:@"name"] withPath:profile.captureObjectPath] : nil;

    profile.nickname =
        [dictionary objectForKey:@"nickname"] != [NSNull null] ? 
        [dictionary objectForKey:@"nickname"] : nil;

    profile.note =
        [dictionary objectForKey:@"note"] != [NSNull null] ? 
        [dictionary objectForKey:@"note"] : nil;

    profile.organizations =
        [dictionary objectForKey:@"organizations"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"organizations"] arrayOfOrganizationsObjectsFromOrganizationsDictionariesWithPath:profile.captureObjectPath] : nil;

    profile.pets =
        [dictionary objectForKey:@"pets"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pets"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"value" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/pets", profile.captureObjectPath]] : nil;

    profile.phoneNumbers =
        [dictionary objectForKey:@"phoneNumbers"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"phoneNumbers"] arrayOfPhoneNumbersObjectsFromPhoneNumbersDictionariesWithPath:profile.captureObjectPath] : nil;

    profile.profilePhotos =
        [dictionary objectForKey:@"photos"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfProfilePhotosObjectsFromProfilePhotosDictionariesWithPath:profile.captureObjectPath] : nil;

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
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"published"]] : nil;

    profile.quotes =
        [dictionary objectForKey:@"quotes"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"quotes"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"quote" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/quotes", profile.captureObjectPath]] : nil;

    profile.relationshipStatus =
        [dictionary objectForKey:@"relationshipStatus"] != [NSNull null] ? 
        [dictionary objectForKey:@"relationshipStatus"] : nil;

    profile.relationships =
        [dictionary objectForKey:@"relationships"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"relationships"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"relationship" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/relationships", profile.captureObjectPath]] : nil;

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
        [(NSArray*)[dictionary objectForKey:@"sports"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"sport" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/sports", profile.captureObjectPath]] : nil;

    profile.status =
        [dictionary objectForKey:@"status"] != [NSNull null] ? 
        [dictionary objectForKey:@"status"] : nil;

    profile.tags =
        [dictionary objectForKey:@"tags"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"tags"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"tag" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/tags", profile.captureObjectPath]] : nil;

    profile.turnOffs =
        [dictionary objectForKey:@"turnOffs"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"turnOffs"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"turnOff" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/turnOffs", profile.captureObjectPath]] : nil;

    profile.turnOns =
        [dictionary objectForKey:@"turnOns"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"turnOns"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"turnOn" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/turnOns", profile.captureObjectPath]] : nil;

    profile.tvShows =
        [dictionary objectForKey:@"tvShows"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"tvShows"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"tvShow" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/tvShows", profile.captureObjectPath]] : nil;

    profile.updated =
        [dictionary objectForKey:@"updated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"updated"]] : nil;

    profile.urls =
        [dictionary objectForKey:@"urls"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"urls"] arrayOfUrlsObjectsFromUrlsDictionariesWithPath:profile.captureObjectPath] : nil;

    profile.utcOffset =
        [dictionary objectForKey:@"utcOffset"] != [NSNull null] ? 
        [dictionary objectForKey:@"utcOffset"] : nil;

    [profile.dirtyPropertySet removeAllObjects];
    [profile.dirtyArraySet removeAllObjects];
    
    return profile;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"profile"];

    if ([dictionary objectForKey:@"aboutMe"])
        self.aboutMe = [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
            [dictionary objectForKey:@"aboutMe"] : nil;

    if ([dictionary objectForKey:@"anniversary"])
        self.anniversary = [dictionary objectForKey:@"anniversary"] != [NSNull null] ? 
            [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"anniversary"]] : nil;

    if ([dictionary objectForKey:@"birthday"])
        self.birthday = [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
            [dictionary objectForKey:@"birthday"] : nil;

    if ([dictionary objectForKey:@"bodyType"] == [NSNull null])
        self.bodyType = nil;
    else if ([dictionary objectForKey:@"bodyType"] && !self.bodyType)
        self.bodyType = [JRBodyType bodyTypeObjectFromDictionary:[dictionary objectForKey:@"bodyType"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"bodyType"])
        [self.bodyType updateFromDictionary:[dictionary objectForKey:@"bodyType"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"currentLocation"] == [NSNull null])
        self.currentLocation = nil;
    else if ([dictionary objectForKey:@"currentLocation"] && !self.currentLocation)
        self.currentLocation = [JRCurrentLocation currentLocationObjectFromDictionary:[dictionary objectForKey:@"currentLocation"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"currentLocation"])
        [self.currentLocation updateFromDictionary:[dictionary objectForKey:@"currentLocation"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"displayName"])
        self.displayName = [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
            [dictionary objectForKey:@"displayName"] : nil;

    if ([dictionary objectForKey:@"drinker"])
        self.drinker = [dictionary objectForKey:@"drinker"] != [NSNull null] ? 
            [dictionary objectForKey:@"drinker"] : nil;

    if ([dictionary objectForKey:@"ethnicity"])
        self.ethnicity = [dictionary objectForKey:@"ethnicity"] != [NSNull null] ? 
            [dictionary objectForKey:@"ethnicity"] : nil;

    if ([dictionary objectForKey:@"fashion"])
        self.fashion = [dictionary objectForKey:@"fashion"] != [NSNull null] ? 
            [dictionary objectForKey:@"fashion"] : nil;

    if ([dictionary objectForKey:@"gender"])
        self.gender = [dictionary objectForKey:@"gender"] != [NSNull null] ? 
            [dictionary objectForKey:@"gender"] : nil;

    if ([dictionary objectForKey:@"happiestWhen"])
        self.happiestWhen = [dictionary objectForKey:@"happiestWhen"] != [NSNull null] ? 
            [dictionary objectForKey:@"happiestWhen"] : nil;

    if ([dictionary objectForKey:@"humor"])
        self.humor = [dictionary objectForKey:@"humor"] != [NSNull null] ? 
            [dictionary objectForKey:@"humor"] : nil;

    if ([dictionary objectForKey:@"interestedInMeeting"])
        self.interestedInMeeting = [dictionary objectForKey:@"interestedInMeeting"] != [NSNull null] ? 
            [dictionary objectForKey:@"interestedInMeeting"] : nil;

    if ([dictionary objectForKey:@"livingArrangement"])
        self.livingArrangement = [dictionary objectForKey:@"livingArrangement"] != [NSNull null] ? 
            [dictionary objectForKey:@"livingArrangement"] : nil;

    if ([dictionary objectForKey:@"name"] == [NSNull null])
        self.name = nil;
    else if ([dictionary objectForKey:@"name"] && !self.name)
        self.name = [JRName nameObjectFromDictionary:[dictionary objectForKey:@"name"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"name"])
        [self.name updateFromDictionary:[dictionary objectForKey:@"name"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"nickname"])
        self.nickname = [dictionary objectForKey:@"nickname"] != [NSNull null] ? 
            [dictionary objectForKey:@"nickname"] : nil;

    if ([dictionary objectForKey:@"note"])
        self.note = [dictionary objectForKey:@"note"] != [NSNull null] ? 
            [dictionary objectForKey:@"note"] : nil;

    if ([dictionary objectForKey:@"politicalViews"])
        self.politicalViews = [dictionary objectForKey:@"politicalViews"] != [NSNull null] ? 
            [dictionary objectForKey:@"politicalViews"] : nil;

    if ([dictionary objectForKey:@"preferredUsername"])
        self.preferredUsername = [dictionary objectForKey:@"preferredUsername"] != [NSNull null] ? 
            [dictionary objectForKey:@"preferredUsername"] : nil;

    if ([dictionary objectForKey:@"profileSong"])
        self.profileSong = [dictionary objectForKey:@"profileSong"] != [NSNull null] ? 
            [dictionary objectForKey:@"profileSong"] : nil;

    if ([dictionary objectForKey:@"profileUrl"])
        self.profileUrl = [dictionary objectForKey:@"profileUrl"] != [NSNull null] ? 
            [dictionary objectForKey:@"profileUrl"] : nil;

    if ([dictionary objectForKey:@"profileVideo"])
        self.profileVideo = [dictionary objectForKey:@"profileVideo"] != [NSNull null] ? 
            [dictionary objectForKey:@"profileVideo"] : nil;

    if ([dictionary objectForKey:@"published"])
        self.published = [dictionary objectForKey:@"published"] != [NSNull null] ? 
            [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"published"]] : nil;

    if ([dictionary objectForKey:@"relationshipStatus"])
        self.relationshipStatus = [dictionary objectForKey:@"relationshipStatus"] != [NSNull null] ? 
            [dictionary objectForKey:@"relationshipStatus"] : nil;

    if ([dictionary objectForKey:@"religion"])
        self.religion = [dictionary objectForKey:@"religion"] != [NSNull null] ? 
            [dictionary objectForKey:@"religion"] : nil;

    if ([dictionary objectForKey:@"romance"])
        self.romance = [dictionary objectForKey:@"romance"] != [NSNull null] ? 
            [dictionary objectForKey:@"romance"] : nil;

    if ([dictionary objectForKey:@"scaredOf"])
        self.scaredOf = [dictionary objectForKey:@"scaredOf"] != [NSNull null] ? 
            [dictionary objectForKey:@"scaredOf"] : nil;

    if ([dictionary objectForKey:@"sexualOrientation"])
        self.sexualOrientation = [dictionary objectForKey:@"sexualOrientation"] != [NSNull null] ? 
            [dictionary objectForKey:@"sexualOrientation"] : nil;

    if ([dictionary objectForKey:@"smoker"])
        self.smoker = [dictionary objectForKey:@"smoker"] != [NSNull null] ? 
            [dictionary objectForKey:@"smoker"] : nil;

    if ([dictionary objectForKey:@"status"])
        self.status = [dictionary objectForKey:@"status"] != [NSNull null] ? 
            [dictionary objectForKey:@"status"] : nil;

    if ([dictionary objectForKey:@"updated"])
        self.updated = [dictionary objectForKey:@"updated"] != [NSNull null] ? 
            [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"updated"]] : nil;

    if ([dictionary objectForKey:@"utcOffset"])
        self.utcOffset = [dictionary objectForKey:@"utcOffset"] != [NSNull null] ? 
            [dictionary objectForKey:@"utcOffset"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"profile"];

    self.aboutMe =
        [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
        [dictionary objectForKey:@"aboutMe"] : nil;

    self.accounts =
        [dictionary objectForKey:@"accounts"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"accounts"] arrayOfAccountsObjectsFromAccountsDictionariesWithPath:self.captureObjectPath] : nil;

    self.addresses =
        [dictionary objectForKey:@"addresses"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"addresses"] arrayOfAddressesObjectsFromAddressesDictionariesWithPath:self.captureObjectPath] : nil;

    self.anniversary =
        [dictionary objectForKey:@"anniversary"] != [NSNull null] ? 
        [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"anniversary"]] : nil;

    self.birthday =
        [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
        [dictionary objectForKey:@"birthday"] : nil;

    if (![dictionary objectForKey:@"bodyType"] || [dictionary objectForKey:@"bodyType"] == [NSNull null])
        self.bodyType = nil;
    else if (!self.bodyType)
        self.bodyType = [JRBodyType bodyTypeObjectFromDictionary:[dictionary objectForKey:@"bodyType"] withPath:self.captureObjectPath];
    else
        [self.bodyType replaceFromDictionary:[dictionary objectForKey:@"bodyType"] withPath:self.captureObjectPath];

    self.books =
        [dictionary objectForKey:@"books"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"books"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"book" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/books", self.captureObjectPath]] : nil;

    self.cars =
        [dictionary objectForKey:@"cars"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"cars"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"car" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/cars", self.captureObjectPath]] : nil;

    self.children =
        [dictionary objectForKey:@"children"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"children"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"value" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/children", self.captureObjectPath]] : nil;

    if (![dictionary objectForKey:@"currentLocation"] || [dictionary objectForKey:@"currentLocation"] == [NSNull null])
        self.currentLocation = nil;
    else if (!self.currentLocation)
        self.currentLocation = [JRCurrentLocation currentLocationObjectFromDictionary:[dictionary objectForKey:@"currentLocation"] withPath:self.captureObjectPath];
    else
        [self.currentLocation replaceFromDictionary:[dictionary objectForKey:@"currentLocation"] withPath:self.captureObjectPath];

    self.displayName =
        [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
        [dictionary objectForKey:@"displayName"] : nil;

    self.drinker =
        [dictionary objectForKey:@"drinker"] != [NSNull null] ? 
        [dictionary objectForKey:@"drinker"] : nil;

    self.emails =
        [dictionary objectForKey:@"emails"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"emails"] arrayOfEmailsObjectsFromEmailsDictionariesWithPath:self.captureObjectPath] : nil;

    self.ethnicity =
        [dictionary objectForKey:@"ethnicity"] != [NSNull null] ? 
        [dictionary objectForKey:@"ethnicity"] : nil;

    self.fashion =
        [dictionary objectForKey:@"fashion"] != [NSNull null] ? 
        [dictionary objectForKey:@"fashion"] : nil;

    self.food =
        [dictionary objectForKey:@"food"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"food"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"food" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/food", self.captureObjectPath]] : nil;

    self.gender =
        [dictionary objectForKey:@"gender"] != [NSNull null] ? 
        [dictionary objectForKey:@"gender"] : nil;

    self.happiestWhen =
        [dictionary objectForKey:@"happiestWhen"] != [NSNull null] ? 
        [dictionary objectForKey:@"happiestWhen"] : nil;

    self.heroes =
        [dictionary objectForKey:@"heroes"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"heroes"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"hero" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/heroes", self.captureObjectPath]] : nil;

    self.humor =
        [dictionary objectForKey:@"humor"] != [NSNull null] ? 
        [dictionary objectForKey:@"humor"] : nil;

    self.ims =
        [dictionary objectForKey:@"ims"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"ims"] arrayOfImsObjectsFromImsDictionariesWithPath:self.captureObjectPath] : nil;

    self.interestedInMeeting =
        [dictionary objectForKey:@"interestedInMeeting"] != [NSNull null] ? 
        [dictionary objectForKey:@"interestedInMeeting"] : nil;

    self.interests =
        [dictionary objectForKey:@"interests"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"interests"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"interest" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/interests", self.captureObjectPath]] : nil;

    self.jobInterests =
        [dictionary objectForKey:@"jobInterests"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"jobInterests"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"jobInterest" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/jobInterests", self.captureObjectPath]] : nil;

    self.languages =
        [dictionary objectForKey:@"languages"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"languages"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"language" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/languages", self.captureObjectPath]] : nil;

    self.languagesSpoken =
        [dictionary objectForKey:@"languagesSpoken"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"languagesSpoken"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"languageSpoken" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/languagesSpoken", self.captureObjectPath]] : nil;

    self.livingArrangement =
        [dictionary objectForKey:@"livingArrangement"] != [NSNull null] ? 
        [dictionary objectForKey:@"livingArrangement"] : nil;

    self.lookingFor =
        [dictionary objectForKey:@"lookingFor"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"lookingFor"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"value" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/lookingFor", self.captureObjectPath]] : nil;

    self.movies =
        [dictionary objectForKey:@"movies"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"movies"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"movie" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/movies", self.captureObjectPath]] : nil;

    self.music =
        [dictionary objectForKey:@"music"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"music"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"music" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/music", self.captureObjectPath]] : nil;

    if (![dictionary objectForKey:@"name"] || [dictionary objectForKey:@"name"] == [NSNull null])
        self.name = nil;
    else if (!self.name)
        self.name = [JRName nameObjectFromDictionary:[dictionary objectForKey:@"name"] withPath:self.captureObjectPath];
    else
        [self.name replaceFromDictionary:[dictionary objectForKey:@"name"] withPath:self.captureObjectPath];

    self.nickname =
        [dictionary objectForKey:@"nickname"] != [NSNull null] ? 
        [dictionary objectForKey:@"nickname"] : nil;

    self.note =
        [dictionary objectForKey:@"note"] != [NSNull null] ? 
        [dictionary objectForKey:@"note"] : nil;

    self.organizations =
        [dictionary objectForKey:@"organizations"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"organizations"] arrayOfOrganizationsObjectsFromOrganizationsDictionariesWithPath:self.captureObjectPath] : nil;

    self.pets =
        [dictionary objectForKey:@"pets"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pets"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"value" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/pets", self.captureObjectPath]] : nil;

    self.phoneNumbers =
        [dictionary objectForKey:@"phoneNumbers"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"phoneNumbers"] arrayOfPhoneNumbersObjectsFromPhoneNumbersDictionariesWithPath:self.captureObjectPath] : nil;

    self.profilePhotos =
        [dictionary objectForKey:@"photos"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfProfilePhotosObjectsFromProfilePhotosDictionariesWithPath:self.captureObjectPath] : nil;

    self.politicalViews =
        [dictionary objectForKey:@"politicalViews"] != [NSNull null] ? 
        [dictionary objectForKey:@"politicalViews"] : nil;

    self.preferredUsername =
        [dictionary objectForKey:@"preferredUsername"] != [NSNull null] ? 
        [dictionary objectForKey:@"preferredUsername"] : nil;

    self.profileSong =
        [dictionary objectForKey:@"profileSong"] != [NSNull null] ? 
        [dictionary objectForKey:@"profileSong"] : nil;

    self.profileUrl =
        [dictionary objectForKey:@"profileUrl"] != [NSNull null] ? 
        [dictionary objectForKey:@"profileUrl"] : nil;

    self.profileVideo =
        [dictionary objectForKey:@"profileVideo"] != [NSNull null] ? 
        [dictionary objectForKey:@"profileVideo"] : nil;

    self.published =
        [dictionary objectForKey:@"published"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"published"]] : nil;

    self.quotes =
        [dictionary objectForKey:@"quotes"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"quotes"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"quote" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/quotes", self.captureObjectPath]] : nil;

    self.relationshipStatus =
        [dictionary objectForKey:@"relationshipStatus"] != [NSNull null] ? 
        [dictionary objectForKey:@"relationshipStatus"] : nil;

    self.relationships =
        [dictionary objectForKey:@"relationships"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"relationships"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"relationship" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/relationships", self.captureObjectPath]] : nil;

    self.religion =
        [dictionary objectForKey:@"religion"] != [NSNull null] ? 
        [dictionary objectForKey:@"religion"] : nil;

    self.romance =
        [dictionary objectForKey:@"romance"] != [NSNull null] ? 
        [dictionary objectForKey:@"romance"] : nil;

    self.scaredOf =
        [dictionary objectForKey:@"scaredOf"] != [NSNull null] ? 
        [dictionary objectForKey:@"scaredOf"] : nil;

    self.sexualOrientation =
        [dictionary objectForKey:@"sexualOrientation"] != [NSNull null] ? 
        [dictionary objectForKey:@"sexualOrientation"] : nil;

    self.smoker =
        [dictionary objectForKey:@"smoker"] != [NSNull null] ? 
        [dictionary objectForKey:@"smoker"] : nil;

    self.sports =
        [dictionary objectForKey:@"sports"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"sports"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"sport" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/sports", self.captureObjectPath]] : nil;

    self.status =
        [dictionary objectForKey:@"status"] != [NSNull null] ? 
        [dictionary objectForKey:@"status"] : nil;

    self.tags =
        [dictionary objectForKey:@"tags"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"tags"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"tag" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/tags", self.captureObjectPath]] : nil;

    self.turnOffs =
        [dictionary objectForKey:@"turnOffs"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"turnOffs"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"turnOff" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/turnOffs", self.captureObjectPath]] : nil;

    self.turnOns =
        [dictionary objectForKey:@"turnOns"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"turnOns"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"turnOn" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/turnOns", self.captureObjectPath]] : nil;

    self.tvShows =
        [dictionary objectForKey:@"tvShows"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"tvShows"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"tvShow" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/tvShows", self.captureObjectPath]] : nil;

    self.updated =
        [dictionary objectForKey:@"updated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"updated"]] : nil;

    self.urls =
        [dictionary objectForKey:@"urls"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"urls"] arrayOfUrlsObjectsFromUrlsDictionariesWithPath:self.captureObjectPath] : nil;

    self.utcOffset =
        [dictionary objectForKey:@"utcOffset"] != [NSNull null] ? 
        [dictionary objectForKey:@"utcOffset"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"aboutMe"])
        [dict setObject:(self.aboutMe ? self.aboutMe : [NSNull null]) forKey:@"aboutMe"];

    if ([self.dirtyPropertySet containsObject:@"anniversary"])
        [dict setObject:(self.anniversary ? [self.anniversary stringFromISO8601Date] : [NSNull null]) forKey:@"anniversary"];

    if ([self.dirtyPropertySet containsObject:@"birthday"])
        [dict setObject:(self.birthday ? self.birthday : [NSNull null]) forKey:@"birthday"];

    if ([self.dirtyPropertySet containsObject:@"bodyType"])
        [dict setObject:(self.bodyType ?
                              [self.bodyType toUpdateDictionary] :
                              [[JRBodyType bodyType] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"bodyType"];

    if ([self.dirtyPropertySet containsObject:@"currentLocation"])
        [dict setObject:(self.currentLocation ?
                              [self.currentLocation toUpdateDictionary] :
                              [[JRCurrentLocation currentLocation] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"currentLocation"];

    if ([self.dirtyPropertySet containsObject:@"displayName"])
        [dict setObject:(self.displayName ? self.displayName : [NSNull null]) forKey:@"displayName"];

    if ([self.dirtyPropertySet containsObject:@"drinker"])
        [dict setObject:(self.drinker ? self.drinker : [NSNull null]) forKey:@"drinker"];

    if ([self.dirtyPropertySet containsObject:@"ethnicity"])
        [dict setObject:(self.ethnicity ? self.ethnicity : [NSNull null]) forKey:@"ethnicity"];

    if ([self.dirtyPropertySet containsObject:@"fashion"])
        [dict setObject:(self.fashion ? self.fashion : [NSNull null]) forKey:@"fashion"];

    if ([self.dirtyPropertySet containsObject:@"gender"])
        [dict setObject:(self.gender ? self.gender : [NSNull null]) forKey:@"gender"];

    if ([self.dirtyPropertySet containsObject:@"happiestWhen"])
        [dict setObject:(self.happiestWhen ? self.happiestWhen : [NSNull null]) forKey:@"happiestWhen"];

    if ([self.dirtyPropertySet containsObject:@"humor"])
        [dict setObject:(self.humor ? self.humor : [NSNull null]) forKey:@"humor"];

    if ([self.dirtyPropertySet containsObject:@"interestedInMeeting"])
        [dict setObject:(self.interestedInMeeting ? self.interestedInMeeting : [NSNull null]) forKey:@"interestedInMeeting"];

    if ([self.dirtyPropertySet containsObject:@"livingArrangement"])
        [dict setObject:(self.livingArrangement ? self.livingArrangement : [NSNull null]) forKey:@"livingArrangement"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:(self.name ?
                              [self.name toUpdateDictionary] :
                              [[JRName name] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"nickname"])
        [dict setObject:(self.nickname ? self.nickname : [NSNull null]) forKey:@"nickname"];

    if ([self.dirtyPropertySet containsObject:@"note"])
        [dict setObject:(self.note ? self.note : [NSNull null]) forKey:@"note"];

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

    if ([self.dirtyPropertySet containsObject:@"relationshipStatus"])
        [dict setObject:(self.relationshipStatus ? self.relationshipStatus : [NSNull null]) forKey:@"relationshipStatus"];

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

    if ([self.dirtyPropertySet containsObject:@"status"])
        [dict setObject:(self.status ? self.status : [NSNull null]) forKey:@"status"];

    if ([self.dirtyPropertySet containsObject:@"updated"])
        [dict setObject:(self.updated ? [self.updated stringFromISO8601DateTime] : [NSNull null]) forKey:@"updated"];

    if ([self.dirtyPropertySet containsObject:@"utcOffset"])
        [dict setObject:(self.utcOffset ? self.utcOffset : [NSNull null]) forKey:@"utcOffset"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.aboutMe ? self.aboutMe : [NSNull null]) forKey:@"aboutMe"];
    [dict setObject:(self.accounts ? [self.accounts arrayOfAccountsReplaceDictionariesFromAccountsObjects] : [NSArray array]) forKey:@"accounts"];
    [dict setObject:(self.addresses ? [self.addresses arrayOfAddressesReplaceDictionariesFromAddressesObjects] : [NSArray array]) forKey:@"addresses"];
    [dict setObject:(self.anniversary ? [self.anniversary stringFromISO8601Date] : [NSNull null]) forKey:@"anniversary"];
    [dict setObject:(self.birthday ? self.birthday : [NSNull null]) forKey:@"birthday"];
    [dict setObject:(self.bodyType ?
                          [self.bodyType toReplaceDictionary] :
                          [[JRBodyType bodyType] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"bodyType"];
    [dict setObject:(self.books ? [self.books arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"books"];
    [dict setObject:(self.cars ? [self.cars arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"cars"];
    [dict setObject:(self.children ? [self.children arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"children"];
    [dict setObject:(self.currentLocation ?
                          [self.currentLocation toReplaceDictionary] :
                          [[JRCurrentLocation currentLocation] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"currentLocation"];
    [dict setObject:(self.displayName ? self.displayName : [NSNull null]) forKey:@"displayName"];
    [dict setObject:(self.drinker ? self.drinker : [NSNull null]) forKey:@"drinker"];
    [dict setObject:(self.emails ? [self.emails arrayOfEmailsReplaceDictionariesFromEmailsObjects] : [NSArray array]) forKey:@"emails"];
    [dict setObject:(self.ethnicity ? self.ethnicity : [NSNull null]) forKey:@"ethnicity"];
    [dict setObject:(self.fashion ? self.fashion : [NSNull null]) forKey:@"fashion"];
    [dict setObject:(self.food ? [self.food arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"food"];
    [dict setObject:(self.gender ? self.gender : [NSNull null]) forKey:@"gender"];
    [dict setObject:(self.happiestWhen ? self.happiestWhen : [NSNull null]) forKey:@"happiestWhen"];
    [dict setObject:(self.heroes ? [self.heroes arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"heroes"];
    [dict setObject:(self.humor ? self.humor : [NSNull null]) forKey:@"humor"];
    [dict setObject:(self.ims ? [self.ims arrayOfImsReplaceDictionariesFromImsObjects] : [NSArray array]) forKey:@"ims"];
    [dict setObject:(self.interestedInMeeting ? self.interestedInMeeting : [NSNull null]) forKey:@"interestedInMeeting"];
    [dict setObject:(self.interests ? [self.interests arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"interests"];
    [dict setObject:(self.jobInterests ? [self.jobInterests arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"jobInterests"];
    [dict setObject:(self.languages ? [self.languages arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"languages"];
    [dict setObject:(self.languagesSpoken ? [self.languagesSpoken arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"languagesSpoken"];
    [dict setObject:(self.livingArrangement ? self.livingArrangement : [NSNull null]) forKey:@"livingArrangement"];
    [dict setObject:(self.lookingFor ? [self.lookingFor arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"lookingFor"];
    [dict setObject:(self.movies ? [self.movies arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"movies"];
    [dict setObject:(self.music ? [self.music arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"music"];
    [dict setObject:(self.name ?
                          [self.name toReplaceDictionary] :
                          [[JRName name] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"name"];
    [dict setObject:(self.nickname ? self.nickname : [NSNull null]) forKey:@"nickname"];
    [dict setObject:(self.note ? self.note : [NSNull null]) forKey:@"note"];
    [dict setObject:(self.organizations ? [self.organizations arrayOfOrganizationsReplaceDictionariesFromOrganizationsObjects] : [NSArray array]) forKey:@"organizations"];
    [dict setObject:(self.pets ? [self.pets arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"pets"];
    [dict setObject:(self.phoneNumbers ? [self.phoneNumbers arrayOfPhoneNumbersReplaceDictionariesFromPhoneNumbersObjects] : [NSArray array]) forKey:@"phoneNumbers"];
    [dict setObject:(self.profilePhotos ? [self.profilePhotos arrayOfProfilePhotosReplaceDictionariesFromProfilePhotosObjects] : [NSArray array]) forKey:@"photos"];
    [dict setObject:(self.politicalViews ? self.politicalViews : [NSNull null]) forKey:@"politicalViews"];
    [dict setObject:(self.preferredUsername ? self.preferredUsername : [NSNull null]) forKey:@"preferredUsername"];
    [dict setObject:(self.profileSong ? self.profileSong : [NSNull null]) forKey:@"profileSong"];
    [dict setObject:(self.profileUrl ? self.profileUrl : [NSNull null]) forKey:@"profileUrl"];
    [dict setObject:(self.profileVideo ? self.profileVideo : [NSNull null]) forKey:@"profileVideo"];
    [dict setObject:(self.published ? [self.published stringFromISO8601DateTime] : [NSNull null]) forKey:@"published"];
    [dict setObject:(self.quotes ? [self.quotes arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"quotes"];
    [dict setObject:(self.relationshipStatus ? self.relationshipStatus : [NSNull null]) forKey:@"relationshipStatus"];
    [dict setObject:(self.relationships ? [self.relationships arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"relationships"];
    [dict setObject:(self.religion ? self.religion : [NSNull null]) forKey:@"religion"];
    [dict setObject:(self.romance ? self.romance : [NSNull null]) forKey:@"romance"];
    [dict setObject:(self.scaredOf ? self.scaredOf : [NSNull null]) forKey:@"scaredOf"];
    [dict setObject:(self.sexualOrientation ? self.sexualOrientation : [NSNull null]) forKey:@"sexualOrientation"];
    [dict setObject:(self.smoker ? self.smoker : [NSNull null]) forKey:@"smoker"];
    [dict setObject:(self.sports ? [self.sports arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"sports"];
    [dict setObject:(self.status ? self.status : [NSNull null]) forKey:@"status"];
    [dict setObject:(self.tags ? [self.tags arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"tags"];
    [dict setObject:(self.turnOffs ? [self.turnOffs arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"turnOffs"];
    [dict setObject:(self.turnOns ? [self.turnOns arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"turnOns"];
    [dict setObject:(self.tvShows ? [self.tvShows arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"tvShows"];
    [dict setObject:(self.updated ? [self.updated stringFromISO8601DateTime] : [NSNull null]) forKey:@"updated"];
    [dict setObject:(self.urls ? [self.urls arrayOfUrlsReplaceDictionariesFromUrlsObjects] : [NSArray array]) forKey:@"urls"];
    [dict setObject:(self.utcOffset ? self.utcOffset : [NSNull null]) forKey:@"utcOffset"];

    return dict;
}

- (void)replaceAccountsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.accounts named:@"accounts"
                    forDelegate:delegate withContext:context];
}

- (void)replaceAddressesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.addresses named:@"addresses"
                    forDelegate:delegate withContext:context];
}

- (void)replaceBooksArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.books ofType:@"book" named:@"books"
                          forDelegate:delegate withContext:context];
}

- (void)replaceCarsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.cars ofType:@"car" named:@"cars"
                          forDelegate:delegate withContext:context];
}

- (void)replaceChildrenArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.children ofType:@"value" named:@"children"
                          forDelegate:delegate withContext:context];
}

- (void)replaceEmailsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.emails named:@"emails"
                    forDelegate:delegate withContext:context];
}

- (void)replaceFoodArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.food ofType:@"food" named:@"food"
                          forDelegate:delegate withContext:context];
}

- (void)replaceHeroesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.heroes ofType:@"hero" named:@"heroes"
                          forDelegate:delegate withContext:context];
}

- (void)replaceImsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.ims named:@"ims"
                    forDelegate:delegate withContext:context];
}

- (void)replaceInterestsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.interests ofType:@"interest" named:@"interests"
                          forDelegate:delegate withContext:context];
}

- (void)replaceJobInterestsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.jobInterests ofType:@"jobInterest" named:@"jobInterests"
                          forDelegate:delegate withContext:context];
}

- (void)replaceLanguagesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.languages ofType:@"language" named:@"languages"
                          forDelegate:delegate withContext:context];
}

- (void)replaceLanguagesSpokenArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.languagesSpoken ofType:@"languageSpoken" named:@"languagesSpoken"
                          forDelegate:delegate withContext:context];
}

- (void)replaceLookingForArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.lookingFor ofType:@"value" named:@"lookingFor"
                          forDelegate:delegate withContext:context];
}

- (void)replaceMoviesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.movies ofType:@"movie" named:@"movies"
                          forDelegate:delegate withContext:context];
}

- (void)replaceMusicArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.music ofType:@"music" named:@"music"
                          forDelegate:delegate withContext:context];
}

- (void)replaceOrganizationsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.organizations named:@"organizations"
                    forDelegate:delegate withContext:context];
}

- (void)replacePetsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.pets ofType:@"value" named:@"pets"
                          forDelegate:delegate withContext:context];
}

- (void)replacePhoneNumbersArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.phoneNumbers named:@"phoneNumbers"
                    forDelegate:delegate withContext:context];
}

- (void)replaceProfilePhotosArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.profilePhotos named:@"profilePhotos"
                    forDelegate:delegate withContext:context];
}

- (void)replaceQuotesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.quotes ofType:@"quote" named:@"quotes"
                          forDelegate:delegate withContext:context];
}

- (void)replaceRelationshipsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.relationships ofType:@"relationship" named:@"relationships"
                          forDelegate:delegate withContext:context];
}

- (void)replaceSportsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.sports ofType:@"sport" named:@"sports"
                          forDelegate:delegate withContext:context];
}

- (void)replaceTagsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.tags ofType:@"tag" named:@"tags"
                          forDelegate:delegate withContext:context];
}

- (void)replaceTurnOffsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.turnOffs ofType:@"turnOff" named:@"turnOffs"
                          forDelegate:delegate withContext:context];
}

- (void)replaceTurnOnsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.turnOns ofType:@"turnOn" named:@"turnOns"
                          forDelegate:delegate withContext:context];
}

- (void)replaceTvShowsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.tvShows ofType:@"tvShow" named:@"tvShows"
                          forDelegate:delegate withContext:context];
}

- (void)replaceUrlsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.urls named:@"urls"
                    forDelegate:delegate withContext:context];
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"aboutMe"];
    [dict setObject:@"NSArray" forKey:@"accounts"];
    [dict setObject:@"NSArray" forKey:@"addresses"];
    [dict setObject:@"JRDate" forKey:@"anniversary"];
    [dict setObject:@"NSString" forKey:@"birthday"];
    [dict setObject:@"JRBodyType" forKey:@"bodyType"];
    [dict setObject:@"JRStringArray" forKey:@"books"];
    [dict setObject:@"JRStringArray" forKey:@"cars"];
    [dict setObject:@"JRStringArray" forKey:@"children"];
    [dict setObject:@"JRCurrentLocation" forKey:@"currentLocation"];
    [dict setObject:@"NSString" forKey:@"displayName"];
    [dict setObject:@"NSString" forKey:@"drinker"];
    [dict setObject:@"NSArray" forKey:@"emails"];
    [dict setObject:@"NSString" forKey:@"ethnicity"];
    [dict setObject:@"NSString" forKey:@"fashion"];
    [dict setObject:@"JRStringArray" forKey:@"food"];
    [dict setObject:@"NSString" forKey:@"gender"];
    [dict setObject:@"NSString" forKey:@"happiestWhen"];
    [dict setObject:@"JRStringArray" forKey:@"heroes"];
    [dict setObject:@"NSString" forKey:@"humor"];
    [dict setObject:@"NSArray" forKey:@"ims"];
    [dict setObject:@"NSString" forKey:@"interestedInMeeting"];
    [dict setObject:@"JRStringArray" forKey:@"interests"];
    [dict setObject:@"JRStringArray" forKey:@"jobInterests"];
    [dict setObject:@"JRStringArray" forKey:@"languages"];
    [dict setObject:@"JRStringArray" forKey:@"languagesSpoken"];
    [dict setObject:@"NSString" forKey:@"livingArrangement"];
    [dict setObject:@"JRStringArray" forKey:@"lookingFor"];
    [dict setObject:@"JRStringArray" forKey:@"movies"];
    [dict setObject:@"JRStringArray" forKey:@"music"];
    [dict setObject:@"JRName" forKey:@"name"];
    [dict setObject:@"NSString" forKey:@"nickname"];
    [dict setObject:@"NSString" forKey:@"note"];
    [dict setObject:@"NSArray" forKey:@"organizations"];
    [dict setObject:@"JRStringArray" forKey:@"pets"];
    [dict setObject:@"NSArray" forKey:@"phoneNumbers"];
    [dict setObject:@"NSArray" forKey:@"profilePhotos"];
    [dict setObject:@"NSString" forKey:@"politicalViews"];
    [dict setObject:@"NSString" forKey:@"preferredUsername"];
    [dict setObject:@"NSString" forKey:@"profileSong"];
    [dict setObject:@"NSString" forKey:@"profileUrl"];
    [dict setObject:@"NSString" forKey:@"profileVideo"];
    [dict setObject:@"JRDateTime" forKey:@"published"];
    [dict setObject:@"JRStringArray" forKey:@"quotes"];
    [dict setObject:@"NSString" forKey:@"relationshipStatus"];
    [dict setObject:@"JRStringArray" forKey:@"relationships"];
    [dict setObject:@"NSString" forKey:@"religion"];
    [dict setObject:@"NSString" forKey:@"romance"];
    [dict setObject:@"NSString" forKey:@"scaredOf"];
    [dict setObject:@"NSString" forKey:@"sexualOrientation"];
    [dict setObject:@"NSString" forKey:@"smoker"];
    [dict setObject:@"JRStringArray" forKey:@"sports"];
    [dict setObject:@"NSString" forKey:@"status"];
    [dict setObject:@"JRStringArray" forKey:@"tags"];
    [dict setObject:@"JRStringArray" forKey:@"turnOffs"];
    [dict setObject:@"JRStringArray" forKey:@"turnOns"];
    [dict setObject:@"JRStringArray" forKey:@"tvShows"];
    [dict setObject:@"JRDateTime" forKey:@"updated"];
    [dict setObject:@"NSArray" forKey:@"urls"];
    [dict setObject:@"NSString" forKey:@"utcOffset"];

    return [NSDictionary dictionaryWithDictionary:dict];
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
