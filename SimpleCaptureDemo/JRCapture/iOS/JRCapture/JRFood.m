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

- (NSInteger )foodId
{
    return _foodId;
}

- (void)setFoodId:(NSInteger )newFoodId
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

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (self.foodId)
        [dict setObject:[NSNumber numberWithInt:self.foodId] forKey:@"id"];

    if (self.food)
        [dict setObject:self.food forKey:@"food"];

    return dict;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"foodId"])
        self.foodId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"food"])
        self.food = [dictionary objectForKey:@"food"];
}

- (void)dealloc
{
    [_food release];

    [super dealloc];
}
@end
