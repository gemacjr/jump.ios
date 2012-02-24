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


#import "JRSports.h"

@implementation JRSports
@synthesize sportsId;
@synthesize sport;

- (id)init
{
    if ((self = [super init]))
    {
    }
    return self;
}

+ (id)sports
{
    return [[[JRSports alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRSports *sportsCopy =
                [[JRSports allocWithZone:zone] init];

    sportsCopy.sportsId = self.sportsId;
    sportsCopy.sport = self.sport;

    return sportsCopy;
}

+ (id)sportsObjectFromDictionary:(NSDictionary*)dictionary
{
    JRSports *sports =
        [JRSports sports];

    sports.sportsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    sports.sport = [dictionary objectForKey:@"sport"];

    return sports;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (sportsId)
        [dict setObject:[NSNumber numberWithInt:sportsId] forKey:@"id"];

    if (sport)
        [dict setObject:sport forKey:@"sport"];

    return dict;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"sportsId"])
        self.sportsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"sport"])
        self.sport = [dictionary objectForKey:@"sport"];
}

- (void)dealloc
{
    [sport release];

    [super dealloc];
}
@end
