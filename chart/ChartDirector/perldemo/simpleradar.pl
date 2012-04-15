#!/usr/bin/perl
use perlchartdir;

# The data for the chart
my $data = [90, 60, 65, 75, 40];

# The labels for the chart
my $labels = ["Speed", "Reliability", "Comfort", "Safety", "Efficiency"];

# Create a PolarChart object of size 450 x 350 pixels
my $c = new PolarChart(450, 350);

# Set center of plot area at (225, 185) with radius 150 pixels
$c->setPlotArea(225, 185, 150);

# Add an area layer to the polar chart
$c->addAreaLayer($data, 0x9999ff);

# Set the labels to the angular axis as spokes
$c->angularAxis()->setLabels($labels);

# Output the chart
$c->makeChart("simpleradar.png")

