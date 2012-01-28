
#import "JRUrlsObject.h"

@implementation JRUrlsObject
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

+ (id)urlsObject
{
    return [[[JRUrlsObject alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRUrlsObject *urlsObjectCopy =
                [[JRUrlsObject allocWithZone:zone] init];

    urlsObjectCopy.primary = self.primary;
    urlsObjectCopy.type = self.type;
    urlsObjectCopy.value = self.value;

    return urlsObjectCopy;
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
