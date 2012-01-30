
#import "JRLocation.h"

@implementation JRLocation
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

+ (id)location
{
    return [[[JRLocation alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRLocation *locationCopy =
                [[JRLocation allocWithZone:zone] init];

    locationCopy.country = self.country;
    locationCopy.extendedAddress = self.extendedAddress;
    locationCopy.formatted = self.formatted;
    locationCopy.latitude = self.latitude;
    locationCopy.locality = self.locality;
    locationCopy.longitude = self.longitude;
    locationCopy.poBox = self.poBox;
    locationCopy.postalCode = self.postalCode;
    locationCopy.region = self.region;
    locationCopy.streetAddress = self.streetAddress;
    locationCopy.type = self.type;

    return locationCopy;
}

+ (id)locationObjectFromDictionary:(NSDictionary*)dictionary
{
    JRLocation *location =
        [JRLocation location];

    location.country = [dictionary objectForKey:@"country"];
    location.extendedAddress = [dictionary objectForKey:@"extendedAddress"];
    location.formatted = [dictionary objectForKey:@"formatted"];
    location.latitude = [dictionary objectForKey:@"latitude"];
    location.locality = [dictionary objectForKey:@"locality"];
    location.longitude = [dictionary objectForKey:@"longitude"];
    location.poBox = [dictionary objectForKey:@"poBox"];
    location.postalCode = [dictionary objectForKey:@"postalCode"];
    location.region = [dictionary objectForKey:@"region"];
    location.streetAddress = [dictionary objectForKey:@"streetAddress"];
    location.type = [dictionary objectForKey:@"type"];

    return location;
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
