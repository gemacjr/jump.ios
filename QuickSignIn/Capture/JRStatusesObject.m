
#import "JRStatusesObject.h"

@implementation JRStatusesObject
@synthesize status;
@synthesize statusCreated;

- (id)init
{
    if ((self = [super init]))
    {
    }
    return self;
}

+ (id)statusesObject
{
    return [[[JRStatusesObject alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRStatusesObject *statusesObjectCopy =
                [[JRStatusesObject allocWithZone:zone] init];

    statusesObjectCopy.status = self.status;
    statusesObjectCopy.statusCreated = self.statusCreated;

    return statusesObjectCopy;
}

+ (id)statusesObjectFromDictionary:(NSDictionary*)dictionary
{
    JRStatusesObject *statusesObject =
        [JRStatusesObject statusesObject];

    statusesObject.status = [dictionary objectForKey:@"status"];
    statusesObject.statusCreated = [dictionary objectForKey:@"statusCreated"];

    return statusesObject;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (status)
        [dict setObject:status forKey:@"status"];

    if (statusCreated)
        [dict setObject:statusCreated forKey:@"statusCreated"];

    return dict;
}

- (void)dealloc
{
    [status release];
    [statusCreated release];

    [super dealloc];
}
@end
