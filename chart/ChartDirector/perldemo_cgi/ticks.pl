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
my $data = [100, 125, 265, 147, 67, 105];
my $labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"];

# Create a XYChart object of size 250 x 250 pixels
my $c = new XYChart(250, 250);

# Set the plot area at (27, 25) and of size 200 x 200 pixels
$c->setPlotArea(27, 25, 200, 200);

if ($query->param("img") eq "1") {
    # High tick density, uses 10 pixels as tick spacing
    $c->addTitle("Tick Density = 10 pixels");
    $c->yAxis()->setTickDensity(10);
} else {
    # Normal tick density, just use the default setting
    $c->addTitle("Default Tick Density");
}

# Set the labels on the x axis
$c->xAxis()->setLabels($labels);

# Add a color bar layer using the given data. Use a 1 pixel 3D border for the bars.
$c->addBarLayer3($data)->setBorderColor(-1, 1);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

