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


#import "JRCaptureObject+Internal.h"
#import "JRProfilesElement.h"

@interface JRProfile (ProfileInternalMethods)
+ (id)profileObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToProfile:(JRProfile *)otherProfile;
@end

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
@synthesize canBeUpdatedOrReplaced;

- (JRObjectId *)profilesElementId
{
    return _profilesElementId;
}

- (void)setProfilesElementId:(JRObjectId *)newProfilesElementId
{
    [self.dirtyPropertySet addObject:@"profilesElementId"];

    [_profilesElementId autorelease];
    _profilesElementId = [newProfilesElementId copy];
}

- (JRJsonObject *)accessCredentials
{
    return _accessCredentials;
}

- (void)setAccessCredentials:(JRJsonObject *)newAccessCredentials
{
    [self.dirtyPropertySet addObject:@"accessCredentials"];

    [_accessCredentials autorelease];
    _accessCredentials = [newAccessCredentials copy];
}

- (NSString *)domain
{
    return _domain;
}

- (void)setDomain:(NSString *)newDomain
{
    [self.dirtyPropertySet addObject:@"domain"];

    [_domain autorelease];
    _domain = [newDomain copy];
}

- (JRStringArray *)followers
{
    return _followers;
}

- (void)setFollowers:(JRStringArray *)newFollowers
{
    [_followers autorelease];
    _followers = [newFollowers copy];
}

- (JRStringArray *)following
{
    return _following;
}

- (void)setFollowing:(JRStringArray *)newFollowing
{
    [_following autorelease];
    _following = [newFollowing copy];
}

- (JRStringArray *)friends
{
    return _friends;
}

- (void)setFriends:(JRStringArray *)newFriends
{
    [_friends autorelease];
    _friends = [newFriends copy];
}

- (NSString *)identifier
{
    return _identifier;
}

- (void)setIdentifier:(NSString *)newIdentifier
{
    [self.dirtyPropertySet addObject:@"identifier"];

    [_identifier autorelease];
    _identifier = [newIdentifier copy];
}

- (JRProfile *)profile
{
    return _profile;
}

- (void)setProfile:(JRProfile *)newProfile
{
    [self.dirtyPropertySet addObject:@"profile"];

    [_profile autorelease];
    _profile = [newProfile retain];
}

- (JRJsonObject *)provider
{
    return _provider;
}

- (void)setProvider:(JRJsonObject *)newProvider
{
    [self.dirtyPropertySet addObject:@"provider"];

    [_provider autorelease];
    _provider = [newProvider copy];
}

- (NSString *)remote_key
{
    return _remote_key;
}

