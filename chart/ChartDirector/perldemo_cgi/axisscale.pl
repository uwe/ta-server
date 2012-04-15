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

# The data for the chart
my $data = [5.5, 3.5, -3.7, 1.7, -1.4, 3.3];
my $labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"];

# Create a XYChart object of size 200 x 190 pixels
my $c = new XYChart(200, 190);

# Set the plot area at (30, 20) and of size 140 x 140 pixels
$c->setPlotArea(30, 20, 140, 140);

# Configure the axis as according to the input parameter
if ($query->param("img") eq "0") {
    $c->addTitle("No Axis Extension", "arial.ttf", 8);
} elsif ($query->param("img") eq "1") {
    $c->addTitle("Top/Bottom Extensions = 0/0", "arial.ttf", 8);
    # Reserve 20% margin at top of plot area when auto-scaling
    $c->yAxis()->setAutoScale(0, 0);
} elsif ($query->param("img") eq "2") {
    $c->addTitle("Top/Bottom Extensions = 0.2/0.2", "arial.ttf", 8);
    # Reserve 20% margin at top and bottom of plot area when auto-scaling
    $c->yAxis()->setAutoScale(0.2, 0.2);
} elsif ($query->param("img") eq "3") {
    $c->addTitle("Axis Top Margin = 15", "arial.ttf", 8);
    # Reserve 15 pixels at top of plot area
    $c->yAxis()->setMargin(15);
} else {
    $c->addTitle("Manual Scale -5 to 10", "arial.ttf", 8);
    # Set the y axis to scale from -5 to 10, with ticks every 5 units
    $c->yAxis()->setLinearScale(-5, 10, 5);
}

# Set the labels on the x axis
$c->xAxis()->setLabels($labels);

# Add a color bar layer using the given data. Use a 1 pixel 3D border for the bars.
$c->addBarLayer3($data)->setBorderColor(-1, 1);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

