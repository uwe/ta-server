#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# Get HTTP query parameters
use CGI;
my $query = new CGI;


# The currently selected year
my $selectedYear = ($query->param("year") or 2001);

# SQL statement to get the monthly revenues for the selected year.
my $SQL =
    "Select Software, Hardware, Services From revenue Where Year(TimeStamp) = ".
    "$selectedYear Order By TimeStamp";

#
# Connect to database and read the query result into arrays
#

use DBI;
my $dbh = DBI->connect('dbi:mysql:sample', 'test', 'test');
my $sth = $dbh->prepare($SQL);
$sth->execute();

my $software = [];
my $hardware = [];
my $services = [];
while (my @row = $sth->fetchrow_array) {
    push @$software, $row[0];
    push @$hardware, $row[1];
    push @$services, $row[2];
}
$dbh->disconnect;

# Serialize the data into a string to be used as HTTP query parameters
my $httpParam = sprintf("year=%s&software=%s&hardware=%s&services=%s", $selectedYear,
    join(",", @$software), join(",", @$hardware), join(",", @$services));

#
# The following code generates the <option> tags for the HTML select box, with the
# <option> tag representing the currently selected year marked as selected.
#

my $optionTags = [(undef) x (2001 - 1990 + 1)];
for(my $i = 1990; $i < 2001 + 1; ++$i) {
    if ($i == $selectedYear) {
        $optionTags->[$i - 1990] = "<option value='$i' selected>$i</option>";
    } else {
        $optionTags->[$i - 1990] = "<option value='$i'>$i</option>";
    }
}
my $selectYearOptions = join("", @$optionTags);

print "Content-type: text/html\n\n";
print <<EndOfHTML
<html>
<body style="margin:5px 0px 0px 5px">
<div style="font-size:18pt; font-family:verdana; font-weight:bold">
    Database Integration Demo (2)
</div>
<hr style="border:solid 1px #000080" />
<div style="font-size:10pt; font-family:verdana; width:600px">
This example demonstrates creating a chart using data from a database. The database
query is performed in the containing HTML page. The data are then passed to the chart
generation pages as HTTP GET parameters.
<ul>
    <li><a href="viewsource.pl?file=$ENV{"SCRIPT_NAME"}">
        View containing HTML page source code
    </a></li>
    <li><a href="viewsource.pl?file=dbdemo2a.pl">
        View chart generation page source code for upper chart
    </a></li>
    <li><a href="viewsource.pl?file=dbdemo2b.pl">
        View chart generation page source code for lower chart
    </a></li>
</ul>
<form>
    I want to obtain the revenue data for the year
    <select name="year">
        $selectYearOptions
    </select>
    <input type="submit" value="OK">
</form>
</div>

<img src="dbdemo2a.pl?$httpParam">
<br><br>
<img src="dbdemo2b.pl?$httpParam">
</body>
</html>
EndOfHTML
;
