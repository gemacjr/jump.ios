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


#import "JRTurnOffs.h"

@implementation JRTurnOffs
{
    NSInteger _turnOffsId;
    NSString *_turnOff;
}
@dynamic turnOffsId;
@dynamic turnOff;

- (NSInteger)turnOffsId
{
    return _turnOffsId;
}

- (void)setTurnOffsId:(NSInteger)newTurnOffsId
{
    [self.dirtyPropertySet addObject:@"turnOffsId"];

    _turnOffsId = newTurnOffsId;
}

- (NSString *)turnOff
{
    return _turnOff;
}

- (void)setTurnOff:(NSString *)newTurnOff
{
    [self.dirtyPropertySet addObject:@"turnOff"];

    _turnOff = [newTurnOff copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/turnOffs";
    }
    return self;
}

+ (id)turnOffs
{
    return [[[JRTurnOffs alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRTurnOffs *turnOffsCopy =
                [[JRTurnOffs allocWithZone:zone] init];

    turnOffsCopy.turnOffsId = self.turnOffsId;
    turnOffsCopy.turnOff = self.turnOff;

    return turnOffsCopy;
}

+ (id)turnOffsObjectFromDictionary:(NSDictionary*)dictionary
{
    JRTurnOffs *turnOffs =
        [JRTurnOffs turnOffs];

    turnOffs.turnOffsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    turnOffs.turnOff = [dictionary objectForKey:@"turnOff"];

    return turnOffs;
}

- (NSDictionary*)dictionaryFromTurnOffsObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.turnOffsId)
        [dict setObject:[NSNumber numberWithInt:self.turnOffsId] forKey:@"id"];

    if (self.turnOff)
        [dict setObject:self.turnOff forKey:@"turnOff"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"turnOff"])
        self.turnOff = [dictionary objectForKey:@"turnOff"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    self.turnOffsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    self.turnOff = [dictionary objectForKey:@"turnOff"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"turnOff"])
        [dict setObject:self.turnOff forKey:@"turnOff"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo updateCaptureObject:dict
                                        withId:self.turnOffsId
                                        atPath:self.captureObjectPath
                                     withToken:[JRCaptureData accessToken]
                                   forDelegate:super
                                   withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:self.turnOff forKey:@"turnOff"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo replaceCaptureObject:dict
                                         withId:self.turnOffsId
                                         atPath:self.captureObjectPath
                                      withToken:[JRCaptureData accessToken]
                                    forDelegate:super
                                    withContext:newContext];
}

- (void)dealloc
{
    [_turnOff release];

    [super dealloc];
}
@end
