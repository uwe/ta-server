#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# The data for the area chart
my $data = [30, 28, 40, 55, 75, 68, 54, 60, 50, 62, 75, 65, 75, 89, 60, 55, 53, 35,
    50, 66, 56, 48, 52, 65, 62];

# The labels for the area chart
my $labels = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12",
    "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"];

# Create a XYChart object of size 250 x 250 pixels
my $c = new XYChart(250, 250);

# Set the plotarea at (30, 20) and of size 200 x 200 pixels
$c->setPlotArea(30, 20, 200, 200);

# Add an area chart layer using the given data
$c->addAreaLayer($data);

# Set the labels on the x axis.
$c->xAxis()->setLabels($labels);

# Display 1 out of 3 labels on the x-axis.
$c->xAxis()->setLabelStep(3);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

