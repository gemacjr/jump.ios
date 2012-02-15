
#import "JRPhoneNumbers.h"

@implementation JRPhoneNumbers
@synthesize primary;
@synthesize type;
@synthesize value;

- (id)init
{
    if ((self = [super init]))
    {
    }
    return self;
}

+ (id)phoneNumbers
{
    return [[[JRPhoneNumbers alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPhoneNumbers *phoneNumbersCopy =
                [[JRPhoneNumbers allocWithZone:zone] init];

    phoneNumbersCopy.primary = self.primary;
    phoneNumbersCopy.type = self.type;
    phoneNumbersCopy.value = self.value;

    return phoneNumbersCopy;
}

+ (id)phoneNumbersObjectFromDictionary:(NSDictionary*)dictionary
{
    JRPhoneNumbers *phoneNumbers =
        [JRPhoneNumbers phoneNumbers];

    phoneNumbers.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    phoneNumbers.type = [dictionary objectForKey:@"type"];
    phoneNumbers.value = [dictionary objectForKey:@"value"];

    return phoneNumbers;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (primary)
        [dict setObject:[NSNumber numberWithBool:primary] forKey:@"primary"];

    if (type)
        [dict setObject:type forKey:@"type"];

    if (value)
        [dict setObject:value forKey:@"value"];

    return dict;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"primary"])
        self.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];

    if ([dictionary objectForKey:@"type"])
        self.type = [dictionary objectForKey:@"type"];

    if ([dictionary objectForKey:@"value"])
        self.value = [dictionary objectForKey:@"value"];
}

- (void)dealloc
{
    [type release];
    [value release];

    [super dealloc];
}
@end
