
#import "JRLocationObject.h"

@implementation JRLocationObject
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

+ (id)locationObject
{
    return [[[JRLocationObject alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRLocationObject *locationObjectCopy =
                [[JRLocationObject allocWithZone:zone] init];

    locationObjectCopy.country = self.country;
    locationObjectCopy.extendedAddress = self.extendedAddress;
    locationObjectCopy.formatted = self.formatted;
    locationObjectCopy.latitude = self.latitude;
    locationObjectCopy.locality = self.locality;
    locationObjectCopy.longitude = self.longitude;
    locationObjectCopy.poBox = self.poBox;
    locationObjectCopy.postalCode = self.postalCode;
    locationObjectCopy.region = self.region;
    locationObjectCopy.streetAddress = self.streetAddress;
    locationObjectCopy.type = self.type;

    return locationObjectCopy;
}

+ (id)locationObjectFromDictionary:(NSDictionary*)dictionary
{
    JRLocationObject *locationObject =
        [JRLocationObject locationObject];

    locationObject.country = [dictionary objectForKey:@"country"];
    locationObject.extendedAddress = [dictionary objectForKey:@"extendedAddress"];
    locationObject.formatted = [dictionary objectForKey:@"formatted"];
    locationObject.latitude = [dictionary objectForKey:@"latitude"];
    locationObject.locality = [dictionary objectForKey:@"locality"];
    locationObject.longitude = [dictionary objectForKey:@"longitude"];
    locationObject.poBox = [dictionary objectForKey:@"poBox"];
    locationObject.postalCode = [dictionary objectForKey:@"postalCode"];
    locationObject.region = [dictionary objectForKey:@"region"];
    locationObject.streetAddress = [dictionary objectForKey:@"streetAddress"];
    locationObject.type = [dictionary objectForKey:@"type"];

    return locationObject;
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
