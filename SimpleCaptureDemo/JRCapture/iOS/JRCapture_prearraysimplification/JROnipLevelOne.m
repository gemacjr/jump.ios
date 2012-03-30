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


#import "JROnipLevelOne.h"

@implementation JROnipLevelOne
{
    NSInteger _onipLevelOneId;
    NSString *_level;
    NSString *_name;
    JROnipLevelTwo *_onipLevelTwo;
}
@dynamic onipLevelOneId;
@dynamic level;
@dynamic name;
@dynamic onipLevelTwo;

- (NSInteger)onipLevelOneId
{
    return _onipLevelOneId;
}

- (void)setOnipLevelOneId:(NSInteger)newOnipLevelOneId
{
    [self.dirtyPropertySet addObject:@"onipLevelOneId"];

    _onipLevelOneId = newOnipLevelOneId;
}

- (NSString *)level
{
    return _level;
}

- (void)setLevel:(NSString *)newLevel
{
    [self.dirtyPropertySet addObject:@"level"];

    if (!newLevel)
        _level = [NSNull null];
    else
        _level = [newLevel copy];
}

- (NSString *)name
{
    return _name;
}

- (void)setName:(NSString *)newName
{
    [self.dirtyPropertySet addObject:@"name"];

    if (!newName)
        _name = [NSNull null];
    else
        _name = [newName copy];
}

- (JROnipLevelTwo *)onipLevelTwo
{
    return _onipLevelTwo;
}

- (void)setOnipLevelTwo:(JROnipLevelTwo *)newOnipLevelTwo
{
    [self.dirtyPropertySet addObject:@"onipLevelTwo"];

    if (!newOnipLevelTwo)
        _onipLevelTwo = [NSNull null];
    else
        _onipLevelTwo = [newOnipLevelTwo copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/onipLevelOne";
    }
    return self;
}

+ (id)onipLevelOne
{
    return [[[JROnipLevelOne alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JROnipLevelOne *onipLevelOneCopy =
                [[JROnipLevelOne allocWithZone:zone] init];

    onipLevelOneCopy.onipLevelOneId = self.onipLevelOneId;
    onipLevelOneCopy.level = self.level;
    onipLevelOneCopy.name = self.name;
    onipLevelOneCopy.onipLevelTwo = self.onipLevelTwo;

    return onipLevelOneCopy;
}

+ (id)onipLevelOneObjectFromDictionary:(NSDictionary*)dictionary
{
    JROnipLevelOne *onipLevelOne =
        [JROnipLevelOne onipLevelOne];

    onipLevelOne.onipLevelOneId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    onipLevelOne.level = [dictionary objectForKey:@"level"];
    onipLevelOne.name = [dictionary objectForKey:@"name"];
    onipLevelOne.onipLevelTwo = [JROnipLevelTwo onipLevelTwoObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"onipLevelTwo"]];

    return onipLevelOne;
}

- (NSDictionary*)dictionaryFromOnipLevelOneObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.onipLevelOneId)
        [dict setObject:[NSNumber numberWithInt:self.onipLevelOneId] forKey:@"id"];

    if (self.level && self.level != [NSNull null])
        [dict setObject:self.level forKey:@"level"];
    else
        [dict setObject:[NSNull null] forKey:@"level"];

    if (self.name && self.name != [NSNull null])
        [dict setObject:self.name forKey:@"name"];
    else
        [dict setObject:[NSNull null] forKey:@"name"];

    if (self.onipLevelTwo && self.onipLevelTwo != [NSNull null])
        [dict setObject:[self.onipLevelTwo dictionaryFromOnipLevelTwoObject] forKey:@"onipLevelTwo"];
    else
        [dict setObject:[NSNull null] forKey:@"onipLevelTwo"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"id"])
        _onipLevelOneId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"level"])
        _level = [dictionary objectForKey:@"level"];

    if ([dictionary objectForKey:@"name"])
        _name = [dictionary objectForKey:@"name"];

    if ([dictionary objectForKey:@"onipLevelTwo"])
        _onipLevelTwo = [JROnipLevelTwo onipLevelTwoObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"onipLevelTwo"]];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    _onipLevelOneId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    _level = [dictionary objectForKey:@"level"];
    _name = [dictionary objectForKey:@"name"];
    _onipLevelTwo = [JROnipLevelTwo onipLevelTwoObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"onipLevelTwo"]];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"onipLevelOneId"])
        [dict setObject:[NSNumber numberWithInt:self.onipLevelOneId] forKey:@"id"];

    if ([self.dirtyPropertySet containsObject:@"level"])
        [dict setObject:self.level forKey:@"level"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:self.name forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"onipLevelTwo"])
        [dict setObject:[self.onipLevelTwo dictionaryFromOnipLevelTwoObject] forKey:@"onipLevelTwo"];

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

    [dict setObject:[NSNumber numberWithInt:self.onipLevelOneId] forKey:@"id"];
    [dict setObject:self.level forKey:@"level"];
    [dict setObject:self.name forKey:@"name"];
    [dict setObject:[self.onipLevelTwo dictionaryFromOnipLevelTwoObject] forKey:@"onipLevelTwo"];

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
    [_level release];
    [_name release];
    [_onipLevelTwo release];

    [super dealloc];
}
@end
