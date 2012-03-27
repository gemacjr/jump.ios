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


#import "JRPinoLevelOne.h"

@implementation JRPinoLevelOne
{
    NSString *_level;
    NSString *_name;
    JRPinoLevelTwo *_pinoLevelTwo;
}
@dynamic level;
@dynamic name;
@dynamic pinoLevelTwo;

- (NSString *)level
{
    return _level;
}

- (void)setLevel:(NSString *)newLevel
{
    [self.dirtyPropertySet addObject:@"level"];

    _level = [newLevel copy];
}

- (NSString *)name
{
    return _name;
}

- (void)setName:(NSString *)newName
{
    [self.dirtyPropertySet addObject:@"name"];

    _name = [newName copy];
}

- (JRPinoLevelTwo *)pinoLevelTwo
{
    return _pinoLevelTwo;
}

- (void)setPinoLevelTwo:(JRPinoLevelTwo *)newPinoLevelTwo
{
    [self.dirtyPropertySet addObject:@"pinoLevelTwo"];

    _pinoLevelTwo = [newPinoLevelTwo copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/pinoLevelOne";
    }
    return self;
}

+ (id)pinoLevelOne
{
    return [[[JRPinoLevelOne alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPinoLevelOne *pinoLevelOneCopy =
                [[JRPinoLevelOne allocWithZone:zone] init];

    pinoLevelOneCopy.level = self.level;
    pinoLevelOneCopy.name = self.name;
    pinoLevelOneCopy.pinoLevelTwo = self.pinoLevelTwo;

    return pinoLevelOneCopy;
}

+ (id)pinoLevelOneObjectFromDictionary:(NSDictionary*)dictionary
{
    JRPinoLevelOne *pinoLevelOne =
        [JRPinoLevelOne pinoLevelOne];

    pinoLevelOne.level = [dictionary objectForKey:@"level"];
    pinoLevelOne.name = [dictionary objectForKey:@"name"];
    pinoLevelOne.pinoLevelTwo = [JRPinoLevelTwo pinoLevelTwoObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"pinoLevelTwo"]];

    return pinoLevelOne;
}

- (NSDictionary*)dictionaryFromPinoLevelOneObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.level)
        [dict setObject:self.level forKey:@"level"];

    if (self.name)
        [dict setObject:self.name forKey:@"name"];

    if (self.pinoLevelTwo)
        [dict setObject:[self.pinoLevelTwo dictionaryFromPinoLevelTwoObject] forKey:@"pinoLevelTwo"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"level"])
        self.level = [dictionary objectForKey:@"level"];

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"];

    if ([dictionary objectForKey:@"pinoLevelTwo"])
        self.pinoLevelTwo = [JRPinoLevelTwo pinoLevelTwoObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"pinoLevelTwo"]];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    self.level = [dictionary objectForKey:@"level"];
    self.name = [dictionary objectForKey:@"name"];
    self.pinoLevelTwo = [JRPinoLevelTwo pinoLevelTwoObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:@"pinoLevelTwo"]];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"level"])
        [dict setObject:self.level forKey:@"level"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:self.name forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"pinoLevelTwo"])
        [dict setObject:[self.pinoLevelTwo dictionaryFromPinoLevelTwoObject] forKey:@"pinoLevelTwo"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo updateCaptureObject:dict
                                        withId:nil
                                        atPath:self.captureObjectPath
                                     withToken:[JRCaptureData accessToken]
                                   forDelegate:super
                                   withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:self.level forKey:@"level"];
    [dict setObject:self.name forKey:@"name"];
    [dict setObject:[self.pinoLevelTwo dictionaryFromPinoLevelTwoObject] forKey:@"pinoLevelTwo"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo replaceCaptureObject:dict
                                         withId:nil
                                         atPath:self.captureObjectPath
                                      withToken:[JRCaptureData accessToken]
                                    forDelegate:super
                                    withContext:newContext];
}

- (void)dealloc
{
    [_level release];
    [_name release];
    [_pinoLevelTwo release];

    [super dealloc];
}
@end
