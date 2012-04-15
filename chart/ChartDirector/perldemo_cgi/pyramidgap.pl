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

# The data for the pyramid chart
my $data = [156, 123, 211, 179];

# The colors for the pyramid layers
my $colors = [0x66aaee, 0xeebb22, 0xcccccc, 0xcc88ff];

# The layer gap
my $gap = int($query->param("img")) * 0.01;

# Create a PyramidChart object of size 200 x 200 pixels, with white (ffffff)
# background and grey (888888) border
my $c = new PyramidChart(200, 200, 0xffffff, 0x888888);

# Set the pyramid center at (100, 100), and width x height to 60 x 120 pixels
$c->setPyramidSize(100, 100, 60, 120);

# Set the layer gap
$c->addTitle("Gap = $gap", "ariali.ttf", 15);
$c->setLayerGap($gap);

# Set the elevation to 15 degrees
$c->setViewAngle(15);

# Set the pyramid data
$c->setData($data);

# Set the layer colors to the given colors
$c->setColors2($perlchartdir::DataColor, $colors);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

