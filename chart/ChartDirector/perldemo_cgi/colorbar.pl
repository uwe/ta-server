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

# The colors for the bar chart
my $colors = [0xb8bc9c, 0xa0bdc4, 0x999966, 0x333366, 0xc3c3e6];

# Create a XYChart object of size 300 x 220 pixels. Use golden background color. Use
# a 2 pixel 3D border.
my $c = new XYChart(300, 220, perlchartdir::goldColor(), -1, 2);

# Add a title box using 10 point Arial Bold font. Set the background color to
# metallic blue (9999FF) Use a 1 pixel 3D border.
$c->addTitle("Daily Network Load", "arialbd.ttf", 10)->setBackground(
    perlchartdir::metalColor(0x9999ff), -1, 1);

# Set the plotarea at (40, 40) and of 240 x 150 pixels in size
$c->setPlotArea(40, 40, 240, 150);

# Add a multi-color bar chart layer using the given data and colors. Use a 1 pixel 3D
# border for the bars.
$c->addBarLayer3($data, $colors)->setBorderColor(-1, 1);

# Set the labels on the x axis.
$c->xAxis()->setLabels($labels);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

