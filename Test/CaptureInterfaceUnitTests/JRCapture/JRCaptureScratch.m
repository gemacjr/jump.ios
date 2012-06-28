#ifdef foo
#import "JRCaptureObject.h"
#import "JRCaptureUser.h"

@class JRCaptureObject;

@protocol JRCaptureObjectExternalDelegate <NSObject>
@optional
- (void)updateDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context;
- (void)updateDidFailForObject:(JRCaptureObject *)object withError:(NSString *)error context:(NSObject *)context;
- (void)replaceDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context;
- (void)replaceDidFailForObject:(JRCaptureObject *)object withError:(NSString *)error context:(NSObject *)context;

- (void)replaceArrayDidSucceedForObject:(JRCaptureObject *)object
                               newArray:(NSArray *)replacedArray /* replaced array? */
                                  named:(NSString *)arrayName
                                context:(NSObject *)context;

- (void)replaceArrayDidFailForObject:(JRCaptureObject *)object
                          arrayNamed:(NSString *)arrayName
                           withError:(NSString *)error
                             context:(NSObject *)context;


- (void)replaceDidSucceedForArray:(NSArray *)resultArray /* replaced array? */
                  onCaptureObject:(JRCaptureObject *)object
                            named:(NSString *)arrayName
                          context:(NSObject *)context;

- (void)replaceDidFailForArrayOnCaptureObject:(JRCaptureObject *)object
                                        named:(NSString *)arrayName
                                    withError:(NSString *)error
                                      context:(NSObject *)context;

@end



@interface JRCaptureObject (external)
// property getting setters

// update for delegate

- (void)updateOnCaptureForDelegate:(id<JRCaptureObjectExternalDelegate>)delegate context:(NSObject *)context;

// replace for delegate
- (void)replaceOnCaptureForDelegate:(id<JRCaptureObjectExternalDelegate>)delegate context:(NSObject *)context;

// replace array methods

// (hidden) captureObjectFromDictionary:withPath: changed from specificObjectFromDictionary and hidden
// (hidden) is equals to object methods
// (hidden) object properties (introspection)
@end

@protocol JRCaptureUserExternalDelegate <NSObject>
@optional
- (void)createDidSucceedForUser:(JRCaptureUser *)user context:(NSObject *)context;
- (void)createDidFailForUser:(JRCaptureUser *)user withError:(NSString *)error context:(NSObject *)context;

- (void)fetchUserDidSucceed:(JRCaptureUser *)fetchedUser context:(NSObject *)context;
- (void)fetchUserDidFailWithError:(NSString *)error context:(NSObject *)context;

- (void)fetchLastUpdatedDidSucceed:(JRDateTime *)serverLastUpdated isOutdated:(BOOL)isOutdated context:(NSObject *)context;
- (void)fetchLastUpdatedDidFailWithError:(NSString *)error context:(NSObject *)context;

@end

@interface JRCaptureUser (external)
// save
// load

// create user
- (void)createOnCaptureForDelegate:(id<JRCaptureUserExternalDelegate>)delegate context:(NSObject *)context;

// fetch user
+ (void)fetchCaptureUserFromServerForDelegate:(id<JRCaptureUserExternalDelegate>)delegate context:(NSObject *)context;

// get created, uuid, etc.

// get lastUpdated/is outdated (locally and server)
- (void)fetchLastUpdatedFromServerForDelegate:(id<JRCaptureUserExternalDelegate>)delegate context:(NSObject *)context;

// record creation status (is new, not created, missing required info, record exists)
@end
#endif
