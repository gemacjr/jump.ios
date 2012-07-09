//
//  JRCaptureData.h
//  SimpleCaptureDemo
//
//  Created by Lilli Szafranski on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @internal
 * Intended for internal use. Please see JRCapture.h
 */
@interface JRCaptureData : NSObject
+ (void)setAccessToken:(NSString *)newAccessToken forUser:(NSString *)userId;
+ (void)setCreationToken:(NSString *)newCreationToken;
+ (NSString *)accessTokenForUser:(NSString *)userId;
+ (NSString *)accessToken;//ForUser:(NSString *)userId;
+ (NSString *)creationToken;//ForUser:(NSString *)userId;
+ (NSString *)captureApidDomain;
+ (NSString *)captureUIDomain;
+ (NSString *)clientId;
+ (NSString *)entityTypeName;
+ (void)setCaptureApiDomain:(NSString *)newCaptureApidDomain
            captureUIDomain:(NSString *)newCaptureUIDomain
                   clientId:(NSString *)newClientId
          andEntityTypeName:(NSString *)newEntityTypeName;
+ (NSString *)captureMobileEndpointUrl;
@end
