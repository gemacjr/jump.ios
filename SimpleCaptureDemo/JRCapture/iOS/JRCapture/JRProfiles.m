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

    if (!newAccessCredentials)
        _accessCredentials = [NSNull null];
    else
        _accessCredentials = [newAccessCredentials copy];
}

- (NSString *)domain
{
    return _domain;
}

- (void)setDomain:(NSString *)newDomain
{
    [self.dirtyPropertySet addObject:@"domain"];

    if (!newDomain)
        _domain = [NSNull null];
    else
        _domain = [newDomain copy];
}

- (NSArray *)followers
{
    return _followers;
}

- (void)setFollowers:(NSArray *)newFollowers
{
    [self.dirtyPropertySet addObject:@"followers"];

    if (!newFollowers)
        _followers = [NSNull null];
    else
        _followers = [newFollowers copyArrayOfStringPluralElementsWithType:@"identifier"];
}

- (NSArray *)following
{
    return _following;
}

- (void)setFollowing:(NSArray *)newFollowing
{
    [self.dirtyPropertySet addObject:@"following"];

    if (!newFollowing)
        _following = [NSNull null];
    else
        _following = [newFollowing copyArrayOfStringPluralElementsWithType:@"identifier"];
}

- (NSArray *)friends
{
    return _friends;
}

- (void)setFriends:(NSArray *)newFriends
{
    [self.dirtyPropertySet addObject:@"friends"];

    if (!newFriends)
        _friends = [NSNull null];
    else
        _friends = [newFriends copyArrayOfStringPluralElementsWithType:@"identifier"];
}

- (NSString *)identifier
{
    return _identifier;
}

- (void)setIdentifier:(NSString *)newIdentifier
{
    [self.dirtyPropertySet addObject:@"identifier"];

    if (!newIdentifier)
        _identifier = [NSNull null];
    else
        _identifier = [newIdentifier copy];
}

- (JRProfile *)profile
{
    return _profile;
}

- (void)setProfile:(JRProfile *)newProfile
{
    [self.dirtyPropertySet addObject:@"profile"];

    if (!newProfile)
        _profile = [NSNull null];
    else
        _profile = [newProfile copy];
}

- (NSObject *)provider
{
    return _provider;
}

- (void)setProvider:(NSObject *)newProvider
{
    [self.dirtyPropertySet addObject:@"provider"];

    if (!newProvider)
        _provider = [NSNull null];
    else
        _provider = [newProvider copy];
}

- (NSString *)remote_key
{
    return _remote_key;
}

