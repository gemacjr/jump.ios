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
#import "JRGames.h"
#import "JRObjectLevelOne.h"
#import "JROnipLevelOne.h"
#import "JRPhotos.h"
#import "JRPinoLevelOne.h"
#import "JRPluralLevelOne.h"
#import "JRPrimaryAddress.h"
#import "JRProfiles.h"
#import "JRStatuses.h"

@interface JRCaptureUser : JRCaptureObject
@property                   NSInteger captureUserId;
@property (nonatomic, copy) NSString *uuid;  
@property (nonatomic, copy) NSDate *created;  
@property (nonatomic, copy) NSDate *lastUpdated;  
@property (nonatomic, copy) NSString *aboutMe;  
@property (nonatomic, copy) NSDate *birthday;  
@property (nonatomic, copy) NSString *currentLocation;  
@property (nonatomic, copy) NSObject *display; /* This is a property of type 'json', and therefore can be an NSDictionary, NSArray, NSString, etc. */ 
@property (nonatomic, copy) NSString *displayName;  
@property (nonatomic, copy) NSString *email;  
@property (nonatomic, copy) NSDate *emailVerified;  
@property (nonatomic, copy) NSString *familyName;  
@property (nonatomic, copy) NSArray *games; /* This is an array of JRGames */ 
@property (nonatomic, copy) NSString *gender;  
@property (nonatomic, copy) NSString *givenName;  
@property (nonatomic, copy) NSDate *lastLogin;  
@property (nonatomic, copy) NSString *middleName;  
@property (nonatomic, copy) JRObjectLevelOne *objectLevelOne;  
@property (nonatomic, copy) NSArray *onipLevelOne; /* This is an array of JROnipLevelOne */ 
@property (nonatomic, copy) NSObject *password;  
@property (nonatomic, copy) NSArray *photos; /* This is an array of JRPhotos */ 
@property (nonatomic, copy) JRPinoLevelOne *pinoLevelOne;  
@property (nonatomic, copy) NSArray *pluralLevelOne; /* This is an array of JRPluralLevelOne */ 
@property (nonatomic, copy) JRPrimaryAddress *primaryAddress;  
@property (nonatomic, copy) NSArray *profiles; /* This is an array of JRProfiles */ 
@property (nonatomic, copy) NSArray *statuses; /* This is an array of JRStatuses */ 
- (id)init;
+ (id)captureUser;
- (id)initWithEmail:(NSString *)newEmail;
+ (id)captureUserWithEmail:(NSString *)email;
+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary;
- (NSDictionary*)toDictionary;
- (void)updateFromDictionary:(NSDictionary*)dictionary;
@end
