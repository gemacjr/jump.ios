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


#import "JRLookingFor.h"

@implementation JRLookingFor
{
    NSInteger _lookingForId;
    NSString *_value;
}
@dynamic lookingForId;
@dynamic value;

- (NSInteger)lookingForId
{
    return _lookingForId;
}

- (void)setLookingForId:(NSInteger)newLookingForId
{
    [self.dirtyPropertySet addObject:@"lookingForId"];

    _lookingForId = newLookingForId;
}

- (NSString *)value
{
    return _value;
}

- (void)setValue:(NSString *)newValue
{
    [self.dirtyPropertySet addObject:@"value"];

    if (!newValue)
        _value = [NSNull null];
    else
        _value = [newValue copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/lookingFor";
    }
    return self;
}

+ (id)lookingFor
{
    return [[[JRLookingFor alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRLookingFor *lookingForCopy =
                [[JRLookingFor allocWithZone:zone] init];

    lookingForCopy.lookingForId = self.lookingForId;
    lookingForCopy.value = self.value;

    return lookingForCopy;
}

+ (id)lookingForObjectFromDictionary:(NSDictionary*)dictionary
{
    JRLookingFor *lookingFor =
        [JRLookingFor lookingFor];

    lookingFor.lookingForId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    lookingFor.value = [dictionary objectForKey:@"value"];

    return lookingFor;
}

- (NSDictionary*)dictionaryFromLookingForObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.lookingForId)
        [dict setObject:[NSNumber numberWithInt:self.lookingForId] forKey:@"id"];

    if (self.value && self.value != [NSNull null])
        [dict setObject:self.value forKey:@"value"];
    else
        [dict setObject:[NSNull null] forKey:@"value"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"id"])
        _lookingForId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"value"])
        _value = [dictionary objectForKey:@"value"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    _lookingForId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    _value = [dictionary objectForKey:@"value"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"lookingForId"])
        [dict setObject:[NSNumber numberWithInt:self.lookingForId] forKey:@"id"];

    if ([self.dirtyPropertySet containsObject:@"value"])
        [dict setObject:self.value forKey:@"value"];

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

    [dict setObject:[NSNumber numberWithInt:self.lookingForId] forKey:@"id"];
    [dict setObject:self.value forKey:@"value"];

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
    [_value release];

    [super dealloc];
}
@end
