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
#import "JRImsElement.h"

@interface JRImsElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRImsElement
{
    JRObjectId *_imsElementId;
    JRBoolean *_primary;
    NSString *_type;
    NSString *_value;
}
@synthesize canBeUpdatedOrReplaced;

- (JRObjectId *)imsElementId
{
    return _imsElementId;
}

- (void)setImsElementId:(JRObjectId *)newImsElementId
{
    [self.dirtyPropertySet addObject:@"imsElementId"];

    [_imsElementId autorelease];
    _imsElementId = [newImsElementId copy];
}

- (JRBoolean *)primary
{
    return _primary;
}

- (void)setPrimary:(JRBoolean *)newPrimary
{
    [self.dirtyPropertySet addObject:@"primary"];

    [_primary autorelease];
    _primary = [newPrimary copy];
}

- (BOOL)getPrimaryBoolValue
{
    return [_primary boolValue];
}

- (void)setPrimaryWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"primary"];
    _primary = [NSNumber numberWithBool:boolVal];
}

- (NSString *)type
{
    return _type;
}

- (void)setType:(NSString *)newType
{
    [self.dirtyPropertySet addObject:@"type"];

    [_type autorelease];
    _type = [newType copy];
}

- (NSString *)value
{
    return _value;
}

- (void)setValue:(NSString *)newValue
{
    [self.dirtyPropertySet addObject:@"value"];

    [_value autorelease];
    _value = [newValue copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;


        [self.dirtyPropertySet setSet:[NSMutableSet setWithObjects:@"imsElementId", @"primary", @"type", @"value", nil]];
    }
    return self;
}

+ (id)imsElement
{
    return [[[JRImsElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRImsElement *imsElementCopy = (JRImsElement *)[super copyWithZone:zone];

    imsElementCopy.imsElementId = self.imsElementId;
    imsElementCopy.primary = self.primary;
    imsElementCopy.type = self.type;
    imsElementCopy.value = self.value;

    return imsElementCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.imsElementId ? [NSNumber numberWithInteger:[self.imsElementId integerValue]] : [NSNull null])
                   forKey:@"id"];
    [dictionary setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null])
                   forKey:@"primary"];
    [dictionary setObject:(self.type ? self.type : [NSNull null])
                   forKey:@"type"];
    [dictionary setObject:(self.value ? self.value : [NSNull null])
                   forKey:@"value"];

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

+ (id)imsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRImsElement *imsElement = [JRImsElement imsElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        imsElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        imsElement.canBeUpdatedOrReplaced = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOrReplaced"] boolValue];
    }
    else
    {
        imsElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"ims", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        // TODO: Is this safe to assume?
        imsElement.canBeUpdatedOrReplaced = YES;
    }

    imsElement.imsElementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    imsElement.primary =
        [dictionary objectForKey:@"primary"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"primary"] boolValue]] : nil;

    imsElement.type =
        [dictionary objectForKey:@"type"] != [NSNull null] ? 
        [dictionary objectForKey:@"type"] : nil;

    imsElement.value =
        [dictionary objectForKey:@"value"] != [NSNull null] ? 
        [dictionary objectForKey:@"value"] : nil;

    if (fromDecoder)
        [imsElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [imsElement.dirtyPropertySet removeAllObjects];
    
    return imsElement;
}

+ (id)imsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRImsElement imsElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"ims", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"id"])
        self.imsElementId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
            [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    if ([dictionary objectForKey:@"primary"])
        self.primary = [dictionary objectForKey:@"primary"] != [NSNull null] ? 
            [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"primary"] boolValue]] : nil;

    if ([dictionary objectForKey:@"type"])
        self.type = [dictionary objectForKey:@"type"] != [NSNull null] ? 
            [dictionary objectForKey:@"type"] : nil;

    if ([dictionary objectForKey:@"value"])
        self.value = [dictionary objectForKey:@"value"] != [NSNull null] ? 
            [dictionary objectForKey:@"value"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"ims", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.imsElementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.primary =
        [dictionary objectForKey:@"primary"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"primary"] boolValue]] : nil;

    self.type =
        [dictionary objectForKey:@"type"] != [NSNull null] ? 
        [dictionary objectForKey:@"type"] : nil;

    self.value =
        [dictionary objectForKey:@"value"] != [NSNull null] ? 
        [dictionary objectForKey:@"value"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"primary"])
        [dictionary setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null]) forKey:@"primary"];

    if ([self.dirtyPropertySet containsObject:@"type"])
        [dictionary setObject:(self.type ? self.type : [NSNull null]) forKey:@"type"];

    if ([self.dirtyPropertySet containsObject:@"value"])
        [dictionary setObject:(self.value ? self.value : [NSNull null]) forKey:@"value"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionaryIncludingArrays:(BOOL)includingArrays
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null]) forKey:@"primary"];
    [dictionary setObject:(self.type ? self.type : [NSNull null]) forKey:@"type"];
    [dictionary setObject:(self.value ? self.value : [NSNull null]) forKey:@"value"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToImsElement:(JRImsElement *)otherImsElement
{
    if (!self.primary && !otherImsElement.primary) /* Keep going... */;
    else if ((self.primary == nil) ^ (otherImsElement.primary == nil)) return NO; // xor
    else if (![self.primary isEqualToNumber:otherImsElement.primary]) return NO;

    if (!self.type && !otherImsElement.type) /* Keep going... */;
    else if ((self.type == nil) ^ (otherImsElement.type == nil)) return NO; // xor
    else if (![self.type isEqualToString:otherImsElement.type]) return NO;

    if (!self.value && !otherImsElement.value) /* Keep going... */;
    else if ((self.value == nil) ^ (otherImsElement.value == nil)) return NO; // xor
    else if (![self.value isEqualToString:otherImsElement.value]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"JRObjectId" forKey:@"imsElementId"];
    [dictionary setObject:@"JRBoolean" forKey:@"primary"];
    [dictionary setObject:@"NSString" forKey:@"type"];
    [dictionary setObject:@"NSString" forKey:@"value"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_imsElementId release];
    [_primary release];
    [_type release];
    [_value release];

    [super dealloc];
}
@end
