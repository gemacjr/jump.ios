//
//  Created by lillialexis on 2/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "JRCaptureUser.h"

@class JRCaptureObject;
@class JRCaptureUser;

@protocol JRCaptureUserDelegate <JRCaptureObjectDelegate>
@optional
- (void)createDidSucceedForUser:(JRCaptureUser *)user context:(NSObject *)context;
- (void)createDidFailForUser:(JRCaptureUser *)user withError:(NSError *)error context:(NSObject *)context;

- (void)fetchUserDidSucceed:(JRCaptureUser *)fetchedUser context:(NSObject *)context;
- (void)fetchUserDidFailWithError:(NSError *)error context:(NSObject *)context;

- (void)fetchLastUpdatedDidSucceed:(JRDateTime *)serverLastUpdated isOutdated:(BOOL)isOutdated context:(NSObject *)context;
- (void)fetchLastUpdatedDidFailWithError:(NSError *)error context:(NSObject *)context;
@end

@interface JRCaptureUser (Extras)
// save
// load

// create user
- (void)createOnCaptureForDelegate:(id<JRCaptureUserDelegate>)delegate context:(NSObject *)context;

// fetch user
+ (void)fetchCaptureUserFromServerForDelegate:(id<JRCaptureUserDelegate>)delegate context:(NSObject *)context;

// get created, uuid, etc.

// get lastUpdated/is outdated (locally and server)
- (void)fetchLastUpdatedFromServerForDelegate:(id<JRCaptureUserDelegate>)delegate context:(NSObject *)context;

+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary;
@end
