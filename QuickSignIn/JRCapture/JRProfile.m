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
            [filteredDictionaryArray addObject:[(JRAccounts*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRAddresses*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRBooks*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRCars*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRChildren*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JREmails*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRFood*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRHeroes*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRIms*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRInterests*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRJobInterests*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRLanguages*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRLanguagesSpoken*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRLookingFor*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRMovies*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRMusic*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JROrganizations*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRPets*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRPhoneNumbers*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRProfilePhotos*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRQuotes*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRRelationships*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRSports*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRTags*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRTurnOffs*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRTurnOns*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRTvShows*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRUrls*)object dictionaryFromObject]];

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
@synthesize aboutMe;
@synthesize accounts;
@synthesize addresses;
@synthesize anniversary;
@synthesize birthday;
@synthesize bodyType;
@synthesize books;
@synthesize cars;
@synthesize children;
@synthesize currentLocation;
@synthesize displayName;
@synthesize drinker;
@synthesize emails;
@synthesize ethnicity;
@synthesize fashion;
@synthesize food;
@synthesize gender;
@synthesize happiestWhen;
@synthesize heroes;
@synthesize humor;
@synthesize ims;
@synthesize interestedInMeeting;
@synthesize interests;
@synthesize jobInterests;
@synthesize languages;
@synthesize languagesSpoken;
@synthesize livingArrangement;
@synthesize lookingFor;
@synthesize movies;
@synthesize music;
@synthesize name;
@synthesize nickname;
@synthesize note;
@synthesize organizations;
@synthesize pets;
@synthesize phoneNumbers;
@synthesize profilePhotos;
@synthesize politicalViews;
@synthesize preferredUsername;
@synthesize profileSong;
@synthesize profileUrl;
@synthesize profileVideo;
@synthesize published;
@synthesize quotes;
@synthesize relationshipStatus;
@synthesize relationships;
@synthesize religion;
@synthesize romance;
@synthesize scaredOf;
@synthesize sexualOrientation;
@synthesize smoker;
@synthesize sports;
@synthesize status;
@synthesize tags;
@synthesize turnOffs;
@synthesize turnOns;
@synthesize tvShows;
@synthesize updated;
@synthesize urls;
@synthesize utcOffset;

