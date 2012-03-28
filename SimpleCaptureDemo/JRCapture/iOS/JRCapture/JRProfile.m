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
- (NSArray*)arrayOfAccountsDictionariesFromAccountsObjects;
- (NSArray*)arrayOfAccountsObjectsFromAccountsDictionaries;
@end

@implementation NSArray (AccountsToFromDictionary)
- (NSArray*)arrayOfAccountsDictionariesFromAccountsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRAccounts class]])
            [filteredDictionaryArray addObject:[(JRAccounts*)object dictionaryFromAccountsObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfAccountsObjectsFromAccountsDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRAccounts accountsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (AddressesToFromDictionary)
- (NSArray*)arrayOfAddressesDictionariesFromAddressesObjects;
- (NSArray*)arrayOfAddressesObjectsFromAddressesDictionaries;
@end

@implementation NSArray (AddressesToFromDictionary)
- (NSArray*)arrayOfAddressesDictionariesFromAddressesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRAddresses class]])
            [filteredDictionaryArray addObject:[(JRAddresses*)object dictionaryFromAddressesObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfAddressesObjectsFromAddressesDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRAddresses addressesObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (BooksToFromDictionary)
- (NSArray*)arrayOfBooksDictionariesFromBooksObjects;
- (NSArray*)arrayOfBooksObjectsFromBooksDictionaries;
@end

@implementation NSArray (BooksToFromDictionary)
- (NSArray*)arrayOfBooksDictionariesFromBooksObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRBooks class]])
            [filteredDictionaryArray addObject:[(JRBooks*)object dictionaryFromBooksObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfBooksObjectsFromBooksDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRBooks booksObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (CarsToFromDictionary)
- (NSArray*)arrayOfCarsDictionariesFromCarsObjects;
- (NSArray*)arrayOfCarsObjectsFromCarsDictionaries;
@end

@implementation NSArray (CarsToFromDictionary)
- (NSArray*)arrayOfCarsDictionariesFromCarsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRCars class]])
            [filteredDictionaryArray addObject:[(JRCars*)object dictionaryFromCarsObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfCarsObjectsFromCarsDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRCars carsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (ChildrenToFromDictionary)
- (NSArray*)arrayOfChildrenDictionariesFromChildrenObjects;
- (NSArray*)arrayOfChildrenObjectsFromChildrenDictionaries;
@end

@implementation NSArray (ChildrenToFromDictionary)
- (NSArray*)arrayOfChildrenDictionariesFromChildrenObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRChildren class]])
            [filteredDictionaryArray addObject:[(JRChildren*)object dictionaryFromChildrenObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfChildrenObjectsFromChildrenDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRChildren childrenObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (EmailsToFromDictionary)
- (NSArray*)arrayOfEmailsDictionariesFromEmailsObjects;
- (NSArray*)arrayOfEmailsObjectsFromEmailsDictionaries;
@end

@implementation NSArray (EmailsToFromDictionary)
- (NSArray*)arrayOfEmailsDictionariesFromEmailsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JREmails class]])
            [filteredDictionaryArray addObject:[(JREmails*)object dictionaryFromEmailsObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfEmailsObjectsFromEmailsDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JREmails emailsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (FoodToFromDictionary)
- (NSArray*)arrayOfFoodDictionariesFromFoodObjects;
- (NSArray*)arrayOfFoodObjectsFromFoodDictionaries;
@end

@implementation NSArray (FoodToFromDictionary)
- (NSArray*)arrayOfFoodDictionariesFromFoodObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRFood class]])
            [filteredDictionaryArray addObject:[(JRFood*)object dictionaryFromFoodObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfFoodObjectsFromFoodDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRFood foodObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (HeroesToFromDictionary)
- (NSArray*)arrayOfHeroesDictionariesFromHeroesObjects;
- (NSArray*)arrayOfHeroesObjectsFromHeroesDictionaries;
@end

@implementation NSArray (HeroesToFromDictionary)
- (NSArray*)arrayOfHeroesDictionariesFromHeroesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRHeroes class]])
            [filteredDictionaryArray addObject:[(JRHeroes*)object dictionaryFromHeroesObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfHeroesObjectsFromHeroesDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRHeroes heroesObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (ImsToFromDictionary)
- (NSArray*)arrayOfImsDictionariesFromImsObjects;
- (NSArray*)arrayOfImsObjectsFromImsDictionaries;
@end

@implementation NSArray (ImsToFromDictionary)
- (NSArray*)arrayOfImsDictionariesFromImsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRIms class]])
            [filteredDictionaryArray addObject:[(JRIms*)object dictionaryFromImsObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfImsObjectsFromImsDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRIms imsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (InterestsToFromDictionary)
- (NSArray*)arrayOfInterestsDictionariesFromInterestsObjects;
- (NSArray*)arrayOfInterestsObjectsFromInterestsDictionaries;
@end

@implementation NSArray (InterestsToFromDictionary)
- (NSArray*)arrayOfInterestsDictionariesFromInterestsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRInterests class]])
            [filteredDictionaryArray addObject:[(JRInterests*)object dictionaryFromInterestsObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfInterestsObjectsFromInterestsDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRInterests interestsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (JobInterestsToFromDictionary)
- (NSArray*)arrayOfJobInterestsDictionariesFromJobInterestsObjects;
- (NSArray*)arrayOfJobInterestsObjectsFromJobInterestsDictionaries;
@end

@implementation NSArray (JobInterestsToFromDictionary)
- (NSArray*)arrayOfJobInterestsDictionariesFromJobInterestsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRJobInterests class]])
            [filteredDictionaryArray addObject:[(JRJobInterests*)object dictionaryFromJobInterestsObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfJobInterestsObjectsFromJobInterestsDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRJobInterests jobInterestsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (LanguagesToFromDictionary)
- (NSArray*)arrayOfLanguagesDictionariesFromLanguagesObjects;
- (NSArray*)arrayOfLanguagesObjectsFromLanguagesDictionaries;
@end

@implementation NSArray (LanguagesToFromDictionary)
- (NSArray*)arrayOfLanguagesDictionariesFromLanguagesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRLanguages class]])
            [filteredDictionaryArray addObject:[(JRLanguages*)object dictionaryFromLanguagesObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfLanguagesObjectsFromLanguagesDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRLanguages languagesObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (LanguagesSpokenToFromDictionary)
- (NSArray*)arrayOfLanguagesSpokenDictionariesFromLanguagesSpokenObjects;
- (NSArray*)arrayOfLanguagesSpokenObjectsFromLanguagesSpokenDictionaries;
@end

@implementation NSArray (LanguagesSpokenToFromDictionary)
- (NSArray*)arrayOfLanguagesSpokenDictionariesFromLanguagesSpokenObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRLanguagesSpoken class]])
            [filteredDictionaryArray addObject:[(JRLanguagesSpoken*)object dictionaryFromLanguagesSpokenObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfLanguagesSpokenObjectsFromLanguagesSpokenDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRLanguagesSpoken languagesSpokenObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (LookingForToFromDictionary)
- (NSArray*)arrayOfLookingForDictionariesFromLookingForObjects;
- (NSArray*)arrayOfLookingForObjectsFromLookingForDictionaries;
@end

@implementation NSArray (LookingForToFromDictionary)
- (NSArray*)arrayOfLookingForDictionariesFromLookingForObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRLookingFor class]])
            [filteredDictionaryArray addObject:[(JRLookingFor*)object dictionaryFromLookingForObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfLookingForObjectsFromLookingForDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRLookingFor lookingForObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (MoviesToFromDictionary)
- (NSArray*)arrayOfMoviesDictionariesFromMoviesObjects;
- (NSArray*)arrayOfMoviesObjectsFromMoviesDictionaries;
@end

@implementation NSArray (MoviesToFromDictionary)
- (NSArray*)arrayOfMoviesDictionariesFromMoviesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRMovies class]])
            [filteredDictionaryArray addObject:[(JRMovies*)object dictionaryFromMoviesObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfMoviesObjectsFromMoviesDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRMovies moviesObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (MusicToFromDictionary)
- (NSArray*)arrayOfMusicDictionariesFromMusicObjects;
- (NSArray*)arrayOfMusicObjectsFromMusicDictionaries;
@end

@implementation NSArray (MusicToFromDictionary)
- (NSArray*)arrayOfMusicDictionariesFromMusicObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRMusic class]])
            [filteredDictionaryArray addObject:[(JRMusic*)object dictionaryFromMusicObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfMusicObjectsFromMusicDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRMusic musicObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (OrganizationsToFromDictionary)
- (NSArray*)arrayOfOrganizationsDictionariesFromOrganizationsObjects;
- (NSArray*)arrayOfOrganizationsObjectsFromOrganizationsDictionaries;
@end

@implementation NSArray (OrganizationsToFromDictionary)
- (NSArray*)arrayOfOrganizationsDictionariesFromOrganizationsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROrganizations class]])
            [filteredDictionaryArray addObject:[(JROrganizations*)object dictionaryFromOrganizationsObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfOrganizationsObjectsFromOrganizationsDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JROrganizations organizationsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PetsToFromDictionary)
- (NSArray*)arrayOfPetsDictionariesFromPetsObjects;
- (NSArray*)arrayOfPetsObjectsFromPetsDictionaries;
@end

@implementation NSArray (PetsToFromDictionary)
- (NSArray*)arrayOfPetsDictionariesFromPetsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPets class]])
            [filteredDictionaryArray addObject:[(JRPets*)object dictionaryFromPetsObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPetsObjectsFromPetsDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRPets petsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (PhoneNumbersToFromDictionary)
- (NSArray*)arrayOfPhoneNumbersDictionariesFromPhoneNumbersObjects;
- (NSArray*)arrayOfPhoneNumbersObjectsFromPhoneNumbersDictionaries;
@end

@implementation NSArray (PhoneNumbersToFromDictionary)
- (NSArray*)arrayOfPhoneNumbersDictionariesFromPhoneNumbersObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhoneNumbers class]])
            [filteredDictionaryArray addObject:[(JRPhoneNumbers*)object dictionaryFromPhoneNumbersObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPhoneNumbersObjectsFromPhoneNumbersDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRPhoneNumbers phoneNumbersObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (ProfilePhotosToFromDictionary)
- (NSArray*)arrayOfProfilePhotosDictionariesFromProfilePhotosObjects;
- (NSArray*)arrayOfProfilePhotosObjectsFromProfilePhotosDictionaries;
@end

@implementation NSArray (ProfilePhotosToFromDictionary)
- (NSArray*)arrayOfProfilePhotosDictionariesFromProfilePhotosObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfilePhotos class]])
            [filteredDictionaryArray addObject:[(JRProfilePhotos*)object dictionaryFromProfilePhotosObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfProfilePhotosObjectsFromProfilePhotosDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRProfilePhotos profilePhotosObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (QuotesToFromDictionary)
- (NSArray*)arrayOfQuotesDictionariesFromQuotesObjects;
- (NSArray*)arrayOfQuotesObjectsFromQuotesDictionaries;
@end

@implementation NSArray (QuotesToFromDictionary)
- (NSArray*)arrayOfQuotesDictionariesFromQuotesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRQuotes class]])
            [filteredDictionaryArray addObject:[(JRQuotes*)object dictionaryFromQuotesObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfQuotesObjectsFromQuotesDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRQuotes quotesObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (RelationshipsToFromDictionary)
- (NSArray*)arrayOfRelationshipsDictionariesFromRelationshipsObjects;
- (NSArray*)arrayOfRelationshipsObjectsFromRelationshipsDictionaries;
@end

@implementation NSArray (RelationshipsToFromDictionary)
- (NSArray*)arrayOfRelationshipsDictionariesFromRelationshipsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRRelationships class]])
            [filteredDictionaryArray addObject:[(JRRelationships*)object dictionaryFromRelationshipsObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfRelationshipsObjectsFromRelationshipsDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRRelationships relationshipsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (SportsToFromDictionary)
- (NSArray*)arrayOfSportsDictionariesFromSportsObjects;
- (NSArray*)arrayOfSportsObjectsFromSportsDictionaries;
@end

@implementation NSArray (SportsToFromDictionary)
- (NSArray*)arrayOfSportsDictionariesFromSportsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRSports class]])
            [filteredDictionaryArray addObject:[(JRSports*)object dictionaryFromSportsObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfSportsObjectsFromSportsDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRSports sportsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (TagsToFromDictionary)
- (NSArray*)arrayOfTagsDictionariesFromTagsObjects;
- (NSArray*)arrayOfTagsObjectsFromTagsDictionaries;
@end

@implementation NSArray (TagsToFromDictionary)
- (NSArray*)arrayOfTagsDictionariesFromTagsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRTags class]])
            [filteredDictionaryArray addObject:[(JRTags*)object dictionaryFromTagsObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfTagsObjectsFromTagsDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRTags tagsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (TurnOffsToFromDictionary)
- (NSArray*)arrayOfTurnOffsDictionariesFromTurnOffsObjects;
- (NSArray*)arrayOfTurnOffsObjectsFromTurnOffsDictionaries;
@end

@implementation NSArray (TurnOffsToFromDictionary)
- (NSArray*)arrayOfTurnOffsDictionariesFromTurnOffsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRTurnOffs class]])
            [filteredDictionaryArray addObject:[(JRTurnOffs*)object dictionaryFromTurnOffsObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfTurnOffsObjectsFromTurnOffsDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRTurnOffs turnOffsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (TurnOnsToFromDictionary)
- (NSArray*)arrayOfTurnOnsDictionariesFromTurnOnsObjects;
- (NSArray*)arrayOfTurnOnsObjectsFromTurnOnsDictionaries;
@end

@implementation NSArray (TurnOnsToFromDictionary)
- (NSArray*)arrayOfTurnOnsDictionariesFromTurnOnsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRTurnOns class]])
            [filteredDictionaryArray addObject:[(JRTurnOns*)object dictionaryFromTurnOnsObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfTurnOnsObjectsFromTurnOnsDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRTurnOns turnOnsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (TvShowsToFromDictionary)
- (NSArray*)arrayOfTvShowsDictionariesFromTvShowsObjects;
- (NSArray*)arrayOfTvShowsObjectsFromTvShowsDictionaries;
@end

@implementation NSArray (TvShowsToFromDictionary)
- (NSArray*)arrayOfTvShowsDictionariesFromTvShowsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRTvShows class]])
            [filteredDictionaryArray addObject:[(JRTvShows*)object dictionaryFromTvShowsObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfTvShowsObjectsFromTvShowsDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRTvShows tvShowsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (UrlsToFromDictionary)
- (NSArray*)arrayOfUrlsDictionariesFromUrlsObjects;
- (NSArray*)arrayOfUrlsObjectsFromUrlsDictionaries;
@end

@implementation NSArray (UrlsToFromDictionary)
- (NSArray*)arrayOfUrlsDictionariesFromUrlsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRUrls class]])
            [filteredDictionaryArray addObject:[(JRUrls*)object dictionaryFromUrlsObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfUrlsObjectsFromUrlsDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRUrls urlsObjectFromDictionary:(NSDictionary*)dictionary]];

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

    if (!newAboutMe)
        _aboutMe = [NSNull null];
    else
        _aboutMe = [newAboutMe copy];
}

