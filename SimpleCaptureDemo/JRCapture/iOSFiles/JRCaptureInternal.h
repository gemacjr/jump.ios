//
//  JRCaptureData.h
//  SimpleCaptureDemo
//
//  Created by Lilli Szafranski on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRCaptureInterface.h"
#import "JSONKit.h"
#import "JRCapture.h"

@class JRCaptureObject;
@protocol JRCaptureObjectDelegate <NSObject>
@optional
- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context;
- (void)updateCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context;
- (void)replaceCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context;
- (void)replaceCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context;
// TODO: Do we want to add the name of the array to this method as well?
- (void)replaceArray:(NSArray *)array named:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context;
- (void)replaceArrayNamed:(NSString *)arrayName onCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context;
@end

@protocol JRCaptureInterfaceDelegate;
@interface JRCaptureObject : NSObject <NSCopying, JRCaptureInterfaceDelegate>
@property (retain)   NSString     *captureObjectPath;
@property (readonly) NSMutableSet *dirtyPropertySet;
@property (readonly) NSMutableSet *dirtyArraySet;
@property (readonly) BOOL canBeUpdatedOrReplaced;
- (NSDictionary *)toDictionary;
- (NSDictionary *)toUpdateDictionary;
- (NSDictionary *)toReplaceDictionary;
- (NSDictionary *)objectProperties;
- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;
- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;
//- (void)updateLocallyFromNewDictionary:(NSDictionary *)dictionary;
//- (void)replaceLocallyFromNewDictionary:(NSDictionary *)dictionary;
- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;
- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;
- (void)replaceArrayOnCapture:(NSArray *)array named:(NSString *)arrayName
                  forDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;
- (void)replaceSimpleArrayOnCapture:(NSArray *)array ofType:(NSString *)elementType named:(NSString *)arrayName
                        forDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;
@end

@interface JRStringPluralElement : JRCaptureObject
// TODO: Make JRObjectId type
@property (nonatomic, copy)     JRObjectId *elementId;
@property (nonatomic, readonly) NSString   *type;
@property (nonatomic, copy)     NSString   *value;
+ (id)stringElementWithType:(NSString *)elementType;
- (id)initWithType:(NSString *)elementType;
@end

@interface NSArray (JRStringPluralElement)
- (NSArray *)arrayOfStringPluralDictionariesFromStringPluralElements;
- (NSArray *)arrayOfStringPluralUpdateDictionariesFromStringPluralElements;
- (NSArray *)arrayOfStringPluralReplaceDictionariesFromStringPluralElements;
- (NSArray *)arrayOfStringPluralElementsFromStringPluralDictionariesWithType:(NSString *)elementType andPath:(NSString *)capturePath;
//- (NSArray*)copyArrayOfStringsIntoArrayOfStringPluralElementsWithType:(NSString *)elementType;
- (NSArray*)copyArrayOfStringPluralElementsWithType:(NSString *)elementType;
@end

@interface JRCaptureData : NSObject
+ (NSString *)accessToken;
+ (NSString *)creationToken;
+ (NSString *)captureApidDomain;
+ (NSString *)captureUIDomain;
+ (NSString *)clientId;
+ (NSString *)entityTypeName;
+ (void)setAccessToken:(NSString *)newAccessToken;
+ (void)setCreationToken:(NSString *)newCreationToken;
+ (void)setCaptureApiDomain:(NSString *)newCaptureApidDomain
            captureUIDomain:(NSString *)newCaptureUIDomain
                   clientId:(NSString *)newClientId
          andEntityTypeName:(NSString *)newEntityTypeName;
+ (NSString *)captureMobileEndpointUrl;
@end
