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

@class JRCaptureObject;
@protocol JRCaptureObjectDelegate <NSObject>
@optional
- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context;
- (void)updateCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context;
- (void)replaceCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context;
- (void)replaceCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context;
@end

@protocol JRCaptureInterfaceDelegate;
@interface JRCaptureObject : NSObject <NSCopying, JRCaptureInterfaceDelegate>
@property (retain)   NSString     *captureObjectPath;
@property (readonly) NSMutableSet *dirtyPropertySet;
- (void)updateLocallyFromNewDictionary:(NSDictionary *)dictionary;
- (void)replaceLocallyFromNewDictionary:(NSDictionary *)dictionary;
- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;
- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;
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
