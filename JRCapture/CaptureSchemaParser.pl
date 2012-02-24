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

#!/usr/bin/perl
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
my $IS_PLURAL_TYPE     = 1;
my $IS_NOT_PLURAL_TYPE = 0;


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
# HELPER METHODS
############################################
sub isAnArrayOfStrings {
  my $arrayRef    = $_[0];
  my @attrDefsArr = @$arrayRef;

  if (@attrDefsArr > 1) {
    return 0;
  }
  
  my $hashRef = $attrDefsArr[0];
  my %propertyHash = %$hashRef;
  my $propertyType = $propertyHash{"type"};

  if ($propertyType eq "string") {
    return 1;
  } else {
    return 0;
  }
}

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

######################################################################
# RECURSIVE PARSING METHOD
#
# Method takes 3 arguments, the object name, a list of the 
# object's properties (as a reference to an array of properties),
# and whether the object (or sub-object) is an "plural object".
#
# *Properties* that are sub-objects themselves, or lists of 
# sub-objects (plural properties), have their sub-objects 
# recursively parsed.
#
# For each object/sub-object, method will write the appropriate
# .h and .m files.  The .h/.m files include an instance constructor, 
# class constructor, copy constructor, destructor, a method to 
# convert the object to NSArrays/NSDictionaries for easy
# jsonification, and synthesized accessors for all of its properties.
# Required properties are treated as such in the constructors, etc.
#
# Arguments:
#   0:  The name of the object, with a lower-cased first letter and
#       camel-cased rest
#   1:  A reference (pointer) to the array of properties.  Each 
#       property is a hash of attributes
#   2:  If the sub-object is a 'plural' it is treated ???
######################################################################

