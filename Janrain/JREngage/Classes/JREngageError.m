//
// Created by lillialexis on 7/11/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "JREngageError.h"

NSString * JREngageErrorDomain = @"JREngage.ErrorDomain";

@implementation JREngageError
+ (NSError*)setError:(NSString*)message withCode:(NSInteger)code
{
    ALog (@"An error occured (%d): %@", code, message);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithString:message], NSLocalizedDescriptionKey, nil];

    return [[[NSError alloc] initWithDomain:JREngageErrorDomain
                                       code:code
                                   userInfo:userInfo] autorelease];
}
@end
