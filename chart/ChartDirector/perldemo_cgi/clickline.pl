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

# Get the selected year.
my $selectedYear = $query->param("xLabel");

#
# In real life, the data may come from a database based on selectedYear. In this
# example, we just use a random number generator.
#
my $seed = 50 + (int($selectedYear) - 1996) * 15;
my $rantable = new RanTable($seed, 1, 12);
$rantable->setCol2(0, $seed, -$seed * 0.25, $seed * 0.33, $seed * 0.1, $seed * 3);

my $data = $rantable->getCol(0);

#
# Now we obtain the data into arrays, we can start to draw the chart using
# ChartDirector
#

# Create a XYChart object of size 600 x 320 pixels
my $c = new XYChart(600, 360);

# Add a title to the chart using 18pts Times Bold Italic font
$c->addTitle("Month Revenue for Star Tech for $selectedYear", "timesbi.ttf", 18);

# Set the plotarea at (60, 40) and of size 500 x 280 pixels. Use a vertical gradient
# color from light blue (eeeeff) to deep blue (0000cc) as background. Set border and
# grid lines to white (ffffff).
$c->setPlotArea(60, 40, 500, 280, $c->linearGradientColor(60, 40, 60, 280, 0xeeeeff,
    0x0000cc), -1, 0xffffff, 0xffffff);

# Add a red line (ff0000) chart layer using the data
my $dataSet = $c->addLineLayer()->addDataSet($data, 0xff0000, "Revenue");

# Set the line width to 3 pixels
$dataSet->setLineWidth(3);

# Use a 13 point circle symbol to plot the data points
$dataSet->setDataSymbol($perlchartdir::CircleSymbol, 13);

# Set the labels on the x axis. In this example, the labels must be Jan - Dec.
my $labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct",
    "Nov", "Dec"];
$c->xAxis()->setLabels($labels);

# When auto-scaling, use tick spacing of 40 pixels as a guideline
$c->yAxis()->setTickDensity(40);

# Add a title to the x axis to reflect the selected year
$c->xAxis()->setTitle("Year $selectedYear", "timesbi.ttf", 12);

# Add a title to the y axis
$c->yAxis()->setTitle("USD (millions)", "timesbi.ttf", 12);

# Set axis label style to 8pts Arial Bold
$c->xAxis()->setLabelStyle("arialbd.ttf", 8);
$c->yAxis()->setLabelStyle("arialbd.ttf", 8);

# Set axis line width to 2 pixels
$c->xAxis()->setWidth(2);
$c->yAxis()->setWidth(2);

# Create the image and save it in a temporary location
my $chart1URL = $c->makeTmpFile("/tmp/tmpcharts");

# Create an image map for the chart
my $imageMap = $c->getHTMLImageMap("clickpie.pl?year=$selectedYear", "",
    "title='{xLabel}: US\$ {value|0}M'");

print "Content-type: text/html\n\n";
print <<EndOfHTML
<html>
<body style="margin:5px 0px 0px 5px">
<div style="font-size:18pt; font-family:verdana; font-weight:bold">
    Simple Clickable Line Chart
</div>
<hr style="border:solid 1px #000080" />
<div style="font-size:10pt; font-family:verdana; margin-bottom:20">
    <a href="viewsource.pl?file=$ENV{"SCRIPT_NAME"}">View Source Code</a>
</div>
<img src="getchart.pl?img=/tmp/tmpcharts/$chart1URL" border="0" usemap="#map1">
<map name="map1">
$imageMap
</map>
</body>
</html>
EndOfHTML
;
