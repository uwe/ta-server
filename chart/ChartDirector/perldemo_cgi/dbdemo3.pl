#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# SQL statement to get the revenue for the 12 years from 1990 to 2001
my $SQL =
    "Select Sum(Software + Hardware + Services), Year(TimeStamp) From revenue ".
    "Where Year(TimeStamp) >= 1990 And Year(TimeStamp) <= 2001 Group By ".
    "Year(TimeStamp) Order By Year(TimeStamp)";

#
# Connect to database and read the query result into arrays
#
use DBI;
my $dbh = DBI->connect('dbi:mysql:sample', 'test', 'test');
my $sth = $dbh->prepare($SQL);
$sth->execute();

my $revenue = [];
my $timestamp = [];
while (my @row = $sth->fetchrow_array) {
    push @$revenue, $row[0];
    push @$timestamp, $row[1];
}
$dbh->disconnect;

#
# Now we have read data into arrays, we can draw the chart using ChartDirector
#

# Create a XYChart object of size 600 x 360 pixels
my $c = new XYChart(600, 360);

# Set the plotarea at (60, 40) and of size 480 x 280 pixels. Use a vertical gradient
# color from light blue (eeeeff) to deep blue (0000cc) as background. Set border and
# grid lines to white (ffffff).
$c->setPlotArea(60, 40, 480, 280, $c->linearGradientColor(60, 40, 60, 280, 0xeeeeff,
    0x0000cc), -1, 0xffffff, 0xffffff);

# Add a title to the chart using 18pts Times Bold Italic font
$c->addTitle("Annual Revenue for Star Tech", "timesbi.ttf", 18);

# Add a multi-color bar chart layer using the supplied data
my $layer = $c->addBarLayer3($revenue);

# Use glass lighting effect with light direction from the left
$layer->setBorderColor($perlchartdir::Transparent, perlchartdir::glassEffect(
    $perlchartdir::NormalGlare, $perlchartdir::Left));

# Set the x axis labels
$c->xAxis()->setLabels($timestamp);

# Set y-axis tick density to 30 pixels. ChartDirector auto-scaling will use this as
# the guideline when putting ticks on the y-axis.
$c->yAxis()->setTickDensity(30);

# Synchronize the left and right y-axes
$c->syncYAxis();

# Set the y axes titles with 10pts Arial Bold font
$c->yAxis()->setTitle("USD (Millions)", "arialbd.ttf", 10);
$c->yAxis2()->setTitle("USD (Millions)", "arialbd.ttf", 10);

# Set all axes to transparent
$c->xAxis()->setColors($perlchartdir::Transparent);
$c->yAxis()->setColors($perlchartdir::Transparent);
$c->yAxis2()->setColors($perlchartdir::Transparent);

# Set the label styles of all axes to 8pt Arial Bold font
$c->xAxis()->setLabelStyle("arialbd.ttf", 8);
$c->yAxis()->setLabelStyle("arialbd.ttf", 8);
$c->yAxis2()->setLabelStyle("arialbd.ttf", 8);

# Create the image
my $chart1URL = $c->makeTmpFile("/tmp/tmpcharts");

# Create an image map for the chart
my $imageMap = $c->getHTMLImageMap("dbdemo3a.pl", "",
    "title='{xLabel}: US\$ {value|0}M'");

print "Content-type: text/html\n\n";
print <<EndOfHTML
<html>
<body style="margin:5px 0px 0px 5px">
<div style="font-size:18pt; font-family:verdana; font-weight:bold">
    Database Clickable Charts
</div>
<hr style="border:solid 1px #000080" />
<div style="font-size:10pt; font-family:verdana; width:600px; margin-bottom:20px">
    The example demonstrates creating a clickable chart using data from a database.
    Click on a bar below to "drill down" onto a particular year.
<br /><br />
<a href='viewsource.pl?file=$ENV{"SCRIPT_NAME"}'>
    View source code
</a>
</div>

<img src="getchart.pl?img=/tmp/tmpcharts/$chart1URL" border="0" usemap="#map1">
<map name="map1">
$imageMap
</map>

</body>
</html>
EndOfHTML
;
