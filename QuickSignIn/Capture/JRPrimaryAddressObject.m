
#import "JRPrimaryAddressObject.h"

@implementation JRPrimaryAddressObject
@synthesize address1;
@synthesize address2;
@synthesize city;
@synthesize company;
@synthesize mobile;
@synthesize phone;
@synthesize stateAbbreviation;
@synthesize zip;
@synthesize zipPlus4;

- (id)init
{
    if ((self = [super init]))
    {
    }
    return self;
}

+ (id)primaryAddressObject
{
    return [[[JRPrimaryAddressObject alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPrimaryAddressObject *primaryAddressObjectCopy =
                [[JRPrimaryAddressObject allocWithZone:zone] init];

    primaryAddressObjectCopy.address1 = self.address1;
    primaryAddressObjectCopy.address2 = self.address2;
    primaryAddressObjectCopy.city = self.city;
    primaryAddressObjectCopy.company = self.company;
    primaryAddressObjectCopy.mobile = self.mobile;
    primaryAddressObjectCopy.phone = self.phone;
    primaryAddressObjectCopy.stateAbbreviation = self.stateAbbreviation;
    primaryAddressObjectCopy.zip = self.zip;
    primaryAddressObjectCopy.zipPlus4 = self.zipPlus4;

    return primaryAddressObjectCopy;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (address1)
        [dict setObject:address1 forKey:@"address1"];

    if (address2)
        [dict setObject:address2 forKey:@"address2"];

    if (city)
        [dict setObject:city forKey:@"city"];

    if (company)
        [dict setObject:company forKey:@"company"];

    if (mobile)
        [dict setObject:mobile forKey:@"mobile"];

    if (phone)
        [dict setObject:phone forKey:@"phone"];

    if (stateAbbreviation)
        [dict setObject:stateAbbreviation forKey:@"stateAbbreviation"];

    if (zip)
        [dict setObject:zip forKey:@"zip"];

    if (zipPlus4)
        [dict setObject:zipPlus4 forKey:@"zipPlus4"];

    return dict;
}

- (void)dealloc
{
    [address1 release];
    [address2 release];
    [city release];
    [company release];
    [mobile release];
    [phone release];
    [stateAbbreviation release];
    [zip release];
    [zipPlus4 release];

    [super dealloc];
}
@end
