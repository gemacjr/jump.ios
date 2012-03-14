//
//  JRCaptureData.h
//  SimpleCaptureDemo
//
//  Created by Lilli Szafranski on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRCaptureData : NSObject
+ (NSString *)captureDomain;
+ (NSString *)clientId;
+ (NSString *)entityTypeName;
+ (void)setCaptureDomain:(NSString *)newCaptureDomain
                clientId:(NSString *)newClientId
       andEntityTypeName:(NSString *)newEntityTypeName;

+ (NSString *)captureMobileEndpointUrl;
@end
