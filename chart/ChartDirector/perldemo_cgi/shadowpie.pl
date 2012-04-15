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

# the tilt angle of the pie
my $angle = int($query->param("img")) * 90 + 45;

# The data for the pie chart
my $data = [25, 18, 15, 12, 8, 30, 35];

# Create a PieChart object of size 100 x 110 pixels
my $c = new PieChart(100, 110);

# Set the center of the pie at (50, 55) and the radius to 36 pixels
$c->setPieSize(50, 55, 36);

# Set the depth, tilt angle and 3D mode of the 3D pie (-1 means auto depth, "true"
# means the 3D effect is in shadow mode)
$c->set3D(-1, $angle, 1);

# Add a title showing the shadow angle
$c->addTitle("Shadow @ $angle deg", "arial.ttf", 8);

# Set the pie data
$c->setData($data);

# Disable the sector labels by setting the color to Transparent
$c->setLabelStyle("", 8, $perlchartdir::Transparent);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

