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
#import "JRCapture.h"
#import "JRProfile.h"

@interface JRProfiles : JRCaptureObject
@property                   NSInteger profilesId;
@property (nonatomic, copy) NSObject *accessCredentials; /* This is a property of type 'json', and therefore can be an NSDictionary, NSArray, NSString, etc. */ 
@property (nonatomic, copy) NSString *domain;  
@property (nonatomic, copy) NSArray *followers; /* This is an array of JRStringPluralElements with type identifier */ 
@property (nonatomic, copy) NSArray *following; /* This is an array of JRStringPluralElements with type identifier */ 
@property (nonatomic, copy) NSArray *friends; /* This is an array of JRStringPluralElements with type identifier */ 
@property (nonatomic, copy) NSString *identifier;  
@property (nonatomic, copy) JRProfile *profile;  
@property (nonatomic, copy) NSObject *provider; /* This is a property of type 'json', and therefore can be an NSDictionary, NSArray, NSString, etc. */ 
@property (nonatomic, copy) NSString *remote_key;  
- (id)init;
+ (id)profiles;
- (id)initWithDomain:(NSString *)newDomain andIdentifier:(NSString *)newIdentifier;
+ (id)profilesWithDomain:(NSString *)domain andIdentifier:(NSString *)identifier;
+ (id)profilesObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;
- (NSDictionary*)toDictionary;
- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;
@end
