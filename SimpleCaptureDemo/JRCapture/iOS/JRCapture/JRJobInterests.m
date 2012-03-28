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


#import "JRJobInterests.h"

@implementation JRJobInterests
{
    NSInteger _jobInterestsId;
    NSString *_jobInterest;
}
@dynamic jobInterestsId;
@dynamic jobInterest;

- (NSInteger)jobInterestsId
{
    return _jobInterestsId;
}

- (void)setJobInterestsId:(NSInteger)newJobInterestsId
{
    [self.dirtyPropertySet addObject:@"jobInterestsId"];

    _jobInterestsId = newJobInterestsId;
}

- (NSString *)jobInterest
{
    return _jobInterest;
}

- (void)setJobInterest:(NSString *)newJobInterest
{
    [self.dirtyPropertySet addObject:@"jobInterest"];

    _jobInterest = [newJobInterest copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/jobInterests";
    }
    return self;
}

+ (id)jobInterests
{
    return [[[JRJobInterests alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRJobInterests *jobInterestsCopy =
                [[JRJobInterests allocWithZone:zone] init];

    jobInterestsCopy.jobInterestsId = self.jobInterestsId;
    jobInterestsCopy.jobInterest = self.jobInterest;

    return jobInterestsCopy;
}

+ (id)jobInterestsObjectFromDictionary:(NSDictionary*)dictionary
{
    JRJobInterests *jobInterests =
        [JRJobInterests jobInterests];

    jobInterests.jobInterestsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    jobInterests.jobInterest = [dictionary objectForKey:@"jobInterest"];

    return jobInterests;
}

- (NSDictionary*)dictionaryFromJobInterestsObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.jobInterestsId)
        [dict setObject:[NSNumber numberWithInt:self.jobInterestsId] forKey:@"id"];

    if (self.jobInterest)
        [dict setObject:self.jobInterest forKey:@"jobInterest"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"jobInterest"])
        self.jobInterest = [dictionary objectForKey:@"jobInterest"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    self.jobInterestsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    self.jobInterest = [dictionary objectForKey:@"jobInterest"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"jobInterest"])
        [dict setObject:self.jobInterest forKey:@"jobInterest"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:dict
                                     withId:self.jobInterestsId
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:self.jobInterest forKey:@"jobInterest"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:dict
                                      withId:self.jobInterestsId
                                      atPath:self.captureObjectPath
                                   withToken:[JRCaptureData accessToken]
                                 forDelegate:self
                                 withContext:newContext];
}

- (void)dealloc
{
    [_jobInterest release];

    [super dealloc];
}
@end
