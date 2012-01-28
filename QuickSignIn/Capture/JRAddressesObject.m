
#import "JRAddressesObject.h"

@implementation JRAddressesObject
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

+ (id)addressesObject
{
    return [[[JRAddressesObject alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRAddressesObject *addressesObjectCopy =
                [[JRAddressesObject allocWithZone:zone] init];

    addressesObjectCopy.country = self.country;
    addressesObjectCopy.extendedAddress = self.extendedAddress;
    addressesObjectCopy.formatted = self.formatted;
    addressesObjectCopy.latitude = self.latitude;
    addressesObjectCopy.locality = self.locality;
    addressesObjectCopy.longitude = self.longitude;
    addressesObjectCopy.poBox = self.poBox;
    addressesObjectCopy.postalCode = self.postalCode;
    addressesObjectCopy.primary = self.primary;
    addressesObjectCopy.region = self.region;
    addressesObjectCopy.streetAddress = self.streetAddress;
    addressesObjectCopy.type = self.type;

    return addressesObjectCopy;
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
