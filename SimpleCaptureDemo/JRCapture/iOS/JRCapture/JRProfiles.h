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

/**
 * @brief A JRProfiles object
 **/
@interface JRProfiles : JRCaptureObject
@property (nonatomic, copy) JRObjectId *profilesId; /**< Simple identifier for this sub-entity @note The \e id of the object should not be set. // TODO: etc. */ 
@property (nonatomic, copy) JRJsonObject *accessCredentials; /**< User's authorization credentials for this provider @note This is a property of type 'json', which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy) NSString *domain; /**< The object's \e domain property */ 
@property (nonatomic, copy) JRSimpleArray *followers; /**< User's followers @note This is an array of \c JRStringPluralElements with type \c identifier */ 
@property (nonatomic, copy) JRSimpleArray *following; /**< Who the user is following @note This is an array of \c JRStringPluralElements with type \c identifier */ 
@property (nonatomic, copy) JRSimpleArray *friends; /**< User's friends @note This is an array of \c JRStringPluralElements with type \c identifier */ 
@property (nonatomic, copy) NSString *identifier; /**< Profile provider unique identifier */ 
@property (nonatomic, copy) JRProfile *profile; /**< The object's profile property */ 
@property (nonatomic, copy) JRJsonObject *provider; /**< Provider for this profile @note This is a property of type 'json', which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy) NSString *remote_key; /**< PrimaryKey field from Engage */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Returns a JRProfiles object
 *
 * @return
 *   A JRProfiles object
 * 
 * @note
 * Method creates a JRProfiles object without the required properties TODO:MAKE A LIST!
 * These properties are required when updating the object on Capture.
 **/
- (id)init;

/**
 * Returns a JRProfiles object
 *
 * @return
 *   A JRProfiles object
 * 
 * @note
 * Method creates a JRProfiles object without the required properties TODO:MAKE A LIST!
 * These properties are required when updating the object on Capture.
 **/
+ (id)profiles;

/**
 * Returns a JRProfiles object
 * *
 * @return
 *   A JRProfiles object initialized with the given
 *   If the required arguments are \e nil or \e [NSNull null], returns \e nil
 **/
- (id)initWithDomain:(NSString *)newDomain andIdentifier:(NSString *)newIdentifier;

/**
 * Returns a JRProfiles object
 * *
 * @return
 *   A JRProfiles object initialized with the given
 *   If the required arguments are \e nil or \e [NSNull null], returns \e nil,
 **/
+ (id)profilesWithDomain:(NSString *)domain andIdentifier:(NSString *)identifier;

/**
 * Returns a JRProfiles object created from an \e NSDictionary representing the object
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
 *   A JRProfiles object
 * 
 * @note
 * Method creates a JRProfiles object without the required properties TODO:MAKE A LIST!
 * These properties are required when updating the object on Capture.
 **/
+ (id)profilesObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;
/*@}*/

/**
 * @name Dictionary Serialization/Deserialization
 **/
/*@{*/
/**
 * Creates an  NSDictionary represention of a JRProfiles object
 * populated with all of the object's properties, as the dictionary's 
 * keys, and the properties' values as the dictionary's values
 *
 * @return
 *   An \e NSDictionary representation of a JRProfiles object
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
/**
 * TODO: Doxygen doc
 **/
- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/**
 * TODO: Doxygen doc
 **/
- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;
/*@}*/

@end
