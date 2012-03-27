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

#!/usr/bin/perl

###################################################################
# OBJC METHODS TO BE POPULATED WITH PROPERTIES
###################################################################

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
#     return <object>Copy;
# }
###################################################################

my @copyConstructorParts = (
"- (id)copyWithZone:(NSZone*)zone",
"\n{\n", 
"", " allocWithZone:zone] init", "", "];\n\n",
"", "\n    return ", "", ";",
"\n}\n\n");


###################################################################
# MAKE OBJECT FROM DICTIONARY (W REQUIRED PROPERTIES)
#
# + (id)<objectName>ObjectFromDictionary:(NSDictionary*)dictionary
# {
#                        Section only here when there are required properties     
#                                                  |                         
#                                                  V         
#     <className> *<object> =
#         [<className> <object><requiredProperties/requiredPropertiesFromDictionaryMethods>];
# 
#     <object>.<property> = [dictionary objectForKey:@"<property>"];
#       OR
#     <object>.<property> = [<propertyFromDictionaryMethod>:[dictionary objectForKey:@"<property>"]];
#       ...
#
#     return <object>;
# }
###################################################################

my @fromDictionaryParts = (
"+ (id)","","ObjectFromDictionary:(NSDictionary*)dictionary",
"\n{\n",
"",
"        [","","","];\n",
"",
"\n\n    return ", "", ";",
"\n}\n\n");


###################################################################
# MAKE DICTIONARY FROM OBJECT (W REQUIRED PROPERTIES)
#
# - (NSDictionary*)dictionaryFrom<objectName>Object
# {
#     NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
#
#     Section only here when there are required properties     
#                              |                         
#                              V                         
#     [dict setObject:<requiredProperty> forKey:@"<requiredProperty>"];
#       OR
#     [dict setObject:<requiredPropertyToDictionaryMethod> forKey:@"<requiredProperty>"];
#       ...
#
#     if (<property>)
#         [dict setObject:<property> forKey:@"<property>"];
#           OR
#         [dict setObject:<propertyToDictionaryMethod> forKey:@"<property>"];
#       ...
#
#     return dict;
#  }
###################################################################

my @toDictionaryParts = (
"- (NSDictionary*)dictionaryFrom", "", "Object",
"\n{\n",
"    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];\n",
"", 
"", 
"\n    return dict;",
"\n}\n\n");


###################################################################
# UPDATE CURRENT OBJECT FROM A NEW DICTIONARY
#
# - (void)updateLocallyFromNewDictionary:(NSDictionary *)dictionary
# {
#     if ([dictionary objectForKey:@"<property>"])
#         self.<property> = [dictionary objectForKey:@"<property>"];
#           OR
#         self.<property> = [<propertyFromDictionaryMethod>:[dictionary objectForKey:@"<property>"]];
#           ...
# }
###################################################################

my @updateFrDictParts = (
"- (void)updateLocallyFromNewDictionary:(NSDictionary*)dictionary",
"\n{",
"",
"}\n\n");


###################################################################
# REPLACE CURRENT OBJECT FROM A NEW DICTIONARY
#
# - (void)replaceLocallyFromNewDictionary:(NSDictionary *)dictionary
# {
#     self.<property> = [dictionary objectForKey:@"<property>"];
#       OR
#     self.<property> = [<propertyFromDictionaryMethod>:[dictionary objectForKey:@"<property>"]];
#       ...
# }
###################################################################

my @replaceFrDictParts = (
"- (void)replaceLocallyFromNewDictionary:(NSDictionary*)dictionary",
"\n{\n",
"",
"}\n\n");


###################################################################
# UPDATE OBJECT ON CAPTURE
#
# - (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
# {
#     NSMutableDictionary *dict =
#         [NSMutableDictionary dictionaryWithCapacity:10];
# 
#     if ([self.dirtyPropertySet containsObject:@"car"])
#         [dict setObject:self.car forKey:@"car"];
# 
#     NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
#                                                      context, @"callerContext",
#                                                      self, @"captureObject",
#                                                      delegate, @"delegate", nil];
# 
#     [JRCaptureInterfaceTwo updateCaptureObject:dict
#                                         withId:self.carsId
#                                         atPath:self.captureObjectPath
#                                      withToken:[JRCaptureData accessToken]
#                                    forDelegate:super
#                                    withContext:newContext];
# }
###################################################################

