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

@implementation JRStatuses
{
    NSInteger _statusesId;
    NSString *_status;
    NSDate *_statusCreated;
}
@dynamic statusesId;
@dynamic status;
@dynamic statusCreated;

- (NSInteger)statusesId
{
    return _statusesId;
}

- (void)setStatusesId:(NSInteger)newStatusesId
{
    [self.dirtyPropertySet addObject:@"statusesId"];
    _statusesId = newStatusesId;
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

- (NSDate *)statusCreated
{
    return _statusCreated;
}

- (void)setStatusCreated:(NSDate *)newStatusCreated
{
    [self.dirtyPropertySet addObject:@"statusCreated"];
    _statusCreated = [newStatusCreated copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/statuses";
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

    statusesCopy.statusesId = self.statusesId;
    statusesCopy.status = self.status;
    statusesCopy.statusCreated = self.statusCreated;

    [statusesCopy.dirtyPropertySet removeAllObjects];
    [statusesCopy.dirtyPropertySet setSet:self.dirtyPropertySet];

    return statusesCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:[NSNumber numberWithInt:self.statusesId]
             forKey:@"id"];
    [dict setObject:(self.status ? self.status : [NSNull null])
             forKey:@"status"];
    [dict setObject:(self.statusCreated ? [self.statusCreated stringFromISO8601DateTime] : [NSNull null])
             forKey:@"statusCreated"];

    return dict;
}

+ (id)statusesObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    JRStatuses *statuses = [JRStatuses statuses];
    statuses.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"statuses", statuses.statusesId];

    statuses.statusesId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [(NSNumber*)[dictionary objectForKey:@"id"] intValue] : 0;

    statuses.status =
        [dictionary objectForKey:@"status"] != [NSNull null] ? 
        [dictionary objectForKey:@"status"] : nil;

    statuses.statusCreated =
        [dictionary objectForKey:@"statusCreated"] != [NSNull null] ? 
        [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"statusCreated"]] : nil;

    [statuses.dirtyPropertySet removeAllObjects];
    
    return statuses;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"statuses", self.statusesId];

    if ([dictionary objectForKey:@"id"])
        _statusesId = [dictionary objectForKey:@"id"] != [NSNull null] ? 
            [(NSNumber*)[dictionary objectForKey:@"id"] intValue] : 0;

    if ([dictionary objectForKey:@"status"])
        _status = [dictionary objectForKey:@"status"] != [NSNull null] ? 
            [dictionary objectForKey:@"status"] : nil;

    if ([dictionary objectForKey:@"statusCreated"])
        _statusCreated = [dictionary objectForKey:@"statusCreated"] != [NSNull null] ? 
            [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"statusCreated"]] : nil;
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"statuses", self.statusesId];

    _statusesId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [(NSNumber*)[dictionary objectForKey:@"id"] intValue] : 0;

    _status =
        [dictionary objectForKey:@"status"] != [NSNull null] ? 
        [dictionary objectForKey:@"status"] : nil;

    _statusCreated =
        [dictionary objectForKey:@"statusCreated"] != [NSNull null] ? 
        [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"statusCreated"]] : nil;
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

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:[self toUpdateDictionary]
                                     withId:self.statusesId
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.status ? self.status : [NSNull null]) forKey:@"status"];
    [dict setObject:(self.statusCreated ? [self.statusCreated stringFromISO8601DateTime] : [NSNull null]) forKey:@"statusCreated"];

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
                                      withId:self.statusesId
                                      atPath:self.captureObjectPath
                                   withToken:[JRCaptureData accessToken]
                                 forDelegate:self
                                 withContext:newContext];
}

- (void)dealloc
{
    [_status release];
    [_statusCreated release];

    [super dealloc];
}
@end
