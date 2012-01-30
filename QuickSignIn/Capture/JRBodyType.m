
#import "JRBodyType.h"

@implementation JRBodyType
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

+ (id)bodyType
{
    return [[[JRBodyType alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRBodyType *bodyTypeCopy =
                [[JRBodyType allocWithZone:zone] init];

    bodyTypeCopy.build = self.build;
    bodyTypeCopy.color = self.color;
    bodyTypeCopy.eyeColor = self.eyeColor;
    bodyTypeCopy.hairColor = self.hairColor;
    bodyTypeCopy.height = self.height;

    return bodyTypeCopy;
}

+ (id)bodyTypeObjectFromDictionary:(NSDictionary*)dictionary
{
    JRBodyType *bodyType =
        [JRBodyType bodyType];

    bodyType.build = [dictionary objectForKey:@"build"];
    bodyType.color = [dictionary objectForKey:@"color"];
    bodyType.eyeColor = [dictionary objectForKey:@"eyeColor"];
    bodyType.hairColor = [dictionary objectForKey:@"hairColor"];
    bodyType.height = [dictionary objectForKey:@"height"];

    return bodyType;
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
