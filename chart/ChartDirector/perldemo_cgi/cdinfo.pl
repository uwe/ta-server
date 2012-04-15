#!/usr/bin/perl

#Include current script directory in the module path (needed on Microsoft IIS).
#This allows this script to work by copying ChartDirector to the same directory
#as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

print "Content-type: text/html\n\n";
print <<EndOfHTML
<html>
<body topmargin="0" leftmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
<div style="margin:5;">
<div style="font-family:verdana; font-weight:bold; font-size:18pt;">
ChartDirector Information
</div>
<hr color="#000080">
<div style="font-family:verdana; font-size:10pt;">
<ul style="margin-top:0; list-style:square; font-family:verdana; font-size:10pt;">
<li>Description : ${\(perlchartdir::getDescription())}<br><br>
<li>Version : ${\((perlchartdir::getVersion() & 0xff000000) / 0x1000000)}.${\((perlchartdir::getVersion() & 0xff0000) / 0x10000)}.${\(perlchartdir::getVersion() & 0xffff)}<br><br>
<li>Copyright : ${\(perlchartdir::getCopyright())}<br><br>
<li>Boot Log : <br><ul><li>${\(join("<li>", split("\n", perlchartdir::getBootLog())))}</ul><br>
<li>Font Loading Test : <br><ul><li>${\(join("<li>", split("\n", perlchartdir::libgTTFTest())))}</ul>
</ul>
</div>
</body>
</html>
EndOfHTML
;
