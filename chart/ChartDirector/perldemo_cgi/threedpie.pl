#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# The data for the pie chart
my $data = [25, 18, 15, 12, 8, 30, 35];

# The labels for the pie chart
my $labels = ["Labor", "Licenses", "Taxes", "Legal", "Insurance", "Facilities",
    "Production"];

# Create a PieChart object of size 360 x 300 pixels
my $c = new PieChart(360, 300);

# Set the center of the pie at (180, 140) and the radius to 100 pixels
$c->setPieSize(180, 140, 100);

# Add a title to the pie chart
$c->addTitle("Project Cost Breakdown");

# Draw the pie in 3D
$c->set3D();

# Set the pie data and the pie labels
$c->setData($data, $labels);

# Explode the 1st sector (index = 0)
$c->setExplode(0);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

