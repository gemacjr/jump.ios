
#import <Foundation/Foundation.h>
#import "JRCaptureObject.h"
#import "JRCaptureUser+Extras.h"

@interface NSArray (JRArray_StringArray)
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

- (void)replaceDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context;
- (void)replaceDidFailForObject:(JRCaptureObject *)object withError:(NSError *)error context:(NSObject *)context;
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
- (NSDictionary *)toReplaceDictionary;
- (NSDictionary *)objectProperties;
//- (NSSet *)setOfAllUpdatableProperties;

- (NSSet *)updatablePropertySet;
- (void)setAllPropertiesToDirty;
- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet;
- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshot;


- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;
- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;

- (void)replaceOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

- (void)replaceArrayOnCapture:(NSArray *)array named:(NSString *)arrayName isArrayOfStrings:(BOOL)isStringArray withType:(NSString *)type
                  forDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

- (BOOL)isEqualByPrivateProperties:(JRCaptureObject *)otherObj;
@end
