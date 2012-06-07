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


#import "JRPinonipL1PluralElement.h"

@interface JRPinonipL1PluralElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRPinonipL1PluralElement
{
    NSString *_string1;
    NSString *_string2;
    JRPinonipL2Object *_pinonipL2Object;
}
@dynamic string1;
@dynamic string2;
@dynamic pinonipL2Object;
@synthesize canBeUpdatedOrReplaced;

- (NSString *)string1
{
    return _string1;
}

- (void)setString1:(NSString *)newString1
{
    [self.dirtyPropertySet addObject:@"string1"];
    _string1 = [newString1 copy];
}

- (NSString *)string2
{
    return _string2;
}

- (void)setString2:(NSString *)newString2
{
    [self.dirtyPropertySet addObject:@"string2"];
    _string2 = [newString2 copy];
}

- (JRPinonipL2Object *)pinonipL2Object
{
    return _pinonipL2Object;
}

- (void)setPinonipL2Object:(JRPinonipL2Object *)newPinonipL2Object
{
    [self.dirtyPropertySet addObject:@"pinonipL2Object"];
    _pinonipL2Object = [newPinonipL2Object copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;
    }
    return self;
}

+ (id)pinonipL1Plural
{
    return [[[JRPinonipL1PluralElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRPinonipL1PluralElement *pinonipL1PluralCopy =
                [[JRPinonipL1PluralElement allocWithZone:zone] init];

    pinonipL1PluralCopy.captureObjectPath = self.captureObjectPath;

    pinonipL1PluralCopy.string1 = self.string1;
    pinonipL1PluralCopy.string2 = self.string2;
    pinonipL1PluralCopy.pinonipL2Object = self.pinonipL2Object;
    // TODO: Necessary??
    pinonipL1PluralCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    // TODO: Necessary??
    [pinonipL1PluralCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [pinonipL1PluralCopy.dirtyArraySet setSet:self.dirtyArraySet];

    return pinonipL1PluralCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null])
             forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null])
             forKey:@"string2"];
    [dict setObject:(self.pinonipL2Object ? [self.pinonipL2Object toDictionary] : [NSNull null])
             forKey:@"pinonipL2Object"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)pinonipL1PluralObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRPinonipL1PluralElement *pinonipL1Plural = [JRPinonipL1PluralElement pinonipL1Plural];

    pinonipL1Plural.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pinonipL1Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
// TODO: Is this safe to assume?
    pinonipL1Plural.canBeUpdatedOrReplaced = YES;

    pinonipL1Plural.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    pinonipL1Plural.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    pinonipL1Plural.pinonipL2Object =
        [dictionary objectForKey:@"pinonipL2Object"] != [NSNull null] ? 
        [JRPinonipL2Object pinonipL2ObjectObjectFromDictionary:[dictionary objectForKey:@"pinonipL2Object"] withPath:pinonipL1Plural.captureObjectPath] : nil;

    [pinonipL1Plural.dirtyPropertySet removeAllObjects];
    [pinonipL1Plural.dirtyArraySet removeAllObjects];
    
    return pinonipL1Plural;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pinonipL1Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"string1"])
        self.string1 = [dictionary objectForKey:@"string1"] != [NSNull null] ? 
            [dictionary objectForKey:@"string1"] : nil;

    if ([dictionary objectForKey:@"string2"])
        self.string2 = [dictionary objectForKey:@"string2"] != [NSNull null] ? 
            [dictionary objectForKey:@"string2"] : nil;

    if ([dictionary objectForKey:@"pinonipL2Object"] == [NSNull null])
        self.pinonipL2Object = nil;
    else if ([dictionary objectForKey:@"pinonipL2Object"] && !self.pinonipL2Object)
        self.pinonipL2Object = [JRPinonipL2Object pinonipL2ObjectObjectFromDictionary:[dictionary objectForKey:@"pinonipL2Object"] withPath:self.captureObjectPath];
    else if ([dictionary objectForKey:@"pinonipL2Object"])
        [self.pinonipL2Object updateFromDictionary:[dictionary objectForKey:@"pinonipL2Object"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pinonipL1Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    self.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    if (![dictionary objectForKey:@"pinonipL2Object"] || [dictionary objectForKey:@"pinonipL2Object"] == [NSNull null])
        self.pinonipL2Object = nil;
    else if (!self.pinonipL2Object)
        self.pinonipL2Object = [JRPinonipL2Object pinonipL2ObjectObjectFromDictionary:[dictionary objectForKey:@"pinonipL2Object"] withPath:self.captureObjectPath];
    else
        [self.pinonipL2Object replaceFromDictionary:[dictionary objectForKey:@"pinonipL2Object"] withPath:self.captureObjectPath];

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"string1"])
        [dict setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];

    if ([self.dirtyPropertySet containsObject:@"string2"])
        [dict setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    if ([self.dirtyPropertySet containsObject:@"pinonipL2Object"] || [self.pinonipL2Object needsUpdate])
        [dict setObject:(self.pinonipL2Object ?
                              [self.pinonipL2Object toUpdateDictionary] :
                              [[JRPinonipL2Object pinonipL2Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                 forKey:@"pinonipL2Object"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];
    [dict setObject:(self.pinonipL2Object ?
                          [self.pinonipL2Object toReplaceDictionary] :
                          [[JRPinonipL2Object pinonipL2Object] toUpdateDictionary]) /* Use the default constructor to create an empty object */
             forKey:@"pinonipL2Object"];

    return dict;
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if([self.pinonipL2Object needsUpdate])
        return YES;

    return NO;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"string1"];
    [dict setObject:@"NSString" forKey:@"string2"];
    [dict setObject:@"JRPinonipL2Object" forKey:@"pinonipL2Object"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];
    [_pinonipL2Object release];

    [super dealloc];
}
@end
