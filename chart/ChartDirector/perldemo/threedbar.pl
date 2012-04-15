#!/usr/bin/perl
use perlchartdir;

# The data for the bar chart
my $data = [85, 156, 179.5, 211, 123];

# The labels for the bar chart
my $labels = ["Mon", "Tue", "Wed", "Thu", "Fri"];

# Create a XYChart object of size 300 x 280 pixels
my $c = new XYChart(300, 280);

# Set the plotarea at (45, 30) and of size 200 x 200 pixels
$c->setPlotArea(45, 30, 200, 200);

# Add a title to the chart
$c->addTitle("Weekly Server Load");

# Add a title to the y axis
$c->yAxis()->setTitle("MBytes");

# Add a title to the x axis
$c->xAxis()->setTitle("Work Week 25");

# Add a bar chart layer with green (0x00ff00) bars using the given data
$c->addBarLayer($data, 0x00ff00)->set3D();

# Set the labels on the x axis.
$c->xAxis()->setLabels($labels);

# Output the chart
$c->makeChart("threedbar.png")

