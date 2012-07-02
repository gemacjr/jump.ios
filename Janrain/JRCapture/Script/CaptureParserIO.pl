#!/usr/bin/env perl -w

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
# File:   CaptureParserIO.pl
# Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
# Date:   Wednesday, February 8, 2012
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

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