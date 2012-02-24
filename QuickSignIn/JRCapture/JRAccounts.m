/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import "JRAccounts.h"

@implementation JRAccounts
@synthesize accountsId;
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

    accountsCopy.accountsId = self.accountsId;
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

    accounts.accountsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    accounts.domain = [dictionary objectForKey:@"domain"];
    accounts.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    accounts.userid = [dictionary objectForKey:@"userid"];
    accounts.username = [dictionary objectForKey:@"username"];

    return accounts;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (accountsId)
        [dict setObject:[NSNumber numberWithInt:accountsId] forKey:@"id"];

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

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"accountsId"])
        self.accountsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"domain"])
        self.domain = [dictionary objectForKey:@"domain"];

    if ([dictionary objectForKey:@"primary"])
        self.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];

    if ([dictionary objectForKey:@"userid"])
        self.userid = [dictionary objectForKey:@"userid"];

    if ([dictionary objectForKey:@"username"])
        self.username = [dictionary objectForKey:@"username"];
}

- (void)dealloc
{
    [domain release];
    [userid release];
    [username release];

    [super dealloc];
}
@end
