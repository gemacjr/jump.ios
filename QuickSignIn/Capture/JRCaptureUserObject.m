
#import "JRCaptureUserObject.h"

@interface NSArray (PhotosToDictionary)
- (NSArray*)arrayOfPhotosDictionariesFromPhotosObjects;
@end

@implementation NSArray (PhotosToDictionary)
- (NSArray*)arrayOfPhotosDictionariesFromPhotosObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhotosObject class]])
            [filteredDictionaryArray addObject:[(JRPhotosObject*)object dictionaryFromObject]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (ProfilesToDictionary)
- (NSArray*)arrayOfProfilesDictionariesFromProfilesObjects;
@end

@implementation NSArray (ProfilesToDictionary)
- (NSArray*)arrayOfProfilesDictionariesFromProfilesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfilesObject class]])
            [filteredDictionaryArray addObject:[(JRProfilesObject*)object dictionaryFromObject]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (StatusesToDictionary)
- (NSArray*)arrayOfStatusesDictionariesFromStatusesObjects;
@end

@implementation NSArray (StatusesToDictionary)
- (NSArray*)arrayOfStatusesDictionariesFromStatusesObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRStatusesObject class]])
            [filteredDictionaryArray addObject:[(JRStatusesObject*)object dictionaryFromObject]];

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
