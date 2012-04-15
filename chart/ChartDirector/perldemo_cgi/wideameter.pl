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

# The value to display on the meter
my $value = 6.5;

# Create an AugularMeter object of size 200 x 100 pixels with rounded corners
my $m = new AngularMeter(200, 100);
$m->setRoundedFrame();

# Set meter background according to a parameter
if ($query->param("img") eq "0") {
    # Use gold background color
    $m->setBackground(perlchartdir::goldColor(), 0x000000, -2);
} elsif ($query->param("img") eq "1") {
    # Use silver background color
    $m->setBackground(perlchartdir::silverColor(), 0x000000, -2);
} elsif ($query->param("img") eq "2") {
    # Use metallic blue (9898E0) background color
    $m->setBackground(perlchartdir::metalColor(0x9898e0), 0x000000, -2);
} elsif ($query->param("img") eq "3") {
    # Use a wood pattern as background color
    $m->setBackground($m->patternColor2(dirname($0)."/wood.png"), 0x000000, -2);
} elsif ($query->param("img") eq "4") {
    # Use a marble pattern as background color
    $m->setBackground($m->patternColor2(dirname($0)."/marble.png"), 0x000000, -2);
} else {
    # Use a solid light purple (EEBBEE) background color
    $m->setBackground(0xeebbee, 0x000000, -2);
}

# Set the meter center at (100, 235), with radius 210 pixels, and span from -24 to
# +24 degress
$m->setMeter(100, 235, 210, -24, 24);

# Meter scale is 0 - 100, with a tick every 1 unit
$m->setScale(0, 10, 1);

# Set 0 - 6 as green (99ff99) zone, 6 - 8 as yellow (ffff00) zone, and 8 - 10 as red
# (ff3333) zone
$m->addZone(0, 6, 0x99ff99, 0x808080);
$m->addZone(6, 8, 0xffff00, 0x808080);
$m->addZone(8, 10, 0xff3333, 0x808080);

# Add a title at the bottom of the meter using 10 pts Arial Bold font
$m->addTitle2($perlchartdir::Bottom, "OUTPUT POWER LEVEL\n", "arialbd.ttf", 10);

# Add a semi-transparent black (80000000) pointer at the specified value
$m->addPointer($value, 0x80000000);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $m->makeChart2($perlchartdir::PNG);

