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


#import "JRLanguagesSpoken.h"

@implementation JRLanguagesSpoken
{
    NSInteger _languagesSpokenId;
    NSString *_languageSpoken;

}
@dynamic languagesSpokenId;
@dynamic languageSpoken;

- (NSInteger )languagesSpokenId
{
    return _languagesSpokenId;
}

- (void)setLanguagesSpokenId:(NSInteger )newLanguagesSpokenId
{
    [self.dirtyPropertySet addObject:@"languagesSpokenId"];

    _languagesSpokenId = newLanguagesSpokenId;

}

- (NSString *)languageSpoken
{
    return _languageSpoken;
}

- (void)setLanguageSpoken:(NSString *)newLanguageSpoken
{
    [self.dirtyPropertySet addObject:@"languageSpoken"];

    _languageSpoken = [newLanguageSpoken copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/languagesSpoken";
    }
    return self;
}

+ (id)languagesSpoken
{
    return [[[JRLanguagesSpoken alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRLanguagesSpoken *languagesSpokenCopy =
                [[JRLanguagesSpoken allocWithZone:zone] init];

    languagesSpokenCopy.languagesSpokenId = self.languagesSpokenId;
    languagesSpokenCopy.languageSpoken = self.languageSpoken;

    return languagesSpokenCopy;
}

+ (id)languagesSpokenObjectFromDictionary:(NSDictionary*)dictionary
{
    JRLanguagesSpoken *languagesSpoken =
        [JRLanguagesSpoken languagesSpoken];

    languagesSpoken.languagesSpokenId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    languagesSpoken.languageSpoken = [dictionary objectForKey:@"languageSpoken"];

    return languagesSpoken;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (self.languagesSpokenId)
        [dict setObject:[NSNumber numberWithInt:self.languagesSpokenId] forKey:@"id"];

    if (self.languageSpoken)
        [dict setObject:self.languageSpoken forKey:@"languageSpoken"];

    return dict;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"languagesSpokenId"])
        self.languagesSpokenId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"languageSpoken"])
        self.languageSpoken = [dictionary objectForKey:@"languageSpoken"];
}

- (void)dealloc
{
    [_languageSpoken release];

    [super dealloc];
}
@end
