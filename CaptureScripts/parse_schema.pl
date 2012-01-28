#!/usr/bin/perl
use strict;
use warnings;

use JSON; # imports encode_json, decode_json, to_json and from_json.


my %hFiles = ();
my %mFiles = ();

###################################################################
#  Section only here when there are required properties     
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

my @constructorParts      = ("- (id)init", "",
                             "\n{\n",
                                "\tif (", "", ")\n",
                                "\t{\n\t\t[self release];\n\t\treturn nil;\n\t}\n\n",
                                "\tif ((self = [super init]))\n\t{\n", "",
                                "\t}\n\treturn self;\n}\n\n");

my @classConstructorParts = ("+ (id)", "", "", 
                             "\n{\n\treturn [[[", "", " alloc] init", "", "] autorelease];\n}\n\n"); 

my @copyConstructorParts  = ("- (id)copyWithZone:(NSZone*)zone\n{\n", 
                             "", " allocWithZone:zone] init", "", "];\n\n",
                             "", "\n\treturn ", "", ";\n}\n\n");

my @jsonifyParts          = ("- (NSDictionary*)jsonFromObject\n{\n\tNSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];\n\n",
                            "", "", "\n\treturn dict;\n}\n\n");

my @destructorParts       = ("- (void)dealloc\n{\n", "", "\n\t[super dealloc];\n}\n");

  
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

sub recursiveParse {

  my $objectName = $_[0];
  my $arrRef     = $_[1];

  my @propertyList = @$arrRef;

  my $extraImportsSection     = "";
  my $propertiesSection       = "";
  my $synthesizeSection       = "";
  my @constructorSection      = @constructorParts;
  my @classConstructorSection = @classConstructorParts;
  my @copyConstructorSection  = @copyConstructorParts;
  my @destructorSection       = @destructorParts;
  my @jsonifySection          = @jsonifyParts;
  
  my $className = "JR" . ucfirst($objectName) . "Object";
 
  $classConstructorSection[1] = $objectName . "Object";
  $classConstructorSection[4] = $className;
  
  $copyConstructorSection[1]  = "\t" . $className . " *" . $objectName . "ObjectCopy =\n\t\t\t\t[[" . $className;
  $copyConstructorSection[7]  = $objectName . "ObjectCopy";
  

  my $requiredProperties = 0;
  
  my $i = 0;
  foreach my $hashRef (@propertyList) {
    print "hashRef[$i]: $hashRef\n";
    
    my %propertyHash = %$hashRef;
    my $propertyName = $propertyHash{"name"};
    my $propertyType = $propertyHash{"type"};
    
    print "property name: $propertyName\n";
    print "property type: $propertyType\n";

    my $objectiveType = "";
    my $dictionaryStr = $propertyName; # Default operation is to just stick the NSObject into an NSMutableDictionary
    my $isBooleanType = 0;
    my $isComplexType = 0;
    
    my $isRequired = getIsRequired (\%propertyHash); 
    if ($isRequired) {
      print "REQUIRED PROPERTY\n";
      $requiredProperties++;
    }
    
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

    } elsif ($propertyType eq "json") { #???
      $objectiveType = "NSString *";

    } elsif ($propertyType eq "plural") { # RECURSE!!
      $objectiveType = "JR" . ucfirst($propertyName) . " *";
      $dictionaryStr = "[$propertyName jsonFromObject]";
      $extraImportsSection = "#import \"$objectiveType.h\"\n";

    } elsif ($propertyType eq "object") { # RECURSE!!
      $objectiveType = "JR" . ucfirst($propertyName) . " *";
      $dictionaryStr = "[$propertyName jsonFromObject]";
      $extraImportsSection = "#import \"JR" . ucfirst($propertyName) . ".h\"\n";
      
    } else {
      print "PROPERTY TYPE NOT BEING CAUGHT: " . $propertyName . "\n";
    }

    if ($isRequired) {
      if ($requiredProperties == 1) { # If it's the first required property
        $constructorSection[1] .= "With" . ucfirst($propertyName) . ":(" . $objectiveType . ")new" . ucfirst($propertyName);
        $constructorSection[4] .= "!new" . ucfirst($propertyName);
        
        $classConstructorSection[2] .= "With" . ucfirst($propertyName) . ":(" . $objectiveType . ")" . ucfirst($propertyName);
        $classConstructorSection[6] .= "With" . ucfirst($propertyName) . ":" . ucfirst($propertyName);

        $copyConstructorSection[3]  .= "With" . ucfirst($propertyName) . ":" . ucfirst($propertyName);               
        
      } else {
        $constructorSection[1] .= " and" . ucfirst($propertyName) . ":(" . $objectiveType . ")new" . ucfirst($propertyName);
        $constructorSection[4] .= " && !new" . ucfirst($propertyName);

        $classConstructorSection[2] .= " and" . ucfirst($propertyName) . ":(" . $objectiveType . ")" . ucfirst($propertyName);
        $classConstructorSection[6] .= " and" . ucfirst($propertyName) . ":" . ucfirst($propertyName);

        $copyConstructorSection[3]  .= " and" . ucfirst($propertyName) . ":" . ucfirst($propertyName);
      }        
      
      $constructorSection[8] .= "\t\t" . $propertyName . " = [new" . ucfirst($propertyName) . " copy];\n";
      $jsonifySection[1] .= "\t\t[dict setObject:" . $dictionaryStr . " forKey:\@\"" . $propertyName . "\"];\n";
      
    } else {
      $jsonifySection[2] .= "\tif (" . $propertyName . ")\n";
      $jsonifySection[2] .= "\t\t\t[dict setObject:" . $dictionaryStr . " forKey:\@\"" . $propertyName . "\"];\n\n";
      
      $copyConstructorSection[5] .= "\t" . $objectName . "ObjectCopy." . $propertyName . " = self." . $propertyName . ";\n";
    }
    
    if ($isBooleanType) {
      $propertiesSection    .= "\@property                   $objectiveType $propertyName;\n";
      $synthesizeSection    .= "\@synthesize $propertyName;\n";    
    } else {
      $destructorSection[1] .= "\t[$propertyName release];\n";
      $propertiesSection    .= "\@property (nonatomic, copy) $objectiveType$propertyName;\n";
      $synthesizeSection    .= "\@synthesize $propertyName;\n";
    }      

    $i++;
  }

  
  my $hFile = "\n#import <Foundation/Foundation.h>\n#import \"JRCapture.h\"\n";
  
  $hFile .= $extraImportsSection . "\n";
  $hFile .= "\@interface $className : NSObject <NSCopying, JRJsonifying>\n";
  $hFile .= $propertiesSection;
  $hFile .= "\@end\n";

  my $mFile = "\n#import \"$className.h\"\n\n";
  
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
  
  for (my $i = 0; $i < @jsonifySection; $i++) {
    $mFile .= $jsonifySection[$i];
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

recursiveParse ("user", $perl_scalar);

my @hFileNames = keys (%hFiles);
my @mFileNames = keys (%mFiles);

foreach my $fileName (@hFileNames) {
  open (FILE, ">$fileName");
  print FILE $hFiles{$fileName};
}

foreach my $fileName (@mFileNames) {
  open (FILE, ">$fileName");
  print FILE $mFiles{$fileName};
}
