#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# The data for the bar chart
my $data0 = [100, 125, 245, 147, 67];
my $data1 = [85, 156, 179, 211, 123];
my $data2 = [97, 87, 56, 267, 157];
my $labels = ["Mon", "Tue", "Wed", "Thur", "Fri"];

# Create a XYChart object of size 540 x 375 pixels
my $c = new XYChart(540, 375);

# Add a title to the chart using 18 pts Times Bold Italic font
$c->addTitle("Average Weekly Network Load", "timesbi.ttf", 18);

# Set the plotarea at (50, 55) and of 440 x 280 pixels in size. Use a vertical
# gradient color from light blue (f9f9ff) to blue (6666ff) as background. Set border
# and grid lines to white (ffffff).
$c->setPlotArea(50, 55, 440, 280, $c->linearGradientColor(0, 55, 0, 335, 0xf9f9ff,
    0x6666ff), -1, 0xffffff, 0xffffff);

# Add a legend box at (50, 28) using horizontal layout. Use 10pts Arial Bold as font,
# with transparent background.
$c->addLegend(50, 28, 0, "arialbd.ttf", 10)->setBackground($perlchartdir::Transparent
    );

# Set the x axis labels
$c->xAxis()->setLabels($labels);

# Draw the ticks between label positions (instead of at label positions)
$c->xAxis()->setTickOffset(0.5);

# Set axis label style to 8pts Arial Bold
$c->xAxis()->setLabelStyle("arialbd.ttf", 8);
$c->yAxis()->setLabelStyle("arialbd.ttf", 8);

# Set axis line width to 2 pixels
$c->xAxis()->setWidth(2);
$c->yAxis()->setWidth(2);

# Add axis title
$c->yAxis()->setTitle("Throughput (MBytes Per Hour)");

# Add a multi-bar layer with 3 data sets
my $layer = $c->addBarLayer2($perlchartdir::Side);
$layer->addDataSet($data0, 0xff0000, "Server #1");
$layer->addDataSet($data1, 0x00ff00, "Server #2");
$layer->addDataSet($data2, 0xff8800, "Server #3");

# Set bar border to transparent. Use glass lighting effect with light direction from
# left.
$layer->setBorderColor($perlchartdir::Transparent, perlchartdir::glassEffect(
    $perlchartdir::NormalGlare, $perlchartdir::Left));

# Configure the bars within a group to touch each others (no gap)
$layer->setBarGap(0.2, $perlchartdir::TouchBar);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

