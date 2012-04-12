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

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


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
@property (nonatomic, copy) JRObjectId *captureUserId;  
@property (nonatomic, copy) JRUuid *uuid; /* This is a property of type 'uuid', which is a typedef of NSString, etc. */ 
@property (nonatomic, copy) JRDateTime *created; /* This is a property of type 'dateTime', which is a typedef of NSDate, etc. The accepted format should be an ISO8601 dateTime string (e.g., yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ) */ 
@property (nonatomic, copy) JRDateTime *lastUpdated; /* This is a property of type 'dateTime', which is a typedef of NSDate, etc. The accepted format should be an ISO8601 dateTime string (e.g., yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ) */ 
@property (nonatomic, copy) NSString *aboutMe;  
@property (nonatomic, copy) JRDate *birthday; /* This is a property of type 'date', which is a typedef of NSDate, etc. The accepted format should be an ISO8601 date string (e.g., yyyy-MM-dd) */ 
@property (nonatomic, copy) NSString *currentLocation;  
@property (nonatomic, copy) JRJsonObject *display; /* This is a property of type 'json', which can be an NSDictionary, NSArray, NSString, etc., and is therefore is a typedef of NSObject */ 
@property (nonatomic, copy) NSString *displayName;  
@property (nonatomic, copy) NSString *email;  
@property (nonatomic, copy) JRDateTime *emailVerified; /* This is a property of type 'dateTime', which is a typedef of NSDate, etc. The accepted format should be an ISO8601 dateTime string (e.g., yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ) */ 
@property (nonatomic, copy) NSString *familyName;  
@property (nonatomic, copy) JRArray *games; /* This is an array of JRGames */ 
@property (nonatomic, copy) NSString *gender;  
@property (nonatomic, copy) NSString *givenName;  
@property (nonatomic, copy) JRDateTime *lastLogin; /* This is a property of type 'dateTime', which is a typedef of NSDate, etc. The accepted format should be an ISO8601 dateTime string (e.g., yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ) */ 
@property (nonatomic, copy) NSString *middleName;  
@property (nonatomic, copy) JRObjectLevelOne *objectLevelOne;  
@property (nonatomic, copy) JRArray *onipLevelOne; /* This is an array of JROnipLevelOne */ 
@property (nonatomic, copy) JRPassword *password; /* This is a property of type 'password', which can be an NSString or NSDictionary, and is therefore is a typedef of NSObject */ 
@property (nonatomic, copy) JRArray *photos; /* This is an array of JRPhotos */ 
@property (nonatomic, copy) JRPinoLevelOne *pinoLevelOne;  
@property (nonatomic, copy) JRArray *pluralLevelOne; /* This is an array of JRPluralLevelOne */ 
@property (nonatomic, copy) JRPrimaryAddress *primaryAddress;  
@property (nonatomic, copy) JRArray *profiles; /* This is an array of JRProfiles */ 
@property (nonatomic, copy) JRArray *statuses; /* This is an array of JRStatuses */ 
@property (nonatomic, copy) JRBoolean *testerBoolean;  
@property (nonatomic, copy) JRInteger *testerInteger;  
@property (nonatomic, copy) JRIpAddress *testerIpAddr; /* This is a property of type 'ipAddress', which is a typedef of NSString, etc. */ 
- (id)init;
+ (id)captureUser;
- (id)initWithEmail:(NSString *)newEmail;
+ (id)captureUserWithEmail:(NSString *)email;
+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;
- (NSDictionary*)toDictionary;
- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;
- (NSDictionary*)objectProperties;
- (BOOL)getTesterBooleanBoolValue;
- (void)setTesterBooleanWithBool:(BOOL)boolVal;
- (NSInteger)getTesterIntegerIntegerValue;
- (void)setTesterIntegerWithInteger:(NSInteger)integerVal;
@end
