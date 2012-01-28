#!/usr/bin/perl
use strict;
use warnings;

use JSON; # imports encode_json, decode_json, to_json and from_json.

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
# FUNCTION PROTOTYPES
############################################


###################################################################
# INSTANCE CONSTRUCTOR (W REQUIRED PROPERTIES)
#
# Section only here when there are required properties     
#                     |
#                     V
# - (id)init<requiredProperties>
# {
#     if(!<requriredProperties) <-
#     {                         <- Section only here
#       [self release];         <- when there are 
#       return nil;             <- required properties
#     }                         <-          |
#                                           |
#     if ((self = [super init]))            |
#     {                                     |
#          <copy required properties> <-----+
#     }
#
#     return self;
# }
################################################################

my @constructorParts      = 
("- (id)init", "",
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

my @classConstructorParts = ("+ (id)", "", "", 
                             "\n{\n    return [[[", "", " alloc] init", "", "] autorelease];\n}\n\n"); 

my @copyConstructorParts  = ("- (id)copyWithZone:(NSZone*)zone\n{\n", 
                             "", " allocWithZone:zone] init", "", "];\n\n",
                             "", "\n    return ", "", ";\n}\n\n");

my @makeDictionaryParts   = ("- (NSDictionary*)dictionaryFromObject\n{\n    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];\n\n",
                            "", "", "\n    return dict;\n}\n\n");

my @destructorParts       = ("- (void)dealloc\n{\n", "", "\n    [super dealloc];\n}\n");

sub createArrayCategoryForSubobject { 
  my $propertyName = $_[0];
  
  my $arrayCategoryIntf = "\@interface NSArray (" . ucfirst($propertyName) . "ToDictionary)\n";
  my $arrayCategoryImpl = "\@implementation NSArray (" . ucfirst($propertyName) . "ToDictionary)\n";

  my $methodName = "- (NSArray*)arrayOf" . ucfirst($propertyName) . "DictionariesFrom" . ucfirst($propertyName) . "Objects";
  
  $arrayCategoryIntf .= "$methodName;\n\@end\n\n";
  $arrayCategoryImpl .= "$methodName\n{\n";
  
#  $arrayCategoryImpl .=  
#      "NSPredicate    *predicate =
#      [NSPredicate predicateWithFormat:\@\"cf_className = \%\@\", NSStringFromClass([JR" . ucfirst($propertyName) . "Object class])];";

  $arrayCategoryImpl .=        
       "    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];\n" . 
       "    for (NSObject *object in self)\n" . 
       "        if ([object isKindOfClass:[JR" . ucfirst($propertyName) . "Object class]])\n" . 
       "            [filteredDictionaryArray addObject:[(JR" . ucfirst($propertyName) . "Object*)object dictionaryFromObject]];\n\n" . 
       "    return filteredDictionaryArray;\n}\n\@end\n\n";

#  my $category = $arrayCategoryIntf . $arrayCategoryImpl;
  return "$arrayCategoryIntf$arrayCategoryImpl";
}

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
  #my $isPlural   = $_[2];


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
  my @constructorSection      = @constructorParts;
  my @classConstructorSection = @classConstructorParts;
  my @copyConstructorSection  = @copyConstructorParts;
  my @destructorSection       = @destructorParts;
  my @makeDictionarySection   = @makeDictionaryParts;

  
  ######################################################
  # Create the class name of an object
  # e.g., 'primaryAddress' becomes 'JRPrimaryObject'
  ######################################################
  my $className = "JR" . ucfirst($objectName) . "Object";
 
 
  ######################################################
  # Parts of the class constructor and copy constructor
  # references the object name and class name
  # e.g., 
  # JRUserObject *userObjectCopy =
	#			[[JRUserObject allocWithZone:zone] init];
  ######################################################
  $classConstructorSection[1] = $objectName . "Object";
  $classConstructorSection[4] = $className;
  
  $copyConstructorSection[1]  = "    " . $className . " *" . $objectName . "ObjectCopy =\n                [[" . $className;
  $copyConstructorSection[7]  = $objectName . "ObjectCopy";
  
  ######################################################
  # Keep track of how many properties are required
  ######################################################
  my $requiredProperties = 0;

  ######################################################
  # Properties list contains references (pointers) to
  # property hashes.  Loop through, dereference, and 
  # parse...
  ######################################################
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

    ################################################
    # Initialize property attributes to default 
    # values
    ################################################
    my $objectiveType = "";            # Property type in Objective-C (e.g., NSString*)
    my $dictionaryStr = $propertyName; # Default operation is to just stick the NSObject into an NSMutableDictionary
    my $isBooleanType = 0;             # If it's a boolean, we do things differently
    my $isArrayType   = 0;             # If it's an array (plural), we do things differently
    my $propertyNotes = "";            # Comment that provides more infomation if necessary (e.g., in the 
                                       # case of an array of objects versus and array of strings
    
    ################################################
    # Find out if it's a required property
    ################################################
    my $isRequired = getIsRequired (\%propertyHash); 
    if ($isRequired) {
      $requiredProperties++;
    }

    ##########################################################
    # Determine the property's ObjC type and what to do when 
    # creating a dictionary of the property's object
    # (i.e., how to we store each property in an 
    # NSMutableDictionary so that it can be turned into JSON
    ##########################################################
    if ($propertyType eq "string") {
      $objectiveType = "NSString *";

    } elsif ($propertyType eq "boolean") {
      $isBooleanType = 1;
      $objectiveType = "BOOL";
      $dictionaryStr = "[NSNumber numberWithBool:$propertyName]";

    } elsif ($propertyType eq "decimal") {
      $objectiveType = "NSNumber *";

    } elsif ($propertyType eq "date") {
      $objectiveType = "NSDate *";

    } elsif ($propertyType eq "dateTime") {
      $objectiveType = "NSDate *";

    } elsif ($propertyType eq "password-crypt-sha256") {
      $objectiveType = "NSString *";

    } elsif ($propertyType eq "json") { # What the hell is a 'json'?  A string?
      $objectiveType = "NSString *";

    } elsif ($propertyType eq "plural") {
      ##################################################################
      # If the property is a 'plural' (i.e., a list of strings or 
      # sub-objects), first decide if it's a list of strings or
      # sub-objects by checking the property's 'attr_defs'.
      # If it's a list of sub-objects, recurse on the plural's 
      #'attr_defs', creating the sub-object.  Also, add an NSArray
      # category to the current object's .m file, so that the NSArray
      # of sub-objects can properly turn themselves into an NSArray 
      # of NSDictionaries
      ##################################################################

      $objectiveType = "NSArray *";                               
      my $propertyAttrDefsRef = $propertyHash{"attr_defs"};
      
      if (isAnArrayOfStrings($propertyAttrDefsRef)) {
        $propertyNotes = "/* This is an array of strings */";      
        
      } else {
        $extraImportsSection .= "#import \"JR" . ucfirst($propertyName) . "Object.h\"\n";
        $arrayCategoriesSection .= createArrayCategoryForSubobject($propertyName);
        $dictionaryStr = "[$propertyName arrayOf" . ucfirst($propertyName) . "DictionariesFrom" . ucfirst($propertyName) . "Objects]";
        $propertyNotes = "/* This is an array of JR" . ucfirst($propertyName) . "Objects */";
        
        recursiveParse ($propertyName, $propertyAttrDefsRef);
        

      }
      

    } elsif ($propertyType eq "object") {
      ##################################################
      # If the property is an object itself, recurse on 
      # the sub-object's 'attr_defs'
      ##################################################
  
      $objectiveType = "JR" . ucfirst($propertyName) . "Object *";
      $dictionaryStr = "[$propertyName dictionaryFromObject]";
      $extraImportsSection .= "#import \"JR" . ucfirst($propertyName) . "Object.h\"\n";

      my $propertyAttrDefsRef = $propertyHash{"attr_defs"};
      recursiveParse ($propertyName, $propertyAttrDefsRef);

    } else {
      print "PROPERTY TYPE NOT BEING CAUGHT: " . $propertyName . "\n";
    }

    if ($isRequired) {
      if ($requiredProperties == 1) { # If it's the first required property
        $constructorSection[1] .= "With" . ucfirst($propertyName) . ":(" . $objectiveType . ")new" . ucfirst($propertyName);
        $constructorSection[4] .= "!new" . ucfirst($propertyName);
        
        $classConstructorSection[2] .= "With" . ucfirst($propertyName) . ":(" . $objectiveType . ")" . $propertyName;
        $classConstructorSection[6] .= "With" . ucfirst($propertyName) . ":" . $propertyName;

        $copyConstructorSection[3]  .= "With" . ucfirst($propertyName) . ":self.$propertyName";
        
      } else {
        $constructorSection[1] .= " and" . ucfirst($propertyName) . ":(" . $objectiveType . ")new" . ucfirst($propertyName);
        $constructorSection[4] .= " || !new" . ucfirst($propertyName);

        $classConstructorSection[2] .= " and" . ucfirst($propertyName) . ":(" . $objectiveType . ")" . $propertyName;
        $classConstructorSection[6] .= " and" . ucfirst($propertyName) . ":" . $propertyName;

        $copyConstructorSection[3]  .= " and" . ucfirst($propertyName) . ":self.$propertyName";
      }        
      
      $constructorSection[8] .= "        " . $propertyName . " = [new" . ucfirst($propertyName) . " copy];\n";
      $makeDictionarySection[1] .= "    [dict setObject:" . $dictionaryStr . " forKey:\@\"" . $propertyName . "\"];\n";
      
    } else {
      $makeDictionarySection[2] .= "\n    if (" . $propertyName . ")\n";
      $makeDictionarySection[2] .= "        [dict setObject:" . $dictionaryStr . " forKey:\@\"" . $propertyName . "\"];\n";
      
      $copyConstructorSection[5] .= "    " . $objectName . "ObjectCopy." . $propertyName . " = self." . $propertyName . ";\n";
    }
    
    if ($isBooleanType) {
      $propertiesSection    .= "\@property                   $objectiveType $propertyName;\n";
      $synthesizeSection    .= "\@synthesize $propertyName;\n";    
    } else {
      $destructorSection[1] .= "    [$propertyName release];\n";
      $propertiesSection    .= "\@property (nonatomic, copy) $objectiveType$propertyName; $propertyNotes \n";
      $synthesizeSection    .= "\@synthesize $propertyName;\n";
    }      
  }

  
  my $hFile = "\n#import <Foundation/Foundation.h>\n#import \"JRCapture.h\"\n";
  
  $hFile .= $extraImportsSection . "\n";
  $hFile .= "\@interface $className : NSObject <NSCopying, JRJsonifying>\n";
  $hFile .= $propertiesSection;
  $hFile .= "$constructorSection[0]$constructorSection[1];\n";
  $hFile .= "$classConstructorSection[0]$classConstructorSection[1]$classConstructorSection[2];\n";
  $hFile .= "\@end\n";

  my $mFile = "\n#import \"$className.h\"\n\n";
  
  $mFile .= $arrayCategoriesSection;
  $mFile .= "\@implementation $className\n";
  $mFile .= $synthesizeSection . "\n";
  
  for (my $i = 0; $i < @constructorSection; $i++) {
    if ($i == 1 || $i == 3 || $i == 4 || $i == 5 || $i == 6 || $i == 8) {
      if ($requiredProperties) {     
        $mFile .= $constructorSection[$i];
      }
    } else {
      $mFile .= $constructorSection[$i];
    }
  }

  for (my $i = 0; $i < @classConstructorSection; $i++) {
    $mFile .= $classConstructorSection[$i];
  }

  for (my $i = 0; $i < @copyConstructorSection; $i++) {
      $mFile .= $copyConstructorSection[$i];
  }
  
  for (my $i = 0; $i < @makeDictionarySection; $i++) {
    $mFile .= $makeDictionarySection[$i];
  }
  
  for (my $i = 0; $i < @destructorSection; $i++) {
    $mFile .= $destructorSection[$i];
  }

  $mFile .= "\@end\n";  
  
  my $hFileName = $className . ".h";
  my $mFileName = $className . ".m";

  $hFiles{$hFileName} = $hFile;
  $mFiles{$mFileName} = $mFile;

  print $hFile;
  print $mFile;
} 
 
