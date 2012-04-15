#!/usr/bin/perl
print "Content-type: text/html\n\n";
print <<EndOfHTML
<html>
<body style="margin:0px">
<div style="margin:5px">
<div style="font-family:verdana; font-weight:bold; font-size:18pt;">
Database Integration Demo (2)
</div>
<hr style="border:solid 1px #000080" />
<div style="font-family:verdana; font-size:10pt;">

This example demonstrates creating a chart using data from a database. The database query
is performed in the containing HTML page. The data are then passed to the chart generation
pages as HTTP GET parameters.<br><br>

To run this example, you need to set up the database as mentioned in <a href="dbdemo1_intro.pl">
Database Integration Demo (1)</a>. After that, <a href="dbdemo2.pl">click here</a> to run
this demo.<br><br>

If you just want to view the sample code, please use the links below:
<ul>
    <li><a href="viewsource.pl?file=dbdemo2.pl">View containing HTML page source code</a>
    <li><a href="viewsource.pl?file=dbdemo2a.pl">View chart generation page source code for upper chart</a>
    <li><a href="viewsource.pl?file=dbdemo2b.pl">View chart generation page source code for lower chart</a>
</ul>

</div>
</body>
</html>
EndOfHTML
;
