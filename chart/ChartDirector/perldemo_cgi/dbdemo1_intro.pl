#!/usr/bin/perl
print "Content-type: text/html\n\n";
print <<EndOfHTML
<html>
<body style="margin:0px">
<div style="margin:5px">
<div style="font-family:verdana; font-weight:bold; font-size:18pt;">
Database Integration Demo (1)
</div>
<hr style="border:solid 1px #000080" />
<div style="font-family:verdana; font-size:10pt;">

This example demonstrates creating a chart using data from a database. This example is
based on the MySQL database. To run this example, you need to:

<ul>

    <li>Set up a <a href="http://www.mysql.com">MySQL</a> database server to run on the same
    machine as your web server.
    <li>Install the Perl DBI module and DBI Driver for MySQL. These modules are available
    from <a href="http://www.cpan.org">CPAN</a>.

    <li>Create a database called "sample" in your MySQL server
    <li>Create an account with username "test" and password "test" that can be used to access "sample"
    <li>Import the table "sample.sql" (located in the "perldemo_cgi" subdirectory) into the "sample" database
</ul>

After you have performed the above:
<ul>
    <li><a href="dbdemo_test.pl">Click here</a> to check database connection.
    <li><a href="dbdemo1.pl">Click here</a> to run this demo.
</ul>

If you just want to view the sample code, please use the links below:
<ul>
    <li><a href="viewsource.pl?file=dbdemo1.pl">View containing HTML page source code</a>
    <li><a href="viewsource.pl?file=dbdemo1a.pl">View chart generation page source code</a>
</ul>

</div>
</body>
</html>
EndOfHTML
;
