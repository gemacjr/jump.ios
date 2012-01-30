
#import "JRPhotosObject.h"

@implementation JRPhotosObject
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

+ (id)photosObject
{
    return [[[JRPhotosObject alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPhotosObject *photosObjectCopy =
                [[JRPhotosObject allocWithZone:zone] init];

    photosObjectCopy.primary = self.primary;
    photosObjectCopy.type = self.type;
    photosObjectCopy.value = self.value;

    return photosObjectCopy;
}

+ (id)photosObjectFromDictionary:(NSDictionary*)dictionary
{
    JRPhotosObject *photosObject =
        [JRPhotosObject photosObject];

    photosObject.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    photosObject.type = [dictionary objectForKey:@"type"];
    photosObject.value = [dictionary objectForKey:@"value"];

    return photosObject;
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
