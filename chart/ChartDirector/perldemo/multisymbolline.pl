#!/usr/bin/perl
use perlchartdir;

# In this example, the data points are unevenly spaced on the x-axis
my $dataY = [4.7, 4.7, 6.6, 2.2, 4.7, 4.0, 4.0, 5.1, 4.5, 4.5, 6.8, 4.5, 4, 2.1, 3,
    2.5, 2.5, 3.1];
my $dataX = [perlchartdir::chartTime(1999, 7, 1), perlchartdir::chartTime(2000, 1, 1
    ), perlchartdir::chartTime(2000, 2, 1), perlchartdir::chartTime(2000, 4, 1),
    perlchartdir::chartTime(2000, 5, 8), perlchartdir::chartTime(2000, 7, 5),
    perlchartdir::chartTime(2001, 3, 5), perlchartdir::chartTime(2001, 4, 7),
    perlchartdir::chartTime(2001, 5, 9), perlchartdir::chartTime(2002, 2, 4),
    perlchartdir::chartTime(2002, 4, 4), perlchartdir::chartTime(2002, 5, 8),
    perlchartdir::chartTime(2002, 7, 7), perlchartdir::chartTime(2002, 8, 30),
    perlchartdir::chartTime(2003, 1, 2), perlchartdir::chartTime(2003, 2, 16),
    perlchartdir::chartTime(2003, 11, 6), perlchartdir::chartTime(2004, 1, 4)];

# Data points are assigned different symbols based on point type
my $pointType = [0, 1, 0, 1, 2, 1, 0, 0, 1, 1, 2, 2, 1, 0, 2, 1, 2, 0];

# Create a XYChart object of size 480 x 320 pixels. Use a vertical gradient color
# from pale blue (e8f0f8) to sky blue (aaccff) spanning half the chart height as
# background. Set border to blue (88aaee). Use rounded corners. Enable soft drop
# shadow.
my $c = new XYChart(480, 320);
$c->setBackground($c->linearGradientColor(0, 0, 0, $c->getHeight() / 2, 0xe8f0f8,
    0xaaccff), 0x88aaee);
$c->setRoundedFrame();
$c->setDropShadow();

# Add a title to the chart using 15 points Arial Italic font. Set top/bottom margins
# to 12 pixels.
my $title = $c->addTitle("Multi-Symbol Line Chart Demo", "ariali.ttf", 15);
$title->setMargin2(0, 0, 12, 12);

# Tentatively set the plotarea to 50 pixels from the left edge to allow for the
# y-axis, and to just under the title. Set the width to 65 pixels less than the chart
# width, and the height to reserve 90 pixels at the bottom for the x-axis and the
# legend box. Use pale blue (e8f0f8) background, transparent border, and grey
# (888888) dotted horizontal and vertical grid lines.
$c->setPlotArea(50, $title->getHeight(), $c->getWidth() - 65, $c->getHeight() -
    $title->getHeight() - 90, 0xe8f0f8, -1, $perlchartdir::Transparent,
    $c->dashLineColor(0x888888, $perlchartdir::DotLine), -1);

# Add a legend box where the bottom-center is anchored to the 12 pixels above the
# bottom-center of the chart. Use horizontal layout and 8 points Arial font.
my $legendBox = $c->addLegend($c->getWidth() / 2, $c->getHeight() - 12, 0,
    "arialbd.ttf", 8);
$legendBox->setAlignment($perlchartdir::BottomCenter);

# Set the legend box background and border to pale blue (e8f0f8) and bluish grey
# (445566)
$legendBox->setBackground(0xe8f0f8, 0x445566);

# Use rounded corners of 5 pixel radius for the legend box
$legendBox->setRoundedCorners(5);

# Set the y axis label format to display a percentage sign
$c->yAxis()->setLabelFormat("{value}%");

# Set y-axis title to use 10 points Arial Bold Italic font
$c->yAxis()->setTitle("Axis Title Placeholder", "arialbi.ttf", 10);

# Set axis labels to use Arial Bold font
$c->yAxis()->setLabelStyle("arialbd.ttf");
$c->xAxis()->setLabelStyle("arialbd.ttf");

# We add the different data symbols using scatter layers. The scatter layers are
# added before the line layer to make sure the data symbols stay on top of the line
# layer.

# We select the points with pointType = 0 (the non-selected points will be set to
# NoValue), and use yellow (ffff00) 15 pixels high 5 pointed star shape symbols for
# the points. (This example uses both x and y coordinates. For charts that have no x
# explicitly coordinates, use an empty array as dataX.)
$c->addScatterLayer($dataX, new ArrayMath($dataY)->selectEQZ($pointType,
    $perlchartdir::NoValue)->result(), "Point Type 0", perlchartdir::StarShape(5),
    15, 0xffff00);

# Similar to above, we select the points with pointType - 1 = 0 and use green (ff00)
# 13 pixels high six-sided polygon as symbols.
$c->addScatterLayer($dataX, new ArrayMath($dataY)->selectEQZ(new ArrayMath($pointType
    )->sub(1)->result(), $perlchartdir::NoValue)->result(), "Point Type 1",
    perlchartdir::PolygonShape(6), 13, 0x00ff00);

# Similar to above, we select the points with pointType - 2 = 0 and use red (ff0000)
# 13 pixels high X shape as symbols.
$c->addScatterLayer($dataX, new ArrayMath($dataY)->selectEQZ(new ArrayMath($pointType
    )->sub(2)->result(), $perlchartdir::NoValue)->result(), "Point Type 2",
    perlchartdir::Cross2Shape(), 13, 0xff0000);

# Finally, add a blue (0000ff) line layer with line width of 2 pixels
my $layer = $c->addLineLayer($dataY, 0x0000ff);
$layer->setXData($dataX);
$layer->setLineWidth(2);

# Adjust the plot area size, such that the bounding box (inclusive of axes) is 10
# pixels from the left edge, just below the title, 25 pixels from the right edge, and
# 8 pixels above the legend box.
$c->packPlotArea(10, $title->getHeight(), $c->getWidth() - 25, $c->layoutLegend(
    )->getTopY() - 8);

# Output the chart
$c->makeChart("multisymbolline.png")

