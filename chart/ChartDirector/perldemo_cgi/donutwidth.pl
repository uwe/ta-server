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

# Determine the donut inner radius (as percentage of outer radius) based on input
# parameter
my $donutRadius = int($query->param("img")) * 25;

# The data for the pie chart
my $data = [10, 10, 10, 10, 10];

# The labels for the pie chart
my $labels = ["Marble", "Wood", "Granite", "Plastic", "Metal"];

# Create a PieChart object of size 150 x 120 pixels, with a grey (EEEEEE) background,
# black border and 1 pixel 3D border effect
my $c = new PieChart(150, 120, 0xeeeeee, 0x000000, 1);

# Set donut center at (75, 65) and the outer radius to 50 pixels. Inner radius is
# computed according donutWidth
$c->setDonutSize(75, 60, 50, int(50 * $donutRadius / 100));

# Add a title to show the donut width
$c->addTitle("Inner Radius = $donutRadius %", "Arial", 10)->setBackground(0xcccccc, 0
    );

# Draw the pie in 3D
$c->set3D(12);

# Set the pie data and the pie labels
$c->setData($data, $labels);

# Disable the sector labels by setting the color to Transparent
$c->setLabelStyle("", 8, $perlchartdir::Transparent);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

