#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# The tasks for the gantt chart
my $labels = ["Market Research", "Define Specifications", "Overall Archiecture",
    "Project Planning", "Detail Design", "Software Development", "Test Plan",
    "Testing and QA", "User Documentation"];

# The task index, start date, end date and color for each bar
my $taskNo = [0, 0, 1, 2, 3, 4, 5, 6, 6, 7, 8, 8];
my $startDate = [perlchartdir::chartTime(2004, 8, 16), perlchartdir::chartTime(2004,
    10, 4), perlchartdir::chartTime(2004, 8, 30), perlchartdir::chartTime(2004, 9, 13
    ), perlchartdir::chartTime(2004, 9, 20), perlchartdir::chartTime(2004, 9, 27),
    perlchartdir::chartTime(2004, 10, 4), perlchartdir::chartTime(2004, 10, 4),
    perlchartdir::chartTime(2004, 10, 25), perlchartdir::chartTime(2004, 11, 1),
    perlchartdir::chartTime(2004, 10, 18), perlchartdir::chartTime(2004, 11, 8)];
my $endDate = [perlchartdir::chartTime(2004, 8, 30), perlchartdir::chartTime(2004,
    10, 18), perlchartdir::chartTime(2004, 9, 13), perlchartdir::chartTime(2004, 9,
    27), perlchartdir::chartTime(2004, 10, 4), perlchartdir::chartTime(2004, 10, 11),
    perlchartdir::chartTime(2004, 11, 8), perlchartdir::chartTime(2004, 10, 18),
    perlchartdir::chartTime(2004, 11, 8), perlchartdir::chartTime(2004, 11, 22),
    perlchartdir::chartTime(2004, 11, 1), perlchartdir::chartTime(2004, 11, 22)];
my $colors = [0x00cc00, 0x00cc00, 0x00cc00, 0x0000cc, 0x0000cc, 0xcc0000, 0xcc0000,
    0x0000cc, 0xcc0000, 0xcc0000, 0x00cc00, 0xcc0000];

# Create a XYChart object of size 620 x 325 pixels. Set background color to light red
# (0xffcccc), with 1 pixel 3D border effect.
my $c = new XYChart(620, 325, 0xffcccc, 0x000000, 1);

# Add a title to the chart using 15 points Times Bold Itatic font, with white
# (ffffff) text on a dark red (800000) background
$c->addTitle("Mutli-Color Gantt Chart Demo", "timesbi.ttf", 15, 0xffffff
    )->setBackground(0x800000);

# Set the plotarea at (140, 55) and of size 460 x 200 pixels. Use alternative
# white/grey background. Enable both horizontal and vertical grids by setting their
# colors to grey (c0c0c0). Set vertical major grid (represents month boundaries) 2
# pixels in width
$c->setPlotArea(140, 55, 460, 200, 0xffffff, 0xeeeeee, $perlchartdir::LineColor,
    0xc0c0c0, 0xc0c0c0)->setGridWidth(2, 1, 1, 1);

# swap the x and y axes to create a horziontal box-whisker chart
$c->swapXY();

# Set the y-axis scale to be date scale from Aug 16, 2004 to Nov 22, 2004, with ticks
# every 7 days (1 week)
$c->yAxis()->setDateScale(perlchartdir::chartTime(2004, 8, 16),
    perlchartdir::chartTime(2004, 11, 22), 86400 * 7);

# Set multi-style axis label formatting. Month labels are in Arial Bold font in "mmm
# d" format. Weekly labels just show the day of month and use minor tick (by using
# '-' as first character of format string).
$c->yAxis()->setMultiFormat(perlchartdir::StartOfMonthFilter(),
    "<*font=arialbd.ttf*>{value|mmm d}", perlchartdir::StartOfDayFilter(),
    "-{value|d}");

# Set the y-axis to shown on the top (right + swapXY = top)
$c->setYAxisOnRight();

# Set the labels on the x axis
$c->xAxis()->setLabels($labels);

# Reverse the x-axis scale so that it points downwards.
$c->xAxis()->setReverse();

# Set the horizontal ticks and grid lines to be between the bars
$c->xAxis()->setTickOffset(0.5);

# Add some symbols to the chart to represent milestones. The symbols are added using
# scatter layers. We need to specify the task index, date, name, symbol shape, size
# and color.
$c->addScatterLayer([1], [perlchartdir::chartTime(2004, 9, 13)], "Milestone 1",
    perlchartdir::Cross2Shape(), 13, 0xffff00);
$c->addScatterLayer([3], [perlchartdir::chartTime(2004, 10, 4)], "Milestone 2",
    perlchartdir::StarShape(5), 15, 0xff00ff);
$c->addScatterLayer([5], [perlchartdir::chartTime(2004, 11, 8)], "Milestone 3",
    $perlchartdir::TriangleSymbol, 13, 0xff9933);

# Add a multi-color box-whisker layer to represent the gantt bars
my $layer = $c->addBoxWhiskerLayer2($startDate, $endDate, undef, undef, undef,
    $colors);
$layer->setXData($taskNo);
$layer->setBorderColor($perlchartdir::SameAsMainColor);

# Divide the plot area height ( = 200 in this chart) by the number of tasks to get
# the height of each slot. Use 80% of that as the bar height.
$layer->setDataWidth(int(200 * 4 / 5 / scalar(@$labels)));

# Add a legend box at (140, 265) - bottom of the plot area. Use 8 pts Arial Bold as
# the font with auto-grid layout. Set the width to the same width as the plot area.
# Set the backgorund to grey (dddddd).
my $legendBox = $c->addLegend2(140, 265, $perlchartdir::AutoGrid, "arialbd.ttf", 8);
$legendBox->setWidth(461);
$legendBox->setBackground(0xdddddd);

# The keys for the scatter layers (milestone symbols) will automatically be added to
# the legend box. We just need to add keys to show the meanings of the bar colors.
$legendBox->addKey("Market Team", 0x00cc00);
$legendBox->addKey("Planning Team", 0x0000cc);
$legendBox->addKey("Development Team", 0xcc0000);

# Output the chart
binmode(STDOUT);
print "Content-type: image/png\n\n";
print $c->makeChart2($perlchartdir::PNG);

