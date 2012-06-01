#!/usr/bin/perl

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Copyright (c) 2012, Janrain, Inc.
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation and/or
#   other materials provided with the distribution.
# * Neither the name of the Janrain, Inc. nor the names of its
#   contributors may be used to endorse or promote products derived from this
#   software without specific prior written permission.
#
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# File:   ObjCMethodParts.pl
# Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
# Date:   Wednesday, February 8, 2012
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

###################################################################
# OBJC METHODS TO BE POPULATED WITH PROPERTIES
###################################################################

###################################################################
# MINIMUM INSTANCE CONSTRUCTOR (W/O REQUIRED PROPERTIES)
#
#                                          (Section only here when there are required properties)     
#                                                                        |
# /**                                                                    |
#  * Default constructor. Returns an empty <objectClass> object.         |
#  *                                                                     |
#  * @return                                                             |
#  *   A <objectClass> object                                            |
#  *                                                                     |
#  * @note Method creates a <objectClass> object without the required    |
#  * properties <requiredProperties>.  These properties are required  <--+
#  * when updating the object on Capture.
#  **/
# - (id)init
# {                                                              
#     if ((self = [super init]))                                 
#     {     
#         self.captureObjectPath = @"<entity_path>";
#         self.canBeUpdatedOrReplaced = <YES_or_NO>;\n
#     }
#
#     return self;
# }
###################################################################

my @minConstructorDocParts = (
"/**
 * Default constructor. Returns an empty ",""," object
 *
 * \@return
 *   A ",""," object\n",
"", 
" **/\n");

