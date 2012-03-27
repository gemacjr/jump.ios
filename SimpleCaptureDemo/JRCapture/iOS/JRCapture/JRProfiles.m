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
            [filteredDictionaryArray addObject:[(JRFollowers*)object dictionaryFromFollowersObject]];

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
            [filteredDictionaryArray addObject:[(JRFollowing*)object dictionaryFromFollowingObject]];

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
            [filteredDictionaryArray addObject:[(JRFriends*)object dictionaryFromFriendsObject]];

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
{
    NSInteger _profilesId;
    NSObject *_accessCredentials;
    NSString *_domain;
    NSArray *_followers;
    NSArray *_following;
    NSArray *_friends;
    NSString *_identifier;
    JRProfile *_profile;
    NSObject *_provider;
    NSString *_remote_key;
}
@dynamic profilesId;
@dynamic accessCredentials;
@dynamic domain;
@dynamic followers;
@dynamic following;
@dynamic friends;
@dynamic identifier;
@dynamic profile;
@dynamic provider;
@dynamic remote_key;

- (NSInteger)profilesId
{
    return _profilesId;
}

- (void)setProfilesId:(NSInteger)newProfilesId
{
    [self.dirtyPropertySet addObject:@"profilesId"];

    _profilesId = newProfilesId;
}

- (NSObject *)accessCredentials
{
    return _accessCredentials;
}

- (void)setAccessCredentials:(NSObject *)newAccessCredentials
{
    [self.dirtyPropertySet addObject:@"accessCredentials"];

    _accessCredentials = [newAccessCredentials copy];
}

- (NSString *)domain
{
    return _domain;
}

- (void)setDomain:(NSString *)newDomain
{
    [self.dirtyPropertySet addObject:@"domain"];

    _domain = [newDomain copy];
}

- (NSArray *)followers
{
    return _followers;
}

- (void)setFollowers:(NSArray *)newFollowers
{
    [self.dirtyPropertySet addObject:@"followers"];

    _followers = [newFollowers copy];
}

- (NSArray *)following
{
    return _following;
}

- (void)setFollowing:(NSArray *)newFollowing
{
    [self.dirtyPropertySet addObject:@"following"];

    _following = [newFollowing copy];
}

- (NSArray *)friends
{
    return _friends;
}

- (void)setFriends:(NSArray *)newFriends
{
    [self.dirtyPropertySet addObject:@"friends"];

    _friends = [newFriends copy];
}

- (NSString *)identifier
{
    return _identifier;
}

- (void)setIdentifier:(NSString *)newIdentifier
{
    [self.dirtyPropertySet addObject:@"identifier"];

    _identifier = [newIdentifier copy];
}

- (JRProfile *)profile
{
    return _profile;
}

- (void)setProfile:(JRProfile *)newProfile
{
    [self.dirtyPropertySet addObject:@"profile"];

    _profile = [newProfile copy];
}

- (NSObject *)provider
{
    return _provider;
}

- (void)setProvider:(NSObject *)newProvider
{
    [self.dirtyPropertySet addObject:@"provider"];

    _provider = [newProvider copy];
}

- (NSString *)remote_key
{
    return _remote_key;
}

- (void)setRemote_key:(NSString *)newRemote_key
{
    [self.dirtyPropertySet addObject:@"remote_key"];

    _remote_key = [newRemote_key copy];
}