- (id)init
{
    if ((self = [super init]))
    {
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
    profile.profilePhotos = [(NSArray*)[dictionary objectForKey:@"profilePhotos"] arrayOfProfilePhotosObjectsFromProfilePhotosDictionaries];
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

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (aboutMe)
        [dict setObject:aboutMe forKey:@"aboutMe"];

    if (accounts)
        [dict setObject:[accounts arrayOfAccountsDictionariesFromAccountsObjects] forKey:@"accounts"];

    if (addresses)
        [dict setObject:[addresses arrayOfAddressesDictionariesFromAddressesObjects] forKey:@"addresses"];

    if (anniversary)
        [dict setObject:[anniversary stringFromISO8601Date] forKey:@"anniversary"];

    if (birthday)
        [dict setObject:birthday forKey:@"birthday"];

    if (bodyType)
        [dict setObject:[bodyType dictionaryFromObject] forKey:@"bodyType"];

    if (books)
        [dict setObject:[books arrayOfBooksDictionariesFromBooksObjects] forKey:@"books"];

    if (cars)
        [dict setObject:[cars arrayOfCarsDictionariesFromCarsObjects] forKey:@"cars"];

    if (children)
        [dict setObject:[children arrayOfChildrenDictionariesFromChildrenObjects] forKey:@"children"];

    if (currentLocation)
        [dict setObject:[currentLocation dictionaryFromObject] forKey:@"currentLocation"];

    if (displayName)
        [dict setObject:displayName forKey:@"displayName"];

    if (drinker)
        [dict setObject:drinker forKey:@"drinker"];

    if (emails)
        [dict setObject:[emails arrayOfEmailsDictionariesFromEmailsObjects] forKey:@"emails"];

    if (ethnicity)
        [dict setObject:ethnicity forKey:@"ethnicity"];

    if (fashion)
        [dict setObject:fashion forKey:@"fashion"];

    if (food)
        [dict setObject:[food arrayOfFoodDictionariesFromFoodObjects] forKey:@"food"];

    if (gender)
        [dict setObject:gender forKey:@"gender"];

    if (happiestWhen)
        [dict setObject:happiestWhen forKey:@"happiestWhen"];

    if (heroes)
        [dict setObject:[heroes arrayOfHeroesDictionariesFromHeroesObjects] forKey:@"heroes"];

    if (humor)
        [dict setObject:humor forKey:@"humor"];

    if (ims)
        [dict setObject:[ims arrayOfImsDictionariesFromImsObjects] forKey:@"ims"];

    if (interestedInMeeting)
        [dict setObject:interestedInMeeting forKey:@"interestedInMeeting"];

    if (interests)
        [dict setObject:[interests arrayOfInterestsDictionariesFromInterestsObjects] forKey:@"interests"];

    if (jobInterests)
        [dict setObject:[jobInterests arrayOfJobInterestsDictionariesFromJobInterestsObjects] forKey:@"jobInterests"];

    if (languages)
        [dict setObject:[languages arrayOfLanguagesDictionariesFromLanguagesObjects] forKey:@"languages"];

    if (languagesSpoken)
        [dict setObject:[languagesSpoken arrayOfLanguagesSpokenDictionariesFromLanguagesSpokenObjects] forKey:@"languagesSpoken"];

    if (livingArrangement)
        [dict setObject:livingArrangement forKey:@"livingArrangement"];

    if (lookingFor)
        [dict setObject:[lookingFor arrayOfLookingForDictionariesFromLookingForObjects] forKey:@"lookingFor"];

    if (movies)
        [dict setObject:[movies arrayOfMoviesDictionariesFromMoviesObjects] forKey:@"movies"];

    if (music)
        [dict setObject:[music arrayOfMusicDictionariesFromMusicObjects] forKey:@"music"];

    if (name)
        [dict setObject:[name dictionaryFromObject] forKey:@"name"];

    if (nickname)
        [dict setObject:nickname forKey:@"nickname"];

    if (note)
        [dict setObject:note forKey:@"note"];

    if (organizations)
        [dict setObject:[organizations arrayOfOrganizationsDictionariesFromOrganizationsObjects] forKey:@"organizations"];

    if (pets)
        [dict setObject:[pets arrayOfPetsDictionariesFromPetsObjects] forKey:@"pets"];

    if (phoneNumbers)
        [dict setObject:[phoneNumbers arrayOfPhoneNumbersDictionariesFromPhoneNumbersObjects] forKey:@"phoneNumbers"];

    if (profilePhotos)
        [dict setObject:[profilePhotos arrayOfProfilePhotosDictionariesFromProfilePhotosObjects] forKey:@"profilePhotos"];

    if (politicalViews)
        [dict setObject:politicalViews forKey:@"politicalViews"];

    if (preferredUsername)
        [dict setObject:preferredUsername forKey:@"preferredUsername"];

    if (profileSong)
        [dict setObject:profileSong forKey:@"profileSong"];

    if (profileUrl)
        [dict setObject:profileUrl forKey:@"profileUrl"];

    if (profileVideo)
        [dict setObject:profileVideo forKey:@"profileVideo"];

    if (published)
        [dict setObject:[published stringFromISO8601DateTime] forKey:@"published"];

    if (quotes)
        [dict setObject:[quotes arrayOfQuotesDictionariesFromQuotesObjects] forKey:@"quotes"];

    if (relationshipStatus)
        [dict setObject:relationshipStatus forKey:@"relationshipStatus"];

    if (relationships)
        [dict setObject:[relationships arrayOfRelationshipsDictionariesFromRelationshipsObjects] forKey:@"relationships"];

    if (religion)
        [dict setObject:religion forKey:@"religion"];

    if (romance)
        [dict setObject:romance forKey:@"romance"];

    if (scaredOf)
        [dict setObject:scaredOf forKey:@"scaredOf"];

    if (sexualOrientation)
        [dict setObject:sexualOrientation forKey:@"sexualOrientation"];

    if (smoker)
        [dict setObject:smoker forKey:@"smoker"];

    if (sports)
        [dict setObject:[sports arrayOfSportsDictionariesFromSportsObjects] forKey:@"sports"];

    if (status)
        [dict setObject:status forKey:@"status"];

    if (tags)
        [dict setObject:[tags arrayOfTagsDictionariesFromTagsObjects] forKey:@"tags"];

    if (turnOffs)
        [dict setObject:[turnOffs arrayOfTurnOffsDictionariesFromTurnOffsObjects] forKey:@"turnOffs"];

    if (turnOns)
        [dict setObject:[turnOns arrayOfTurnOnsDictionariesFromTurnOnsObjects] forKey:@"turnOns"];

    if (tvShows)
        [dict setObject:[tvShows arrayOfTvShowsDictionariesFromTvShowsObjects] forKey:@"tvShows"];

    if (updated)
        [dict setObject:[updated stringFromISO8601DateTime] forKey:@"updated"];

    if (urls)
        [dict setObject:[urls arrayOfUrlsDictionariesFromUrlsObjects] forKey:@"urls"];

    if (utcOffset)
        [dict setObject:utcOffset forKey:@"utcOffset"];

    return dict;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"aboutMe"])
        self.aboutMe = [dictionary objectForKey:@"aboutMe"];

    if ([dictionary objectForKey:@"accounts"])
        self.accounts = [(NSArray*)[dictionary objectForKey:@"accounts"] arrayOfAccountsObjectsFromAccountsDictionaries];

    if ([dictionary objectForKey:@"addresses"])
        self.addresses = [(NSArray*)[dictionary objectForKey:@"addresses"] arrayOfAddressesObjectsFromAddressesDictionaries];

    if ([dictionary objectForKey:@"anniversary"])
        self.anniversary = [NSDate dateFromISO8601DateString:[dictionary objectForKey:@"anniversary"]];

    if ([dictionary objectForKey:@"birthday"])
        self.birthday = [dictionary objectForKey:@"birthday"];

    if ([dictionary objectForKey:@"bodyType"])
        self.bodyType = [JRBodyType bodyTypeObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"bodyType"]];

    if ([dictionary objectForKey:@"books"])
        self.books = [(NSArray*)[dictionary objectForKey:@"books"] arrayOfBooksObjectsFromBooksDictionaries];

    if ([dictionary objectForKey:@"cars"])
        self.cars = [(NSArray*)[dictionary objectForKey:@"cars"] arrayOfCarsObjectsFromCarsDictionaries];

    if ([dictionary objectForKey:@"children"])
        self.children = [(NSArray*)[dictionary objectForKey:@"children"] arrayOfChildrenObjectsFromChildrenDictionaries];

    if ([dictionary objectForKey:@"currentLocation"])
        self.currentLocation = [JRCurrentLocation currentLocationObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"currentLocation"]];

    if ([dictionary objectForKey:@"displayName"])
        self.displayName = [dictionary objectForKey:@"displayName"];

    if ([dictionary objectForKey:@"drinker"])
        self.drinker = [dictionary objectForKey:@"drinker"];

    if ([dictionary objectForKey:@"emails"])
        self.emails = [(NSArray*)[dictionary objectForKey:@"emails"] arrayOfEmailsObjectsFromEmailsDictionaries];

    if ([dictionary objectForKey:@"ethnicity"])
        self.ethnicity = [dictionary objectForKey:@"ethnicity"];

    if ([dictionary objectForKey:@"fashion"])
        self.fashion = [dictionary objectForKey:@"fashion"];

    if ([dictionary objectForKey:@"food"])
        self.food = [(NSArray*)[dictionary objectForKey:@"food"] arrayOfFoodObjectsFromFoodDictionaries];

    if ([dictionary objectForKey:@"gender"])
        self.gender = [dictionary objectForKey:@"gender"];

    if ([dictionary objectForKey:@"happiestWhen"])
        self.happiestWhen = [dictionary objectForKey:@"happiestWhen"];

    if ([dictionary objectForKey:@"heroes"])
        self.heroes = [(NSArray*)[dictionary objectForKey:@"heroes"] arrayOfHeroesObjectsFromHeroesDictionaries];

    if ([dictionary objectForKey:@"humor"])
        self.humor = [dictionary objectForKey:@"humor"];

    if ([dictionary objectForKey:@"ims"])
        self.ims = [(NSArray*)[dictionary objectForKey:@"ims"] arrayOfImsObjectsFromImsDictionaries];

    if ([dictionary objectForKey:@"interestedInMeeting"])
        self.interestedInMeeting = [dictionary objectForKey:@"interestedInMeeting"];

    if ([dictionary objectForKey:@"interests"])
        self.interests = [(NSArray*)[dictionary objectForKey:@"interests"] arrayOfInterestsObjectsFromInterestsDictionaries];

    if ([dictionary objectForKey:@"jobInterests"])
        self.jobInterests = [(NSArray*)[dictionary objectForKey:@"jobInterests"] arrayOfJobInterestsObjectsFromJobInterestsDictionaries];

    if ([dictionary objectForKey:@"languages"])
        self.languages = [(NSArray*)[dictionary objectForKey:@"languages"] arrayOfLanguagesObjectsFromLanguagesDictionaries];

    if ([dictionary objectForKey:@"languagesSpoken"])
        self.languagesSpoken = [(NSArray*)[dictionary objectForKey:@"languagesSpoken"] arrayOfLanguagesSpokenObjectsFromLanguagesSpokenDictionaries];

    if ([dictionary objectForKey:@"livingArrangement"])
        self.livingArrangement = [dictionary objectForKey:@"livingArrangement"];

    if ([dictionary objectForKey:@"lookingFor"])
        self.lookingFor = [(NSArray*)[dictionary objectForKey:@"lookingFor"] arrayOfLookingForObjectsFromLookingForDictionaries];

    if ([dictionary objectForKey:@"movies"])
        self.movies = [(NSArray*)[dictionary objectForKey:@"movies"] arrayOfMoviesObjectsFromMoviesDictionaries];

    if ([dictionary objectForKey:@"music"])
        self.music = [(NSArray*)[dictionary objectForKey:@"music"] arrayOfMusicObjectsFromMusicDictionaries];

    if ([dictionary objectForKey:@"name"])
        self.name = [JRName nameObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"name"]];

    if ([dictionary objectForKey:@"nickname"])
        self.nickname = [dictionary objectForKey:@"nickname"];

    if ([dictionary objectForKey:@"note"])
        self.note = [dictionary objectForKey:@"note"];

    if ([dictionary objectForKey:@"organizations"])
        self.organizations = [(NSArray*)[dictionary objectForKey:@"organizations"] arrayOfOrganizationsObjectsFromOrganizationsDictionaries];

    if ([dictionary objectForKey:@"pets"])
        self.pets = [(NSArray*)[dictionary objectForKey:@"pets"] arrayOfPetsObjectsFromPetsDictionaries];

    if ([dictionary objectForKey:@"phoneNumbers"])
        self.phoneNumbers = [(NSArray*)[dictionary objectForKey:@"phoneNumbers"] arrayOfPhoneNumbersObjectsFromPhoneNumbersDictionaries];

    if ([dictionary objectForKey:@"profilePhotos"])
        self.profilePhotos = [(NSArray*)[dictionary objectForKey:@"profilePhotos"] arrayOfProfilePhotosObjectsFromProfilePhotosDictionaries];

    if ([dictionary objectForKey:@"politicalViews"])
        self.politicalViews = [dictionary objectForKey:@"politicalViews"];

    if ([dictionary objectForKey:@"preferredUsername"])
        self.preferredUsername = [dictionary objectForKey:@"preferredUsername"];

    if ([dictionary objectForKey:@"profileSong"])
        self.profileSong = [dictionary objectForKey:@"profileSong"];

    if ([dictionary objectForKey:@"profileUrl"])
        self.profileUrl = [dictionary objectForKey:@"profileUrl"];

    if ([dictionary objectForKey:@"profileVideo"])
        self.profileVideo = [dictionary objectForKey:@"profileVideo"];

    if ([dictionary objectForKey:@"published"])
        self.published = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"published"]];

    if ([dictionary objectForKey:@"quotes"])
        self.quotes = [(NSArray*)[dictionary objectForKey:@"quotes"] arrayOfQuotesObjectsFromQuotesDictionaries];

    if ([dictionary objectForKey:@"relationshipStatus"])
        self.relationshipStatus = [dictionary objectForKey:@"relationshipStatus"];

    if ([dictionary objectForKey:@"relationships"])
        self.relationships = [(NSArray*)[dictionary objectForKey:@"relationships"] arrayOfRelationshipsObjectsFromRelationshipsDictionaries];

    if ([dictionary objectForKey:@"religion"])
        self.religion = [dictionary objectForKey:@"religion"];

    if ([dictionary objectForKey:@"romance"])
        self.romance = [dictionary objectForKey:@"romance"];

    if ([dictionary objectForKey:@"scaredOf"])
        self.scaredOf = [dictionary objectForKey:@"scaredOf"];

    if ([dictionary objectForKey:@"sexualOrientation"])
        self.sexualOrientation = [dictionary objectForKey:@"sexualOrientation"];

    if ([dictionary objectForKey:@"smoker"])
        self.smoker = [dictionary objectForKey:@"smoker"];

    if ([dictionary objectForKey:@"sports"])
        self.sports = [(NSArray*)[dictionary objectForKey:@"sports"] arrayOfSportsObjectsFromSportsDictionaries];

    if ([dictionary objectForKey:@"status"])
        self.status = [dictionary objectForKey:@"status"];

    if ([dictionary objectForKey:@"tags"])
        self.tags = [(NSArray*)[dictionary objectForKey:@"tags"] arrayOfTagsObjectsFromTagsDictionaries];

    if ([dictionary objectForKey:@"turnOffs"])
        self.turnOffs = [(NSArray*)[dictionary objectForKey:@"turnOffs"] arrayOfTurnOffsObjectsFromTurnOffsDictionaries];

    if ([dictionary objectForKey:@"turnOns"])
        self.turnOns = [(NSArray*)[dictionary objectForKey:@"turnOns"] arrayOfTurnOnsObjectsFromTurnOnsDictionaries];

    if ([dictionary objectForKey:@"tvShows"])
        self.tvShows = [(NSArray*)[dictionary objectForKey:@"tvShows"] arrayOfTvShowsObjectsFromTvShowsDictionaries];

    if ([dictionary objectForKey:@"updated"])
        self.updated = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"updated"]];

    if ([dictionary objectForKey:@"urls"])
        self.urls = [(NSArray*)[dictionary objectForKey:@"urls"] arrayOfUrlsObjectsFromUrlsDictionaries];

    if ([dictionary objectForKey:@"utcOffset"])
        self.utcOffset = [dictionary objectForKey:@"utcOffset"];
}

