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

#
# Displays the monthly revenue for the selected year. The selected year should be
# passed in as a query parameter called "xLabel"
#
my $selectedYear = ($query->param("xLabel") or 2001);

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

#
# Now we have read data into arrays, we can draw the chart using ChartDirector
#

# Create a XYChart object of size 600 x 360 pixels
my $c = new XYChart(600, 360);

# Set the plotarea at (60, 50) and of size 480 x 270 pixels. Use a vertical gradient
# color from light blue (eeeeff) to deep blue (0000cc) as background. Set border and
# grid lines to white (ffffff).
$c->setPlotArea(60, 50, 480, 270, $c->linearGradientColor(60, 50, 60, 270, 0xeeeeff,
    0x0000cc), -1, 0xffffff, 0xffffff);

# Add a title to the chart using 15pts Times Bold Italic font
$c->addTitle("Global Revenue for Year $selectedYear", "timesbi.ttf", 18);

# Add a legend box at (60, 25) (top of the plotarea) with 9pts Arial Bold font
$c->addLegend(60, 25, 0, "arialbd.ttf", 9)->setBackground($perlchartdir::Transparent)
    ;

# Add a line chart layer using the supplied data
my $layer = $c->addLineLayer2();
$layer->addDataSet($software, 0xffaa00, "Software")->setDataSymbol(
    $perlchartdir::CircleShape, 9);
$layer->addDataSet($hardware, 0x00ff00, "Hardware")->setDataSymbol(
    $perlchartdir::DiamondShape, 11);
$layer->addDataSet($services, 0xff0000, "Services")->setDataSymbol(
    perlchartdir::Cross2Shape(), 11);

# Set the line width to 3 pixels
$layer->setLineWidth(3);

# Set the x axis labels. In this example, the labels must be Jan - Dec.
my $labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct",
    "Nov", "Dec"];
$c->xAxis()->setLabels($labels);

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

# Create the image and save it in a temporary location
my $chart1URL = $c->makeTmpFile("/tmp/tmpcharts");

# Create an image map for the chart
my $imageMap = $c->getHTMLImageMap("xystub.pl", "",
    "title='{dataSetName} @ {xLabel} = USD {value|0}M'");

print "Content-type: text/html\n\n";
print <<EndOfHTML
<html>
<body style="margin:5px 0px 0px 5px">
<div style="font-size:18pt; font-family:verdana; font-weight:bold">
    Database Clickable Charts
</div>
<hr style="border:solid 1px #000080" />
<div style="font-size:10pt; font-family:verdana; width:600px; margin-bottom:20px">
    You have click the bar for the year $selectedYear.
    Below is the "drill-down" chart showing the monthly details.
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
