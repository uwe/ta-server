#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# The data for the pie chart
my $data = [35, 30, 25, 7, 6, 5, 4, 3, 2, 1];

# The labels for the pie chart
my $labels = ["Labor", "Production", "Facilities", "Taxes", "Misc", "Legal",
    "Insurance", "Licenses", "Transport", "Interest"];

# Create a PieChart object of size 560 x 270 pixels, with a golden background and a 1
# pixel 3D border
my $c = new PieChart(560, 270, perlchartdir::goldColor(), -1, 1);

# Add a title box using 15 pts Times Bold Italic font and metallic pink background
# color
$c->addTitle("Project Cost Breakdown", "timesbi.ttf", 15)->setBackground(
    perlchartdir::metalColor(0xff9999));

# Set the center of the pie at (280, 135) and the radius to 110 pixels
$c->setPieSize(280, 135, 110);

# Draw the pie in 3D with 20 pixels 3D depth
$c->set3D(20);

# Use the side label layout method
$c->setLabelLayout($perlchartdir::SideLayout);

# Set the label box background color the same as the sector color, with glass effect,
# and with 5 pixels rounded corners
my $t = $c->setLabelStyle();
$t->setBackground($perlchartdir::SameAsMainColor, $perlchartdir::Transparent,
    perlchartdir::glassEffect());
$t->setRoundedCorners(5);

# Set the border color of the sector the same color as the fill color. Set the line
# color of the join line to black (0x0)
$c->setLineColor($perlchartdir::SameAsMainColor, 0x000000);

# Set the start angle to 135 degrees may improve layout when there are many small
# sectors at the end of the data array (that is, data sorted in descending order). It
# is because this makes the small sectors position near the horizontal axis, where
# the text label has the least tendency to overlap. For data sorted in ascending
# order, a start angle of 45 degrees can be used instead.
$c->setStartAngle(135);

# Set the pie data and the pie labels
$c->setData($data, $labels);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

