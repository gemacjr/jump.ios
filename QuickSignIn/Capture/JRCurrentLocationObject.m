
#import "JRCurrentLocationObject.h"

@implementation JRCurrentLocationObject
@synthesize country;
@synthesize extendedAddress;
@synthesize formatted;
@synthesize latitude;
@synthesize locality;
@synthesize longitude;
@synthesize poBox;
@synthesize postalCode;
@synthesize region;
@synthesize streetAddress;
@synthesize type;

- (id)init
{
    if ((self = [super init]))
    {
    }
    return self;
}

+ (id)currentLocationObject
{
    return [[[JRCurrentLocationObject alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRCurrentLocationObject *currentLocationObjectCopy =
                [[JRCurrentLocationObject allocWithZone:zone] init];

    currentLocationObjectCopy.country = self.country;
    currentLocationObjectCopy.extendedAddress = self.extendedAddress;
    currentLocationObjectCopy.formatted = self.formatted;
    currentLocationObjectCopy.latitude = self.latitude;
    currentLocationObjectCopy.locality = self.locality;
    currentLocationObjectCopy.longitude = self.longitude;
    currentLocationObjectCopy.poBox = self.poBox;
    currentLocationObjectCopy.postalCode = self.postalCode;
    currentLocationObjectCopy.region = self.region;
    currentLocationObjectCopy.streetAddress = self.streetAddress;
    currentLocationObjectCopy.type = self.type;

    return currentLocationObjectCopy;
}

+ (id)currentLocationObjectFromDictionary:(NSDictionary*)dictionary
{
    JRCurrentLocationObject *currentLocationObject =
        [JRCurrentLocationObject currentLocationObject];

    currentLocationObject.country = [dictionary objectForKey:@"country"];
    currentLocationObject.extendedAddress = [dictionary objectForKey:@"extendedAddress"];
    currentLocationObject.formatted = [dictionary objectForKey:@"formatted"];
    currentLocationObject.latitude = [dictionary objectForKey:@"latitude"];
    currentLocationObject.locality = [dictionary objectForKey:@"locality"];
    currentLocationObject.longitude = [dictionary objectForKey:@"longitude"];
    currentLocationObject.poBox = [dictionary objectForKey:@"poBox"];
    currentLocationObject.postalCode = [dictionary objectForKey:@"postalCode"];
    currentLocationObject.region = [dictionary objectForKey:@"region"];
    currentLocationObject.streetAddress = [dictionary objectForKey:@"streetAddress"];
    currentLocationObject.type = [dictionary objectForKey:@"type"];

    return currentLocationObject;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (country)
        [dict setObject:country forKey:@"country"];

    if (extendedAddress)
        [dict setObject:extendedAddress forKey:@"extendedAddress"];

    if (formatted)
        [dict setObject:formatted forKey:@"formatted"];

    if (latitude)
        [dict setObject:latitude forKey:@"latitude"];

    if (locality)
        [dict setObject:locality forKey:@"locality"];

    if (longitude)
        [dict setObject:longitude forKey:@"longitude"];

    if (poBox)
        [dict setObject:poBox forKey:@"poBox"];

    if (postalCode)
        [dict setObject:postalCode forKey:@"postalCode"];

    if (region)
        [dict setObject:region forKey:@"region"];

    if (streetAddress)
        [dict setObject:streetAddress forKey:@"streetAddress"];

    if (type)
        [dict setObject:type forKey:@"type"];

    return dict;
}

- (void)dealloc
{
    [country release];
    [extendedAddress release];
    [formatted release];
    [latitude release];
    [locality release];
    [longitude release];
    [poBox release];
    [postalCode release];
    [region release];
    [streetAddress release];
    [type release];

    [super dealloc];
}
@end
