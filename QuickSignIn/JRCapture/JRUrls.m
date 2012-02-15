
#import "JRUrls.h"

@implementation JRUrls
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

+ (id)urls
{
    return [[[JRUrls alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRUrls *urlsCopy =
                [[JRUrls allocWithZone:zone] init];

    urlsCopy.primary = self.primary;
    urlsCopy.type = self.type;
    urlsCopy.value = self.value;

    return urlsCopy;
}

+ (id)urlsObjectFromDictionary:(NSDictionary*)dictionary
{
    JRUrls *urls =
        [JRUrls urls];

    urls.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    urls.type = [dictionary objectForKey:@"type"];
    urls.value = [dictionary objectForKey:@"value"];

    return urls;
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
