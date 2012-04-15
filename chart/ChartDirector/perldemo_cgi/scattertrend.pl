#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# The XY data of the first data series
my $dataX0 = [50, 55, 37, 24, 42, 49, 63, 72, 83, 59];
my $dataY0 = [3.6, 2.8, 2.5, 2.3, 3.8, 3.0, 3.8, 5.0, 6.0, 3.3];

# The XY data of the second data series
my $dataX1 = [50, 55, 37, 24, 42, 49, 63, 72, 83, 59];
my $dataY1 = [1.6, 1.8, 0.8, 0.5, 1.3, 1.5, 2.3, 2.4, 2.9, 1.5];

# Create a XYChart object of size 450 x 420 pixels
my $c = new XYChart(450, 420);

# Set the plotarea at (55, 65) and of size 350 x 300 pixels, with white background
# and a light grey border (0xc0c0c0). Turn on both horizontal and vertical grid lines
# with light grey color (0xc0c0c0)
$c->setPlotArea(55, 65, 350, 300, 0xffffff, -1, 0xc0c0c0, 0xc0c0c0, -1);

# Add a legend box at (50, 30) (top of the chart) with horizontal layout. Use 12 pts
# Times Bold Italic font. Set the background and border color to Transparent.
$c->addLegend(50, 30, 0, "timesbi.ttf", 12)->setBackground($perlchartdir::Transparent
    );

# Add a title to the chart using 18 point Times Bold Itatic font.
$c->addTitle("Server Performance", "timesbi.ttf", 18);

# Add titles to the axes using 12 pts Arial Bold Italic font
$c->yAxis()->setTitle("Response Time (sec)", "arialbi.ttf", 12);
$c->xAxis()->setTitle("Server Load (TPS)", "arialbi.ttf", 12);

# Set the axes line width to 3 pixels
$c->yAxis()->setWidth(3);
$c->xAxis()->setWidth(3);

# Add a scatter layer using (dataX0, dataY0)
$c->addScatterLayer($dataX0, $dataY0, "Server AAA", $perlchartdir::DiamondSymbol, 11,
    0x008000);

# Add a trend line layer for (dataX0, dataY0)
$c->addTrendLayer2($dataX0, $dataY0, 0x008000)->setLineWidth(3);

# Add a scatter layer for (dataX1, dataY1)
$c->addScatterLayer($dataX1, $dataY1, "Server BBB", $perlchartdir::TriangleSymbol, 9,
    0x6666ff);

# Add a trend line layer for (dataX1, dataY1)
$c->addTrendLayer2($dataX1, $dataY1, 0x6666ff)->setLineWidth(3);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

