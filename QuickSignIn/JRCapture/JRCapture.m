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

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "JRCapture.h"


@implementation NSDate (CaptureDateTime)
// YYYY-MM-DD
+ (NSDate *)dateFromISO8601DateString:(NSString *)dateString
{
    if (!dateString) return nil;

    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }

    NSDate *date = nil;
    NSString *ISO8601String = [[NSString stringWithString:dateString] uppercaseString];
    if (!date) /* 1983-03-12 */
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        date = [dateFormatter dateFromString:ISO8601String];
    }
    if (!date) /* 19830312 */
    {
        [dateFormatter setDateFormat:@"YYYYMMDD"];
        date = [dateFormatter dateFromString:ISO8601String];
    }

    if (!date) NSLog(@"Could not parse IS8601 date: \"%@\" Possibly invalid format.", dateString);
    return date;
}

+ (NSDate *)dateFromISO8601DateTimeString:(NSString *)dateTimeString
{
    if (!dateTimeString) return nil;

    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }

    NSDate *date = nil;
    NSString *ISO8601String = [[NSString stringWithString:dateTimeString] uppercaseString];
    if (!date) /* Full ISO8601; e.g., 2012-02-02 01:33:20.122198 +0000 */
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ"];
        date = [dateFormatter dateFromString:ISO8601String];
    }
    if (!date) /* With a 'T'; e.g., 2012-02-02T01:33:20.122198 +0000 */
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSS ZZZ"];
        date = [dateFormatter dateFromString:ISO8601String];
    }
    if (!date) /* No timezone; e.g., 2012-02-02 01:33:20.122198 */
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS"];
        date = [dateFormatter dateFromString:ISO8601String];
    }
    if (!date) /* No timezone and a 'T'; e.g., 2012-02-02T01:33:20.122198 */
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSS"];
        date = [dateFormatter dateFromString:ISO8601String];
    }
    if (!date) /* No milis; e.g., 2012-02-02 01:33:20 +0000 */
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
        date = [dateFormatter dateFromString:ISO8601String];
    }
    if (!date) /* No milis and a 'T'; e.g., 2012-02-02T01:33:20 +0000 */
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss ZZZ"];
        date = [dateFormatter dateFromString:ISO8601String];
    }
    if (!date) /* No milis or timezone; e.g., 2012-02-02 01:33:20 */
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        date = [dateFormatter dateFromString:ISO8601String];
    }
    if (!date) /* No milis or timezone and a 'T'; e.g., 2012-02-02T01:33:20 */
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        date = [dateFormatter dateFromString:ISO8601String];
    }
    // TODO: Test for and come up with any more!!!

    if (!date) NSLog(@"Could not parse ISO8601 date: \"%@\" Possibly invalid format.", dateTimeString);
    return date;
}

- (NSString *)stringFromISO8601Date
{
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }

    return [dateFormatter stringFromDate:self];
}

- (NSString *)stringFromISO8601DateTime
{
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ"];
    }

    return [dateFormatter stringFromDate:self];
}
@end

@implementation JRCapture
/* Only here until the Capture server populates this field for us */
+ (NSString *)domainFromIdentifier:(NSString *)identifier
{
    NSURL    *url  = [NSURL URLWithString:identifier];
    NSString *host = url.host;

    if (!host)
        return identifier;

    NSArray *parts = [host componentsSeparatedByString:@"."];

    if (!parts || [parts count] < 3)
        return host;

    return [NSString stringWithFormat:@"%@.%@", [parts objectAtIndex:1], [parts objectAtIndex:2]];
}

+ (id)captureProfilesObjectFromEngageAuthInfo:(NSDictionary *)engageAuthInfo
{
    NSString *identifier = [[engageAuthInfo objectForKey:@"profile"] objectForKey:@"identifier"];
    NSString *domain     = [self domainFromIdentifier:identifier];

    NSMutableDictionary *newEngageAuthInfo = nil;
    if (domain && identifier)
    {
        newEngageAuthInfo = [NSMutableDictionary dictionaryWithDictionary:engageAuthInfo];
        [newEngageAuthInfo setObject:domain forKey:@"domain"];
        [newEngageAuthInfo setObject:identifier forKey:@"identifier"];
    }

    Class JRProfilesClass            = NSClassFromString(@"JRProfiles");
    SEL profilesObjectFromDictionary = NSSelectorFromString(@"profilesObjectFromDictionary:");

    id profilesObject = [JRProfilesClass performSelector:profilesObjectFromDictionary withObject:newEngageAuthInfo];

    return profilesObject;
}
@end
