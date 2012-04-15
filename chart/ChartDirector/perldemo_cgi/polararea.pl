#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# Data for the chart
my $data0 = [5, 3, 10, 4, 3, 5, 2, 5];
my $data1 = [12, 6, 17, 6, 7, 9, 4, 7];
my $data2 = [17, 7, 22, 7, 18, 13, 5, 11];

my $labels = ["North", "North<*br*>East", "East", "South<*br*>East", "South",
    "South<*br*>West", "West", "North<*br*>West"];

# Create a PolarChart object of size 460 x 500 pixels, with a grey (e0e0e0)
# background and 1 pixel 3D border
my $c = new PolarChart(460, 500, 0xe0e0e0, 0x000000, 1);

# Add a title to the chart at the top left corner using 15pts Arial Bold Italic font.
# Use a wood pattern as the title background.
$c->addTitle("Polar Area Chart Demo", "arialbi.ttf", 15)->setBackground(
    $c->patternColor(dirname($0)."/wood.png"));

# Set center of plot area at (230, 280) with radius 180 pixels, and white (ffffff)
# background.
$c->setPlotArea(230, 280, 180, 0xffffff);

# Set the grid style to circular grid
$c->setGridStyle(0);

# Add a legend box at top-center of plot area (230, 35) using horizontal layout. Use
# 10 pts Arial Bold font, with 1 pixel 3D border effect.
my $b = $c->addLegend(230, 35, 0, "arialbd.ttf", 9);
$b->setAlignment($perlchartdir::TopCenter);
$b->setBackground($perlchartdir::Transparent, $perlchartdir::Transparent, 1);

# Set angular axis using the given labels
$c->angularAxis()->setLabels($labels);

# Specify the label format for the radial axis
$c->radialAxis()->setLabelFormat("{value}%");

# Set radial axis label background to semi-transparent grey (40cccccc)
$c->radialAxis()->setLabelStyle()->setBackground(0x40cccccc, 0);

# Add the data as area layers
$c->addAreaLayer($data2, -1, "5 m/s or above");
$c->addAreaLayer($data1, -1, "1 - 5 m/s");
$c->addAreaLayer($data0, -1, "less than 1 m/s");

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

