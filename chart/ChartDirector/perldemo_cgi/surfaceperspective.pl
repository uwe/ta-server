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

# The x and y coordinates of the grid
my $dataX = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
my $dataY = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];

# The values at the grid points. In this example, we will compute the values using
# the formula z = sin((x - 0.5) * 2 * pi) * sin((y - 0.5) * 2 * pi)
my $dataZ = [(0) x (scalar(@$dataX) * scalar(@$dataY))];
for(my $yIndex = 0; $yIndex < scalar(@$dataY); ++$yIndex) {
    my $y = ($dataY->[$yIndex] - 0.5) * 2 * 3.1416;
    for(my $xIndex = 0; $xIndex < scalar(@$dataX); ++$xIndex) {
        my $x = ($dataX->[$xIndex] - 0.5) * 2 * 3.1416;
        $dataZ->[$yIndex * scalar(@$dataX) + $xIndex] = sin($x) * sin($y);
    }
}

# the perspective level
my $perspective = int($query->param("img")) * 12;

# Create a SurfaceChart object of size 360 x 360 pixels, with white (ffffff)
# background and grey (888888) border.
my $c = new SurfaceChart(360, 360, 0xffffff, 0x888888);

# Set the perspective level
$c->setPerspective($perspective);
$c->addTitle("Perspective = $perspective");

# Set the center of the plot region at (195, 165), and set width x depth x height to
# 200 x 200 x 150 pixels
$c->setPlotRegion(195, 165, 200, 200, 150);

# Set the plot region wall thichness to 5 pixels
$c->setWallThickness(5);

# Set the elevation and rotation angles to 30 and 30 degrees
$c->setViewAngle(30, 30);

# Set the data to use to plot the chart
$c->setData($dataX, $dataY, $dataZ);

# Spline interpolate data to a 40 x 40 grid for a smooth surface
$c->setInterpolation(40, 40);

# Use smooth gradient coloring.
$c->colorAxis()->setColorGradient();

# Output the chart
binmode(STDOUT);
print "Content-type: image/jpeg\n\n";
print $c->makeChart2($perlchartdir::JPG);

