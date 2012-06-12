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


#import "JRSimpleStringPluralOneElement.h"

@interface JRSimpleStringPluralOneElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRSimpleStringPluralOneElement
{
    NSString *_simpleTypeOne;
}
@dynamic simpleTypeOne;
@synthesize canBeUpdatedOrReplaced;

- (NSString *)simpleTypeOne
{
    return _simpleTypeOne;
}

- (void)setSimpleTypeOne:(NSString *)newSimpleTypeOne
{
    [self.dirtyPropertySet addObject:@"simpleTypeOne"];
    _simpleTypeOne = [newSimpleTypeOne copy];
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

+ (id)simpleStringPluralOneElement
{
    return [[[JRSimpleStringPluralOneElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRSimpleStringPluralOneElement *simpleStringPluralOneElementCopy =
                [[JRSimpleStringPluralOneElement allocWithZone:zone] init];

    simpleStringPluralOneElementCopy.captureObjectPath = self.captureObjectPath;

    simpleStringPluralOneElementCopy.simpleTypeOne = self.simpleTypeOne;
    // TODO: Necessary??
    simpleStringPluralOneElementCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    // TODO: Necessary??
    [simpleStringPluralOneElementCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [simpleStringPluralOneElementCopy.dirtyArraySet setSet:self.dirtyArraySet];

    return simpleStringPluralOneElementCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.simpleTypeOne ? self.simpleTypeOne : [NSNull null])
             forKey:@"simpleTypeOne"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)simpleStringPluralOneElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRSimpleStringPluralOneElement *simpleStringPluralOneElement = [JRSimpleStringPluralOneElement simpleStringPluralOneElement];

    simpleStringPluralOneElement.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"simpleStringPluralOne", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
// TODO: Is this safe to assume?
    simpleStringPluralOneElement.canBeUpdatedOrReplaced = YES;

    simpleStringPluralOneElement.simpleTypeOne =
        [dictionary objectForKey:@"simpleTypeOne"] != [NSNull null] ? 
        [dictionary objectForKey:@"simpleTypeOne"] : nil;

    [simpleStringPluralOneElement.dirtyPropertySet removeAllObjects];
    [simpleStringPluralOneElement.dirtyArraySet removeAllObjects];
    
    return simpleStringPluralOneElement;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"simpleStringPluralOne", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"simpleTypeOne"])
        self.simpleTypeOne = [dictionary objectForKey:@"simpleTypeOne"] != [NSNull null] ? 
            [dictionary objectForKey:@"simpleTypeOne"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"simpleStringPluralOne", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.simpleTypeOne =
        [dictionary objectForKey:@"simpleTypeOne"] != [NSNull null] ? 
        [dictionary objectForKey:@"simpleTypeOne"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"simpleTypeOne"])
        [dict setObject:(self.simpleTypeOne ? self.simpleTypeOne : [NSNull null]) forKey:@"simpleTypeOne"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.simpleTypeOne ? self.simpleTypeOne : [NSNull null]) forKey:@"simpleTypeOne"];

    return dict;
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"simpleTypeOne"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_simpleTypeOne release];

    [super dealloc];
}
@end
