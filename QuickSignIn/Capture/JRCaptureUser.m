
#import "JRCaptureUser.h"

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
            [filteredDictionaryArray addObject:[(JRPhotos*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRProfiles*)object dictionaryFromObject]];

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
            [filteredDictionaryArray addObject:[(JRStatuses*)object dictionaryFromObject]];

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
@synthesize aboutMe;
@synthesize birthday;
@synthesize currentLocation;
@synthesize display;
@synthesize displayName;
@synthesize email;
@synthesize emailVerified;
@synthesize familyName;
@synthesize gender;
@synthesize givenName;
@synthesize lastLogin;
@synthesize middleName;
@synthesize password;
@synthesize photos;
@synthesize primaryAddress;
@synthesize profiles;
@synthesize statuses;

- (id)init
{
    if ((self = [super init]))
    {
    }
    return self;
}

+ (id)captureUser
{
    return [[[JRCaptureUser alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRCaptureUser *captureUserCopy =
                [[JRCaptureUser allocWithZone:zone] init];

    captureUserCopy.aboutMe = self.aboutMe;
    captureUserCopy.birthday = self.birthday;
    captureUserCopy.currentLocation = self.currentLocation;
    captureUserCopy.display = self.display;
    captureUserCopy.displayName = self.displayName;
    captureUserCopy.email = self.email;
    captureUserCopy.emailVerified = self.emailVerified;
    captureUserCopy.familyName = self.familyName;
    captureUserCopy.gender = self.gender;
    captureUserCopy.givenName = self.givenName;
    captureUserCopy.lastLogin = self.lastLogin;
    captureUserCopy.middleName = self.middleName;
    captureUserCopy.password = self.password;
    captureUserCopy.photos = self.photos;
    captureUserCopy.primaryAddress = self.primaryAddress;
    captureUserCopy.profiles = self.profiles;
    captureUserCopy.statuses = self.statuses;

    return captureUserCopy;
}

+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary
{
    JRCaptureUser *captureUser =
        [JRCaptureUser captureUser];

    captureUser.aboutMe = [dictionary objectForKey:@"aboutMe"];
    captureUser.birthday = [dictionary objectForKey:@"birthday"];
    captureUser.currentLocation = [dictionary objectForKey:@"currentLocation"];
    captureUser.display = [dictionary objectForKey:@"display"];
    captureUser.displayName = [dictionary objectForKey:@"displayName"];
    captureUser.email = [dictionary objectForKey:@"email"];
    captureUser.emailVerified = [dictionary objectForKey:@"emailVerified"];
    captureUser.familyName = [dictionary objectForKey:@"familyName"];
    captureUser.gender = [dictionary objectForKey:@"gender"];
    captureUser.givenName = [dictionary objectForKey:@"givenName"];
    captureUser.lastLogin = [dictionary objectForKey:@"lastLogin"];
    captureUser.middleName = [dictionary objectForKey:@"middleName"];
    captureUser.password = [dictionary objectForKey:@"password"];
    captureUser.photos = [dictionary objectForKey:@"photos"];
    captureUser.primaryAddress = [JRPrimaryAddress primaryAddressObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"primaryAddress"]];
    captureUser.profiles = [dictionary objectForKey:@"profiles"];
    captureUser.statuses = [dictionary objectForKey:@"statuses"];

    return captureUser;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (aboutMe)
        [dict setObject:aboutMe forKey:@"aboutMe"];

    if (birthday)
        [dict setObject:birthday forKey:@"birthday"];

    if (currentLocation)
        [dict setObject:currentLocation forKey:@"currentLocation"];

    if (display)
        [dict setObject:display forKey:@"display"];

    if (displayName)
        [dict setObject:displayName forKey:@"displayName"];

    if (email)
        [dict setObject:email forKey:@"email"];

    if (emailVerified)
        [dict setObject:emailVerified forKey:@"emailVerified"];

    if (familyName)
        [dict setObject:familyName forKey:@"familyName"];

    if (gender)
        [dict setObject:gender forKey:@"gender"];

    if (givenName)
        [dict setObject:givenName forKey:@"givenName"];

    if (lastLogin)
        [dict setObject:lastLogin forKey:@"lastLogin"];

    if (middleName)
        [dict setObject:middleName forKey:@"middleName"];

    if (password)
        [dict setObject:password forKey:@"password"];

    if (photos)
        [dict setObject:[photos arrayOfPhotosDictionariesFromPhotosObjects] forKey:@"photos"];

    if (primaryAddress)
        [dict setObject:[primaryAddress dictionaryFromObject] forKey:@"primaryAddress"];

    if (profiles)
        [dict setObject:[profiles arrayOfProfilesDictionariesFromProfilesObjects] forKey:@"profiles"];

    if (statuses)
        [dict setObject:[statuses arrayOfStatusesDictionariesFromStatusesObjects] forKey:@"statuses"];

    return dict;
}

- (void)dealloc
{
    [aboutMe release];
    [birthday release];
    [currentLocation release];
    [display release];
    [displayName release];
    [email release];
    [emailVerified release];
    [familyName release];
    [gender release];
    [givenName release];
    [lastLogin release];
    [middleName release];
    [password release];
    [photos release];
    [primaryAddress release];
    [profiles release];
    [statuses release];

    [super dealloc];
}
@end
