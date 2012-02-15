
#import "JRCurrentLocation.h"

@implementation JRCurrentLocation
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

+ (id)currentLocation
{
    return [[[JRCurrentLocation alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRCurrentLocation *currentLocationCopy =
                [[JRCurrentLocation allocWithZone:zone] init];

    currentLocationCopy.country = self.country;
    currentLocationCopy.extendedAddress = self.extendedAddress;
    currentLocationCopy.formatted = self.formatted;
    currentLocationCopy.latitude = self.latitude;
    currentLocationCopy.locality = self.locality;
    currentLocationCopy.longitude = self.longitude;
    currentLocationCopy.poBox = self.poBox;
    currentLocationCopy.postalCode = self.postalCode;
    currentLocationCopy.region = self.region;
    currentLocationCopy.streetAddress = self.streetAddress;
    currentLocationCopy.type = self.type;

    return currentLocationCopy;
}

+ (id)currentLocationObjectFromDictionary:(NSDictionary*)dictionary
{
    JRCurrentLocation *currentLocation =
        [JRCurrentLocation currentLocation];

    currentLocation.country = [dictionary objectForKey:@"country"];
    currentLocation.extendedAddress = [dictionary objectForKey:@"extendedAddress"];
    currentLocation.formatted = [dictionary objectForKey:@"formatted"];
    currentLocation.latitude = [dictionary objectForKey:@"latitude"];
    currentLocation.locality = [dictionary objectForKey:@"locality"];
    currentLocation.longitude = [dictionary objectForKey:@"longitude"];
    currentLocation.poBox = [dictionary objectForKey:@"poBox"];
    currentLocation.postalCode = [dictionary objectForKey:@"postalCode"];
    currentLocation.region = [dictionary objectForKey:@"region"];
    currentLocation.streetAddress = [dictionary objectForKey:@"streetAddress"];
    currentLocation.type = [dictionary objectForKey:@"type"];

    return currentLocation;
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

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"country"])
        self.country = [dictionary objectForKey:@"country"];

    if ([dictionary objectForKey:@"extendedAddress"])
        self.extendedAddress = [dictionary objectForKey:@"extendedAddress"];

    if ([dictionary objectForKey:@"formatted"])
        self.formatted = [dictionary objectForKey:@"formatted"];

    if ([dictionary objectForKey:@"latitude"])
        self.latitude = [dictionary objectForKey:@"latitude"];

    if ([dictionary objectForKey:@"locality"])
        self.locality = [dictionary objectForKey:@"locality"];

    if ([dictionary objectForKey:@"longitude"])
        self.longitude = [dictionary objectForKey:@"longitude"];

    if ([dictionary objectForKey:@"poBox"])
        self.poBox = [dictionary objectForKey:@"poBox"];

    if ([dictionary objectForKey:@"postalCode"])
        self.postalCode = [dictionary objectForKey:@"postalCode"];

    if ([dictionary objectForKey:@"region"])
        self.region = [dictionary objectForKey:@"region"];

    if ([dictionary objectForKey:@"streetAddress"])
        self.streetAddress = [dictionary objectForKey:@"streetAddress"];

    if ([dictionary objectForKey:@"type"])
        self.type = [dictionary objectForKey:@"type"];
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
