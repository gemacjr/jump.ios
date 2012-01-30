
#import "JRProfileObject.h"

@interface NSArray (AccountsToFromDictionary)
- (NSArray*)arrayOfAccountsDictionariesFromAccountsObjects;
- (NSArray*)arrayOfAccountsObjectsFromAccountsDictionaries;
@end

@implementation NSArray (AccountsToFromDictionary)
- (NSArray*)arrayOfAccountsDictionariesFromAccountsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRAccountsObject class]])
            [filteredDictionaryArray addObject:[(JRAccountsObject*)object dictionaryFromObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfAccountsObjectsFromAccountsDictionaries
{
    NSMutableArray *filteredObjectArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])            [filteredDictionaryArray addObject:[JRAccounts accountsObjectFromDictionary:(NSDictionary*)dictionary]];

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
        if ([object isKindOfClass:[JRAddressesObject class]])
            [filteredDictionaryArray addObject:[(JRAddressesObject*)object dictionaryFromObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfAddressesObjectsFromAddressesDictionaries
{
    NSMutableArray *filteredObjectArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])            [filteredDictionaryArray addObject:[JRAddresses addressesObjectFromDictionary:(NSDictionary*)dictionary]];

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
        if ([object isKindOfClass:[JREmailsObject class]])
            [filteredDictionaryArray addObject:[(JREmailsObject*)object dictionaryFromObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfEmailsObjectsFromEmailsDictionaries
{
    NSMutableArray *filteredObjectArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])            [filteredDictionaryArray addObject:[JREmails emailsObjectFromDictionary:(NSDictionary*)dictionary]];

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
        if ([object isKindOfClass:[JRImsObject class]])
            [filteredDictionaryArray addObject:[(JRImsObject*)object dictionaryFromObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfImsObjectsFromImsDictionaries
{
    NSMutableArray *filteredObjectArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])            [filteredDictionaryArray addObject:[JRIms imsObjectFromDictionary:(NSDictionary*)dictionary]];

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
        if ([object isKindOfClass:[JROrganizationsObject class]])
            [filteredDictionaryArray addObject:[(JROrganizationsObject*)object dictionaryFromObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfOrganizationsObjectsFromOrganizationsDictionaries
{
    NSMutableArray *filteredObjectArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])            [filteredDictionaryArray addObject:[JROrganizations organizationsObjectFromDictionary:(NSDictionary*)dictionary]];

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
        if ([object isKindOfClass:[JRPhoneNumbersObject class]])
            [filteredDictionaryArray addObject:[(JRPhoneNumbersObject*)object dictionaryFromObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPhoneNumbersObjectsFromPhoneNumbersDictionaries
{
    NSMutableArray *filteredObjectArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])            [filteredDictionaryArray addObject:[JRPhoneNumbers phoneNumbersObjectFromDictionary:(NSDictionary*)dictionary]];

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
        if ([object isKindOfClass:[JRPhotosObject class]])
            [filteredDictionaryArray addObject:[(JRPhotosObject*)object dictionaryFromObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPhotosObjectsFromPhotosDictionaries
{
    NSMutableArray *filteredObjectArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])            [filteredDictionaryArray addObject:[JRPhotos photosObjectFromDictionary:(NSDictionary*)dictionary]];

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
        if ([object isKindOfClass:[JRUrlsObject class]])
            [filteredDictionaryArray addObject:[(JRUrlsObject*)object dictionaryFromObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfUrlsObjectsFromUrlsDictionaries
{
    NSMutableArray *filteredObjectArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])            [filteredDictionaryArray addObject:[JRUrls urlsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@implementation JRProfileObject
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
@synthesize photos;
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

+ (id)profileObject
{
    return [[[JRProfileObject alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRProfileObject *profileObjectCopy =
                [[JRProfileObject allocWithZone:zone] init];

    profileObjectCopy.aboutMe = self.aboutMe;
    profileObjectCopy.accounts = self.accounts;
    profileObjectCopy.addresses = self.addresses;
    profileObjectCopy.anniversary = self.anniversary;
    profileObjectCopy.birthday = self.birthday;
    profileObjectCopy.bodyType = self.bodyType;
    profileObjectCopy.books = self.books;
    profileObjectCopy.cars = self.cars;
    profileObjectCopy.children = self.children;
    profileObjectCopy.currentLocation = self.currentLocation;
    profileObjectCopy.displayName = self.displayName;
    profileObjectCopy.drinker = self.drinker;
    profileObjectCopy.emails = self.emails;
    profileObjectCopy.ethnicity = self.ethnicity;
    profileObjectCopy.fashion = self.fashion;
    profileObjectCopy.food = self.food;
    profileObjectCopy.gender = self.gender;
    profileObjectCopy.happiestWhen = self.happiestWhen;
    profileObjectCopy.heroes = self.heroes;
    profileObjectCopy.humor = self.humor;
    profileObjectCopy.ims = self.ims;
    profileObjectCopy.interestedInMeeting = self.interestedInMeeting;
    profileObjectCopy.interests = self.interests;
    profileObjectCopy.jobInterests = self.jobInterests;
    profileObjectCopy.languages = self.languages;
    profileObjectCopy.languagesSpoken = self.languagesSpoken;
    profileObjectCopy.livingArrangement = self.livingArrangement;
    profileObjectCopy.lookingFor = self.lookingFor;
    profileObjectCopy.movies = self.movies;
    profileObjectCopy.music = self.music;
    profileObjectCopy.name = self.name;
    profileObjectCopy.nickname = self.nickname;
    profileObjectCopy.note = self.note;
    profileObjectCopy.organizations = self.organizations;
    profileObjectCopy.pets = self.pets;
    profileObjectCopy.phoneNumbers = self.phoneNumbers;
    profileObjectCopy.photos = self.photos;
    profileObjectCopy.politicalViews = self.politicalViews;
    profileObjectCopy.preferredUsername = self.preferredUsername;
    profileObjectCopy.profileSong = self.profileSong;
    profileObjectCopy.profileUrl = self.profileUrl;
    profileObjectCopy.profileVideo = self.profileVideo;
    profileObjectCopy.published = self.published;
    profileObjectCopy.quotes = self.quotes;
    profileObjectCopy.relationshipStatus = self.relationshipStatus;
    profileObjectCopy.relationships = self.relationships;
    profileObjectCopy.religion = self.religion;
    profileObjectCopy.romance = self.romance;
    profileObjectCopy.scaredOf = self.scaredOf;
    profileObjectCopy.sexualOrientation = self.sexualOrientation;
    profileObjectCopy.smoker = self.smoker;
    profileObjectCopy.sports = self.sports;
    profileObjectCopy.status = self.status;
    profileObjectCopy.tags = self.tags;
    profileObjectCopy.turnOffs = self.turnOffs;
    profileObjectCopy.turnOns = self.turnOns;
    profileObjectCopy.tvShows = self.tvShows;
    profileObjectCopy.updated = self.updated;
    profileObjectCopy.urls = self.urls;
    profileObjectCopy.utcOffset = self.utcOffset;

    return profileObjectCopy;
}

+ (id)profileObjectFromDictionary:(NSDictionary*)dictionary
{
    JRProfileObject *profileObject =
        [JRProfileObject profileObject];

    profileObject.aboutMe = [dictionary objectForKey:@"aboutMe"];
    profileObject.accounts = [dictionary objectForKey:@"accounts"];
    profileObject.addresses = [dictionary objectForKey:@"addresses"];
    profileObject.anniversary = [dictionary objectForKey:@"anniversary"];
    profileObject.birthday = [dictionary objectForKey:@"birthday"];
    profileObject.bodyType = [JRBodyTypeObject bodyTypeObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"bodyType"]];
    profileObject.books = [dictionary objectForKey:@"books"];
    profileObject.cars = [dictionary objectForKey:@"cars"];
    profileObject.children = [dictionary objectForKey:@"children"];
    profileObject.currentLocation = [JRCurrentLocationObject currentLocationObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"currentLocation"]];
    profileObject.displayName = [dictionary objectForKey:@"displayName"];
    profileObject.drinker = [dictionary objectForKey:@"drinker"];
    profileObject.emails = [dictionary objectForKey:@"emails"];
    profileObject.ethnicity = [dictionary objectForKey:@"ethnicity"];
    profileObject.fashion = [dictionary objectForKey:@"fashion"];
    profileObject.food = [dictionary objectForKey:@"food"];
    profileObject.gender = [dictionary objectForKey:@"gender"];
    profileObject.happiestWhen = [dictionary objectForKey:@"happiestWhen"];
    profileObject.heroes = [dictionary objectForKey:@"heroes"];
    profileObject.humor = [dictionary objectForKey:@"humor"];
    profileObject.ims = [dictionary objectForKey:@"ims"];
    profileObject.interestedInMeeting = [dictionary objectForKey:@"interestedInMeeting"];
    profileObject.interests = [dictionary objectForKey:@"interests"];
    profileObject.jobInterests = [dictionary objectForKey:@"jobInterests"];
    profileObject.languages = [dictionary objectForKey:@"languages"];
    profileObject.languagesSpoken = [dictionary objectForKey:@"languagesSpoken"];
    profileObject.livingArrangement = [dictionary objectForKey:@"livingArrangement"];
    profileObject.lookingFor = [dictionary objectForKey:@"lookingFor"];
    profileObject.movies = [dictionary objectForKey:@"movies"];
    profileObject.music = [dictionary objectForKey:@"music"];
    profileObject.name = [JRNameObject nameObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"name"]];
    profileObject.nickname = [dictionary objectForKey:@"nickname"];
    profileObject.note = [dictionary objectForKey:@"note"];
    profileObject.organizations = [dictionary objectForKey:@"organizations"];
    profileObject.pets = [dictionary objectForKey:@"pets"];
    profileObject.phoneNumbers = [dictionary objectForKey:@"phoneNumbers"];
    profileObject.photos = [dictionary objectForKey:@"photos"];
    profileObject.politicalViews = [dictionary objectForKey:@"politicalViews"];
    profileObject.preferredUsername = [dictionary objectForKey:@"preferredUsername"];
    profileObject.profileSong = [dictionary objectForKey:@"profileSong"];
    profileObject.profileUrl = [dictionary objectForKey:@"profileUrl"];
    profileObject.profileVideo = [dictionary objectForKey:@"profileVideo"];
    profileObject.published = [dictionary objectForKey:@"published"];
    profileObject.quotes = [dictionary objectForKey:@"quotes"];
    profileObject.relationshipStatus = [dictionary objectForKey:@"relationshipStatus"];
    profileObject.relationships = [dictionary objectForKey:@"relationships"];
    profileObject.religion = [dictionary objectForKey:@"religion"];
    profileObject.romance = [dictionary objectForKey:@"romance"];
    profileObject.scaredOf = [dictionary objectForKey:@"scaredOf"];
    profileObject.sexualOrientation = [dictionary objectForKey:@"sexualOrientation"];
    profileObject.smoker = [dictionary objectForKey:@"smoker"];
    profileObject.sports = [dictionary objectForKey:@"sports"];
    profileObject.status = [dictionary objectForKey:@"status"];
    profileObject.tags = [dictionary objectForKey:@"tags"];
    profileObject.turnOffs = [dictionary objectForKey:@"turnOffs"];
    profileObject.turnOns = [dictionary objectForKey:@"turnOns"];
    profileObject.tvShows = [dictionary objectForKey:@"tvShows"];
    profileObject.updated = [dictionary objectForKey:@"updated"];
    profileObject.urls = [dictionary objectForKey:@"urls"];
    profileObject.utcOffset = [dictionary objectForKey:@"utcOffset"];

    return profileObject;
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
        [dict setObject:anniversary forKey:@"anniversary"];

    if (birthday)
        [dict setObject:birthday forKey:@"birthday"];

    if (bodyType)
        [dict setObject:[bodyType dictionaryFromObject] forKey:@"bodyType"];

    if (books)
        [dict setObject:books forKey:@"books"];

    if (cars)
        [dict setObject:cars forKey:@"cars"];

    if (children)
        [dict setObject:children forKey:@"children"];

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
        [dict setObject:food forKey:@"food"];

    if (gender)
        [dict setObject:gender forKey:@"gender"];

    if (happiestWhen)
        [dict setObject:happiestWhen forKey:@"happiestWhen"];

    if (heroes)
        [dict setObject:heroes forKey:@"heroes"];

    if (humor)
        [dict setObject:humor forKey:@"humor"];

    if (ims)
        [dict setObject:[ims arrayOfImsDictionariesFromImsObjects] forKey:@"ims"];

    if (interestedInMeeting)
        [dict setObject:interestedInMeeting forKey:@"interestedInMeeting"];

    if (interests)
        [dict setObject:interests forKey:@"interests"];

    if (jobInterests)
        [dict setObject:jobInterests forKey:@"jobInterests"];

    if (languages)
        [dict setObject:languages forKey:@"languages"];

    if (languagesSpoken)
        [dict setObject:languagesSpoken forKey:@"languagesSpoken"];

    if (livingArrangement)
        [dict setObject:livingArrangement forKey:@"livingArrangement"];

    if (lookingFor)
        [dict setObject:lookingFor forKey:@"lookingFor"];

    if (movies)
        [dict setObject:movies forKey:@"movies"];

    if (music)
        [dict setObject:music forKey:@"music"];

    if (name)
        [dict setObject:[name dictionaryFromObject] forKey:@"name"];

    if (nickname)
        [dict setObject:nickname forKey:@"nickname"];

    if (note)
        [dict setObject:note forKey:@"note"];

    if (organizations)
        [dict setObject:[organizations arrayOfOrganizationsDictionariesFromOrganizationsObjects] forKey:@"organizations"];

    if (pets)
        [dict setObject:pets forKey:@"pets"];

    if (phoneNumbers)
        [dict setObject:[phoneNumbers arrayOfPhoneNumbersDictionariesFromPhoneNumbersObjects] forKey:@"phoneNumbers"];

    if (photos)
        [dict setObject:[photos arrayOfPhotosDictionariesFromPhotosObjects] forKey:@"photos"];

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
        [dict setObject:published forKey:@"published"];

    if (quotes)
        [dict setObject:quotes forKey:@"quotes"];

    if (relationshipStatus)
        [dict setObject:relationshipStatus forKey:@"relationshipStatus"];

    if (relationships)
        [dict setObject:relationships forKey:@"relationships"];

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
        [dict setObject:sports forKey:@"sports"];

    if (status)
        [dict setObject:status forKey:@"status"];

    if (tags)
        [dict setObject:tags forKey:@"tags"];

    if (turnOffs)
        [dict setObject:turnOffs forKey:@"turnOffs"];

    if (turnOns)
        [dict setObject:turnOns forKey:@"turnOns"];

    if (tvShows)
        [dict setObject:tvShows forKey:@"tvShows"];

    if (updated)
        [dict setObject:updated forKey:@"updated"];

    if (urls)
        [dict setObject:[urls arrayOfUrlsDictionariesFromUrlsObjects] forKey:@"urls"];

    if (utcOffset)
        [dict setObject:utcOffset forKey:@"utcOffset"];

    return dict;
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
    [photos release];
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