sub recursiveParse {

  my $objectName = $_[0];
  my $arrRef     = $_[1];

  $repeatNamesHash{$objectName} = 1;
  
  ################################################
  # Dereference the list of properties
  ################################################
  my @propertyList = @$arrRef;


  ################################################
  # Initialize the sections of the .h/.m files
  ################################################
  my $extraImportsSection     = "";
  my $propertiesSection       = "";
  my $arrayCategoriesSection  = "";
  my $synthesizeSection       = "";
  my @constructorSection      = getConstructorParts();
  my @classConstructorSection = getClassConstructorParts();
  my @copyConstructorSection  = getCopyConstructorParts();
  my @destructorSection       = getDestructorParts();
  my @makeDictionarySection   = getToDictionaryParts();
  my @makeObjectSection       = getFromDictionaryParts();
  my @updateObjectSection     = getUpFromDictionaryParts();

  
  ######################################################
  # Create the class name of an object
  # e.g., 'primaryAddress' becomes 'JRPrimaryAddress'
  ######################################################
  my $className = "JR" . ucfirst($objectName);
 
  print "Parsing object $className...\n";
  
  ##############################################################
  # Parts of the class constructor, copy constructor, and other 
  # methods reference the object name and class name in a 
  # few, specific places in their implementation
  #
  # e.g., 
  # JRUserObject *userObjectCopy =
	#			[[JRUserObject allocWithZone:zone] init];
  ######################################################
  $classConstructorSection[1] = $objectName;
  $classConstructorSection[5] = $className;
  
  $copyConstructorSection[2]  = "    " . $className . " *" . $objectName . "Copy =\n                [[" . $className;
  $copyConstructorSection[8]  = $objectName . "Copy";
  
  $makeObjectSection[1]       = $objectName;
  $makeObjectSection[4]       = "    " . $className . " *" . $objectName . " =\n";
  $makeObjectSection[6]       = $className . " " . $objectName;
  $makeObjectSection[11]      = $objectName;

  
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


    ######################################################
    # Make sure the property name isn't an ObjC keyword
    ######################################################
    if ($propertyName eq "id") {
        $propertyName = $objectName . ucfirst($propertyName);
    }
    
    # TODO: Check for other keywords!

    ######################################################
    # Initialize property attributes to default values
    ######################################################
    my $objectiveType = "";            # Property type in Objective-C (e.g., NSString*)
    my $toDictionary  = $propertyName; # Default operation is to just stick the NSObject into an NSMutableDictionary
    my $frDictionary  =                # Default operation is to just pull the NSObject from the dictionary and stick it into the property
          "[dictionary objectForKey:\@\"$propertyName\"]";
    my $isBooleanType = 0;             # If it's a boolean, we do things differently
    my $isArrayType   = 0;             # If it's an array (plural), we do things differently
    my $propertyNotes = "";            # Comment that provides more infomation if necessary for a property 
                                       # (e.g., in the case of an array of objects versus and array of strings)
    
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

    } elsif ($propertyType eq "boolean") {
    ##################
    # BOOLEAN
    ##################
      $isBooleanType = 1;
      $objectiveType = "BOOL";
      $toDictionary = "[NSNumber numberWithBool:$propertyName]";
      $frDictionary = "[(NSNumber*)[dictionary objectForKey:\@\"$propertyName\"] boolValue]";

    } elsif ($propertyType eq "integer") {
    ##################
    # INTEGER
    ##################
      $objectiveType = "NSNumber *";

    } elsif ($propertyType eq "decimal") {
    ##################
    # NUMBER
    ##################
      $objectiveType = "NSNumber *";

    } elsif ($propertyType eq "date") {
    ##################
    # DATE
    ##################
      $objectiveType = "NSDate *";
      $toDictionary = "[$propertyName stringFromISO8601Date]";
      $frDictionary = "[NSDate dateFromISO8601DateString:[dictionary objectForKey:\@\"$propertyName\"]]";

    } elsif ($propertyType eq "dateTime") {
    ##################
    # DATETIME
    ##################

      $objectiveType = "NSDate *";
      $toDictionary = "[$propertyName stringFromISO8601DateTime]";
      $frDictionary = "[NSDate dateFromISO8601DateTimeString:[dictionary objectForKey:\@\"$propertyName\"]]";

    } elsif ($propertyType =~ m/^password/) { 
    ##########################################################################
    # PASSWORD
    #'password' types all start with the string 'password' (e.g., "password-crypt-sha256") 
    # Passwords are typically string representations of a json object, and 
    # since we don't know the type of object it could be (e.g., array, string, etc.),
    # we store it as an NSObject
    ##########################################################################
      $objectiveType = "NSObject *";          

    } elsif ($propertyType eq "json") {
    ##########################################################################
    # JSON
    # Properties of type 'json' are typically string representations
    # of a basic json object or primitive type. Since we don't know what
    # type of object the property could be (e.g., array, string, etc.), 
    # we store it as an NSObject
    ##########################################################################
      
      $objectiveType = "NSObject *";
      $propertyNotes = "/* This is a property of type 'json', and therefore can be an NSDictionary, NSArray, NSString, etc. */";      

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

      $objectiveType = "NSArray *";                               
      my $propertyAttrDefsRef = $propertyHash{"attr_defs"};
      
      if (isAnArrayOfStrings($propertyAttrDefsRef)) {
        $propertyNotes = "/* This is an array of strings */";      
        
      } else {
        
        if ($repeatNamesHash{$propertyName}) {
          $propertyName = $objectName . ucfirst($propertyName);
        }
        
        $extraImportsSection    .= "#import \"JR" . ucfirst($propertyName) . ".h\"\n";
        $arrayCategoriesSection .= createArrayCategoryForSubobject ($propertyName);
        $toDictionary  = "[$propertyName arrayOf" . ucfirst($propertyName) . "DictionariesFrom" . ucfirst($propertyName) . "Objects]";
        $frDictionary  = "[(NSArray*)[dictionary objectForKey:\@\"" . $propertyName . "\"] arrayOf" . ucfirst($propertyName) . "ObjectsFrom" . ucfirst($propertyName) . "Dictionaries]";
        $propertyNotes = "/* This is an array of JR" . ucfirst($propertyName) . " */";
        
        recursiveParse ($propertyName, $propertyAttrDefsRef);
        
      }
      
    } elsif ($propertyType eq "object") {
    ##########################################################################
    # OBJECT (DICTIONARY)
    # If the property is an object itself, recurse on the sub-object's 'attr_defs'
    ##########################################################################
      
      if ($repeatNamesHash{$propertyName}) {
        $propertyName = $objectName . ucfirst($propertyName);
      }
      
      $objectiveType = "JR" . ucfirst($propertyName) . " *";
      $toDictionary  = "[$propertyName dictionaryFromObject]";
      $frDictionary  = "[JR" . ucfirst($propertyName) . " " . $propertyName . "ObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:\@\"" . $propertyName . "\"]]";
      $extraImportsSection .= "#import \"JR" . ucfirst($propertyName) . ".h\"\n";

      my $propertyAttrDefsRef = $propertyHash{"attr_defs"};
      recursiveParse ($propertyName, $propertyAttrDefsRef);

    } else {
    ################################
    # OTHER - JUST MAKE IT A STRING
    ################################
      $objectiveType = "NSString *";
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

        # e.g., JRObj *obj = [JRObj objWithFoo:[dictionary objectForKey:@"foo"] ...
        $makeObjectSection[7] .= "With" . ucfirst($propertyName) . ":" . $frDictionary;
        
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

        # e.g., JRObj *obj = [JRObj objWithFoo:[dictionary objectForKey:@"foo"] andBar:[dictionary objectForKey:@"bar"] ...
        $makeObjectSection[7] .= " and" . ucfirst($propertyName) . ":" . $frDictionary;
      }        
      ##########################################################################
      # For *all* required properties...
      ##########################################################################
      
      # e.g., foo = [newFoo copy];
      $constructorSection[8] .= "        " . $propertyName . " = [new" . ucfirst($propertyName) . " copy];\n";
      
      # e.g., [dict setObject:foo forKey:@"foo"];
      $makeDictionarySection[3] .= "    [dict setObject:" . $toDictionary . " forKey:\@\"" . $propertyName . "\"];\n";
      
    } else {
    ######################################################
    # If the property is *not* required...
    ######################################################

      # e.g., if (baz)
      $makeDictionarySection[4] .= "\n    if (" . $propertyName . ")\n";

      # e.g., [dict setObject:baz forKey:@"baz"];
      $makeDictionarySection[4] .= "        [dict setObject:" . $toDictionary . " forKey:\@\"" . $propertyName . "\"];\n";
      
      # e.g., objCopy.baz = self.baz;
      $copyConstructorSection[6] .= "    " . $objectName . "Copy." . $propertyName . " = self." . $propertyName . ";\n";
      
      # e.g., obj.baz = [dictionary objectForKey:@"baz"];
      $makeObjectSection[8] .= "\n    " . $objectName . "." . $propertyName . " = " . $frDictionary . ";";
    }
    ##########################################################################
    # For *all* properties...
    ##########################################################################

      # e.g., if ([dictionary objectForKey:@"foo"])
      #           self.foo = [dictionary objectForKey:@"foo"];
      $updateObjectSection[2] .= "\n    if ([dictionary objectForKey:\@\"" . $propertyName . "\"])";
      $updateObjectSection[2] .= "\n        self." . $propertyName . " = " . $frDictionary . ";\n";
      
    if ($isBooleanType) {
      $propertiesSection    .= "\@property                   $objectiveType $propertyName;\n";
      $synthesizeSection    .= "\@synthesize $propertyName;\n";    
    } else {
      $destructorSection[2] .= "    [$propertyName release];\n";
      $propertiesSection    .= "\@property (nonatomic, copy) $objectiveType$propertyName; $propertyNotes \n";
      $synthesizeSection    .= "\@synthesize $propertyName;\n";
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
  $hFile .= "\n#import <Foundation/Foundation.h>\n#import \"JRCapture.h\"\n";
  
  ##########################################################################
  # Add any extra imports ...
  ##########################################################################
  $hFile .= $extraImportsSection . "\n";
  
#  my $extraDelegates = "";
#  if ($className eq 'JRProfiles') {
#    $extraDelegates = ", JRProfilesAssumedPresence";
#  }
  
  ##########################################################################
  # Declare the interface, add the properties, and add the function
  # declarations
  ##########################################################################
  $hFile .= "\@interface $className : NSObject <NSCopying, JRJsonifying>\n";
  $hFile .= $propertiesSection;
  $hFile .= "$constructorSection[0]$constructorSection[1];\n";
  $hFile .= "$classConstructorSection[0]$classConstructorSection[1]$classConstructorSection[2];\n";
  $hFile .= "$makeObjectSection[0]$makeObjectSection[1]$makeObjectSection[2];\n";
  $hFile .= "$updateObjectSection[0];\n";
  $hFile .= "\@end\n";

  ##########################################################################
  # Import the header
  ##########################################################################
  $mFile .= "\n#import \"$className.h\"\n\n";

  ##########################################################################
  # Add any of the array categories, if needed to parse an array of objects
  ##########################################################################
  $mFile .= $arrayCategoriesSection;
  
  ##########################################################################
  # Declare the implementation and synthesize the properties
  ##########################################################################
  $mFile .= "\@implementation $className\n";
  $mFile .= $synthesizeSection . "\n";
  
  ##########################################################################
  # Loop through our constructor method pieces, adding them to the .m file...
  # If there are any required properties, add the additional sections, 
  # otherwise, skip them
  ##########################################################################
  for (my $i = 0; $i < @constructorSection; $i++) {
    if ($i != 0 && $i != 2 && $i != 7 && $i != 9) {
      if ($requiredProperties) {     
        $mFile .= $constructorSection[$i];
      }
    } else {
      $mFile .= $constructorSection[$i];
    }
  }

  ##########################################################################
  # Loop through our class constructor pieces...
  # If there are *no* required properties, those sections should be empty,
  # so we can safely loop through all the sections 
  ##########################################################################
  for (my $i = 0; $i < @classConstructorSection; $i++) {
    $mFile .= $classConstructorSection[$i];
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
  for (my $i = 0; $i < @makeObjectSection; $i++) {
    $mFile .= $makeObjectSection[$i];
  }

  for (my $i = 0; $i < @makeDictionarySection; $i++) {
    $mFile .= $makeDictionarySection[$i];
  }
  
  for (my $i = 0; $i < @updateObjectSection; $i++) {
    $mFile .= $updateObjectSection[$i];
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
recursiveParse ("captureUser", $attrDefsArrayRef);

##########################################################################
# Finally, print our .h/.m files
##########################################################################
my @hFileNames = keys (%hFiles);
my @mFileNames = keys (%mFiles);

my $deviceDir  = "iOS";
my $filesDir   = "iOSFiles";
my $captureDir = "JRCapture";

unless (-d $deviceDir) {
    mkdir $deviceDir or die "[ERROR] Unable to make the directory '$deviceDir'\n\n";
}

unless (-d "$deviceDir/$captureDir") {
    mkdir "$deviceDir/$captureDir" or die "[ERROR] Unable to make the directory '$deviceDir/$captureDir'\n\n";
}

my $copyResult = `cp ./iOSFiles/* $deviceDir/$captureDir/ 2>&1`;

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

print "\n[SUCCESS] Capture schema successfully parsed.\n\n"
