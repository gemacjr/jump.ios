
#import "JRIms.h"

@implementation JRIms
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

+ (id)ims
{
    return [[[JRIms alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRIms *imsCopy =
                [[JRIms allocWithZone:zone] init];

    imsCopy.primary = self.primary;
    imsCopy.type = self.type;
    imsCopy.value = self.value;

    return imsCopy;
}

+ (id)imsObjectFromDictionary:(NSDictionary*)dictionary
{
    JRIms *ims =
        [JRIms ims];

    ims.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    ims.type = [dictionary objectForKey:@"type"];
    ims.value = [dictionary objectForKey:@"value"];

    return ims;
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
