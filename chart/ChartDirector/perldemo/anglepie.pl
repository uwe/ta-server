#!/usr/bin/perl
use perlchartdir;

sub createChart
{
    my $img = shift;

    # Determine the starting angle and direction based on input parameter
    my $angle = 0;
    my $clockwise = 1;
    if ($img ne "0") {
        $angle = 90;
        $clockwise = 0;
    }

    # The data for the pie chart
    my $data = [25, 18, 15, 12, 8, 30, 35];

    # The labels for the pie chart
    my $labels = ["Labor", "Licenses", "Taxes", "Legal", "Insurance", "Facilities",
        "Production"];

    # Create a PieChart object of size 280 x 240 pixels
    my $c = new PieChart(280, 240);

    # Set the center of the pie at (140, 130) and the radius to 80 pixels
    $c->setPieSize(140, 130, 80);

    # Add a title to the pie to show the start angle and direction
    if ($clockwise) {
        $c->addTitle("Start Angle = $angle degrees\nDirection = Clockwise");
    } else {
        $c->addTitle("Start Angle = $angle degrees\nDirection = AntiClockwise");
    }

    # Set the pie start angle and direction
    $c->setStartAngle($angle, $clockwise);

    # Draw the pie in 3D
    $c->set3D();

    # Set the pie data and the pie labels
    $c->setData($data, $labels);

    # Explode the 1st sector (index = 0)
    $c->setExplode(0);

    # Output the chart
    $c->makeChart("anglepie$img.png")
}

createChart(0);
createChart(1);

