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

/**
 * @brief Basic plural property for testing getting/setting, updating, and replacing
 **/
@interface JRBasicPluralElement : JRCaptureObject
@property (nonatomic, copy)   NSString *string1; /**< The object's \e string1 property */ 
@property (nonatomic, copy)   NSString *string2; /**< The object's \e string2 property */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default constructor. Returns an empty JRBasicPluralElement object
 *
 * @return
 *   A JRBasicPluralElement object
 **/
- (id)init;

/**
 * Returns an empty JRBasicPluralElement object
 *
 * @return
 *   A JRBasicPluralElement object
 **/
+ (id)basicPluralElement;

/**
 * Returns a JRBasicPluralElement object created from an \e NSDictionary representing the object
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
 *   A JRBasicPluralElement object
 **/
+ (id)basicPluralElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath;
/*@}*/

/**
 * @name Dictionary Serialization/Deserialization
 **/
/*@{*/
/**
 * Creates an  NSDictionary represention of a JRBasicPluralElement object
 * populated with all of the object's properties, as the dictionary's 
 * keys, and the properties' values as the dictionary's values
 *
 * @return
 *   An \e NSDictionary representation of a JRBasicPluralElement object
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
- (BOOL)isEqualToBasicPluralElement:(JRBasicPluralElement *)otherBasicPluralElement;
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
- (BOOL)needsUpdate;
/*@}*/

@end
