
#import "JROrganizations.h"

@implementation JROrganizations
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

+ (id)organizations
{
    return [[[JROrganizations alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JROrganizations *organizationsCopy =
                [[JROrganizations allocWithZone:zone] init];

    organizationsCopy.department = self.department;
    organizationsCopy.description = self.description;
    organizationsCopy.endDate = self.endDate;
    organizationsCopy.location = self.location;
    organizationsCopy.name = self.name;
    organizationsCopy.primary = self.primary;
    organizationsCopy.startDate = self.startDate;
    organizationsCopy.title = self.title;
    organizationsCopy.type = self.type;

    return organizationsCopy;
}

+ (id)organizationsObjectFromDictionary:(NSDictionary*)dictionary
{
    JROrganizations *organizations =
        [JROrganizations organizations];

    organizations.department = [dictionary objectForKey:@"department"];
    organizations.description = [dictionary objectForKey:@"description"];
    organizations.endDate = [dictionary objectForKey:@"endDate"];
    organizations.location = [JRLocation locationObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"location"]];
    organizations.name = [dictionary objectForKey:@"name"];
    organizations.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    organizations.startDate = [dictionary objectForKey:@"startDate"];
    organizations.title = [dictionary objectForKey:@"title"];
    organizations.type = [dictionary objectForKey:@"type"];

    return organizations;
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

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"department"])
        self.department = [dictionary objectForKey:@"department"];

    if ([dictionary objectForKey:@"description"])
        self.description = [dictionary objectForKey:@"description"];

    if ([dictionary objectForKey:@"endDate"])
        self.endDate = [dictionary objectForKey:@"endDate"];

    if ([dictionary objectForKey:@"location"])
        self.location = [JRLocation locationObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"location"]];

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"];

    if ([dictionary objectForKey:@"primary"])
        self.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];

    if ([dictionary objectForKey:@"startDate"])
        self.startDate = [dictionary objectForKey:@"startDate"];

    if ([dictionary objectForKey:@"title"])
        self.title = [dictionary objectForKey:@"title"];

    if ([dictionary objectForKey:@"type"])
        self.type = [dictionary objectForKey:@"type"];
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
