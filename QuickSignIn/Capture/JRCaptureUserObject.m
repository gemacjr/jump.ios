
#import "JRCaptureUserObject.h"

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

@interface NSArray (ProfilesToFromDictionary)
- (NSArray*)arrayOfProfilesDictionariesFromProfilesObjects;
- (NSArray*)arrayOfProfilesObjectsFromProfilesDictionaries;
@end

@implementation NSArray (ProfilesToFromDictionary)
- (NSArray*)arrayOfProfilesDictionariesFromProfilesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfilesObject class]])
            [filteredDictionaryArray addObject:[(JRProfilesObject*)object dictionaryFromObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfProfilesObjectsFromProfilesDictionaries
{
    NSMutableArray *filteredObjectArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])            [filteredDictionaryArray addObject:[JRProfiles profilesObjectFromDictionary:(NSDictionary*)dictionary]];

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
        if ([object isKindOfClass:[JRStatusesObject class]])
            [filteredDictionaryArray addObject:[(JRStatusesObject*)object dictionaryFromObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfStatusesObjectsFromStatusesDictionaries
{
    NSMutableArray *filteredObjectArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])            [filteredDictionaryArray addObject:[JRStatuses statusesObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@implementation JRCaptureUserObject
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

+ (id)captureUserObject
{
    return [[[JRCaptureUserObject alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRCaptureUserObject *captureUserObjectCopy =
                [[JRCaptureUserObject allocWithZone:zone] init];

    captureUserObjectCopy.aboutMe = self.aboutMe;
    captureUserObjectCopy.birthday = self.birthday;
    captureUserObjectCopy.currentLocation = self.currentLocation;
    captureUserObjectCopy.display = self.display;
    captureUserObjectCopy.displayName = self.displayName;
    captureUserObjectCopy.email = self.email;
    captureUserObjectCopy.emailVerified = self.emailVerified;
    captureUserObjectCopy.familyName = self.familyName;
    captureUserObjectCopy.gender = self.gender;
    captureUserObjectCopy.givenName = self.givenName;
    captureUserObjectCopy.lastLogin = self.lastLogin;
    captureUserObjectCopy.middleName = self.middleName;
    captureUserObjectCopy.password = self.password;
    captureUserObjectCopy.photos = self.photos;
    captureUserObjectCopy.primaryAddress = self.primaryAddress;
    captureUserObjectCopy.profiles = self.profiles;
    captureUserObjectCopy.statuses = self.statuses;

    return captureUserObjectCopy;
}

+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary
{
    JRCaptureUserObject *captureUserObject =
        [JRCaptureUserObject captureUserObject];

    captureUserObject.aboutMe = [dictionary objectForKey:@"aboutMe"];
    captureUserObject.birthday = [dictionary objectForKey:@"birthday"];
    captureUserObject.currentLocation = [dictionary objectForKey:@"currentLocation"];
    captureUserObject.display = [dictionary objectForKey:@"display"];
    captureUserObject.displayName = [dictionary objectForKey:@"displayName"];
    captureUserObject.email = [dictionary objectForKey:@"email"];
    captureUserObject.emailVerified = [dictionary objectForKey:@"emailVerified"];
    captureUserObject.familyName = [dictionary objectForKey:@"familyName"];
    captureUserObject.gender = [dictionary objectForKey:@"gender"];
    captureUserObject.givenName = [dictionary objectForKey:@"givenName"];
    captureUserObject.lastLogin = [dictionary objectForKey:@"lastLogin"];
    captureUserObject.middleName = [dictionary objectForKey:@"middleName"];
    captureUserObject.password = [dictionary objectForKey:@"password"];
    captureUserObject.photos = [dictionary objectForKey:@"photos"];
    captureUserObject.primaryAddress = [JRPrimaryAddressObject primaryAddressObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"primaryAddress"]];
    captureUserObject.profiles = [dictionary objectForKey:@"profiles"];
    captureUserObject.statuses = [dictionary objectForKey:@"statuses"];

    return captureUserObject;
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
