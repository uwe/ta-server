#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# The data for the chart
my $data0 = [90, 60, 85, 75, 55];
my $data1 = [60, 80, 70, 80, 85];

# The labels for the chart
my $labels = ["Speed", "Reliability", "Comfort", "Safety", "Efficiency"];

# Create a PolarChart object of size 480 x 380 pixels. Set background color to gold,
# with 1 pixel 3D border effect
my $c = new PolarChart(480, 380, perlchartdir::goldColor(), 0x000000, 1);

# Add a title to the chart using 15 pts Times Bold Italic font. The title text is
# white (ffffff) on a deep blue (000080) background
$c->addTitle("Space Travel Vehicles Compared", "timesbi.ttf", 15, 0xffffff
    )->setBackground(0x000080);

# Set plot area center at (240, 210), with 150 pixels radius, and a white (ffffff)
# background.
$c->setPlotArea(240, 210, 150, 0xffffff);

# Add a legend box at top right corner (470, 35) using 10 pts Arial Bold font. Set
# the background to silver, with 1 pixel 3D border effect.
my $b = $c->addLegend(470, 35, 1, "arialbd.ttf", 10);
$b->setAlignment($perlchartdir::TopRight);
$b->setBackground(perlchartdir::silverColor(), $perlchartdir::Transparent, 1);

# Add an area layer to the chart using semi-transparent blue (0x806666cc). Add a blue
# (0x6666cc) line layer using the same data with 3 pixel line width to highlight the
# border of the area.
$c->addAreaLayer($data0, 0x806666cc, "Model Saturn");
$c->addLineLayer($data0, 0x6666cc)->setLineWidth(3);

# Add an area layer to the chart using semi-transparent red (0x80cc6666). Add a red
# (0xcc6666) line layer using the same data with 3 pixel line width to highlight the
# border of the area.
$c->addAreaLayer($data1, 0x80cc6666, "Model Jupiter");
$c->addLineLayer($data1, 0xcc6666)->setLineWidth(3);

# Set the labels to the angular axis as spokes.
$c->angularAxis()->setLabels($labels);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

