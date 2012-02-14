
#import "JRAddresses.h"

@implementation JRAddresses
@synthesize country;
@synthesize extendedAddress;
@synthesize formatted;
@synthesize latitude;
@synthesize locality;
@synthesize longitude;
@synthesize poBox;
@synthesize postalCode;
@synthesize primary;
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

+ (id)addresses
{
    return [[[JRAddresses alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRAddresses *addressesCopy =
                [[JRAddresses allocWithZone:zone] init];

    addressesCopy.country = self.country;
    addressesCopy.extendedAddress = self.extendedAddress;
    addressesCopy.formatted = self.formatted;
    addressesCopy.latitude = self.latitude;
    addressesCopy.locality = self.locality;
    addressesCopy.longitude = self.longitude;
    addressesCopy.poBox = self.poBox;
    addressesCopy.postalCode = self.postalCode;
    addressesCopy.primary = self.primary;
    addressesCopy.region = self.region;
    addressesCopy.streetAddress = self.streetAddress;
    addressesCopy.type = self.type;

    return addressesCopy;
}

+ (id)addressesObjectFromDictionary:(NSDictionary*)dictionary
{
    JRAddresses *addresses =
        [JRAddresses addresses];

    addresses.country = [dictionary objectForKey:@"country"];
    addresses.extendedAddress = [dictionary objectForKey:@"extendedAddress"];
    addresses.formatted = [dictionary objectForKey:@"formatted"];
    addresses.latitude = [dictionary objectForKey:@"latitude"];
    addresses.locality = [dictionary objectForKey:@"locality"];
    addresses.longitude = [dictionary objectForKey:@"longitude"];
    addresses.poBox = [dictionary objectForKey:@"poBox"];
    addresses.postalCode = [dictionary objectForKey:@"postalCode"];
    addresses.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    addresses.region = [dictionary objectForKey:@"region"];
    addresses.streetAddress = [dictionary objectForKey:@"streetAddress"];
    addresses.type = [dictionary objectForKey:@"type"];

    return addresses;
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

    if (primary)
        [dict setObject:[NSNumber numberWithBool:primary] forKey:@"primary"];

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
