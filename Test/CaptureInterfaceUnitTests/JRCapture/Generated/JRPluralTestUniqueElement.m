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
#import "JRPluralTestUniqueElement.h"

@interface JRPluralTestUniqueElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRPluralTestUniqueElement
{
    NSString *_uniqueString;
    NSString *_string1;
    NSString *_string2;
}
@synthesize canBeUpdatedOrReplaced;

- (NSString *)uniqueString
{
    return _uniqueString;
}

- (void)setUniqueString:(NSString *)newUniqueString
{
    [self.dirtyPropertySet addObject:@"uniqueString"];

    [_uniqueString autorelease];
    _uniqueString = [newUniqueString copy];
}

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


        [self.dirtyPropertySet setSet:[NSMutableSet setWithObjects:@"uniqueString", @"string1", @"string2", nil]];
    }
    return self;
}

+ (id)pluralTestUniqueElement
{
    return [[[JRPluralTestUniqueElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPluralTestUniqueElement *pluralTestUniqueElementCopy = (JRPluralTestUniqueElement *)[super copyWithZone:zone];

    pluralTestUniqueElementCopy.uniqueString = self.uniqueString;
    pluralTestUniqueElementCopy.string1 = self.string1;
    pluralTestUniqueElementCopy.string2 = self.string2;

    return pluralTestUniqueElementCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.uniqueString ? self.uniqueString : [NSNull null])
                   forKey:@"uniqueString"];
    [dictionary setObject:(self.string1 ? self.string1 : [NSNull null])
                   forKey:@"string1"];
    [dictionary setObject:(self.string2 ? self.string2 : [NSNull null])
                   forKey:@"string2"];

    if (forEncoder)
    {
        [dictionary setObject:[self.dirtyPropertySet allObjects] forKey:@"dirtyPropertiesSet"];
        [dictionary setObject:self.captureObjectPath forKey:@"captureObjectPath"];
        [dictionary setObject:[NSNumber numberWithBool:self.canBeUpdatedOrReplaced] forKey:@"canBeUpdatedOrReplaced"];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (id)pluralTestUniqueElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRPluralTestUniqueElement *pluralTestUniqueElement = [JRPluralTestUniqueElement pluralTestUniqueElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        pluralTestUniqueElement.captureObjectPath      = [dictionary objectForKey:@"captureObjectPath"];
        pluralTestUniqueElement.canBeUpdatedOrReplaced = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOrReplaced"] boolValue];
    }
    else
    {
        pluralTestUniqueElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pluralTestUnique", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        // TODO: Is this safe to assume?
        pluralTestUniqueElement.canBeUpdatedOrReplaced = YES;
    }

    pluralTestUniqueElement.uniqueString =
        [dictionary objectForKey:@"uniqueString"] != [NSNull null] ? 
        [dictionary objectForKey:@"uniqueString"] : nil;

    pluralTestUniqueElement.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    pluralTestUniqueElement.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    if (fromDecoder)
        [pluralTestUniqueElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [pluralTestUniqueElement.dirtyPropertySet removeAllObjects];
    
    return pluralTestUniqueElement;
}

+ (id)pluralTestUniqueElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRPluralTestUniqueElement pluralTestUniqueElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pluralTestUnique", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"uniqueString"])
        self.uniqueString = [dictionary objectForKey:@"uniqueString"] != [NSNull null] ? 
            [dictionary objectForKey:@"uniqueString"] : nil;

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
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pluralTestUnique", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.uniqueString =
        [dictionary objectForKey:@"uniqueString"] != [NSNull null] ? 
        [dictionary objectForKey:@"uniqueString"] : nil;

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

    if ([self.dirtyPropertySet containsObject:@"uniqueString"])
        [dictionary setObject:(self.uniqueString ? self.uniqueString : [NSNull null]) forKey:@"uniqueString"];

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

    [dictionary setObject:(self.uniqueString ? self.uniqueString : [NSNull null]) forKey:@"uniqueString"];
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

- (BOOL)isEqualToPluralTestUniqueElement:(JRPluralTestUniqueElement *)otherPluralTestUniqueElement
{
    if (!self.uniqueString && !otherPluralTestUniqueElement.uniqueString) /* Keep going... */;
    else if ((self.uniqueString == nil) ^ (otherPluralTestUniqueElement.uniqueString == nil)) return NO; // xor
    else if (![self.uniqueString isEqualToString:otherPluralTestUniqueElement.uniqueString]) return NO;

    if (!self.string1 && !otherPluralTestUniqueElement.string1) /* Keep going... */;
    else if ((self.string1 == nil) ^ (otherPluralTestUniqueElement.string1 == nil)) return NO; // xor
    else if (![self.string1 isEqualToString:otherPluralTestUniqueElement.string1]) return NO;

    if (!self.string2 && !otherPluralTestUniqueElement.string2) /* Keep going... */;
    else if ((self.string2 == nil) ^ (otherPluralTestUniqueElement.string2 == nil)) return NO; // xor
    else if (![self.string2 isEqualToString:otherPluralTestUniqueElement.string2]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"uniqueString"];
    [dictionary setObject:@"NSString" forKey:@"string1"];
    [dictionary setObject:@"NSString" forKey:@"string2"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_uniqueString release];
    [_string1 release];
    [_string2 release];

    [super dealloc];
}
@end
