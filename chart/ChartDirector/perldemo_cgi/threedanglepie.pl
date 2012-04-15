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
my $angle = int($query->param("img")) * 15;

# The data for the pie chart
my $data = [25, 18, 15, 12, 8, 30, 35];

# Create a PieChart object of size 100 x 110 pixels
my $c = new PieChart(100, 110);

# Set the center of the pie at (50, 55) and the radius to 38 pixels
$c->setPieSize(50, 55, 38);

# Set the depth and tilt angle of the 3D pie (-1 means auto depth)
$c->set3D(-1, $angle);

# Add a title showing the tilt angle
$c->addTitle("Tilt = $angle deg", "arial.ttf", 8);

# Set the pie data
$c->setData($data);

# Disable the sector labels by setting the color to Transparent
$c->setLabelStyle("", 8, $perlchartdir::Transparent);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

