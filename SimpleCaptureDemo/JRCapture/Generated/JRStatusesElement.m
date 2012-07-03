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
#import "JRStatusesElement.h"

@interface JRStatusesElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRStatusesElement
{
    JRObjectId *_statusesElementId;
    NSString *_status;
    JRDateTime *_statusCreated;
}
@synthesize canBeUpdatedOrReplaced;

- (JRObjectId *)statusesElementId
{
    return _statusesElementId;
}

- (void)setStatusesElementId:(JRObjectId *)newStatusesElementId
{
    [self.dirtyPropertySet addObject:@"statusesElementId"];

    [_statusesElementId autorelease];
    _statusesElementId = [newStatusesElementId copy];
}

- (NSString *)status
{
    return _status;
}

- (void)setStatus:(NSString *)newStatus
{
    [self.dirtyPropertySet addObject:@"status"];

    [_status autorelease];
    _status = [newStatus copy];
}

- (JRDateTime *)statusCreated
{
    return _statusCreated;
}

- (void)setStatusCreated:(JRDateTime *)newStatusCreated
{
    [self.dirtyPropertySet addObject:@"statusCreated"];

    [_statusCreated autorelease];
    _statusCreated = [newStatusCreated copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;


        [self.dirtyPropertySet setSet:[NSMutableSet setWithObjects:@"statusesElementId", @"status", @"statusCreated", nil]];
    }
    return self;
}

+ (id)statusesElement
{
    return [[[JRStatusesElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRStatusesElement *statusesElementCopy = (JRStatusesElement *)[super copyWithZone:zone];

    statusesElementCopy.statusesElementId = self.statusesElementId;
    statusesElementCopy.status = self.status;
    statusesElementCopy.statusCreated = self.statusCreated;

    return statusesElementCopy;
}

- (NSDictionary*)toDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.statusesElementId ? [NSNumber numberWithInteger:[self.statusesElementId integerValue]] : [NSNull null])
                   forKey:@"id"];
    [dictionary setObject:(self.status ? self.status : [NSNull null])
                   forKey:@"status"];
    [dictionary setObject:(self.statusCreated ? [self.statusCreated stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"statusCreated"];

    if (forEncoder)
    {
        [dictionary setObject:([self.dirtyPropertySet allObjects] ? [self.dirtyPropertySet allObjects] : [NSArray array])
                       forKey:@"dirtyPropertiesSet"];
        [dictionary setObject:(self.captureObjectPath ? self.captureObjectPath : [NSNull null])
                       forKey:@"captureObjectPath"];
        [dictionary setObject:[NSNumber numberWithBool:self.canBeUpdatedOrReplaced] 
                       forKey:@"canBeUpdatedOrReplaced"];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (id)statusesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRStatusesElement *statusesElement = [JRStatusesElement statusesElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        statusesElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        statusesElement.canBeUpdatedOrReplaced = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOrReplaced"] boolValue];
    }
    else
    {
        statusesElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"statuses", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        // TODO: Is this safe to assume?
        statusesElement.canBeUpdatedOrReplaced = YES;
    }

    statusesElement.statusesElementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    statusesElement.status =
        [dictionary objectForKey:@"status"] != [NSNull null] ? 
        [dictionary objectForKey:@"status"] : nil;

    statusesElement.statusCreated =
        [dictionary objectForKey:@"statusCreated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"statusCreated"]] : nil;

    if (fromDecoder)
        [statusesElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [statusesElement.dirtyPropertySet removeAllObjects];
    
    return statusesElement;
}

+ (id)statusesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRStatusesElement statusesElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"statuses", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"id"])
        self.statusesElementId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
            [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    if ([dictionary objectForKey:@"status"])
        self.status = [dictionary objectForKey:@"status"] != [NSNull null] ? 
            [dictionary objectForKey:@"status"] : nil;

    if ([dictionary objectForKey:@"statusCreated"])
        self.statusCreated = [dictionary objectForKey:@"statusCreated"] != [NSNull null] ? 
            [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"statusCreated"]] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"statuses", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.statusesElementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.status =
        [dictionary objectForKey:@"status"] != [NSNull null] ? 
        [dictionary objectForKey:@"status"] : nil;

    self.statusCreated =
        [dictionary objectForKey:@"statusCreated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"statusCreated"]] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"status"])
        [dictionary setObject:(self.status ? self.status : [NSNull null]) forKey:@"status"];

    if ([self.dirtyPropertySet containsObject:@"statusCreated"])
        [dictionary setObject:(self.statusCreated ? [self.statusCreated stringFromISO8601DateTime] : [NSNull null]) forKey:@"statusCreated"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)toReplaceDictionaryIncludingArrays:(BOOL)includingArrays
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.status ? self.status : [NSNull null]) forKey:@"status"];
    [dictionary setObject:(self.statusCreated ? [self.statusCreated stringFromISO8601DateTime] : [NSNull null]) forKey:@"statusCreated"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToStatusesElement:(JRStatusesElement *)otherStatusesElement
{
    if (!self.status && !otherStatusesElement.status) /* Keep going... */;
    else if ((self.status == nil) ^ (otherStatusesElement.status == nil)) return NO; // xor
    else if (![self.status isEqualToString:otherStatusesElement.status]) return NO;

    if (!self.statusCreated && !otherStatusesElement.statusCreated) /* Keep going... */;
    else if ((self.statusCreated == nil) ^ (otherStatusesElement.statusCreated == nil)) return NO; // xor
    else if (![self.statusCreated isEqualToDate:otherStatusesElement.statusCreated]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"JRObjectId" forKey:@"statusesElementId"];
    [dictionary setObject:@"NSString" forKey:@"status"];
    [dictionary setObject:@"JRDateTime" forKey:@"statusCreated"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)dealloc
{
    [_statusesElementId release];
    [_status release];
    [_statusCreated release];

    [super dealloc];
}
@end
