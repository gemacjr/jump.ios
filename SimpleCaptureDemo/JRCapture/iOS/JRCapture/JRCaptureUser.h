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

/**
 * @brief A JRCaptureUser object
 **/
@interface JRCaptureUser : JRCaptureObject
@property (nonatomic, copy) JRObjectId *captureUserId; /**< Simple identifier for this entity @note The id of the object should not be set. // TODO: etc. */ 
@property (nonatomic, copy) JRUuid *uuid; /**< Globally unique indentifier for this entity @note This is a property of type 'uuid', which is a typedef of NSString, etc. */ 
@property (nonatomic, copy) JRDateTime *created; /**< When this entity was created @note This is a property of type 'dateTime', which is a typedef of NSDate, etc. The accepted format should be an ISO8601 dateTime string (e.g., yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ) */ 
@property (nonatomic, copy) JRDateTime *lastUpdated; /**< When this entity was last updated @note This is a property of type 'dateTime', which is a typedef of NSDate, etc. The accepted format should be an ISO8601 dateTime string (e.g., yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ) */ 
@property (nonatomic, copy) NSString *aboutMe; /**< The object's aboutMe property */ 
@property (nonatomic, copy) JRDate *birthday; /**< The object's birthday property @note This is a property of type 'date', which is a typedef of NSDate, etc. The accepted format should be an ISO8601 date string (e.g., yyyy-MM-dd) */ 
@property (nonatomic, copy) NSString *currentLocation; /**< The object's currentLocation property */ 
@property (nonatomic, copy) JRJsonObject *display; /**< The object's display property @note This is a property of type 'json', which can be an NSDictionary, NSArray, NSString, etc., and is therefore is a typedef of NSObject */ 
@property (nonatomic, copy) NSString *displayName; /**< The name of this Contact, suitable for display to end-users. */ 
@property (nonatomic, copy) NSString *email; /**< The object's email property */ 
@property (nonatomic, copy) JRDateTime *emailVerified; /**< The object's emailVerified property @note This is a property of type 'dateTime', which is a typedef of NSDate, etc. The accepted format should be an ISO8601 dateTime string (e.g., yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ) */ 
@property (nonatomic, copy) NSString *familyName; /**< The object's familyName property */ 
@property (nonatomic, copy) JRArray *games; /**< The object's games property @note This is an array of JRGames */ 
@property (nonatomic, copy) NSString *gender; /**< The object's gender property */ 
@property (nonatomic, copy) NSString *givenName; /**< The object's givenName property */ 
@property (nonatomic, copy) JRDateTime *lastLogin; /**< The object's lastLogin property @note This is a property of type 'dateTime', which is a typedef of NSDate, etc. The accepted format should be an ISO8601 dateTime string (e.g., yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ) */ 
@property (nonatomic, copy) NSString *middleName; /**< The object's middleName property */ 
@property (nonatomic, copy) JRObjectLevelOne *objectLevelOne; /**< The object's objectLevelOne property */ 
@property (nonatomic, copy) JRArray *onipLevelOne; /**< The object's onipLevelOne property @note This is an array of JROnipLevelOne */ 
@property (nonatomic, copy) JRPassword *password; /**< The object's password property @note This is a property of type 'password', which can be an NSString or NSDictionary, and is therefore is a typedef of NSObject */ 
@property (nonatomic, copy) JRArray *photos; /**< The object's photos property @note This is an array of JRPhotos */ 
@property (nonatomic, copy) JRPinoLevelOne *pinoLevelOne; /**< The object's pinoLevelOne property */ 
@property (nonatomic, copy) JRArray *pluralLevelOne; /**< The object's pluralLevelOne property @note This is an array of JRPluralLevelOne */ 
@property (nonatomic, copy) JRPrimaryAddress *primaryAddress; /**< The object's primaryAddress property */ 
@property (nonatomic, copy) JRArray *profiles; /**< The object's profiles property @note This is an array of JRProfiles */ 
@property (nonatomic, copy) JRArray *statuses; /**< The object's statuses property @note This is an array of JRStatuses */ 
@property (nonatomic, copy) JRBoolean *testerBoolean; /**< The object's testerBoolean property @note This is a property of type 'boolean', which is a typedef of NSNumber. The accepted values can only be [NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO], or [NSNull null] */ 
@property (nonatomic, copy) JRInteger *testerInteger; /**< The object's testerInteger property @note This is a property of type 'integer', which is a typedef of NSNumber. The accepted values can only be [NSNumber numberWithInteger:<myInteger>], [NSNumber numberWithInt:<myInt>], or [NSNull null] */ 
@property (nonatomic, copy) JRIpAddress *testerIpAddr; /**< The object's testerIpAddr property @note This is a property of type 'ipAddress', which is a typedef of NSString, etc. */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Returns a JRCaptureUser object
 *
 * @return
 *   A JRCaptureUser object
 **/
- (id)init;

