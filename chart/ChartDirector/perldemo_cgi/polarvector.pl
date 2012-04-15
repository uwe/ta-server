#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# Coordinates of the starting points of the vectors
my $radius = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 10, 10, 10, 10, 10, 10, 10, 10, 10,
    10, 10, 10, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 20, 20, 20, 20, 20,
    20, 20, 20, 20, 20, 20, 20, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25];
my $angle = [0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330, 0, 30, 60, 90,
    120, 150, 180, 210, 240, 270, 300, 330, 0, 30, 60, 90, 120, 150, 180, 210, 240,
    270, 300, 330, 0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330, 0, 30, 60,
    90, 120, 150, 180, 210, 240, 270, 300, 330];

# Magnitude and direction of the vectors
my $magnitude = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
    4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
my $direction = [60, 90, 120, 150, 180, 210, 240, 270, 300, 330, 0, 30, 60, 90, 120,
    150, 180, 210, 240, 270, 300, 330, 0, 30, 60, 90, 120, 150, 180, 210, 240, 270,
    300, 330, 0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330, 0, 30, 60, 90,
    120, 150, 180, 210, 240, 270, 300, 330, 0, 30];

# Create a PolarChart object of size 460 x 460 pixels
my $c = new PolarChart(460, 460);

# Add a title to the chart at the top left corner using 15pts Arial Bold Italic font
$c->addTitle("Polar Vector Chart Demonstration", "arialbi.ttf", 15);

# Set center of plot area at (230, 240) with radius 180 pixels
$c->setPlotArea(230, 240, 180);

# Set the grid style to circular grid
$c->setGridStyle(0);

# Set angular axis as 0 - 360, with a spoke every 30 units
$c->angularAxis()->setLinearScale(0, 360, 30);

# Add a polar vector layer to the chart with blue (0000ff) vectors
$c->addVectorLayer($radius, $angle, $magnitude, $direction,
    $perlchartdir::RadialAxisScale, 0x0000ff);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

