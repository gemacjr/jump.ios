
#import "JRPrimaryAddress.h"

@implementation JRPrimaryAddress
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

+ (id)primaryAddress
{
    return [[[JRPrimaryAddress alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPrimaryAddress *primaryAddressCopy =
                [[JRPrimaryAddress allocWithZone:zone] init];

    primaryAddressCopy.address1 = self.address1;
    primaryAddressCopy.address2 = self.address2;
    primaryAddressCopy.city = self.city;
    primaryAddressCopy.company = self.company;
    primaryAddressCopy.mobile = self.mobile;
    primaryAddressCopy.phone = self.phone;
    primaryAddressCopy.stateAbbreviation = self.stateAbbreviation;
    primaryAddressCopy.zip = self.zip;
    primaryAddressCopy.zipPlus4 = self.zipPlus4;

    return primaryAddressCopy;
}

+ (id)primaryAddressObjectFromDictionary:(NSDictionary*)dictionary
{
    JRPrimaryAddress *primaryAddress =
        [JRPrimaryAddress primaryAddress];

    primaryAddress.address1 = [dictionary objectForKey:@"address1"];
    primaryAddress.address2 = [dictionary objectForKey:@"address2"];
    primaryAddress.city = [dictionary objectForKey:@"city"];
    primaryAddress.company = [dictionary objectForKey:@"company"];
    primaryAddress.mobile = [dictionary objectForKey:@"mobile"];
    primaryAddress.phone = [dictionary objectForKey:@"phone"];
    primaryAddress.stateAbbreviation = [dictionary objectForKey:@"stateAbbreviation"];
    primaryAddress.zip = [dictionary objectForKey:@"zip"];
    primaryAddress.zipPlus4 = [dictionary objectForKey:@"zipPlus4"];

    return primaryAddress;
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

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"address1"])
        self.address1 = [dictionary objectForKey:@"address1"];

    if ([dictionary objectForKey:@"address2"])
        self.address2 = [dictionary objectForKey:@"address2"];

    if ([dictionary objectForKey:@"city"])
        self.city = [dictionary objectForKey:@"city"];

    if ([dictionary objectForKey:@"company"])
        self.company = [dictionary objectForKey:@"company"];

    if ([dictionary objectForKey:@"mobile"])
        self.mobile = [dictionary objectForKey:@"mobile"];

    if ([dictionary objectForKey:@"phone"])
        self.phone = [dictionary objectForKey:@"phone"];

    if ([dictionary objectForKey:@"stateAbbreviation"])
        self.stateAbbreviation = [dictionary objectForKey:@"stateAbbreviation"];

    if ([dictionary objectForKey:@"zip"])
        self.zip = [dictionary objectForKey:@"zip"];

    if ([dictionary objectForKey:@"zipPlus4"])
        self.zipPlus4 = [dictionary objectForKey:@"zipPlus4"];
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
