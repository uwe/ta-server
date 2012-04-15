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

# Create a PieChart object of size 450 x 270 pixels
my $c = new PieChart(450, 270);

# Set the center of the pie at (150, 100) and the radius to 80 pixels
$c->setPieSize(150, 135, 100);

# add a legend box where the top left corner is at (330, 50)
$c->addLegend(330, 60);

# modify the sector label format to show percentages only
$c->setLabelFormat("{percent}%");

# Set the pie data and the pie labels
$c->setData($data, $labels);

# Use rounded edge shading, with a 1 pixel white (FFFFFF) border
$c->setSectorStyle($perlchartdir::RoundedEdgeShading, 0xffffff, 1);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

