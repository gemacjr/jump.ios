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


#import "JRCaptureObject+Internal.h"
#import "JRPinapinoL3PluralElement.h"

@interface JRPinapinoL3PluralElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRPinapinoL3PluralElement
{
    NSString *_string1;
    NSString *_string2;
}
@synthesize canBeUpdatedOrReplaced;

- (NSString *)string1
{
    return _string1;
}

- (void)setString1:(NSString *)newString1
{
    [self.dirtyPropertySet addObject:@"string1"];

    [_string1 autorelease];
    _string1 = [newString1 copy];
}

- (NSString *)string2
{
    return _string2;
}

- (void)setString2:(NSString *)newString2
{
    [self.dirtyPropertySet addObject:@"string2"];

    [_string2 autorelease];
    _string2 = [newString2 copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;


        [self.dirtyPropertySet setSet:[NSMutableSet setWithObjects:@"string1", @"string2", nil]];
    }
    return self;
}

+ (id)pinapinoL3PluralElement
{
    return [[[JRPinapinoL3PluralElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPinapinoL3PluralElement *pinapinoL3PluralElementCopy = (JRPinapinoL3PluralElement *)[super copyWithZone:zone];

    pinapinoL3PluralElementCopy.string1 = self.string1;
    pinapinoL3PluralElementCopy.string2 = self.string2;

    return pinapinoL3PluralElementCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.string1 ? self.string1 : [NSNull null])
                   forKey:@"string1"];
    [dictionary setObject:(self.string2 ? self.string2 : [NSNull null])
                   forKey:@"string2"];

    if (forEncoder)
    {
        [dictionary setObject:([self.dirtyPropertySet allObjects] ? [self.dirtyPropertySet allObjects] : [NSArray array])
                       forKey:@"dirtyPropertySet"];
        [dictionary setObject:(self.captureObjectPath ? self.captureObjectPath : [NSNull null])
                       forKey:@"captureObjectPath"];
        [dictionary setObject:[NSNumber numberWithBool:self.canBeUpdatedOrReplaced] 
                       forKey:@"canBeUpdatedOrReplaced"];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (id)pinapinoL3PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRPinapinoL3PluralElement *pinapinoL3PluralElement = [JRPinapinoL3PluralElement pinapinoL3PluralElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        pinapinoL3PluralElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        pinapinoL3PluralElement.canBeUpdatedOrReplaced = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOrReplaced"] boolValue];
    }
    else
    {
        pinapinoL3PluralElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pinapinoL3Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        // TODO: Is this safe to assume?
        pinapinoL3PluralElement.canBeUpdatedOrReplaced = YES;
    }

    pinapinoL3PluralElement.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    pinapinoL3PluralElement.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    if (fromDecoder)
        [pinapinoL3PluralElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [pinapinoL3PluralElement.dirtyPropertySet removeAllObjects];
    
    return pinapinoL3PluralElement;
}

+ (id)pinapinoL3PluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRPinapinoL3PluralElement pinapinoL3PluralElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pinapinoL3Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"string1"])
        self.string1 = [dictionary objectForKey:@"string1"] != [NSNull null] ? 
            [dictionary objectForKey:@"string1"] : nil;

    if ([dictionary objectForKey:@"string2"])
        self.string2 = [dictionary objectForKey:@"string2"] != [NSNull null] ? 
            [dictionary objectForKey:@"string2"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pinapinoL3Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    self.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"string1"])
        [dictionary setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];

    if ([self.dirtyPropertySet containsObject:@"string2"])
        [dictionary setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionaryIncludingArrays:(BOOL)includingArrays
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];
    [dictionary setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToPinapinoL3PluralElement:(JRPinapinoL3PluralElement *)otherPinapinoL3PluralElement
{
    if (!self.string1 && !otherPinapinoL3PluralElement.string1) /* Keep going... */;
    else if ((self.string1 == nil) ^ (otherPinapinoL3PluralElement.string1 == nil)) return NO; // xor
    else if (![self.string1 isEqualToString:otherPinapinoL3PluralElement.string1]) return NO;

    if (!self.string2 && !otherPinapinoL3PluralElement.string2) /* Keep going... */;
    else if ((self.string2 == nil) ^ (otherPinapinoL3PluralElement.string2 == nil)) return NO; // xor
    else if (![self.string2 isEqualToString:otherPinapinoL3PluralElement.string2]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"string1"];
    [dictionary setObject:@"NSString" forKey:@"string2"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];

    [super dealloc];
}
@end
