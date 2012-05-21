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
# File:   CaptureSchemaParser.pl
# Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
# Date:   Friday, January 27, 2012
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

use strict;
use warnings;

require './ObjCMethodParts.pl';
require './CaptureParserIO.pl';

use JSON; # imports encode_json, decode_json, to_json and from_json.
use Getopt::Std;


########################################################################
# First things first: If the schema was passed in on the command line
# with the option '-f', open it up, otherwise, find out where it is
########################################################################
our ($opt_f);
getopt('f');
my $schemaName = $opt_f;
my $schema = "";

if ($schemaName) {
  $schema = openSchemaNamed ($schemaName);
} else {
  $schema = getCaptureSchema (0, "");
}


############################################
# CONSTANTS
############################################
my $YES = 1;
my $NO  = 0;
# my $PLURAL_ELEMENT     = 1;
# my $PLURAL_PARENT      = 1;
# my $READ_ONLY_PROPERTY = 1; # 'id', 'uuid', 'created', and 'lastUpdated' can't be changed from the client


############################################
# HASHES OF .M AND .H FILES
############################################
my %hFiles = ();
my %mFiles = ();


############################################
# HASH TO KEEP TRACK OF OBJECT NAMES
############################################
my %repeatNamesHash = ();


############################################
# ARRAYS TO KEEP TRACK OF INTEGER AND BOOLS
############################################
my @booleanProperties;
my @integerProperties;


############################################
# HELPER METHODS
############################################

################################################
# Figure out if our plural is SIMPLE, that is, 
# simple plurals contain lists of strings
# e.g.:
# "books":["book1","book2","book3"]
#   OR
# "books":[{"book":"book1","id":55},
#          {"book":"book2","id":56},
#          {"book":"book2","id":56}]
################################################
sub getIsAnArrayOfStrings {
  my $arrayRef    = $_[0];
  my @attrDefsArr = @$arrayRef;

  if (@attrDefsArr != 2) {
    return 0;
  }
  
  my $foundString = 0, my $foundId = 0;

  foreach my $hashRef (@attrDefsArr) {
    my %propertyHash = %$hashRef;
    my $propertyType = $propertyHash{"type"};

    if ($propertyType eq "string") {
      $foundString = 1;
    } elsif ($propertyType eq "id") {
      $foundId     = 1;
    }
  }
  
  if ($foundString && $foundId) {
    return 1;
  } else {
    return 0;
  }
}

##################################################
# For a simple plural, figure out the type (name)
# of our string elements
# e.g.:
# "books":[{"book":"book1","id":55},
#          {"book":"book2","id":56},
#          {"book":"book2","id":56}]
##################################################
sub getSimplePluralType {
  my $arrayRef    = $_[0];
  my @attrDefsArr = @$arrayRef;

  foreach my $hashRef (@attrDefsArr) {
    my %propertyHash = %$hashRef;
    my $propertyType = $propertyHash{"type"};
    my $propertyName = $propertyHash{"name"}; # TODO: Assumes presence; return "value" if isn't there or just assume it always is
    
    if ($propertyType eq "string") {
      return $propertyName;
    }
  }
}

##################################################
# Determine if an object's property is required 
##################################################
sub getIsRequired {
  my $hashRef = $_[0];
  my %propertyHash = %$hashRef;
  
  my $constraintsArrRef = $propertyHash{"constraints"};
  
  if (!$constraintsArrRef) {
    return 0;
  }
  
  my @constraintsArray = @$constraintsArrRef;
  
  foreach my $val (@constraintsArray) {
    if ($val eq "required") {
      return 1;
    }
  }

  return 0;  
}

##########################################################
# Certain properties, 'id', 'uuid', 'created', 
# and 'lastUpdated', can't be changed from the client.
# Determine if this property is one of those.
##########################################################
sub getIsReadOnly {
  my $propertyName = $_[0];
  my %ignoredProperties = map { $_ => 1 } ("id", "uuid", "created", "lastUpdated");

  if(exists($ignoredProperties{$propertyName})) { 
    return 1;
  }
  
  return 0;
}

##########################################################
# Certain properties may share a name with Objective-C
# keywords and reserved words (e.g., 'id'). Make sure
# the property name can be used or change appropriately.
##########################################################
sub getIsPropertyNameObjcKeyword {
  my $propertyName = $_[0];
  my %keywords     = getObjcKeywords();

  if(exists($keywords{$propertyName})) { 
    return 1;
  }
  
  return 0;
}

##########################################################
# Quickie function to remove the pointer character from 
# the Objective-C type string.
# e.g., 'JRBooks *' -> 'JRBooks'
##########################################################
sub stripPointer {
  my $objectiveType = $_[0];
  $objectiveType =~ s/ \*//;
  return $objectiveType;
}

##########################################################
# Duh.
##########################################################
sub trim {
	my $string = $_[0];
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}


##################################################################################################
# RECURSIVE PARSING METHOD
#
# The meat of the script.  This method recursively parses the objects in the schema, extracting 
# an object's properties, and writing an interface and implementation file for each object.
#
# As the properties of an object are parsed, the script checks if a property is an object or a 
# plural of objects (not including plurals of strings), and recurses
#
# For each object, this method will write the appropriate .h and .m files.  The .h/.m files 
# include instance constructors, class constructors, a copy constructor, a destructor, methods to 
# convert the object to/from NSArrays/NSDictionaries for easy jsonification, methods to 
# create/update objects from NSDictionaries, methods to update/replace the object and its arrays
# on Capture, and accessors for all of the properties. Required properties are treated as such in 
# special constructors.  This method adds Doxygen comments to the object.
#
# Arguments
#   objectName:       The name of the object as it is in the schema, with a lower-cased first letter
#                     and camel-cased rest.  If the property shares a name with a property of another
#                     object or with a reserved word in Objective-C, this name has already been updated
#                     to be unique, by appending the parent object's name to it while still parsing
#                     the parent.
#    
#   arrRef:           A list of the object's properties (as a reference to an array of properties).
#                     That is, a reference (pointer) to the array of properties, where each element in
#                     the array is a reference (pointer) to a hash of attributes of the property
#    
#   parentPath:       The path of object names from the root object '/' to the parent of the current
#                     object. The current object's Name is appended to this value. This value is used by
#                     objects when updating/replacing themselves on Capture, and is equivalent to the
#                     value path 'attribute_name' on APID. Objects who are children of plurals won't
#                     know their path until they have been assigned an id. When this happens (the objects
#                     or their parents have been assigned an id), the generated code will automatically
#                     update the object's path.
#                     e.g.:
#                       /objectLevelOne/objectLevel3
#                         OR
#                       /objectWithPlural/pluralElement#55
#    
#   pathAppend:       The name of the object that gets appended to the parent path, which is the exact
#                     name of the property as it appears in the schema. This is needed as the objectName
#                     might have changed from what is in the schema (see above for explanation), and
#                     there is a special case with the top-level object (captureUser) and its direct
#                     decendents.  In the Objective-C code, the top level object is called captureUser
#                     (or JRCaptureUser), but on Capture the path to this entity is just '/'. The path
#                     to the children of this entity is /nameOfChildObject, as opposed to 
#                     /captureUser/firstChild. When we call this method for our top-level object, we pass
#                     in "" for this parameter and "/" for the parentPath. On subsequent calls, we pass 
#                     in an object's path as the parentPath of the subobject, and the name of the subobject
#                     as the path append.
#  
#   isPluralElement:  If the object itself is an element in a plural.
#  
#   hasPluralParent:  If the object or parent of the object (or any ancestor) is an element of a plural
#                     paths need to be handled differently, so keep track of this.
#  
#   objectDesc:       The description of the object as it is found in the schema. This value is used in
#                     Doxygen comments of the object.
######################################################################