- (void)setRemote_key:(NSString *)newRemote_key
{
    [self.dirtyPropertySet addObject:@"remote_key"];

    [_remote_key autorelease];
    _remote_key = [newRemote_key copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;

        _profile = [[JRProfile alloc] init];

        [self.dirtyPropertySet setSet:[NSMutableSet setWithObjects:@"profilesElementId", @"accessCredentials", @"domain", @"identifier", @"profile", @"provider", @"remote_key", nil]];
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
        _profile = [[JRProfile alloc] init];
    
        [self.dirtyPropertySet setSet:[NSMutableSet setWithObjects:@"profilesElementId", @"accessCredentials", @"domain", @"identifier", @"profile", @"provider", @"remote_key", nil]];
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
{
    JRProfilesElement *profilesElementCopy = (JRProfilesElement *)[super copyWithZone:zone];

    profilesElementCopy.profilesElementId = self.profilesElementId;
    profilesElementCopy.accessCredentials = self.accessCredentials;
    profilesElementCopy.domain = self.domain;
    profilesElementCopy.followers = self.followers;
    profilesElementCopy.following = self.following;
    profilesElementCopy.friends = self.friends;
    profilesElementCopy.identifier = self.identifier;
    profilesElementCopy.profile = self.profile;
    profilesElementCopy.provider = self.provider;
    profilesElementCopy.remote_key = self.remote_key;

    return profilesElementCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.profilesElementId ? [NSNumber numberWithInteger:[self.profilesElementId integerValue]] : [NSNull null])
                   forKey:@"id"];
    [dictionary setObject:(self.accessCredentials ? self.accessCredentials : [NSNull null])
                   forKey:@"accessCredentials"];
    [dictionary setObject:(self.domain ? self.domain : [NSNull null])
                   forKey:@"domain"];
    [dictionary setObject:(self.followers ? self.followers : [NSNull null])
                   forKey:@"followers"];
    [dictionary setObject:(self.following ? self.following : [NSNull null])
                   forKey:@"following"];
    [dictionary setObject:(self.friends ? self.friends : [NSNull null])
                   forKey:@"friends"];
    [dictionary setObject:(self.identifier ? self.identifier : [NSNull null])
                   forKey:@"identifier"];
    [dictionary setObject:(self.profile ? [self.profile toDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"profile"];
    [dictionary setObject:(self.provider ? self.provider : [NSNull null])
                   forKey:@"provider"];
    [dictionary setObject:(self.remote_key ? self.remote_key : [NSNull null])
                   forKey:@"remote_key"];

    if (forEncoder)
    {
        [dictionary setObject:([self.dirtyPropertySet allObjects] ? [self.dirtyPropertySet allObjects] : [NSArray array])
                       forKey:@"dirtyPropertiesSet"];
        [dictionary setObject:(self.captureObjectPath ? self.captureObjectPath : [NSNull null])
                       forKey:@"captureObjectPath"];
        [dictionary setObject:[NSNumber numberWithBool:self.canBeUpdatedOrReplaced] 
                       forKey:@"canBeUpdatedOrReplaced"];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (id)profilesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRProfilesElement *profilesElement = [JRProfilesElement profilesElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        profilesElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        profilesElement.canBeUpdatedOrReplaced = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOrReplaced"] boolValue];
    }
    else
    {
        profilesElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"profiles", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        profilesElement.canBeUpdatedOrReplaced = YES;
    }

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
        [(NSArray*)[dictionary objectForKey:@"followers"] arrayOfStringsFromStringPluralDictionariesWithType:@"identifier"] : nil;

    profilesElement.following =
        [dictionary objectForKey:@"following"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"following"] arrayOfStringsFromStringPluralDictionariesWithType:@"identifier"] : nil;

    profilesElement.friends =
        [dictionary objectForKey:@"friends"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"friends"] arrayOfStringsFromStringPluralDictionariesWithType:@"identifier"] : nil;

    profilesElement.identifier =
        [dictionary objectForKey:@"identifier"] != [NSNull null] ? 
        [dictionary objectForKey:@"identifier"] : nil;

    profilesElement.profile =
        [dictionary objectForKey:@"profile"] != [NSNull null] ? 
        [JRProfile profileObjectFromDictionary:[dictionary objectForKey:@"profile"] withPath:profilesElement.captureObjectPath fromDecoder:fromDecoder] : nil;

    profilesElement.provider =
        [dictionary objectForKey:@"provider"] != [NSNull null] ? 
        [dictionary objectForKey:@"provider"] : nil;

    profilesElement.remote_key =
        [dictionary objectForKey:@"remote_key"] != [NSNull null] ? 
        [dictionary objectForKey:@"remote_key"] : nil;

    if (fromDecoder)
        [profilesElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [profilesElement.dirtyPropertySet removeAllObjects];
    
    return profilesElement;
}

+ (id)profilesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRProfilesElement profilesElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

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
        self.profile = [JRProfile profileObjectFromDictionary:[dictionary objectForKey:@"profile"] withPath:self.captureObjectPath fromDecoder:NO];
    else if ([dictionary objectForKey:@"profile"])
        [self.profile updateFromDictionary:[dictionary objectForKey:@"profile"] withPath:self.captureObjectPath];

    if ([dictionary objectForKey:@"provider"])
        self.provider = [dictionary objectForKey:@"provider"] != [NSNull null] ? 
            [dictionary objectForKey:@"provider"] : nil;

    if ([dictionary objectForKey:@"remote_key"])
        self.remote_key = [dictionary objectForKey:@"remote_key"] != [NSNull null] ? 
            [dictionary objectForKey:@"remote_key"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

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
        [(NSArray*)[dictionary objectForKey:@"followers"] arrayOfStringsFromStringPluralDictionariesWithType:@"identifier"] : nil;

    self.following =
        [dictionary objectForKey:@"following"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"following"] arrayOfStringsFromStringPluralDictionariesWithType:@"identifier"] : nil;

    self.friends =
        [dictionary objectForKey:@"friends"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"friends"] arrayOfStringsFromStringPluralDictionariesWithType:@"identifier"] : nil;

    self.identifier =
        [dictionary objectForKey:@"identifier"] != [NSNull null] ? 
        [dictionary objectForKey:@"identifier"] : nil;

    if (![dictionary objectForKey:@"profile"] || [dictionary objectForKey:@"profile"] == [NSNull null])
        self.profile = nil;
    else if (!self.profile)
        self.profile = [JRProfile profileObjectFromDictionary:[dictionary objectForKey:@"profile"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.profile replaceFromDictionary:[dictionary objectForKey:@"profile"] withPath:self.captureObjectPath];

    self.provider =
        [dictionary objectForKey:@"provider"] != [NSNull null] ? 
        [dictionary objectForKey:@"provider"] : nil;

    self.remote_key =
        [dictionary objectForKey:@"remote_key"] != [NSNull null] ? 
        [dictionary objectForKey:@"remote_key"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"accessCredentials"])
        [dictionary setObject:(self.accessCredentials ? self.accessCredentials : [NSNull null]) forKey:@"accessCredentials"];

    if ([self.dirtyPropertySet containsObject:@"domain"])
        [dictionary setObject:(self.domain ? self.domain : [NSNull null]) forKey:@"domain"];

    if ([self.dirtyPropertySet containsObject:@"identifier"])
        [dictionary setObject:(self.identifier ? self.identifier : [NSNull null]) forKey:@"identifier"];

    if ([self.dirtyPropertySet containsObject:@"profile"])
        [dictionary setObject:(self.profile ?
                              [self.profile toReplaceDictionaryIncludingArrays:NO] :
                              [[JRProfile profile] toReplaceDictionaryIncludingArrays:NO]) /* Use the default constructor to create an empty object */
                       forKey:@"profile"];
    else if ([self.profile needsUpdate])
        [dictionary setObject:[self.profile toUpdateDictionary]
                       forKey:@"profile"];

    if ([self.dirtyPropertySet containsObject:@"provider"])
        [dictionary setObject:(self.provider ? self.provider : [NSNull null]) forKey:@"provider"];

    if ([self.dirtyPropertySet containsObject:@"remote_key"])
        [dictionary setObject:(self.remote_key ? self.remote_key : [NSNull null]) forKey:@"remote_key"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionaryIncludingArrays:(BOOL)includingArrays
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.accessCredentials ? self.accessCredentials : [NSNull null]) forKey:@"accessCredentials"];
    [dictionary setObject:(self.domain ? self.domain : [NSNull null]) forKey:@"domain"];

    if (includingArrays)
        [dictionary setObject:(self.followers ?
                          self.followers :
                          [NSArray array])
                       forKey:@"followers"];

    if (includingArrays)
        [dictionary setObject:(self.following ?
                          self.following :
                          [NSArray array])
                       forKey:@"following"];

    if (includingArrays)
        [dictionary setObject:(self.friends ?
                          self.friends :
                          [NSArray array])
                       forKey:@"friends"];
    [dictionary setObject:(self.identifier ? self.identifier : [NSNull null]) forKey:@"identifier"];

    [dictionary setObject:(self.profile ?
                          [self.profile toReplaceDictionaryIncludingArrays:YES] :
                          [[JRProfile profile] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                     forKey:@"profile"];
    [dictionary setObject:(self.provider ? self.provider : [NSNull null]) forKey:@"provider"];
    [dictionary setObject:(self.remote_key ? self.remote_key : [NSNull null]) forKey:@"remote_key"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)replaceFollowersArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.followers named:@"followers" isArrayOfStrings:YES
                       withType:@"identifier" forDelegate:delegate withContext:context];
}

