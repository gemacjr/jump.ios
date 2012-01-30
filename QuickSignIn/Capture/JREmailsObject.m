
#import "JREmailsObject.h"

@implementation JREmailsObject
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

+ (id)emailsObject
{
    return [[[JREmailsObject alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JREmailsObject *emailsObjectCopy =
                [[JREmailsObject allocWithZone:zone] init];

    emailsObjectCopy.primary = self.primary;
    emailsObjectCopy.type = self.type;
    emailsObjectCopy.value = self.value;

    return emailsObjectCopy;
}

+ (id)emailsObjectFromDictionary:(NSDictionary*)dictionary
{
    JREmailsObject *emailsObject =
        [JREmailsObject emailsObject];

    emailsObject.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    emailsObject.type = [dictionary objectForKey:@"type"];
    emailsObject.value = [dictionary objectForKey:@"value"];

    return emailsObject;
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
