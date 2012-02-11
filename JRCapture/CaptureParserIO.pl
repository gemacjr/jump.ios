#!/usr/bin/perl -w
use strict;
use warnings;

sub getCaptureSchema {
  my $failedCount = $_[0];
  my $attemptedName = $_[1];
  
  if ($failedCount == 0) {  
    print "Where is your Capture Schema located (path and file name)? ";
    my $name = <STDIN>;

  	chomp ($name);
	
	  open(FH, "$name") or getCaptureSchema(($failedCount+1), $name);

#    return join("", <FH>);
    
	} else {
    print "\n[ERROR] CaptureSchemaParser could not find: $attemptedName\n";
    print "[ERROR] Please make sure that you specified the correct path and file name.\n\n";
    print "Where is your Capture Schema located (path and file name)? ";
    my $name = <STDIN>;

    chomp ($name);

    if ($failedCount < 3) {  
      open(FH, "$name") or getCaptureSchema(($failedCount+1), $name);      
    } else {
    	open(FH, "$name") or die "[ERROR] CaptureSchemaParser could not find: $attemptedName\nGiving up!\n";
    }
  }
	
  return join("", <FH>);
}

sub openSchemaNamed {
  my $name = $_[0];

  open(FH, "$name") or getCaptureSchema(1, $name);

  return join("", <FH>);
}

1;