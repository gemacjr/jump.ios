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


#import "JRLanguages.h"

@implementation JRLanguages
{
    NSInteger _languagesId;
    NSString *_language;
}
@dynamic languagesId;
@dynamic language;

- (NSInteger)languagesId
{
    return _languagesId;
}

- (void)setLanguagesId:(NSInteger)newLanguagesId
{
    [self.dirtyPropertySet addObject:@"languagesId"];

    _languagesId = newLanguagesId;
}

- (NSString *)language
{
    return _language;
}

- (void)setLanguage:(NSString *)newLanguage
{
    [self.dirtyPropertySet addObject:@"language"];

    if (!newLanguage)
        _language = [NSNull null];
    else
        _language = [newLanguage copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/languages";
    }
    return self;
}

+ (id)languages
{
    return [[[JRLanguages alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRLanguages *languagesCopy =
                [[JRLanguages allocWithZone:zone] init];

    languagesCopy.languagesId = self.languagesId;
    languagesCopy.language = self.language;

    return languagesCopy;
}

+ (id)languagesObjectFromDictionary:(NSDictionary*)dictionary
{
    JRLanguages *languages =
        [JRLanguages languages];

    languages.languagesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    languages.language = [dictionary objectForKey:@"language"];

    return languages;
}

- (NSDictionary*)dictionaryFromLanguagesObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.languagesId)
        [dict setObject:[NSNumber numberWithInt:self.languagesId] forKey:@"id"];

    if (self.language && self.language != [NSNull null])
        [dict setObject:self.language forKey:@"language"];
    else
        [dict setObject:[NSNull null] forKey:@"language"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"id"])
        _languagesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"language"])
        _language = [dictionary objectForKey:@"language"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    _languagesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    _language = [dictionary objectForKey:@"language"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"languagesId"])
        [dict setObject:[NSNumber numberWithInt:self.languagesId] forKey:@"id"];

    if ([self.dirtyPropertySet containsObject:@"language"])
        [dict setObject:self.language forKey:@"language"];

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

    [dict setObject:[NSNumber numberWithInt:self.languagesId] forKey:@"id"];
    [dict setObject:self.language forKey:@"language"];

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
    [_language release];

    [super dealloc];
}
@end
