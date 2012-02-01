/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2010, Janrain, Inc.

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


 File:   JRCapture.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, January 31, 2012
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "JRCapture.h"


@implementation NSDate (CaptureDateTime)
// YYYY-MM-DD
+ (NSDate *)dateFromISO8601DateString:(NSString *)dateString
{
    if (!dateString) return nil;

    /* Create date formatter */
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        NSLocale *en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:en_US_POSIX];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [en_US_POSIX release];
    }

    /* Process */
    NSDate *date = nil;
    NSString *ISO8601String = [[NSString stringWithString:dateString] uppercaseString];
    if (!date) { // YYYY-MM-DD
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        date = [dateFormatter dateFromString:ISO8601String];
    }
    if (!date) { // YYYYMMDD
        [dateFormatter setDateFormat:@"YYYYMMDD"];
        date = [dateFormatter dateFromString:ISO8601String];
    }
    if (!date) { // Sun, 19 May 2002 15:21:36
        [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss"];
        date = [dateFormatter dateFromString:ISO8601String];
    }
    if (!date) { // Sun, 19 May 2002 15:21
        [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm"];
        date = [dateFormatter dateFromString:ISO8601String];
    }

    if (!date) NSLog(@"Could not parse RFC822 date: \"%@\" Possibly invalid format.", dateString);
    return date;
}

+ (NSDate *)dateFromISO8601DateTimeString:(NSString *)dateTimeString
{
    if (!dateTimeString) return nil;

    // Create date formatter
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        NSLocale *en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:en_US_POSIX];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [en_US_POSIX release];
    }

    // Process
    NSDate *date = nil;
    NSString *ISO8601String = [[NSString stringWithString:dateTimeString] uppercaseString];
    if ([ISO8601String rangeOfString:@","].location != NSNotFound) {
        if (!date) { // Sun, 19 May 2002 15:21:36 GMT
            [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"];
            date = [dateFormatter dateFromString:ISO8601String];
        }
        if (!date) { // Sun, 19 May 2002 15:21 GMT
            [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm zzz"];
            date = [dateFormatter dateFromString:ISO8601String];
        }
        if (!date) { // Sun, 19 May 2002 15:21:36
            [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss"];
            date = [dateFormatter dateFromString:ISO8601String];
        }
        if (!date) { // Sun, 19 May 2002 15:21
            [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm"];
            date = [dateFormatter dateFromString:ISO8601String];
        }
    } else {
        if (!date) { // 19 May 2002 15:21:36 GMT
            [dateFormatter setDateFormat:@"d MMM yyyy HH:mm:ss zzz"];
            date = [dateFormatter dateFromString:ISO8601String];
        }
        if (!date) { // 19 May 2002 15:21 GMT
            [dateFormatter setDateFormat:@"d MMM yyyy HH:mm zzz"];
            date = [dateFormatter dateFromString:ISO8601String];
        }
        if (!date) { // 19 May 2002 15:21:36
            [dateFormatter setDateFormat:@"d MMM yyyy HH:mm:ss"];
            date = [dateFormatter dateFromString:ISO8601String];
        }
        if (!date) { // 19 May 2002 15:21
            [dateFormatter setDateFormat:@"d MMM yyyy HH:mm"];
            date = [dateFormatter dateFromString:ISO8601String];
        }
    }
    if (!date) NSLog(@"Could not parse RFC822 date: \"%@\" Possibly invalid format.", dateTimeString);
    return date;
}
- (NSString *)stringFromISO8601Date
{
    return @"FOO";
}
- (NSString *)stringFromISO8601DateTime
{
    return @"FOO";
}
@end
