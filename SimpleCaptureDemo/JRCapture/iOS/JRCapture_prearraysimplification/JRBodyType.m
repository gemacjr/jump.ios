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
{
    NSString *_build;
    NSString *_color;
    NSString *_eyeColor;
    NSString *_hairColor;
    NSNumber *_height;
}
@dynamic build;
@dynamic color;
@dynamic eyeColor;
@dynamic hairColor;
@dynamic height;

- (NSString *)build
{
    return _build;
}

- (void)setBuild:(NSString *)newBuild
{
    [self.dirtyPropertySet addObject:@"build"];

    if (!newBuild)
        _build = [NSNull null];
    else
        _build = [newBuild copy];
}

- (NSString *)color
{
    return _color;
}

- (void)setColor:(NSString *)newColor
{
    [self.dirtyPropertySet addObject:@"color"];

    if (!newColor)
        _color = [NSNull null];
    else
        _color = [newColor copy];
}

- (NSString *)eyeColor
{
    return _eyeColor;
}

- (void)setEyeColor:(NSString *)newEyeColor
{
    [self.dirtyPropertySet addObject:@"eyeColor"];

    if (!newEyeColor)
        _eyeColor = [NSNull null];
    else
        _eyeColor = [newEyeColor copy];
}

- (NSString *)hairColor
{
    return _hairColor;
}

- (void)setHairColor:(NSString *)newHairColor
{
    [self.dirtyPropertySet addObject:@"hairColor"];

    if (!newHairColor)
        _hairColor = [NSNull null];
    else
        _hairColor = [newHairColor copy];
}

- (NSNumber *)height
{
    return _height;
}

- (void)setHeight:(NSNumber *)newHeight
{
    [self.dirtyPropertySet addObject:@"height"];

    if (!newHeight)
        _height = [NSNull null];
    else
        _height = [newHeight copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/bodyType";
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

- (NSDictionary*)dictionaryFromBodyTypeObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.build && self.build != [NSNull null])
        [dict setObject:self.build forKey:@"build"];
    else
        [dict setObject:[NSNull null] forKey:@"build"];

    if (self.color && self.color != [NSNull null])
        [dict setObject:self.color forKey:@"color"];
    else
        [dict setObject:[NSNull null] forKey:@"color"];

    if (self.eyeColor && self.eyeColor != [NSNull null])
        [dict setObject:self.eyeColor forKey:@"eyeColor"];
    else
        [dict setObject:[NSNull null] forKey:@"eyeColor"];

    if (self.hairColor && self.hairColor != [NSNull null])
        [dict setObject:self.hairColor forKey:@"hairColor"];
    else
        [dict setObject:[NSNull null] forKey:@"hairColor"];

    if (self.height && self.height != [NSNull null])
        [dict setObject:self.height forKey:@"height"];
    else
        [dict setObject:[NSNull null] forKey:@"height"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"build"])
        _build = [dictionary objectForKey:@"build"];

    if ([dictionary objectForKey:@"color"])
        _color = [dictionary objectForKey:@"color"];

    if ([dictionary objectForKey:@"eyeColor"])
        _eyeColor = [dictionary objectForKey:@"eyeColor"];

    if ([dictionary objectForKey:@"hairColor"])
        _hairColor = [dictionary objectForKey:@"hairColor"];

    if ([dictionary objectForKey:@"height"])
        _height = [dictionary objectForKey:@"height"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    _build = [dictionary objectForKey:@"build"];
    _color = [dictionary objectForKey:@"color"];
    _eyeColor = [dictionary objectForKey:@"eyeColor"];
    _hairColor = [dictionary objectForKey:@"hairColor"];
    _height = [dictionary objectForKey:@"height"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"build"])
        [dict setObject:self.build forKey:@"build"];

    if ([self.dirtyPropertySet containsObject:@"color"])
        [dict setObject:self.color forKey:@"color"];

    if ([self.dirtyPropertySet containsObject:@"eyeColor"])
        [dict setObject:self.eyeColor forKey:@"eyeColor"];

    if ([self.dirtyPropertySet containsObject:@"hairColor"])
        [dict setObject:self.hairColor forKey:@"hairColor"];

    if ([self.dirtyPropertySet containsObject:@"height"])
        [dict setObject:self.height forKey:@"height"];

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

    [dict setObject:self.build forKey:@"build"];
    [dict setObject:self.color forKey:@"color"];
    [dict setObject:self.eyeColor forKey:@"eyeColor"];
    [dict setObject:self.hairColor forKey:@"hairColor"];
    [dict setObject:self.height forKey:@"height"];

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
    [_build release];
    [_color release];
    [_eyeColor release];
    [_hairColor release];
    [_height release];

    [super dealloc];
}
@end
