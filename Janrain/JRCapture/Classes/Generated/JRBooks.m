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


#import "JRBooks.h"

@implementation JRBooks
@synthesize booksId;
@synthesize book;

- (id)init
{
    if ((self = [super init]))
    {
    }
    return self;
}

+ (id)books
{
    return [[[JRBooks alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRBooks *booksCopy =
                [[JRBooks allocWithZone:zone] init];

    booksCopy.booksId = self.booksId;
    booksCopy.book = self.book;

    return booksCopy;
}

+ (id)booksObjectFromDictionary:(NSDictionary*)dictionary
{
    JRBooks *books =
        [JRBooks books];

    books.booksId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    books.book = [dictionary objectForKey:@"book"];

    return books;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (booksId)
        [dict setObject:[NSNumber numberWithInt:booksId] forKey:@"id"];

    if (book)
        [dict setObject:book forKey:@"book"];

    return dict;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"booksId"])
        self.booksId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"book"])
        self.book = [dictionary objectForKey:@"book"];
}

- (void)dealloc
{
    [book release];

    [super dealloc];
}
@end
