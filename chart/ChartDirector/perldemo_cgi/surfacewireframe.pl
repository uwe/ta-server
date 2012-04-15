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
my $dataX = [-2, -1, 0, 1, 2];
my $dataY = [-2, -1, 0, 1, 2];

# The values at the grid points. In this example, we will compute the values using
# the formula z = square_root(15 - x * x - y * y).
my $dataZ = [(0) x (scalar(@$dataX) * scalar(@$dataY))];
for(my $yIndex = 0; $yIndex < scalar(@$dataY); ++$yIndex) {
    my $y = $dataY->[$yIndex];
    for(my $xIndex = 0; $xIndex < scalar(@$dataX); ++$xIndex) {
        my $x = $dataX->[$xIndex];
        $dataZ->[$yIndex * scalar(@$dataX) + $xIndex] = sqrt(15 - $x * $x - $y * $y);
    }
}

# Create a SurfaceChart object of size 380 x 340 pixels, with white (ffffff)
# background and grey (888888) border.
my $c = new SurfaceChart(380, 340, 0xffffff, 0x888888);

# Demonstrate various wireframes with and without interpolation
if ($query->param("img") eq "0") {
    # Original data without interpolation
    $c->addTitle("5 x 5 Data Points\nStandard Shading", "arialbd.ttf", 12);
    $c->setContourColor(0x80ffffff);
} elsif ($query->param("img") eq "1") {
    # Original data, spline interpolated to 40 x 40 for smoothness
    $c->addTitle("5 x 5 Points - Spline Fitted to 40 x 40\nStandard Shading",
        "arialbd.ttf", 12);
    $c->setContourColor(0x80ffffff);
    $c->setInterpolation(40, 40);
} elsif ($query->param("img") eq "2") {
    # Rectangular wireframe of original data
    $c->addTitle("5 x 5 Data Points\nRectangular Wireframe");
    $c->setShadingMode($perlchartdir::RectangularFrame);
} elsif ($query->param("img") eq "3") {
    # Rectangular wireframe of original data spline interpolated to 40 x 40
    $c->addTitle("5 x 5 Points - Spline Fitted to 40 x 40\nRectangular Wireframe");
    $c->setShadingMode($perlchartdir::RectangularFrame);
    $c->setInterpolation(40, 40);
} elsif ($query->param("img") eq "4") {
    # Triangular wireframe of original data
    $c->addTitle("5 x 5 Data Points\nTriangular Wireframe");
    $c->setShadingMode($perlchartdir::TriangularFrame);
} else {
    # Triangular wireframe of original data spline interpolated to 40 x 40
    $c->addTitle("5 x 5 Points - Spline Fitted to 40 x 40\nTriangular Wireframe");
    $c->setShadingMode($perlchartdir::TriangularFrame);
    $c->setInterpolation(40, 40);
}

# Set the center of the plot region at (200, 170), and set width x depth x height to
# 200 x 200 x 150 pixels
$c->setPlotRegion(200, 170, 200, 200, 150);

# Set the plot region wall thichness to 5 pixels
$c->setWallThickness(5);

# Set the elevation and rotation angles to 20 and 30 degrees
$c->setViewAngle(20, 30);

# Set the data to use to plot the chart
$c->setData($dataX, $dataY, $dataZ);

# Output the chart
binmode(STDOUT);
print "Content-type: image/jpeg\n\n";
print $c->makeChart2($perlchartdir::JPG);

