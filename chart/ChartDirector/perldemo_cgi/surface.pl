#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# The x and y coordinates of the grid
my $dataX = [-10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
    10];
my $dataY = [-10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
    10];

# The values at the grid points. In this example, we will compute the values using
# the formula z = x * sin(y) + y * sin(x).
my $dataZ = [(0) x (scalar(@$dataX) * scalar(@$dataY))];
for(my $yIndex = 0; $yIndex < scalar(@$dataY); ++$yIndex) {
    my $y = $dataY->[$yIndex];
    for(my $xIndex = 0; $xIndex < scalar(@$dataX); ++$xIndex) {
        my $x = $dataX->[$xIndex];
        $dataZ->[$yIndex * scalar(@$dataX) + $xIndex] = $x * sin($y) + $y * sin($x);
    }
}

# Create a SurfaceChart object of size 720 x 600 pixels
my $c = new SurfaceChart(720, 600);

# Add a title to the chart using 20 points Times New Roman Italic font
$c->addTitle("Surface Energy Density   ", "timesi.ttf", 20);

# Set the center of the plot region at (350, 280), and set width x depth x height to
# 360 x 360 x 270 pixels
$c->setPlotRegion(350, 280, 360, 360, 270);

# Set the data to use to plot the chart
$c->setData($dataX, $dataY, $dataZ);

# Spline interpolate data to a 80 x 80 grid for a smooth surface
$c->setInterpolation(80, 80);

# Add a color axis (the legend) in which the left center is anchored at (645, 270).
# Set the length to 200 pixels and the labels on the right side.
$c->setColorAxis(645, 270, $perlchartdir::Left, 200, $perlchartdir::Right);

# Set the x, y and z axis titles using 10 points Arial Bold font
$c->xAxis()->setTitle("X (nm)", "arialbd.ttf", 10);
$c->yAxis()->setTitle("Y (nm)", "arialbd.ttf", 10);
$c->zAxis()->setTitle("Energy Density (J/m<*font,super*>2<*/font*>)", "arialbd.ttf",
    10);

# Output the chart
binmode(STDOUT);
print "Content-type: image/jpeg\n\n";
print $c->makeChart2($perlchartdir::JPG);

