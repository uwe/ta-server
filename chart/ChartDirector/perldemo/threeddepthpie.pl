#!/usr/bin/perl
use perlchartdir;

sub createChart
{
    my $img = shift;

    # the tilt angle of the pie
    my $depth = int($img) * 5 + 5;

    # The data for the pie chart
    my $data = [25, 18, 15, 12, 8, 30, 35];

    # Create a PieChart object of size 100 x 110 pixels
    my $c = new PieChart(100, 110);

    # Set the center of the pie at (50, 55) and the radius to 38 pixels
    $c->setPieSize(50, 55, 38);

    # Set the depth of the 3D pie
    $c->set3D($depth);

    # Add a title showing the depth
    $c->addTitle("Depth = $depth pixels", "arial.ttf", 8);

    # Set the pie data
    $c->setData($data);

    # Disable the sector labels by setting the color to Transparent
    $c->setLabelStyle("", 8, $perlchartdir::Transparent);

    # Output the chart
    $c->makeChart("threeddepthpie$img.png")
}

createChart(0);
createChart(1);
createChart(2);
createChart(3);
createChart(4);