- (void)setRemote_key:(NSString *)newRemote_key
{
    [self.dirtyPropertySet addObject:@"remote_key"];

    if (!newRemote_key)
        _remote_key = [NSNull null];
    else
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
    profiles.followers = [(NSArray*)[dictionary objectForKey:@"followers"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier"];
    profiles.following = [(NSArray*)[dictionary objectForKey:@"following"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier"];
    profiles.friends = [(NSArray*)[dictionary objectForKey:@"friends"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier"];
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

    if (self.accessCredentials && self.accessCredentials != [NSNull null])
        [dict setObject:self.accessCredentials forKey:@"accessCredentials"];
    else
        [dict setObject:[NSNull null] forKey:@"accessCredentials"];

    if (self.followers && self.followers != [NSNull null])
        [dict setObject:[self.followers arrayOfStringPluralDictionariesFromStringPluralElements] forKey:@"followers"];
    else
        [dict setObject:[NSNull null] forKey:@"followers"];

    if (self.following && self.following != [NSNull null])
        [dict setObject:[self.following arrayOfStringPluralDictionariesFromStringPluralElements] forKey:@"following"];
    else
        [dict setObject:[NSNull null] forKey:@"following"];

    if (self.friends && self.friends != [NSNull null])
        [dict setObject:[self.friends arrayOfStringPluralDictionariesFromStringPluralElements] forKey:@"friends"];
    else
        [dict setObject:[NSNull null] forKey:@"friends"];

    if (self.profile && self.profile != [NSNull null])
        [dict setObject:[self.profile dictionaryFromProfileObject] forKey:@"profile"];
    else
        [dict setObject:[NSNull null] forKey:@"profile"];

    if (self.provider && self.provider != [NSNull null])
        [dict setObject:self.provider forKey:@"provider"];
    else
        [dict setObject:[NSNull null] forKey:@"provider"];

    if (self.remote_key && self.remote_key != [NSNull null])
        [dict setObject:self.remote_key forKey:@"remote_key"];
    else
        [dict setObject:[NSNull null] forKey:@"remote_key"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"id"])
        _profilesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"accessCredentials"])
        _accessCredentials = [dictionary objectForKey:@"accessCredentials"];

    if ([dictionary objectForKey:@"domain"])
        _domain = [dictionary objectForKey:@"domain"];

    if ([dictionary objectForKey:@"followers"])
        _followers = [(NSArray*)[dictionary objectForKey:@"followers"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier"];

    if ([dictionary objectForKey:@"following"])
        _following = [(NSArray*)[dictionary objectForKey:@"following"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier"];

    if ([dictionary objectForKey:@"friends"])
        _friends = [(NSArray*)[dictionary objectForKey:@"friends"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier"];

    if ([dictionary objectForKey:@"identifier"])
        _identifier = [dictionary objectForKey:@"identifier"];

    if ([dictionary objectForKey:@"profile"])
        _profile = [JRProfile profileObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"profile"]];

    if ([dictionary objectForKey:@"provider"])
        _provider = [dictionary objectForKey:@"provider"];

    if ([dictionary objectForKey:@"remote_key"])
        _remote_key = [dictionary objectForKey:@"remote_key"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    _profilesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    _accessCredentials = [dictionary objectForKey:@"accessCredentials"];
    _domain = [dictionary objectForKey:@"domain"];
    _followers = [(NSArray*)[dictionary objectForKey:@"followers"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier"];
    _following = [(NSArray*)[dictionary objectForKey:@"following"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier"];
    _friends = [(NSArray*)[dictionary objectForKey:@"friends"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier"];
    _identifier = [dictionary objectForKey:@"identifier"];
    _profile = [JRProfile profileObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"profile"]];
    _provider = [dictionary objectForKey:@"provider"];
    _remote_key = [dictionary objectForKey:@"remote_key"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"profilesId"])
        [dict setObject:[NSNumber numberWithInt:self.profilesId] forKey:@"id"];

    if ([self.dirtyPropertySet containsObject:@"accessCredentials"])
        [dict setObject:self.accessCredentials forKey:@"accessCredentials"];

    if ([self.dirtyPropertySet containsObject:@"domain"])
        [dict setObject:self.domain forKey:@"domain"];

    if ([self.dirtyPropertySet containsObject:@"followers"])
        [dict setObject:[self.followers arrayOfStringPluralDictionariesFromStringPluralElements] forKey:@"followers"];

    if ([self.dirtyPropertySet containsObject:@"following"])
        [dict setObject:[self.following arrayOfStringPluralDictionariesFromStringPluralElements] forKey:@"following"];

    if ([self.dirtyPropertySet containsObject:@"friends"])
        [dict setObject:[self.friends arrayOfStringPluralDictionariesFromStringPluralElements] forKey:@"friends"];

    if ([self.dirtyPropertySet containsObject:@"identifier"])
        [dict setObject:self.identifier forKey:@"identifier"];

    if ([self.dirtyPropertySet containsObject:@"profile"])
        [dict setObject:[self.profile dictionaryFromProfileObject] forKey:@"profile"];

    if ([self.dirtyPropertySet containsObject:@"provider"])
        [dict setObject:self.provider forKey:@"provider"];

    if ([self.dirtyPropertySet containsObject:@"remote_key"])
        [dict setObject:self.remote_key forKey:@"remote_key"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:dict
                                     withId:0
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:[NSNumber numberWithInt:self.profilesId] forKey:@"id"];
    [dict setObject:self.accessCredentials forKey:@"accessCredentials"];
    [dict setObject:self.domain forKey:@"domain"];
    [dict setObject:[self.followers arrayOfStringPluralDictionariesFromStringPluralElements] forKey:@"followers"];
    [dict setObject:[self.following arrayOfStringPluralDictionariesFromStringPluralElements] forKey:@"following"];
    [dict setObject:[self.friends arrayOfStringPluralDictionariesFromStringPluralElements] forKey:@"friends"];
    [dict setObject:self.identifier forKey:@"identifier"];
    [dict setObject:[self.profile dictionaryFromProfileObject] forKey:@"profile"];
    [dict setObject:self.provider forKey:@"provider"];
    [dict setObject:self.remote_key forKey:@"remote_key"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:dict
                                      withId:0
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
