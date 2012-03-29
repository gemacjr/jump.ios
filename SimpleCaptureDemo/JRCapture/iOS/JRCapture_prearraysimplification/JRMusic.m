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


#import "JRMusic.h"

@implementation JRMusic
{
    NSInteger _musicId;
    NSString *_music;
}
@dynamic musicId;
@dynamic music;

- (NSInteger)musicId
{
    return _musicId;
}

- (void)setMusicId:(NSInteger)newMusicId
{
    [self.dirtyPropertySet addObject:@"musicId"];

    _musicId = newMusicId;
}

- (NSString *)music
{
    return _music;
}

- (void)setMusic:(NSString *)newMusic
{
    [self.dirtyPropertySet addObject:@"music"];

    if (!newMusic)
        _music = [NSNull null];
    else
        _music = [newMusic copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/music";
    }
    return self;
}

+ (id)music
{
    return [[[JRMusic alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRMusic *musicCopy =
                [[JRMusic allocWithZone:zone] init];

    musicCopy.musicId = self.musicId;
    musicCopy.music = self.music;

    return musicCopy;
}

+ (id)musicObjectFromDictionary:(NSDictionary*)dictionary
{
    JRMusic *music =
        [JRMusic music];

    music.musicId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    music.music = [dictionary objectForKey:@"music"];

    return music;
}

- (NSDictionary*)dictionaryFromMusicObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.musicId)
        [dict setObject:[NSNumber numberWithInt:self.musicId] forKey:@"id"];

    if (self.music && self.music != [NSNull null])
        [dict setObject:self.music forKey:@"music"];
    else
        [dict setObject:[NSNull null] forKey:@"music"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"id"])
        _musicId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"music"])
        _music = [dictionary objectForKey:@"music"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    _musicId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    _music = [dictionary objectForKey:@"music"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"musicId"])
        [dict setObject:[NSNumber numberWithInt:self.musicId] forKey:@"id"];

    if ([self.dirtyPropertySet containsObject:@"music"])
        [dict setObject:self.music forKey:@"music"];

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

    [dict setObject:[NSNumber numberWithInt:self.musicId] forKey:@"id"];
    [dict setObject:self.music forKey:@"music"];

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
    [_music release];

    [super dealloc];
}
@end
