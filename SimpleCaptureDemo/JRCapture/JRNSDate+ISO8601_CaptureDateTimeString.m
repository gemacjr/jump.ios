//
// Created by lillialexis on 6/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "JRNSDate+ISO8601_CaptureDateTimeString.h"

@implementation NSDate (ISO8601_CaptureDateTimeString)
+ (NSDate *)dateFromISO8601DateString:(NSString *)dateString
{
    if (!dateString) return nil;

    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setLenient:NO];
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
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        date = [dateFormatter dateFromString:ISO8601String];
    }

    if (!date) NSLog(@"Could not parse ISO8601 date: \"%@\" Possibly invalid format.", dateString);
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
    DLog(@"");
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