sub recursiveParse {

  my $objectName      = $_[0];
  my $arrRef          = $_[1];
  my $parentPath      = $_[2];
  my $pathAppend      = $_[3];
  my $isPluralElement = $_[4];
  my $hasPluralParent = $_[4];
  my $objectDesc      = $_[5];

  my $className;
  my $objectPath;

  ################################################
  # Dereference the list of properties
  ################################################
  my @propertyList = @$arrRef;

  ################################################
  # Add the object name to the repeatNamesHash
  ################################################
  $repeatNamesHash{$objectName} = 1;

  ##########################################################################
  # Create the object's path. Object path depends on if the object is a 
  # decendent of a plural element and if it falls under the special case of 
  # the top-level object and its direct decendents
  # e.g.:
  #   /firstChild
  #     OR
  #   /firstChild/secondChild
  ##########################################################################
  # TODO: Don't create if child of plural??
  if ($parentPath eq "/") { 
    $objectPath = $parentPath . $pathAppend;
  } else {
    $objectPath = $parentPath . "/" . $pathAppend;
  }
  
  
  ##########################################################################
  # Initialize the sections of the .h/.m files from the stubbed out methods
  # in the file ObjCMethodParts.pl
  ##########################################################################
  my $extraImportsSection        = "";
  my $propertiesSection          = "";
  my $privateIvarsSection        = "";
  my $arrayCategoriesSection     = "";
  my $synthesizeSection          = ""; # Well, now it's all dynamic; still needed
  my $getterSettersSection       = "";
  my $replaceArrayIntfSection    = "";
  my $replaceArrayImplSection    = "";
  my @minConstructorSection      = getMinConstructorParts();
  my @constructorSection         = getConstructorParts();
  my @minClassConstructorSection = getMinClassConstructorParts();
  my @classConstructorSection    = getClassConstructorParts();
  my @copyConstructorSection     = getCopyConstructorParts();
  my @destructorSection          = getDestructorParts();
  my @dictFromObjSection         = getToDictionaryParts();
  my @objFromDictSection         = getFromDictionaryParts();
  my @updateFromDictSection      = getUpdateFromDictParts();
  my @replaceFromDictSection     = getReplaceFromDictParts();
  my @toUpdateDictSection        = getToUpdateDictParts();
  my @toReplaceDictSection       = getToReplaceDictParts();
  my @objectPropertiesSection    = getObjectPropertiesParts();

  my @doxygenClassDescSection    = getDoxygenClassDescParts();  
  my @minConstructorDocSection      = getMinConstructorDocParts();
  my @constructorDocSection         = getConstructorDocParts();
  my @minClassConstructorDocSection = getMinClassConstructorDocParts();
  my @classConstructorDocSection    = getClassConstructorDocParts();
  my @dictFromObjectDocSection      = getToDictionaryDocParts();
  my @objFromDictDocSection         = getFromDictionaryDocParts();
  my @updateFrDictDocSection        = getUpdateFromDictDocParts();
  my @replaceFrDictDocSection       = getReplaceFromDictDocParts();
  my @updateRemotelyDocSection      = getUpdateRemotelyDocParts();
  my @replaceRemotelyDocSection     = getReplaceRemotelyDocParts();
  my @objectPropertiesDocSection    = getObjectPropertiesDocParts();


  ######################################################################
  # Create the class name of an object, adding 'Element' if the object
  # is in a plural (but not an object in an object in a plural).
  # e.g.:
  #   'primaryAddress' becomes 'JRPrimaryAddress' or
  #   'statuses' becomes 'JRStatusesElement'
  ######################################################################
  if ($isPluralElement) {
    $className = "JR" . ucfirst($objectName) . "Element";  
  } else {
    $className = "JR" . ucfirst($objectName);  
  }
 
  print "Parsing object $className...\n";
  
  
  
  ####################################################
  # FILL IN METHODS WITH OBJECT NAME AND CLASS NAME
  ####################################################
  
  ################################################################################
  # Parts of the class constructor, copy constructor, and other methods reference 
  # the object name and class name in a few specific places in their 
  # implementation. Now that we have the object name and the class name, we need
  # to fill in these portions of the stubbed out methods (see ObjCMethodParts.pl
  # for exact details).
  #
  # e.g., 
  # JRUserObject *userObjectCopy =
	#			[[JRUserObject allocWithZone:zone] init];
  #	
  # The rest of the methods/sections of our class get filled in as we loop through
  # the list of properties.
  ################################################################################

  $minConstructorDocSection[1] = $className;
  $minConstructorDocSection[3] = $className;
  $constructorDocSection[1] = $className;
  $constructorDocSection[5] = $className;
  
  $minClassConstructorSection[1]    = $objectName;
  $minClassConstructorSection[4]    = $className;
  $minClassConstructorDocSection[1] = $className;
  $minClassConstructorDocSection[3] = $className;

  $classConstructorSection[1] = $objectName;
  $classConstructorSection[5] = $className;
  $classConstructorDocSection[1] = $className;
  $classConstructorDocSection[5] = $className;
  
  $objFromDictDocSection[1] = $className;
  $objFromDictDocSection[3] = $className;
  $dictFromObjectDocSection[1] = $className;
  $dictFromObjectDocSection[3] = $className;
  
  $copyConstructorSection[2]  = "    " . $className . " *" . $objectName . "Copy =\n                [[" . $className;
  $copyConstructorSection[7]  = $objectName . "Copy";
  $copyConstructorSection[11] = $objectName . "Copy";
  $copyConstructorSection[13] = $objectName . "Copy";
  $copyConstructorSection[15] = $objectName . "Copy";
  $copyConstructorSection[18] = $objectName . "Copy";
  
  $objFromDictSection[1]      = $objectName;
  $objFromDictSection[5]      = "    " . $className . " *" . $objectName;
  $objFromDictSection[7]      = $className . " " . $objectName;
  $objFromDictSection[10]      = $objectName;
  $objFromDictSection[14]     = "\@\"" . $objectName . "\"";  
  $objFromDictSection[19]     = $objectName;
  $objFromDictSection[21]     = $objectName;
  $objFromDictSection[23]     = $objectName;
  
  $updateFromDictSection[6]   = "\@\"" . $objectName . "\"";  
  $replaceFromDictSection[6]  = "\@\"" . $objectName . "\"";  
      
  if ($objectDesc) {
    $doxygenClassDescSection[1]      = ucfirst(trim($objectDesc));
  } else {
    $doxygenClassDescSection[1]      = "A " . $className . " object";
  }

  if ($pluralParent) {
    $minConstructorSection[3]  = "        self.captureObjectPath = \@\"\";\n";
    $minConstructorSection[3] .= "        self.canBeUpdatedOrReplaced = NO;\n";
    $constructorSection[8]     = "        self.captureObjectPath = \@\"\";\n";
    $constructorSection[8]    .= "        self.canBeUpdatedOrReplaced = NO;\n";
    
    $objFromDictSection[17]   .= "// TODO: Is this safe to assume?\n    " . $objectName . ".canBeUpdatedOrReplaced = YES;\n";

  } else {

    if ($objectName eq "captureUser") {      
      $minConstructorSection[3] = "        self.captureObjectPath = \@\"\";\n";
      $constructorSection[8]    = "        self.captureObjectPath = \@\"\";\n";
    } else {
      $minConstructorSection[3] = "        self.captureObjectPath = \@\"" . $objectPath . "\";\n";
      $constructorSection[8]    = "        self.captureObjectPath = \@\"" . $objectPath . "\";\n";
    }

    $minConstructorSection[3] .= "        self.canBeUpdatedOrReplaced = YES;\n";
    $constructorSection[8]    .= "        self.canBeUpdatedOrReplaced = YES;\n";

    $objFromDictSection[9]     = "//" . $objFromDictSection[9];

#    $updateFromDictSection[2]  = "//" . $updateFromDictSection[2];
#    $replaceFromDictSection[2] = "//" . $replaceFromDictSection[2];    

    $updateFromDictSection[3]  = "//" . $updateFromDictSection[3];
    $replaceFromDictSection[3] = "//" . $replaceFromDictSection[3];    
  }
  
  
  ######################################################
  # Keep track of how many properties are required
  ######################################################
  my $requiredProperties = 0;

  ########################################################################
  # A property list contains references (pointers) to property hashes.
  # Loop through the properties, dereference, and parse...
  ########################################################################
  foreach my $hashRef (@propertyList) {

    ################################################
    # Dereference the property hash
    ################################################    
    my %propertyHash = %$hashRef;
    
    ################################################
    # Get the property's name and type
    ################################################
    my $propertyName = $propertyHash{"name"};
    my $propertyType = $propertyHash{"type"};
    my $propertyDesc = $propertyHash{"description"};

    ######################################################
    # Initialize property attributes to default values
    ######################################################
    my $objectiveType   = "";             # Property type in Objective-C (e.g., NSString*)
    my $isAlsoPrimitive = 0;              # If it's a boolean or integer, we don't retain/release, etc.
    my $isObject        = 0;
    my $isArray         = 0;              # If it's an array (plural), we do things differently
    my $isSimpleArray   = 0;              # If it's a simple array (plural) of strings, we do things differently
    my $simpleArrayType = "";             # And if it is, get its type
    my $isId            = 0;              # If the name of the property is 'id', we also do things differently
    my $dictionaryKey   = $propertyName;  # Set the dictionary key as the property name, and change the property name if it is an objc keyword
    my $propertyNotes   = "";             # Doxygen comment that provides more infomation if necessary for a property 
                                          # (e.g., in the case of an array of objects versus and array of strings)

    ##########################################################
    # Calls to the Capture server should not contain id, uuid, 
    # created, and lastUpdated
    ##########################################################
    my $shouldIgnore = getShouldIgnore($propertyName);

    ##########################################################
    # Before setting the default to/from dictionary methods, 
    # make sure the property name isn't an objc keyword
    ##########################################################
    if (isPropertyNameObjcKeyword($propertyName)) {
      $propertyName = $objectName . ucfirst($propertyName);
    }

    ######################################################
    # Finish initializing property defaults
    ######################################################
    my $toDictionary    =                                   # Default operation is to just stick the NSObject 
          "self.$propertyName";                             # into an NSMutableDictionary
    my $toUpDictionary  = "self.$propertyName";             # Default operation for toUpdateDictionary                                        
    my $toRplDictionary = "self.$propertyName";             # Default operation for toReplaceDictionary 
    my $frDictionary    =                                   # Default operation is to just pull the NSObject from 
          "[dictionary objectForKey:\@\"$dictionaryKey\"]"; # the dictionary and stick it into the property
    my $frUpDictionary  = 
          "[dictionary objectForKey:\@\"$dictionaryKey\"]";
    my $frRplDictionary  = 
          "[dictionary objectForKey:\@\"$dictionaryKey\"]";
    
    ######################################################
    # Find out if it's a required property, and
    # increase the requiredProperties counter if it is
    ######################################################
    my $isRequired = getIsRequired (\%propertyHash); 
    if ($isRequired) {
      $requiredProperties++;
    }
    
    ##########################################################################
    # Determine the property's ObjC type.  Also determine how the property 
    # should be serialized/deserialized to/from and NSDictionary 
    # (e.g., do we store the property in an NSMutableDictionary as is, or do
    # we need to do something first so that it can stored in the dictionary)
    ##########################################################################
    if ($propertyType eq "string") {
    ##################
    # STRING
    ##################
      $objectiveType = "NSString *";
      
      if ($propertyDesc) {
        $propertyNotes .= "/**< " . ucfirst(trim($propertyDesc)) . " */";
      } else {
        $propertyNotes .= "/**< The object's \\e " . $propertyName . " property */";
      }

    } elsif ($propertyType eq "boolean") {
    ##################
    # BOOLEAN
    ##################
      $isAlsoPrimitive = "b";
      $objectiveType = "JRBoolean *";#"BOOL";
      $toDictionary  = $toUpDictionary = $toRplDictionary = "[NSNumber numberWithBool:[self." . $propertyName . " boolValue]]";#"[NSNumber numberWithBool:self." . $propertyName . "]";
      $frDictionary  = $frUpDictionary = $frRplDictionary = "[NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] boolValue]]";#"[(NSNumber*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] boolValue]";

      if ($propertyDesc) {
        $propertyNotes .= "/**< " . ucfirst(trim($propertyDesc));
      } else {
        $propertyNotes .= "/**< The object's \\e " . $propertyName . " property";
      }
      $propertyNotes   .= " \@note This is a property of type 'boolean', which is a typedef of \\e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:&gt;myBool&lt;]</code> or <code>[NSNull null]</code> */";

      push (@booleanProperties, $propertyName);
      
    } elsif ($propertyType eq "integer") {
    ##################
    # INTEGER
    ##################
      $isAlsoPrimitive = "i";
      $objectiveType = "JRInteger *";#"NSInteger";
      $toDictionary  = $toUpDictionary = $toRplDictionary = "[NSNumber numberWithInteger:[self." . $propertyName . " integerValue]]";#"[NSNumber numberWithInt:self." . $propertyName . "]";
      $frDictionary  = $frUpDictionary = $frRplDictionary = "[NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] integerValue]]";#"[(NSNumber*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] intValue]";

      if ($propertyDesc) {
        $propertyNotes .= "/**< " . ucfirst(trim($propertyDesc));
      } else {
        $propertyNotes .= "/**< The object's " . $propertyName . " property";
      }
      $propertyNotes   .= " \@note This is a property of type 'integer', which is a typedef of \\e NSNumber. The accepted values can only be <code>[NSNumber numberWithInteger:&gt;myInteger&lt;]</code>, <code>[NSNumber numberWithInt:&gt;myInt&lt;]</code>, or <code>[NSNull null]</code> */";

      push (@integerProperties, $propertyName);

    } elsif ($propertyType eq "decimal") {
    ##################
    # DECIMAL/NUMBER
    ##################
      $objectiveType = "NSNumber *";

      if ($propertyDesc) {
        $propertyNotes .= "/**< " . ucfirst(trim($propertyDesc)) . " */";
      } else {
        $propertyNotes .= "/**< The object's \\e " . $propertyName . " property */";
      }

    } elsif ($propertyType eq "date") {
    ##################
    # DATE
    ##################
      $objectiveType = "JRDate *";
      
      $toDictionary  = $toUpDictionary = $toRplDictionary = "[self." . $propertyName . " stringFromISO8601Date]";
      $frDictionary  = $frUpDictionary = $frRplDictionary = "[JRDate dateFromISO8601DateString:[dictionary objectForKey:\@\"" . $dictionaryKey . "\"]]";

      if ($propertyDesc) {
        $propertyNotes .= "/**< " . ucfirst(trim($propertyDesc));
      } else {
        $propertyNotes .= "/**< The object's " . $propertyName . " property";
      }
      $propertyNotes   .= " \@note This is a property of type 'date', which is a typedef of \\e NSDate. The accepted format should be an ISO8601 date string (e.g., \\c yyyy-MM-dd) */";      

    } elsif ($propertyType eq "dateTime") {
    ##################
    # DATETIME
    ##################
      $objectiveType = "JRDateTime *";
      
      $toDictionary  = $toUpDictionary = $toRplDictionary = "[self." . $propertyName . " stringFromISO8601DateTime]";
      $frDictionary  = $frUpDictionary = $frRplDictionary = "[JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:\@\"" . $dictionaryKey . "\"]]";

      if ($propertyDesc) {
        $propertyNotes .= "/**< " . ucfirst(trim($propertyDesc));
      } else {
        $propertyNotes .= "/**< The object's " . $propertyName . " property";
      }
      $propertyNotes   .= " \@note This is a property of type 'dateTime', which is a typedef of \\e NSDate. The accepted format should be an ISO8601 dateTime string (e.g., \\c yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ) */";

    } elsif ($propertyType eq "ipAddress") {
    ####################################
    # IPADDRESS IS JUST A STRING
    ####################################
      $objectiveType = "JRIpAddress *";

      if ($propertyDesc) {
        $propertyNotes .= "/**< " . ucfirst(trim($propertyDesc));
      } else {
        $propertyNotes .= "/**< The object's " . $propertyName . " property";
      }
      $propertyNotes   .= " \@note This is a property of type 'ipAddress', which is a typedef of \\e NSString. */";      

    } elsif ($propertyType =~ m/^password/) { 
    ##########################################################################
    # PASSWORD
    #'password' types all start with the string 'password' (e.g., "password-crypt-sha256") 
    # Passwords are typically string representations of a json object, and 
    # since we don't know the type of object it could be (e.g., array, string, etc.),
    # we store it as an NSObject
    ##########################################################################
      $objectiveType = "JRPassword *";          

      if ($propertyDesc) {
        $propertyNotes .= "/**< " . ucfirst(trim($propertyDesc));
      } else {
        $propertyNotes .= "/**< The object's " . $propertyName . " property";
      }
      $propertyNotes   .= " \@note This is a property of type 'password', which can be either an \\e NSString or \\e NSDictionary, and is therefore is a typedef of \\e NSObject */";      

    } elsif ($propertyType eq "json") {
    ##########################################################################
    # JSON
    # Properties of type 'json' are typically string representations
    # of a basic json object or primitive type. Since we don't know what
    # type of object the property could be (e.g., array, string, etc.), 
    # we store it as an NSObject
    ##########################################################################
      $objectiveType = "JRJsonObject *";
      
      if ($propertyDesc) {
        $propertyNotes .= "/**< " . ucfirst(trim($propertyDesc));
      } else {
        $propertyNotes .= "/**< The object's \\e " . $propertyName . " property";
      }
      $propertyNotes   .= " \@note This is a property of type 'json', which can be an \\e NSDictionary, \\e NSArray, \\e NSString, etc., and is therefore is a typedef of \\e NSObject */";      

    } elsif ($propertyType eq "uuid") {
    ####################################
    # UUID IS JUST A STRING
    ####################################
      $objectiveType = "JRUuid *";

      if ($propertyDesc) {
        $propertyNotes .= "/**< " . ucfirst(trim($propertyDesc));
      } else {
        $propertyNotes .= "/**< The object's " . $propertyName . " property";
      }
      $propertyNotes   .= " \@note This is a property of type 'uuid', which is a typedef of \\e NSString */";      
      
    } elsif ($propertyType eq "id") {
    ##########################################################################
    # ID
    # If the property is type 'id' and has the name 'id', change the property
    # name to compile in ObjC
    ##########################################################################

      $isId          = 1;
      #$isNotNSObject = 1;
      $objectiveType = "JRObjectId *";#"NSInteger";
      $toDictionary  = $toUpDictionary = $toRplDictionary = "[NSNumber numberWithInteger:[self." . $propertyName . " integerValue]]";#"[NSNumber numberWithInt:self." . $propertyName . "]";
      $frDictionary  = $frUpDictionary = $frRplDictionary = "[NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] integerValue]]";#"[(NSNumber*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] intValue]";

      if ($propertyDesc) {
        $propertyNotes .= "/**< " . ucfirst(trim($propertyDesc));
      } else {
        $propertyNotes .= "/**< The object's \\c " . $propertyName . " property";
      }
      $propertyNotes   .= " \@note The \\e id of the object should not be set. // TODO: etc. */"

    } elsif ($propertyType eq "plural") {
    ##########################################################################
    # PLURAL (ARRAY)
    # If the property is a 'plural' (i.e., a list of strings or sub-objects), 
    # first decide if it's a list of strings or sub-objects by checking the 
    # property's 'attr_defs'. If it's a list of sub-objects, recurse on the 
    # plural's attr_defs', creating the sub-object.  Also, add an NSArray category
    # to the current object's .m file, so that the NSArray of sub-objects can 
    # properly turn themselves into an NSArray of NSDictionaries
    ##########################################################################
      $isArray = 1;
      
      my $propertyAttrDefsRef = $propertyHash{"attr_defs"};
      
      if (isAnArrayOfStrings($propertyAttrDefsRef)) {
        $isSimpleArray = 1;
        
        $objectiveType = "JRStringArray *";      
        
        $extraImportsSection    .= "#import \"JRStringPluralElement.h\"\n";
        
        $simpleArrayType = getSimplePluralType($propertyAttrDefsRef);
        
        $toDictionary    = "[self." . $propertyName . " arrayOfStringPluralDictionariesFromStringPluralElements]";
        #$toUpDictionary  = "[self." . $propertyName . " arrayOfStringPluralUpdateDictionariesFromStringPluralElements]";
        $toRplDictionary = "[self." . $propertyName . " arrayOfStringsFromStringPluralElements]";
        $frDictionary    = "[(NSArray*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:\@\"" . $simpleArrayType . "\" 
                                                                andExtendedPath:[NSString stringWithFormat:\@\"\%\@/" . $propertyName . "\", " . $objectName . ".captureObjectPath]]";
        #$frUpDictionary  = "[(NSArray*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"]
        #        arrayOfStringPluralElementsFromStringPluralDictionariesWithType:\@\"" . $simpleArrayType . "\" 
        #                                                                andPath:[NSString stringWithFormat:\@\"\%\@/" . $propertyName . "\", self.captureObjectPath]]";
        $frRplDictionary = "[(NSArray*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:\@\"" . $simpleArrayType . "\" 
                                                                andExtendedPath:[NSString stringWithFormat:\@\"\%\@/" . $propertyName . "\", self.captureObjectPath]]";

        $replaceArrayIntfSection .= createArrayReplaceMethodDeclaration($propertyName);
        $replaceArrayImplSection .= createArrayReplaceMethodImplementation($propertyName, $simpleArrayType);
        
        if ($propertyDesc) {
          $propertyNotes .= "/**< " . ucfirst(trim($propertyDesc));
        } else {
          $propertyNotes .= "/**< The object's \\c " . $propertyName . " property";
        }
        $propertyNotes   .= " \@note This is an array of \\c JRStringPluralElements with type \\c " . $simpleArrayType . " TODO: Add note about how setting the array requires a replace on capture and how you can set it with an array of stringPluralElements or just an array of strings */";      
        
      } else {

        $objectiveType = "NSArray *";      

        if ($repeatNamesHash{$propertyName}) {
          $propertyName = $objectName . ucfirst($propertyName);
        }
        
        $extraImportsSection    .= "#import \"JR" . ucfirst($propertyName) . ".h\"\n";
        $arrayCategoriesSection .= createArrayCategoryForSubobject ($propertyName);
        $toDictionary    = "[self." . $propertyName . " arrayOf" . ucfirst($propertyName) . "DictionariesFrom" . ucfirst($propertyName) . "Objects]";
        #$toUpDictionary  = "[self." . $propertyName . " arrayOf" . ucfirst($propertyName) . "UpdateDictionariesFrom" . ucfirst($propertyName) . "Objects]";
        $toRplDictionary = "[self." . $propertyName . " arrayOf" . ucfirst($propertyName) . "ReplaceDictionariesFrom" . ucfirst($propertyName) . "Objects]";
        $frDictionary    = "[(NSArray*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] arrayOf" . ucfirst($propertyName) . "ObjectsFrom" . ucfirst($propertyName) . "DictionariesWithPath:" . $objectName . ".captureObjectPath]";
        #$frUpDictionary  = "[(NSArray*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] arrayOf" . ucfirst($propertyName) . "ObjectsFrom" . ucfirst($propertyName) . "DictionariesWithPath:self.captureObjectPath]";
        $frRplDictionary = "[(NSArray*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] arrayOf" . ucfirst($propertyName) . "ObjectsFrom" . ucfirst($propertyName) . "DictionariesWithPath:self.captureObjectPath]";

        $replaceArrayIntfSection .= createArrayReplaceMethodDeclaration($propertyName);
        $replaceArrayImplSection .= createArrayReplaceMethodImplementation($propertyName);

        if ($propertyDesc) {
          $propertyNotes .= "/**< " . ucfirst(trim($propertyDesc));
        } else {
          $propertyNotes .= "/**< The object's \\c " . $propertyName . " property";
        }
        $propertyNotes   .= " \@note This is an array of \\c JR" . ucfirst($propertyName) . " objects */";
        
        ################
        # AND RECURSE!!
        ################
        recursiveParse ($propertyName, $propertyAttrDefsRef, $objectPath, $propertyName, $propertyDesc, 1);
       
      }
      
    } elsif ($propertyType eq "object") {
    ##########################################################################
    # OBJECT (DICTIONARY)
    # If the property is an object itself, recurse on the sub-object's 'attr_defs'
    ##########################################################################
      $isObject = 1;
      
      if ($repeatNamesHash{$propertyName}) {
        $propertyName = $objectName . ucfirst($propertyName);
      }
      
      $objectiveType   = "JR" . ucfirst($propertyName) . " *";
      $toDictionary    = "[self." . $propertyName . " toDictionary]";
      $toUpDictionary  = "[self." . $propertyName . " toUpdateDictionary]";
      $toRplDictionary = "[self." . $propertyName . " toReplaceDictionary]";
      $frDictionary    = "[JR" . ucfirst($propertyName) . " " . $propertyName . "ObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] withPath:" . $objectName . ".captureObjectPath]";
#      $frUpDictionary  = "";#"[JR" . ucfirst($propertyName) . " " . $propertyName . "ObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] withPath:self.captureObjectPath]";
#      $frRplDictionary = "";#"[JR" . ucfirst($propertyName) . " " . $propertyName . "ObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] withPath:self.captureObjectPath]";
      $extraImportsSection .= "#import \"JR" . ucfirst($propertyName) . ".h\"\n";

      if ($propertyDesc) {
        $propertyNotes .= "/**< " . ucfirst(trim($propertyDesc)) . " */";
      } else {
        $propertyNotes .= "/**< The object's " . $propertyName . " property */";
      }

      ################
      # AND RECURSE!!
      ################
      my $propertyAttrDefsRef = $propertyHash{"attr_defs"};
      recursiveParse ($propertyName, $propertyAttrDefsRef, $objectPath, $propertyName, $propertyDesc, $pluralParent);

    } else {
    #########################################################
    # OTHER, SHOULDN'T HAPPEN, BUT JUST MAKE IT AN OBJECT
    #########################################################
      $objectiveType = "NSObject *";
    }

    ##########################################################################
    # Now, to take the property, and add it to all those function's in the 
    # object's .h/.m files
    ##########################################################################

    if ($isRequired) {
    ######################################################
    # If the property *is* required...
    ######################################################

      if ($requiredProperties == 1) { 
      ##########################################################################
      # If the property is the *first* required property, we usually precede it
      # with 'With' in method names
      ##########################################################################

        # e.g., - (id)initWithFoo:(NSObject *)newFoo ...
        $constructorSection[1] .= "With" . ucfirst($propertyName) . ":(" . $objectiveType . ")new" . ucfirst($propertyName);

        # e.g., if (!newFoo ...
        $constructorSection[4] .= "!new" . ucfirst($propertyName);

        # e.g., + (id)objWithFoo:(NSObject *)foo ...
        $classConstructorSection[2] .= "With" . ucfirst($propertyName) . ":(" . $objectiveType . ")" . $propertyName;

        # e.g., return [[[JRObj alloc] initWithFoo:foo ...
        $classConstructorSection[7] .= "With" . ucfirst($propertyName) . ":" . $propertyName;

        # e.g., JRObj *objCopy = [[JRObj allocWithZone:zone] initWithFoo:self.foo ...
        $copyConstructorSection[4]  .= "With" . ucfirst($propertyName) . ":self.$propertyName";
        
      } else {
      ##########################################################################
      # If the property is *not* the first required property, we usually 
      # precede it with 'And' in method names
      ##########################################################################
        
        # e.g., - (id)initWithFoo:(NSObject *)newFoo andBar:(NSObject *)newBar ...
        $constructorSection[1] .= " and" . ucfirst($propertyName) . ":(" . $objectiveType . ")new" . ucfirst($propertyName);

        # e.g., if (!newFoo || !newBar ...
        $constructorSection[4] .= " || !new" . ucfirst($propertyName);

        # e.g., + (id)objWithFoo:(NSObject *)foo andBar:(NSObject *)bar ...
        $classConstructorSection[2] .= " and" . ucfirst($propertyName) . ":(" . $objectiveType . ")" . $propertyName;

        # e.g., return [[[JRObj alloc] initWithFoo:foo andBar:bar ...
        $classConstructorSection[7] .= " and" . ucfirst($propertyName) . ":" . $propertyName;

        # e.g., JRObj *objCopy = [[JRObj allocWithZone:zone] initWithFoo:self.foo andBar:self.bar ...
        $copyConstructorSection[4]  .= " and" . ucfirst($propertyName) . ":self.$propertyName";

      }        
      ##########################################################################
      # For *all* required properties...
      ##########################################################################
      
      # e.g., foo = [newFoo copy];
      $constructorSection[8] .= "        _" . $propertyName . " = [new" . ucfirst($propertyName) . " copy];\n";
      
    } else {
    ######################################################
    # If the property is *not* required...
    ######################################################  
      
      # e.g., objCopy.baz = self.baz;
      $copyConstructorSection[9] .= "    " . $objectName . "Copy." . $propertyName . " = self." . $propertyName . ";\n";

    }
    ##########################################################################
    # For *all* properties...
    ##########################################################################

#      if ($isNotNSObject) {
#        # e.g., obj.baz = [dictionary objectForKey:@"baz"] != [NSNull null] ? [dictionary objectForKey:@"baz"] : nil;
#        $objFromDictSection[16]    .= "\n    " . $objectName . "." . $propertyName . " =\n";
#        $objFromDictSection[16]    .= "        [dictionary objectForKey:\@\"" . $dictionaryKey . "\"] != [NSNull null] ? \n";
#        $objFromDictSection[16]    .= "        " . $frDictionary . " : 0;\n";
#        
#        # e.g., if ([dictionary objectForKey:@"foo"])
#        $updateFromDictSection[8]  .= "\n    if ([dictionary objectForKey:\@\"" . $dictionaryKey . "\"])";
#
#        # e.g., obj.baz = [dictionary objectForKey:@"baz"] != [NSNull null] ? [dictionary objectForKey:@"baz"] : nil;
#        $updateFromDictSection[8]  .= "\n        self." . $propertyName . " = [dictionary objectForKey:\@\"" . $dictionaryKey . "\"] != [NSNull null] ? \n";
#        $updateFromDictSection[8]  .=  "            " . $frUpDictionary . " : 0;\n";
#
#        # e.g., obj.baz = [dictionary objectForKey:@"baz"] != [NSNull null] ? [dictionary objectForKey:@"baz"] : nil;
#        $replaceFromDictSection[8] .= "\n    self." . $propertyName . " =\n";
#        $replaceFromDictSection[8] .= "        [dictionary objectForKey:\@\"" . $dictionaryKey . "\"] != [NSNull null] ? \n";
#        $replaceFromDictSection[8] .= "        " . $frRplDictionary . " : 0;\n";
#        
#        ##########################################################################
#        # Object ids needs to be serialized/deserialized with the key 'id', even 
#        # though that's not what the propertyName is
#        # e.g., [dict setObject:baz forKey:@"baz"];
#        #         OR
#        #       [dict setObject:bazId forKey:@"id"];
#        ##########################################################################
#        $dictFromObjSection[3] .= "    [dict setObject:" . $toDictionary . "\n";
#        $dictFromObjSection[3] .= "             forKey:\@\"" . $dictionaryKey . "\"];\n";
#        
#        $propertiesSection    .= "\@property                   $objectiveType $propertyName;\n";
#        $privateIvarsSection  .= "    " . $objectiveType . " _" . $propertyName . ";\n";
#        $synthesizeSection    .= "\@dynamic $propertyName;\n";    
#    
#      } else {

        # e.g., obj.baz = [dictionary objectForKey:@"baz"] != [NSNull null] ? [dictionary objectForKey:@"baz"] : nil;
        $objFromDictSection[17]     .= "\n    " . $objectName . "." . $propertyName . " =\n";
        $objFromDictSection[17]     .= "        [dictionary objectForKey:\@\"" . $dictionaryKey . "\"] != [NSNull null] ? \n";
        $objFromDictSection[17]     .= "        " . $frDictionary . " : nil;\n";
        
        if (!$isArray) {
          # e.g., if ([dictionary objectForKey:@"foo"])

          if ($isObject) { 

            $updateFromDictSection[9]   .= "\n    if ([dictionary objectForKey:\@\"" . $dictionaryKey . "\"] == [NSNull null])";
            $updateFromDictSection[9]   .= "\n        self." . $propertyName . " = nil;";
            $updateFromDictSection[9]   .= "\n    else if ([dictionary objectForKey:\@\"" . $dictionaryKey . "\"])";
            $updateFromDictSection[9]   .= "\n        [self." . $propertyName . " updateFromDictionary:[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] withPath:self.captureObjectPath];\n";

          } else {
        
            $updateFromDictSection[9]   .= "\n    if ([dictionary objectForKey:\@\"" . $dictionaryKey . "\"])";
     
            # e.g., obj.baz = [dictionary objectForKey:@"baz"] != [NSNull null] ? [dictionary objectForKey:@"baz"] : nil;
            $updateFromDictSection[9]   .= "\n        self." . $propertyName . " = [dictionary objectForKey:\@\"" . $dictionaryKey . "\"] != [NSNull null] ? \n";
            $updateFromDictSection[9]   .= "            " . $frUpDictionary . " : nil;\n";          
        
          }
        }
        
        if ($isObject) { 

          $replaceFromDictSection[9]   .= "\n    if (![dictionary objectForKey:\@\"" . $dictionaryKey . "\"] || [dictionary objectForKey:\@\"" . $dictionaryKey . "\"] == [NSNull null])";
          $replaceFromDictSection[9]   .= "\n        self." . $propertyName . " = nil;";
          $replaceFromDictSection[9]   .= "\n    else";
          $replaceFromDictSection[9]   .= "\n        [self." . $propertyName . " replaceFromDictionary:[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] withPath:self.captureObjectPath];\n";

        } else {
        
          # e.g., obj.baz = [dictionary objectForKey:@"baz"] != [NSNull null] ? [dictionary objectForKey:@"baz"] : nil;
          $replaceFromDictSection[9]  .= "\n    self." . $propertyName . " =\n";
          $replaceFromDictSection[9]  .= "        [dictionary objectForKey:\@\"" . $dictionaryKey . "\"] != [NSNull null] ? \n";
          $replaceFromDictSection[9]  .= "        " . $frRplDictionary . " : nil;\n";
        
        }
        
        # e.g., [dict setObject:(self.baz ? self.baz : [NSNull null]) forKey:@"baz"];
        $dictFromObjSection[3]      .= "    [dict setObject:(self." . $propertyName . " ? " . $toDictionary . " : [NSNull null])\n";
        $dictFromObjSection[3]      .= "             forKey:\@\"" . $dictionaryKey . "\"];\n";
        
        $objectPropertiesSection[3] .= "    [dict setObject:\@\"" . stripPointer($objectiveType) . "\" forKey:\@\"" . $propertyName . "\"];\n";
        
        $destructorSection[2] .= "    [_$propertyName release];\n";
        $propertiesSection    .= "\@property (nonatomic, copy) $objectiveType$propertyName; $propertyNotes \n";
        $privateIvarsSection  .= "    " . $objectiveType . "_" . $propertyName . ";\n";
        $synthesizeSection    .= "\@dynamic $propertyName;\n";
#      }   

      if (!$shouldIgnore) {
        if ($isObject) {

          $toUpdateDictSection[3]  .= "\n    if ([self.dirtyPropertySet containsObject:\@\"" . $propertyName . "\"])\n";
          $toUpdateDictSection[3]  .= "        [dict setObject:(self." . $propertyName . " ?\n" . 
                                      "                              " . $toUpDictionary . " :\n" .
                                      "                              [[JR" . ucfirst($propertyName) . " " . $propertyName . "] toUpdateDictionary]) /* Use the default constructor to create an empty object */\n" . 
                                      "                 forKey:\@\"" . $dictionaryKey . "\"];\n";
        
          $toReplaceDictSection[3] .= "    [dict setObject:(self." . $propertyName . " ?\n" . 
                                      "                          " . $toRplDictionary . " :\n" .
                                      "                          [[JR" . ucfirst($propertyName) . " " . $propertyName . "] toUpdateDictionary]) /* Use the default constructor to create an empty object */\n" . 
                                      "             forKey:\@\"" . $dictionaryKey . "\"];\n";

        } elsif ($isArray) {

          $toReplaceDictSection[3] .= "    [dict setObject:(self." . $propertyName . " ? " . $toRplDictionary . " : [NSArray array]) forKey:\@\"" . $dictionaryKey . "\"];\n";
      
        } else {

          # e.g., if ([self.dirtyPropertySet containsObject:@"foo"])
          #           [dict setObject:self.car forKey:@"foo"];
          $toUpdateDictSection[3]  .= "\n    if ([self.dirtyPropertySet containsObject:\@\"" . $propertyName . "\"])\n";
          $toUpdateDictSection[3]  .= "        [dict setObject:(self." . $propertyName . " ? " . $toUpDictionary . " : [NSNull null]) forKey:\@\"" . $dictionaryKey . "\"];\n";

          $toReplaceDictSection[3] .= "    [dict setObject:(self." . $propertyName . " ? " . $toRplDictionary . " : [NSNull null]) forKey:\@\"" . $dictionaryKey . "\"];\n";

        }      
      }

      if ($isId) {
        #$updateRemotelySection[3]  = "[self." . $propertyName . " integerValue]";
        #$replaceRemotelySection[3] = "[self." . $propertyName . " integerValue]";
        
        $objFromDictSection[12]    = "#%d";
        $objFromDictSection[15]    = ", [(NSNumber*)[dictionary objectForKey:\@\"id\"] integerValue]";#", [" . $objectName . "." . $propertyName . " integerValue]";
        
        $updateFromDictSection[4]  = "#%d";
        $updateFromDictSection[7]  = ", [(NSNumber*)[dictionary objectForKey:\@\"id\"] integerValue]";#", [self." . $propertyName . " integerValue]";
        
        $replaceFromDictSection[4]  = "#%d";
        $replaceFromDictSection[7]  = ", [(NSNumber*)[dictionary objectForKey:\@\"id\"] integerValue]";#", [self." . $propertyName . " integerValue]";
      }

      if ($isSimpleArray) {
        $getterSettersSection .= createGetterSetterForSimpleArray ($propertyName, $simpleArrayType);
      } else {
        $getterSettersSection .= createGetterSetterForProperty ($propertyName, $objectiveType, $isAlsoPrimitive, $isArray); 
      }

  ##########################################################################
  # And loop again...
  ##########################################################################
  }

  ##########################################################################
  # Once we've looped through all of the object's properties, now we 
  # write out all of the functions, declarations, etc. into our .h/.m files
  ##########################################################################
  
  ##########################################################################
  # Add the copyrights ...
  ##########################################################################
  my $hFile = getCopyrightHeader();
  my $mFile = getCopyrightHeader();
  
  ##########################################################################
  # Add the imports ...
  ##########################################################################
  $hFile .= "#import <Foundation/Foundation.h>\n#import \"JRCapture.h\"\n";
  
  ##########################################################################
  # Add any extra imports ...
  ##########################################################################
  $hFile .= $extraImportsSection . "\n";
  
  for (my $i = 0; $i < @doxygenClassDescSection; $i++) { $hFile .= $doxygenClassDescSection[$i]; }
  
  ##########################################################################
  # Declare the interface, add the properties, and add the function
  # declarations
  ##########################################################################
  $hFile .= "\@interface $className : JRCaptureObject\n";# <NSCopying, JRJsonifying>\n";
  $hFile .= $propertiesSection;
    
  if ($requiredProperties) {
    $minConstructorDocSection[5] = $minClassConstructorDocSection[5] = $objFromDictDocSection[5] = 
        " * \n * \@note\n * Method creates a $className object without the required properties TODO:MAKE A LIST!\n * These properties are required when updating the object on Capture.\n"; 
  }
  
  $hFile .= "\n/**\n * \@name Constructors\n **/\n/*\@{*/\n";
  
  for (my $i = 0; $i < @minConstructorDocSection; $i++) { $hFile .= $minConstructorDocSection[$i]; }
  $hFile .= "$minConstructorSection[0];\n\n";
  for (my $i = 0; $i < @minClassConstructorDocSection; $i++) { $hFile .= $minClassConstructorDocSection[$i]; }
  $hFile .= "$minClassConstructorSection[0]$minClassConstructorSection[1];\n\n";
  
  if ($requiredProperties) {
    for (my $i = 0; $i < @constructorDocSection; $i++) { $hFile .= $constructorDocSection[$i]; }
    $hFile .= "$constructorSection[0]$constructorSection[1];\n\n";
    for (my $i = 0; $i < @classConstructorDocSection; $i++) { $hFile .= $classConstructorDocSection[$i]; }
    $hFile .= "$classConstructorSection[0]$classConstructorSection[1]$classConstructorSection[2];\n\n";
  }
  
  for (my $i = 0; $i < @objFromDictDocSection; $i++) { $hFile .= $objFromDictDocSection[$i]; }
  $hFile .= "$objFromDictSection[0]$objFromDictSection[1]$objFromDictSection[2];\n";
  $hFile .= "/*\@}*/\n\n";


  $hFile .= "/**\n * \@name Dictionary Serialization/Deserialization\n **/\n/*\@{*/\n";
  for (my $i = 0; $i < @dictFromObjectDocSection; $i++) { $hFile .= $dictFromObjectDocSection[$i]; }
  $hFile .= "$dictFromObjSection[0];\n\n";
  for (my $i = 0; $i < @updateFrDictDocSection; $i++) { $hFile .= $updateFrDictDocSection[$i]; }
  $hFile .= "$updateFromDictSection[0];\n\n";
  for (my $i = 0; $i < @replaceFrDictDocSection; $i++) { $hFile .= $replaceFrDictDocSection[$i]; }
  $hFile .= "$replaceFromDictSection[0];\n";
  $hFile .= "/*\@}*/\n\n";
  $hFile .= "/**\n * \@name Object Introspection\n **/\n/*\@{*/\n";
  for (my $i = 0; $i < @objectPropertiesDocSection; $i++) { $hFile .= $objectPropertiesDocSection[$i]; }
  $hFile .= "$objectPropertiesSection[0];\n";
  $hFile .= "/*\@}*/\n\n";


  $hFile .= "/**\n * \@name Manage Remotely \n **/\n/*\@{*/\n";
#  for (my $i = 0; $i < @updateRemotelyDocSection; $i++) { $hFile .= $updateRemotelyDocSection[$i]; }
#  $hFile .= "$updateRemotelySection[0];\n\n";
#  for (my $i = 0; $i < @replaceRemotelyDocSection; $i++) { $hFile .= $replaceRemotelyDocSection[$i]; }
#  $hFile .= "$replaceRemotelySection[0];\n";
  $hFile .= $replaceArrayIntfSection;
  $hFile .= "/*\@}*/\n\n";

  
  if (@booleanProperties || @integerProperties) {
    my $total = @booleanProperties + @integerProperties;
    my $current = 1;
    
    $hFile .= "/**\n * \@name Primitive Getters/Setters \n **/\n/*\@{*/\n";

    for (my $i = 0; $i < @booleanProperties; $i++) {
      $hFile .= "/**\n * TODO\n **/\n";
      $hFile .= "- (BOOL)get" . ucfirst($booleanProperties[$i]) . "BoolValue;\n\n";
      $hFile .= "/**\n * TODO\n **/\n";
      $hFile .= "- (void)set" . ucfirst($booleanProperties[$i]) . "WithBool:(BOOL)boolVal;\n";
      
      if ($current != $total) { $hFile .= "\n"; } $current++;
    }
    
    for (my $i = 0; $i < @integerProperties; $i++) {
      $hFile .= "/**\n * TODO\n **/\n";
      $hFile .= "- (NSInteger)get" . ucfirst($integerProperties[$i]) . "IntegerValue;\n\n";
      $hFile .= "/**\n * TODO\n **/\n";
      $hFile .= "- (void)set" . ucfirst($integerProperties[$i]) . "WithInteger:(NSInteger)integerVal;\n";
    
      if ($current != $total) { $hFile .= "\n"; } $current++;
    }

    $hFile .= "/*\@}*/\n\n";
  
    @booleanProperties = ();
    @integerProperties = ();
  }
  
  $hFile .= "\@end\n";


  ##########################################################################
  # Add Dlog
  ##########################################################################
  $mFile .= "#ifdef DEBUG\n#define DLog(fmt, ...) NSLog((\@\"\%s [Line \%d] \" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)\n";
  $mFile .= "#else\n#define DLog(...)\n#endif\n\n#define ALog(fmt, ...) NSLog((\@\"\%s [Line \%d] \" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)\n\n";

  ##########################################################################
  # Import the header
  ##########################################################################
  $mFile .= "\n#import \"$className.h\"\n\n";

  ##########################################################################
  # Add any of the array categories, if needed to parse an array of objects
  ##########################################################################
  $mFile .= $arrayCategoriesSection;
  
  ##########################################################################
  # Declare the implementation, ivars, and the dynamic properties
  ##########################################################################
  $mFile .= "\@interface $className ()\n";
  $mFile .= "\@property BOOL canBeUpdatedOrReplaced;\n";
  $mFile .= "\@end\n\n";
  $mFile .= "\@implementation $className\n";
  $mFile .= "{\n" . $privateIvarsSection . "}\n";
  $mFile .= $synthesizeSection;
  $mFile .= "\@synthesize canBeUpdatedOrReplaced;\n\n";
  $mFile .= $getterSettersSection;
  
  ##########################################################################
  # Loop through our constructor method pieces, adding them to the .m file...
  # If there are any required properties, add the additional sections, 
  # otherwise, skip them
  ##########################################################################
  for (my $i = 0; $i < @minConstructorSection; $i++) {
    $mFile .= $minConstructorSection[$i];
  }

  if ($requiredProperties) {
    for (my $i = 0; $i < @constructorSection; $i++) {  
      $mFile .= $constructorSection[$i];
    }
  }
  
  ##########################################################################
  # Loop through our class constructor pieces...
  # If there are *no* required properties, those sections should be empty,
  # so we can safely loop through all the sections 
  ##########################################################################
  for (my $i = 0; $i < @minClassConstructorSection; $i++) {
    $mFile .= $minClassConstructorSection[$i];
  }

  if ($requiredProperties) {
    for (my $i = 0; $i < @classConstructorSection; $i++) {
      $mFile .= $classConstructorSection[$i];
    }
  }
  
  ##########################################################################
  # Loop through our copy constructor pieces...
  ##########################################################################
  for (my $i = 0; $i < @copyConstructorSection; $i++) {
      $mFile .= $copyConstructorSection[$i];
  }

  ##########################################################################
  # Loop through the rest of our methods, and add '@end'
  ##########################################################################
  for (my $i = 0; $i < @dictFromObjSection; $i++) {
    $mFile .= $dictFromObjSection[$i];
  }
  
  for (my $i = 0; $i < @objFromDictSection; $i++) {
    $mFile .= $objFromDictSection[$i];
  }
  
  for (my $i = 0; $i < @updateFromDictSection; $i++) {
    $mFile .= $updateFromDictSection[$i];
  }
  
  for (my $i = 0; $i < @replaceFromDictSection; $i++) {
    $mFile .= $replaceFromDictSection[$i];
  }

  for (my $i = 0; $i < @toUpdateDictSection; $i++) {
    $mFile .= $toUpdateDictSection[$i];
  }
    
#  for (my $i = 0; $i < @updateRemotelySection; $i++) {
#    $mFile .= $updateRemotelySection[$i];
#  }
  
  for (my $i = 0; $i < @toReplaceDictSection; $i++) {
    $mFile .= $toReplaceDictSection[$i];
  }

#  for (my $i = 0; $i < @replaceRemotelySection; $i++) {
#    $mFile .= $replaceRemotelySection[$i];
#  }

  $mFile .= $replaceArrayImplSection;

  for (my $i = 0; $i < @objectPropertiesSection; $i++) {
    $mFile .= $objectPropertiesSection[$i];
  }
  
  for (my $i = 0; $i < @destructorSection; $i++) {
    $mFile .= $destructorSection[$i];
  }
  
  $mFile .= "\@end\n";  
  
  ##########################################################################
  # Name our files...
  ##########################################################################
  my $hFileName = $className . ".h";
  my $mFileName = $className . ".m";

  ##########################################################################
  # ...and save them for later
  ##########################################################################
  $hFiles{$hFileName} = $hFile;
  $mFiles{$mFileName} = $mFile;
} 
 
my $json = JSON->new->allow_nonref;
 
##########################################################################
# Decode our JSON schema
##########################################################################
my $topMostScalarRef = $json->decode( $schema );

##########################################################################
# If the schema attr_defs is buried in a dictionary, pull them out
##########################################################################
my $attrDefsArrayRef;

if (ref($topMostScalarRef) eq "ARRAY") { 
  $attrDefsArrayRef = $topMostScalarRef;

} elsif (ref($topMostScalarRef) eq "HASH") { 
  my %topMostHashObj = %$topMostScalarRef;
  
  my $schemaDictionaryRef = $topMostHashObj{"schema"};
  my %schemaDictionaryObj = %$schemaDictionaryRef;
  
  $attrDefsArrayRef = $schemaDictionaryObj{"attr_defs"};
}

##########################################################################
# Then recursively parse it...
##########################################################################
recursiveParse ("captureUser", $attrDefsArrayRef, "", "", "", 0);

##########################################################################
# Finally, print our .h/.m files
##########################################################################
my @hFileNames = keys (%hFiles);
my @mFileNames = keys (%mFiles);

my $deviceDir  = "iOS";
my $filesDir   = "iOSFiles";
my $captureDir = "JRCapture";
my $docsDir    = "Docs";

my $canMakeDocs = 1;

unless (-d $deviceDir) {
    mkdir $deviceDir or die "[ERROR] Unable to make the directory '$deviceDir'\n\n";
}

unless (-d "$deviceDir/$captureDir") {
    mkdir "$deviceDir/$captureDir" or die "[ERROR] Unable to make the directory '$deviceDir/$captureDir'\n\n";
}

unless (-d "$deviceDir/$docsDir") {
    mkdir $deviceDir or $canMakeDocs = 0; # or die "[ERROR] Unable to make the directory '$deviceDir'\n\n";
}

my $copyResult = `cp ./iOSFiles/JR* $deviceDir/$captureDir/ 2>&1`;

if ($copyResult) {
  die "[ERROR] Unable to copy necessary files to the '$deviceDir/$captureDir': $copyResult\n\n";
}

foreach my $fileName (@hFileNames) {
  open (FILE, ">$deviceDir/$captureDir/$fileName") or die "[ERROR] Unable to open '$deviceDir/$captureDir/$fileName' for writing\n\n";
  print "Writing $fileName... ";
  print FILE $hFiles{$fileName};
  print "Finished $fileName.\n";
}

foreach my $fileName (@mFileNames) {
  open (FILE, ">$deviceDir/$captureDir/$fileName") or die "[ERROR] Unable to open '$deviceDir/$captureDir/$fileName' for writing\n\n";
  print "Writing $fileName... ";
  print FILE $mFiles{$fileName};
  print "Finished $fileName.\n";
}

# TODO: Better success/fail reporting if doxygen works or not
my $doxygenResult = `doxygen ./Doxygen/Doxyfile 2>&1`;
print $doxygenResult;

print "\n[SUCCESS] Capture schema successfully parsed.\n\n"
