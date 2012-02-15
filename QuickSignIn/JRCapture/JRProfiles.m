
#import "JRProfiles.h"

@implementation JRProfiles
@synthesize accessCredentials;
@synthesize domain;
@synthesize followers;
@synthesize following;
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

+ (id)profilesWithDomain:(NSString *)domain andIdentifier:(NSString *)identifier
{
    return [[[JRProfiles alloc] initWithDomain:domain andIdentifier:identifier] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRProfiles *profilesCopy =
                [[JRProfiles allocWithZone:zone] initWithDomain:self.domain andIdentifier:self.identifier];

    profilesCopy.accessCredentials = self.accessCredentials;
    profilesCopy.followers = self.followers;
    profilesCopy.following = self.following;
    profilesCopy.friends = self.friends;
    profilesCopy.profile = self.profile;
    profilesCopy.provider = self.provider;
    profilesCopy.remote_key = self.remote_key;

    return profilesCopy;
}

+ (id)profilesObjectFromDictionary:(NSDictionary*)dictionary
{
    JRProfiles *profiles =
        [JRProfiles profilesWithDomain:[dictionary objectForKey:@"domain"] andIdentifier:[dictionary objectForKey:@"identifier"]];

    profiles.accessCredentials = [dictionary objectForKey:@"accessCredentials"];
    profiles.followers = [dictionary objectForKey:@"followers"];
    profiles.following = [dictionary objectForKey:@"following"];
    profiles.friends = [dictionary objectForKey:@"friends"];
    profiles.profile = [JRProfile profileObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"profile"]];
    profiles.provider = [dictionary objectForKey:@"provider"];
    profiles.remote_key = [dictionary objectForKey:@"remote_key"];

    return profiles;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:domain forKey:@"domain"];
    [dict setObject:identifier forKey:@"identifier"];

    if (accessCredentials)
        [dict setObject:accessCredentials forKey:@"accessCredentials"];

    if (followers)
        [dict setObject:followers forKey:@"followers"];

    if (following)
        [dict setObject:following forKey:@"following"];

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

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"accessCredentials"])
        self.accessCredentials = [dictionary objectForKey:@"accessCredentials"];

    if ([dictionary objectForKey:@"domain"])
        self.domain = [dictionary objectForKey:@"domain"];

    if ([dictionary objectForKey:@"followers"])
        self.followers = [dictionary objectForKey:@"followers"];

    if ([dictionary objectForKey:@"following"])
        self.following = [dictionary objectForKey:@"following"];

    if ([dictionary objectForKey:@"friends"])
        self.friends = [dictionary objectForKey:@"friends"];

    if ([dictionary objectForKey:@"identifier"])
        self.identifier = [dictionary objectForKey:@"identifier"];

    if ([dictionary objectForKey:@"profile"])
        self.profile = [JRProfile profileObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"profile"]];

    if ([dictionary objectForKey:@"provider"])
        self.provider = [dictionary objectForKey:@"provider"];

    if ([dictionary objectForKey:@"remote_key"])
        self.remote_key = [dictionary objectForKey:@"remote_key"];
}

- (void)dealloc
{
    [accessCredentials release];
    [domain release];
    [followers release];
    [following release];
    [friends release];
    [identifier release];
    [profile release];
    [provider release];
    [remote_key release];

    [super dealloc];
}
@end
