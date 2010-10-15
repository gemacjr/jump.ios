# Xcode auto-versioning script for Subversion by Axel Andersson
# Updated for git by Marcus S. Zarra and Matt Long
# Updated for JREngage library by Lilli Szafranski

use strict;
 
# Get the current git commit hash and use it to set the CFBundleVersion value
my $REV = `/opt/local/bin/git tag`;
my $INFO = "JREngage/JREngage-Info.plist";
 
my @version =  split(/\n/, $REV);

print "@version\n";

my $version = @version[-1];

print "$version\n";

die "$0: No Git revision found" unless $version;
 
open(FH, "$INFO") or die "$0: $INFO: $!";
my $info = join("", <FH>);

print "$info";

close(FH);
 
$info =~ s/([\t ]+<key>CFBundleShortVersionString<\/key>\n[\t ]+<string>).*?(<\/string>)/$1$version$2/;
 
open(FH, ">$INFO") or die "$0: $INFO: $!";
print FH $info;
close(FH);