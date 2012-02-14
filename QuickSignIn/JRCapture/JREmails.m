
#import "JREmails.h"

@implementation JREmails
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

+ (id)emails
{
    return [[[JREmails alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JREmails *emailsCopy =
                [[JREmails allocWithZone:zone] init];

    emailsCopy.primary = self.primary;
    emailsCopy.type = self.type;
    emailsCopy.value = self.value;

    return emailsCopy;
}

+ (id)emailsObjectFromDictionary:(NSDictionary*)dictionary
{
    JREmails *emails =
        [JREmails emails];

    emails.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    emails.type = [dictionary objectForKey:@"type"];
    emails.value = [dictionary objectForKey:@"value"];

    return emails;
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
