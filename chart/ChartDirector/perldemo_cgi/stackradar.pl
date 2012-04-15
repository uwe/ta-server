#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# The data for the chart
my $data0 = [100, 100, 100, 100, 100];
my $data1 = [90, 85, 85, 80, 70];
my $data2 = [80, 65, 65, 75, 45];

# The labels for the chart
my $labels = ["Population<*br*><*font=arial.ttf*>6 millions",
    "GDP<*br*><*font=arial.ttf*>120 billions",
    "Export<*br*><*font=arial.ttf*>25 billions",
    "Import<*br*><*font=arial.ttf*>24 billions",
    "Investments<*br*><*font=arial.ttf*>20 billions"];

# Create a PolarChart object of size 480 x 460 pixels. Set background color to
# silver, with 1 pixel 3D border effect
my $c = new PolarChart(480, 460, perlchartdir::silverColor(), 0x000000, 1);

# Add a title to the chart using 15 pts Times Bold Italic font. The title text is
# white (ffffff) on a deep green (008000) background
$c->addTitle("Economic Growth", "timesbi.ttf", 15, 0xffffff)->setBackground(0x008000)
    ;

# Set plot area center at (240, 270), with 150 pixels radius
$c->setPlotArea(240, 270, 150);

# Use 1 pixel width semi-transparent black (c0000000) lines as grid lines
$c->setGridColor(0xc0000000, 1, 0xc0000000, 1);

# Add a legend box at top-center of plot area (240, 35) using horizontal layout. Use
# 10 pts Arial Bold font, with silver background and 1 pixel 3D border effect.
my $b = $c->addLegend(240, 35, 0, "arialbd.ttf", 10);
$b->setAlignment($perlchartdir::TopCenter);
$b->setBackground(perlchartdir::silverColor(), $perlchartdir::Transparent, 1);

# Add area layers of different colors to represent the data
$c->addAreaLayer($data0, 0xcc8880, "Year 2004");
$c->addAreaLayer($data1, 0xffd080, "Year 1994");
$c->addAreaLayer($data2, 0xa0bce0, "Year 1984");

# Set the labels to the angular axis as spokes.
$c->angularAxis()->setLabels($labels);

# Set radial axis from 0 - 100 with a tick every 20 units
$c->radialAxis()->setLinearScale(0, 100, 20);

# Just show the radial axis as a grid line. Hide the axis labels by setting the label
# color to Transparent
$c->radialAxis()->setColors(0xc0000000, $perlchartdir::Transparent);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

