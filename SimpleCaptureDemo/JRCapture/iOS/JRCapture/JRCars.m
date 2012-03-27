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


#import "JRCars.h"

@implementation JRCars
{
    NSInteger _carsId;
    NSString *_car;
}
@dynamic carsId;
@dynamic car;

- (NSInteger)carsId
{
    return _carsId;
}

- (void)setCarsId:(NSInteger)newCarsId
{
    [self.dirtyPropertySet addObject:@"carsId"];

    _carsId = newCarsId;
}

- (NSString *)car
{
    return _car;
}

- (void)setCar:(NSString *)newCar
{
    [self.dirtyPropertySet addObject:@"car"];

    _car = [newCar copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/cars";
    }
    return self;
}

+ (id)cars
{
    return [[[JRCars alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRCars *carsCopy =
                [[JRCars allocWithZone:zone] init];

    carsCopy.carsId = self.carsId;
    carsCopy.car = self.car;

    return carsCopy;
}

+ (id)carsObjectFromDictionary:(NSDictionary*)dictionary
{
    JRCars *cars =
        [JRCars cars];

    cars.carsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    cars.car = [dictionary objectForKey:@"car"];

    return cars;
}

- (NSDictionary*)dictionaryFromCarsObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.carsId)
        [dict setObject:[NSNumber numberWithInt:self.carsId] forKey:@"id"];

    if (self.car)
        [dict setObject:self.car forKey:@"car"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"car"])
        self.car = [dictionary objectForKey:@"car"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    self.carsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    self.car = [dictionary objectForKey:@"car"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"car"])
        [dict setObject:self.car forKey:@"car"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo updateCaptureObject:dict
                                        withId:self.carsId
                                        atPath:self.captureObjectPath
                                     withToken:[JRCaptureData accessToken]
                                   forDelegate:super
                                   withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:self.car forKey:@"car"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo replaceCaptureObject:dict
                                         withId:self.carsId
                                         atPath:self.captureObjectPath
                                      withToken:[JRCaptureData accessToken]
                                    forDelegate:super
                                    withContext:newContext];
}

- (void)dealloc
{
    [_car release];

    [super dealloc];
}
@end
