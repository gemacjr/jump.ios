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


#import "JRProfiles.h"

@interface NSArray (FollowersToFromDictionary)
- (NSArray*)arrayOfFollowersDictionariesFromFollowersObjects;
- (NSArray*)arrayOfFollowersObjectsFromFollowersDictionaries;
@end

@implementation NSArray (FollowersToFromDictionary)
- (NSArray*)arrayOfFollowersDictionariesFromFollowersObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRFollowers class]])
            [filteredDictionaryArray addObject:[(JRFollowers*)object dictionaryFromObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfFollowersObjectsFromFollowersDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRFollowers followersObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (FollowingToFromDictionary)
- (NSArray*)arrayOfFollowingDictionariesFromFollowingObjects;
- (NSArray*)arrayOfFollowingObjectsFromFollowingDictionaries;
@end

@implementation NSArray (FollowingToFromDictionary)
- (NSArray*)arrayOfFollowingDictionariesFromFollowingObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRFollowing class]])
            [filteredDictionaryArray addObject:[(JRFollowing*)object dictionaryFromObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfFollowingObjectsFromFollowingDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRFollowing followingObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (FriendsToFromDictionary)
- (NSArray*)arrayOfFriendsDictionariesFromFriendsObjects;
- (NSArray*)arrayOfFriendsObjectsFromFriendsDictionaries;
@end

@implementation NSArray (FriendsToFromDictionary)
- (NSArray*)arrayOfFriendsDictionariesFromFriendsObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRFriends class]])
            [filteredDictionaryArray addObject:[(JRFriends*)object dictionaryFromObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfFriendsObjectsFromFriendsDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRFriends friendsObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@implementation JRProfiles
@synthesize profilesId;
@synthesize accessCredentials;
@synthesize domain;
@synthesize followers;
@synthesize following;
@synthesize friends;
@synthesize identifier;
@synthesize profile;
@synthesize provider;
@synthesize remote_key;

- (id)initWithDomain:(NSString *)newDomain andIdentifier:(NSString *)newIdentifier
{
    if (!newDomain || !newIdentifier)
    {
        [self release];
        return nil;
     }

    if ((self = [super init]))
    {
        domain = [newDomain copy];
        identifier = [newIdentifier copy];
    }
    return self;
}

+ (id)profilesWithDomain:(NSString *)domain andIdentifier:(NSString *)identifier
{
    return [[[JRProfiles alloc] initWithDomain:domain andIdentifier:identifier] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRProfiles *profilesCopy =
                [[JRProfiles allocWithZone:zone] initWithDomain:self.domain andIdentifier:self.identifier];

    profilesCopy.profilesId = self.profilesId;
    profilesCopy.accessCredentials = self.accessCredentials;
    profilesCopy.followers = self.followers;
    profilesCopy.following = self.following;
    profilesCopy.friends = self.friends;
    profilesCopy.profile = self.profile;
    profilesCopy.provider = self.provider;
    profilesCopy.remote_key = self.remote_key;

    return profilesCopy;
}

+ (id)profilesObjectFromDictionary:(NSDictionary*)dictionary
{
    JRProfiles *profiles =
        [JRProfiles profilesWithDomain:[dictionary objectForKey:@"domain"] andIdentifier:[dictionary objectForKey:@"identifier"]];

    profiles.profilesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    profiles.accessCredentials = [dictionary objectForKey:@"accessCredentials"];
    profiles.followers = [(NSArray*)[dictionary objectForKey:@"followers"] arrayOfFollowersObjectsFromFollowersDictionaries];
    profiles.following = [(NSArray*)[dictionary objectForKey:@"following"] arrayOfFollowingObjectsFromFollowingDictionaries];
    profiles.friends = [(NSArray*)[dictionary objectForKey:@"friends"] arrayOfFriendsObjectsFromFriendsDictionaries];
    profiles.profile = [JRProfile profileObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"profile"]];
    profiles.provider = [dictionary objectForKey:@"provider"];
    profiles.remote_key = [dictionary objectForKey:@"remote_key"];

    return profiles;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:domain forKey:@"domain"];
    [dict setObject:identifier forKey:@"identifier"];

    if (profilesId)
        [dict setObject:[NSNumber numberWithInt:profilesId] forKey:@"id"];

    if (accessCredentials)
        [dict setObject:accessCredentials forKey:@"accessCredentials"];

    if (followers)
        [dict setObject:[followers arrayOfFollowersDictionariesFromFollowersObjects] forKey:@"followers"];

    if (following)
        [dict setObject:[following arrayOfFollowingDictionariesFromFollowingObjects] forKey:@"following"];

    if (friends)
        [dict setObject:[friends arrayOfFriendsDictionariesFromFriendsObjects] forKey:@"friends"];

    if (profile)
        [dict setObject:[profile dictionaryFromObject] forKey:@"profile"];

    if (provider)
        [dict setObject:provider forKey:@"provider"];

    if (remote_key)
        [dict setObject:remote_key forKey:@"remote_key"];

    return dict;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"profilesId"])
        self.profilesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"accessCredentials"])
        self.accessCredentials = [dictionary objectForKey:@"accessCredentials"];

    if ([dictionary objectForKey:@"domain"])
        self.domain = [dictionary objectForKey:@"domain"];

    if ([dictionary objectForKey:@"followers"])
        self.followers = [(NSArray*)[dictionary objectForKey:@"followers"] arrayOfFollowersObjectsFromFollowersDictionaries];

    if ([dictionary objectForKey:@"following"])
        self.following = [(NSArray*)[dictionary objectForKey:@"following"] arrayOfFollowingObjectsFromFollowingDictionaries];

    if ([dictionary objectForKey:@"friends"])
        self.friends = [(NSArray*)[dictionary objectForKey:@"friends"] arrayOfFriendsObjectsFromFriendsDictionaries];

    if ([dictionary objectForKey:@"identifier"])
        self.identifier = [dictionary objectForKey:@"identifier"];

    if ([dictionary objectForKey:@"profile"])
        self.profile = [JRProfile profileObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"profile"]];

    if ([dictionary objectForKey:@"provider"])
        self.provider = [dictionary objectForKey:@"provider"];

    if ([dictionary objectForKey:@"remote_key"])
        self.remote_key = [dictionary objectForKey:@"remote_key"];
}

- (void)dealloc
{
    [accessCredentials release];
    [domain release];
    [followers release];
    [following release];
    [friends release];
    [identifier release];
    [profile release];
    [provider release];
    [remote_key release];

    [super dealloc];
}
@end
