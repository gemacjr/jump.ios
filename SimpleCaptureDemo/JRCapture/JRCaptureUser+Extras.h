//
//  Created by lillialexis on 2/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "JRCaptureUser.h"

@class JRCaptureObject;
@class JRCaptureUser;
@protocol JRCaptureInterfaceDelegate;

// TODO: Do we even need this file anymore??
@protocol JRCaptureUserDelegate <NSObject>
@optional
- (void)createCaptureUser:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context;
- (void)createCaptureUser:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context;
//- (void)updateCaptureUser:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context;
//- (void)updateCaptureUser:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context;
//- (void)replaceCaptureUser:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context;
//- (void)replaceCaptureUser:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context;
@end

@interface JRCaptureUser (Extras) <JRCaptureInterfaceDelegate>
+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary;
//@property (copy) NSString *accessToken;
//@property (copy) NSString *creationToken;
- (void)createUserOnCaptureForDelegate:(id<JRCaptureUserDelegate>)delegate withContext:(NSObject *)context;
//- (void)updateUserOnCaptureForDelegate:(id<JRCaptureUserDelegate>)delegate withContext:(NSObject *)context;
//- (void)replaceUserOnCaptureForDelegate:(id<JRCaptureUserDelegate>)delegate withContext:(NSObject *)context;

//- (void)updateForDelegate:(id<JRCaptureUserDelegate>)delegate;
//- (void)createForDelegate:(id<JRCaptureUserDelegate>)delegate;
@end
