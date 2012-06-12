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

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


#import "JRProfilesElement.h"

@interface JRProfilesElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRProfilesElement
{
    JRObjectId *_profilesElementId;
    JRJsonObject *_accessCredentials;
    NSString *_domain;
    JRStringArray *_followers;
    JRStringArray *_following;
    JRStringArray *_friends;
    NSString *_identifier;
    JRProfile *_profile;
    JRJsonObject *_provider;
    NSString *_remote_key;
}
@dynamic profilesElementId;
@dynamic accessCredentials;
@dynamic domain;
@dynamic followers;
@dynamic following;
@dynamic friends;
@dynamic identifier;
@dynamic profile;
@dynamic provider;
@dynamic remote_key;
@synthesize canBeUpdatedOrReplaced;

- (JRObjectId *)profilesElementId
{
    return _profilesElementId;
}

- (void)setProfilesElementId:(JRObjectId *)newProfilesElementId
{
    [self.dirtyPropertySet addObject:@"profilesElementId"];
    _profilesElementId = [newProfilesElementId copy];
}

- (JRJsonObject *)accessCredentials
{
    return _accessCredentials;
}

- (void)setAccessCredentials:(JRJsonObject *)newAccessCredentials
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
    [self.dirtyArraySet addObject:@"followers"];
    _followers = [newFollowers copyArrayOfStringPluralElementsWithType:@"identifier"];
}

- (NSArray *)following
{
    return _following;
}

- (void)setFollowing:(NSArray *)newFollowing
{
    [self.dirtyArraySet addObject:@"following"];
    _following = [newFollowing copyArrayOfStringPluralElementsWithType:@"identifier"];
}

- (NSArray *)friends
{
    return _friends;
}

- (void)setFriends:(NSArray *)newFriends
{
    [self.dirtyArraySet addObject:@"friends"];
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

- (JRJsonObject *)provider
{
    return _provider;
}

- (void)setProvider:(JRJsonObject *)newProvider
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
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;
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
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;
        _domain = [newDomain copy];
        _identifier = [newIdentifier copy];
    }
    return self;
}

+ (id)profilesElement
{
    return [[[JRProfilesElement alloc] init] autorelease];
}