- (void)dealloc
{
    [aboutMe release];
    [accounts release];
    [addresses release];
    [anniversary release];
    [birthday release];
    [bodyType release];
    [books release];
    [cars release];
    [children release];
    [currentLocation release];
    [displayName release];
    [drinker release];
    [emails release];
    [ethnicity release];
    [fashion release];
    [food release];
    [gender release];
    [happiestWhen release];
    [heroes release];
    [humor release];
    [ims release];
    [interestedInMeeting release];
    [interests release];
    [jobInterests release];
    [languages release];
    [languagesSpoken release];
    [livingArrangement release];
    [lookingFor release];
    [movies release];
    [music release];
    [name release];
    [nickname release];
    [note release];
    [organizations release];
    [pets release];
    [phoneNumbers release];
    [profilePhotos release];
    [politicalViews release];
    [preferredUsername release];
    [profileSong release];
    [profileUrl release];
    [profileVideo release];
    [published release];
    [quotes release];
    [relationshipStatus release];
    [relationships release];
    [religion release];
    [romance release];
    [scaredOf release];
    [sexualOrientation release];
    [smoker release];
    [sports release];
    [status release];
    [tags release];
    [turnOffs release];
    [turnOns release];
    [tvShows release];
    [updated release];
    [urls release];
    [utcOffset release];

    [super dealloc];
}
@end
