
#import <Foundation/Foundation.h>
#import "JRCaptureObject.h"
#import "JRCaptureUser+Extras.h"

@interface NSArray (StringArray)
- (NSArray *)arrayOfStringsFromStringPluralDictionariesWithType:(NSString *)type;
@end

@class JRCaptureObject;
@protocol JRCaptureObjectDelegate;

@protocol JRCaptureObjectTesterDelegate <JRCaptureObjectDelegate>
@optional
- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context;
- (void)updateCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context;
- (void)replaceCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context;
- (void)replaceCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context;
- (void)replaceArray:(NSArray *)newArray named:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context;
- (void)replaceArrayNamed:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context;
@end

@protocol JRCaptureUserTesterDelegate <JRCaptureUserDelegate>
@optional
- (void)createCaptureUser:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context;
- (void)createCaptureUser:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context;
@end


@interface JRCaptureObject ()
@property (retain)   NSString     *captureObjectPath;
@property (readonly) NSMutableSet *dirtyPropertySet;
- (NSDictionary *)toDictionaryForEncoder:(BOOL)forEncoder;
- (NSDictionary *)toUpdateDictionary;
- (NSDictionary *)toReplaceDictionaryIncludingArrays:(BOOL)includingArrays;
- (NSDictionary *)objectProperties;

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;
- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;// includingStateVariables:(BOOL)includingStateVariables;

- (void)replaceOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

//- (id)captureObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;

- (void)replaceArrayOnCapture:(NSArray *)array named:(NSString *)arrayName isArrayOfStrings:(BOOL)isStringArray withType:(NSString *)type
                  forDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

- (BOOL)isEqualByPrivateProperties:(JRCaptureObject *)otherObj;
@end