+ (id)profilesElementWithDomain:(NSString *)domain andIdentifier:(NSString *)identifier
{
    return [[[JRProfilesElement alloc] initWithDomain:domain andIdentifier:identifier] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRProfilesElement *profilesElementCopy =
                [[JRProfilesElement allocWithZone:zone] initWithDomain:self.domain andIdentifier:self.identifier];

    profilesElementCopy.captureObjectPath = self.captureObjectPath;

    profilesElementCopy.profilesElementId = self.profilesElementId;
    profilesElementCopy.accessCredentials = self.accessCredentials;
    profilesElementCopy.followers = self.followers;
    profilesElementCopy.following = self.following;
    profilesElementCopy.friends = self.friends;
    profilesElementCopy.profile = self.profile;
    profilesElementCopy.provider = self.provider;
    profilesElementCopy.remote_key = self.remote_key;
    // TODO: Necessary??
    profilesElementCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    // TODO: Necessary??
    [profilesElementCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [profilesElementCopy.dirtyArraySet setSet:self.dirtyArraySet];

    return profilesElementCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.profilesElementId ? [NSNumber numberWithInteger:[self.profilesElementId integerValue]] : [NSNull null])
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

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)profilesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRProfilesElement *profilesElement = [JRProfilesElement profilesElement];

    profilesElement.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"profiles", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
// TODO: Is this safe to assume?
    profilesElement.canBeUpdatedOrReplaced = YES;

    profilesElement.profilesElementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    profilesElement.accessCredentials =
        [dictionary objectForKey:@"accessCredentials"] != [NSNull null] ? 
        [dictionary objectForKey:@"accessCredentials"] : nil;

    profilesElement.domain =
        [dictionary objectForKey:@"domain"] != [NSNull null] ? 
        [dictionary objectForKey:@"domain"] : nil;

    profilesElement.followers =
        [dictionary objectForKey:@"followers"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"followers"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/followers", profilesElement.captureObjectPath]] : nil;

    profilesElement.following =
        [dictionary objectForKey:@"following"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"following"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/following", profilesElement.captureObjectPath]] : nil;

    profilesElement.friends =
        [dictionary objectForKey:@"friends"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"friends"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/friends", profilesElement.captureObjectPath]] : nil;

    profilesElement.identifier =
        [dictionary objectForKey:@"identifier"] != [NSNull null] ? 
        [dictionary objectForKey:@"identifier"] : nil;

    profilesElement.profile =
        [dictionary objectForKey:@"profile"] != [NSNull null] ? 
        [JRProfile profileObjectFromDictionary:[dictionary objectForKey:@"profile"] withPath:profilesElement.captureObjectPath] : nil;

    profilesElement.provider =
        [dictionary objectForKey:@"provider"] != [NSNull null] ? 
        [dictionary objectForKey:@"provider"] : nil;

    profilesElement.remote_key =
        [dictionary objectForKey:@"remote_key"] != [NSNull null] ? 
        [dictionary objectForKey:@"remote_key"] : nil;

    [profilesElement.dirtyPropertySet removeAllObjects];
    [profilesElement.dirtyArraySet removeAllObjects];
    
    return profilesElement;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"profiles", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"id"])
        self.profilesElementId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
            [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    if ([dictionary objectForKey:@"accessCredentials"])
        self.accessCredentials = [dictionary objectForKey:@"accessCredentials"] != [NSNull null] ? 
            [dictionary objectForKey:@"accessCredentials"] : nil;

    if ([dictionary objectForKey:@"domain"])
        self.domain = [dictionary objectForKey:@"domain"] != [NSNull null] ? 
            [dictionary objectForKey:@"domain"] : nil;

    if ([dictionary objectForKey:@"identifier"])
        self.identifier = [dictionary objectForKey:@"identifier"] != [NSNull null] ? 
            [dictionary objectForKey:@"identifier"] : nil;

    if ([dictionary objectForKey:@"profile"] == [NSNull null])
        self.profile = nil;
    else if ([dictionary objectForKey:@"profile"] && !self.profile)
        self.profile = [JRProfile profileObjectFromDictionary:[dictionary objectForKey:@"profile"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"profile"])
        [self.profile updateFromDictionary:[dictionary objectForKey:@"profile"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"provider"])
        self.provider = [dictionary objectForKey:@"provider"] != [NSNull null] ? 
            [dictionary objectForKey:@"provider"] : nil;

    if ([dictionary objectForKey:@"remote_key"])
        self.remote_key = [dictionary objectForKey:@"remote_key"] != [NSNull null] ? 
            [dictionary objectForKey:@"remote_key"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"profiles", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.profilesElementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.accessCredentials =
        [dictionary objectForKey:@"accessCredentials"] != [NSNull null] ? 
        [dictionary objectForKey:@"accessCredentials"] : nil;

    self.domain =
        [dictionary objectForKey:@"domain"] != [NSNull null] ? 
        [dictionary objectForKey:@"domain"] : nil;

    self.followers =
        [dictionary objectForKey:@"followers"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"followers"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/followers", self.captureObjectPath]] : nil;

    self.following =
        [dictionary objectForKey:@"following"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"following"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/following", self.captureObjectPath]] : nil;

    self.friends =
        [dictionary objectForKey:@"friends"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"friends"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:@"identifier" 
                                                                andExtendedPath:[NSString stringWithFormat:@"%@/friends", self.captureObjectPath]] : nil;

    self.identifier =
        [dictionary objectForKey:@"identifier"] != [NSNull null] ? 
        [dictionary objectForKey:@"identifier"] : nil;

    if (![dictionary objectForKey:@"profile"] || [dictionary objectForKey:@"profile"] == [NSNull null])
        self.profile = nil;
    else if (!self.profile)
        self.profile = [JRProfile profileObjectFromDictionary:[dictionary objectForKey:@"profile"] withPath:self.captureObjectPath];
    else
        [self.profile replaceFromDictionary:[dictionary objectForKey:@"profile"] withPath:self.captureObjectPath];

    self.provider =
        [dictionary objectForKey:@"provider"] != [NSNull null] ? 
        [dictionary objectForKey:@"provider"] : nil;

    self.remote_key =
        [dictionary objectForKey:@"remote_key"] != [NSNull null] ? 
        [dictionary objectForKey:@"remote_key"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"accessCredentials"])
        [dict setObject:(self.accessCredentials ? self.accessCredentials : [NSNull null]) forKey:@"accessCredentials"];

    if ([self.dirtyPropertySet containsObject:@"domain"])
        [dict setObject:(self.domain ? self.domain : [NSNull null]) forKey:@"domain"];

    if ([self.dirtyPropertySet containsObject:@"identifier"])
        [dict setObject:(self.identifier ? self.identifier : [NSNull null]) forKey:@"identifier"];

    if ([self.dirtyPropertySet containsObject:@"profile"] || [self.profile needsUpdate])
        [dict setObject:(self.profile ?
                              [self.profile toUpdateDictionary] :
                              [[JRProfile profile] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"profile"];

    if ([self.dirtyPropertySet containsObject:@"provider"])
        [dict setObject:(self.provider ? self.provider : [NSNull null]) forKey:@"provider"];

    if ([self.dirtyPropertySet containsObject:@"remote_key"])
        [dict setObject:(self.remote_key ? self.remote_key : [NSNull null]) forKey:@"remote_key"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.accessCredentials ? self.accessCredentials : [NSNull null]) forKey:@"accessCredentials"];
    [dict setObject:(self.domain ? self.domain : [NSNull null]) forKey:@"domain"];
    [dict setObject:(self.followers ? [self.followers arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"followers"];
    [dict setObject:(self.following ? [self.following arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"following"];
    [dict setObject:(self.friends ? [self.friends arrayOfStringsFromStringPluralElements] : [NSArray array]) forKey:@"friends"];
    [dict setObject:(self.identifier ? self.identifier : [NSNull null]) forKey:@"identifier"];
    [dict setObject:(self.profile ?
                          [self.profile toReplaceDictionary] :
                          [[JRProfile profile] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"profile"];
    [dict setObject:(self.provider ? self.provider : [NSNull null]) forKey:@"provider"];
    [dict setObject:(self.remote_key ? self.remote_key : [NSNull null]) forKey:@"remote_key"];

    return dict;
}

- (void)replaceFollowersArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.followers ofType:@"identifier" named:@"followers"
                          forDelegate:delegate withContext:context];
}

- (void)replaceFollowingArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.following ofType:@"identifier" named:@"following"
                          forDelegate:delegate withContext:context];
}

- (void)replaceFriendsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceSimpleArrayOnCapture:self.friends ofType:@"identifier" named:@"friends"
                          forDelegate:delegate withContext:context];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if([self.profile needsUpdate])
        return YES;

    return NO;
}

- (BOOL)isEqualToProfilesElement:(JRProfilesElement *)otherProfilesElement
{
    if ((self.accessCredentials == nil) ^ (otherProfilesElement.accessCredentials == nil)) // xor
        return NO;

    if (![self.accessCredentials isEqual:otherProfilesElement.accessCredentials])
        return NO;

    if ((self.domain == nil) ^ (otherProfilesElement.domain == nil)) // xor
        return NO;

    if (![self.domain isEqualToString:otherProfilesElement.domain])
        return NO;

    if (!self.followers && !otherProfilesElement.followers) /* Keep going... */;
    else if (!self.followers && ![otherProfilesElement.followers count]) /* Keep going... */;
    else if (!otherProfilesElement.followers && ![self.followers count]) /* Keep going... */;
    else if (![self.followers isEqualToOtherStringPluralArray:otherProfilesElement.followers]) return NO;

    if (!self.following && !otherProfilesElement.following) /* Keep going... */;
    else if (!self.following && ![otherProfilesElement.following count]) /* Keep going... */;
    else if (!otherProfilesElement.following && ![self.following count]) /* Keep going... */;
    else if (![self.following isEqualToOtherStringPluralArray:otherProfilesElement.following]) return NO;

    if (!self.friends && !otherProfilesElement.friends) /* Keep going... */;
    else if (!self.friends && ![otherProfilesElement.friends count]) /* Keep going... */;
    else if (!otherProfilesElement.friends && ![self.friends count]) /* Keep going... */;
    else if (![self.friends isEqualToOtherStringPluralArray:otherProfilesElement.friends]) return NO;

    if ((self.identifier == nil) ^ (otherProfilesElement.identifier == nil)) // xor
        return NO;

    if (![self.identifier isEqualToString:otherProfilesElement.identifier])
        return NO;

    if (!self.profile && !otherProfilesElement.profile) /* Keep going... */;
    else if (!self.profile && [otherProfilesElement.profile isEqualToProfile:[JRProfile profile]]) /* Keep going... */;
    else if (!otherProfilesElement.profile && [self.profile isEqualToProfile:[JRProfile profile]]) /* Keep going... */;
    else if (![self.profile isEqualToProfile:otherProfilesElement.profile]) return NO;

    if ((self.provider == nil) ^ (otherProfilesElement.provider == nil)) // xor
        return NO;

    if (![self.provider isEqual:otherProfilesElement.provider])
        return NO;

    if ((self.remote_key == nil) ^ (otherProfilesElement.remote_key == nil)) // xor
        return NO;

    if (![self.remote_key isEqualToString:otherProfilesElement.remote_key])
        return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"JRObjectId" forKey:@"profilesElementId"];
    [dict setObject:@"JRJsonObject" forKey:@"accessCredentials"];
    [dict setObject:@"NSString" forKey:@"domain"];
    [dict setObject:@"JRStringArray" forKey:@"followers"];
    [dict setObject:@"JRStringArray" forKey:@"following"];
    [dict setObject:@"JRStringArray" forKey:@"friends"];
    [dict setObject:@"NSString" forKey:@"identifier"];
    [dict setObject:@"JRProfile" forKey:@"profile"];
    [dict setObject:@"JRJsonObject" forKey:@"provider"];
    [dict setObject:@"NSString" forKey:@"remote_key"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_profilesElementId release];
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
