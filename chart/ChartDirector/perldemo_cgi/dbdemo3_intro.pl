#!/usr/bin/perl
print "Content-type: text/html\n\n";
print <<EndOfHTML
<html>
<body style="margin:0px">
<div style="margin:5px">
<div style="font-family:verdana; font-weight:bold; font-size:18pt;">
Database Clickable Charts
</div>
<hr style="border:solid 1px #000080" />
<div style="font-family:verdana; font-size:10pt;">
The example demonstrates creating a clickable chart using data from a database. You can
click on a bar in the 10-year bar chart to "drill down" onto a particular year.<br><br>

To run this example, you need to set up the database as mentioned in <a href="dbdemo1_intro.pl">
Database Integration Demo (1)</a>. After that, <a href="dbdemo3.pl">click here</a>
to run this demo.<br><br>

If you just want to view the sample code, please use the links below:
<ul>
    <li><a href="viewsource.pl?file=dbdemo3.pl">Source code of the clickable 10-year bar chart page</a>
    <li><a href="viewsource.pl?file=dbdemo3a.pl">Source code of the clickable monthly bar chart page</a>
</ul>

</div>
</body>
</html>
EndOfHTML
;
