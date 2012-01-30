
#import "JRName.h"

@implementation JRName
@synthesize familyName;
@synthesize formatted;
@synthesize givenName;
@synthesize honorificPrefix;
@synthesize honorificSuffix;
@synthesize middleName;

- (id)init
{
    if ((self = [super init]))
    {
    }
    return self;
}

+ (id)name
{
    return [[[JRName alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRName *nameCopy =
                [[JRName allocWithZone:zone] init];

    nameCopy.familyName = self.familyName;
    nameCopy.formatted = self.formatted;
    nameCopy.givenName = self.givenName;
    nameCopy.honorificPrefix = self.honorificPrefix;
    nameCopy.honorificSuffix = self.honorificSuffix;
    nameCopy.middleName = self.middleName;

    return nameCopy;
}

+ (id)nameObjectFromDictionary:(NSDictionary*)dictionary
{
    JRName *name =
        [JRName name];

    name.familyName = [dictionary objectForKey:@"familyName"];
    name.formatted = [dictionary objectForKey:@"formatted"];
    name.givenName = [dictionary objectForKey:@"givenName"];
    name.honorificPrefix = [dictionary objectForKey:@"honorificPrefix"];
    name.honorificSuffix = [dictionary objectForKey:@"honorificSuffix"];
    name.middleName = [dictionary objectForKey:@"middleName"];

    return name;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (familyName)
        [dict setObject:familyName forKey:@"familyName"];

    if (formatted)
        [dict setObject:formatted forKey:@"formatted"];

    if (givenName)
        [dict setObject:givenName forKey:@"givenName"];

    if (honorificPrefix)
        [dict setObject:honorificPrefix forKey:@"honorificPrefix"];

    if (honorificSuffix)
        [dict setObject:honorificSuffix forKey:@"honorificSuffix"];

    if (middleName)
        [dict setObject:middleName forKey:@"middleName"];

    return dict;
}

- (void)dealloc
{
    [familyName release];
    [formatted release];
    [givenName release];
    [honorificPrefix release];
    [honorificSuffix release];
    [middleName release];

    [super dealloc];
}
@end