my @updateRemotelyParts = (
"- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context",
"\n{\n",
"    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];\n",
"",
"\n    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, \@\"callerContext\",
                                                     self, \@\"captureObject\",
                                                     delegate, \@\"delegate\", nil];

    [JRCaptureInterfaceTwo updateCaptureObject:dict
                                        withId:", "nil", "
                                        atPath:self.captureObjectPath
                                     withToken:[JRCaptureData accessToken]
                                   forDelegate:super
                                   withContext:newContext];",
"\n}\n\n");


###################################################################
# REPLACE OBJECT ON CAPTURE
#
# - (void)replaceLocallyFromNewDictionary:(NSDictionary *)dictionary
# {
#     self.<property> = [dictionary objectForKey:@"<property>"];
#       OR
#     self.<property> = [<propertyFromDictionaryMethod>:[dictionary objectForKey:@"<property>"]];
#       ...
# }
###################################################################

my @replaceRemotelyParts = (
"- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context",
"\n{\n",
"    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];\n\n",
"",
"\n    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     context, \@\"callerContext\",
                                                     self, \@\"captureObject\",
                                                     delegate, \@\"delegate\", nil];

    [JRCaptureInterfaceTwo replaceCaptureObject:dict
                                         withId:", "nil", "
                                         atPath:self.captureObjectPath
                                      withToken:[JRCaptureData accessToken]
                                    forDelegate:super
                                    withContext:newContext];",
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

sub createArrayCategoryForSubobject { 
  my $propertyName = $_[0];
  
  my $arrayCategoryIntf = "\@interface NSArray (" . ucfirst($propertyName) . "ToFromDictionary)\n";
  my $arrayCategoryImpl = "\@implementation NSArray (" . ucfirst($propertyName) . "ToFromDictionary)\n";

  my $methodName1 = "- (NSArray*)arrayOf" . ucfirst($propertyName) . "DictionariesFrom" . ucfirst($propertyName) . "Objects";
  my $methodName2 = "- (NSArray*)arrayOf" . ucfirst($propertyName) . "ObjectsFrom" . ucfirst($propertyName) . "Dictionaries";
  
  $arrayCategoryIntf .= "$methodName1;\n$methodName2;\n\@end\n\n";
  $arrayCategoryImpl .= "$methodName1\n{\n";

  $arrayCategoryImpl .=        
       "    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];\n" . 
       "    for (NSObject *object in self)\n" . 
       "        if ([object isKindOfClass:[JR" . ucfirst($propertyName) . " class]])\n" . 
       "            [filteredDictionaryArray addObject:[(JR" . ucfirst($propertyName) . "*)object dictionaryFrom" . ucfirst($propertyName) . "Object]];\n\n" . 
       "    return filteredDictionaryArray;\n}\n\n";
       
  $arrayCategoryImpl .= "$methodName2\n{\n";

  $arrayCategoryImpl .=        
       "    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];\n" . 
       "    for (NSObject *dictionary in self)\n" . 
       "        if ([dictionary isKindOfClass:[NSDictionary class]])\n" . 
       "            [filteredDictionaryArray addObject:[JR" . ucfirst($propertyName) . " " . $propertyName . "ObjectFromDictionary:(NSDictionary*)dictionary]];\n\n" . 
       "    return filteredDictionaryArray;\n}\n\@end\n\n";

  return "$arrayCategoryIntf$arrayCategoryImpl";
}

sub createGetterSetterForProperty {
  my $propertyName  = $_[0];
  my $propertyType  = $_[1];
  my $isNotNSObject = $_[2];
  
  my $getterSetter = "- (" . $propertyType . ")" . $propertyName;
  
  $getterSetter .= "\n{\n";
  $getterSetter .= "    return _" . $propertyName . ";";
  $getterSetter .= "\n}\n\n";
  
  $getterSetter .= "- (void)set". ucfirst($propertyName) . ":(" . $propertyType . ")new" . ucfirst($propertyName); 
  $getterSetter .= "\n{\n";
  $getterSetter .= "    [self.dirtyPropertySet addObject:@\"" . $propertyName . "\"];\n\n";

  if ($isNotNSObject) {
    $getterSetter .= "    _" . $propertyName .  " = new" . ucfirst($propertyName) . ";";  
  } else {
    $getterSetter .= "    _" . $propertyName .  " = [new" . ucfirst($propertyName) . " copy];";  
  }
  
  $getterSetter .= "\n}\n\n";

  return $getterSetter;
}

sub getConstructorParts {
  return @constructorParts;
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

sub getUpdateRemotelyParts {
  return @updateRemotelyParts;
}

sub getReplaceRemotelyParts {
  return @replaceRemotelyParts;
}

sub getDestructorParts {
  return @destructorParts;
}

sub getCopyrightHeader {
  return $copyrightHeader;
}

1;