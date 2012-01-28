
#import "JRAccountsObject.h"

@implementation JRAccountsObject
@synthesize domain;
@synthesize primary;
@synthesize userid;
@synthesize username;

- (id)init
{
    if ((self = [super init]))
    {
    }
    return self;
}

+ (id)accountsObject
{
    return [[[JRAccountsObject alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRAccountsObject *accountsObjectCopy =
                [[JRAccountsObject allocWithZone:zone] init];

    accountsObjectCopy.domain = self.domain;
    accountsObjectCopy.primary = self.primary;
    accountsObjectCopy.userid = self.userid;
    accountsObjectCopy.username = self.username;

    return accountsObjectCopy;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (domain)
        [dict setObject:domain forKey:@"domain"];

    if (primary)
        [dict setObject:[NSNumber numberWithBool:primary] forKey:@"primary"];

    if (userid)
        [dict setObject:userid forKey:@"userid"];

    if (username)
        [dict setObject:username forKey:@"username"];

    return dict;
}

- (void)dealloc
{
    [domain release];
    [userid release];
    [username release];

    [super dealloc];
}
@end
