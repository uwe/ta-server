#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# Get HTTP query parameters
use CGI;
my $query = new CGI;

# The data for the pie chart
my $data0 = [25, 18, 15];
my $data1 = [14, 32, 24];
my $data2 = [25, 23, 9];

# The labels for the pie chart
my $labels = ["Software", "Hardware", "Services"];

# Create a PieChart object of size 180 x 160 pixels
my $c = new PieChart(180, 160);

# Set the center of the pie at (90, 80) and the radius to 60 pixels
$c->setPieSize(90, 80, 60);

# Set the border color of the sectors to white (ffffff)
$c->setLineColor(0xffffff);

# Set the background color of the sector label to pale yellow (ffffc0) with a black
# border (000000)
$c->setLabelStyle()->setBackground(0xffffc0, 0x000000);

# Set the label to be slightly inside the perimeter of the circle
$c->setLabelLayout($perlchartdir::CircleLayout, -10);

# Set the title, data and colors according to which pie to draw
if ($query->param("img") eq "0") {
    $c->addTitle("Alpha Division", "arialbd.ttf", 8);
    $c->setData($data0, $labels);
    $c->setColors2($perlchartdir::DataColor, [0xff3333, 0xff9999, 0xffcccc]);
} elsif ($query->param("img") eq "1") {
    $c->addTitle("Beta Division", "arialbd.ttf", 8);
    $c->setData($data1, $labels);
    $c->setColors2($perlchartdir::DataColor, [0x33ff33, 0x99ff99, 0xccffcc]);
} else {
    $c->addTitle("Gamma Division", "arialbd.ttf", 8);
    $c->setData($data2, $labels);
    $c->setColors2($perlchartdir::DataColor, [0x3333ff, 0x9999ff, 0xccccff]);
}

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

