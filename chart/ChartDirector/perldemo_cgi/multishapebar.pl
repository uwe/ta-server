#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# The data for the bar chart
my $data0 = [100, 125, 245, 147];
my $data1 = [85, 156, 179, 211];
my $data2 = [97, 87, 56, 267];
my $labels = ["1st Quarter", "2nd Quarter", "3rd Quarter", "4th Quarter"];

# Create a XYChart object of size 600 x 350 pixels
my $c = new XYChart(600, 350);

# Add a title to the chart using 14 pts Arial Bold Italic font
$c->addTitle("Annual Product Revenue", "arialbi.ttf", 14);

# Set the plot area at (50, 60) and of size 500 x 240. Use two alternative background
# colors (f8f8f8 and ffffff)
$c->setPlotArea(50, 60, 500, 240, 0xf8f8f8, 0xffffff);

# Add a legend box at (55, 22) using horizontal layout, with transparent background
$c->addLegend(55, 22, 0)->setBackground($perlchartdir::Transparent);

# Set the x axis labels
$c->xAxis()->setLabels($labels);

# Draw the ticks between label positions (instead of at label positions)
$c->xAxis()->setTickOffset(0.5);

# Add a multi-bar layer with 3 data sets and 9 pixels 3D depth
my $layer = $c->addBarLayer2($perlchartdir::Side, 9);
$layer->addDataSet($data0, -1, "Product A");
$layer->addDataSet($data1, -1, "Product B");
$layer->addDataSet($data2, -1, "Product C");

# Set data set 1 to use a bar shape of a 6-pointed star
$layer->setBarShape(perlchartdir::StarShape(6), 0);

# Set data set 2 to use a bar shapre of a 6-sided polygon
$layer->setBarShape(perlchartdir::PolygonShape(6), 1);

# Set data set 3 to use an X bar shape
$layer->setBarShape(perlchartdir::Cross2Shape(), 2);

# Add a title to the y-axis
$c->yAxis()->setTitle("Revenue (USD in millions)");

# Add a title to the x axis
$c->xAxis()->setTitle("Year 2005");

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

