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


#import "JRRelationships.h"

@implementation JRRelationships
{
    NSInteger _relationshipsId;
    NSString *_relationship;
}
@dynamic relationshipsId;
@dynamic relationship;

- (NSInteger)relationshipsId
{
    return _relationshipsId;
}

- (void)setRelationshipsId:(NSInteger)newRelationshipsId
{
    [self.dirtyPropertySet addObject:@"relationshipsId"];

    _relationshipsId = newRelationshipsId;
}

- (NSString *)relationship
{
    return _relationship;
}

- (void)setRelationship:(NSString *)newRelationship
{
    [self.dirtyPropertySet addObject:@"relationship"];

    if (!newRelationship)
        _relationship = [NSNull null];
    else
        _relationship = [newRelationship copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/relationships";
    }
    return self;
}

+ (id)relationships
{
    return [[[JRRelationships alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRRelationships *relationshipsCopy =
                [[JRRelationships allocWithZone:zone] init];

    relationshipsCopy.relationshipsId = self.relationshipsId;
    relationshipsCopy.relationship = self.relationship;

    return relationshipsCopy;
}

+ (id)relationshipsObjectFromDictionary:(NSDictionary*)dictionary
{
    JRRelationships *relationships =
        [JRRelationships relationships];

    relationships.relationshipsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    relationships.relationship = [dictionary objectForKey:@"relationship"];

    return relationships;
}

- (NSDictionary*)dictionaryFromRelationshipsObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.relationshipsId)
        [dict setObject:[NSNumber numberWithInt:self.relationshipsId] forKey:@"id"];

    if (self.relationship && self.relationship != [NSNull null])
        [dict setObject:self.relationship forKey:@"relationship"];
    else
        [dict setObject:[NSNull null] forKey:@"relationship"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"id"])
        _relationshipsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"relationship"])
        _relationship = [dictionary objectForKey:@"relationship"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    _relationshipsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    _relationship = [dictionary objectForKey:@"relationship"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"relationshipsId"])
        [dict setObject:[NSNumber numberWithInt:self.relationshipsId] forKey:@"id"];

    if ([self.dirtyPropertySet containsObject:@"relationship"])
        [dict setObject:self.relationship forKey:@"relationship"];

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

    [dict setObject:[NSNumber numberWithInt:self.relationshipsId] forKey:@"id"];
    [dict setObject:self.relationship forKey:@"relationship"];

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
    [_relationship release];

    [super dealloc];
}
@end
