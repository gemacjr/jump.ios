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


#import "JRBodyType.h"

@implementation JRBodyType
@synthesize build;
@synthesize color;
@synthesize eyeColor;
@synthesize hairColor;
@synthesize height;

- (id)init
{
    if ((self = [super init]))
    {
    }
    return self;
}

+ (id)bodyType
{
    return [[[JRBodyType alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRBodyType *bodyTypeCopy =
                [[JRBodyType allocWithZone:zone] init];

    bodyTypeCopy.build = self.build;
    bodyTypeCopy.color = self.color;
    bodyTypeCopy.eyeColor = self.eyeColor;
    bodyTypeCopy.hairColor = self.hairColor;
    bodyTypeCopy.height = self.height;

    return bodyTypeCopy;
}

+ (id)bodyTypeObjectFromDictionary:(NSDictionary*)dictionary
{
    JRBodyType *bodyType =
        [JRBodyType bodyType];

    bodyType.build = [dictionary objectForKey:@"build"];
    bodyType.color = [dictionary objectForKey:@"color"];
    bodyType.eyeColor = [dictionary objectForKey:@"eyeColor"];
    bodyType.hairColor = [dictionary objectForKey:@"hairColor"];
    bodyType.height = [dictionary objectForKey:@"height"];

    return bodyType;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (build)
        [dict setObject:build forKey:@"build"];

    if (color)
        [dict setObject:color forKey:@"color"];

    if (eyeColor)
        [dict setObject:eyeColor forKey:@"eyeColor"];

    if (hairColor)
        [dict setObject:hairColor forKey:@"hairColor"];

    if (height)
        [dict setObject:height forKey:@"height"];

    return dict;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"build"])
        self.build = [dictionary objectForKey:@"build"];

    if ([dictionary objectForKey:@"color"])
        self.color = [dictionary objectForKey:@"color"];

    if ([dictionary objectForKey:@"eyeColor"])
        self.eyeColor = [dictionary objectForKey:@"eyeColor"];

    if ([dictionary objectForKey:@"hairColor"])
        self.hairColor = [dictionary objectForKey:@"hairColor"];

    if ([dictionary objectForKey:@"height"])
        self.height = [dictionary objectForKey:@"height"];
}

- (void)dealloc
{
    [build release];
    [color release];
    [eyeColor release];
    [hairColor release];
    [height release];

    [super dealloc];
}
@end
