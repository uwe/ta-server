#!/usr/bin/perl
use perlchartdir;

# The data for the chart
my $data = [51, 15, 51, 40, 17, 87, 94, 21, 35, 88, 50, 60];

# The labels for the chart
my $labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct",
    "Nov", "Dec"];

# Create a PolarChart object of size 400 x 420 pixels
my $c = new PolarChart(400, 420);

# Set background color to a 2 pixel pattern color, with a black border and 1 pixel 3D
# border effect
$c->setBackground($c->patternColor([0xffffff, 0xe0e0e0], 2), 0, 1);

# Add a title to the chart using 16 pts Arial Bold Italic font. The title text is
# white (0xffffff) on 2 pixel pattern background
$c->addTitle("Chemical Concentration", "arialbi.ttf", 16, 0xffffff)->setBackground(
    $c->patternColor([0x000000, 0x000080], 2));

# Set center of plot area at (200, 240) with radius 145 pixels. Set background color
# to blue (9999ff)
$c->setPlotArea(200, 240, 145, 0x9999ff);

# Color the region between radius = 40 to 80 as green (99ff99)
$c->radialAxis()->addZone(40, 80, 0x99ff99);

# Color the region with radius > 80 as red (ff9999)
$c->radialAxis()->addZone(80, 999, 0xff9999);

# Set the grid style to circular grid
$c->setGridStyle(0);

# Set the radial axis label format
$c->radialAxis()->setLabelFormat("{value} ppm");

# Use semi-transparent (40ffffff) label background so as not to block the data
$c->radialAxis()->setLabelStyle()->setBackground(0x40ffffff, 0x40000000);

# Add a legend box at (200, 30) top center aligned, using 9 pts Arial Bold font. with
# a black border.
my $legendBox = $c->addLegend(200, 30, 0, "arialbd.ttf", 9);
$legendBox->setAlignment($perlchartdir::TopCenter);

# Add legend keys to represent the red/green/blue zones
$legendBox->addKey("Under-Absorp", 0x9999ff);
$legendBox->addKey("Normal", 0x99ff99);
$legendBox->addKey("Over-Absorp", 0xff9999);

# Add a blue (000080) spline line layer with line width set to 3 pixels and using
# yellow (ffff00) circles to represent the data points
my $layer = $c->addSplineLineLayer($data, 0x000080);
$layer->setLineWidth(3);
$layer->setDataSymbol($perlchartdir::CircleShape, 11, 0xffff00);

# Set the labels to the angular axis as spokes.
$c->angularAxis()->setLabels($labels);

# Output the chart
$c->makeChart("polarzones.png")

