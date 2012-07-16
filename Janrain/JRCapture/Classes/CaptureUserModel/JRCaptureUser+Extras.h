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
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>
#import "JRCaptureUser.h"

@class JRCaptureObject;
@class JRCaptureUser;

@protocol JRCaptureUserDelegate <JRCaptureObjectDelegate>
@optional
- (void)createDidSucceedForUser:(JRCaptureUser *)user context:(NSObject *)context;
- (void)createDidFailForUser:(JRCaptureUser *)user withError:(NSError *)error context:(NSObject *)context;

- (void)fetchUserDidSucceed:(JRCaptureUser *)fetchedUser context:(NSObject *)context;
- (void)fetchUserDidFailWithError:(NSError *)error context:(NSObject *)context;

- (void)fetchLastUpdatedDidSucceed:(JRDateTime *)serverLastUpdated isOutdated:(BOOL)isOutdated context:(NSObject *)context;
- (void)fetchLastUpdatedDidFailWithError:(NSError *)error context:(NSObject *)context;
@end

@interface JRCaptureUser (JRCaptureUser_Extras) <NSCoding>
// save
// load

// create user
- (void)createOnCaptureForDelegate:(id<JRCaptureUserDelegate>)delegate context:(NSObject *)context;

// fetch user
+ (void)fetchCaptureUserFromServerForDelegate:(id<JRCaptureUserDelegate>)delegate context:(NSObject *)context;

// get created, uuid, etc.

// get lastUpdated/is outdated (locally and server)
- (void)fetchLastUpdatedFromServerForDelegate:(id<JRCaptureUserDelegate>)delegate context:(NSObject *)context;

+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary;
@end
