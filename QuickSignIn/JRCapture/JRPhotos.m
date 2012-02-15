
#import "JRPhotos.h"

@implementation JRPhotos
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

+ (id)photos
{
    return [[[JRPhotos alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPhotos *photosCopy =
                [[JRPhotos allocWithZone:zone] init];

    photosCopy.primary = self.primary;
    photosCopy.type = self.type;
    photosCopy.value = self.value;

    return photosCopy;
}

+ (id)photosObjectFromDictionary:(NSDictionary*)dictionary
{
    JRPhotos *photos =
        [JRPhotos photos];

    photos.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    photos.type = [dictionary objectForKey:@"type"];
    photos.value = [dictionary objectForKey:@"value"];

    return photos;
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
