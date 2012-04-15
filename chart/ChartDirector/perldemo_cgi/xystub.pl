#!/usr/bin/perl

# Get HTTP query parameters
use CGI;
my $query = new CGI;

print "Content-type: text/html\n\n";
print <<EndOfHTML
<html>
<body style="margin:5px 0px 0px 5px">
<div style="font-size:18pt; font-family:verdana; font-weight:bold">
    Simple Clickable XY Chart Handler
</div>
<hr style="border:solid 1px #000080" />
<div style="font-size:10pt; font-family:verdana; margin-bottom:20">
    <a href="viewsource.pl?file=$ENV{"SCRIPT_NAME"}">View Source Code</a>
</div>
<div style="font-size:10pt; font-family:verdana;">
<b>You have clicked on the following chart element :</b><br />
<ul>
    <li>Data Set : @{[$query->param("dataSetName")]}</li>
    <li>X Position : @{[$query->param("x")]}</li>
    <li>X Label : @{[$query->param("xLabel")]}</li>
    <li>Data Value : @{[$query->param("value")]}</li>
</ul>
</div>
</body>
</html>
EndOfHTML
;
