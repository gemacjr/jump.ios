
#import "JRProfilesObject.h"

@implementation JRProfilesObject
@synthesize accessCredentials;
@synthesize domain;
@synthesize friends;
@synthesize identifier;
@synthesize profile;
@synthesize provider;
@synthesize remote_key;

- (id)initWithDomain:(NSString *)newDomain andIdentifier:(NSString *)newIdentifier
{
    if (!newDomain || !newIdentifier)
    {
        [self release];
        return nil;
     }

    if ((self = [super init]))
    {
        domain = [newDomain copy];
        identifier = [newIdentifier copy];
    }
    return self;
}

+ (id)profilesObjectWithDomain:(NSString *)domain andIdentifier:(NSString *)identifier
{
    return [[[JRProfilesObject alloc] initWithDomain:domain andIdentifier:identifier] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRProfilesObject *profilesObjectCopy =
                [[JRProfilesObject allocWithZone:zone] initWithDomain:self.domain andIdentifier:self.identifier];

    profilesObjectCopy.accessCredentials = self.accessCredentials;
    profilesObjectCopy.friends = self.friends;
    profilesObjectCopy.profile = self.profile;
    profilesObjectCopy.provider = self.provider;
    profilesObjectCopy.remote_key = self.remote_key;

    return profilesObjectCopy;
}

+ (id)profilesObjectFromDictionary:(NSDictionary*)dictionary
{
    JRProfilesObject *profilesObject =
        [JRProfilesObject profilesObjectWithDomain:[dictionary objectForKey:@"domain"] andIdentifier:[dictionary objectForKey:@"identifier"]];

    profilesObject.accessCredentials = [dictionary objectForKey:@"accessCredentials"];
    profilesObject.friends = [dictionary objectForKey:@"friends"];
    profilesObject.profile = [JRProfileObject profileObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"profile"]];
    profilesObject.provider = [dictionary objectForKey:@"provider"];
    profilesObject.remote_key = [dictionary objectForKey:@"remote_key"];

    return profilesObject;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:domain forKey:@"domain"];
    [dict setObject:identifier forKey:@"identifier"];

    if (accessCredentials)
        [dict setObject:accessCredentials forKey:@"accessCredentials"];

    if (friends)
        [dict setObject:friends forKey:@"friends"];

    if (profile)
        [dict setObject:[profile dictionaryFromObject] forKey:@"profile"];

    if (provider)
        [dict setObject:provider forKey:@"provider"];

    if (remote_key)
        [dict setObject:remote_key forKey:@"remote_key"];

    return dict;
}

- (void)dealloc
{
    [accessCredentials release];
    [domain release];
    [friends release];
    [identifier release];
    [profile release];
    [provider release];
    [remote_key release];

    [super dealloc];
}
@end
