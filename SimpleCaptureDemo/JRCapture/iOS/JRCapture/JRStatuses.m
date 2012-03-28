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

    if (!newStatus)
        _status = [NSNull null];
    else
        _status = [newStatus copy];
}

- (NSDate *)statusCreated
{
    return _statusCreated;
}

- (void)setStatusCreated:(NSDate *)newStatusCreated
{
    [self.dirtyPropertySet addObject:@"statusCreated"];

    if (!newStatusCreated)
        _statusCreated = [NSNull null];
    else
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
{
    JRStatuses *statusesCopy =
                [[JRStatuses allocWithZone:zone] init];

    statusesCopy.statusesId = self.statusesId;
    statusesCopy.status = self.status;
    statusesCopy.statusCreated = self.statusCreated;

    return statusesCopy;
}

+ (id)statusesObjectFromDictionary:(NSDictionary*)dictionary
{
    JRStatuses *statuses =
        [JRStatuses statuses];

    statuses.statusesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    statuses.status = [dictionary objectForKey:@"status"];
    statuses.statusCreated = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"statusCreated"]];

    return statuses;
}

- (NSDictionary*)dictionaryFromStatusesObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.statusesId)
        [dict setObject:[NSNumber numberWithInt:self.statusesId] forKey:@"id"];

    if (self.status && self.status != [NSNull null])
        [dict setObject:self.status forKey:@"status"];
    else
        [dict setObject:[NSNull null] forKey:@"status"];

    if (self.statusCreated && self.statusCreated != [NSNull null])
        [dict setObject:[self.statusCreated stringFromISO8601DateTime] forKey:@"statusCreated"];
    else
        [dict setObject:[NSNull null] forKey:@"statusCreated"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"id"])
        _statusesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"status"])
        _status = [dictionary objectForKey:@"status"];

    if ([dictionary objectForKey:@"statusCreated"])
        _statusCreated = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"statusCreated"]];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    _statusesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    _status = [dictionary objectForKey:@"status"];
    _statusCreated = [NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:@"statusCreated"]];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"statusesId"])
        [dict setObject:[NSNumber numberWithInt:self.statusesId] forKey:@"id"];

    if ([self.dirtyPropertySet containsObject:@"status"])
        [dict setObject:self.status forKey:@"status"];

    if ([self.dirtyPropertySet containsObject:@"statusCreated"])
        [dict setObject:[self.statusCreated stringFromISO8601DateTime] forKey:@"statusCreated"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:dict
                                     withId:0
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:[NSNumber numberWithInt:self.statusesId] forKey:@"id"];
    [dict setObject:self.status forKey:@"status"];
    [dict setObject:[self.statusCreated stringFromISO8601DateTime] forKey:@"statusCreated"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:dict
                                      withId:0
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
