
#import "JROrganizationsObject.h"

@implementation JROrganizationsObject
@synthesize department;
@synthesize description;
@synthesize endDate;
@synthesize location;
@synthesize name;
@synthesize primary;
@synthesize startDate;
@synthesize title;
@synthesize type;

- (id)init
{
    if ((self = [super init]))
    {
    }
    return self;
}

+ (id)organizationsObject
{
    return [[[JROrganizationsObject alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JROrganizationsObject *organizationsObjectCopy =
                [[JROrganizationsObject allocWithZone:zone] init];

    organizationsObjectCopy.department = self.department;
    organizationsObjectCopy.description = self.description;
    organizationsObjectCopy.endDate = self.endDate;
    organizationsObjectCopy.location = self.location;
    organizationsObjectCopy.name = self.name;
    organizationsObjectCopy.primary = self.primary;
    organizationsObjectCopy.startDate = self.startDate;
    organizationsObjectCopy.title = self.title;
    organizationsObjectCopy.type = self.type;

    return organizationsObjectCopy;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (department)
        [dict setObject:department forKey:@"department"];

    if (description)
        [dict setObject:description forKey:@"description"];

    if (endDate)
        [dict setObject:endDate forKey:@"endDate"];

    if (location)
        [dict setObject:[location dictionaryFromObject] forKey:@"location"];

    if (name)
        [dict setObject:name forKey:@"name"];

    if (primary)
        [dict setObject:[NSNumber numberWithBool:primary] forKey:@"primary"];

    if (startDate)
        [dict setObject:startDate forKey:@"startDate"];

    if (title)
        [dict setObject:title forKey:@"title"];

    if (type)
        [dict setObject:type forKey:@"type"];

    return dict;
}

- (void)dealloc
{
    [department release];
    [description release];
    [endDate release];
    [location release];
    [name release];
    [startDate release];
    [title release];
    [type release];

    [super dealloc];
}
@end
