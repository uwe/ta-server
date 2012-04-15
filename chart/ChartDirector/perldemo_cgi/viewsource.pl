#!/usr/bin/perl
use File::Basename;

#standard code to parse HTTP query parameters
%query = map {my($k,$v) = split(/=/)} split(/&/, $ENV{"QUERY_STRING"});

print "Content-type: text/html\n\n";
print "<html>\n";
print "<body>\n";

my $myFile = $query{"file"};
print "<p style='font-size:14pt; font-family:verdana; font-weight:bold'>$myFile</p>\n";
print "<p style='font-size:10pt; font-family:verdana;'><a href='javascript:history.go(-1);'>Back to Chart Graphics</a></p>\n";

print "<xmp>\n";
open(INF, dirname($0)."/".basename($myFile));
foreach $line (<INF>) {
	chomp($line);
	print "$line\n";
}
close(INF);
print "</xmp>\n";

print "</body>\n";
print "</html>\n";
