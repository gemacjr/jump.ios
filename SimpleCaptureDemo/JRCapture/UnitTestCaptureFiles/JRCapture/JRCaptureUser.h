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
#import "JRBasicPluralElement.h"
#import "JRBasicObject.h"
#import "JRObjectTestRequired.h"
#import "JRPluralTestUniqueElement.h"
#import "JRObjectTestRequiredUnique.h"
#import "JRPluralTestAlphabeticElement.h"
#import "JRSimpleStringPluralOneElement.h"
#import "JRSimpleStringPluralTwoElement.h"
#import "JRPinapL1PluralElement.h"
#import "JRPinoL1Object.h"
#import "JROnipL1PluralElement.h"
#import "JROinoL1Object.h"
#import "JRPinapinapL1PluralElement.h"
#import "JRPinonipL1PluralElement.h"
#import "JRPinapinoL1Object.h"
#import "JRPinoinoL1Object.h"
#import "JROnipinapL1PluralElement.h"
#import "JROinonipL1PluralElement.h"
#import "JROnipinoL1Object.h"
#import "JROinoinoL1Object.h"

/**
 * @brief A JRCaptureUser object
 **/
@interface JRCaptureUser : JRCaptureObject
@property (nonatomic, copy) NSString *email; /**< The object's \e email property */ 
@property (nonatomic, copy) JRBoolean *basicBoolean; /**< Basic boolean property for testing getting/setting with NSNumbers and primitives, updating, and replacing @note This is a property of type \ref types "boolean", which is a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>[NSNull null]</code> */ 
@property (nonatomic, copy) NSString *basicString; /**< Basic string property for testing getting/setting, updating, and replacing */ 
@property (nonatomic, copy) JRInteger *basicInteger; /**< Basic integer property for testing getting/setting with NSNumbers and primitives, updating, and replacing @note This is a property of type \ref types "integer", which is a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithInteger:<em>myInteger</em>]</code>, <code>[NSNumber numberWithInt:<em>myInt</em>]</code>, or <code>[NSNull null]</code> */ 
@property (nonatomic, copy) NSNumber *basicDecimal; /**< Basic decimal property for testing getting/setting with various NSNumbers, updating, and replacing */ 
@property (nonatomic, copy) JRDate *basicDate; /**< Basic date property for testing getting/setting with various formats, updating, and replacing @note This is a property of type \ref types "date", which is a typedef of \e NSDate. The accepted format should be an ISO8601 date string (e.g., <code>yyyy-MM-dd</code>) */ 
@property (nonatomic, copy) JRDateTime *basicDateTime; /**< Basic dateTime property for testing getting/setting with various formats, updating, and replacing @note This is a property of type \ref types "dateTime", which is a typedef of \e NSDate. The accepted format should be an ISO8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy) JRIpAddress *basicIpAddress; /**< Basic ipAddress property for testing getting/setting with various formats, updating, and replacing @note This is a property of type \ref types "ipAddress", which is a typedef of \e NSString. */ 
@property (nonatomic, copy) JRPassword *basicPassword; /**< Property used to test password strings, getting/setting with various formats, updating, and replacing @note This is a property of type \ref types "password", which can be either an \e NSString or \e NSDictionary, and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy) JRJsonObject *jsonNumber; /**< Property used to test json numbers, getting/setting with various formats, updating, and replacing @note This is a property of type \ref types "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy) JRJsonObject *jsonString; /**< Property used to test json strings, getting/setting with various formats, updating, and replacing @note This is a property of type \ref types "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy) JRJsonObject *jsonArray; /**< Property used to test json arrays, getting/setting with various formats, updating, and replacing @note This is a property of type \ref types "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy) JRJsonObject *jsonDictionary; /**< Property used to test json dictionaries, getting/setting with various formats, updating, and replacing @note This is a property of type \ref types "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy) NSString *stringTestJson; /**< Property used to test getting/setting, updating, and replacing strings that contain valid json objects, json characters, etc. */ 
@property (nonatomic, copy) NSString *stringTestEmpty; /**< Property used to test getting/setting, updating, and replacing empty strings */ 
@property (nonatomic, copy) NSString *stringTestNull; /**< Property used to test getting/setting, updating, and replacing null strings */ 
@property (nonatomic, copy) NSString *stringTestInvalid; /**< Property used to test getting/setting, updating, and replacing strings that contain special or dangerous characters */ 
@property (nonatomic, copy) NSString *stringTestNSNull; /**< Property used to test getting/setting, updating, and replacing [NSNull null] strings */ 
@property (nonatomic, copy) NSString *stringTestAlphanumeric; /**< Property used to test getting/setting, updating, and replacing strings that have the 'alphanumeric' constraint */ 
@property (nonatomic, copy) NSString *stringTestUnicodeLetters; /**< Property used to test getting/setting, updating, and replacing strings that have the 'unicode-letters' constraint */ 
@property (nonatomic, copy) NSString *stringTestUnicodePrintable; /**< Property used to test getting/setting, updating, and replacing strings that have the 'unicode-printable' constraint */ 
@property (nonatomic, copy) NSString *stringTestEmailAddress; /**< Property used to test getting/setting, updating, and replacing strings that have the 'email-address' constraint */ 
@property (nonatomic, copy) NSString *stringTestLength; /**< Property used to test getting/setting, updating, and replacing strings that have the length attribute defined */ 
@property (nonatomic, copy) NSString *stringTestCaseSensitive; /**< Property used to test getting/setting, updating, and replacing strings that have the case-sensitive attribute defined */ 
@property (nonatomic, copy) NSString *stringTestFeatures; /**< Property used to test getting/setting, updating, and replacing strings that have the features attribute defined */ 
@property (nonatomic, copy) NSArray *basicPlural; /**< Basic plural property for testing getting/setting, updating, and replacing @note This is an array of \c JRBasicPluralElement objects */ 
@property (nonatomic, copy) JRBasicObject *basicObject; /**< Basic object property for testing getting/setting, updating, and replacing */ 
@property (nonatomic, copy) JRObjectTestRequired *objectTestRequired; /**< Object for testing getting/setting, updating, and replacing properties when one property has the constraint of being required */ 
@property (nonatomic, copy) NSArray *pluralTestUnique; /**< Plural for testing getting/setting, updating, and replacing elements when one element property has the constraint of being unique @note This is an array of \c JRPluralTestUniqueElement objects */ 
@property (nonatomic, copy) JRObjectTestRequiredUnique *objectTestRequiredUnique; /**< Object for testing getting/setting, updating, and replacing properties when the properties have the constraints of being required and unique */ 
@property (nonatomic, copy) NSArray *pluralTestAlphabetic; /**< Plural for testing getting/setting, updating, and replacing elements when one element property has the constraint of being alphabetic @note This is an array of \c JRPluralTestAlphabeticElement objects */ 
@property (nonatomic, copy) NSArray *simpleStringPluralOne; /**< Plural property for testing getting/setting, updating, and replacing lists of strings/JRStringPluralElements @note This is an array of \c JRSimpleStringPluralOneElement objects */ 
@property (nonatomic, copy) NSArray *simpleStringPluralTwo; /**< Another plural property for testing getting/setting, updating, and replacing lists of strings/JRStringPluralElements @note This is an array of \c JRSimpleStringPluralTwoElement objects */ 
@property (nonatomic, copy) NSArray *pinapL1Plural; /**< Plural in a plural (element in a plural in an element in a plural) @note This is an array of \c JRPinapL1PluralElement objects */ 
@property (nonatomic, copy) JRPinoL1Object *pinoL1Object; /**< Plural in an object (element in a plural in an object) */ 
@property (nonatomic, copy) NSArray *onipL1Plural; /**< Object in a plural (object in an element in a plural) @note This is an array of \c JROnipL1PluralElement objects */ 
@property (nonatomic, copy) JROinoL1Object *oinoL1Object; /**< Object in a object */ 
@property (nonatomic, copy) NSArray *pinapinapL1Plural; /**< Plural in a plural in a plural (element in a plural in an element in a plural in an element in a plural) @note This is an array of \c JRPinapinapL1PluralElement objects */ 
@property (nonatomic, copy) NSArray *pinonipL1Plural; /**< Plural in an object in a plural (element in a plural in an object in an element in a plural) @note This is an array of \c JRPinonipL1PluralElement objects */ 
@property (nonatomic, copy) JRPinapinoL1Object *pinapinoL1Object; /**< Plural in a plural in an object (element in a plural in an element in a plural in an object) */ 
@property (nonatomic, copy) JRPinoinoL1Object *pinoinoL1Object; /**< Plural in an object in a object (element in a plural in an object in an object) */ 
@property (nonatomic, copy) NSArray *onipinapL1Plural; /**< Object in a plural in a plural (object in an element in a plural in an element in a plural) @note This is an array of \c JROnipinapL1PluralElement objects */ 
@property (nonatomic, copy) NSArray *oinonipL1Plural; /**< Object in an object in a plural (object in an object in an element in a plural) @note This is an array of \c JROinonipL1PluralElement objects */ 
@property (nonatomic, copy) JROnipinoL1Object *onipinoL1Object; /**< Object in a plural in an object (object in an element in a plural in an object) */ 
@property (nonatomic, copy) JROinoinoL1Object *oinoinoL1Object; /**< Object in an object in a object */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default constructor. Returns an empty JRCaptureUser object
 *
 * @return
 *   A JRCaptureUser object
 **/
- (id)init;

/**
 * Returns an empty JRCaptureUser object
 *
 * @return
 *   A JRCaptureUser object
 **/
+ (id)captureUser;

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
- (BOOL)isEqualToCaptureUser:(JRCaptureUser *)otherCaptureUser;
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
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceBasicPluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replacePluralTestUniqueArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replacePluralTestAlphabeticArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceSimpleStringPluralOneArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceSimpleStringPluralTwoArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replacePinapL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceOnipL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replacePinapinapL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replacePinonipL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceOnipinapL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceOinonipL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;

/**
 * TODO: Doxygen doc
 **/
- (BOOL)needsUpdate;
/*@}*/

/**
 * @name Primitive Getters/Setters 
 **/
/*@{*/
/**
 * TODO
 **/
- (BOOL)getBasicBooleanBoolValue;

/**
 * TODO
 **/
- (void)setBasicBooleanWithBool:(BOOL)boolVal;

/**
 * TODO
 **/
- (NSInteger)getBasicIntegerIntegerValue;

/**
 * TODO
 **/
- (void)setBasicIntegerWithInteger:(NSInteger)integerVal;
/*@}*/

@end
