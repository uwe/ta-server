#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# The data for the bar chart
my $data0 = [100, 125, 245, 147, 67];
my $data1 = [85, 156, 179, 211, 123];
my $data2 = [97, 87, 56, 267, 157];

# The labels for the bar chart
my $labels = ["Mon", "Tue", "Wed", "Thu", "Fri"];

# Create a XYChart object of size 500 x 320 pixels
my $c = new XYChart(500, 320);

# Set the plotarea at (100, 40) and of size 280 x 240 pixels
$c->setPlotArea(100, 40, 280, 240);

# Add a legend box at (400, 100)
$c->addLegend(400, 100);

# Add a title to the chart using 14 points Times Bold Itatic font
$c->addTitle("Weekday Network Load", "timesbi.ttf", 14);

# Add a title to the y axis. Draw the title upright (font angle = 0)
$c->yAxis()->setTitle("Average\nWorkload\n(MBytes\nPer Hour)")->setFontAngle(0);

# Set the labels on the x axis
$c->xAxis()->setLabels($labels);

# Add a stacked bar layer and set the layer 3D depth to 8 pixels
my $layer = $c->addBarLayer2($perlchartdir::Stack, 8);

# Add the three data sets to the bar layer
$layer->addDataSet($data0, 0xff8080, "Server # 1");
$layer->addDataSet($data1, 0x80ff80, "Server # 2");
$layer->addDataSet($data2, 0x8080ff, "Server # 3");

# Enable bar label for the whole bar
$layer->setAggregateLabelStyle();

# Enable bar label for each segment of the stacked bar
$layer->setDataLabelStyle();

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

