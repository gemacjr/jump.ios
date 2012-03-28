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


#import "JRSports.h"

@implementation JRSports
{
    NSInteger _sportsId;
    NSString *_sport;
}
@dynamic sportsId;
@dynamic sport;

- (NSInteger)sportsId
{
    return _sportsId;
}

- (void)setSportsId:(NSInteger)newSportsId
{
    [self.dirtyPropertySet addObject:@"sportsId"];

    _sportsId = newSportsId;
}

- (NSString *)sport
{
    return _sport;
}

- (void)setSport:(NSString *)newSport
{
    [self.dirtyPropertySet addObject:@"sport"];

    _sport = [newSport copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/sports";
    }
    return self;
}

+ (id)sports
{
    return [[[JRSports alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRSports *sportsCopy =
                [[JRSports allocWithZone:zone] init];

    sportsCopy.sportsId = self.sportsId;
    sportsCopy.sport = self.sport;

    return sportsCopy;
}

+ (id)sportsObjectFromDictionary:(NSDictionary*)dictionary
{
    JRSports *sports =
        [JRSports sports];

    sports.sportsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    sports.sport = [dictionary objectForKey:@"sport"];

    return sports;
}

- (NSDictionary*)dictionaryFromSportsObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.sportsId)
        [dict setObject:[NSNumber numberWithInt:self.sportsId] forKey:@"id"];

    if (self.sport)
        [dict setObject:self.sport forKey:@"sport"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"sport"])
        self.sport = [dictionary objectForKey:@"sport"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    self.sportsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    self.sport = [dictionary objectForKey:@"sport"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"sport"])
        [dict setObject:self.sport forKey:@"sport"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:dict
                                     withId:self.sportsId
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:self.sport forKey:@"sport"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:dict
                                      withId:self.sportsId
                                      atPath:self.captureObjectPath
                                   withToken:[JRCaptureData accessToken]
                                 forDelegate:self
                                 withContext:newContext];
}

- (void)dealloc
{
    [_sport release];

    [super dealloc];
}
@end
