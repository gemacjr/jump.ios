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


#import "JRPinoLevelThree.h"

@implementation JRPinoLevelThree
{
    JRObjectId *_pinoLevelThreeId;
    NSString *_level;
    NSString *_name;
}
@dynamic pinoLevelThreeId;
@dynamic level;
@dynamic name;

- (JRObjectId *)pinoLevelThreeId
{
    return _pinoLevelThreeId;
}

- (void)setPinoLevelThreeId:(JRObjectId *)newPinoLevelThreeId
{
    [self.dirtyPropertySet addObject:@"pinoLevelThreeId"];
    _pinoLevelThreeId = [newPinoLevelThreeId copy];
}

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

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/pinoLevelOne/pinoLevelTwo/pinoLevelThree";
    }
    return self;
}

+ (id)pinoLevelThree
{
    return [[[JRPinoLevelThree alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRPinoLevelThree *pinoLevelThreeCopy =
                [[JRPinoLevelThree allocWithZone:zone] init];

    pinoLevelThreeCopy.pinoLevelThreeId = self.pinoLevelThreeId;
    pinoLevelThreeCopy.level = self.level;
    pinoLevelThreeCopy.name = self.name;

    [pinoLevelThreeCopy.dirtyPropertySet removeAllObjects];
    [pinoLevelThreeCopy.dirtyPropertySet setSet:self.dirtyPropertySet];

    return pinoLevelThreeCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.pinoLevelThreeId ? [NSNumber numberWithInteger:[self.pinoLevelThreeId integerValue]] : [NSNull null])
             forKey:@"id"];
    [dict setObject:(self.level ? self.level : [NSNull null])
             forKey:@"level"];
    [dict setObject:(self.name ? self.name : [NSNull null])
             forKey:@"name"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)pinoLevelThreeObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRPinoLevelThree *pinoLevelThree = [JRPinoLevelThree pinoLevelThree];
    pinoLevelThree.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pinoLevelThree", [pinoLevelThree.pinoLevelThreeId integerValue]];

    pinoLevelThree.pinoLevelThreeId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    pinoLevelThree.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    pinoLevelThree.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    [pinoLevelThree.dirtyPropertySet removeAllObjects];
    
    return pinoLevelThree;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pinoLevelThree", [self.pinoLevelThreeId integerValue]];

    if ([dictionary objectForKey:@"id"])
        self.pinoLevelThreeId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
            [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    if ([dictionary objectForKey:@"level"])
        self.level = [dictionary objectForKey:@"level"] != [NSNull null] ? 
            [dictionary objectForKey:@"level"] : nil;

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"] != [NSNull null] ? 
            [dictionary objectForKey:@"name"] : nil;
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pinoLevelThree", [self.pinoLevelThreeId integerValue]];

    self.pinoLevelThreeId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.level =
        [dictionary objectForKey:@"level"] != [NSNull null] ? 
        [dictionary objectForKey:@"level"] : nil;

    self.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"level"])
        [dict setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    return dict;
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:[self toUpdateDictionary]
                                     withId:[self.pinoLevelThreeId integerValue]
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.level ? self.level : [NSNull null]) forKey:@"level"];
    [dict setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    return dict;
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:[self toReplaceDictionary]
                                      withId:[self.pinoLevelThreeId integerValue]
                                      atPath:self.captureObjectPath
                                   withToken:[JRCaptureData accessToken]
                                 forDelegate:self
                                 withContext:newContext];
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"JRObjectId" forKey:@"pinoLevelThreeId"];
    [dict setObject:@"NSString" forKey:@"level"];
    [dict setObject:@"NSString" forKey:@"name"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_pinoLevelThreeId release];
    [_level release];
    [_name release];

    [super dealloc];
}
@end
