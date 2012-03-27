//
//  JRCaptureData.h
//  SimpleCaptureDemo
//
//  Created by Lilli Szafranski on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRCaptureData : NSObject
+ (NSString *)accessToken;
+ (NSString *)creationToken;
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