/**
 * Returns a JRCaptureUser object
 *
 * @return
 *   A JRCaptureUser object
 **/
+ (id)captureUser;

/**
 * Returns a JRCaptureUser object
 * *
 * @return
 *   A JRCaptureUser object initialized with the given *   If the required arguments are \e nil or \e [NSNull null], returns \e nil **/
- (id)initWithEmail:(NSString *)newEmail;

/**
 * Returns a JRCaptureUser object
 * *
 * @return
 *   A JRCaptureUser object initialized with the given *   If the required arguments are \e nil or \e [NSNull null], returns \e nil **/
+ (id)captureUserWithEmail:(NSString *)email;

/**
 * Returns a JRCaptureUser object created from an \e NSDictionary representing the object
 *
 * @param dictionary
 *   An \e NSDictionary containing keys/values which map the the object's 
 *   properties and their values/types.  This value cannot be nil
 *
 * @param capturePath
 *   This is the qualified name used to refer to specific elements in a record;
 *   a pound sign (#) is used to refer to plural elements with an id. The path
 *   of the root object is "/"
 *
 * @par Example:
 * The \c /primaryAddress/city refers to the city attribute of the primaryAddress object
 * The \c /profiles#1/username refers to the username attribute of the element in profiles with id=1
 *
 * @return
 *   A JRCaptureUser object
 **/
+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;
/*@}*/

/**
 * @name Dictionary Serialization/Deserialization
 **/
/*@{*/
/**
 * Creates an  NSDictionary represention of a JRCaptureUser object
 * populated with all of the object's properties, as the dictionary's 
 * keys, and the properties' values as the dictionary's values
 *
 * @return
 *   An \e NSDictionary representation of a JRCaptureUser object
 **/
- (NSDictionary*)toDictionary;

/**
 * @internal
 * Updates the object from an \e NSDictionary populated with some of the object's
 * properties, as the dictionary's keys, and the properties' values as the dictionary's values. 
 * This method is used by other JRCaptureObjects and should not be used by consumers of the 
 * mobile Capture library
 *
 * @param dictionary
 *   An \e NSDictionary containing keys/values which map the the object's 
 *   properties and their values/types
 *
 * @param capturePath
 *   This is the qualified name used to refer to specific elements in a record;
 *   a pound sign (#) is used to refer to plural elements with an id. The path
 *   of the root object is "/"
 *
 * @par Example:
 * The \c /primaryAddress/city refers to the city attribute of the primaryAddress object
 * The \c /profiles#1/username refers to the username attribute of the element in profiles with id=1
 *
 *  
 * The main difference between this method and the replaceFromDictionary:withPath:(), is that
 * in this method properties are only updated if they exist in the dictionary, and in 
 * replaceFromDictionary:withPath:(), all properties are replaced.  Even if the value is \e [NSNull null]
 * so long as the key exists in the dictionary, the property is updated.
 **/
- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;

/**
 * @internal
 * Replaces the object from an \e NSDictionary populated with some or all of the object's
 * properties, as the dictionary's keys, and the properties' values as the dictionary's values.
 * This method is used by other JRCaptureObjects and should not be used by consumers of the 
 * mobile Capture library
 *
 * @param dictionary
 *   An  NSDictionary containing keys/values which map the the object's 
 *   properties and their values/types
 *
 * @param capturePath
 *   This is the qualified name used to refer to specific elements in a record;
 *   a pound sign (#) is used to refer to plural elements with an id. The path
 *   of the root object is "/"
 *
 * @par Example:
 * The \c /primaryAddress/city refers to the city attribute of the primaryAddress object
 * The \c /profiles#1/username refers to the username attribute of the element in profiles with id=1
 *
 * @note 
 * The main difference between this method and the updateFromDictionary:withPath:(), is that
 * in this method  all the properties are replaced, and in updateFromDictionary:withPath:(),
 * they are only updated if the exist in the dictionary.  If the key does not exist in
 * the dictionary, the property is set to \e nil
 **/
- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;
/*@}*/

/**
 * @name Object Introspection
 **/
/*@{*/
/**
 * TODO: Doxygen doc
 **/
- (NSDictionary*)objectProperties;
/*@}*/

/**
 * @name Manage Remotely 
 **/
/*@{*/
/**
 * TODO: Doxygen doc
 **/
- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/**
 * TODO: Doxygen doc
 **/
- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;
/*@}*/

/**
 * @name Primitive Getters/Setters 
 **/
/*@{*/
/**
 * TODO
 **/
- (BOOL)getTesterBooleanBoolValue;

/**
 * TODO
 **/
- (void)setTesterBooleanWithBool:(BOOL)boolVal;

/**
 * TODO
 **/
- (NSInteger)getTesterIntegerIntegerValue;

/**
 * TODO
 **/
- (void)setTesterIntegerWithInteger:(NSInteger)integerVal;
/*@}*/

@end
