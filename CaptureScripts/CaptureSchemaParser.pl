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
  
      $objectiveType = "JR" . ucfirst($propertyName) . " *";
      $toDictionary  = "[$propertyName dictionaryFromObject]";
      $frDictionary  = "[JR" . ucfirst($propertyName) . " " . $propertyName . "ObjectFromDictionary:(NSDictionary*)[dictionary objectForKey:\@\"" . $propertyName . "\"]]";
      $extraImportsSection .= "#import \"JR" . ucfirst($propertyName) . ".h\"\n";

      my $propertyAttrDefsRef = $propertyHash{"attr_defs"};
      recursiveParse ($propertyName, $propertyAttrDefsRef);

    } else {
    ##################
    # ERROR
    ##################
      print "PROPERTY TYPE NOT BEING CAUGHT: " . $propertyName . "\n";
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
  # Add the imports ...
  ##########################################################################
  my $hFile = "\n#import <Foundation/Foundation.h>\n#import \"JRCapture.h\"\n";
  
  ##########################################################################
  # Add any extra imports ...
  ##########################################################################
  $hFile .= $extraImportsSection . "\n";
  
  ##########################################################################
  # Declare the interface, add the properties, and add the function
  # declarations
  ##########################################################################
  $hFile .= "\@interface $className : NSObject <NSCopying, JRJsonifying>\n";
  $hFile .= $propertiesSection;
  $hFile .= "$constructorSection[0]$constructorSection[1];\n";
  $hFile .= "$classConstructorSection[0]$classConstructorSection[1]$classConstructorSection[2];\n";
  $hFile .= "$makeObjectSection[0]$makeObjectSection[1]$makeObjectSection[2];\n";
  $hFile .= "\@end\n";

  ##########################################################################
  # Import the header
  ##########################################################################
  my $mFile = "\n#import \"$className.h\"\n\n";

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
 
#my $json_text = getCaptureSchema (0, ""); #"[{\"case-sensitive\":false,\"name\":\"aboutMe\",\"length\":null,\"type\":\"string\"},{\"name\":\"birthday\",\"type\":\"date\"},{\"case-sensitive\":false,\"name\":\"currentLocation\",\"length\":1000,\"type\":\"string\"},{\"name\":\"display\",\"type\":\"json\"},{\"case-sensitive\":false,\"name\":\"displayName\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"email\",\"length\":256,\"type\":\"string\",\"constraints\":[\"unique\"]},{\"name\":\"emailVerified\",\"type\":\"dateTime\"},{\"case-sensitive\":false,\"name\":\"familyName\",\"length\":1000,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"case-sensitive\":false,\"name\":\"gender\",\"length\":100,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"givenName\",\"length\":1000,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"name\":\"lastLogin\",\"type\":\"dateTime\"},{\"case-sensitive\":false,\"name\":\"middleName\",\"length\":1000,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"name\":\"password\",\"type\":\"password-crypt-sha256\"},{\"name\":\"photos\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":true,\"name\":\"type\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":true,\"name\":\"value\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"primaryAddress\",\"type\":\"object\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"address1\",\"length\":1000,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"case-sensitive\":false,\"name\":\"address2\",\"length\":1000,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"case-sensitive\":false,\"name\":\"city\",\"length\":1000,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"case-sensitive\":false,\"name\":\"company\",\"length\":1000,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"case-sensitive\":false,\"name\":\"mobile\",\"length\":100,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"case-sensitive\":false,\"name\":\"phone\",\"length\":100,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"case-sensitive\":false,\"name\":\"stateAbbreviation\",\"length\":100,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"case-sensitive\":false,\"name\":\"zip\",\"length\":100,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"case-sensitive\":false,\"name\":\"zipPlus4\",\"length\":100,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]}]},{\"name\":\"profiles\",\"type\":\"plural\",\"attr_defs\":[{\"name\":\"accessCredentials\",\"type\":\"json\"},{\"case-sensitive\":false,\"name\":\"domain\",\"length\":1000,\"type\":\"string\",\"constraints\":[\"required\"]},{\"name\":\"friends\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":true,\"name\":\"identifier\",\"length\":null,\"type\":\"string\",\"constraints\":[\"required\"]}]},{\"case-sensitive\":false,\"name\":\"identifier\",\"length\":1000,\"type\":\"string\",\"constraints\":[\"required\",\"unique\"]},{\"name\":\"profile\",\"type\":\"object\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"aboutMe\",\"length\":null,\"type\":\"string\"},{\"name\":\"accounts\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"domain\",\"length\":1000,\"type\":\"string\"},{\"name\":\"primary\",\"type\":\"boolean\"},{\"case-sensitive\":false,\"name\":\"userid\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":true,\"name\":\"username\",\"length\":1000,\"type\":\"string\"}]},{\"name\":\"addresses\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"country\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"extendedAddress\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"formatted\",\"length\":null,\"type\":\"string\"},{\"name\":\"latitude\",\"type\":\"decimal\"},{\"case-sensitive\":false,\"name\":\"locality\",\"length\":1000,\"type\":\"string\"},{\"name\":\"longitude\",\"type\":\"decimal\"},{\"case-sensitive\":false,\"name\":\"poBox\",\"length\":100,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"postalCode\",\"length\":100,\"type\":\"string\"},{\"name\":\"primary\",\"type\":\"boolean\"},{\"case-sensitive\":false,\"name\":\"region\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"streetAddress\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"type\",\"length\":1000,\"type\":\"string\"}]},{\"name\":\"anniversary\",\"type\":\"date\"},{\"case-sensitive\":false,\"name\":\"birthday\",\"length\":100,\"type\":\"string\"},{\"name\":\"bodyType\",\"type\":\"object\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"build\",\"length\":100,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"color\",\"length\":100,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"eyeColor\",\"length\":100,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"hairColor\",\"length\":100,\"type\":\"string\"},{\"name\":\"height\",\"type\":\"decimal\"}]},{\"name\":\"books\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"book\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"cars\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"car\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"children\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"value\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"currentLocation\",\"type\":\"object\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"country\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"extendedAddress\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"formatted\",\"length\":1000,\"type\":\"string\"},{\"name\":\"latitude\",\"type\":\"decimal\"},{\"case-sensitive\":false,\"name\":\"locality\",\"length\":1000,\"type\":\"string\"},{\"name\":\"longitude\",\"type\":\"decimal\"},{\"case-sensitive\":false,\"name\":\"poBox\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"postalCode\",\"length\":100,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"region\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"streetAddress\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"type\",\"length\":null,\"type\":\"string\"}]},{\"case-sensitive\":true,\"name\":\"displayName\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"drinker\",\"length\":null,\"type\":\"string\"},{\"name\":\"emails\",\"type\":\"plural\",\"attr_defs\":[{\"name\":\"primary\",\"type\":\"boolean\"},{\"case-sensitive\":false,\"name\":\"type\",\"length\":256,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"value\",\"length\":256,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"ethnicity\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"fashion\",\"length\":null,\"type\":\"string\"},{\"name\":\"food\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"food\",\"length\":null,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"gender\",\"length\":100,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"happiestWhen\",\"length\":null,\"type\":\"string\"},{\"name\":\"heroes\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"hero\",\"length\":null,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"humor\",\"length\":null,\"type\":\"string\"},{\"name\":\"ims\",\"type\":\"plural\",\"attr_defs\":[{\"name\":\"primary\",\"type\":\"boolean\"},{\"case-sensitive\":false,\"name\":\"type\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"value\",\"length\":null,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"interestedInMeeting\",\"length\":null,\"type\":\"string\"},{\"name\":\"interests\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"interest\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"jobInterests\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"jobInterest\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"languages\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"language\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"languagesSpoken\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"languageSpoken\",\"length\":null,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"livingArrangement\",\"length\":null,\"type\":\"string\"},{\"name\":\"lookingFor\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"value\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"movies\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"movie\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"music\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"music\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"name\",\"type\":\"object\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"familyName\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"formatted\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"givenName\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"honorificPrefix\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"honorificSuffix\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"middleName\",\"length\":1000,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"nickname\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"note\",\"length\":null,\"type\":\"string\"},{\"name\":\"organizations\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"department\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"description\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"endDate\",\"length\":null,\"type\":\"string\"},{\"name\":\"location\",\"type\":\"object\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"country\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"extendedAddress\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"formatted\",\"length\":null,\"type\":\"string\"},{\"name\":\"latitude\",\"type\":\"decimal\"},{\"case-sensitive\":false,\"name\":\"locality\",\"length\":1000,\"type\":\"string\"},{\"name\":\"longitude\",\"type\":\"decimal\"},{\"case-sensitive\":false,\"name\":\"poBox\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"postalCode\",\"length\":100,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"region\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"streetAddress\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"type\",\"length\":1000,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"name\",\"length\":1000,\"type\":\"string\"},{\"name\":\"primary\",\"type\":\"boolean\"},{\"case-sensitive\":false,\"name\":\"startDate\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"title\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"type\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"pets\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"value\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"phoneNumbers\",\"type\":\"plural\",\"attr_defs\":[{\"name\":\"primary\",\"type\":\"boolean\"},{\"case-sensitive\":false,\"name\":\"type\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"value\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"photos\",\"type\":\"plural\",\"attr_defs\":[{\"name\":\"primary\",\"type\":\"boolean\"},{\"case-sensitive\":false,\"name\":\"type\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"value\",\"length\":null,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"politicalViews\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":true,\"name\":\"preferredUsername\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"profileSong\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"profileUrl\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"profileVideo\",\"length\":1000,\"type\":\"string\"},{\"name\":\"published\",\"type\":\"dateTime\"},{\"name\":\"quotes\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"quote\",\"length\":null,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"relationshipStatus\",\"length\":1000,\"type\":\"string\"},{\"name\":\"relationships\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"relationship\",\"length\":1000,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"religion\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"romance\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"scaredOf\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"sexualOrientation\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"smoker\",\"length\":null,\"type\":\"string\"},{\"name\":\"sports\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"sport\",\"length\":null,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"status\",\"length\":1000,\"type\":\"string\"},{\"name\":\"tags\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"tag\",\"length\":1000,\"type\":\"string\"}]},{\"name\":\"turnOffs\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"turnOff\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"turnOns\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"turnOn\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"tvShows\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"tvShow\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"updated\",\"type\":\"dateTime\"},{\"name\":\"urls\",\"type\":\"plural\",\"attr_defs\":[{\"name\":\"primary\",\"type\":\"boolean\"},{\"case-sensitive\":false,\"name\":\"type\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"value\",\"length\":null,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"utcOffset\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"provider\",\"type\":\"json\"},{\"case-sensitive\":true,\"name\":\"remote_key\",\"length\":4096,\"type\":\"string\"}]},{\"name\":\"statuses\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"status\",\"length\":1000,\"type\":\"string\"},{\"name\":\"statusCreated\",\"type\":\"dateTime\"}]}]";

##########################################################################
# Decode our JSON schema
##########################################################################
my $perl_scalar = $json->decode( $schema ); #$json_text );

##########################################################################
# Then recursively parse it...
##########################################################################
recursiveParse ("captureUser", $perl_scalar);

##########################################################################
# Finally, print our .h/.m files
##########################################################################
my @hFileNames = keys (%hFiles);
my @mFileNames = keys (%mFiles);

foreach my $fileName (@hFileNames) {
  open (FILE, ">CaptureObjects/$fileName") or die "[ERROR] Unable to open Capture/$fileName for writing\n";
  print "Writing $fileName... ";
  print FILE $hFiles{$fileName};
  print "Finished $fileName.\n";
}

foreach my $fileName (@mFileNames) {
  open (FILE, ">CaptureObjects/$fileName") or die "[ERROR] Unable to open Capture/$fileName for writing\n";
  print "Writing $fileName... ";
  print FILE $mFiles{$fileName};
  print "Finished $fileName.\n";
}

print "\n[SUCCESS] Capture schema successfully parsed.\n\n"