- (id)initWithDomain:(NSString *)newDomain andIdentifier:(NSString *)newIdentifier
{
    if (!newDomain || !newIdentifier)
    {
        [self release];
        return nil;
     }

    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles";
        _domain = [newDomain copy];
        _identifier = [newIdentifier copy];
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

- (NSDictionary*)dictionaryFromProfilesObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:self.domain forKey:@"domain"];
    [dict setObject:self.identifier forKey:@"identifier"];

    if (self.profilesId)
        [dict setObject:[NSNumber numberWithInt:self.profilesId] forKey:@"id"];

    if (self.accessCredentials)
        [dict setObject:self.accessCredentials forKey:@"accessCredentials"];

    if (self.followers)
        [dict setObject:[self.followers arrayOfFollowersDictionariesFromFollowersObjects] forKey:@"followers"];

    if (self.following)
        [dict setObject:[self.following arrayOfFollowingDictionariesFromFollowingObjects] forKey:@"following"];

    if (self.friends)
        [dict setObject:[self.friends arrayOfFriendsDictionariesFromFriendsObjects] forKey:@"friends"];

    if (self.profile)
        [dict setObject:[self.profile dictionaryFromProfileObject] forKey:@"profile"];

    if (self.provider)
        [dict setObject:self.provider forKey:@"provider"];

    if (self.remote_key)
        [dict setObject:self.remote_key forKey:@"remote_key"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
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

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    self.profilesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    self.accessCredentials = [dictionary objectForKey:@"accessCredentials"];
    self.domain = [dictionary objectForKey:@"domain"];
    self.followers = [(NSArray*)[dictionary objectForKey:@"followers"] arrayOfFollowersObjectsFromFollowersDictionaries];
    self.following = [(NSArray*)[dictionary objectForKey:@"following"] arrayOfFollowingObjectsFromFollowingDictionaries];
    self.friends = [(NSArray*)[dictionary objectForKey:@"friends"] arrayOfFriendsObjectsFromFriendsDictionaries];
    self.identifier = [dictionary objectForKey:@"identifier"];
    self.profile = [JRProfile profileObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"profile"]];
    self.provider = [dictionary objectForKey:@"provider"];
    self.remote_key = [dictionary objectForKey:@"remote_key"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"accessCredentials"])
        [dict setObject:self.accessCredentials forKey:@"accessCredentials"];

    if ([self.dirtyPropertySet containsObject:@"domain"])
        [dict setObject:self.domain forKey:@"domain"];

    if ([self.dirtyPropertySet containsObject:@"followers"])
        [dict setObject:[self.followers arrayOfFollowersDictionariesFromFollowersObjects] forKey:@"followers"];

    if ([self.dirtyPropertySet containsObject:@"following"])
        [dict setObject:[self.following arrayOfFollowingDictionariesFromFollowingObjects] forKey:@"following"];

    if ([self.dirtyPropertySet containsObject:@"friends"])
        [dict setObject:[self.friends arrayOfFriendsDictionariesFromFriendsObjects] forKey:@"friends"];

    if ([self.dirtyPropertySet containsObject:@"identifier"])
        [dict setObject:self.identifier forKey:@"identifier"];

    if ([self.dirtyPropertySet containsObject:@"profile"])
        [dict setObject:[self.profile dictionaryFromProfileObject] forKey:@"profile"];

    if ([self.dirtyPropertySet containsObject:@"provider"])
        [dict setObject:self.provider forKey:@"provider"];

    if ([self.dirtyPropertySet containsObject:@"remote_key"])
        [dict setObject:self.remote_key forKey:@"remote_key"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo updateCaptureObject:dict
                                        withId:self.profilesId
                                        atPath:self.captureObjectPath
                                     withToken:[JRCaptureData accessToken]
                                   forDelegate:self
                                   withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:self.accessCredentials forKey:@"accessCredentials"];
    [dict setObject:self.domain forKey:@"domain"];
    [dict setObject:[self.followers arrayOfFollowersDictionariesFromFollowersObjects] forKey:@"followers"];
    [dict setObject:[self.following arrayOfFollowingDictionariesFromFollowingObjects] forKey:@"following"];
    [dict setObject:[self.friends arrayOfFriendsDictionariesFromFriendsObjects] forKey:@"friends"];
    [dict setObject:self.identifier forKey:@"identifier"];
    [dict setObject:[self.profile dictionaryFromProfileObject] forKey:@"profile"];
    [dict setObject:self.provider forKey:@"provider"];
    [dict setObject:self.remote_key forKey:@"remote_key"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo replaceCaptureObject:dict
                                         withId:self.profilesId
                                         atPath:self.captureObjectPath
                                      withToken:[JRCaptureData accessToken]
                                    forDelegate:self
                                    withContext:newContext];
}

- (void)dealloc
{
    [_accessCredentials release];
    [_domain release];
    [_followers release];
    [_following release];
    [_friends release];
    [_identifier release];
    [_profile release];
    [_provider release];
    [_remote_key release];

    [super dealloc];
}
@end
