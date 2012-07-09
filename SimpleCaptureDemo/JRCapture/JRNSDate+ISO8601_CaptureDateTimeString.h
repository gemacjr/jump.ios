//
// Created by lillialexis on 6/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface NSDate (JRDate_ISO8601_CaptureDateTimeString)
+ (NSDate *)dateFromISO8601DateString:(NSString *)dateString;
+ (NSDate *)dateFromISO8601DateTimeString:(NSString *)dateTimeString;
- (NSString *)stringFromISO8601Date;
- (NSString *)stringFromISO8601DateTime;
@end
