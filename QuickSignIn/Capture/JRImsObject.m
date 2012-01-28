
#import "JRImsObject.h"

@implementation JRImsObject
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

+ (id)imsObject
{
    return [[[JRImsObject alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRImsObject *imsObjectCopy =
                [[JRImsObject allocWithZone:zone] init];

    imsObjectCopy.primary = self.primary;
    imsObjectCopy.type = self.type;
    imsObjectCopy.value = self.value;

    return imsObjectCopy;
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
