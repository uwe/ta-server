#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# The data for the bar chart
my $data = [85, 156, 179.5, 211, 123];

# The labels for the bar chart
my $labels = ["Mon", "Tue", "Wed", "Thu", "Fri"];

# Create a XYChart object of size 400 x 240 pixels.
my $c = new XYChart(400, 240);

# Add a title to the chart using 14 pts Times Bold Italic font
$c->addTitle("Weekly Server Load", "timesbi.ttf", 14);

# Set the plotarea at (45, 40) and of 300 x 160 pixels in size. Use alternating light
# grey (f8f8f8) / white (ffffff) background.
$c->setPlotArea(45, 40, 300, 160, 0xf8f8f8, 0xffffff);

# Add a multi-color bar chart layer
my $layer = $c->addBarLayer3($data);

# Set layer to 3D with 10 pixels 3D depth
$layer->set3D(10);

# Set bar shape to circular (cylinder)
$layer->setBarShape($perlchartdir::CircleShape);

# Set the labels on the x axis.
$c->xAxis()->setLabels($labels);

# Add a title to the y axis
$c->yAxis()->setTitle("MBytes");

# Add a title to the x axis
$c->xAxis()->setTitle("Work Week 25");

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

