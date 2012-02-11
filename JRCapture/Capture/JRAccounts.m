
#import "JRAccounts.h"

@implementation JRAccounts
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

+ (id)accounts
{
    return [[[JRAccounts alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRAccounts *accountsCopy =
                [[JRAccounts allocWithZone:zone] init];

    accountsCopy.domain = self.domain;
    accountsCopy.primary = self.primary;
    accountsCopy.userid = self.userid;
    accountsCopy.username = self.username;

    return accountsCopy;
}

+ (id)accountsObjectFromDictionary:(NSDictionary*)dictionary
{
    JRAccounts *accounts =
        [JRAccounts accounts];

    accounts.domain = [dictionary objectForKey:@"domain"];
    accounts.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    accounts.userid = [dictionary objectForKey:@"userid"];
    accounts.username = [dictionary objectForKey:@"username"];

    return accounts;
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
