#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# Some ChartDirector built-in symbols
my $symbols = [$perlchartdir::CircleShape, $perlchartdir::GlassSphereShape,
    $perlchartdir::GlassSphere2Shape, $perlchartdir::SolidSphereShape,
    $perlchartdir::SquareShape, $perlchartdir::DiamondShape,
    $perlchartdir::TriangleShape, $perlchartdir::RightTriangleShape,
    $perlchartdir::LeftTriangleShape, $perlchartdir::InvertedTriangleShape,
    perlchartdir::StarShape(3), perlchartdir::StarShape(4), perlchartdir::StarShape(5
    ), perlchartdir::StarShape(6), perlchartdir::StarShape(7),
    perlchartdir::StarShape(8), perlchartdir::StarShape(9), perlchartdir::StarShape(
    10), perlchartdir::PolygonShape(5), perlchartdir::Polygon2Shape(5),
    perlchartdir::PolygonShape(6), perlchartdir::Polygon2Shape(6),
    perlchartdir::CrossShape(0.1), perlchartdir::CrossShape(0.2),
    perlchartdir::CrossShape(0.3), perlchartdir::CrossShape(0.4),
    perlchartdir::CrossShape(0.5), perlchartdir::CrossShape(0.6),
    perlchartdir::CrossShape(0.7), perlchartdir::Cross2Shape(0.1),
    perlchartdir::Cross2Shape(0.2), perlchartdir::Cross2Shape(0.3),
    perlchartdir::Cross2Shape(0.4), perlchartdir::Cross2Shape(0.5),
    perlchartdir::Cross2Shape(0.6), perlchartdir::Cross2Shape(0.7)];

# Create a XYChart object of size 450 x 400 pixels
my $c = new XYChart(450, 400);

# Set the plotarea at (55, 40) and of size 350 x 300 pixels, with a light grey border
# (0xc0c0c0). Turn on both horizontal and vertical grid lines with light grey color
# (0xc0c0c0)
$c->setPlotArea(55, 40, 350, 300, -1, -1, 0xc0c0c0, 0xc0c0c0, -1);

# Add a title to the chart using 18 pts Times Bold Itatic font.
$c->addTitle("Built-in Symbols", "timesbi.ttf", 18);

# Set the axes line width to 3 pixels
$c->xAxis()->setWidth(3);
$c->yAxis()->setWidth(3);

# Ensure the ticks are at least 1 unit part (integer ticks)
$c->xAxis()->setMinTickInc(1);
$c->yAxis()->setMinTickInc(1);

# Add each symbol as a separate scatter layer.
for(my $i = 0; $i < scalar(@$symbols); ++$i) {
    $c->addScatterLayer([$i % 6 + 1], [int($i / 6 + 1)], "", $symbols->[$i], 15);
}

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

