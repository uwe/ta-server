#!/usr/bin/perl
use perlchartdir;

sub createChart
{
    my $img = shift;

    # The data for the pyramid chart
    my $data = [156, 123, 211, 179];

    # The semi-transparent colors for the pyramid layers
    my $colors = [0x400000cc, 0x4066aaee, 0x40ffbb00, 0x40ee6622];

    # The rotation angle
    my $angle = int($img) * 15;

    # Create a PyramidChart object of size 200 x 200 pixels, with white (ffffff)
    # background and grey (888888) border
    my $c = new PyramidChart(200, 200, 0xffffff, 0x888888);

    # Set the pyramid center at (100, 100), and width x height to 60 x 120 pixels
    $c->setPyramidSize(100, 100, 60, 120);

    # Set the elevation to 15 degrees and use the given rotation angle
    $c->addTitle("Rotation = $angle", "ariali.ttf", 15);
    $c->setViewAngle(15, $angle);

    # Set the pyramid data
    $c->setData($data);

    # Set the layer colors to the given colors
    $c->setColors2($perlchartdir::DataColor, $colors);

    # Leave 1% gaps between layers
    $c->setLayerGap(0.01);

    # Output the chart
    $c->makeChart("pyramidrotation$img.png")
}

createChart(0);
createChart(1);
createChart(2);
createChart(3);
createChart(4);
createChart(5);
createChart(6);