- (NSArray *)accounts
{
    return _accounts;
}

- (void)setAccounts:(NSArray *)newAccounts
{
    [self.dirtyPropertySet addObject:@"accounts"];

    if (!newAccounts)
        _accounts = [NSNull null];
    else
        _accounts = [newAccounts copy];
}

- (NSArray *)addresses
{
    return _addresses;
}

- (void)setAddresses:(NSArray *)newAddresses
{
    [self.dirtyPropertySet addObject:@"addresses"];

    if (!newAddresses)
        _addresses = [NSNull null];
    else
        _addresses = [newAddresses copy];
}

- (NSDate *)anniversary
{
    return _anniversary;
}

- (void)setAnniversary:(NSDate *)newAnniversary
{
    [self.dirtyPropertySet addObject:@"anniversary"];

    if (!newAnniversary)
        _anniversary = [NSNull null];
    else
        _anniversary = [newAnniversary copy];
}

- (NSString *)birthday
{
    return _birthday;
}

- (void)setBirthday:(NSString *)newBirthday
{
    [self.dirtyPropertySet addObject:@"birthday"];

    if (!newBirthday)
        _birthday = [NSNull null];
    else
        _birthday = [newBirthday copy];
}

- (JRBodyType *)bodyType
{
    return _bodyType;
}

- (void)setBodyType:(JRBodyType *)newBodyType
{
    [self.dirtyPropertySet addObject:@"bodyType"];

    if (!newBodyType)
        _bodyType = [NSNull null];
    else
        _bodyType = [newBodyType copy];
}

- (NSArray *)books
{
    return _books;
}

- (void)setBooks:(NSArray *)newBooks
{
    [self.dirtyPropertySet addObject:@"books"];

    if (!newBooks)
        _books = [NSNull null];
    else
        _books = [newBooks copy];
}

- (NSArray *)cars
{
    return _cars;
}

- (void)setCars:(NSArray *)newCars
{
    [self.dirtyPropertySet addObject:@"cars"];

    if (!newCars)
        _cars = [NSNull null];
    else
        _cars = [newCars copy];
}

- (NSArray *)children
{
    return _children;
}

- (void)setChildren:(NSArray *)newChildren
{
    [self.dirtyPropertySet addObject:@"children"];

    if (!newChildren)
        _children = [NSNull null];
    else
        _children = [newChildren copy];
}

- (JRCurrentLocation *)currentLocation
{
    return _currentLocation;
}