my $json = JSON->new->allow_nonref;
 
my $json_text   = "[{\"case-sensitive\":false,\"name\":\"aboutMe\",\"length\":null,\"type\":\"string\"},{\"name\":\"birthday\",\"type\":\"date\"},{\"case-sensitive\":false,\"name\":\"currentLocation\",\"length\":1000,\"type\":\"string\"},{\"name\":\"display\",\"type\":\"json\"},{\"case-sensitive\":false,\"name\":\"displayName\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"email\",\"length\":256,\"type\":\"string\",\"constraints\":[\"unique\"]},{\"name\":\"emailVerified\",\"type\":\"dateTime\"},{\"case-sensitive\":false,\"name\":\"familyName\",\"length\":1000,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"case-sensitive\":false,\"name\":\"gender\",\"length\":100,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"givenName\",\"length\":1000,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"name\":\"lastLogin\",\"type\":\"dateTime\"},{\"case-sensitive\":false,\"name\":\"middleName\",\"length\":1000,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"name\":\"password\",\"type\":\"password-crypt-sha256\"},{\"name\":\"photos\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":true,\"name\":\"type\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":true,\"name\":\"value\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"primaryAddress\",\"type\":\"object\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"address1\",\"length\":1000,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"case-sensitive\":false,\"name\":\"address2\",\"length\":1000,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"case-sensitive\":false,\"name\":\"city\",\"length\":1000,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"case-sensitive\":false,\"name\":\"company\",\"length\":1000,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"case-sensitive\":false,\"name\":\"mobile\",\"length\":100,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"case-sensitive\":false,\"name\":\"phone\",\"length\":100,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"case-sensitive\":false,\"name\":\"stateAbbreviation\",\"length\":100,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"case-sensitive\":false,\"name\":\"zip\",\"length\":100,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]},{\"case-sensitive\":false,\"name\":\"zipPlus4\",\"length\":100,\"type\":\"string\",\"constraints\":[\"unicode-printable\"]}]},{\"name\":\"profiles\",\"type\":\"plural\",\"attr_defs\":[{\"name\":\"accessCredentials\",\"type\":\"json\"},{\"case-sensitive\":false,\"name\":\"domain\",\"length\":1000,\"type\":\"string\",\"constraints\":[\"required\"]},{\"name\":\"friends\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":true,\"name\":\"identifier\",\"length\":null,\"type\":\"string\",\"constraints\":[\"required\"]}]},{\"case-sensitive\":false,\"name\":\"identifier\",\"length\":1000,\"type\":\"string\",\"constraints\":[\"required\",\"unique\"]},{\"name\":\"profile\",\"type\":\"object\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"aboutMe\",\"length\":null,\"type\":\"string\"},{\"name\":\"accounts\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"domain\",\"length\":1000,\"type\":\"string\"},{\"name\":\"primary\",\"type\":\"boolean\"},{\"case-sensitive\":false,\"name\":\"userid\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":true,\"name\":\"username\",\"length\":1000,\"type\":\"string\"}]},{\"name\":\"addresses\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"country\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"extendedAddress\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"formatted\",\"length\":null,\"type\":\"string\"},{\"name\":\"latitude\",\"type\":\"decimal\"},{\"case-sensitive\":false,\"name\":\"locality\",\"length\":1000,\"type\":\"string\"},{\"name\":\"longitude\",\"type\":\"decimal\"},{\"case-sensitive\":false,\"name\":\"poBox\",\"length\":100,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"postalCode\",\"length\":100,\"type\":\"string\"},{\"name\":\"primary\",\"type\":\"boolean\"},{\"case-sensitive\":false,\"name\":\"region\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"streetAddress\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"type\",\"length\":1000,\"type\":\"string\"}]},{\"name\":\"anniversary\",\"type\":\"date\"},{\"case-sensitive\":false,\"name\":\"birthday\",\"length\":100,\"type\":\"string\"},{\"name\":\"bodyType\",\"type\":\"object\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"build\",\"length\":100,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"color\",\"length\":100,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"eyeColor\",\"length\":100,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"hairColor\",\"length\":100,\"type\":\"string\"},{\"name\":\"height\",\"type\":\"decimal\"}]},{\"name\":\"books\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"book\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"cars\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"car\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"children\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"value\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"currentLocation\",\"type\":\"object\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"country\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"extendedAddress\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"formatted\",\"length\":1000,\"type\":\"string\"},{\"name\":\"latitude\",\"type\":\"decimal\"},{\"case-sensitive\":false,\"name\":\"locality\",\"length\":1000,\"type\":\"string\"},{\"name\":\"longitude\",\"type\":\"decimal\"},{\"case-sensitive\":false,\"name\":\"poBox\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"postalCode\",\"length\":100,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"region\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"streetAddress\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"type\",\"length\":null,\"type\":\"string\"}]},{\"case-sensitive\":true,\"name\":\"displayName\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"drinker\",\"length\":null,\"type\":\"string\"},{\"name\":\"emails\",\"type\":\"plural\",\"attr_defs\":[{\"name\":\"primary\",\"type\":\"boolean\"},{\"case-sensitive\":false,\"name\":\"type\",\"length\":256,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"value\",\"length\":256,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"ethnicity\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"fashion\",\"length\":null,\"type\":\"string\"},{\"name\":\"food\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"food\",\"length\":null,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"gender\",\"length\":100,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"happiestWhen\",\"length\":null,\"type\":\"string\"},{\"name\":\"heroes\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"hero\",\"length\":null,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"humor\",\"length\":null,\"type\":\"string\"},{\"name\":\"ims\",\"type\":\"plural\",\"attr_defs\":[{\"name\":\"primary\",\"type\":\"boolean\"},{\"case-sensitive\":false,\"name\":\"type\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"value\",\"length\":null,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"interestedInMeeting\",\"length\":null,\"type\":\"string\"},{\"name\":\"interests\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"interest\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"jobInterests\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"jobInterest\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"languages\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"language\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"languagesSpoken\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"languageSpoken\",\"length\":null,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"livingArrangement\",\"length\":null,\"type\":\"string\"},{\"name\":\"lookingFor\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"value\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"movies\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"movie\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"music\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"music\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"name\",\"type\":\"object\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"familyName\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"formatted\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"givenName\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"honorificPrefix\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"honorificSuffix\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"middleName\",\"length\":1000,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"nickname\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"note\",\"length\":null,\"type\":\"string\"},{\"name\":\"organizations\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"department\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"description\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"endDate\",\"length\":null,\"type\":\"string\"},{\"name\":\"location\",\"type\":\"object\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"country\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"extendedAddress\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"formatted\",\"length\":null,\"type\":\"string\"},{\"name\":\"latitude\",\"type\":\"decimal\"},{\"case-sensitive\":false,\"name\":\"locality\",\"length\":1000,\"type\":\"string\"},{\"name\":\"longitude\",\"type\":\"decimal\"},{\"case-sensitive\":false,\"name\":\"poBox\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"postalCode\",\"length\":100,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"region\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"streetAddress\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"type\",\"length\":1000,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"name\",\"length\":1000,\"type\":\"string\"},{\"name\":\"primary\",\"type\":\"boolean\"},{\"case-sensitive\":false,\"name\":\"startDate\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"title\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"type\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"pets\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"value\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"phoneNumbers\",\"type\":\"plural\",\"attr_defs\":[{\"name\":\"primary\",\"type\":\"boolean\"},{\"case-sensitive\":false,\"name\":\"type\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"value\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"photos\",\"type\":\"plural\",\"attr_defs\":[{\"name\":\"primary\",\"type\":\"boolean\"},{\"case-sensitive\":false,\"name\":\"type\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"value\",\"length\":null,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"politicalViews\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":true,\"name\":\"preferredUsername\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"profileSong\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"profileUrl\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"profileVideo\",\"length\":1000,\"type\":\"string\"},{\"name\":\"published\",\"type\":\"dateTime\"},{\"name\":\"quotes\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"quote\",\"length\":null,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"relationshipStatus\",\"length\":1000,\"type\":\"string\"},{\"name\":\"relationships\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"relationship\",\"length\":1000,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"religion\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"romance\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"scaredOf\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"sexualOrientation\",\"length\":null,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"smoker\",\"length\":null,\"type\":\"string\"},{\"name\":\"sports\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"sport\",\"length\":null,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"status\",\"length\":1000,\"type\":\"string\"},{\"name\":\"tags\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"tag\",\"length\":1000,\"type\":\"string\"}]},{\"name\":\"turnOffs\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"turnOff\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"turnOns\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"turnOn\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"tvShows\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"tvShow\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"updated\",\"type\":\"dateTime\"},{\"name\":\"urls\",\"type\":\"plural\",\"attr_defs\":[{\"name\":\"primary\",\"type\":\"boolean\"},{\"case-sensitive\":false,\"name\":\"type\",\"length\":1000,\"type\":\"string\"},{\"case-sensitive\":false,\"name\":\"value\",\"length\":null,\"type\":\"string\"}]},{\"case-sensitive\":false,\"name\":\"utcOffset\",\"length\":null,\"type\":\"string\"}]},{\"name\":\"provider\",\"type\":\"json\"},{\"case-sensitive\":true,\"name\":\"remote_key\",\"length\":4096,\"type\":\"string\"}]},{\"name\":\"statuses\",\"type\":\"plural\",\"attr_defs\":[{\"case-sensitive\":false,\"name\":\"status\",\"length\":1000,\"type\":\"string\"},{\"name\":\"statusCreated\",\"type\":\"dateTime\"}]}]";
my $perl_scalar = $json->decode( $json_text );

recursiveParse ("captureUser", $perl_scalar);

my @hFileNames = keys (%hFiles);
my @mFileNames = keys (%mFiles);

foreach my $fileName (@hFileNames) {
  open (FILE, ">CaptureObjects/$fileName");
  print FILE $hFiles{$fileName};
}

foreach my $fileName (@mFileNames) {
  open (FILE, ">CaptureObjects/$fileName");
  print FILE $mFiles{$fileName};
}
