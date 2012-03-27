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


#import "JROpponents.h"

@implementation JROpponents
{
    NSInteger _opponentsId;
    NSString *_name;
}
@dynamic opponentsId;
@dynamic name;

- (NSInteger)opponentsId
{
    return _opponentsId;
}

- (void)setOpponentsId:(NSInteger)newOpponentsId
{
    [self.dirtyPropertySet addObject:@"opponentsId"];

    _opponentsId = newOpponentsId;
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

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/games/opponents";
    }
    return self;
}

+ (id)opponents
{
    return [[[JROpponents alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JROpponents *opponentsCopy =
                [[JROpponents allocWithZone:zone] init];

    opponentsCopy.opponentsId = self.opponentsId;
    opponentsCopy.name = self.name;

    return opponentsCopy;
}

+ (id)opponentsObjectFromDictionary:(NSDictionary*)dictionary
{
    JROpponents *opponents =
        [JROpponents opponents];

    opponents.opponentsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    opponents.name = [dictionary objectForKey:@"name"];

    return opponents;
}

- (NSDictionary*)dictionaryFromOpponentsObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.opponentsId)
        [dict setObject:[NSNumber numberWithInt:self.opponentsId] forKey:@"id"];

    if (self.name)
        [dict setObject:self.name forKey:@"name"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    self.opponentsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    self.name = [dictionary objectForKey:@"name"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:self.name forKey:@"name"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo updateCaptureObject:dict
                                        withId:self.opponentsId
                                        atPath:self.captureObjectPath
                                     withToken:[JRCaptureData accessToken]
                                   forDelegate:super
                                   withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:self.name forKey:@"name"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo replaceCaptureObject:dict
                                         withId:self.opponentsId
                                         atPath:self.captureObjectPath
                                      withToken:[JRCaptureData accessToken]
                                    forDelegate:super
                                    withContext:newContext];
}

- (void)dealloc
{
    [_name release];

    [super dealloc];
}
@end
