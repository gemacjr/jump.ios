#!/usr/bin/perl

#package ObjCMethodParts;
#use Exporter;
#
#@ISA = ('Exporter');
#@EXPORT = ('hello');
#
#@EXPORT = ('getConstructorParts');
#@EXPORT = ('getClassConstructorParts');
#@EXPORT = ('getCopyConstructorParts');
#@EXPORT = ('getToDictionaryParts');
#@EXPORT = ('getToObjectParts');
#@EXPORT = ('getDestructorParts');

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
#     <object>.<property> = [<propertyFromDictionaryMethod>:[dictionary objectForKey:@"profile"]];
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
# - (NSDictionary*)dictionaryFromObject
# {
#     NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
#
#     Section only here when there are required properties     
#                              |                         
#                              V                         
#     [dict setObject:<requiredProperty> forKey:@"<requiredProperty"];
#       OR
#     [dict setObject:<requiredPropertyToDictionaryMethod> forKey:@"<requiredProperty"];
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
"- (NSDictionary*)dictionaryFromObject",
"\n{\n",
"    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];\n\n",
"", 
"", 
"\n    return dict;",
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

sub getDestructorParts {
  return @destructorParts;
}

sub hello {
  print "Hello, world\n";
}

1;