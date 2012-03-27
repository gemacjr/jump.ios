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


#import "JRMovies.h"

@implementation JRMovies
{
    NSInteger _moviesId;
    NSString *_movie;
}
@dynamic moviesId;
@dynamic movie;

- (NSInteger)moviesId
{
    return _moviesId;
}

- (void)setMoviesId:(NSInteger)newMoviesId
{
    [self.dirtyPropertySet addObject:@"moviesId"];

    _moviesId = newMoviesId;
}

- (NSString *)movie
{
    return _movie;
}

- (void)setMovie:(NSString *)newMovie
{
    [self.dirtyPropertySet addObject:@"movie"];

    _movie = [newMovie copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/profiles/profile/movies";
    }
    return self;
}

+ (id)movies
{
    return [[[JRMovies alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRMovies *moviesCopy =
                [[JRMovies allocWithZone:zone] init];

    moviesCopy.moviesId = self.moviesId;
    moviesCopy.movie = self.movie;

    return moviesCopy;
}

+ (id)moviesObjectFromDictionary:(NSDictionary*)dictionary
{
    JRMovies *movies =
        [JRMovies movies];

    movies.moviesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    movies.movie = [dictionary objectForKey:@"movie"];

    return movies;
}

- (NSDictionary*)dictionaryFromMoviesObject
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    if (self.moviesId)
        [dict setObject:[NSNumber numberWithInt:self.moviesId] forKey:@"id"];

    if (self.movie)
        [dict setObject:self.movie forKey:@"movie"];

    return dict;
}

- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"movie"])
        self.movie = [dictionary objectForKey:@"movie"];
}

- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary
{
    self.moviesId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    self.movie = [dictionary objectForKey:@"movie"];
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"movie"])
        [dict setObject:self.movie forKey:@"movie"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo updateCaptureObject:dict
                                        withId:self.moviesId
                                        atPath:self.captureObjectPath
                                     withToken:[JRCaptureData accessToken]
                                   forDelegate:self
                                   withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:self.movie forKey:@"movie"];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, @"callerContext",
                                                     self, @"captureObject",
                                                     delegate, @"delegate", nil];

    [JRCaptureInterfaceTwo replaceCaptureObject:dict
                                         withId:self.moviesId
                                         atPath:self.captureObjectPath
                                      withToken:[JRCaptureData accessToken]
                                    forDelegate:self
                                    withContext:newContext];
}

- (void)dealloc
{
    [_movie release];

    [super dealloc];
}
@end
