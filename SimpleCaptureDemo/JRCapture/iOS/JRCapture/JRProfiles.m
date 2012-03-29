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
    _followers = [newFollowers copyArrayOfStringPluralElementsWithType:@"identifier"];
}

- (NSArray *)following
{
    return _following;
}

- (void)setFollowing:(NSArray *)newFollowing
{
    [self.dirtyPropertySet addObject:@"following"];
    _following = [newFollowing copyArrayOfStringPluralElementsWithType:@"identifier"];
}

- (NSArray *)friends
{
    return _friends;
}

- (void)setFriends:(NSArray *)newFriends
{
    [self.dirtyPropertySet addObject:@"friends"];
    _friends = [newFriends copyArrayOfStringPluralElementsWithType:@"identifier"];
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

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles";
    }
    return self;
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

+ (id)profiles
{
    return [[[JRProfiles alloc] init] autorelease];
}

+ (id)profilesWithDomain:(NSString *)domain andIdentifier:(NSString *)identifier
{
    return [[[JRProfiles alloc] initWithDomain:domain andIdentifier:identifier] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
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

    [profilesCopy.dirtyPropertySet removeAllObjects];
    [profilesCopy.dirtyPropertySet setSet:self.dirtyPropertySet];

    return profilesCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:[NSNumber numberWithInt:self.profilesId]
             forKey:@"id"];
    [dict setObject:(self.accessCredentials ? self.accessCredentials : [NSNull null])
             forKey:@"accessCredentials"];
    [dict setObject:(self.domain ? self.domain : [NSNull null])
             forKey:@"domain"];
    [dict setObject:(self.followers ? [self.followers arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"followers"];
    [dict setObject:(self.following ? [self.following arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"following"];
    [dict setObject:(self.friends ? [self.friends arrayOfStringPluralDictionariesFromStringPluralElements] : [NSNull null])
             forKey:@"friends"];
    [dict setObject:(self.identifier ? self.identifier : [NSNull null])
             forKey:@"identifier"];
    [dict setObject:(self.profile ? [self.profile toDictionary] : [NSNull null])
             forKey:@"profile"];
    [dict setObject:(self.provider ? self.provider : [NSNull null])
             forKey:@"provider"];
    [dict setObject:(self.remote_key ? self.remote_key : [NSNull null])
             forKey:@"remote_key"];

    return dict;
}

+ (id)profilesObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    JRProfiles *profiles = [JRProfiles profiles];
    profiles.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"profiles", profiles.profilesId];

    profiles.profilesId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [(NSNumber*)[dictionary objectForKey:@"id"] intValue] : 0;

    profiles.accessCredentials =
        [dictionary objectForKey:@"accessCredentials"] != [NSNull null] ? 
        [dictionary objectForKey:@"accessCredentials"] : nil;

    profiles.domain =
        [dictionary objectForKey:@"domain"] != [NSNull null] ? 
        [dictionary objectForKey:@"domain"] : nil;

    profiles.followers =
        [dictionary objectForKey:@"followers"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"followers"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier" andPath:profiles.captureObjectPath] : nil;

    profiles.following =
        [dictionary objectForKey:@"following"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"following"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier" andPath:profiles.captureObjectPath] : nil;

    profiles.friends =
        [dictionary objectForKey:@"friends"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"friends"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier" andPath:profiles.captureObjectPath] : nil;

    profiles.identifier =
        [dictionary objectForKey:@"identifier"] != [NSNull null] ? 
        [dictionary objectForKey:@"identifier"] : nil;

    profiles.profile =
        [dictionary objectForKey:@"profile"] != [NSNull null] ? 
        [JRProfile profileObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"profile"] withPath:profiles.captureObjectPath] : nil;

    profiles.provider =
        [dictionary objectForKey:@"provider"] != [NSNull null] ? 
        [dictionary objectForKey:@"provider"] : nil;

    profiles.remote_key =
        [dictionary objectForKey:@"remote_key"] != [NSNull null] ? 
        [dictionary objectForKey:@"remote_key"] : nil;

    [profiles.dirtyPropertySet removeAllObjects];
    
    return profiles;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"profiles", self.profilesId];

    if ([dictionary objectForKey:@"id"])
        _profilesId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
            [(NSNumber*)[dictionary objectForKey:@"id"] intValue] : 0;

    if ([dictionary objectForKey:@"accessCredentials"])
        _accessCredentials = [dictionary objectForKey:@"accessCredentials"] != [NSNull null] ? 
            [dictionary objectForKey:@"accessCredentials"] : nil;

    if ([dictionary objectForKey:@"domain"])
        _domain = [dictionary objectForKey:@"domain"] != [NSNull null] ? 
            [dictionary objectForKey:@"domain"] : nil;

    if ([dictionary objectForKey:@"followers"])
        _followers = [dictionary objectForKey:@"followers"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"followers"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier" andPath:self.captureObjectPath] : nil;

    if ([dictionary objectForKey:@"following"])
        _following = [dictionary objectForKey:@"following"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"following"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier" andPath:self.captureObjectPath] : nil;

    if ([dictionary objectForKey:@"friends"])
        _friends = [dictionary objectForKey:@"friends"] != [NSNull null] ? 
            [(NSArray*)[dictionary objectForKey:@"friends"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier" andPath:self.captureObjectPath] : nil;

    if ([dictionary objectForKey:@"identifier"])
        _identifier = [dictionary objectForKey:@"identifier"] != [NSNull null] ? 
            [dictionary objectForKey:@"identifier"] : nil;

    if ([dictionary objectForKey:@"profile"])
        _profile = [dictionary objectForKey:@"profile"] != [NSNull null] ? 
            [JRProfile profileObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"profile"] withPath:self.captureObjectPath] : nil;

    if ([dictionary objectForKey:@"provider"])
        _provider = [dictionary objectForKey:@"provider"] != [NSNull null] ? 
            [dictionary objectForKey:@"provider"] : nil;

    if ([dictionary objectForKey:@"remote_key"])
        _remote_key = [dictionary objectForKey:@"remote_key"] != [NSNull null] ? 
            [dictionary objectForKey:@"remote_key"] : nil;
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"profiles", self.profilesId];

    _profilesId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [(NSNumber*)[dictionary objectForKey:@"id"] intValue] : 0;

    _accessCredentials =
        [dictionary objectForKey:@"accessCredentials"] != [NSNull null] ? 
        [dictionary objectForKey:@"accessCredentials"] : nil;

    _domain =
        [dictionary objectForKey:@"domain"] != [NSNull null] ? 
        [dictionary objectForKey:@"domain"] : nil;

    _followers =
        [dictionary objectForKey:@"followers"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"followers"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier" andPath:self.captureObjectPath] : nil;

    _following =
        [dictionary objectForKey:@"following"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"following"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier" andPath:self.captureObjectPath] : nil;

    _friends =
        [dictionary objectForKey:@"friends"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"friends"] arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier" andPath:self.captureObjectPath] : nil;

    _identifier =
        [dictionary objectForKey:@"identifier"] != [NSNull null] ? 
        [dictionary objectForKey:@"identifier"] : nil;

    _profile =
        [dictionary objectForKey:@"profile"] != [NSNull null] ? 
        [JRProfile profileObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"profile"] withPath:self.captureObjectPath] : nil;

    _provider =
        [dictionary objectForKey:@"provider"] != [NSNull null] ? 
        [dictionary objectForKey:@"provider"] : nil;

    _remote_key =
        [dictionary objectForKey:@"remote_key"] != [NSNull null] ? 
        [dictionary objectForKey:@"remote_key"] : nil;
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"accessCredentials"])
        [dict setObject:(self.accessCredentials ? self.accessCredentials : [NSNull null]) forKey:@"accessCredentials"];

    if ([self.dirtyPropertySet containsObject:@"domain"])
        [dict setObject:(self.domain ? self.domain : [NSNull null]) forKey:@"domain"];

    if ([self.dirtyPropertySet containsObject:@"followers"])
        [dict setObject:(self.followers ? [self.followers arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"followers"];

    if ([self.dirtyPropertySet containsObject:@"following"])
        [dict setObject:(self.following ? [self.following arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"following"];

    if ([self.dirtyPropertySet containsObject:@"friends"])
        [dict setObject:(self.friends ? [self.friends arrayOfStringPluralUpdateDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"friends"];

    if ([self.dirtyPropertySet containsObject:@"identifier"])
        [dict setObject:(self.identifier ? self.identifier : [NSNull null]) forKey:@"identifier"];

    if ([self.dirtyPropertySet containsObject:@"profile"])
        [dict setObject:(self.profile ? [self.profile toUpdateDictionary] : [NSNull null]) forKey:@"profile"];

    if ([self.dirtyPropertySet containsObject:@"provider"])
        [dict setObject:(self.provider ? self.provider : [NSNull null]) forKey:@"provider"];

    if ([self.dirtyPropertySet containsObject:@"remote_key"])
        [dict setObject:(self.remote_key ? self.remote_key : [NSNull null]) forKey:@"remote_key"];

    return dict;
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:[self toUpdateDictionary]
                                     withId:self.profilesId
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.accessCredentials ? self.accessCredentials : [NSNull null]) forKey:@"accessCredentials"];
    [dict setObject:(self.domain ? self.domain : [NSNull null]) forKey:@"domain"];
    [dict setObject:(self.followers ? [self.followers arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"followers"];
    [dict setObject:(self.following ? [self.following arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"following"];
    [dict setObject:(self.friends ? [self.friends arrayOfStringPluralReplaceDictionariesFromStringPluralElements] : [NSNull null]) forKey:@"friends"];
    [dict setObject:(self.identifier ? self.identifier : [NSNull null]) forKey:@"identifier"];
    [dict setObject:(self.profile ? [self.profile toReplaceDictionary] : [NSNull null]) forKey:@"profile"];
    [dict setObject:(self.provider ? self.provider : [NSNull null]) forKey:@"provider"];
    [dict setObject:(self.remote_key ? self.remote_key : [NSNull null]) forKey:@"remote_key"];

    return dict;
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:[self toReplaceDictionary]
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
