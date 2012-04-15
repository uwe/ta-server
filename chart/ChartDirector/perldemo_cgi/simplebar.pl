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

# Create a XYChart object of size 250 x 250 pixels
my $c = new XYChart(250, 250);

# Set the plotarea at (30, 20) and of size 200 x 200 pixels
$c->setPlotArea(30, 20, 200, 200);

# Add a bar chart layer using the given data
$c->addBarLayer($data);

# Set the labels on the x axis.
$c->xAxis()->setLabels($labels);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

