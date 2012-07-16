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