- (void)setCurrentLocation:(JRCurrentLocation *)newCurrentLocation
{
    [self.dirtyPropertySet addObject:@"currentLocation"];

    if (!newCurrentLocation)
        _currentLocation = [NSNull null];
    else
        _currentLocation = [newCurrentLocation copy];
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

- (NSString *)drinker
{
    return _drinker;
}

- (void)setDrinker:(NSString *)newDrinker
{
    [self.dirtyPropertySet addObject:@"drinker"];

    if (!newDrinker)
        _drinker = [NSNull null];
    else
        _drinker = [newDrinker copy];
}

- (NSArray *)emails
{
    return _emails;
}

- (void)setEmails:(NSArray *)newEmails
{
    [self.dirtyPropertySet addObject:@"emails"];

    if (!newEmails)
        _emails = [NSNull null];
    else
        _emails = [newEmails copy];
}

- (NSString *)ethnicity
{
    return _ethnicity;
}

- (void)setEthnicity:(NSString *)newEthnicity
{
    [self.dirtyPropertySet addObject:@"ethnicity"];

    if (!newEthnicity)
        _ethnicity = [NSNull null];
    else
        _ethnicity = [newEthnicity copy];
}

- (NSString *)fashion
{
    return _fashion;
}

- (void)setFashion:(NSString *)newFashion
{
    [self.dirtyPropertySet addObject:@"fashion"];

    if (!newFashion)
        _fashion = [NSNull null];
    else
        _fashion = [newFashion copy];
}

- (NSArray *)food
{
    return _food;
}

- (void)setFood:(NSArray *)newFood
{
    [self.dirtyPropertySet addObject:@"food"];

    if (!newFood)
        _food = [NSNull null];
    else
        _food = [newFood copy];
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

- (NSString *)happiestWhen
{
    return _happiestWhen;
}

- (void)setHappiestWhen:(NSString *)newHappiestWhen
{
    [self.dirtyPropertySet addObject:@"happiestWhen"];

    if (!newHappiestWhen)
        _happiestWhen = [NSNull null];
    else
        _happiestWhen = [newHappiestWhen copy];
}

- (NSArray *)heroes
{
    return _heroes;
}

- (void)setHeroes:(NSArray *)newHeroes
{
    [self.dirtyPropertySet addObject:@"heroes"];

    if (!newHeroes)
        _heroes = [NSNull null];
    else
        _heroes = [newHeroes copy];
}

- (NSString *)humor
{
    return _humor;
}

- (void)setHumor:(NSString *)newHumor
{
    [self.dirtyPropertySet addObject:@"humor"];

    if (!newHumor)
        _humor = [NSNull null];
    else
        _humor = [newHumor copy];
}

- (NSArray *)ims
{
    return _ims;
}

- (void)setIms:(NSArray *)newIms
{
    [self.dirtyPropertySet addObject:@"ims"];

    if (!newIms)
        _ims = [NSNull null];
    else
        _ims = [newIms copy];
}

- (NSString *)interestedInMeeting
{
    return _interestedInMeeting;
}

- (void)setInterestedInMeeting:(NSString *)newInterestedInMeeting
{
    [self.dirtyPropertySet addObject:@"interestedInMeeting"];

    if (!newInterestedInMeeting)
        _interestedInMeeting = [NSNull null];
    else
        _interestedInMeeting = [newInterestedInMeeting copy];
}

- (NSArray *)interests
{
    return _interests;
}

- (void)setInterests:(NSArray *)newInterests
{
    [self.dirtyPropertySet addObject:@"interests"];

    if (!newInterests)
        _interests = [NSNull null];
    else
        _interests = [newInterests copy];
}

- (NSArray *)jobInterests
{
    return _jobInterests;
}

- (void)setJobInterests:(NSArray *)newJobInterests
{
    [self.dirtyPropertySet addObject:@"jobInterests"];

    if (!newJobInterests)
        _jobInterests = [NSNull null];
    else
        _jobInterests = [newJobInterests copy];
}

- (NSArray *)languages
{
    return _languages;
}

- (void)setLanguages:(NSArray *)newLanguages
{
    [self.dirtyPropertySet addObject:@"languages"];

    if (!newLanguages)
        _languages = [NSNull null];
    else
        _languages = [newLanguages copy];
}

- (NSArray *)languagesSpoken
{
    return _languagesSpoken;
}

- (void)setLanguagesSpoken:(NSArray *)newLanguagesSpoken
{
    [self.dirtyPropertySet addObject:@"languagesSpoken"];

    if (!newLanguagesSpoken)
        _languagesSpoken = [NSNull null];
    else
        _languagesSpoken = [newLanguagesSpoken copy];
}

- (NSString *)livingArrangement
{
    return _livingArrangement;
}

- (void)setLivingArrangement:(NSString *)newLivingArrangement
{
    [self.dirtyPropertySet addObject:@"livingArrangement"];

    if (!newLivingArrangement)
        _livingArrangement = [NSNull null];
    else
        _livingArrangement = [newLivingArrangement copy];
}

- (NSArray *)lookingFor
{
    return _lookingFor;
}

- (void)setLookingFor:(NSArray *)newLookingFor
{
    [self.dirtyPropertySet addObject:@"lookingFor"];

    if (!newLookingFor)
        _lookingFor = [NSNull null];
    else
        _lookingFor = [newLookingFor copy];
}

- (NSArray *)movies
{
    return _movies;
}

- (void)setMovies:(NSArray *)newMovies
{
    [self.dirtyPropertySet addObject:@"movies"];

    if (!newMovies)
        _movies = [NSNull null];
    else
        _movies = [newMovies copy];
}

- (NSArray *)music
{
    return _music;
}

- (void)setMusic:(NSArray *)newMusic
{
    [self.dirtyPropertySet addObject:@"music"];

    if (!newMusic)
        _music = [NSNull null];
    else
        _music = [newMusic copy];
}

- (JRName *)name
{
    return _name;
}

- (void)setName:(JRName *)newName
{
    [self.dirtyPropertySet addObject:@"name"];

    if (!newName)
        _name = [NSNull null];
    else
        _name = [newName copy];
}

- (NSString *)nickname
{
    return _nickname;
}

- (void)setNickname:(NSString *)newNickname
{
    [self.dirtyPropertySet addObject:@"nickname"];

    if (!newNickname)
        _nickname = [NSNull null];
    else
        _nickname = [newNickname copy];
}

- (NSString *)note
{
    return _note;
}

- (void)setNote:(NSString *)newNote
{
    [self.dirtyPropertySet addObject:@"note"];

    if (!newNote)
        _note = [NSNull null];
    else
        _note = [newNote copy];
}

- (NSArray *)organizations
{
    return _organizations;
}

- (void)setOrganizations:(NSArray *)newOrganizations
{
    [self.dirtyPropertySet addObject:@"organizations"];

    if (!newOrganizations)
        _organizations = [NSNull null];
    else
        _organizations = [newOrganizations copy];
}

- (NSArray *)pets
{
    return _pets;
}

- (void)setPets:(NSArray *)newPets
{
    [self.dirtyPropertySet addObject:@"pets"];

    if (!newPets)
        _pets = [NSNull null];
    else
        _pets = [newPets copy];
}

- (NSArray *)phoneNumbers
{
    return _phoneNumbers;
}

- (void)setPhoneNumbers:(NSArray *)newPhoneNumbers
{
    [self.dirtyPropertySet addObject:@"phoneNumbers"];

    if (!newPhoneNumbers)
        _phoneNumbers = [NSNull null];
    else
        _phoneNumbers = [newPhoneNumbers copy];
}

- (NSArray *)profilePhotos
{
    return _profilePhotos;
}

- (void)setProfilePhotos:(NSArray *)newProfilePhotos
{
    [self.dirtyPropertySet addObject:@"profilePhotos"];

    if (!newProfilePhotos)
        _profilePhotos = [NSNull null];
    else
        _profilePhotos = [newProfilePhotos copy];
}

- (NSString *)politicalViews
{
    return _politicalViews;
}

- (void)setPoliticalViews:(NSString *)newPoliticalViews
{
    [self.dirtyPropertySet addObject:@"politicalViews"];

    if (!newPoliticalViews)
        _politicalViews = [NSNull null];
    else
        _politicalViews = [newPoliticalViews copy];
}

- (NSString *)preferredUsername
{
    return _preferredUsername;
}

- (void)setPreferredUsername:(NSString *)newPreferredUsername
{
    [self.dirtyPropertySet addObject:@"preferredUsername"];

    if (!newPreferredUsername)
        _preferredUsername = [NSNull null];
    else
        _preferredUsername = [newPreferredUsername copy];
}

- (NSString *)profileSong
{
    return _profileSong;
}

- (void)setProfileSong:(NSString *)newProfileSong
{
    [self.dirtyPropertySet addObject:@"profileSong"];

    if (!newProfileSong)
        _profileSong = [NSNull null];
    else
        _profileSong = [newProfileSong copy];
}

- (NSString *)profileUrl
{
    return _profileUrl;
}

- (void)setProfileUrl:(NSString *)newProfileUrl
{
    [self.dirtyPropertySet addObject:@"profileUrl"];

    if (!newProfileUrl)
        _profileUrl = [NSNull null];
    else
        _profileUrl = [newProfileUrl copy];
}

- (NSString *)profileVideo
{
    return _profileVideo;
}

- (void)setProfileVideo:(NSString *)newProfileVideo
{
    [self.dirtyPropertySet addObject:@"profileVideo"];

    if (!newProfileVideo)
        _profileVideo = [NSNull null];
    else
        _profileVideo = [newProfileVideo copy];
}

- (NSDate *)published
{
    return _published;
}

- (void)setPublished:(NSDate *)newPublished
{
    [self.dirtyPropertySet addObject:@"published"];

    if (!newPublished)
        _published = [NSNull null];
    else
        _published = [newPublished copy];
}

- (NSArray *)quotes
{
    return _quotes;
}

- (void)setQuotes:(NSArray *)newQuotes
{
    [self.dirtyPropertySet addObject:@"quotes"];

    if (!newQuotes)
        _quotes = [NSNull null];
    else
        _quotes = [newQuotes copy];
}

- (NSString *)relationshipStatus
{
    return _relationshipStatus;
}

- (void)setRelationshipStatus:(NSString *)newRelationshipStatus
{
    [self.dirtyPropertySet addObject:@"relationshipStatus"];

    if (!newRelationshipStatus)
        _relationshipStatus = [NSNull null];
    else
        _relationshipStatus = [newRelationshipStatus copy];
}

- (NSArray *)relationships
{
    return _relationships;
}

- (void)setRelationships:(NSArray *)newRelationships
{
    [self.dirtyPropertySet addObject:@"relationships"];

    if (!newRelationships)
        _relationships = [NSNull null];
    else
        _relationships = [newRelationships copy];
}

- (NSString *)religion
{
    return _religion;
}

- (void)setReligion:(NSString *)newReligion
{
    [self.dirtyPropertySet addObject:@"religion"];

    if (!newReligion)
        _religion = [NSNull null];
    else
        _religion = [newReligion copy];
}

- (NSString *)romance
{
    return _romance;
}

- (void)setRomance:(NSString *)newRomance
{
    [self.dirtyPropertySet addObject:@"romance"];

    if (!newRomance)
        _romance = [NSNull null];
    else
        _romance = [newRomance copy];
}

- (NSString *)scaredOf
{
    return _scaredOf;
}

- (void)setScaredOf:(NSString *)newScaredOf
{
    [self.dirtyPropertySet addObject:@"scaredOf"];

    if (!newScaredOf)
        _scaredOf = [NSNull null];
    else
        _scaredOf = [newScaredOf copy];
}

- (NSString *)sexualOrientation
{
    return _sexualOrientation;
}

- (void)setSexualOrientation:(NSString *)newSexualOrientation
{
    [self.dirtyPropertySet addObject:@"sexualOrientation"];

    if (!newSexualOrientation)
        _sexualOrientation = [NSNull null];
    else
        _sexualOrientation = [newSexualOrientation copy];
}

- (NSString *)smoker
{
    return _smoker;
}

- (void)setSmoker:(NSString *)newSmoker
{
    [self.dirtyPropertySet addObject:@"smoker"];

    if (!newSmoker)
        _smoker = [NSNull null];
    else
        _smoker = [newSmoker copy];
}

- (NSArray *)sports
{
    return _sports;
}

- (void)setSports:(NSArray *)newSports
{
    [self.dirtyPropertySet addObject:@"sports"];

    if (!newSports)
        _sports = [NSNull null];
    else
        _sports = [newSports copy];
}

- (NSString *)status
{
    return _status;
}

- (void)setStatus:(NSString *)newStatus
{
    [self.dirtyPropertySet addObject:@"status"];

    if (!newStatus)
        _status = [NSNull null];
    else
        _status = [newStatus copy];
}

- (NSArray *)tags
{
    return _tags;
}

- (void)setTags:(NSArray *)newTags
{
    [self.dirtyPropertySet addObject:@"tags"];

    if (!newTags)
        _tags = [NSNull null];
    else
        _tags = [newTags copy];
}

- (NSArray *)turnOffs
{
    return _turnOffs;
}

- (void)setTurnOffs:(NSArray *)newTurnOffs
{
    [self.dirtyPropertySet addObject:@"turnOffs"];

    if (!newTurnOffs)
        _turnOffs = [NSNull null];
    else
        _turnOffs = [newTurnOffs copy];
}

- (NSArray *)turnOns
{
    return _turnOns;
}

- (void)setTurnOns:(NSArray *)newTurnOns
{
    [self.dirtyPropertySet addObject:@"turnOns"];

    if (!newTurnOns)
        _turnOns = [NSNull null];
    else
        _turnOns = [newTurnOns copy];
}

- (NSArray *)tvShows
{
    return _tvShows;
}

- (void)setTvShows:(NSArray *)newTvShows
{
    [self.dirtyPropertySet addObject:@"tvShows"];

    if (!newTvShows)
        _tvShows = [NSNull null];
    else
        _tvShows = [newTvShows copy];
}

- (NSDate *)updated
{
    return _updated;
}

- (void)setUpdated:(NSDate *)newUpdated
{
    [self.dirtyPropertySet addObject:@"updated"];

    if (!newUpdated)
        _updated = [NSNull null];
    else
        _updated = [newUpdated copy];
}

- (NSArray *)urls
{
    return _urls;
}

- (void)setUrls:(NSArray *)newUrls
{
    [self.dirtyPropertySet addObject:@"urls"];

    if (!newUrls)
        _urls = [NSNull null];
    else
        _urls = [newUrls copy];
}

- (NSString *)utcOffset
{
    return _utcOffset;
}

- (void)setUtcOffset:(NSString *)newUtcOffset
{
    [self.dirtyPropertySet addObject:@"utcOffset"];

    if (!newUtcOffset)
        _utcOffset = [NSNull null];
    else
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
{
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

    return profileCopy;
}

+ (id)profileObjectFromDictionary:(NSDictionary*)dictionary
{
    JRProfile *profile =
        [JRProfile profile];

    profile.aboutMe = [dictionary objectForKey:@"aboutMe"];
    profile.accounts = [(NSArray*)[dictionary objectForKey:@"accounts"] arrayOfAccountsObjectsFromAccountsDictionaries];
    profile.addresses = [(NSArray*)[dictionary objectForKey:@"addresses"] arrayOfAddressesObjectsFromAddressesDictionaries];
    profile.anniversary = [NSDate dateFromISO8601DateString:[dictionary objectForKey:@"anniversary"]];
    profile.birthday = [dictionary objectForKey:@"birthday"];
    profile.bodyType = [JRBodyType bodyTypeObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"bodyType"]];
    profile.books = [(NSArray*)[dictionary objectForKey:@"books"] arrayOfBooksObjectsFromBooksDictionaries];
    profile.cars = [(NSArray*)[dictionary objectForKey:@"cars"] arrayOfCarsObjectsFromCarsDictionaries];
    profile.children = [(NSArray*)[dictionary objectForKey:@"children"] arrayOfChildrenObjectsFromChildrenDictionaries];
    profile.currentLocation = [JRCurrentLocation currentLocationObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"currentLocation"]];
    profile.displayName = [dictionary objectForKey:@"displayName"];
    profile.drinker = [dictionary objectForKey:@"drinker"];
    profile.emails = [(NSArray*)[dictionary objectForKey:@"emails"] arrayOfEmailsObjectsFromEmailsDictionaries];
    profile.ethnicity = [dictionary objectForKey:@"ethnicity"];
    profile.fashion = [dictionary objectForKey:@"fashion"];
    profile.food = [(NSArray*)[dictionary objectForKey:@"food"] arrayOfFoodObjectsFromFoodDictionaries];
    profile.gender = [dictionary objectForKey:@"gender"];
    profile.happiestWhen = [dictionary objectForKey:@"happiestWhen"];
    profile.heroes = [(NSArray*)[dictionary objectForKey:@"heroes"] arrayOfHeroesObjectsFromHeroesDictionaries];
    profile.humor = [dictionary objectForKey:@"humor"];
    profile.ims = [(NSArray*)[dictionary objectForKey:@"ims"] arrayOfImsObjectsFromImsDictionaries];
    profile.interestedInMeeting = [dictionary objectForKey:@"interestedInMeeting"];
    profile.interests = [(NSArray*)[dictionary objectForKey:@"interests"] arrayOfInterestsObjectsFromInterestsDictionaries];
    profile.jobInterests = [(NSArray*)[dictionary objectForKey:@"jobInterests"] arrayOfJobInterestsObjectsFromJobInterestsDictionaries];
    profile.languages = [(NSArray*)[dictionary objectForKey:@"languages"] arrayOfLanguagesObjectsFromLanguagesDictionaries];
    profile.languagesSpoken = [(NSArray*)[dictionary objectForKey:@"languagesSpoken"] arrayOfLanguagesSpokenObjectsFromLanguagesSpokenDictionaries];
    profile.livingArrangement = [dictionary objectForKey:@"livingArrangement"];
    profile.lookingFor = [(NSArray*)[dictionary objectForKey:@"lookingFor"] arrayOfLookingForObjectsFromLookingForDictionaries];
    profile.movies = [(NSArray*)[dictionary objectForKey:@"movies"] arrayOfMoviesObjectsFromMoviesDictionaries];
    profile.music = [(NSArray*)[dictionary objectForKey:@"music"] arrayOfMusicObjectsFromMusicDictionaries];
    profile.name = [JRName nameObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"name"]];
    profile.nickname = [dictionary objectForKey:@"nickname"];
    profile.note = [dictionary objectForKey:@"note"];
    profile.organizations = [(NSArray*)[dictionary objectForKey:@"organizations"] arrayOfOrganizationsObjectsFromOrganizationsDictionaries];
    profile.pets = [(NSArray*)[dictionary objectForKey:@"pets"] arrayOfPetsObjectsFromPetsDictionaries];
    profile.phoneNumbers = [(NSArray*)[dictionary objectForKey:@"phoneNumbers"] arrayOfPhoneNumbersObjectsFromPhoneNumbersDictionaries];
    profile.profilePhotos = [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfProfilePhotosObjectsFromProfilePhotosDictionaries];
    profile.politicalViews = [dictionary objectForKey:@"politicalViews"];
    profile.preferredUsername = [dictionary objectForKey:@"preferredUsername"];
    profile.profileSong = [dictionary objectForKey:@"profileSong"];
    profile.profileUrl = [dictionary objectForKey:@"profileUrl"];
    profile.profileVideo = [dictionary objectForKey:@"profileVideo"];
    profile.published = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"published"]];
    profile.quotes = [(NSArray*)[dictionary objectForKey:@"quotes"] arrayOfQuotesObjectsFromQuotesDictionaries];
    profile.relationshipStatus = [dictionary objectForKey:@"relationshipStatus"];
    profile.relationships = [(NSArray*)[dictionary objectForKey:@"relationships"] arrayOfRelationshipsObjectsFromRelationshipsDictionaries];
    profile.religion = [dictionary objectForKey:@"religion"];
    profile.romance = [dictionary objectForKey:@"romance"];
    profile.scaredOf = [dictionary objectForKey:@"scaredOf"];
    profile.sexualOrientation = [dictionary objectForKey:@"sexualOrientation"];
    profile.smoker = [dictionary objectForKey:@"smoker"];
    profile.sports = [(NSArray*)[dictionary objectForKey:@"sports"] arrayOfSportsObjectsFromSportsDictionaries];
    profile.status = [dictionary objectForKey:@"status"];
    profile.tags = [(NSArray*)[dictionary objectForKey:@"tags"] arrayOfTagsObjectsFromTagsDictionaries];
    profile.turnOffs = [(NSArray*)[dictionary objectForKey:@"turnOffs"] arrayOfTurnOffsObjectsFromTurnOffsDictionaries];
    profile.turnOns = [(NSArray*)[dictionary objectForKey:@"turnOns"] arrayOfTurnOnsObjectsFromTurnOnsDictionaries];
    profile.tvShows = [(NSArray*)[dictionary objectForKey:@"tvShows"] arrayOfTvShowsObjectsFromTvShowsDictionaries];
    profile.updated = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"updated"]];
    profile.urls = [(NSArray*)[dictionary objectForKey:@"urls"] arrayOfUrlsObjectsFromUrlsDictionaries];
    profile.utcOffset = [dictionary objectForKey:@"utcOffset"];

    return profile;
}

