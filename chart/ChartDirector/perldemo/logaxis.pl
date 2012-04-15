#!/usr/bin/perl
use perlchartdir;

sub createChart
{
    my $img = shift;

    # The data for the chart
    my $data = [100, 125, 260, 147, 67];
    my $labels = ["Mon", "Tue", "Wed", "Thu", "Fri"];

    # Create a XYChart object of size 200 x 180 pixels
    my $c = new XYChart(200, 180);

    # Set the plot area at (30, 10) and of size 140 x 130 pixels
    $c->setPlotArea(30, 10, 140, 130);

    # Ise log scale axis if required
    if ($img eq "1") {
        $c->yAxis()->setLogScale3();
    }

    # Set the labels on the x axis
    $c->xAxis()->setLabels($labels);

    # Add a color bar layer using the given data. Use a 1 pixel 3D border for the
    # bars.
    $c->addBarLayer3($data)->setBorderColor(-1, 1);

    # Output the chart
    $c->makeChart("logaxis$img.png")
}

createChart(0);
createChart(1);

