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


#import "JRTurnOns.h"

@implementation JRTurnOns
{
    NSInteger _turnOnsId;
    NSString *_turnOn;
}
@dynamic turnOnsId;
@dynamic turnOn;

- (NSInteger)turnOnsId
{
    return _turnOnsId;
}

- (void)setTurnOnsId:(NSInteger)newTurnOnsId
{
    [self.dirtyPropertySet addObject:@"turnOnsId"];

    _turnOnsId = newTurnOnsId;
}

- (NSString *)turnOn
{
    return _turnOn;
}

- (void)setTurnOn:(NSString *)newTurnOn
{
    [self.dirtyPropertySet addObject:@"turnOn"];

    if (!newTurnOn)
        _turnOn = [NSNull null];
    else
        _turnOn = [newTurnOn copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/turnOns";
    }
    return self;
}

+ (id)turnOns
{
    return [[[JRTurnOns alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRTurnOns *turnOnsCopy =
                [[JRTurnOns allocWithZone:zone] init];

    turnOnsCopy.turnOnsId = self.turnOnsId;
    turnOnsCopy.turnOn = self.turnOn;

    return turnOnsCopy;
}

+ (id)turnOnsObjectFromDictionary:(NSDictionary*)dictionary
{
    JRTurnOns *turnOns =
        [JRTurnOns turnOns];

    turnOns.turnOnsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    turnOns.turnOn = [dictionary objectForKey:@"turnOn"];

    return turnOns;
}

- (NSDictionary*)dictionaryFromTurnOnsObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.turnOnsId)
        [dict setObject:[NSNumber numberWithInt:self.turnOnsId] forKey:@"id"];

    if (self.turnOn && self.turnOn != [NSNull null])
        [dict setObject:self.turnOn forKey:@"turnOn"];
    else
        [dict setObject:[NSNull null] forKey:@"turnOn"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"id"])
        _turnOnsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"turnOn"])
        _turnOn = [dictionary objectForKey:@"turnOn"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    _turnOnsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    _turnOn = [dictionary objectForKey:@"turnOn"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"turnOnsId"])
        [dict setObject:[NSNumber numberWithInt:self.turnOnsId] forKey:@"id"];

    if ([self.dirtyPropertySet containsObject:@"turnOn"])
        [dict setObject:self.turnOn forKey:@"turnOn"];

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

    [dict setObject:[NSNumber numberWithInt:self.turnOnsId] forKey:@"id"];
    [dict setObject:self.turnOn forKey:@"turnOn"];

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
    [_turnOn release];

    [super dealloc];
}
@end
