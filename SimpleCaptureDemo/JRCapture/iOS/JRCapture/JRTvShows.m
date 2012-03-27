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


#import "JRTvShows.h"

@implementation JRTvShows
{
    NSInteger _tvShowsId;
    NSString *_tvShow;

}
@dynamic tvShowsId;
@dynamic tvShow;

- (NSInteger )tvShowsId
{
    return _tvShowsId;
}

- (void)setTvShowsId:(NSInteger )newTvShowsId
{
    [self.dirtyPropertySet addObject:@"tvShowsId"];

    _tvShowsId = newTvShowsId;

}

- (NSString *)tvShow
{
    return _tvShow;
}

- (void)setTvShow:(NSString *)newTvShow
{
    [self.dirtyPropertySet addObject:@"tvShow"];

    _tvShow = [newTvShow copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/tvShows";
    }
    return self;
}

+ (id)tvShows
{
    return [[[JRTvShows alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRTvShows *tvShowsCopy =
                [[JRTvShows allocWithZone:zone] init];

    tvShowsCopy.tvShowsId = self.tvShowsId;
    tvShowsCopy.tvShow = self.tvShow;

    return tvShowsCopy;
}

+ (id)tvShowsObjectFromDictionary:(NSDictionary*)dictionary
{
    JRTvShows *tvShows =
        [JRTvShows tvShows];

    tvShows.tvShowsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    tvShows.tvShow = [dictionary objectForKey:@"tvShow"];

    return tvShows;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (self.tvShowsId)
        [dict setObject:[NSNumber numberWithInt:self.tvShowsId] forKey:@"id"];

    if (self.tvShow)
        [dict setObject:self.tvShow forKey:@"tvShow"];

    return dict;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"tvShowsId"])
        self.tvShowsId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"tvShow"])
        self.tvShow = [dictionary objectForKey:@"tvShow"];
}

- (void)dealloc
{
    [_tvShow release];

    [super dealloc];
}
@end
