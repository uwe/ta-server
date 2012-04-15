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

# The labels for the bar chart
my $labels = ["Mon", "Tue", "Wed", "Thu", "Fri"];

# Create a XYChart object of size 500 x 320 pixels. Use a vertical gradient color
# from pale blue (e8f0f8) to sky blue (aaccff) spanning half the chart height as
# background. Set border to blue (88aaee). Use rounded corners. Enable soft drop
# shadow.
my $c = new XYChart(500, 320);
$c->setBackground($c->linearGradientColor(0, 0, 0, $c->getHeight() / 2, 0xe8f0f8,
    0xaaccff), 0x88aaee);
$c->setRoundedFrame();
$c->setDropShadow();

#Set directory for loading images to current script directory
#Need when running under Microsoft IIS
$c->setSearchPath(dirname($0));

# Add a title to the chart using 15 points Arial Italic. Set top/bottom margins to 15
# pixels.
my $title = $c->addTitle("Weekly Product Sales", "ariali.ttf", 15);
$title->setMargin2(0, 0, 15, 15);

# Tentatively set the plotarea to 50 pixels from the left edge, and to just under the
# title. Set the width to 60% of the chart width, and the height to 50 pixels from
# the bottom edge. Use pale blue (e8f0f8) background, transparent border, and grey
# (aaaaaa) grid lines.
$c->setPlotArea(50, $title->getHeight(), $c->getWidth() * 6 / 10, $c->getHeight() -
    $title->getHeight() - 50, 0xe8f0f8, -1, $perlchartdir::Transparent, 0xaaaaaa);

# Add a legend box where the top-right corner is anchored at 10 pixels from the right
# edge, and just under the title. Use vertical layout and 8 points Arial font.
my $legendBox = $c->addLegend($c->getWidth() - 10, $title->getHeight(), 1,
    "arial.ttf", 8);
$legendBox->setAlignment($perlchartdir::TopRight);

# Set the legend box background and border to transparent
$legendBox->setBackground($perlchartdir::Transparent, $perlchartdir::Transparent);

# Set the legend box icon size to 16 x 32 pixels to match with custom icon size
$legendBox->setKeySize(16, 32);

# Set axes to transparent
$c->xAxis()->setColors($perlchartdir::Transparent);
$c->yAxis()->setColors($perlchartdir::Transparent);

# Set the labels on the x axis
$c->xAxis()->setLabels($labels);

# Add a percentage bar layer
my $layer = $c->addBarLayer2($perlchartdir::Percentage);

# Add the three data sets to the bar layer, using icons images with labels as data
# set names
$layer->addDataSet($data0, 0x66aaee,
    "<*block,valign=absmiddle*><*img=service.png*> Service<*/*>");
$layer->addDataSet($data1, 0xeebb22,
    "<*block,valign=absmiddle*><*img=software.png*> Software<*/*>");
$layer->addDataSet($data2, 0xcc88ff,
    "<*block,valign=absmiddle*><*img=computer.png*> Hardware<*/*>");

# Use soft lighting effect with light direction from top
$layer->setBorderColor($perlchartdir::Transparent, perlchartdir::softLighting(
    $perlchartdir::Top));

# Enable data label at the middle of the the bar
$layer->setDataLabelStyle()->setAlignment($perlchartdir::Center);

# For a vertical stacked chart with positive data only, the last data set is always
# on top. However, in a vertical legend box, the last data set is at the bottom. This
# can be reversed by using the setLegend method.
$layer->setLegend($perlchartdir::ReverseLegend);

# Adjust the plot area size, such that the bounding box (inclusive of axes) is 15
# pixels from the left edge, just below the title, 10 pixels to the right of the
# legend box, and 15 pixels from the bottom edge.
$c->packPlotArea(15, $title->getHeight(), $c->layoutLegend()->getLeftX() - 10,
    $c->getHeight() - 15);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

