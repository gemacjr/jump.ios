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
our ($opt_o);
our ($opt_f);
getopt('fo');
my $schemaName = $opt_f;
my $schema = "";

if ($schemaName) {
  $schema = openSchemaNamed ($schemaName);
} else {
  $schema = getCaptureSchema (0, "");
}

########################################################################
# Next, if the output directory was passed in on the command line
# with the option '-o', remember it
########################################################################
# our ($opt_o);
# getopt('o');
my $outputDir = $opt_o;

print "output directory: $outputDir\n";

############################################
# CONSTANTS
############################################
my $IS_PLURAL_ELEMENT  = 1;
my $NOT_PLURAL_ELEMENT = 0;
my $HAS_PLURAL_PARENT  = 1;
my $NO_PLURAL_PARENT   = 0;

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


##################################################
# Get a property's constraints
##################################################
sub getConstraints {
  my $hashRef = $_[0];
  my %propertyHash = %$hashRef;
  
  my $constraintsArrRef = $propertyHash{"constraints"};
  
  if (!$constraintsArrRef) {
    return;
  }
  
  my @constraintsArray = @$constraintsArrRef; 
  my %constraintsHash = map { $_ => 1 } @constraintsArray;
  
  return %constraintsHash;
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


##############################################################################################################
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
##############################################################################################################

sub recursiveParse {

  my $objectName      = $_[0];
  my $arrRef          = $_[1];
  my $parentPath      = $_[2];
  my $pathAppend      = $_[3];
  my $isPluralElement = $_[4];
  my $hasPluralParent = $_[5];
  my $objectDesc      = $_[6];

  my $className;
  my $objectPath;

  ################################################
  # Arrays to keep track of boolean and integers
  ################################################
  my @booleanProperties;
  my @integerProperties;

  ######################################################
  # Keep track of how many properties are required
  ######################################################
  my $requiredProperties = 0;

  ######################################################################################################################
  # Dereference the list of properties from the array reference (pointer) passed into this function. Each object has a 
  # list of properties defined in the schema as the object's 'attr_defs' array. Each element in the list is a 
  # reference (pointer) to a hash of attributes of the property. We will loop through this array later.
  ######################################################################################################################
  my @propertyList = @$arrRef;

  ################################################
  # Add the object name to the repeatNamesHash
  ################################################
  $repeatNamesHash{$objectName} = 1;

  ######################################################################################################################
  # Create the object's path. Object path depends on if the object is a descendant of a plural element and if it falls
  # under the special case of the top-level object and its direct descendants
  # e.g.:
  #   /firstChild
  #     OR
  #   /firstChild/secondChild
  ######################################################################################################################
  # TODO: Don't create if child of plural??
  if ($parentPath eq "/") { 
    $objectPath = $parentPath . $pathAppend;
  } else {
    $objectPath = $parentPath . "/" . $pathAppend;
  }
  

  ######################################################################################################################
  # Initialize the sections of the .h/.m files from the stubbed out methods in the file ObjCMethodParts.pl. Most of the
  # sections are arrays of strings, where each array element is either a known bit of text or an empty string.  Empty 
  # strings get filled in as the script runs. Once an object has been parsed, the script loops through the entire 
  # array, printing it to the .m file, and subsequently writing valid Objective-C. The first few elements of the array 
  # get written to the .h file (as the method signature), and the documentation arrays get unrolled to the .h file as 
  # well (as Doxygen comments).
  # 
  # For example, the array holding the pieces of the dealloc method looks like this:
  #
  # my @destructorParts = (
  # "- (void)dealloc",
  # "\n{\n",
  # "", 
  # "\n    [super dealloc];",
  # "\n}\n");
  #   
  # The array contains 5 elements, and the first two and last two are fixed; that is, they are the same pieces of text 
  # for every object. The third element is an empty string, and it gets filled in with "[<propertyName release];" as 
  # each of the object's properties are parsed. Once unrolled into the .m file, the resulting code looks like this:
  #
  # - (void)dealloc
  # {
  #     [_propertyOne release];
  #     [_propertyTwo release];
  #       ...
  #
  #     [super dealloc];
  # }
  #
  # There are two primary places at which an array element gets filled in during the running of this script:
  #
  # 1. The first place, in the beginning of the recursiveParse method, is the "one-time additions" filling-in; There are 
  #    certain methods/sections that require an object's name or class name, such as in the class and copy constructors.
  #    These sections are edited once per object. That is, the array elements are updated once, usually with the name of
  #    the object or it's class.
  #
  #    For example, the array holding the pieces of the minimal class constructor method looks like this:
  #
  #    my @minClassConstructorParts = (
  #    "+ (id)","",
  #    "\n{\n",
  #    "    return [[[",""," alloc] init] autorelease];",
  #    "\n}\n\n"); 
  #
  #    The first, third, fourth, sixth, and seventh elements are fixed; they do not change.  The second and fifth
  #    elements are empty.  They get filled in with the object's name (e.g., 'exampleElement') and class name (e.g., 
  #    JRExampleElement):
  #  
  #    $minClassConstructorSection[1] = $objectName;
  #    $minClassConstructorSection[4] = $className;
  # 
  #    The final method will look like this:
  #
  #    + (id)exampleElement
  #    {
  #        return [[[JRExampleElement alloc] init] autorelease];
  #    }
  #
  # 2. The second place, as the script loops through an object's properties, and after it determines a property's name
  #    and type, is the "appended property additions" filling-in.  There are certain methods/sections that do stuff
  #    for each property of an object, such as releasing each property in the dealloc.  These sections are appended to
  #    for each property an object contains.  That is, the script loops through an object's properties, and the array 
  #    elements are appended to for each one encountered.
  #
  #    In the example of the dealloc method above, the third array element has "[<propertyName> release];" appended to
  #    it, for each property of the object.
  #
  #    Some sections of the .h/.m files, such as the getters/setters, consist entirely of these "appended property
  #    additions" and have no other text. In these cases, using/unrolling arrays is not needed. These are just empty 
  #    strings defined below.
  #
  # The file ObjCMethodParts.pl has the stubbed out methods/sections with comments describing each method and detailing
  # exactly what each will look like in its final form.
  ######################################################################################################################
  my $extraImportsSection        = ""; 
  my $propertiesSection          = "";
  my $privateIvarsSection        = "";
  my $arrayCategoriesSection     = "";
  my $synthesizeSection          = ""; # Well, now it's all dynamic, but the section is still needed
  my $getterSettersSection       = "";
  my $replaceArrayIntfSection    = "";
  my $replaceArrayImplSection    = "";
  my $arrayCompareIntfSection    = "";
  my $arrayCompareImplSection    = "";
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
  my @needsUpdateSection         = getNeedsUpdateParts();
  my @isEqualObjectSection       = getIsEqualObjectParts();
  my @objectPropertiesSection    = getObjectPropertiesParts();
  
  my @doxygenClassDescSection       = getDoxygenClassDescParts();  
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
  my @needsUpdateDocSection         = getNeedsUpdateDocParts();
  my @isEqualObjectDocSection       = getIsEqualObjectDocParts();
  my @objectPropertiesDocSection    = getObjectPropertiesDocParts();


  ######################################################################
  # Create the class name of an object, adding 'Element' if the object
  # is in a plural (but not an object in an object in a plural).
  # e.g.:
  #   'primaryAddress' becomes 'JRPrimaryAddress' or
  #   'statuses' becomes 'JRStatusesElement'
  ######################################################################
  if ($isPluralElement) {
    $className   = "JR" . ucfirst($objectName) . "Element";  
    $objectName .= "Element";
  } else {
    $className = "JR" . ucfirst($objectName);  
  }
 
  print "Parsing object $className...\n";
  
  
  ########################################################################
  # "ONE-TIME ADDITIONS": FILL IN METHODS WITH OBJECT NAME AND CLASS NAME
  ########################################################################
  
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

  ############################
  # DOXYGEN STUFF
  ############################

  # Doxygen class documentation...
  # Use what's in the schema or make a generic comment  
  if ($objectDesc) {
    $doxygenClassDescSection[1]      = ucfirst(trim($objectDesc));
  } else {
    $doxygenClassDescSection[1]      = "A " . $className . " object";
  }

  # e.g.:
  #   /**                                                                    
  #    * Default constructor. Returns an empty JRExampleElement object.         
  #    *                                                                     
  #    * @return                                                             
  #    *   A JRExampleElement object                                            
  $minConstructorDocSection[1] = $className;
  $minConstructorDocSection[3] = $className;

  # e.g.:
  #   /**
  #    * Returns a JRExampleElement object initialized with the given foo and bar
  #      ...
  #    * @return
  #    *   A JRExampleElement object initialized with the given foo and bar
  $constructorDocSection[1] = $className;
  $constructorDocSection[7] = $className;

  # e.g.:
  #   /**
  #    * Returns an empty JRExampleElement object      
  #    *                                            
  #    * @return                                    
  #    *   A JRExampleElement object                   
  $minClassConstructorDocSection[1] = $className;
  $minClassConstructorDocSection[3] = $className;

  # e.g.:
  #   /**
  #    * Returns a JRExampleElement object initialized with the given foo and bar
  #      ...
  #    * @return
  #    *   A JRExampleElement object initialized with the given foo and bar
  $classConstructorDocSection[1] = $className;
  $classConstructorDocSection[7] = $className;
  
  # e.g.:
  #   /**                                           
  #    * Returns a JRExampleElement object created from an \\e NSDictionary
  #    * representing the object
  #      ...
  #    * @return
  #    *   A JRExampleElement object created from an \e NSDictionary.                       
  #    *   If the \e NSDictionary is \e nil, returns \e nil 
  $objFromDictDocSection[1] = $className;
  $objFromDictDocSection[3] = $className;
  
  # e.g.:
  #   /**
  #    * Creates an \e NSDictionary represention of a JRExampleElement object
  #    * populated with all of the object's properties, as the dictionary's 
  #    * keys, and the properties' values as the dictionary's values
  #    *
  #    * \@return
  #    *   An \e NSDictionary represention of a JRExampleElement object
  $dictFromObjectDocSection[1] = $className;
  $dictFromObjectDocSection[3] = $className;


  ############################
  # CODE STUFF
  ############################

  # e.g.:
  #   + (id)exampleElement    
  #   {                                             
  #       return [[[JRExampleElement alloc] init] autorelease]; 
  $minClassConstructorSection[1]    = $objectName;
  $minClassConstructorSection[4]    = $className;

  # e.g.:
  #   + (id)exampleElementWithFoo:(NSObject *)foo andBar:(NSObject *)bar ...
  #   {                                             
  #       return [[[JRExampleElement alloc] initWithFoo:foo andBar:bar] autorelease]; 
  $classConstructorSection[1] = $objectName;
  $classConstructorSection[5] = $className;

  # e.g.:
  #   JRExampleElement *exampleElementCopy =
  #             [[JRExampleElement allocWithZone:zone] init...
  #
  #   exampleElementCopy.captureObjectPath = self.captureObjectPath;
  $copyConstructorSection[2]  = "    " . $className . " *" . $objectName . "Copy = (" . $className . " *)";
  $copyConstructorSection[6]  = $objectName . "Copy";
  
  # e.g.:
  #   + (id)exampleElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
  $objFromDictSection[1]      = $objectName;
  
  if (!$isPluralElement) {
    # e.g.:
    #   + (id)exampleObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
    $objFromDictSection[1]   .= "Object";
  }
  
  # e.g.:
  #   JRExampleElement *exampleElement = [JRExampleElement exampleElement];
  $objFromDictSection[5]      = "    " . $className . " *" . $objectName;
  $objFromDictSection[7]      = $className . " " . $objectName;

  # e.g.:
  #   [exampleElement.dirtyPropertySet removeAllObjects];
  #   [exampleElement.dirtyArraySet removeAllObjects];
  #  
  #    return exampleElement;
  $objFromDictSection[19]     = $objectName;
  $objFromDictSection[21]     = $objectName;
  $objFromDictSection[23]     = $objectName;
  
  # e.g.:
  #   - (BOOL)isEqualToExampleElement:(JRExampleElement *)otherExampleElement
  #   {
  $isEqualObjectSection[1]    = ucfirst($objectName) . ":(" . $className . " *)other" . ucfirst($objectName);
  #$isEqualObjectSection[4]    = ucfirst($objectName);
  
  ################################################################################
  # Deal with the Capture path and id depending on whether the object itself
  # is an element of a plural or if it is a decendent of an object in a plural
  ################################################################################
  
  if ($isPluralElement) {
  ################################################################################
  # The Capture path needs to be created dynamically, once we know the id of the
  # plural element. We can only get from deserializing the JSON returned by 
  # Capture or other sources or by copying it from another object.  In our
  # deserialization methods, we create the path dynamically by taking the 
  # capturePath passed in to the method, and then appending the object's 
  # name (from the pathAppend argument), the pound sign, and the id extracted
  # from the dictionary.
  #
  # Path would look like /exampleObject/examplePluralElement#55
  ################################################################################
  
    # e.g.:
    #   exampleElement.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"exampleElement", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
    $objFromDictSection[10]    = $objectName;
    $objFromDictSection[14]    = "\@\"" . $pathAppend . "\"";  
    $objFromDictSection[12]    = "#%d";
    $objFromDictSection[15]    = ", [(NSNumber*)[dictionary objectForKey:\@\"id\"] integerValue]";
    
    # e.g.:
    #   self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"exampleElement", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
    $updateFromDictSection[6]  = "\@\"" . $pathAppend . "\"";  
    $updateFromDictSection[4]  = "#%d";
    $updateFromDictSection[7]  = ", [(NSNumber*)[dictionary objectForKey:\@\"id\"] integerValue]";

    # e.g.:
    #   self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"exampleElement", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
    $replaceFromDictSection[6] = "\@\"" . $pathAppend . "\"";      
    $replaceFromDictSection[4] = "#%d";
    $replaceFromDictSection[7] = ", [(NSNumber*)[dictionary objectForKey:\@\"id\"] integerValue]";
  
  } elsif ($hasPluralParent) {
  ################################################################################
  # The Capture path still needs to be created dynamically with id of the 
  # parent plural element. We can only get from deserializing the JSON returned
  # by Capture or other sources or by copying it from another object, but we 
  # don't have an id for the object directly.  In our deserialization methods, 
  # we create the path dynamically by taking the capturePath passed in to the 
  # method, and then appending the object's name (from the pathAppend argument)
  #
  # Path would look like /exampleObject/examplePluralElement#55/exampleSubobject
  ################################################################################

    # e.g.:
    #   exampleElement.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"exampleElement"];
    $objFromDictSection[10]    = $objectName;
    $objFromDictSection[14]    = "\@\"" . $pathAppend . "\"";  
    
    # e.g.:
    #   self.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"exampleElement"];
    $updateFromDictSection[6]  = "\@\"" . $pathAppend . "\"";  
    $replaceFromDictSection[6] = "\@\"" . $pathAppend . "\"";      
  
  } else {
  ################################################################################
  # Let's just remove this bit from the methods altogether
  ################################################################################
    
    for (my $i = 9; $i <= 16; $i++) { $objFromDictSection[$i]     = ""; }
    for (my $i = 3; $i <= 8;  $i++) { $updateFromDictSection[$i]  = ""; }
    for (my $i = 3; $i <= 8;  $i++) { $replaceFromDictSection[$i] = ""; }
  
  }

  if ($hasPluralParent) {
  ################################################################################
  # For all plural elements and their children, until an id has been assigned
  # their paths are unknown and they can't be updated or replaced on Capture.
  # Set these values in the constructors to indicate this.
  ################################################################################
  
    # e.g.:
    #   self.captureObjectPath      = @"";
    #   self.canBeUpdatedOrReplaced = NO;
    $minConstructorSection[3]  = "        self.captureObjectPath      = \@\"\";\n";
    $minConstructorSection[3] .= "        self.canBeUpdatedOrReplaced = NO;\n";
    
    # e.g.:
    #   self.captureObjectPath      = @"";
    #   self.canBeUpdatedOrReplaced = NO;
    $constructorSection[8]     = "        self.captureObjectPath      = \@\"\";\n";
    $constructorSection[8]    .= "        self.canBeUpdatedOrReplaced = NO;\n";
    
    # e.g.:
    #   self.canBeUpdatedOrReplaced = NO;
    $objFromDictSection[17]   .= "// TODO: Is this safe to assume?\n    " . $objectName . ".canBeUpdatedOrReplaced = YES;\n";

  } else {
  ################################################################################
  # Otherwise, the capture path is known and we can set this in the constructors.
  ################################################################################

    #### Special case ####
    if ($objectName eq "captureUser") {      

      # e.g.:
      #   self.captureObjectPath = @"";
      $minConstructorSection[3] = "        self.captureObjectPath = \@\"\";\n";
      $constructorSection[8]    = "        self.captureObjectPath = \@\"\";\n";

    } else {

      # e.g.:
      #   self.captureObjectPath = @"/primaryAddress";
      $minConstructorSection[3] = "        self.captureObjectPath = \@\"" . $objectPath . "\";\n";
      $constructorSection[8]    = "        self.captureObjectPath = \@\"" . $objectPath . "\";\n";

    }

    #########################################################
    # These objects can always be updated and replaced
    #########################################################
    $minConstructorSection[3] .= "        self.canBeUpdatedOrReplaced = YES;\n";
    $constructorSection[8]    .= "        self.canBeUpdatedOrReplaced = YES;\n";

  }
  
  ################################################################################################
  # Each object has a list of properties defined in the schema as the object's 'attr_defs' array. 
  # Each element in the list contains a reference (pointer) to a hash describing that property.
  # Loop through the list, dereference the hash, determine the property name and type, set
  # the code snippets, and append to the stubbed-out code arrays...
  ################################################################################################
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

    my %propertyConstraints = getConstraints(\%propertyHash);

#   my $isRequired = getIsRequired (\%propertyHash); 

    
    ### Find out if it's a required property, and increase the requiredProperties counter if it is  
    my $isRequired = exists($propertyConstraints{"required"});
    if ($isRequired) { 
      $requiredProperties++;
    }
    
    ######################################################
    # Initialize property attributes to default values
    ######################################################
    my $objectiveType   = "";             # Property type in Objective-C (e.g., NSString*)
    my $isAlsoPrimitive = 0;              # If it's a boolean or integer we add special accessor methods
    my $isObject        = 0;              # If it's an object, we do things differently
    my $isArray         = 0;              # If it's an array (plural), we do things differently
    my $isSimpleArray   = 0;              # If it's a simple array (plural) of strings, we do things differently
    my $simpleArrayType = "";             # And if it is, get its type
    my $dictionaryKey   = $propertyName;  # Set the dictionary key as the property name, as it may be changed because of conflicts
    my $pathName        = $propertyName;  # Save the name of the property as it is needed as the pathAppend in the recursive call, and it may be changed because of conflicts
    my $propertyNotes   = "";             # Doxygen comment that provides more infomation if necessary for a property 


    ##########################################################
    # Updates to the Capture server should not contain 'id', 
    # 'uuid', 'created', and 'lastUpdated'
    ##########################################################
    my $isReadOnly = getIsReadOnly($propertyName);

    ##########################################################
    # Before setting the default to/from dictionary methods, 
    # make sure the property name isn't an objc keyword
    ##########################################################
    if (getIsPropertyNameObjcKeyword($propertyName)) {
      $propertyName = $objectName . ucfirst($propertyName);
    }

    ######################################################
    # Finish initializing property defaults
    ######################################################
    my $toDictionary           =                                   # Default operation is to insert the NSObject 
          "self.$propertyName";                                    # into an NSMutableDictionary with no other modifications
    my $toUpDictionary         = "self.$propertyName";             # Default operation for toUpdateDictionary                                        
    my $toRplDictionary        = "self.$propertyName";             # Default operation for toReplaceDictionary 
#    my $toRplDictionaryYesArrs = "";
#    my $toRplDictionaryNoArrs  = "";
    my $frDictionary           =                                   # Default operation is to just pull the NSObject from 
          "[dictionary objectForKey:\@\"$dictionaryKey\"]";        # the dictionary and stick it into the property
    my $frUpDictionary         = 
          "[dictionary objectForKey:\@\"$dictionaryKey\"]";
    my $frRplDictionary        = 
          "[dictionary objectForKey:\@\"$dictionaryKey\"]";
    my $isEqualMethod          = "";

    if ($propertyDesc) {                                    # Use the property description for the Doxygen comment
      $propertyNotes .= "/**< " . ucfirst(trim($propertyDesc));  # or create a default one if there is no description
    } else {
      $propertyNotes .= "/**< The object's \\e " . $propertyName . " property";
    }

    
    ##################################################################################################################
    # Determine the property's ObjC type.  Also determine how the property should be serialized/deserialized to/from
    # and NSDictionary (e.g., do we store the property in an NSMutableDictionary as is, or do we need to do something 
    # first so that it can stored in the dictionary) and add any notes to the property's Doxygen comment
    ##################################################################################################################

    ######## STRING ########
    if ($propertyType eq "string") {
    
      $objectiveType   = "NSString *";
      $isEqualMethod   = "isEqualToString:";

    ######## BOOLEAN ########
    } elsif ($propertyType eq "boolean") {

      $objectiveType   = "JRBoolean *";
      
      $toDictionary    = $toUpDictionary = $toRplDictionary = "[NSNumber numberWithBool:[self." . $propertyName . " boolValue]]";
      $frDictionary    = $frUpDictionary = $frRplDictionary = "[NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] boolValue]]";

      $isEqualMethod   = "isEqualToNumber:";
      
      $propertyNotes  .= " \@note This is a property of type \\ref types \"boolean\", which is a typedef of \\e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>[NSNull null]</code>";
      $isAlsoPrimitive = "b";
      
      push (@booleanProperties, $propertyName);
      
    ######## INTEGER ########
    } elsif ($propertyType eq "integer") {

      $objectiveType   = "JRInteger *";

      $toDictionary    = $toUpDictionary = $toRplDictionary = "[NSNumber numberWithInteger:[self." . $propertyName . " integerValue]]";
      $frDictionary    = $frUpDictionary = $frRplDictionary = "[NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] integerValue]]";

      $isEqualMethod   = "isEqualToNumber:";

      $propertyNotes  .= " \@note This is a property of type \\ref types \"integer\", which is a typedef of \\e NSNumber. The accepted values can only be <code>[NSNumber numberWithInteger:<em>myInteger</em>]</code>, <code>[NSNumber numberWithInt:<em>myInt</em>]</code>, or <code>[NSNull null]</code>";    
      $isAlsoPrimitive = "i";
  
      push (@integerProperties, $propertyName);

    ######## DECIMAL/NUMBER ########
    } elsif ($propertyType eq "decimal") {

      $objectiveType  = "NSNumber *";
      $isEqualMethod  = "isEqualToNumber:";
 
    ######## DATE ########
    } elsif ($propertyType eq "date") {

      $objectiveType  = "JRDate *";
      
      $toDictionary   = $toUpDictionary = $toRplDictionary = "[self." . $propertyName . " stringFromISO8601Date]";
      $frDictionary   = $frUpDictionary = $frRplDictionary = "[JRDate dateFromISO8601DateString:[dictionary objectForKey:\@\"" . $dictionaryKey . "\"]]";

      $isEqualMethod  = "isEqualToDate:";

      $propertyNotes .= " \@note This is a property of type \\ref types \"date\", which is a typedef of \\e NSDate. The accepted format should be an ISO8601 date string (e.g., <code>yyyy-MM-dd</code>)";      

    ######## DATETIME ########
    } elsif ($propertyType eq "dateTime") {

      $objectiveType  = "JRDateTime *";
      
      $toDictionary   = $toUpDictionary = $toRplDictionary = "[self." . $propertyName . " stringFromISO8601DateTime]";
      $frDictionary   = $frUpDictionary = $frRplDictionary = "[JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:\@\"" . $dictionaryKey . "\"]]";

      $isEqualMethod  = "isEqualToDate:";

      $propertyNotes .= " \@note This is a property of type \\ref types \"dateTime\", which is a typedef of \\e NSDate. The accepted format should be an ISO8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>)";

    ######## IPADDRESS ########
    } elsif ($propertyType eq "ipAddress") {
    ####################################
    # 'ipAddress' is just a string
    ####################################
      
      $objectiveType  = "JRIpAddress *";
      $isEqualMethod  = "isEqualToString:";
      $propertyNotes .= " \@note This is a property of type \\ref types \"ipAddress\", which is a typedef of \\e NSString.";      

    ######## PASSWORD ########
    } elsif ($propertyType =~ m/^password/) { 
    ####################################################################################################################
    #'password' types all start with the string 'password' (e.g., "password-crypt-sha256") Passwords are typically
    # string representations of a json object, and since we don't know the type of object it could be (e.g., array, 
    # string, etc.), we store it as an NSObject.
    ####################################################################################################################
      
      $objectiveType  = "JRPassword *";  
      $isEqualMethod  = "isEqual:";        
      $propertyNotes .= " \@note This is a property of type \\ref types \"password\", which can be either an \\e NSString or \\e NSDictionary, and is therefore is a typedef of \\e NSObject";      

    ######## JSON ########
    } elsif ($propertyType eq "json") {
    ####################################################################################################################
    # Properties of type 'json' are typically string representations of a basic json object or primitive type. Since we
    # don't know what type of object the property could be (e.g., array, string, etc.), we store it as an NSObject
    ####################################################################################################################
     
      $objectiveType  = "JRJsonObject *";  
      $isEqualMethod  = "isEqual:";        
      $propertyNotes .= " \@note This is a property of type \\ref types \"json\", which can be an \\e NSDictionary, \\e NSArray, \\e NSString, etc., and is therefore is a typedef of \\e NSObject";

    ######## UUID ########
    } elsif ($propertyType eq "uuid") {
    ####################################
    # 'uuid' is just a string
    ####################################
      
      $objectiveType  = "JRUuid *";
      $isEqualMethod  = "isEqualToString:";        
      $propertyNotes .= " \@note This is a property of type \\ref types \"uuid\", which is a typedef of \\e NSString";      
      
    ######## ID ########
    } elsif ($propertyType eq "id") {
    ###################################################################################################
    # If the property is type 'id' and has the name 'id', change the property name to compile in ObjC
    ###################################################################################################

      $objectiveType  = "JRObjectId *";
     
      $toDictionary   = $toUpDictionary = $toRplDictionary = "[NSNumber numberWithInteger:[self." . $propertyName . " integerValue]]";
      $frDictionary   = $frUpDictionary = $frRplDictionary = "[NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] integerValue]]";

      $isEqualMethod  = "isEqualToNumber:";        

      $propertyNotes .= " \@note The \\e id of the object should not be set. // TODO: etc."

    ######## PLURAL (ARRAY) ########
    } elsif ($propertyType eq "plural") {
    ####################################################################################################################
    # If the property is a 'plural' (i.e., a list of strings or sub-objects), first decide if it's a list of strings or
    # sub-objects by checking the property's 'attr_defs'. If it's a list of sub-objects, recurse on the plural's 
    # 'attr_defs', creating the sub-object.  Also, add an NSArray category to the current object's .m file, so that the
    # NSArray of sub-objects can properly turn themselves into an NSArray of NSDictionaries
    ####################################################################################################################

      $isArray = 1;
      
      my $propertyAttrDefsRef = $propertyHash{"attr_defs"};
      
      if (getIsAnArrayOfStrings($propertyAttrDefsRef)) {
        $isSimpleArray = 1;
        
        $objectiveType = "JRStringArray *";      
        
        $extraImportsSection .= "#import \"JRStringPluralElement.h\"\n";
        
        $simpleArrayType = getSimplePluralType($propertyAttrDefsRef);
        
        $toDictionary    = "[self." . $propertyName . " arrayOfStringPluralDictionariesFromStringPluralElements]";
        $toRplDictionary = "[self." . $propertyName . " arrayOfStringsFromStringPluralElements]";
        $frDictionary    = "[(NSArray*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:\@\"" . $simpleArrayType . "\" 
                                                                andExtendedPath:[NSString stringWithFormat:\@\"\%\@/" . $propertyName . "\", " . $objectName . ".captureObjectPath]]";
        $frRplDictionary = "[(NSArray*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"]
                arrayOfStringPluralElementsFromStringPluralDictionariesWithType:\@\"" . $simpleArrayType . "\" 
                                                                andExtendedPath:[NSString stringWithFormat:\@\"\%\@/" . $propertyName . "\", self.captureObjectPath]]";

        $isEqualMethod  = "isEqualToOtherStringPluralArray:";        

        $replaceArrayIntfSection .= createArrayReplaceMethodDeclaration($propertyName);
        $replaceArrayImplSection .= createArrayReplaceMethodImplementation($propertyName, $simpleArrayType);
        
        $propertyNotes .= " \@note This is an array of \\c JRStringPluralElements with type \\c " . $simpleArrayType . " TODO: Add note about how setting the array requires a replace on capture and how you can set it with an array of stringPluralElements or just an array of strings";      
        
      } else {

        $objectiveType = "NSArray *";      
        
        if ($repeatNamesHash{$propertyName}) {
          $propertyName = $objectName . ucfirst($propertyName);
        }
        
        $extraImportsSection    .= "#import \"JR" . ucfirst($propertyName) . "Element.h\"\n";
        $arrayCategoriesSection .= createArrayCategoryForSubobject ($propertyName);
        $toDictionary    = "[self." . $propertyName . " arrayOf" . ucfirst($propertyName) . "DictionariesFrom" . ucfirst($propertyName) . "Elements]";
        $toRplDictionary = "[self." . $propertyName . " arrayOf" . ucfirst($propertyName) . "ReplaceDictionariesFrom" . ucfirst($propertyName) . "Elements]";
        $frDictionary    = "[(NSArray*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] arrayOf" . ucfirst($propertyName) . "ElementsFrom" . ucfirst($propertyName) . "DictionariesWithPath:" . $objectName . ".captureObjectPath]";
        $frRplDictionary = "[(NSArray*)[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] arrayOf" . ucfirst($propertyName) . "ElementsFrom" . ucfirst($propertyName) . "DictionariesWithPath:self.captureObjectPath]";

        $replaceArrayIntfSection .= createArrayReplaceMethodDeclaration($propertyName);
        $replaceArrayImplSection .= createArrayReplaceMethodImplementation($propertyName);

        $arrayCompareIntfSection .= getArrayComparisonDeclaration($propertyName);
        $arrayCompareImplSection .= getArrayComparisonImplementation($propertyName);        

        $isEqualMethod  = "isEqualToOther" . ucfirst($propertyName) . "Array:";        

        $propertyNotes .= " \@note This is an array of \\c JR" . ucfirst($propertyName) . "Element objects";
        
        ######## AND RECURSE!! ########
        recursiveParse ($propertyName, $propertyAttrDefsRef, $objectPath, $pathName, $IS_PLURAL_ELEMENT, $HAS_PLURAL_PARENT, $propertyDesc);
       
      }
      
    ######## OBJECT (DICTIONARY) ########
    } elsif ($propertyType eq "object") {
    ##################################################################################
    # If the property is an object itself, recurse on the sub-object's 'attr_defs'
    ##################################################################################

      $isObject = 1;
      
      my $propertyAttrDefsRef = $propertyHash{"attr_defs"};
            
      if ($repeatNamesHash{$propertyName}) {
        $propertyName = $objectName . ucfirst($propertyName);
      }
      
      $objectiveType          = "JR" . ucfirst($propertyName) . " *";
      $toDictionary           = "[self." . $propertyName . " toDictionary]";
      $toUpDictionary         = "[self." . $propertyName . " toUpdateDictionary]";
#      $toRplDictionaryYesArrs = "[self." . $propertyName . " toReplaceDictionaryIncludingArrays:YES]";
#      $toRplDictionaryNoArrs  = "[self." . $propertyName . " toReplaceDictionaryIncludingArrays:NO]";
      $frDictionary    = "[JR" . ucfirst($propertyName) . " " . $propertyName . "ObjectFromDictionary:[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] withPath:" . $objectName . ".captureObjectPath]";
      $frUpDictionary  = "[JR" . ucfirst($propertyName) . " " . $propertyName . "ObjectFromDictionary:[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] withPath:self.captureObjectPath]";
      $frRplDictionary = "[JR" . ucfirst($propertyName) . " " . $propertyName . "ObjectFromDictionary:[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] withPath:self.captureObjectPath]";

      $isEqualMethod   = "isEqualTo" . ucfirst($propertyName) . ":";        

      $extraImportsSection .= "#import \"JR" . ucfirst($propertyName) . ".h\"\n";

      ######## AND RECURSE!! ########
      recursiveParse ($propertyName, $propertyAttrDefsRef, $objectPath, $pathName, $NOT_PLURAL_ELEMENT, $hasPluralParent, $propertyDesc);

    ######## OTHER ########
    } else {
    #########################################################
    # Shouldn't happen, but just make it an object
    #########################################################

      $objectiveType = "NSObject *";

    }

    $propertyNotes .= " */";

    ######################################################################################
    # "APPENDED PROPERTY ADDITIONS": FILL IN METHODS BY APPENDING CODE FOR EACH PROPERTY
    ######################################################################################

    #############################################################################################
    # Now, to take the property, and append the appropriate code to all those functions in 
    # the object's .h/.m files.
    #############################################################################################

    if ($isRequired) {
    ######################################################
    # If the property *is* required...
    ######################################################

      if ($requiredProperties == 1) { 
      ######################################################################################################
      # If the property is the *first* required property, we usually precede it with 'With' in method names
      ######################################################################################################

        # e.g.:
        #   - (id)initWithFoo:(NSObject *)newFoo ...
        $constructorSection[1] .= "With" . ucfirst($propertyName) . ":(" . $objectiveType . ")new" . ucfirst($propertyName);

        # e.g.:
        #   if (!newFoo ...
        $constructorSection[4] .= "!new" . ucfirst($propertyName);

        # e.g.:
        #   + (id)exampleElementWithFoo:(NSObject *)foo ...
        $classConstructorSection[2] .= "With" . ucfirst($propertyName) . ":(" . $objectiveType . ")" . $propertyName;

        # e.g.:
        #   return [[[JRExampleElement alloc] initWithFoo:foo ...
        $classConstructorSection[7] .= "With" . ucfirst($propertyName) . ":" . $propertyName;
        
      } else {
      ##########################################################################################################
      # If the property is *not* the first required property, we usually  precede it with 'And' in method names
      ##########################################################################################################
        
        # e.g.:
        #   - (id)initWithFoo:(NSObject *)newFoo andBar:(NSObject *)newBar ...
        $constructorSection[1] .= " and" . ucfirst($propertyName) . ":(" . $objectiveType . ")new" . ucfirst($propertyName);

        # e.g.:
        #   if (!newFoo || !newBar ...
        $constructorSection[4] .= " || !new" . ucfirst($propertyName);

        # e.g.:
        #   + (id)objWithFoo:(NSObject *)foo andBar:(NSObject *)bar ...
        $classConstructorSection[2] .= " and" . ucfirst($propertyName) . ":(" . $objectiveType . ")" . $propertyName;

        # e.g.:
        #   return [[[JRObj alloc] initWithFoo:foo andBar:bar ...
        $classConstructorSection[7] .= " and" . ucfirst($propertyName) . ":" . $propertyName;

      }        
      ##########################################################################
      # For *all* required properties...
      ##########################################################################
      
      # e.g.:
      #   foo = [newFoo copy];
      #   [self.dirtyPropertySet addObject:@"foo"];
      $constructorSection[8] .= "        _" . $propertyName . " = [new" . ucfirst($propertyName) . " copy];\n";
      $constructorSection[8] .= "        [self.dirtyPropertySet addObject:\@\"" . $propertyName . "\"];\n";

      
    } else {
    ######################################################
    # If the property is *not* required...
    ######################################################  
      
#      # e.g.:
#      #   exampleElementCopy.baz = self.baz;
#      $copyConstructorSection[9] .= "    " . $objectName . "Copy." . $propertyName . " = self." . $propertyName . ";\n";

    }
    ##########################################################################
    # For *all* properties (mostly)...
    ##########################################################################

    # e.g.:
    #   exampleElementCopy.baz = self.baz;
    $copyConstructorSection[4]  .= "    " . $objectName . "Copy." . $propertyName . " = self." . $propertyName . ";\n";

    # e.g.:
    #   exampleElement.baz = 
    #       [dictionary objectForKey:@"baz"] != [NSNull null] ? 
    #       [dictionary objectForKey:@"baz"] : nil;
    $objFromDictSection[17]     .= "\n    " . $objectName . "." . $propertyName . " =\n";
    $objFromDictSection[17]     .= "        [dictionary objectForKey:\@\"" . $dictionaryKey . "\"] != [NSNull null] ? \n";
    $objFromDictSection[17]     .= "        " . $frDictionary . " : nil;\n";
    
    # e.g.:
    #   [dict setObject:(self.baz ? self.baz : [NSNull null]) 
    #            forKey:@"baz"];
    $dictFromObjSection[3]      .= "    [dict setObject:(self." . $propertyName . " ? " . $toDictionary . " : [NSNull null])\n";
    $dictFromObjSection[3]      .= "             forKey:\@\"" . $dictionaryKey . "\"];\n";
    
    # e.g.:
    #   [dict setObject:@"JRFoo" forKey:@"foo"];
    $objectPropertiesSection[3] .= "    [dict setObject:\@\"" . stripPointer($objectiveType) . "\" forKey:\@\"" . $propertyName . "\"];\n";
    
    ### All pretty straightforward stuff here... ###
    
    $destructorSection[2] .= "    [_$propertyName release];\n";
    $privateIvarsSection  .= "    " . $objectiveType . "_" . $propertyName . ";\n";
    $synthesizeSection    .= "\@dynamic $propertyName;\n";
  
    if ($isObject) {
      $propertiesSection    .= "\@property (nonatomic, retain) $objectiveType$propertyName; $propertyNotes \n";
    } else {
      $propertiesSection    .= "\@property (nonatomic, copy)   $objectiveType$propertyName; $propertyNotes \n";
    }
  
    if ($isSimpleArray) { 
      $getterSettersSection .= createGetterSetterForSimpleArray ($propertyName, $simpleArrayType);
    } else {
      $getterSettersSection .= createGetterSetterForProperty ($propertyName, $objectiveType, $isAlsoPrimitive, $isArray, $isObject); 
    }

    if ($isObject) { 
    ####################################################################################################################
    # If the NSDictionary has the value [NSNull null] for our property object, set the property to nil (though, I 
    # think this case may never happen as Capture objects are never null). If the dictionary contains a value for
    # our property object, and our property is not nil, call the 'updateFromDictionary'/'replaceFromDictionary' method
    # on our property to avoid invalidating the pointer. If our property is nil, calling this method will do nothing, 
    # so we have to construct a new object from the dictionary.
    ####################################################################################################################

      # e.g.:
      #   if ([dictionary objectForKey:@"foo"] == [NSNull null])
      #       self.foo = nil;
      #   else if ([dictionary objectForKey:@"foo"] && !self.foo)
      #       self.foo = [JRFoo fooObjectFromDictionary:[dictionary objectForKey:@"foo"] withPath:self.captureObjectPath];
      #   else if ([dictionary objectForKey:@"foo"])
      #       [self.foo updateFromDictionary:[dictionary objectForKey:@"foo"] withPath:self.captureObjectPath];
      $updateFromDictSection[9]   .= "\n    if ([dictionary objectForKey:\@\"" . $dictionaryKey . "\"] == [NSNull null])";
      $updateFromDictSection[9]   .= "\n        self." . $propertyName . " = nil;";
      $updateFromDictSection[9]   .= "\n    else if ([dictionary objectForKey:\@\"" . $dictionaryKey . "\"] && !self." . $propertyName . ")";
      $updateFromDictSection[9]   .= "\n        self." . $propertyName . " = " . $frUpDictionary . ";";
      $updateFromDictSection[9]   .= "\n    else if ([dictionary objectForKey:\@\"" . $dictionaryKey . "\"])";
      $updateFromDictSection[9]   .= "\n        [self." . $propertyName . " updateFromDictionary:[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] withPath:self.captureObjectPath];\n";

      # e.g.:
      #   if (![dictionary objectForKey:@"foo"] || [dictionary objectForKey:@"foo"] == [NSNull null])
      #       self.foo = nil;
      #   else if (!self.foo)
      #       self.foo = [JRFoo fooObjectFromDictionary:[dictionary objectForKey:@"foo"] withPath:self.captureObjectPath];
      #   else
      #       [self.foo replaceFromDictionary:[dictionary objectForKey:@"foo"] withPath:self.captureObjectPath];
      $replaceFromDictSection[9]  .= "\n    if (![dictionary objectForKey:\@\"" . $dictionaryKey . "\"] || [dictionary objectForKey:\@\"" . $dictionaryKey . "\"] == [NSNull null])";
      $replaceFromDictSection[9]  .= "\n        self." . $propertyName . " = nil;";
      $replaceFromDictSection[9]  .= "\n    else if (!self." . $propertyName . ")";
      $replaceFromDictSection[9]  .= "\n        self." . $propertyName . " = " . $frRplDictionary . ";";
      $replaceFromDictSection[9]  .= "\n    else";
      $replaceFromDictSection[9]  .= "\n        [self." . $propertyName . " replaceFromDictionary:[dictionary objectForKey:\@\"" . $dictionaryKey . "\"] withPath:self.captureObjectPath];\n";

    } else {
  
      if (!$isArray) {
        ####################################################################################################################
        # Arrays don't get updated remotely, though their elements can be updated if their paths are valid. Likewise,
        # arrays don't get updated locally (from the NSDictionary argument of the method), as it would be too difficult to 
        # figure out which Objective-C element in the object's existing array corresponds with which NSDictionary element 
        # in the array in the NSDictionary argument. Don't want to create a new array, so it's just left out of this method.
        ####################################################################################################################

        # e.g.:        
        #   if ([dictionary objectForKey:@"bar"])
        #       self.name = [dictionary objectForKey:@"bar"] != [NSNull null] ? 
        #           [dictionary objectForKey:@"bar"] : nil;
        $updateFromDictSection[9]   .= "\n    if ([dictionary objectForKey:\@\"" . $dictionaryKey . "\"])";
        $updateFromDictSection[9]   .= "\n        self." . $propertyName . " = [dictionary objectForKey:\@\"" . $dictionaryKey . "\"] != [NSNull null] ? \n";
        $updateFromDictSection[9]   .= "            " . $frUpDictionary . " : nil;\n";          
      
      }
      ############################################
      # Everything but objects (yes, arrays too)
      ############################################
  
      # e.g.:
      #   self.baz =
      #       [dictionary objectForKey:@"baz"] != [NSNull null] ? 
      #       [dictionary objectForKey:@"baz"] : nil;
      $replaceFromDictSection[9]  .= "\n    self." . $propertyName . " =\n";
      $replaceFromDictSection[9]  .= "        [dictionary objectForKey:\@\"" . $dictionaryKey . "\"] != [NSNull null] ? \n";
      $replaceFromDictSection[9]  .= "        " . $frRplDictionary . " : nil;\n";
    
    }

    if (!$isReadOnly) {
    ##############################################################################################
    # Updates to the Capture server should not contain 'id', 'uuid', 'created', and 'lastUpdated'
    ##############################################################################################
 
      if ($isObject) {
      ##################################################################################################################
      # Objects on Capture can't be null, so if a developer sets an object property to null, instead of sending null to
      # Capture, we use the object's default (minimal) class constructor to create an object with nulled-out fields and
      # send that to Capture instead. If the dirtyPropertySet contains the object, we assume it's new, and send all of 
      # it's properties accept for it's arrays
      ##################################################################################################################
      
        # e.g.:      
        #   if ([self.dirtyPropertySet containsObject:@"foo"])
        #       [dict setObject:(self.foo ?
        #                             [self.foo toReplaceDictionaryIncludingArrays:NO] :
        #                             [[JRFoo foo] toUpdateDictionary]) /* Use the default constructor to create an empty object */
        #                forKey:@"foo"];        
        #   else if ([self.foo needsUpdate])
        #       [dict setObject:[self.foo toUpdateDictionary]
        #                forKey:@"foo"];        
        $toUpdateDictSection[3]  .= "\n    if ([self.dirtyPropertySet containsObject:\@\"" . $propertyName . "\"])\n";
        $toUpdateDictSection[3]  .= "        [dict setObject:(self." . $propertyName . " ?\n" . 
                                    "                              [self." . $propertyName . " toReplaceDictionaryIncludingArrays:NO] :\n" .
                                    "                              [[JR" . ucfirst($propertyName) . " " . $propertyName . "] toReplaceDictionaryIncludingArrays:NO]) /* Use the default constructor to create an empty object */\n" . 
                                    "                 forKey:\@\"" . $dictionaryKey . "\"];\n" .
                                    "    else if ([self." . $propertyName . " needsUpdate])\n" . 
                                    "        [dict setObject:[self." . $propertyName . " toUpdateDictionary]\n" . 
                                    "                 forKey:\@\"" . $dictionaryKey . "\"];\n";        

        # e.g.:      
        #   [dict setObject:(self.foo ?
        #                         [self.foo toReplaceDictionaryIncludingArrays:YES] :
        #                         [[JRFoo foo] toReplaceDictionaryIncludingArrays:YES]) /* Use the default constructor to create an empty object */
        #            forKey:@"foo"];              
        $toReplaceDictSection[3] .= "\n    [dict setObject:(self." . $propertyName . " ?\n" . 
                                    "                          [self." . $propertyName . " toReplaceDictionaryIncludingArrays:YES] :\n" .
                                    "                          [[JR" . ucfirst($propertyName) . " " . $propertyName . "] toUpdateDictionary]) /* Use the default constructor to create an empty object */\n" . 
                                    "             forKey:\@\"" . $dictionaryKey . "\"];\n";
    
        # e.g.:      
        #   if ([self.foo needsUpdate])
        #       return YES;
        $needsUpdateSection[3]   .= "    if([self." . $propertyName . " needsUpdate])\n        return YES;\n\n";

        ####################################################################################################
        # For objects, they are considered equal in the following cases:
        #   a. They are both null
        #   b. One is null and the other is empty
        #   c. Their properties are the same
        # This is because Capture returns empty subobjects, as opposed to 'null' subobjects, causing those 
        # subobjects to get initialized locally after a replace. On the other hand, locally a subobject can
        # be set to 'null'.  As our comparison is purposely loose, we can assume that objects that differ 
        # in this way (an empty subobject versus a null subobject) are still the same
        ####################################################################################################
        
        # e.g.:      
        #   if (!self.bar && !otherExampleObject.bar) /* Keep going... */;
        #   else if (!self.bar && [otherExampleObject.bar isEqualToBar:[JRBar bar]]) /* Keep going... */;
        #   else if (!otherExampleObject.bar && [self.bar isEqualToBar:[JRBar bar]]) /* Keep going... */;
        #   else if (![self.bar isEqualToOtherBarArray:otherExampleObject.bar]) return NO;
        $isEqualObjectSection[3] .=
              "    if (!self." . $propertyName . " && !other" . ucfirst($objectName) . "." . $propertyName . ") /* Keep going... */;\n" . 
              "    else if (!self." . $propertyName . " && [other" . ucfirst($objectName) . "." . $propertyName . " " . $isEqualMethod . "[JR" . ucfirst($propertyName) . " " . $propertyName . "]]) /* Keep going... */;\n" . 
              "    else if (!other" . ucfirst($objectName) . "." . $propertyName . " && [self." . $propertyName . " " . $isEqualMethod . "[JR" . ucfirst($propertyName) . " " . $propertyName . "]]) /* Keep going... */;\n" . 
              "    else if (![self." . $propertyName . " " . $isEqualMethod . "other" . ucfirst($objectName) . "." . $propertyName . "]) return NO;\n\n";


      } elsif ($isArray) {
      ####################################################################################################################
      # Arrays don't get updated, though their elements can be updated if their paths are valid. If an array has changed, 
      # that is, the pointer to the NSArray is different, we assume it's a whole new array. Changed arrays need to be 
      # replaced on Capture before their elements or sub-elements can be updated. In any case, leave them out here.
      ####################################################################################################################

        # e.g.:
        #   if (includingArrays)      
        #       [dict setObject:(self.bar ? [self.bar arrayOfBarReplaceDictionariesFromBarObjects] : [NSArray array]) forKey:@"bar"];
        $toReplaceDictSection[3] .= "\n    if (includingArrays)\n" . 
                                    "        [dict setObject:(self." . $propertyName . " ?\n" .
                                    "                          " . $toRplDictionary . " :\n" . 
                                    "                          [NSArray array])\n" . 
                                    "                 forKey:\@\"" . $dictionaryKey . "\"];\n";
              
        ####################################################################################################
        # For arrays, they are considered equal in the following cases:
        #   a. They are both null
        #   b. One is null and the other is empty
        #   c. Their elements are the same
        # This is because Capture returns empty arrays, as opposed to 'null' arrays, causing the object to
        # get initialized with an empty array after a replace. On the other hand, locally an object can have
        # 'null' for an array.  As our comparison is purposely loose, we can assume that objects that differ
        # in this way (an empty array versus a null array) are still the same
        ####################################################################################################
        
        # e.g.:      
        #   if (!self.bar && !otherExampleObject.bar) /* Keep going... */;
        #   else if (!self.bar && [otherExampleObject.bar count]) return NO;
        #   else if (!otherExampleObject.bar && [self.bar count]) return NO;
        #   else if (![self.bar isEqualToOtherBarArray:otherExampleObject.bar]) return NO;        
        $isEqualObjectSection[3] .= 
              "    if (!self." . $propertyName . " && !other" . ucfirst($objectName) . "." . $propertyName . ") /* Keep going... */;\n" .
              "    else if (!self." . $propertyName . " && ![other" . ucfirst($objectName) . "." . $propertyName . " count]) /* Keep going... */;\n" .
              "    else if (!other" . ucfirst($objectName) . "." . $propertyName . " && ![self." . $propertyName . " count]) /* Keep going... */;\n" .
              "    else if (![self." . $propertyName . " " . $isEqualMethod . "other" . ucfirst($objectName) . "." . $propertyName . "]) return NO;\n\n";
    
      } else { ### Not an object or array ###

        # e.g.:
        #   if ([self.dirtyPropertySet containsObject:@"baz"])
        #       [dict setObject:self.baz forKey:@"baz"];
        $toUpdateDictSection[3]  .= "\n    if ([self.dirtyPropertySet containsObject:\@\"" . $propertyName . "\"])\n";
        $toUpdateDictSection[3]  .= "        [dict setObject:(self." . $propertyName . " ? " . $toUpDictionary . " : [NSNull null]) forKey:\@\"" . $dictionaryKey . "\"];\n";

        # e.g.:      
        #   [dict setObject:(self.baz ? self.baz : [NSNull null]) forKey:@"baz"];
        $toReplaceDictSection[3] .= "    [dict setObject:(self." . $propertyName . " ? " . $toRplDictionary . " : [NSNull null]) forKey:\@\"" . $dictionaryKey . "\"];\n";

        # e.g.:      
        #   if ((self.foo == nil) ^ (otherExampleObject.foo == nil)) // xor
        #       return NO;
        #
        #   if (![self.foo isEqualToString:otherExampleObject.foo])
        #       return NO;
        $isEqualObjectSection[3] .= 
              "    if (!self." . $propertyName . " && !other" . ucfirst($objectName) . "." . $propertyName . ") /* Keep going... */;\n" .
              "    else if ((self." . $propertyName . " == nil) ^ (other" . ucfirst($objectName) . "." . $propertyName . " == nil)) return NO; // xor\n" .
              "    else if (![self." . $propertyName . " " . $isEqualMethod . "other" . ucfirst($objectName) . "." . $propertyName . "]) return NO;\n\n";

      }      
            
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
  
  if ($arrayCompareIntfSection ne "") {
    $hFile .= "\@interface NSArray (" . ucfirst($objectName) . "_ArrayComparison)\n$arrayCompareIntfSection\@end\n\n";
  }
     
  for (my $i = 0; $i < @doxygenClassDescSection; $i++) { $hFile .= $doxygenClassDescSection[$i]; }
  
  ##########################################################################
  # Declare the interface, add the properties, and add the function
  # declarations
  ##########################################################################
  $hFile .= "\@interface $className : JRCaptureObject\n";# <NSCopying, JRJsonifying>\n";
  $hFile .= $propertiesSection;
    
  if ($requiredProperties) {
    $minConstructorDocSection[5] = $minClassConstructorDocSection[5] = $objFromDictDocSection[5] = 
        " * \n * \@note\n * Method creates a $className object without the required properties TODO: MAKE A LIST!\n * These properties are required when updating the object on Capture.\n"; 
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
  for (my $i = 0; $i < @isEqualObjectDocSection; $i++) { $hFile .= $isEqualObjectDocSection[$i]; }
  $hFile .= "$isEqualObjectSection[0]$isEqualObjectSection[1];\n";
  for (my $i = 0; $i < @objectPropertiesDocSection; $i++) { $hFile .= $objectPropertiesDocSection[$i]; }
  $hFile .= "$objectPropertiesSection[0];\n";
  $hFile .= "/*\@}*/\n\n";


  $hFile .= "/**\n * \@name Manage Remotely \n **/\n/*\@{*/";
  $hFile .= "$replaceArrayIntfSection\n";
  for (my $i = 0; $i < @needsUpdateDocSection; $i++) { $hFile .= $needsUpdateDocSection[$i]; }
  $hFile .= "$needsUpdateSection[0];\n";
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
  
  if ($arrayCompareImplSection ne "") {
    $mFile .= "\@implementation NSArray (" . ucfirst($objectName) . "_ArrayComparison)\n$arrayCompareImplSection\@end\n\n";
  }
   
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
  
  for (my $i = 0; $i < @toReplaceDictSection; $i++) {
    $mFile .= $toReplaceDictSection[$i];
  }

  $mFile .= $replaceArrayImplSection;

  for (my $i = 0; $i < @needsUpdateSection; $i++) {
    $mFile .= $needsUpdateSection[$i];
  }

  for (my $i = 0; $i < @isEqualObjectSection; $i++) {
    $mFile .= $isEqualObjectSection[$i];
  }
    
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
recursiveParse ("captureUser", $attrDefsArrayRef, "", "", $NOT_PLURAL_ELEMENT, $NO_PLURAL_PARENT, "");

##########################################################################
# Finally, print our .h/.m files
##########################################################################
my @hFileNames = keys (%hFiles);
my @mFileNames = keys (%mFiles);

my $docsDir  = "Docs";
my $copyDir  = "iOSFiles";
my $filesDir = "JRCapture";

if (!$outputDir) {
  $outputDir  = "iOS";
}

my $canMakeDocs = 1;

unless (-d $outputDir) {
    mkdir "$outputDir" or die "[ERROR] Unable to make the directory '$outputDir'\n\n";
}

unless (-d "$outputDir/$filesDir") {
    mkdir "$outputDir/$filesDir" or die "[ERROR] Unable to make the directory '$outputDir/$filesDir'\n\n";
}

unless (-d "$outputDir/$docsDir") {
    mkdir "$outputDir/$docsDir" or $canMakeDocs = 0;
}

my $copyResult = `cp ./$copyDir/JR* $outputDir/$filesDir 2>&1`;

if ($copyResult) {
  die "[ERROR] Unable to copy necessary files to the '$outputDir': $copyResult\n\n";
}

foreach my $fileName (@hFileNames) {
  open (FILE, ">$outputDir/$filesDir/$fileName") or die "[ERROR] Unable to open '$outputDir/$filesDir/$fileName' for writing\n\n";
  print "Writing $fileName... ";
  print FILE $hFiles{$fileName};
  print "Finished $fileName.\n";
}

foreach my $fileName (@mFileNames) {
  open (FILE, ">$outputDir/$filesDir/$fileName") or die "[ERROR] Unable to open '$outputDir/$filesDir/$fileName' for writing\n\n";
  print "Writing $fileName... ";
  print FILE $mFiles{$fileName};
  print "Finished $fileName.\n";
}

# TODO: Make sure the correct input/output directories are known by doxygen when passing in a different out dir
# TODO: Better success/fail reporting if doxygen works or not
my $doxygenResult = `doxygen ./Doxygen/Doxyfile 2>&1`;
print $doxygenResult;

print "\n[SUCCESS] Capture schema successfully parsed.\n\n"
