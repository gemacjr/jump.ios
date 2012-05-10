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


#import "JRStatuses.h"

@interface JRStatuses ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRStatuses
{
    JRObjectId *_statusesId;
    NSString *_status;
    JRDateTime *_statusCreated;
}
@dynamic statusesId;
@dynamic status;
@dynamic statusCreated;
@synthesize canBeUpdatedOrReplaced;

- (JRObjectId *)statusesId
{
    return _statusesId;
}

- (void)setStatusesId:(JRObjectId *)newStatusesId
{
    [self.dirtyPropertySet addObject:@"statusesId"];
    _statusesId = [newStatusesId copy];
}

- (NSString *)status
{
    return _status;
}

- (void)setStatus:(NSString *)newStatus
{
    [self.dirtyPropertySet addObject:@"status"];
    _status = [newStatus copy];
}

- (JRDateTime *)statusCreated
{
    return _statusCreated;
}

- (void)setStatusCreated:(JRDateTime *)newStatusCreated
{
    [self.dirtyPropertySet addObject:@"statusCreated"];
    _statusCreated = [newStatusCreated copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"";
        self.canBeUpdatedOrReplaced = NO;
    }
    return self;
}

+ (id)statuses
{
    return [[[JRStatuses alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRStatuses *statusesCopy =
                [[JRStatuses allocWithZone:zone] init];

    statusesCopy.captureObjectPath = self.captureObjectPath;

    statusesCopy.statusesId = self.statusesId;
    statusesCopy.status = self.status;
    statusesCopy.statusCreated = self.statusCreated;

    statusesCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    [statusesCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [statusesCopy.dirtyArraySet setSet:self.dirtyPropertySet];

    return statusesCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.statusesId ? [NSNumber numberWithInteger:[self.statusesId integerValue]] : [NSNull null])
             forKey:@"id"];
    [dict setObject:(self.status ? self.status : [NSNull null])
             forKey:@"status"];
    [dict setObject:(self.statusCreated ? [self.statusCreated stringFromISO8601DateTime] : [NSNull null])
             forKey:@"statusCreated"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)statusesObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRStatuses *statuses = [JRStatuses statuses];
    statuses.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"statuses", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    statuses.statusesId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    statuses.status =
        [dictionary objectForKey:@"status"] != [NSNull null] ? 
        [dictionary objectForKey:@"status"] : nil;

    statuses.statusCreated =
        [dictionary objectForKey:@"statusCreated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"statusCreated"]] : nil;

    [statuses.dirtyPropertySet removeAllObjects];
    [statuses.dirtyArraySet removeAllObjects];
    
    return statuses;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"statuses", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"id"])
        self.statusesId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
            [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    if ([dictionary objectForKey:@"status"])
        self.status = [dictionary objectForKey:@"status"] != [NSNull null] ? 
            [dictionary objectForKey:@"status"] : nil;

    if ([dictionary objectForKey:@"statusCreated"])
        self.statusCreated = [dictionary objectForKey:@"statusCreated"] != [NSNull null] ? 
            [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"statusCreated"]] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"statuses", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.statusesId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.status =
        [dictionary objectForKey:@"status"] != [NSNull null] ? 
        [dictionary objectForKey:@"status"] : nil;

    self.statusCreated =
        [dictionary objectForKey:@"statusCreated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"statusCreated"]] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"status"])
        [dict setObject:(self.status ? self.status : [NSNull null]) forKey:@"status"];

    if ([self.dirtyPropertySet containsObject:@"statusCreated"])
        [dict setObject:(self.statusCreated ? [self.statusCreated stringFromISO8601DateTime] : [NSNull null]) forKey:@"statusCreated"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.status ? self.status : [NSNull null]) forKey:@"status"];
    [dict setObject:(self.statusCreated ? [self.statusCreated stringFromISO8601DateTime] : [NSNull null]) forKey:@"statusCreated"];

    return dict;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"JRObjectId" forKey:@"statusesId"];
    [dict setObject:@"NSString" forKey:@"status"];
    [dict setObject:@"JRDateTime" forKey:@"statusCreated"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_statusesId release];
    [_status release];
    [_statusCreated release];

    [super dealloc];
}
@end
