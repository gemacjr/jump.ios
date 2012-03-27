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


 File:   JRCapture.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, January 31, 2012
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>
#import "JRCaptureInterface.h"
#import "JRCaptureInterfaceTwo.h"
#import "JRCaptureData.h"
#import "JSONKit.h"

@interface NSDate (CaptureDateTime)
+ (NSDate *)dateFromISO8601DateString:(NSString *)dateString;
+ (NSDate *)dateFromISO8601DateTimeString:(NSString *)dateTimeString;
- (NSString *)stringFromISO8601Date;
- (NSString *)stringFromISO8601DateTime;
@end

//@protocol JRJsonifying <NSObject>
//@optional
//- (NSDictionary*)dictionaryFromObject;
//@end

@class JRCaptureObject;
@protocol JRCaptureObjectDelegate <NSObject>
@optional
- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context;
- (void)updateCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context;
- (void)replaceCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context;
- (void)replaceCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context;
@end

@interface JRCaptureObject : NSObject <NSCopying, /*JRJsonifying,*/ JRCaptureInterfaceDelegate, JRCaptureInterfaceTwoDelegate>
@property (retain)   NSString     *captureObjectPath;
@property (readonly) NSMutableSet *dirtyPropertySet;
//@property (copy)     NSString     *accessToken;
//@property (retain) id<JRCaptureObjectDelegate> updateDelegate;
//- (void)updateForDelegate:(id<JRCaptureObjectDelegate>)delegate;
- (void)updateLocallyFromNewDictionary:(NSDictionary *)dictionary;
- (void)replaceLocallyFromNewDictionary:(NSDictionary *)dictionary;
- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;
- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;
@end

@protocol JRProfilesAssumedPresence <NSObject>
@optional
+ (id)profilesObjectFromDictionary:(NSDictionary *)dictionary;
@end

@interface JRCapture : NSObject
+ (id)captureProfilesObjectFromEngageAuthInfo:(NSDictionary *)engageAuthInfo;
+ (void)setCaptureDomain:(NSString *)newCaptureDomain clientId:(NSString *)newClientId
       andEntityTypeName:(NSString *)newEntityTypeName;
+ (NSString *)captureMobileEndpointUrl;
@end
