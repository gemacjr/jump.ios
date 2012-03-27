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


#import "JRFood.h"

@implementation JRFood
{
    NSInteger _foodId;
    NSString *_food;
}
@dynamic foodId;
@dynamic food;

- (NSInteger)foodId
{
    return _foodId;
}

- (void)setFoodId:(NSInteger)newFoodId
{
    [self.dirtyPropertySet addObject:@"foodId"];

    _foodId = newFoodId;
}

- (NSString *)food
{
    return _food;
}

- (void)setFood:(NSString *)newFood
{
    [self.dirtyPropertySet addObject:@"food"];

    _food = [newFood copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/food";
    }
    return self;
}

+ (id)food
{
    return [[[JRFood alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRFood *foodCopy =
                [[JRFood allocWithZone:zone] init];

    foodCopy.foodId = self.foodId;
    foodCopy.food = self.food;

    return foodCopy;
}

+ (id)foodObjectFromDictionary:(NSDictionary*)dictionary
{
    JRFood *food =
        [JRFood food];

    food.foodId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    food.food = [dictionary objectForKey:@"food"];

    return food;
}

- (NSDictionary*)dictionaryFromFoodObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.foodId)
        [dict setObject:[NSNumber numberWithInt:self.foodId] forKey:@"id"];

    if (self.food)
        [dict setObject:self.food forKey:@"food"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"food"])
        self.food = [dictionary objectForKey:@"food"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    self.foodId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    self.food = [dictionary objectForKey:@"food"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"food"])
        [dict setObject:self.food forKey:@"food"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo updateCaptureObject:dict
                                        withId:self.foodId
                                        atPath:self.captureObjectPath
                                     withToken:[JRCaptureData accessToken]
                                   forDelegate:super
                                   withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:self.food forKey:@"food"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo replaceCaptureObject:dict
                                         withId:self.foodId
                                         atPath:self.captureObjectPath
                                      withToken:[JRCaptureData accessToken]
                                    forDelegate:super
                                    withContext:newContext];
}

- (void)dealloc
{
    [_food release];

    [super dealloc];
}
@end
