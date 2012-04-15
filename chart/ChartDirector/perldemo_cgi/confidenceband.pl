#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# The XY data of the first data series
my $dataX = [50, 55, 37, 24, 42, 49, 63, 72, 83, 59];
my $dataY = [3.6, 2.8, 2.5, 2.3, 3.8, 3.0, 3.8, 5.0, 6.0, 3.3];

# Create a XYChart object of size 450 x 420 pixels
my $c = new XYChart(450, 420);

# Set the plotarea at (55, 65) and of size 350 x 300 pixels, with white background
# and a light grey border (0xc0c0c0). Turn on both horizontal and vertical grid lines
# with light grey color (0xc0c0c0)
$c->setPlotArea(55, 65, 350, 300, 0xffffff, -1, 0xc0c0c0, 0xc0c0c0, -1);

# Add a title to the chart using 18 point Times Bold Itatic font.
$c->addTitle("Server Performance", "timesbi.ttf", 18);

# Add titles to the axes using 12 pts Arial Bold Italic font
$c->yAxis()->setTitle("Response Time (sec)", "arialbi.ttf", 12);
$c->xAxis()->setTitle("Server Load (TPS)", "arialbi.ttf", 12);

# Set the axes line width to 3 pixels
$c->yAxis()->setWidth(3);
$c->xAxis()->setWidth(3);

# Add a scatter layer using (dataX, dataY)
$c->addScatterLayer($dataX, $dataY, "", $perlchartdir::DiamondSymbol, 11, 0x008000);

# Add a trend line layer for (dataX, dataY)
my $trendLayer = $c->addTrendLayer2($dataX, $dataY, 0x008000);

# Set the line width to 3 pixels
$trendLayer->setLineWidth(3);

# Add a 95% confidence band for the line
$trendLayer->addConfidenceBand(0.95, 0x806666ff);

# Add a 95% confidence band (prediction band) for the points
$trendLayer->addPredictionBand(0.95, 0x8066ff66);

# Add a legend box at (50, 30) (top of the chart) with horizontal layout. Use 10 pts
# Arial Bold Italic font. Set the background and border color to Transparent.
my $legendBox = $c->addLegend(50, 30, 0, "arialbi.ttf", 10);
$legendBox->setBackground($perlchartdir::Transparent);

# Add entries to the legend box
$legendBox->addKey("95% Line Confidence", 0x806666ff);
$legendBox->addKey("95% Point Confidence", 0x8066ff66);

# Display the trend line parameters as a text table formatted using CDML
my $textbox = $c->addText(56, 65, sprintf(
    "<*block*>Slope\nIntercept\nCorrelation\nStd Error<*/*>   <*block*>%.4f ".
    "sec/tps\n%.4f sec\n%.4f\n%.4f sec<*/*>", $trendLayer->getSlope(),
    $trendLayer->getIntercept(), $trendLayer->getCorrelation(),
    $trendLayer->getStdError()), "arialbd.ttf", 8);

# Set the background of the text box to light grey, with a black border, and 1 pixel
# 3D border
$textbox->setBackground(0xc0c0c0, 0, 1);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

