#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# The data for the chart
my $data0 = [6, 12.5, 18.2, 15];
my $angles0 = [45, 96, 169, 258];
my $size0 = [41, 105, 12, 20];

my $data1 = [18, 16, 11, 14];
my $angles1 = [30, 210, 240, 310];
my $size1 = [30, 45, 12, 90];

# Create a PolarChart object of size 460 x 460 pixels
my $c = new PolarChart(460, 460);

# Add a title to the chart at the top left corner using 15pts Arial Bold Italic font
$c->addTitle2($perlchartdir::TopLeft, "<*underline=2*>EM Field Strength",
    "arialbi.ttf", 15);

# Set center of plot area at (230, 240) with radius 180 pixels
$c->setPlotArea(230, 240, 180);

# Use alternative light grey/dark grey circular background color
$c->setPlotAreaBg(0xdddddd, 0xeeeeee);

# Set the grid style to circular grid
$c->setGridStyle(0);

# Add a legend box at the top right corner of the chart using 9 pts Arial Bold font
$c->addLegend(459, 0, 1, "arialbd.ttf", 9)->setAlignment($perlchartdir::TopRight);

# Set angular axis as 0 - 360, with a spoke every 30 units
$c->angularAxis()->setLinearScale(0, 360, 30);

# Set the radial axis label format
$c->radialAxis()->setLabelFormat("{value} km");

# Add a blue (0x9999ff) line layer to the chart using (data0, angle0)
my $layer0 = $c->addLineLayer($data0, 0x9999ff, "Cold Spot");
$layer0->setAngles($angles0);

# Disable the line by setting its width to 0, so only the symbols are visible
$layer0->setLineWidth(0);

# Use a circular data point symbol
$layer0->setDataSymbol($perlchartdir::CircleSymbol, 11);

# Modulate the symbol size by size0 to produce a bubble chart effect
$layer0->setSymbolScale($size0);

# Add a red (0xff9999) line layer to the chart using (data1, angle1)
my $layer1 = $c->addLineLayer($data1, 0xff9999, "Hot Spot");
$layer1->setAngles($angles1);

# Disable the line by setting its width to 0, so only the symbols are visible
$layer1->setLineWidth(0);

# Use a circular data point symbol
$layer1->setDataSymbol($perlchartdir::CircleSymbol, 11);

# Modulate the symbol size by size1 to produce a bubble chart effect
$layer1->setSymbolScale($size1);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

