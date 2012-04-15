#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# The data for the pyramid chart
my $data = [156, 123, 211, 179];

# The labels for the pyramid chart
my $labels = ["Funds", "Bonds", "Stocks", "Cash"];

# The semi-transparent colors for the pyramid layers
my $colors = [0x60000088, 0x6066aaee, 0x60ffbb00, 0x60ee6622];

# Create a PyramidChart object of size 480 x 400 pixels
my $c = new PyramidChart(480, 400);

# Set the cone center at (280, 180), and width x height to 150 x 300 pixels
$c->setConeSize(280, 180, 150, 300);

# Set the elevation to 15 degrees
$c->setViewAngle(15);

# Set the pyramid data and labels
$c->setData($data, $labels);

# Set the layer colors to the given colors
$c->setColors2($perlchartdir::DataColor, $colors);

# Leave 1% gaps between layers
$c->setLayerGap(0.01);

# Add labels at the left side of the pyramid layers using Arial Bold font. The labels
# will have 3 lines showing the layer name, value and percentage.
$c->setLeftLabel("{label}\nUS \${value}K\n({percent}%)", "arialbd.ttf");

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