my @minConstructorParts = (
"- (id)init",
"\n{\n",
"    if ((self = [super init]))
    {\n",
    "",
"    }
    return self;
}\n\n");


###################################################################
# INSTANCE CONSTRUCTOR (W REQUIRED PROPERTIES)
# (Method only here when there are required properties)
# 
# /**
#  * Returns a <objectClass> object initialized with the given <requiredProperties>
#  *
#  * @param <requiredProperty>
#  *   <requiredPropertyDescription>
#  *
#  * @return
#  *   A <objectClass> object initialized with the given <requiredProperties>
#  *   If the required arguments are \e nil or \e [NSNull null], returns \e nil
#  **/
# - (id)init<requiredProperties>
# {
#     if(!<requriredProperties>)
#     {                         
#       [self release];         
#       return nil;             
#     }                         
#                               
#     if ((self = [super init]))
#     {                         
#         self.captureObjectPath = @"<entity_path>";         
#                                                            
#         <requiredProperty> = [new<requiredProperty> copy]; 
#           ...
#     }
#
#     return self;
# }
###################################################################

my @constructorDocParts = (
"/**
 * Returns a ",""," object initialized with the given","","
 *",
"", 
" *
 * \@return
 *   A ",""," object initialized with the given","","\n",
" *   If the required arguments are \\e nil or \\e [NSNull null], returns \\e nil
 **/\n");

my @constructorParts = (
"- (id)init","",
"\n{\n",
"    if (","",")\n",
"    {
        [self release];
        return nil;
     }\n\n",
"    if ((self = [super init]))
    {\n",
    "",
"    }
    return self;
}\n\n");


###################################################################
# MINIMUN CLASS CONSTRUCTOR (W/O REQUIRED PROPERTIES)
#
#                      (Section only here when there are required properties)     
#                                               |
# /**                                           |
#  * Returns an empty <objectClass> object      |
#  *                                            |
#  * @return                                    |
#  *   A <objectClass> object                   |
#  *                                            V
#  * @note Method creates a <objectClass> object without the required
#  * properties <requiredProperties>.  These properties are required
#  * when updating the object on Capture.
#  **/
# + (id)<objectName>    
# {                                             
#     return [[[<className> alloc] init] autorelease]; 
# }
###################################################################

my @minClassConstructorDocParts = (
"/**
 * Returns an empty ",""," object
 *
 * \@return
 *   A ",""," object\n",
"", 
" **/\n");

my @minClassConstructorParts = (
"+ (id)","",
"\n{\n",
"    return [[[",""," alloc] init] autorelease];",
"\n}\n\n"); 

###################################################################
# CLASS CONSTRUCTOR (W REQUIRED PROPERTIES)
# (Method only here when there are required properties)
# 
# /**
#  * Returns a <objectClass> object initialized with the given <requiredProperties>
#  *
#  * @param <requiredProperty>
#  *   <requiredPropertyDescription>
#  *
#  * @return
#  *   A <objectClass> object initialized with the given <requiredProperties>
#  *   If the required arguments are \e nil or \e [NSNull null], returns \e nil
#  **/
# + (id)<objectName><requiredProperties>        
# {                                             
#     return [[[<className> alloc] init<requiredProperties>] autorelease]; 
# }
###################################################################

my @classConstructorDocParts = (
"/**
 * Returns a ",""," object initialized with the given","","
 *",
"", 
" *
 * \@return
 *   A ",""," object initialized with the given","","\n",
" *   If the required arguments are \\e nil or \\e [NSNull null], returns \\e nil,
 **/\n");

my @classConstructorParts = (
"+ (id)","","", 
"\n{\n",
"    return [[[",""," alloc] init","","] autorelease];",
"\n}\n\n"); 


###################################################################
# COPY CONSTRUCTOR (W REQUIRED PROPERTIES)
#
# - (id)copyWithZone:(NSZone*)zone         (Section only here when there are required properties)     
# {                                                               |
#     <className> *<object>Copy =                                 V
#                 [[<className> allocWithZone:zone] init<requiredProperties>];
#
#     <object>Copy.<property> = self.<property>;
#       ...
#
#     <object>Copy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
#
#     [<object>Copy.dirtyPropertySet setSet:self.dirtyPropertySet];
#     [<object>Copy.dirtyArraySet setSet:self.dirtyPropertySet];
#
#     return <object>Copy;
# }
###################################################################

my @copyConstructorParts = (
"- (id)copyWithZone:(NSZone*)zone",
"\n{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS\n", 
""," allocWithZone:zone] init","","];\n\n",
"    ","",".captureObjectPath = self.captureObjectPath;\n\n",
"", 
"    // TODO: Necessary??
    ","",".canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    // TODO: Necessary??
    [","",".dirtyPropertySet setSet:self.dirtyPropertySet];
    [","",".dirtyArraySet setSet:self.dirtyArraySet];
",
"\n    return ","",";",
"\n}\n\n");


###################################################################
# MAKE OBJECT FROM DICTIONARY
#                                               
# /**                                           
#  * Returns a <objectClass> object created from an \\e NSDictionary
#  * representing the object
#  *
#  * @param dictionary
#  *   An \e NSDictionary containing keys/values which map the the object's 
#  *   properties and their values/types.  This value cannot be nil
#  *
#  * @param capturePath
#  *   This is the qualified name used to refer to specific elements in a record;
#  *   a pound sign (#) is used to refer to plural elements with an id. The path
#  *   of the root object is "/"
#  *
#  * @par Example:
#  * The \c /primaryAddress/city refers to the city attribute of the primaryAddress object
#  * The \c /profiles#1/username refers to the username attribute of the element in profiles with id=1
#  *                                            
#  * @return                                              (Section only here when there are required properties)
#  *   A <objectClass> object created from an \e NSDictionary.                       |
#  *   If the \e NSDictionary is \e nil, returns \e nil                              |
#  *                                                                                 |
#  * @note Method creates a <objectClass> object without the required                |
#  * properties <requiredProperties>.  These properties are required  <--------------+
#  * when updating the object on Capture.
#  **/
# + (id)<objectName>ObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
# {
#     if (!dictionary)
#         return nil;
#                                                                     For elements in a plural
#     <className> *<object> = [<className> <object>];                             |
#                                                                                 V
#     <object>.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"<object>", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
#     self.canBeUpdatedOrReplaced = YES; 
#
#     <object>.<property> = [dictionary objectForKey:@"<property>"] != [NSNull null] ? 
#                                   [dictionary objectForKey:@"<property>"] : nil;
#       OR
#     <object>.<property> = [dictionary objectForKey:@"<property>"] != [NSNull null] ? 
#                                   [<propertyFromDictionaryMethod>:[dictionary objectForKey:@"<property>"]] : nil;
#       ...
#
#     [<object>.dirtyPropertySet removeAllObjects];
#     [<object>.dirtyArraySet removeAllObjects];
#
#     return <object>;
# }
###################################################################

my @fromDictionaryDocParts = (
"/**
 * Returns a ",""," object created from an \\e NSDictionary representing the object
 *
 * \@param dictionary
 *   An \\e NSDictionary containing keys/values which map the the object's 
 *   properties and their values/types.  This value cannot be nil
 *
 * \@param capturePath
 *   This is the qualified name used to refer to specific elements in a record;
 *   a pound sign (#) is used to refer to plural elements with an id. The path
 *   of the root object is \"/\"
 *
 * \@par Example:
 * The \\c /primaryAddress/city refers to the city attribute of the primaryAddress object
 * The \\c /profiles#1/username refers to the username attribute of the element in profiles with id=1
 *
 * \@return
 *   A ",""," object\n",
"", 
" **/\n");

my @fromDictionaryParts = (
"+ (id)","","ObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath",
"\n{\n",
"    if (!dictionary)\n        return nil;\n\n",
""," = [","","];\n\n",
"    ","",".captureObjectPath = [NSString stringWithFormat:\@\"%@/%@","","\", capturePath, ","","","];\n",
"",
"
    [","",".dirtyPropertySet removeAllObjects];
    [","",".dirtyArraySet removeAllObjects];
    
    return ","",";",
"\n}\n\n");


###################################################################
# MAKE DICTIONARY FROM OBJECT
#
# /**
#  * Creates an \e NSDictionary represention of a <objectClass> object
#  * populated with all of the object's properties, as the dictionary's 
#  * keys, and the properties' values as the dictionary's values
#  *
#  * \@return
#  *   An \e NSDictionary represention of a <objectClass> object
#  **/
# - (NSDictionary*)toDictionary
# {
#     NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
#
#     [dict setObject:(<property> ? <property> : [NSNull null]) forKey:@"<propertyKey>"];
#       OR
#     [dict setObject:(<property> ? <propertyToDictionaryMethod> : [NSNull null]) forKey:@"<propertyKey>"];
#       ...
#
#     return [NSDictionary dictionaryWithDictionary:dict];
#  }
###################################################################

my @toDictionaryDocParts = (
"/**
 * Creates an \e NSDictionary represention of a ",""," object
 * populated with all of the object's properties, as the dictionary's 
 * keys, and the properties' values as the dictionary's values
 *
 * \@return
 *   An \\e NSDictionary representation of a ",""," object\n",
" **/\n");

my @toDictionaryParts = (
"- (NSDictionary*)toDictionary",
"\n{\n",
"    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];\n\n",
"", 
"\n    return [NSDictionary dictionaryWithDictionary:dict];",
"\n}\n\n");


###################################################################
# UPDATE CURRENT OBJECT FROM A NEW DICTIONARY
#
# /**
#  * @internal
#  * Updates the object from an \e NSDictionary populated with some of the object's
#  * properties, as the dictionary's keys, and the properties' values as the dictionary's values.
#  * This method is used by other JRCaptureObjects and should not be used by consumers of the 
#  * mobile Capture library
#  *
#  * @param dictionary
#  *   An \e NSDictionary containing keys/values which map the the object's 
#  *   properties and their values/types
#  *
#  * @param capturePath
#  *   This is the qualified name used to refer to specific elements in a record;
#  *   a pound sign (#) is used to refer to plural elements with an id. The path
#  *   of the root object is "/"
#  *
#  * @par Example:
#  * The \c /primaryAddress/city refers to the city attribute of the primaryAddress object
#  * The \c /profiles#1/username refers to the username attribute of the element in profiles with id=1
#  *
#  * @note 
#  * The main difference between this method and the replaceFromDictionary:withPath:(), is that
#  * in this method properties are only updated if they exist in the dictionary, and in 
#  * replaceFromDictionary:withPath:(), all properties are replaced.  Even if the value is \e [NSNull null]
#  * so long as the key exists in the dictionary, the property is updated.
#  **/
# - (void)updateFromDictionary:(NSDictionary *)dictionary withPath:(NSString *)capturePath
# {
#     self.canBeUpdatedOrReplaced = YES;
#
#     NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
#     NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];
#
#     self.canBeUpdatedOrReplaced = YES;
#     self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"<object>", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
#
#     if ([dictionary objectForKey:@"<property>"])
#         self.<property> = [dictionary objectForKey:@"<property>"] != [NSNull null] ? 
#                                       [dictionary objectForKey:@"<property>"] : nil;
#           OR
#         self.<property> = [dictionary objectForKey:@"<property>"] != [NSNull null] ? 
#                                       [<propertyFromDictionaryMethod>:[dictionary objectForKey:@"<property>"]] : nil;
#           ...
#
#     [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
#     [self.dirtyArraySet setSet:dirtyArraySetCopy];
# }
###################################################################

my @updateFrDictDocParts = (
"/**
 * \@internal
 * Updates the object from an \\e NSDictionary populated with some of the object's
 * properties, as the dictionary's keys, and the properties' values as the dictionary's values. 
 * This method is used by other JRCaptureObjects and should not be used by consumers of the 
 * mobile Capture library
 *
 * \@param dictionary
 *   An \\e NSDictionary containing keys/values which map the the object's 
 *   properties and their values/types
 *
 * \@param capturePath
 *   This is the qualified name used to refer to specific elements in a record;
 *   a pound sign (#) is used to refer to plural elements with an id. The path
 *   of the root object is \"/\"
 *
 * \@par Example:
 * The \\c /primaryAddress/city refers to the city attribute of the primaryAddress object
 * The \\c /profiles#1/username refers to the username attribute of the element in profiles with id=1
 *
 * \@note 
 * The main difference between this method and the replaceFromDictionary:withPath:(), is that
 * in this method properties are only updated if they exist in the dictionary, and in 
 * replaceFromDictionary:withPath:(), all properties are replaced.  Even if the value is \\e [NSNull null]
 * so long as the key exists in the dictionary, the property is updated.
 **/\n");

my @updateFrDictParts = (
"- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath",
"\n{\n    DLog(@\"\%\@ \%\@\", capturePath, [dictionary description]);\n","
    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;\n",
"    self.captureObjectPath = [NSString stringWithFormat:\@\"%@/%@","","\", capturePath, ","","","];\n",
"","
    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}\n\n");


###################################################################
# REPLACE CURRENT OBJECT FROM A NEW DICTIONARY
#
# /**
#  * @internal
#  * Replaces the object from an \e NSDictionary populated with some or all of the object's
#  * properties, as the dictionary's keys, and the properties' values as the dictionary's values.
#  * This method is used by other JRCaptureObjects and should not be used by consumers of the 
#  * mobile Capture library
#  *
#  * @param dictionary
#  *   An \e NSDictionary containing keys/values which map the the object's 
#  *   properties and their values/types
#  *
#  * @param capturePath
#  *   This is the qualified name used to refer to specific elements in a record;
#  *   a pound sign (#) is used to refer to plural elements with an id. The path
#  *   of the root object is "/"
#  *
#  * @par Example:
#  * The \c /primaryAddress/city refers to the city attribute of the primaryAddress object
#  * The \c /profiles#1/username refers to the username attribute of the element in profiles with id=1
#  *
#  * @note 
#  * The main difference between this method and the updateFromDictionary:withPath:(), is that
#  * in this method \e all the properties are replaced, and in updateFromDictionary:withPath:(),
#  * they are only updated if the exist in the dictionary.  If the key does not exist in
#  * the dictionary, the property is set to \e nil
#  **/
# - (void)replaceFromDictionary:(NSDictionary *)dictionary withPath:(NSString *)capturePath
# {
#     NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
#     NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];
#
#     self.canBeUpdatedOrReplaced = YES;
#     self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"<object>", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
#
#     self.<property> = [dictionary objectForKey:@"<property>"] != [NSNull null] ? 
#                                   [dictionary objectForKey:@"<property>"] : nil;
#       OR
#     self.<property> = [dictionary objectForKey:@"<property>"] != [NSNull null] ? 
#                                   [<propertyFromDictionaryMethod>:[dictionary objectForKey:@"<property>"]] : nil;
#       ...
#     [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
#     [self.dirtyArraySet setSet:dirtyArraySetCopy];
# }
###################################################################

my @replaceFrDictDocParts = (
"/**
 * \@internal
 * Replaces the object from an \\e NSDictionary populated with some or all of the object's
 * properties, as the dictionary's keys, and the properties' values as the dictionary's values.
 * This method is used by other JRCaptureObjects and should not be used by consumers of the 
 * mobile Capture library
 *
 * \@param dictionary
 *   An \\e NSDictionary containing keys/values which map the the object's 
 *   properties and their values/types
 *
 * \@param capturePath
 *   This is the qualified name used to refer to specific elements in a record;
 *   a pound sign (#) is used to refer to plural elements with an id. The path
 *   of the root object is \"/\"
 *
 * \@par Example:
 * The \\c /primaryAddress/city refers to the city attribute of the primaryAddress object
 * The \\c /profiles#1/username refers to the username attribute of the element in profiles with id=1
 *
 * \@note 
 * The main difference between this method and the updateFromDictionary:withPath:(), is that
 * in this method \\e all the properties are replaced, and in updateFromDictionary:withPath:(),
 * they are only updated if the exist in the dictionary.  If the key does not exist in
 * the dictionary, the property is set to \\e nil
 **/\n");

my @replaceFrDictParts = (
"- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath",
"\n{\n    DLog(@\"\%\@ \%\@\", capturePath, [dictionary description]);\n","
    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;\n",
"    self.captureObjectPath = [NSString stringWithFormat:\@\"%@/%@","","\", capturePath, ","","","];\n",
"","
    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}\n\n");

###################################################################
# UPDATE OBJECT ON CAPTURE
#
# - (NSDictionary *)toUpdateDictionary
# {
#     NSMutableDictionary *dict =
#          [NSMutableDictionary dictionaryWithCapacity:10];
# 
#     if ([self.dirtyPropertySet containsObject:@"<property>"])
#         [dict setObject:(self.<property> ? self.<property> : [NSNull null]) forKey:@"<property>"];
#           OR
#         [dict setObject:(self.<property> ? <propertyToUpdateDictionaryMethod> : [NSNull null]) forKey:@"<property>"];
# 
#     return dict;
# }
# 
# /**
#  * TODO: Doxygen doc
#  **/
# - (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
# {
#     NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
#                                                      context, @"callerContext",
#                                                      delegate, @"delegate",
#                                                      context, @"callerContext", nil];
# 
#     [JRCaptureInterface updateCaptureObject:[self toUpdateDictionary]
#                                      withId:self.<objectName>Id OR 0
#                                      atPath:self.captureObjectPath
#                                   withToken:[JRCaptureData accessToken]
#                                 forDelegate:self
#                                 withContext:newContext];
# }
###################################################################

my @updateRemotelyDocParts = (
"/**
 * TODO: Doxygen doc
 **/\n");

my @toUpdateDictionaryParts = (
"- (NSDictionary *)toUpdateDictionary",
"\n{\n",
"    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];\n",
"",         
"\n    return dict;",
"\n}\n\n");

#my @updateRemotelyParts = (
#"- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context",
#"\n{\n",
#"    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
#                                                     self, \@\"captureObject\",
#                                                     self.captureObjectPath, \@\"capturePath\",
#                                                     delegate, \@\"delegate\",
#                                                     context, \@\"callerContext\", nil];
#
#    [JRCaptureInterface updateCaptureObject:[self toUpdateDictionary]
#//                                     withId:
#                                     atPath:self.captureObjectPath
#                                  withToken:[JRCaptureData accessToken]
#                                forDelegate:self
#                                withContext:newContext];",
#"\n}\n\n");


###################################################################
# REPLACE OBJECT ON CAPTURE
#
# - (NSDictionary *)toReplaceDictionary
# {
#     NSMutableDictionary *dict =
#          [NSMutableDictionary dictionaryWithCapacity:10];
# 
#     [dict setObject:(self.<property> ? self.<property> : [NSNull null]) forKey:@"<property>"];
#       OR
#     [dict setObject:(self.<property> ? <propertyToUpdateDictionaryMethod> : [NSNull null]) forKey:@"<property>"];
# 
#     return dict;
# }
# 
# /**
#  * TODO: Doxygen doc
#  **/
# - (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
# {
#     NSMutableDictionary *dict =
#         [NSMutableDictionary dictionaryWithCapacity:10];
# 
#     NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
#                                                      self, @"captureObject",
#                                                      delegate, @"delegate",
#                                                      context, @"callerContext", nil];
# 
#     [JRCaptureInterface updateCaptureObject:[self toReplaceDictionary]
#                                      withId:self.<objectName>Id OR 0
#                                      atPath:self.captureObjectPath
#                                   withToken:[JRCaptureData accessToken]
#                                 forDelegate:self
#                                 withContext:newContext];
# }
###################################################################

my @replaceRemotelyDocParts = (
"/**
 * TODO: Doxygen doc
 **/\n");

my @toReplaceDictionaryParts = (
"- (NSDictionary *)toReplaceDictionary",
"\n{\n",
"    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];\n\n",
"",         
"\n    return dict;",
"\n}\n\n");

#my @replaceRemotelyParts = (
#"- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context",
#"\n{\n",
#"    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
#                                                     self, \@\"captureObject\",
#                                                     self.captureObjectPath, \@\"capturePath\",
#                                                     delegate, \@\"delegate\",
#                                                     context, \@\"callerContext\", nil];
#
#    [JRCaptureInterface replaceCaptureObject:[self toReplaceDictionary]
#//                                      withId:
#                                      atPath:self.captureObjectPath
#                                   withToken:[JRCaptureData accessToken]
#                                 forDelegate:self
#                                 withContext:newContext];",
#"\n}\n\n");


###################################################################
# RECURSIVE CHECK IF OBJECT NEEDS UPDATE
#
# /**
#  * TODO: Doxygen doc
#  **/
# - (BOOL)needsUpdate
# {
#     if ([dirtyPropertiesSet count])
#         return YES;
#
#     if ([self.<objectProperty> needsUpdate])
#         return YES;
#       ...
#
#     return NO;    
# }
###################################################################

my @needsUpdateDocParts = (
"/**
 * TODO: Doxygen doc
 **/\n");
 
my @needsUpdateParts = (
"- (BOOL)needsUpdate",
"\n{\n",
"    if ([self.dirtyPropertySet count])
         return YES;\n\n",
"",
"    return NO;",
"\n}\n\n");


###################################################################
# MAKE DICTIONARY OF OBJECT'S PROPERTIES
#
# /**
#  * TODO: Doxygen doc
#  **/
# - (NSDictionary*)objectProperties
# {
#     NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
#
#     [dict setObject:@"<propertyType>" forKey:@"<propertyName>"];
#
#     return [NSDictionary dictionaryWithDictionary:dict];
#  }
###################################################################

my @objectPropertiesDocParts = (
"/**
 * TODO: Doxygen doc
 **/\n");
 
my @objectPropertiesParts = (
"- (NSDictionary*)objectProperties",
"\n{\n",
"    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];\n\n",
"", 
"\n    return [NSDictionary dictionaryWithDictionary:dict];",
"\n}\n\n");


###################################################################
# DESTRUCTOR
#
# - (void)dealloc
# {
#     [<property> release];
#       ...
# 
#     [super dealloc];
# }
###################################################################

my @destructorParts = (
"- (void)dealloc",
"\n{\n",
"", 
"\n    [super dealloc];",
"\n}\n");


my $copyrightHeader = 
"/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
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


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */\n\n";


my @doxygenClassDescParts = (
"/**
 * \@brief ","", 
"\n **/\n");


sub createArrayCategoryForSubobject { 
  my $propertyName = $_[0];
  
  my $arrayCategoryIntf = "\@interface NSArray (" . ucfirst($propertyName) . "ToFromDictionary)\n";
  my $arrayCategoryImpl = "\@implementation NSArray (" . ucfirst($propertyName) . "ToFromDictionary)\n";

  my $methodName1 = "- (NSArray*)arrayOf" . ucfirst($propertyName) . "ObjectsFrom" . ucfirst($propertyName) . "DictionariesWithPath:(NSString*)capturePath";
  my $methodName2 = "- (NSArray*)arrayOf" . ucfirst($propertyName) . "DictionariesFrom" . ucfirst($propertyName) . "Objects";
  my $methodName3 = "- (NSArray*)arrayOf" . ucfirst($propertyName) . "ReplaceDictionariesFrom" . ucfirst($propertyName) . "Objects";
  

  $arrayCategoryIntf .= "$methodName1;\n$methodName2;\n$methodName3;\n\@end\n\n";
  
  $arrayCategoryImpl .= "$methodName1\n{\n";
  $arrayCategoryImpl .=        
       "    NSMutableArray *filtered" . ucfirst($propertyName) . "Array = [NSMutableArray arrayWithCapacity:[self count]];\n" . 
       "    for (NSObject *dictionary in self)\n" . 
       "        if ([dictionary isKindOfClass:[NSDictionary class]])\n" . 
       "            [filtered" . ucfirst($propertyName) . "Array addObject:[JR" . ucfirst($propertyName) . "Element " . $propertyName . "ObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];\n\n" . 
       "    return filtered" . ucfirst($propertyName) . "Array;\n}\n\n";
       
  $arrayCategoryImpl .= "$methodName2\n{\n";
  $arrayCategoryImpl .=        
       "    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];\n" . 
       "    for (NSObject *object in self)\n" . 
       "        if ([object isKindOfClass:[JR" . ucfirst($propertyName) . "Element class]])\n" . 
       "            [filteredDictionaryArray addObject:[(JR" . ucfirst($propertyName) . "Element*)object toDictionary]];\n\n" . 
       "    return filteredDictionaryArray;\n}\n\n";

  $arrayCategoryImpl .= "$methodName3\n{\n";
  $arrayCategoryImpl .=        
       "    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];\n" . 
       "    for (NSObject *object in self)\n" . 
       "        if ([object isKindOfClass:[JR" . ucfirst($propertyName) . "Element class]])\n" . 
       "            [filteredDictionaryArray addObject:[(JR" . ucfirst($propertyName) . "Element*)object toReplaceDictionary]];\n\n" . 
       "    return filteredDictionaryArray;\n}\n\@end\n\n";

  return "$arrayCategoryIntf$arrayCategoryImpl";
}

sub createArrayReplaceMethodDeclaration { 
  my $propertyName = $_[0];

  my $methodDeclaration = 
       "\n"  .
       "/**\n" . 
       " * TODO: DOXYGEN DOCS\n" . 
       " **/\n" . 
       "- (void)replace" . ucfirst($propertyName) . "ArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context;\n";

  return $methodDeclaration;
}

sub createArrayReplaceMethodImplementation { 
  my $propertyName = $_[0];
  my $elementType   = $_[1];

  my $methodImplementation;
  if ($elementType) { # Indicates that the array is a simple array of strings
    $methodImplementation = 
       "- (void)replace" . ucfirst($propertyName) . "ArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context\n" . 
       "{\n" . 
       "    [self replaceSimpleArrayOnCapture:self." . $propertyName . " ofType:\@\"" . $elementType . "\" named:\@\"" . $propertyName . "\"\n" .
       "                          forDelegate:delegate withContext:context];\n" . 
       "}\n\n";
  } else {
    $methodImplementation = 
       "- (void)replace" . ucfirst($propertyName) . "ArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context\n" . 
       "{\n" . 
       "    [self replaceArrayOnCapture:self." . $propertyName . " named:\@\"" . $propertyName . "\"\n" . 
       "                    forDelegate:delegate withContext:context];\n" . 
       "}\n\n";
  }

  return $methodImplementation;
}

sub createGetterSetterForProperty {
  my $propertyName  = $_[0];
  my $propertyType  = $_[1];
  my $isBoolOrInt   = $_[2];
  my $isArray       = $_[3];
  my $getter;
  my $setter;
  my $primitiveGetter = "";
  my $primitiveSetter = "";
  
  $getter = "- (" . $propertyType . ")" . $propertyName;
  
  $getter .= "\n{\n";
  $getter .= "    return _" . $propertyName . ";";
  $getter .= "\n}\n\n";
  
  $setter .= "- (void)set". ucfirst($propertyName) . ":(" . $propertyType . ")new" . ucfirst($propertyName); 
  $setter .= "\n{\n";

  if ($isArray) {
    $setter .= "    [self.dirtyArraySet addObject:@\"" . $propertyName . "\"];\n";
  } else {
    $setter .= "    [self.dirtyPropertySet addObject:@\"" . $propertyName . "\"];\n";
  }
  
  $setter .= "    _" . $propertyName .  " = [new" . ucfirst($propertyName) . " copy];";    
  $setter .= "\n}\n\n";

  if ($isBoolOrInt eq "b") {
  
    $primitiveGetter .= "- (BOOL)get" . ucfirst($propertyName) . "BoolValue";
    $primitiveGetter .= "\n{\n";
    $primitiveGetter .= "    return [_" . $propertyName .  " boolValue];";    
    $primitiveGetter .= "\n}\n\n";
    
    $primitiveSetter .= "- (void)set" . ucfirst($propertyName) . "WithBool:(BOOL)boolVal";
    $primitiveSetter .= "\n{\n";
    $primitiveSetter .= "    [self.dirtyPropertySet addObject:@\"" . $propertyName . "\"];\n";
  
    $primitiveSetter .= "    _" . $propertyName .  " = [NSNumber numberWithBool:boolVal];";    
    $primitiveSetter .= "\n}\n\n";

  } elsif ($isBoolOrInt eq "i") {

    $primitiveGetter .= "- (NSInteger)get" . ucfirst($propertyName) . "IntegerValue";
    $primitiveGetter .= "\n{\n";
    $primitiveGetter .= "    return [_" . $propertyName .  " integerValue];";    
    $primitiveGetter .= "\n}\n\n";
    
    $primitiveSetter .= "- (void)set" . ucfirst($propertyName) . "WithInteger:(NSInteger)integerVal";
    $primitiveSetter .= "\n{\n";
    $primitiveSetter .= "    [self.dirtyPropertySet addObject:@\"" . $propertyName . "\"];\n";
  
    $primitiveSetter .= "    _" . $propertyName .  " = [NSNumber numberWithInteger:integerVal];";    
    $primitiveSetter .= "\n}\n\n";
    
  }

  return $getter . $setter . $primitiveGetter . $primitiveSetter;
}

sub createGetterSetterForSimpleArray {
  my $propertyName  = $_[0];
  my $pluralType    = $_[1];
  my $getter;
  my $setter;
  
  $getter = "- (NSArray *)" . $propertyName;
  
  $getter .= "\n{\n";
  $getter .= "    return _" . $propertyName . ";";
  $getter .= "\n}\n\n";
  
  $setter .= "- (void)set". ucfirst($propertyName) . ":(NSArray *)new" . ucfirst($propertyName); 
  $setter .= "\n{\n";
  $setter .= "    [self.dirtyArraySet addObject:@\"" . $propertyName . "\"];\n";

#   $setter .= "    if (!new" . ucfirst($propertyName) . ")\n";
#   $setter .= "        _" . $propertyName .  " = [NSNull null];\n";  
#   $setter .= "    else\n";
  $setter .= "    _" . $propertyName .  " = ";
  $setter .= "[new" . ucfirst($propertyName) . " copyArrayOfStringPluralElementsWithType:\@\"" . $pluralType . "\"];";  
  
  $setter .= "\n}\n\n";

  return $getter . $setter;
}

sub getMinConstructorParts {
  return @minConstructorParts;
}

sub getConstructorParts {
  return @constructorParts;
}

sub getMinClassConstructorParts {
  return @minClassConstructorParts;
}

sub getClassConstructorParts {
  return @classConstructorParts;
}

sub getCopyConstructorParts {
  return @copyConstructorParts;
}

sub getToDictionaryParts {
  return @toDictionaryParts;
}

sub getFromDictionaryParts {
  return @fromDictionaryParts;
}

sub getUpdateFromDictParts {
  return @updateFrDictParts;
}

sub getReplaceFromDictParts {
  return @replaceFrDictParts;
}

sub getToUpdateDictParts {
  return @toUpdateDictionaryParts;
}

#sub getUpdateRemotelyParts {
#  return @updateRemotelyParts;
#}

sub getToReplaceDictParts {
  return @toReplaceDictionaryParts;
}

#sub getReplaceRemotelyParts {
#  return @replaceRemotelyParts;
#}

sub getNeedsUpdateDocParts {
  return @needsUpdateDocParts;
}

sub getNeedsUpdateParts {
  return @needsUpdateParts;
}

sub getObjectPropertiesParts {
  return @objectPropertiesParts;
}

sub getDestructorParts {
  return @destructorParts;
}

sub getCopyrightHeader {
  return $copyrightHeader;
}

sub getDoxygenClassDescParts {
  return @doxygenClassDescParts;
}

sub getMinConstructorDocParts {
  return @minConstructorDocParts;
}

sub getConstructorDocParts {
  return @constructorDocParts;
}

sub getMinClassConstructorDocParts {
  return @minClassConstructorDocParts;
}

sub getClassConstructorDocParts {
  return @classConstructorDocParts;
}

sub getToDictionaryDocParts {
  return @toDictionaryDocParts;
}

sub getFromDictionaryDocParts {
  return @fromDictionaryDocParts;
}

sub getUpdateFromDictDocParts {
  return @updateFrDictDocParts;
}

sub getReplaceFromDictDocParts {
  return @replaceFrDictDocParts;
}

sub getUpdateRemotelyDocParts {
  return @updateRemotelyDocParts;
}

sub getReplaceRemotelyDocParts {
  return @replaceRemotelyDocParts;
}

sub getObjectPropertiesDocParts {
  return @objectPropertiesDocParts;
}

sub getObjcKeywords {
  my @keywords = ("auto", "_Bool", "_Complex", "_Imaginery", "atomic", "BOOL", "break", "bycopy", "byref", 
                  "case", "char", "Class", "const", "continue", "default", "do", "double", "else", "enum", 
                  "extern", "float", "for", "goto", "id", "if", "IMP", "in", "inline", "inout", "int", "long", 
                  "nil", "NO", "nonatomic", "NULL", "oneway", "out", "Protocol", "register", "restrict", 
                  "retain", "return", "SEL", "self", "short", "signed", "sizeof", "static", "struct", 
                  "super", "switch", "typedef", "union", "unsigned", "void", "volatile", "while", "YES"); 

  my %keywords = map { $_ => 1 } @keywords;
  
  return %keywords;
}

sub getJanrainObjectNames {
  my @objectNames = ("objectId", "integer", "boolean", "uuid", "ipAddress", "password", 
                     "jsonObject", "simpleArray", "array", "date", "dateTime");

  my %keywords = map { $_ => 1 } @keywords;
  
  return %keywords;
}




1;