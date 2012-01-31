
#import "JRStatuses.h"

@implementation JRStatuses
@synthesize status;
@synthesize statusCreated;

- (id)init
{
    if ((self = [super init]))
    {
    }
    return self;
}

+ (id)statuses
{
    return [[[JRStatuses alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRStatuses *statusesCopy =
                [[JRStatuses allocWithZone:zone] init];

    statusesCopy.status = self.status;
    statusesCopy.statusCreated = self.statusCreated;

    return statusesCopy;
}

+ (id)statusesObjectFromDictionary:(NSDictionary*)dictionary
{
    JRStatuses *statuses =
        [JRStatuses statuses];

    statuses.status = [dictionary objectForKey:@"status"];
    statuses.statusCreated = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"statusCreated"]];

    return statuses;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (status)
        [dict setObject:status forKey:@"status"];

    if (statusCreated)
        [dict setObject:[statusCreated stringFromISO8601DateTime] forKey:@"statusCreated"];

    return dict;
}

- (void)dealloc
{
    [status release];
    [statusCreated release];

    [super dealloc];
}
@end
