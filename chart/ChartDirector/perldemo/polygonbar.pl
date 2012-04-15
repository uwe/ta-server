#!/usr/bin/perl
use perlchartdir;

# The data for the bar chart
my $data = [85, 156, 179.5, 211, 123, 176, 195];

# The labels for the bar chart
my $labels = ["Square", "Star(8)", "Polygon(6)", "Cross", "Cross2", "Diamond",
    "Custom"];

# Create a XYChart object of size 500 x 280 pixels.
my $c = new XYChart(500, 280);

# Set the plotarea at (50, 40) with alternating light grey (f8f8f8) / white (ffffff)
# background
$c->setPlotArea(50, 40, 400, 200, 0xf8f8f8, 0xffffff);

# Add a title to the chart using 14 pts Arial Bold Italic font
$c->addTitle("    Bar Shape Demonstration", "arialbi.ttf", 14);

# Add a multi-color bar chart layer
my $layer = $c->addBarLayer3($data);

# Set layer to 3D with 10 pixels 3D depth
$layer->set3D(10);

# Set bar shape to circular (cylinder)
$layer->setBarShape($perlchartdir::CircleShape);

# Set the first bar (index = 0) to square shape
$layer->setBarShape($perlchartdir::SquareShape, 0, 0);

# Set the second bar to 8-pointed star
$layer->setBarShape(perlchartdir::StarShape(8), 0, 1);

# Set the third bar to 6-sided polygon
$layer->setBarShape(perlchartdir::PolygonShape(6), 0, 2);

# Set the next 3 bars to cross shape, X shape and diamond shape
$layer->setBarShape(perlchartdir::CrossShape(), 0, 3);
$layer->setBarShape(perlchartdir::Cross2Shape(), 0, 4);
$layer->setBarShape($perlchartdir::DiamondShape, 0, 5);

# Set the last bar to a custom shape, specified as an array of (x, y) points in
# normalized coordinates
$layer->setBarShape2([-500, 0, 0, 500, 500, 0, 500, 1000, 0, 500, -500, 1000], 0, 6);

# Set the labels on the x axis.
$c->xAxis()->setLabels($labels);

# Add a title to the y axis
$c->yAxis()->setTitle("Frequency");

# Add a title to the x axis
$c->xAxis()->setTitle("Shapes");

# Output the chart
$c->makeChart("polygonbar.png")