- (void)replaceFollowingArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.following named:@"following" isArrayOfStrings:YES
                       withType:@"identifier" forDelegate:delegate withContext:context];
}

- (void)replaceFriendsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.friends named:@"friends" isArrayOfStrings:YES
                       withType:@"identifier" forDelegate:delegate withContext:context];
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
    if (!self.accessCredentials && !otherProfilesElement.accessCredentials) /* Keep going... */;
    else if ((self.accessCredentials == nil) ^ (otherProfilesElement.accessCredentials == nil)) return NO; // xor
    else if (![self.accessCredentials isEqual:otherProfilesElement.accessCredentials]) return NO;

    if (!self.domain && !otherProfilesElement.domain) /* Keep going... */;
    else if ((self.domain == nil) ^ (otherProfilesElement.domain == nil)) return NO; // xor
    else if (![self.domain isEqualToString:otherProfilesElement.domain]) return NO;

    if (!self.followers && !otherProfilesElement.followers) /* Keep going... */;
    else if (!self.followers && ![otherProfilesElement.followers count]) /* Keep going... */;
    else if (!otherProfilesElement.followers && ![self.followers count]) /* Keep going... */;
    else if (![self.followers isEqualToArray:otherProfilesElement.followers]) return NO;

    if (!self.following && !otherProfilesElement.following) /* Keep going... */;
    else if (!self.following && ![otherProfilesElement.following count]) /* Keep going... */;
    else if (!otherProfilesElement.following && ![self.following count]) /* Keep going... */;
    else if (![self.following isEqualToArray:otherProfilesElement.following]) return NO;

    if (!self.friends && !otherProfilesElement.friends) /* Keep going... */;
    else if (!self.friends && ![otherProfilesElement.friends count]) /* Keep going... */;
    else if (!otherProfilesElement.friends && ![self.friends count]) /* Keep going... */;
    else if (![self.friends isEqualToArray:otherProfilesElement.friends]) return NO;

    if (!self.identifier && !otherProfilesElement.identifier) /* Keep going... */;
    else if ((self.identifier == nil) ^ (otherProfilesElement.identifier == nil)) return NO; // xor
    else if (![self.identifier isEqualToString:otherProfilesElement.identifier]) return NO;

    if (!self.profile && !otherProfilesElement.profile) /* Keep going... */;
    else if (!self.profile && [otherProfilesElement.profile isEqualToProfile:[JRProfile profile]]) /* Keep going... */;
    else if (!otherProfilesElement.profile && [self.profile isEqualToProfile:[JRProfile profile]]) /* Keep going... */;
    else if (![self.profile isEqualToProfile:otherProfilesElement.profile]) return NO;

    if (!self.provider && !otherProfilesElement.provider) /* Keep going... */;
    else if ((self.provider == nil) ^ (otherProfilesElement.provider == nil)) return NO; // xor
    else if (![self.provider isEqual:otherProfilesElement.provider]) return NO;

    if (!self.remote_key && !otherProfilesElement.remote_key) /* Keep going... */;
    else if ((self.remote_key == nil) ^ (otherProfilesElement.remote_key == nil)) return NO; // xor
    else if (![self.remote_key isEqualToString:otherProfilesElement.remote_key]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"JRObjectId" forKey:@"profilesElementId"];
    [dictionary setObject:@"JRJsonObject" forKey:@"accessCredentials"];
    [dictionary setObject:@"NSString" forKey:@"domain"];
    [dictionary setObject:@"JRStringArray" forKey:@"followers"];
    [dictionary setObject:@"JRStringArray" forKey:@"following"];
    [dictionary setObject:@"JRStringArray" forKey:@"friends"];
    [dictionary setObject:@"NSString" forKey:@"identifier"];
    [dictionary setObject:@"JRProfile" forKey:@"profile"];
    [dictionary setObject:@"JRJsonObject" forKey:@"provider"];
    [dictionary setObject:@"NSString" forKey:@"remote_key"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
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
