#!/usr/bin/perl
use perlchartdir;

sub createChart
{
    my $img = shift;

    # The data for the chart
    my $data = [85, 156, 179.5, 211, 123];
    my $labels = ["Mon", "Tue", "Wed", "Thu", "Fri"];

    # Create a XYChart object of size 270 x 270 pixels
    my $c = new XYChart(270, 270);

    # Set the plot area at (40, 32) and of size 200 x 200 pixels
    my $plotarea = $c->setPlotArea(40, 32, 200, 200);

    # Set the background style based on the input parameter
    if ($img eq "0") {
        # Has wallpaper image
        $c->setWallpaper("tile.gif");
    } elsif ($img eq "1") {
        # Use a background image as the plot area background
        $plotarea->setBackground2("bg.png");
    } elsif ($img eq "2") {
        # Use white (0xffffff) and grey (0xe0e0e0) as two alternate plotarea
        # background colors
        $plotarea->setBackground(0xffffff, 0xe0e0e0);
    } else {
        # Use a dark background palette
        $c->setColors($perlchartdir::whiteOnBlackPalette);
    }

    # Set the labels on the x axis
    $c->xAxis()->setLabels($labels);

    # Add a color bar layer using the given data. Use a 1 pixel 3D border for the
    # bars.
    $c->addBarLayer3($data)->setBorderColor(-1, 1);

    # Output the chart
    $c->makeChart("background$img.png")
}

createChart(0);
createChart(1);
createChart(2);
createChart(3);

