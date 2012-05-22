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
#import "JRStringPluralElement.h"

/**
 * @brief A JRCaptureUser object
 **/
@interface JRCaptureUser : JRCaptureObject
@property (nonatomic, copy) JRObjectId *captureUserId; /**< Simple identifier for this entity @note The \e id of the object should not be set. // TODO: etc. */ 
@property (nonatomic, copy) JRUuid *uuid; /**< Globally unique indentifier for this entity @note This is a property of type 'uuid', which is a typedef of \e NSString */ 
@property (nonatomic, copy) JRDateTime *created; /**< When this entity was created @note This is a property of type 'dateTime', which is a typedef of \e NSDate. The accepted format should be an ISO8601 dateTime string (e.g., \c yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ) */ 
@property (nonatomic, copy) JRDateTime *lastUpdated; /**< When this entity was last updated @note This is a property of type 'dateTime', which is a typedef of \e NSDate. The accepted format should be an ISO8601 dateTime string (e.g., \c yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ) */ 
@property (nonatomic, copy) NSString *aboutMe; /**< The object's \e aboutMe property */ 
@property (nonatomic, copy) JRDate *birthday; /**< The object's birthday property @note This is a property of type 'date', which is a typedef of \e NSDate. The accepted format should be an ISO8601 date string (e.g., \c yyyy-MM-dd) */ 
@property (nonatomic, copy) NSString *currentLocation; /**< The object's \e currentLocation property */ 
@property (nonatomic, copy) JRJsonObject *display; /**< The object's \e display property @note This is a property of type 'json', which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy) NSString *displayName; /**< The name of this Contact, suitable for display to end-users. */ 
@property (nonatomic, copy) NSString *email; /**< The object's \e email property */ 
@property (nonatomic, copy) JRDateTime *emailVerified; /**< The object's emailVerified property @note This is a property of type 'dateTime', which is a typedef of \e NSDate. The accepted format should be an ISO8601 dateTime string (e.g., \c yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ) */ 
@property (nonatomic, copy) NSString *familyName; /**< The object's \e familyName property */ 
@property (nonatomic, copy) NSArray *games; /**< The object's \c games property @note This is an array of \c JRGames objects */ 
@property (nonatomic, copy) NSString *gender; /**< The object's \e gender property */ 
@property (nonatomic, copy) NSString *givenName; /**< The object's \e givenName property */ 
@property (nonatomic, copy) JRDateTime *lastLogin; /**< The object's lastLogin property @note This is a property of type 'dateTime', which is a typedef of \e NSDate. The accepted format should be an ISO8601 dateTime string (e.g., \c yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ) */ 
@property (nonatomic, copy) NSString *middleName; /**< The object's \e middleName property */ 
@property (nonatomic, copy) JRObjectLevelOne *objectLevelOne; /**< The object's objectLevelOne property */ 
@property (nonatomic, copy) NSArray *onipLevelOne; /**< The object's \c onipLevelOne property @note This is an array of \c JROnipLevelOne objects */ 
@property (nonatomic, copy) JRPassword *password; /**< The object's password property @note This is a property of type 'password', which can be either an \e NSString or \e NSDictionary, and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy) NSArray *photos; /**< The object's \c photos property @note This is an array of \c JRPhotos objects */ 
@property (nonatomic, copy) JRPinoLevelOne *pinoLevelOne; /**< The object's pinoLevelOne property */ 
@property (nonatomic, copy) NSArray *pluralLevelOne; /**< The object's \c pluralLevelOne property @note This is an array of \c JRPluralLevelOne objects */ 
@property (nonatomic, copy) JRPrimaryAddress *primaryAddress; /**< The object's primaryAddress property */ 
@property (nonatomic, copy) NSArray *profiles; /**< The object's \c profiles property @note This is an array of \c JRProfiles objects */ 
@property (nonatomic, copy) NSArray *statuses; /**< The object's \c statuses property @note This is an array of \c JRStatuses objects */ 
@property (nonatomic, copy) JRBoolean *testerBoolean; /**< The object's \e testerBoolean property @note This is a property of type 'boolean', which is a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:&gt;myBool&lt;]</code> or <code>[NSNull null]</code> */ 
@property (nonatomic, copy) JRInteger *testerInteger; /**< The object's testerInteger property @note This is a property of type 'integer', which is a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithInteger:&gt;myInteger&lt;]</code>, <code>[NSNumber numberWithInt:&gt;myInt&lt;]</code>, or <code>[NSNull null]</code> */ 
@property (nonatomic, copy) JRIpAddress *testerIpAddr; /**< The object's testerIpAddr property @note This is a property of type 'ipAddress', which is a typedef of \e NSString. */ 
@property (nonatomic, copy) JRStringArray *testerStringPlural; /**< The object's \c testerStringPlural property @note This is an array of \c JRStringPluralElements with type \c stringPluralItem TODO: Add note about how setting the array requires a replace on capture and how you can set it with an array of stringPluralElements or just an array of strings */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default constructor. Returns an empty JRCaptureUser object
 *
 * @return
 *   A JRCaptureUser object
 * 
 * @note
 * Method creates a JRCaptureUser object without the required properties TODO:MAKE A LIST!
 * These properties are required when updating the object on Capture.
 **/
- (id)init;

/**
 * Returns an empty JRCaptureUser object
 *
 * @return
 *   A JRCaptureUser object
 * 
 * @note
 * Method creates a JRCaptureUser object without the required properties TODO:MAKE A LIST!
 * These properties are required when updating the object on Capture.
 **/
+ (id)captureUser;

/**
 * Returns a JRCaptureUser object initialized with the given
 * *
 * @return
 *   A JRCaptureUser object initialized with the given
 *   If the required arguments are \e nil or \e [NSNull null], returns \e nil
 **/
- (id)initWithEmail:(NSString *)newEmail;

/**
 * Returns a JRCaptureUser object initialized with the given
 * *
 * @return
 *   A JRCaptureUser object initialized with the given
 *   If the required arguments are \e nil or \e [NSNull null], returns \e nil,
 **/
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
 * 
 * @note
 * Method creates a JRCaptureUser object without the required properties TODO:MAKE A LIST!
 * These properties are required when updating the object on Capture.
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
 * @note 
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
 * @note 
 * The main difference between this method and the updateFromDictionary:withPath:(), is that
 * in this method \e all the properties are replaced, and in updateFromDictionary:withPath:(),
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

/** * * TODO: DOXYGEN DOCS * **/
- (void)replaceGamesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/** * * TODO: DOXYGEN DOCS * **/
- (void)replaceOnipLevelOneArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/** * * TODO: DOXYGEN DOCS * **/
- (void)replacePhotosArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/** * * TODO: DOXYGEN DOCS * **/
- (void)replacePluralLevelOneArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/** * * TODO: DOXYGEN DOCS * **/
- (void)replaceProfilesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/** * * TODO: DOXYGEN DOCS * **/
- (void)replaceStatusesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/** * * TODO: DOXYGEN DOCS * **/
- (void)replaceTesterStringPluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;
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
