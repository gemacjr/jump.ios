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


#import "JRFollowing.h"

@implementation JRFollowing
{
    NSInteger _followingId;
    NSString *_identifier;
}
@dynamic followingId;
@dynamic identifier;

- (NSInteger)followingId
{
    return _followingId;
}

- (void)setFollowingId:(NSInteger)newFollowingId
{
    [self.dirtyPropertySet addObject:@"followingId"];

    _followingId = newFollowingId;
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

- (id)initWithIdentifier:(NSString *)newIdentifier
{
    if (!newIdentifier)
    {
        [self release];
        return nil;
     }

    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/following";
        _identifier = [newIdentifier copy];
    }
    return self;
}

+ (id)followingWithIdentifier:(NSString *)identifier
{
    return [[[JRFollowing alloc] initWithIdentifier:identifier] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRFollowing *followingCopy =
                [[JRFollowing allocWithZone:zone] initWithIdentifier:self.identifier];

    followingCopy.followingId = self.followingId;

    return followingCopy;
}

+ (id)followingObjectFromDictionary:(NSDictionary*)dictionary
{
    JRFollowing *following =
        [JRFollowing followingWithIdentifier:[dictionary objectForKey:@"identifier"]];

    following.followingId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    return following;
}

- (NSDictionary*)dictionaryFromFollowingObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:self.identifier forKey:@"identifier"];

    if (self.followingId)
        [dict setObject:[NSNumber numberWithInt:self.followingId] forKey:@"id"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"identifier"])
        self.identifier = [dictionary objectForKey:@"identifier"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    self.followingId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    self.identifier = [dictionary objectForKey:@"identifier"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"identifier"])
        [dict setObject:self.identifier forKey:@"identifier"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo updateCaptureObject:dict
                                        withId:self.followingId
                                        atPath:self.captureObjectPath
                                     withToken:[JRCaptureData accessToken]
                                   forDelegate:self
                                   withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:self.identifier forKey:@"identifier"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo replaceCaptureObject:dict
                                         withId:self.followingId
                                         atPath:self.captureObjectPath
                                      withToken:[JRCaptureData accessToken]
                                    forDelegate:self
                                    withContext:newContext];
}

- (void)dealloc
{
    [_identifier release];

    [super dealloc];
}
@end
