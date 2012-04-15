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

# Create a XYChart object of size 600 x 500 pixels
my $c = new XYChart(600, 500);

# Add a title to the chart using 15 points Arial Bold Italic font
$c->addTitle("z = x * sin(y) + y * sin(x)      ", "arialbi.ttf", 15);

# Set the plotarea at (75, 40) and of size 400 x 400 pixels. Use semi-transparent
# black (80000000) dotted lines for both horizontal and vertical grid lines
$c->setPlotArea(75, 40, 400, 400, -1, -1, -1, $c->dashLineColor(0x80000000,
    $perlchartdir::DotLine), -1);

# Set x-axis and y-axis title using 12 points Arial Bold Italic font
$c->xAxis()->setTitle("X-Axis Title Place Holder", "arialbi.ttf", 12);
$c->yAxis()->setTitle("Y-Axis Title Place Holder", "arialbi.ttf", 12);

# Set x-axis and y-axis labels to use Arial Bold font
$c->xAxis()->setLabelStyle("arialbd.ttf");
$c->yAxis()->setLabelStyle("arialbd.ttf");

# When auto-scaling, use tick spacing of 40 pixels as a guideline
$c->yAxis()->setTickDensity(40);
$c->xAxis()->setTickDensity(40);

# Add a contour layer using the given data
my $layer = $c->addContourLayer($dataX, $dataY, $dataZ);

# Move the grid lines in front of the contour layer
$c->getPlotArea()->moveGridBefore($layer);

# Add a color axis (the legend) in which the top left corner is anchored at (505,
# 40). Set the length to 400 pixels and the labels on the right side.
my $cAxis = $layer->setColorAxis(505, 40, $perlchartdir::TopLeft, 400,
    $perlchartdir::Right);

# Add a title to the color axis using 12 points Arial Bold Italic font
$cAxis->setTitle("Color Legend Title Place Holder", "arialbi.ttf", 12);

# Set color axis labels to use Arial Bold font
$cAxis->setLabelStyle("arialbd.ttf");

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

