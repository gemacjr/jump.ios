/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 File:   JRCaptureInterface.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Thursday, January 26, 2012
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>
#import "JRConnectionManager.h"


@protocol JRCaptureInterfaceDelegate <NSObject>
@optional
- (void)createCaptureUserDidSucceedWithResult:(NSString *)result;
- (void)createCaptureUserDidFailWithResult:(NSString *)result;
- (void)updateCaptureUserDidSucceedWithResult:(NSString *)result;
- (void)updateCaptureUserDidFailWithResult:(NSString *)result;
- (void)getCaptureEntityDidSucceedWithResult:(NSString *)result;
- (void)getCaptureEntityDidFailWithResult:(NSString *)result;
- (void)getCaptureUserDidSucceedWithResult:(NSString *)result;
- (void)getCaptureUserDidFailWithResult:(NSString *)result;
@end

@interface JRCaptureInterface : NSObject <JRConnectionManagerDelegate>
{
//    JRCaptureUser *captureUser;

    id<JRCaptureInterfaceDelegate> captureInterfaceDelegate;
}
+ (void)setCaptureDomain:(NSString *)newCaptureDomain clientId:(NSString *)newClientId
       andEntityTypeName:(NSString *)newEntityTypeName;
+ (NSString *)captureMobileEndpointUrl;

+ (void)createCaptureUser:(NSDictionary *)user withCreationToken:(NSString *)creationToken
              forDelegate:(id<JRCaptureInterfaceDelegate>)delegate;
+ (void)updateCaptureUser:(NSDictionary *)user withAccessToken:(NSString *)accessToken
              forDelegate:(id<JRCaptureInterfaceDelegate>)delegate;
+ (void)getCaptureEntityNamed:(NSString *)entityName withEntityId:(NSInteger)entityId
               andAccessToken:(NSString *)accessToken forDelegate:(id<JRCaptureInterfaceDelegate>)delegate;
+ (void)getCaptureUserWithAccessToken:(NSString *)accessToken
                          forDelegate:(id<JRCaptureInterfaceDelegate>)delegate;
@end
