
#import "JRBodyTypeObject.h"

@implementation JRBodyTypeObject
@synthesize build;
@synthesize color;
@synthesize eyeColor;
@synthesize hairColor;
@synthesize height;

- (id)init
{
    if ((self = [super init]))
    {
    }
    return self;
}

+ (id)bodyTypeObject
{
    return [[[JRBodyTypeObject alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRBodyTypeObject *bodyTypeObjectCopy =
                [[JRBodyTypeObject allocWithZone:zone] init];

    bodyTypeObjectCopy.build = self.build;
    bodyTypeObjectCopy.color = self.color;
    bodyTypeObjectCopy.eyeColor = self.eyeColor;
    bodyTypeObjectCopy.hairColor = self.hairColor;
    bodyTypeObjectCopy.height = self.height;

    return bodyTypeObjectCopy;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (build)
        [dict setObject:build forKey:@"build"];

    if (color)
        [dict setObject:color forKey:@"color"];

    if (eyeColor)
        [dict setObject:eyeColor forKey:@"eyeColor"];

    if (hairColor)
        [dict setObject:hairColor forKey:@"hairColor"];

    if (height)
        [dict setObject:height forKey:@"height"];

    return dict;
}

- (void)dealloc
{
    [build release];
    [color release];
    [eyeColor release];
    [hairColor release];
    [height release];

    [super dealloc];
}
@end
