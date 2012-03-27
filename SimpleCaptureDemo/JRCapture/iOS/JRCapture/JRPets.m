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


#import "JRPets.h"

@implementation JRPets
{
    NSInteger _petsId;
    NSString *_value;

}
@dynamic petsId;
@dynamic value;

- (NSInteger )petsId
{
    return _petsId;
}

- (void)setPetsId:(NSInteger )newPetsId
{
    [self.dirtyPropertySet addObject:@"petsId"];

    _petsId = newPetsId;

}

- (NSString *)value
{
    return _value;
}

- (void)setValue:(NSString *)newValue
{
    [self.dirtyPropertySet addObject:@"value"];

    _value = [newValue copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/pets";
    }
    return self;
}

+ (id)pets
{
    return [[[JRPets alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPets *petsCopy =
                [[JRPets allocWithZone:zone] init];

    petsCopy.petsId = self.petsId;
    petsCopy.value = self.value;

    return petsCopy;
}

+ (id)petsObjectFromDictionary:(NSDictionary*)dictionary
{
    JRPets *pets =
        [JRPets pets];

    pets.petsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    pets.value = [dictionary objectForKey:@"value"];

    return pets;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (self.petsId)
        [dict setObject:[NSNumber numberWithInt:self.petsId] forKey:@"id"];

    if (self.value)
        [dict setObject:self.value forKey:@"value"];

    return dict;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"petsId"])
        self.petsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"value"])
        self.value = [dictionary objectForKey:@"value"];
}

- (void)dealloc
{
    [_value release];

    [super dealloc];
}
@end
