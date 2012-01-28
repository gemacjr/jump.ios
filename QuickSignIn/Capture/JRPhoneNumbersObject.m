
#import "JRPhoneNumbersObject.h"

@implementation JRPhoneNumbersObject
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

+ (id)phoneNumbersObject
{
    return [[[JRPhoneNumbersObject alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPhoneNumbersObject *phoneNumbersObjectCopy =
                [[JRPhoneNumbersObject allocWithZone:zone] init];

    phoneNumbersObjectCopy.primary = self.primary;
    phoneNumbersObjectCopy.type = self.type;
    phoneNumbersObjectCopy.value = self.value;

    return phoneNumbersObjectCopy;
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

- (void)dealloc
{
    [type release];
    [value release];

    [super dealloc];
}
@end
