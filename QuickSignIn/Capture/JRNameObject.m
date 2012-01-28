
#import "JRNameObject.h"

@implementation JRNameObject
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

+ (id)nameObject
{
    return [[[JRNameObject alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRNameObject *nameObjectCopy =
                [[JRNameObject allocWithZone:zone] init];

    nameObjectCopy.familyName = self.familyName;
    nameObjectCopy.formatted = self.formatted;
    nameObjectCopy.givenName = self.givenName;
    nameObjectCopy.honorificPrefix = self.honorificPrefix;
    nameObjectCopy.honorificSuffix = self.honorificSuffix;
    nameObjectCopy.middleName = self.middleName;

    return nameObjectCopy;
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