- (NSDictionary*)dictionaryFromProfileObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.aboutMe && self.aboutMe != [NSNull null])
        [dict setObject:self.aboutMe forKey:@"aboutMe"];
    else
        [dict setObject:[NSNull null] forKey:@"aboutMe"];

    if (self.accounts && self.accounts != [NSNull null])
        [dict setObject:[self.accounts arrayOfAccountsDictionariesFromAccountsObjects] forKey:@"accounts"];
    else
        [dict setObject:[NSNull null] forKey:@"accounts"];

    if (self.addresses && self.addresses != [NSNull null])
        [dict setObject:[self.addresses arrayOfAddressesDictionariesFromAddressesObjects] forKey:@"addresses"];
    else
        [dict setObject:[NSNull null] forKey:@"addresses"];

    if (self.anniversary && self.anniversary != [NSNull null])
        [dict setObject:[self.anniversary stringFromISO8601Date] forKey:@"anniversary"];
    else
        [dict setObject:[NSNull null] forKey:@"anniversary"];

    if (self.birthday && self.birthday != [NSNull null])
        [dict setObject:self.birthday forKey:@"birthday"];
    else
        [dict setObject:[NSNull null] forKey:@"birthday"];

    if (self.bodyType && self.bodyType != [NSNull null])
        [dict setObject:[self.bodyType dictionaryFromBodyTypeObject] forKey:@"bodyType"];
    else
        [dict setObject:[NSNull null] forKey:@"bodyType"];

    if (self.books && self.books != [NSNull null])
        [dict setObject:[self.books arrayOfBooksDictionariesFromBooksObjects] forKey:@"books"];
    else
        [dict setObject:[NSNull null] forKey:@"books"];

    if (self.cars && self.cars != [NSNull null])
        [dict setObject:[self.cars arrayOfCarsDictionariesFromCarsObjects] forKey:@"cars"];
    else
        [dict setObject:[NSNull null] forKey:@"cars"];

    if (self.children && self.children != [NSNull null])
        [dict setObject:[self.children arrayOfChildrenDictionariesFromChildrenObjects] forKey:@"children"];
    else
        [dict setObject:[NSNull null] forKey:@"children"];

    if (self.currentLocation && self.currentLocation != [NSNull null])
        [dict setObject:[self.currentLocation dictionaryFromCurrentLocationObject] forKey:@"currentLocation"];
    else
        [dict setObject:[NSNull null] forKey:@"currentLocation"];

    if (self.displayName && self.displayName != [NSNull null])
        [dict setObject:self.displayName forKey:@"displayName"];
    else
        [dict setObject:[NSNull null] forKey:@"displayName"];

    if (self.drinker && self.drinker != [NSNull null])
        [dict setObject:self.drinker forKey:@"drinker"];
    else
        [dict setObject:[NSNull null] forKey:@"drinker"];

    if (self.emails && self.emails != [NSNull null])
        [dict setObject:[self.emails arrayOfEmailsDictionariesFromEmailsObjects] forKey:@"emails"];
    else
        [dict setObject:[NSNull null] forKey:@"emails"];

    if (self.ethnicity && self.ethnicity != [NSNull null])
        [dict setObject:self.ethnicity forKey:@"ethnicity"];
    else
        [dict setObject:[NSNull null] forKey:@"ethnicity"];

    if (self.fashion && self.fashion != [NSNull null])
        [dict setObject:self.fashion forKey:@"fashion"];
    else
        [dict setObject:[NSNull null] forKey:@"fashion"];

    if (self.food && self.food != [NSNull null])
        [dict setObject:[self.food arrayOfFoodDictionariesFromFoodObjects] forKey:@"food"];
    else
        [dict setObject:[NSNull null] forKey:@"food"];

    if (self.gender && self.gender != [NSNull null])
        [dict setObject:self.gender forKey:@"gender"];
    else
        [dict setObject:[NSNull null] forKey:@"gender"];

    if (self.happiestWhen && self.happiestWhen != [NSNull null])
        [dict setObject:self.happiestWhen forKey:@"happiestWhen"];
    else
        [dict setObject:[NSNull null] forKey:@"happiestWhen"];

    if (self.heroes && self.heroes != [NSNull null])
        [dict setObject:[self.heroes arrayOfHeroesDictionariesFromHeroesObjects] forKey:@"heroes"];
    else
        [dict setObject:[NSNull null] forKey:@"heroes"];

    if (self.humor && self.humor != [NSNull null])
        [dict setObject:self.humor forKey:@"humor"];
    else
        [dict setObject:[NSNull null] forKey:@"humor"];

    if (self.ims && self.ims != [NSNull null])
        [dict setObject:[self.ims arrayOfImsDictionariesFromImsObjects] forKey:@"ims"];
    else
        [dict setObject:[NSNull null] forKey:@"ims"];

    if (self.interestedInMeeting && self.interestedInMeeting != [NSNull null])
        [dict setObject:self.interestedInMeeting forKey:@"interestedInMeeting"];
    else
        [dict setObject:[NSNull null] forKey:@"interestedInMeeting"];

    if (self.interests && self.interests != [NSNull null])
        [dict setObject:[self.interests arrayOfInterestsDictionariesFromInterestsObjects] forKey:@"interests"];
    else
        [dict setObject:[NSNull null] forKey:@"interests"];

    if (self.jobInterests && self.jobInterests != [NSNull null])
        [dict setObject:[self.jobInterests arrayOfJobInterestsDictionariesFromJobInterestsObjects] forKey:@"jobInterests"];
    else
        [dict setObject:[NSNull null] forKey:@"jobInterests"];

    if (self.languages && self.languages != [NSNull null])
        [dict setObject:[self.languages arrayOfLanguagesDictionariesFromLanguagesObjects] forKey:@"languages"];
    else
        [dict setObject:[NSNull null] forKey:@"languages"];

    if (self.languagesSpoken && self.languagesSpoken != [NSNull null])
        [dict setObject:[self.languagesSpoken arrayOfLanguagesSpokenDictionariesFromLanguagesSpokenObjects] forKey:@"languagesSpoken"];
    else
        [dict setObject:[NSNull null] forKey:@"languagesSpoken"];

    if (self.livingArrangement && self.livingArrangement != [NSNull null])
        [dict setObject:self.livingArrangement forKey:@"livingArrangement"];
    else
        [dict setObject:[NSNull null] forKey:@"livingArrangement"];

    if (self.lookingFor && self.lookingFor != [NSNull null])
        [dict setObject:[self.lookingFor arrayOfLookingForDictionariesFromLookingForObjects] forKey:@"lookingFor"];
    else
        [dict setObject:[NSNull null] forKey:@"lookingFor"];

    if (self.movies && self.movies != [NSNull null])
        [dict setObject:[self.movies arrayOfMoviesDictionariesFromMoviesObjects] forKey:@"movies"];
    else
        [dict setObject:[NSNull null] forKey:@"movies"];

    if (self.music && self.music != [NSNull null])
        [dict setObject:[self.music arrayOfMusicDictionariesFromMusicObjects] forKey:@"music"];
    else
        [dict setObject:[NSNull null] forKey:@"music"];

    if (self.name && self.name != [NSNull null])
        [dict setObject:[self.name dictionaryFromNameObject] forKey:@"name"];
    else
        [dict setObject:[NSNull null] forKey:@"name"];

    if (self.nickname && self.nickname != [NSNull null])
        [dict setObject:self.nickname forKey:@"nickname"];
    else
        [dict setObject:[NSNull null] forKey:@"nickname"];

    if (self.note && self.note != [NSNull null])
        [dict setObject:self.note forKey:@"note"];
    else
        [dict setObject:[NSNull null] forKey:@"note"];

    if (self.organizations && self.organizations != [NSNull null])
        [dict setObject:[self.organizations arrayOfOrganizationsDictionariesFromOrganizationsObjects] forKey:@"organizations"];
    else
        [dict setObject:[NSNull null] forKey:@"organizations"];

    if (self.pets && self.pets != [NSNull null])
        [dict setObject:[self.pets arrayOfPetsDictionariesFromPetsObjects] forKey:@"pets"];
    else
        [dict setObject:[NSNull null] forKey:@"pets"];

    if (self.phoneNumbers && self.phoneNumbers != [NSNull null])
        [dict setObject:[self.phoneNumbers arrayOfPhoneNumbersDictionariesFromPhoneNumbersObjects] forKey:@"phoneNumbers"];
    else
        [dict setObject:[NSNull null] forKey:@"phoneNumbers"];

    if (self.profilePhotos && self.profilePhotos != [NSNull null])
        [dict setObject:[self.profilePhotos arrayOfProfilePhotosDictionariesFromProfilePhotosObjects] forKey:@"photos"];
    else
        [dict setObject:[NSNull null] forKey:@"photos"];

    if (self.politicalViews && self.politicalViews != [NSNull null])
        [dict setObject:self.politicalViews forKey:@"politicalViews"];
    else
        [dict setObject:[NSNull null] forKey:@"politicalViews"];

    if (self.preferredUsername && self.preferredUsername != [NSNull null])
        [dict setObject:self.preferredUsername forKey:@"preferredUsername"];
    else
        [dict setObject:[NSNull null] forKey:@"preferredUsername"];

    if (self.profileSong && self.profileSong != [NSNull null])
        [dict setObject:self.profileSong forKey:@"profileSong"];
    else
        [dict setObject:[NSNull null] forKey:@"profileSong"];

    if (self.profileUrl && self.profileUrl != [NSNull null])
        [dict setObject:self.profileUrl forKey:@"profileUrl"];
    else
        [dict setObject:[NSNull null] forKey:@"profileUrl"];

    if (self.profileVideo && self.profileVideo != [NSNull null])
        [dict setObject:self.profileVideo forKey:@"profileVideo"];
    else
        [dict setObject:[NSNull null] forKey:@"profileVideo"];

    if (self.published && self.published != [NSNull null])
        [dict setObject:[self.published stringFromISO8601DateTime] forKey:@"published"];
    else
        [dict setObject:[NSNull null] forKey:@"published"];

    if (self.quotes && self.quotes != [NSNull null])
        [dict setObject:[self.quotes arrayOfQuotesDictionariesFromQuotesObjects] forKey:@"quotes"];
    else
        [dict setObject:[NSNull null] forKey:@"quotes"];

    if (self.relationshipStatus && self.relationshipStatus != [NSNull null])
        [dict setObject:self.relationshipStatus forKey:@"relationshipStatus"];
    else
        [dict setObject:[NSNull null] forKey:@"relationshipStatus"];

    if (self.relationships && self.relationships != [NSNull null])
        [dict setObject:[self.relationships arrayOfRelationshipsDictionariesFromRelationshipsObjects] forKey:@"relationships"];
    else
        [dict setObject:[NSNull null] forKey:@"relationships"];

    if (self.religion && self.religion != [NSNull null])
        [dict setObject:self.religion forKey:@"religion"];
    else
        [dict setObject:[NSNull null] forKey:@"religion"];

    if (self.romance && self.romance != [NSNull null])
        [dict setObject:self.romance forKey:@"romance"];
    else
        [dict setObject:[NSNull null] forKey:@"romance"];

    if (self.scaredOf && self.scaredOf != [NSNull null])
        [dict setObject:self.scaredOf forKey:@"scaredOf"];
    else
        [dict setObject:[NSNull null] forKey:@"scaredOf"];

    if (self.sexualOrientation && self.sexualOrientation != [NSNull null])
        [dict setObject:self.sexualOrientation forKey:@"sexualOrientation"];
    else
        [dict setObject:[NSNull null] forKey:@"sexualOrientation"];

    if (self.smoker && self.smoker != [NSNull null])
        [dict setObject:self.smoker forKey:@"smoker"];
    else
        [dict setObject:[NSNull null] forKey:@"smoker"];

    if (self.sports && self.sports != [NSNull null])
        [dict setObject:[self.sports arrayOfSportsDictionariesFromSportsObjects] forKey:@"sports"];
    else
        [dict setObject:[NSNull null] forKey:@"sports"];

    if (self.status && self.status != [NSNull null])
        [dict setObject:self.status forKey:@"status"];
    else
        [dict setObject:[NSNull null] forKey:@"status"];

    if (self.tags && self.tags != [NSNull null])
        [dict setObject:[self.tags arrayOfTagsDictionariesFromTagsObjects] forKey:@"tags"];
    else
        [dict setObject:[NSNull null] forKey:@"tags"];

    if (self.turnOffs && self.turnOffs != [NSNull null])
        [dict setObject:[self.turnOffs arrayOfTurnOffsDictionariesFromTurnOffsObjects] forKey:@"turnOffs"];
    else
        [dict setObject:[NSNull null] forKey:@"turnOffs"];

    if (self.turnOns && self.turnOns != [NSNull null])
        [dict setObject:[self.turnOns arrayOfTurnOnsDictionariesFromTurnOnsObjects] forKey:@"turnOns"];
    else
        [dict setObject:[NSNull null] forKey:@"turnOns"];

    if (self.tvShows && self.tvShows != [NSNull null])
        [dict setObject:[self.tvShows arrayOfTvShowsDictionariesFromTvShowsObjects] forKey:@"tvShows"];
    else
        [dict setObject:[NSNull null] forKey:@"tvShows"];

    if (self.updated && self.updated != [NSNull null])
        [dict setObject:[self.updated stringFromISO8601DateTime] forKey:@"updated"];
    else
        [dict setObject:[NSNull null] forKey:@"updated"];

    if (self.urls && self.urls != [NSNull null])
        [dict setObject:[self.urls arrayOfUrlsDictionariesFromUrlsObjects] forKey:@"urls"];
    else
        [dict setObject:[NSNull null] forKey:@"urls"];

    if (self.utcOffset && self.utcOffset != [NSNull null])
        [dict setObject:self.utcOffset forKey:@"utcOffset"];
    else
        [dict setObject:[NSNull null] forKey:@"utcOffset"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"aboutMe"])
        _aboutMe = [dictionary objectForKey:@"aboutMe"];

    if ([dictionary objectForKey:@"accounts"])
        _accounts = [(NSArray*)[dictionary objectForKey:@"accounts"] arrayOfAccountsObjectsFromAccountsDictionaries];

    if ([dictionary objectForKey:@"addresses"])
        _addresses = [(NSArray*)[dictionary objectForKey:@"addresses"] arrayOfAddressesObjectsFromAddressesDictionaries];

    if ([dictionary objectForKey:@"anniversary"])
        _anniversary = [NSDate dateFromISO8601DateString:[dictionary objectForKey:@"anniversary"]];

    if ([dictionary objectForKey:@"birthday"])
        _birthday = [dictionary objectForKey:@"birthday"];

    if ([dictionary objectForKey:@"bodyType"])
        _bodyType = [JRBodyType bodyTypeObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"bodyType"]];

    if ([dictionary objectForKey:@"books"])
        _books = [(NSArray*)[dictionary objectForKey:@"books"] arrayOfBooksObjectsFromBooksDictionaries];

    if ([dictionary objectForKey:@"cars"])
        _cars = [(NSArray*)[dictionary objectForKey:@"cars"] arrayOfCarsObjectsFromCarsDictionaries];

    if ([dictionary objectForKey:@"children"])
        _children = [(NSArray*)[dictionary objectForKey:@"children"] arrayOfChildrenObjectsFromChildrenDictionaries];

    if ([dictionary objectForKey:@"currentLocation"])
        _currentLocation = [JRCurrentLocation currentLocationObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"currentLocation"]];

    if ([dictionary objectForKey:@"displayName"])
        _displayName = [dictionary objectForKey:@"displayName"];

    if ([dictionary objectForKey:@"drinker"])
        _drinker = [dictionary objectForKey:@"drinker"];

    if ([dictionary objectForKey:@"emails"])
        _emails = [(NSArray*)[dictionary objectForKey:@"emails"] arrayOfEmailsObjectsFromEmailsDictionaries];

    if ([dictionary objectForKey:@"ethnicity"])
        _ethnicity = [dictionary objectForKey:@"ethnicity"];

    if ([dictionary objectForKey:@"fashion"])
        _fashion = [dictionary objectForKey:@"fashion"];

    if ([dictionary objectForKey:@"food"])
        _food = [(NSArray*)[dictionary objectForKey:@"food"] arrayOfFoodObjectsFromFoodDictionaries];

    if ([dictionary objectForKey:@"gender"])
        _gender = [dictionary objectForKey:@"gender"];

    if ([dictionary objectForKey:@"happiestWhen"])
        _happiestWhen = [dictionary objectForKey:@"happiestWhen"];

    if ([dictionary objectForKey:@"heroes"])
        _heroes = [(NSArray*)[dictionary objectForKey:@"heroes"] arrayOfHeroesObjectsFromHeroesDictionaries];

    if ([dictionary objectForKey:@"humor"])
        _humor = [dictionary objectForKey:@"humor"];

    if ([dictionary objectForKey:@"ims"])
        _ims = [(NSArray*)[dictionary objectForKey:@"ims"] arrayOfImsObjectsFromImsDictionaries];

    if ([dictionary objectForKey:@"interestedInMeeting"])
        _interestedInMeeting = [dictionary objectForKey:@"interestedInMeeting"];

    if ([dictionary objectForKey:@"interests"])
        _interests = [(NSArray*)[dictionary objectForKey:@"interests"] arrayOfInterestsObjectsFromInterestsDictionaries];

    if ([dictionary objectForKey:@"jobInterests"])
        _jobInterests = [(NSArray*)[dictionary objectForKey:@"jobInterests"] arrayOfJobInterestsObjectsFromJobInterestsDictionaries];

    if ([dictionary objectForKey:@"languages"])
        _languages = [(NSArray*)[dictionary objectForKey:@"languages"] arrayOfLanguagesObjectsFromLanguagesDictionaries];

    if ([dictionary objectForKey:@"languagesSpoken"])
        _languagesSpoken = [(NSArray*)[dictionary objectForKey:@"languagesSpoken"] arrayOfLanguagesSpokenObjectsFromLanguagesSpokenDictionaries];

    if ([dictionary objectForKey:@"livingArrangement"])
        _livingArrangement = [dictionary objectForKey:@"livingArrangement"];

    if ([dictionary objectForKey:@"lookingFor"])
        _lookingFor = [(NSArray*)[dictionary objectForKey:@"lookingFor"] arrayOfLookingForObjectsFromLookingForDictionaries];

    if ([dictionary objectForKey:@"movies"])
        _movies = [(NSArray*)[dictionary objectForKey:@"movies"] arrayOfMoviesObjectsFromMoviesDictionaries];

    if ([dictionary objectForKey:@"music"])
        _music = [(NSArray*)[dictionary objectForKey:@"music"] arrayOfMusicObjectsFromMusicDictionaries];

    if ([dictionary objectForKey:@"name"])
        _name = [JRName nameObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"name"]];

    if ([dictionary objectForKey:@"nickname"])
        _nickname = [dictionary objectForKey:@"nickname"];

    if ([dictionary objectForKey:@"note"])
        _note = [dictionary objectForKey:@"note"];

    if ([dictionary objectForKey:@"organizations"])
        _organizations = [(NSArray*)[dictionary objectForKey:@"organizations"] arrayOfOrganizationsObjectsFromOrganizationsDictionaries];

    if ([dictionary objectForKey:@"pets"])
        _pets = [(NSArray*)[dictionary objectForKey:@"pets"] arrayOfPetsObjectsFromPetsDictionaries];

    if ([dictionary objectForKey:@"phoneNumbers"])
        _phoneNumbers = [(NSArray*)[dictionary objectForKey:@"phoneNumbers"] arrayOfPhoneNumbersObjectsFromPhoneNumbersDictionaries];

    if ([dictionary objectForKey:@"photos"])
        _profilePhotos = [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfProfilePhotosObjectsFromProfilePhotosDictionaries];

    if ([dictionary objectForKey:@"politicalViews"])
        _politicalViews = [dictionary objectForKey:@"politicalViews"];

    if ([dictionary objectForKey:@"preferredUsername"])
        _preferredUsername = [dictionary objectForKey:@"preferredUsername"];

    if ([dictionary objectForKey:@"profileSong"])
        _profileSong = [dictionary objectForKey:@"profileSong"];

    if ([dictionary objectForKey:@"profileUrl"])
        _profileUrl = [dictionary objectForKey:@"profileUrl"];

    if ([dictionary objectForKey:@"profileVideo"])
        _profileVideo = [dictionary objectForKey:@"profileVideo"];

    if ([dictionary objectForKey:@"published"])
        _published = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"published"]];

    if ([dictionary objectForKey:@"quotes"])
        _quotes = [(NSArray*)[dictionary objectForKey:@"quotes"] arrayOfQuotesObjectsFromQuotesDictionaries];

    if ([dictionary objectForKey:@"relationshipStatus"])
        _relationshipStatus = [dictionary objectForKey:@"relationshipStatus"];

    if ([dictionary objectForKey:@"relationships"])
        _relationships = [(NSArray*)[dictionary objectForKey:@"relationships"] arrayOfRelationshipsObjectsFromRelationshipsDictionaries];

    if ([dictionary objectForKey:@"religion"])
        _religion = [dictionary objectForKey:@"religion"];

    if ([dictionary objectForKey:@"romance"])
        _romance = [dictionary objectForKey:@"romance"];

    if ([dictionary objectForKey:@"scaredOf"])
        _scaredOf = [dictionary objectForKey:@"scaredOf"];

    if ([dictionary objectForKey:@"sexualOrientation"])
        _sexualOrientation = [dictionary objectForKey:@"sexualOrientation"];

    if ([dictionary objectForKey:@"smoker"])
        _smoker = [dictionary objectForKey:@"smoker"];

    if ([dictionary objectForKey:@"sports"])
        _sports = [(NSArray*)[dictionary objectForKey:@"sports"] arrayOfSportsObjectsFromSportsDictionaries];

    if ([dictionary objectForKey:@"status"])
        _status = [dictionary objectForKey:@"status"];

    if ([dictionary objectForKey:@"tags"])
        _tags = [(NSArray*)[dictionary objectForKey:@"tags"] arrayOfTagsObjectsFromTagsDictionaries];

    if ([dictionary objectForKey:@"turnOffs"])
        _turnOffs = [(NSArray*)[dictionary objectForKey:@"turnOffs"] arrayOfTurnOffsObjectsFromTurnOffsDictionaries];

    if ([dictionary objectForKey:@"turnOns"])
        _turnOns = [(NSArray*)[dictionary objectForKey:@"turnOns"] arrayOfTurnOnsObjectsFromTurnOnsDictionaries];

    if ([dictionary objectForKey:@"tvShows"])
        _tvShows = [(NSArray*)[dictionary objectForKey:@"tvShows"] arrayOfTvShowsObjectsFromTvShowsDictionaries];

    if ([dictionary objectForKey:@"updated"])
        _updated = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"updated"]];

    if ([dictionary objectForKey:@"urls"])
        _urls = [(NSArray*)[dictionary objectForKey:@"urls"] arrayOfUrlsObjectsFromUrlsDictionaries];

    if ([dictionary objectForKey:@"utcOffset"])
        _utcOffset = [dictionary objectForKey:@"utcOffset"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    _aboutMe = [dictionary objectForKey:@"aboutMe"];
    _accounts = [(NSArray*)[dictionary objectForKey:@"accounts"] arrayOfAccountsObjectsFromAccountsDictionaries];
    _addresses = [(NSArray*)[dictionary objectForKey:@"addresses"] arrayOfAddressesObjectsFromAddressesDictionaries];
    _anniversary = [NSDate dateFromISO8601DateString:[dictionary objectForKey:@"anniversary"]];
    _birthday = [dictionary objectForKey:@"birthday"];
    _bodyType = [JRBodyType bodyTypeObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"bodyType"]];
    _books = [(NSArray*)[dictionary objectForKey:@"books"] arrayOfBooksObjectsFromBooksDictionaries];
    _cars = [(NSArray*)[dictionary objectForKey:@"cars"] arrayOfCarsObjectsFromCarsDictionaries];
    _children = [(NSArray*)[dictionary objectForKey:@"children"] arrayOfChildrenObjectsFromChildrenDictionaries];
    _currentLocation = [JRCurrentLocation currentLocationObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"currentLocation"]];
    _displayName = [dictionary objectForKey:@"displayName"];
    _drinker = [dictionary objectForKey:@"drinker"];
    _emails = [(NSArray*)[dictionary objectForKey:@"emails"] arrayOfEmailsObjectsFromEmailsDictionaries];
    _ethnicity = [dictionary objectForKey:@"ethnicity"];
    _fashion = [dictionary objectForKey:@"fashion"];
    _food = [(NSArray*)[dictionary objectForKey:@"food"] arrayOfFoodObjectsFromFoodDictionaries];
    _gender = [dictionary objectForKey:@"gender"];
    _happiestWhen = [dictionary objectForKey:@"happiestWhen"];
    _heroes = [(NSArray*)[dictionary objectForKey:@"heroes"] arrayOfHeroesObjectsFromHeroesDictionaries];
    _humor = [dictionary objectForKey:@"humor"];
    _ims = [(NSArray*)[dictionary objectForKey:@"ims"] arrayOfImsObjectsFromImsDictionaries];
    _interestedInMeeting = [dictionary objectForKey:@"interestedInMeeting"];
    _interests = [(NSArray*)[dictionary objectForKey:@"interests"] arrayOfInterestsObjectsFromInterestsDictionaries];
    _jobInterests = [(NSArray*)[dictionary objectForKey:@"jobInterests"] arrayOfJobInterestsObjectsFromJobInterestsDictionaries];
    _languages = [(NSArray*)[dictionary objectForKey:@"languages"] arrayOfLanguagesObjectsFromLanguagesDictionaries];
    _languagesSpoken = [(NSArray*)[dictionary objectForKey:@"languagesSpoken"] arrayOfLanguagesSpokenObjectsFromLanguagesSpokenDictionaries];
    _livingArrangement = [dictionary objectForKey:@"livingArrangement"];
    _lookingFor = [(NSArray*)[dictionary objectForKey:@"lookingFor"] arrayOfLookingForObjectsFromLookingForDictionaries];
    _movies = [(NSArray*)[dictionary objectForKey:@"movies"] arrayOfMoviesObjectsFromMoviesDictionaries];
    _music = [(NSArray*)[dictionary objectForKey:@"music"] arrayOfMusicObjectsFromMusicDictionaries];
    _name = [JRName nameObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"name"]];
    _nickname = [dictionary objectForKey:@"nickname"];
    _note = [dictionary objectForKey:@"note"];
    _organizations = [(NSArray*)[dictionary objectForKey:@"organizations"] arrayOfOrganizationsObjectsFromOrganizationsDictionaries];
    _pets = [(NSArray*)[dictionary objectForKey:@"pets"] arrayOfPetsObjectsFromPetsDictionaries];
    _phoneNumbers = [(NSArray*)[dictionary objectForKey:@"phoneNumbers"] arrayOfPhoneNumbersObjectsFromPhoneNumbersDictionaries];
    _profilePhotos = [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfProfilePhotosObjectsFromProfilePhotosDictionaries];
    _politicalViews = [dictionary objectForKey:@"politicalViews"];
    _preferredUsername = [dictionary objectForKey:@"preferredUsername"];
    _profileSong = [dictionary objectForKey:@"profileSong"];
    _profileUrl = [dictionary objectForKey:@"profileUrl"];
    _profileVideo = [dictionary objectForKey:@"profileVideo"];
    _published = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"published"]];
    _quotes = [(NSArray*)[dictionary objectForKey:@"quotes"] arrayOfQuotesObjectsFromQuotesDictionaries];
    _relationshipStatus = [dictionary objectForKey:@"relationshipStatus"];
    _relationships = [(NSArray*)[dictionary objectForKey:@"relationships"] arrayOfRelationshipsObjectsFromRelationshipsDictionaries];
    _religion = [dictionary objectForKey:@"religion"];
    _romance = [dictionary objectForKey:@"romance"];
    _scaredOf = [dictionary objectForKey:@"scaredOf"];
    _sexualOrientation = [dictionary objectForKey:@"sexualOrientation"];
    _smoker = [dictionary objectForKey:@"smoker"];
    _sports = [(NSArray*)[dictionary objectForKey:@"sports"] arrayOfSportsObjectsFromSportsDictionaries];
    _status = [dictionary objectForKey:@"status"];
    _tags = [(NSArray*)[dictionary objectForKey:@"tags"] arrayOfTagsObjectsFromTagsDictionaries];
    _turnOffs = [(NSArray*)[dictionary objectForKey:@"turnOffs"] arrayOfTurnOffsObjectsFromTurnOffsDictionaries];
    _turnOns = [(NSArray*)[dictionary objectForKey:@"turnOns"] arrayOfTurnOnsObjectsFromTurnOnsDictionaries];
    _tvShows = [(NSArray*)[dictionary objectForKey:@"tvShows"] arrayOfTvShowsObjectsFromTvShowsDictionaries];
    _updated = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"updated"]];
    _urls = [(NSArray*)[dictionary objectForKey:@"urls"] arrayOfUrlsObjectsFromUrlsDictionaries];
    _utcOffset = [dictionary objectForKey:@"utcOffset"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"aboutMe"])
        [dict setObject:self.aboutMe forKey:@"aboutMe"];

    if ([self.dirtyPropertySet containsObject:@"accounts"])
        [dict setObject:[self.accounts arrayOfAccountsDictionariesFromAccountsObjects] forKey:@"accounts"];

    if ([self.dirtyPropertySet containsObject:@"addresses"])
        [dict setObject:[self.addresses arrayOfAddressesDictionariesFromAddressesObjects] forKey:@"addresses"];

    if ([self.dirtyPropertySet containsObject:@"anniversary"])
        [dict setObject:[self.anniversary stringFromISO8601Date] forKey:@"anniversary"];

    if ([self.dirtyPropertySet containsObject:@"birthday"])
        [dict setObject:self.birthday forKey:@"birthday"];

    if ([self.dirtyPropertySet containsObject:@"bodyType"])
        [dict setObject:[self.bodyType dictionaryFromBodyTypeObject] forKey:@"bodyType"];

    if ([self.dirtyPropertySet containsObject:@"books"])
        [dict setObject:[self.books arrayOfBooksDictionariesFromBooksObjects] forKey:@"books"];

    if ([self.dirtyPropertySet containsObject:@"cars"])
        [dict setObject:[self.cars arrayOfCarsDictionariesFromCarsObjects] forKey:@"cars"];

    if ([self.dirtyPropertySet containsObject:@"children"])
        [dict setObject:[self.children arrayOfChildrenDictionariesFromChildrenObjects] forKey:@"children"];

    if ([self.dirtyPropertySet containsObject:@"currentLocation"])
        [dict setObject:[self.currentLocation dictionaryFromCurrentLocationObject] forKey:@"currentLocation"];

    if ([self.dirtyPropertySet containsObject:@"displayName"])
        [dict setObject:self.displayName forKey:@"displayName"];

    if ([self.dirtyPropertySet containsObject:@"drinker"])
        [dict setObject:self.drinker forKey:@"drinker"];

    if ([self.dirtyPropertySet containsObject:@"emails"])
        [dict setObject:[self.emails arrayOfEmailsDictionariesFromEmailsObjects] forKey:@"emails"];

    if ([self.dirtyPropertySet containsObject:@"ethnicity"])
        [dict setObject:self.ethnicity forKey:@"ethnicity"];

    if ([self.dirtyPropertySet containsObject:@"fashion"])
        [dict setObject:self.fashion forKey:@"fashion"];

    if ([self.dirtyPropertySet containsObject:@"food"])
        [dict setObject:[self.food arrayOfFoodDictionariesFromFoodObjects] forKey:@"food"];

    if ([self.dirtyPropertySet containsObject:@"gender"])
        [dict setObject:self.gender forKey:@"gender"];

    if ([self.dirtyPropertySet containsObject:@"happiestWhen"])
        [dict setObject:self.happiestWhen forKey:@"happiestWhen"];

    if ([self.dirtyPropertySet containsObject:@"heroes"])
        [dict setObject:[self.heroes arrayOfHeroesDictionariesFromHeroesObjects] forKey:@"heroes"];

    if ([self.dirtyPropertySet containsObject:@"humor"])
        [dict setObject:self.humor forKey:@"humor"];

    if ([self.dirtyPropertySet containsObject:@"ims"])
        [dict setObject:[self.ims arrayOfImsDictionariesFromImsObjects] forKey:@"ims"];

    if ([self.dirtyPropertySet containsObject:@"interestedInMeeting"])
        [dict setObject:self.interestedInMeeting forKey:@"interestedInMeeting"];

    if ([self.dirtyPropertySet containsObject:@"interests"])
        [dict setObject:[self.interests arrayOfInterestsDictionariesFromInterestsObjects] forKey:@"interests"];

    if ([self.dirtyPropertySet containsObject:@"jobInterests"])
        [dict setObject:[self.jobInterests arrayOfJobInterestsDictionariesFromJobInterestsObjects] forKey:@"jobInterests"];

    if ([self.dirtyPropertySet containsObject:@"languages"])
        [dict setObject:[self.languages arrayOfLanguagesDictionariesFromLanguagesObjects] forKey:@"languages"];

    if ([self.dirtyPropertySet containsObject:@"languagesSpoken"])
        [dict setObject:[self.languagesSpoken arrayOfLanguagesSpokenDictionariesFromLanguagesSpokenObjects] forKey:@"languagesSpoken"];

    if ([self.dirtyPropertySet containsObject:@"livingArrangement"])
        [dict setObject:self.livingArrangement forKey:@"livingArrangement"];

    if ([self.dirtyPropertySet containsObject:@"lookingFor"])
        [dict setObject:[self.lookingFor arrayOfLookingForDictionariesFromLookingForObjects] forKey:@"lookingFor"];

    if ([self.dirtyPropertySet containsObject:@"movies"])
        [dict setObject:[self.movies arrayOfMoviesDictionariesFromMoviesObjects] forKey:@"movies"];

    if ([self.dirtyPropertySet containsObject:@"music"])
        [dict setObject:[self.music arrayOfMusicDictionariesFromMusicObjects] forKey:@"music"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:[self.name dictionaryFromNameObject] forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"nickname"])
        [dict setObject:self.nickname forKey:@"nickname"];

    if ([self.dirtyPropertySet containsObject:@"note"])
        [dict setObject:self.note forKey:@"note"];

    if ([self.dirtyPropertySet containsObject:@"organizations"])
        [dict setObject:[self.organizations arrayOfOrganizationsDictionariesFromOrganizationsObjects] forKey:@"organizations"];

    if ([self.dirtyPropertySet containsObject:@"pets"])
        [dict setObject:[self.pets arrayOfPetsDictionariesFromPetsObjects] forKey:@"pets"];

    if ([self.dirtyPropertySet containsObject:@"phoneNumbers"])
        [dict setObject:[self.phoneNumbers arrayOfPhoneNumbersDictionariesFromPhoneNumbersObjects] forKey:@"phoneNumbers"];

    if ([self.dirtyPropertySet containsObject:@"profilePhotos"])
        [dict setObject:[self.profilePhotos arrayOfProfilePhotosDictionariesFromProfilePhotosObjects] forKey:@"photos"];

    if ([self.dirtyPropertySet containsObject:@"politicalViews"])
        [dict setObject:self.politicalViews forKey:@"politicalViews"];

    if ([self.dirtyPropertySet containsObject:@"preferredUsername"])
        [dict setObject:self.preferredUsername forKey:@"preferredUsername"];

    if ([self.dirtyPropertySet containsObject:@"profileSong"])
        [dict setObject:self.profileSong forKey:@"profileSong"];

    if ([self.dirtyPropertySet containsObject:@"profileUrl"])
        [dict setObject:self.profileUrl forKey:@"profileUrl"];

    if ([self.dirtyPropertySet containsObject:@"profileVideo"])
        [dict setObject:self.profileVideo forKey:@"profileVideo"];

    if ([self.dirtyPropertySet containsObject:@"published"])
        [dict setObject:[self.published stringFromISO8601DateTime] forKey:@"published"];

    if ([self.dirtyPropertySet containsObject:@"quotes"])
        [dict setObject:[self.quotes arrayOfQuotesDictionariesFromQuotesObjects] forKey:@"quotes"];

    if ([self.dirtyPropertySet containsObject:@"relationshipStatus"])
        [dict setObject:self.relationshipStatus forKey:@"relationshipStatus"];

    if ([self.dirtyPropertySet containsObject:@"relationships"])
        [dict setObject:[self.relationships arrayOfRelationshipsDictionariesFromRelationshipsObjects] forKey:@"relationships"];

    if ([self.dirtyPropertySet containsObject:@"religion"])
        [dict setObject:self.religion forKey:@"religion"];

    if ([self.dirtyPropertySet containsObject:@"romance"])
        [dict setObject:self.romance forKey:@"romance"];

    if ([self.dirtyPropertySet containsObject:@"scaredOf"])
        [dict setObject:self.scaredOf forKey:@"scaredOf"];

    if ([self.dirtyPropertySet containsObject:@"sexualOrientation"])
        [dict setObject:self.sexualOrientation forKey:@"sexualOrientation"];

    if ([self.dirtyPropertySet containsObject:@"smoker"])
        [dict setObject:self.smoker forKey:@"smoker"];

    if ([self.dirtyPropertySet containsObject:@"sports"])
        [dict setObject:[self.sports arrayOfSportsDictionariesFromSportsObjects] forKey:@"sports"];

    if ([self.dirtyPropertySet containsObject:@"status"])
        [dict setObject:self.status forKey:@"status"];

    if ([self.dirtyPropertySet containsObject:@"tags"])
        [dict setObject:[self.tags arrayOfTagsDictionariesFromTagsObjects] forKey:@"tags"];

    if ([self.dirtyPropertySet containsObject:@"turnOffs"])
        [dict setObject:[self.turnOffs arrayOfTurnOffsDictionariesFromTurnOffsObjects] forKey:@"turnOffs"];

    if ([self.dirtyPropertySet containsObject:@"turnOns"])
        [dict setObject:[self.turnOns arrayOfTurnOnsDictionariesFromTurnOnsObjects] forKey:@"turnOns"];

    if ([self.dirtyPropertySet containsObject:@"tvShows"])
        [dict setObject:[self.tvShows arrayOfTvShowsDictionariesFromTvShowsObjects] forKey:@"tvShows"];

    if ([self.dirtyPropertySet containsObject:@"updated"])
        [dict setObject:[self.updated stringFromISO8601DateTime] forKey:@"updated"];

    if ([self.dirtyPropertySet containsObject:@"urls"])
        [dict setObject:[self.urls arrayOfUrlsDictionariesFromUrlsObjects] forKey:@"urls"];

    if ([self.dirtyPropertySet containsObject:@"utcOffset"])
        [dict setObject:self.utcOffset forKey:@"utcOffset"];

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

    [dict setObject:self.aboutMe forKey:@"aboutMe"];
    [dict setObject:[self.accounts arrayOfAccountsDictionariesFromAccountsObjects] forKey:@"accounts"];
    [dict setObject:[self.addresses arrayOfAddressesDictionariesFromAddressesObjects] forKey:@"addresses"];
    [dict setObject:[self.anniversary stringFromISO8601Date] forKey:@"anniversary"];
    [dict setObject:self.birthday forKey:@"birthday"];
    [dict setObject:[self.bodyType dictionaryFromBodyTypeObject] forKey:@"bodyType"];
    [dict setObject:[self.books arrayOfBooksDictionariesFromBooksObjects] forKey:@"books"];
    [dict setObject:[self.cars arrayOfCarsDictionariesFromCarsObjects] forKey:@"cars"];
    [dict setObject:[self.children arrayOfChildrenDictionariesFromChildrenObjects] forKey:@"children"];
    [dict setObject:[self.currentLocation dictionaryFromCurrentLocationObject] forKey:@"currentLocation"];
    [dict setObject:self.displayName forKey:@"displayName"];
    [dict setObject:self.drinker forKey:@"drinker"];
    [dict setObject:[self.emails arrayOfEmailsDictionariesFromEmailsObjects] forKey:@"emails"];
    [dict setObject:self.ethnicity forKey:@"ethnicity"];
    [dict setObject:self.fashion forKey:@"fashion"];
    [dict setObject:[self.food arrayOfFoodDictionariesFromFoodObjects] forKey:@"food"];
    [dict setObject:self.gender forKey:@"gender"];
    [dict setObject:self.happiestWhen forKey:@"happiestWhen"];
    [dict setObject:[self.heroes arrayOfHeroesDictionariesFromHeroesObjects] forKey:@"heroes"];
    [dict setObject:self.humor forKey:@"humor"];
    [dict setObject:[self.ims arrayOfImsDictionariesFromImsObjects] forKey:@"ims"];
    [dict setObject:self.interestedInMeeting forKey:@"interestedInMeeting"];
    [dict setObject:[self.interests arrayOfInterestsDictionariesFromInterestsObjects] forKey:@"interests"];
    [dict setObject:[self.jobInterests arrayOfJobInterestsDictionariesFromJobInterestsObjects] forKey:@"jobInterests"];
    [dict setObject:[self.languages arrayOfLanguagesDictionariesFromLanguagesObjects] forKey:@"languages"];
    [dict setObject:[self.languagesSpoken arrayOfLanguagesSpokenDictionariesFromLanguagesSpokenObjects] forKey:@"languagesSpoken"];
    [dict setObject:self.livingArrangement forKey:@"livingArrangement"];
    [dict setObject:[self.lookingFor arrayOfLookingForDictionariesFromLookingForObjects] forKey:@"lookingFor"];
    [dict setObject:[self.movies arrayOfMoviesDictionariesFromMoviesObjects] forKey:@"movies"];
    [dict setObject:[self.music arrayOfMusicDictionariesFromMusicObjects] forKey:@"music"];
    [dict setObject:[self.name dictionaryFromNameObject] forKey:@"name"];
    [dict setObject:self.nickname forKey:@"nickname"];
    [dict setObject:self.note forKey:@"note"];
    [dict setObject:[self.organizations arrayOfOrganizationsDictionariesFromOrganizationsObjects] forKey:@"organizations"];
    [dict setObject:[self.pets arrayOfPetsDictionariesFromPetsObjects] forKey:@"pets"];
    [dict setObject:[self.phoneNumbers arrayOfPhoneNumbersDictionariesFromPhoneNumbersObjects] forKey:@"phoneNumbers"];
    [dict setObject:[self.profilePhotos arrayOfProfilePhotosDictionariesFromProfilePhotosObjects] forKey:@"photos"];
    [dict setObject:self.politicalViews forKey:@"politicalViews"];
    [dict setObject:self.preferredUsername forKey:@"preferredUsername"];
    [dict setObject:self.profileSong forKey:@"profileSong"];
    [dict setObject:self.profileUrl forKey:@"profileUrl"];
    [dict setObject:self.profileVideo forKey:@"profileVideo"];
    [dict setObject:[self.published stringFromISO8601DateTime] forKey:@"published"];
    [dict setObject:[self.quotes arrayOfQuotesDictionariesFromQuotesObjects] forKey:@"quotes"];
    [dict setObject:self.relationshipStatus forKey:@"relationshipStatus"];
    [dict setObject:[self.relationships arrayOfRelationshipsDictionariesFromRelationshipsObjects] forKey:@"relationships"];
    [dict setObject:self.religion forKey:@"religion"];
    [dict setObject:self.romance forKey:@"romance"];
    [dict setObject:self.scaredOf forKey:@"scaredOf"];
    [dict setObject:self.sexualOrientation forKey:@"sexualOrientation"];
    [dict setObject:self.smoker forKey:@"smoker"];
    [dict setObject:[self.sports arrayOfSportsDictionariesFromSportsObjects] forKey:@"sports"];
    [dict setObject:self.status forKey:@"status"];
    [dict setObject:[self.tags arrayOfTagsDictionariesFromTagsObjects] forKey:@"tags"];
    [dict setObject:[self.turnOffs arrayOfTurnOffsDictionariesFromTurnOffsObjects] forKey:@"turnOffs"];
    [dict setObject:[self.turnOns arrayOfTurnOnsDictionariesFromTurnOnsObjects] forKey:@"turnOns"];
    [dict setObject:[self.tvShows arrayOfTvShowsDictionariesFromTvShowsObjects] forKey:@"tvShows"];
    [dict setObject:[self.updated stringFromISO8601DateTime] forKey:@"updated"];
    [dict setObject:[self.urls arrayOfUrlsDictionariesFromUrlsObjects] forKey:@"urls"];
    [dict setObject:self.utcOffset forKey:@"utcOffset"];

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
