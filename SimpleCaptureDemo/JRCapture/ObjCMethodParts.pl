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
# - (id)init
# {                                                              
#     if ((self = [super init]))                                 
#     {     
#         self.captureObjectPath = @"<entity_path>";
#     }
#
#     return self;
# }
###################################################################

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
#
# Section only here when there are required properties     
#                     |
#                     V
# - (id)init<requiredProperties>
# {
#     if(!<requriredProperties>) <---------
#     {                          <-------------------- Section only here
#       [self release];          <-------------------- when there are 
#       return nil;              <-------------------- required properties
#     }                          <---------                      |
#                                                                |
#     if ((self = [super init]))                                 |
#     {                                                          |
#         self.captureObjectPath = @"<entity_path>";             |
#                                                                |
#         <requiredProperty> = [new<requiredProperty> copy]; <---+
#           ...
#     }
#
#     return self;
# }
###################################################################

my @constructorParts = (
"- (id)init", "",
"\n{\n",
"    if (", "", ")\n",
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
# + (id)<objectName>    
# {                                             
#     return [[[<className> alloc] init] autorelease]; 
# }
###################################################################

my @minClassConstructorParts = (
"+ (id)", "",
"\n{\n",
"    return [[[", "", " alloc] init] autorelease];",
"\n}\n\n"); 

###################################################################
# CLASS CONSTRUCTOR (W REQUIRED PROPERTIES)
#
# Section only here when there are required properties     
#                     |                         |
#                     V                         |
# + (id)<objectName><requiredProperties>        |
# {                                             V
#     return [[[<className> alloc] init<requiredProperties>] autorelease]; 
# }
###################################################################

my @classConstructorParts = (
"+ (id)", "", "", 
"\n{\n",
"    return [[[", "", " alloc] init", "", "] autorelease];",
"\n}\n\n"); 


###################################################################
# COPY CONSTRUCTOR (W REQUIRED PROPERTIES)
#
# - (id)copyWithZone:(NSZone*)zone         Section only here when there are required properties     
# {                                                               |
#     <className> *<object>Copy =                                 V
#                 [[<className> allocWithZone:zone] init<requiredProperties>];
#
#     <object>Copy.<property> = self.<property>;
#       ...
#
#     [<object>Copy.dirtyPropertySet removeAllObjects];
#     [<object>Copy.dirtyPropertySet setSet:self.dirtyPropertySet];
#
#     return <object>Copy;
# }
###################################################################

my @copyConstructorParts = (
"- (id)copyWithZone:(NSZone*)zone",
"\n{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS\n", 
"", " allocWithZone:zone] init", "", "];\n\n",
"", 
"
    [","",".dirtyPropertySet removeAllObjects];
    [","",".dirtyPropertySet setSet:self.dirtyPropertySet];
",
"\n    return ", "", ";",
"\n}\n\n");


###################################################################
# MAKE OBJECT FROM DICTIONARY
#
# + (id)<objectName>ObjectFromDictionary:(NSDictionary*)dictionary
# {
#     <className> *<object> = [<className> <object>];
# 
#     <object>.<property> = [dictionary objectForKey:@"<property>"] != [NSNull null] ? 
#                                   [dictionary objectForKey:@"<property>"] : nil;
#       OR
#     <object>.<property> = [dictionary objectForKey:@"<property>"] != [NSNull null] ? 
#                                   [<propertyFromDictionaryMethod>:[dictionary objectForKey:@"<property>"]] : nil;
#       ...
#
#     [<object>.dirtyPropertySet removeAllObjects];
#
#     return <object>;
# }
###################################################################

my @fromDictionaryParts = (
"+ (id)","","ObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath",
"\n{\n",
"", " = [","","];\n",
"    ", "", ".captureObjectPath = [NSString stringWithFormat:\@\"%@/%@", "", "\", capturePath, ", "", "", "];\n",
"",
"\n    [","",".dirtyPropertySet removeAllObjects];
    
    return ", "", ";",
"\n}\n\n");


###################################################################
# MAKE DICTIONARY FROM OBJECT
#
# - (NSDictionary*)toDictionary
# {
#     NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
#
#     [dict setObject:<propertyToDictionaryMethod> forKey:@"<propertyKey>"]; <- For non NSObject types
#       OR
#     [dict setObject:(<property> ? <property> : [NSNull null]) forKey:@"<propertyKey>"];
#       OR
#     [dict setObject:(<property> ? <propertyToDictionaryMethod> : [NSNull null]) forKey:@"<propertyKey>"];
#       ...
#
#     return [NSDictionary dictionaryWithDictionary:dict];
#  }
###################################################################

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
# - (void)updateFromDictionary:(NSDictionary *)dictionary
# {
#     if ([dictionary objectForKey:@"<property>"])
#         self.<property> = [dictionary objectForKey:@"<property>"] != [NSNull null] ? 
#                                       [dictionary objectForKey:@"<property>"] : nil;
#           OR
#         self.<property> = [dictionary objectForKey:@"<property>"] != [NSNull null] ? 
#                                       [<propertyFromDictionaryMethod>:[dictionary objectForKey:@"<property>"]] : nil;
#           ...
# }
###################################################################

my @updateFrDictParts = (
"- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath",
"\n{\n    DLog(@\"\%\@ \%\@\", capturePath, [dictionary description]);\n\n",
"    self.captureObjectPath = [NSString stringWithFormat:\@\"%@/%@", "", "\", capturePath, ", "", "", "];\n",
"",
"}\n\n");


###################################################################
# REPLACE CURRENT OBJECT FROM A NEW DICTIONARY
#
# - (void)replaceFromDictionary:(NSDictionary *)dictionary
# {
#     self.<property> = [dictionary objectForKey:@"<property>"] != [NSNull null] ? 
#                                   [dictionary objectForKey:@"<property>"] : nil;
#       OR
#     self.<property> = [dictionary objectForKey:@"<property>"] != [NSNull null] ? 
#                                   [<propertyFromDictionaryMethod>:[dictionary objectForKey:@"<property>"]] : nil;
#       ...
# }
###################################################################

my @replaceFrDictParts = (
"- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath",
"\n{\n    DLog(@\"\%\@ \%\@\", capturePath, [dictionary description]);\n\n",
"    self.captureObjectPath = [NSString stringWithFormat:\@\"%@/%@", "", "\", capturePath, ", "", "", "];\n",
"",
"}\n\n");


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

my @toUpdateDictionaryParts = (
"- (NSDictionary *)toUpdateDictionary",
"\n{\n",
"    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];\n",
"",         
"\n    return dict;",
"\n}\n\n");

my @updateRemotelyParts = (
"- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context",
"\n{\n",
"    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, \@\"captureObject\",
                                                     self.captureObjectPath, \@\"capturePath\",
                                                     delegate, \@\"delegate\",
                                                     context, \@\"callerContext\", nil];

    [JRCaptureInterface updateCaptureObject:[self toUpdateDictionary]
                                     withId:", "0", "
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];",
"\n}\n\n");


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

my @toReplaceDictionaryParts = (
"- (NSDictionary *)toReplaceDictionary",
"\n{\n",
"    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];\n\n",
"",         
"\n    return dict;",
"\n}\n\n");

my @replaceRemotelyParts = (
"- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context",
"\n{\n",
"    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, \@\"captureObject\",
                                                     self.captureObjectPath, \@\"capturePath\",
                                                     delegate, \@\"delegate\",
                                                     context, \@\"callerContext\", nil];

    [JRCaptureInterface replaceCaptureObject:[self toReplaceDictionary]
                                      withId:", "0", "
                                      atPath:self.captureObjectPath
                                   withToken:[JRCaptureData accessToken]
                                 forDelegate:self
                                 withContext:newContext];",
"\n}\n\n");


###################################################################
# MAKE DICTIONARY OF OBJECT'S PROPERTIES
#
# - (NSDictionary*)objectProperties
# {
#     NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
#
#     [dict setObject:@"<propertyType>" forKey:@"<propertyName>"];
#
#     return [NSDictionary dictionaryWithDictionary:dict];
#  }
###################################################################

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
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((\@\"\%s [Line \%d] \" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((\@\"\%s [Line \%d] \" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)\n\n";

sub createArrayCategoryForSubobject { 
  my $propertyName = $_[0];
  
  my $arrayCategoryIntf = "\@interface NSArray (" . ucfirst($propertyName) . "ToFromDictionary)\n";
  my $arrayCategoryImpl = "\@implementation NSArray (" . ucfirst($propertyName) . "ToFromDictionary)\n";

  my $methodName1 = "- (NSArray*)arrayOf" . ucfirst($propertyName) . "ObjectsFrom" . ucfirst($propertyName) . "DictionariesWithPath:(NSString*)capturePath";
  my $methodName2 = "- (NSArray*)arrayOf" . ucfirst($propertyName) . "DictionariesFrom" . ucfirst($propertyName) . "Objects";
  my $methodName3 = "- (NSArray*)arrayOf" . ucfirst($propertyName) . "UpdateDictionariesFrom" . ucfirst($propertyName) . "Objects";
  my $methodName4 = "- (NSArray*)arrayOf" . ucfirst($propertyName) . "ReplaceDictionariesFrom" . ucfirst($propertyName) . "Objects";
  
  $arrayCategoryIntf .= "$methodName1;\n$methodName2;\n$methodName3;\n$methodName4;\n\@end\n\n";
  
  $arrayCategoryImpl .= "$methodName1\n{\n";
  $arrayCategoryImpl .=        
       "    NSMutableArray *filtered" . ucfirst($propertyName) . "Array = [NSMutableArray arrayWithCapacity:[self count]];\n" . 
       "    for (NSObject *dictionary in self)\n" . 
       "        if ([dictionary isKindOfClass:[NSDictionary class]])\n" . 
       "            [filtered" . ucfirst($propertyName) . "Array addObject:[JR" . ucfirst($propertyName) . " " . $propertyName . "ObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];\n\n" . 
       "    return filtered" . ucfirst($propertyName) . "Array;\n}\n\n";
       
  $arrayCategoryImpl .= "$methodName2\n{\n";
  $arrayCategoryImpl .=        
       "    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];\n" . 
       "    for (NSObject *object in self)\n" . 
       "        if ([object isKindOfClass:[JR" . ucfirst($propertyName) . " class]])\n" . 
       "            [filteredDictionaryArray addObject:[(JR" . ucfirst($propertyName) . "*)object toDictionary]];\n\n" . 
       "    return filteredDictionaryArray;\n}\n\n";

  $arrayCategoryImpl .= "$methodName3\n{\n";
  $arrayCategoryImpl .=        
       "    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];\n" . 
       "    for (NSObject *object in self)\n" . 
       "        if ([object isKindOfClass:[JR" . ucfirst($propertyName) . " class]])\n" . 
       "            [filteredDictionaryArray addObject:[(JR" . ucfirst($propertyName) . "*)object toUpdateDictionary]];\n\n" . 
       "    return filteredDictionaryArray;\n}\n\n";

  $arrayCategoryImpl .= "$methodName4\n{\n";
  $arrayCategoryImpl .=        
       "    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];\n" . 
       "    for (NSObject *object in self)\n" . 
       "        if ([object isKindOfClass:[JR" . ucfirst($propertyName) . " class]])\n" . 
       "            [filteredDictionaryArray addObject:[(JR" . ucfirst($propertyName) . "*)object toReplaceDictionary]];\n\n" . 
       "    return filteredDictionaryArray;\n}\n\@end\n\n";

  return "$arrayCategoryIntf$arrayCategoryImpl";
}

sub createGetterSetterForProperty {
  my $propertyName  = $_[0];
  my $propertyType  = $_[1];
  my $isBoolOrInt   = $_[2];
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
  $setter .= "    [self.dirtyPropertySet addObject:@\"" . $propertyName . "\"];\n";

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
  $setter .= "    [self.dirtyPropertySet addObject:@\"" . $propertyName . "\"];\n";

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

sub getUpdateRemotelyParts {
  return @updateRemotelyParts;
}

sub getToReplaceDictParts {
  return @toReplaceDictionaryParts;
}

sub getReplaceRemotelyParts {
  return @replaceRemotelyParts;
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

1;