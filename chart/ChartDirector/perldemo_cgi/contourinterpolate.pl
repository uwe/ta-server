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
my $dataX = [-4, -3, -2, -1, 0, 1, 2, 3, 4];
my $dataY = [-4, -3, -2, -1, 0, 1, 2, 3, 4];

# The values at the grid points. In this example, we will compute the values using
# the formula z = Sin(x * pi / 3) * Sin(y * pi / 3).
my $dataZ = [(0) x (scalar(@$dataX) * scalar(@$dataY))];
for(my $yIndex = 0; $yIndex < scalar(@$dataY); ++$yIndex) {
    my $y = $dataY->[$yIndex];
    for(my $xIndex = 0; $xIndex < scalar(@$dataX); ++$xIndex) {
        my $x = $dataX->[$xIndex];
        $dataZ->[$yIndex * scalar(@$dataX) + $xIndex] = sin($x * 3.1416 / 3) * sin($y
             * 3.1416 / 3);
    }
}

# Create a XYChart object of size 360 x 360 pixels
my $c = new XYChart(360, 360);

# Set the plotarea at (30, 25) and of size 300 x 300 pixels. Use semi-transparent
# black (c0000000) for both horizontal and vertical grid lines
$c->setPlotArea(30, 25, 300, 300, -1, -1, -1, 0xc0000000, -1);

# Add a contour layer using the given data
my $layer = $c->addContourLayer($dataX, $dataY, $dataZ);

# Set the x-axis and y-axis scale
$c->xAxis()->setLinearScale(-4, 4, 1);
$c->yAxis()->setLinearScale(-4, 4, 1);

if ($query->param("img") eq "0") {
    # Discrete coloring, spline surface interpolation
    $c->addTitle("Spline Surface - Discrete Coloring", "arialbi.ttf", 12);
} elsif ($query->param("img") eq "1") {
    # Discrete coloring, linear surface interpolation
    $c->addTitle("Linear Surface - Discrete Coloring", "arialbi.ttf", 12);
    $layer->setSmoothInterpolation(0);
} elsif ($query->param("img") eq "2") {
    # Smooth coloring, spline surface interpolation
    $c->addTitle("Spline Surface - Continuous Coloring", "arialbi.ttf", 12);
    $layer->setContourColor($perlchartdir::Transparent);
    $layer->colorAxis()->setColorGradient(1);
} else {
    # Discrete coloring, linear surface interpolation
    $c->addTitle("Linear Surface - Continuous Coloring", "arialbi.ttf", 12);
    $layer->setSmoothInterpolation(0);
    $layer->setContourColor($perlchartdir::Transparent);
    $layer->colorAxis()->setColorGradient(1);
}

# Output the chart
binmode(STDOUT);
print "Content-type: image/jpeg\n\n";
print $c->makeChart2($perlchartdir::JPG);

