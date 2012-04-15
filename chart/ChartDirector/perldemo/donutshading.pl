#!/usr/bin/perl
use perlchartdir;

sub createChart
{
    my $img = shift;

    # The data for the pie chart
    my $data = [18, 30, 20, 15];

    # The colors to use for the sectors
    my $colors = [0x66aaee, 0xeebb22, 0xbbbbbb, 0x8844ff];

    # Create a PieChart object of size 200 x 220 pixels. Use a vertical gradient
    # color from blue (0000cc) to deep blue (000044) as background. Use rounded
    # corners of 16 pixels radius.
    my $c = new PieChart(200, 220);
    $c->setBackground($c->linearGradientColor(0, 0, 0, $c->getHeight(), 0x0000cc,
        0x000044));
    $c->setRoundedFrame(0xffffff, 16);

    # Set donut center at (100, 120), and outer/inner radii as 80/40 pixels
    $c->setDonutSize(100, 120, 80, 40);

    # Set the pie data
    $c->setData($data);

    # Set the sector colors
    $c->setColors2($perlchartdir::DataColor, $colors);

    # Demonstrates various shading modes
    if ($img eq "0") {
        $c->addTitle("Default Shading", "bold", 12, 0xffffff);
    } elsif ($img eq "1") {
        $c->addTitle("Local Gradient", "bold", 12, 0xffffff);
        $c->setSectorStyle($perlchartdir::LocalGradientShading);
    } elsif ($img eq "2") {
        $c->addTitle("Global Gradient", "bold", 12, 0xffffff);
        $c->setSectorStyle($perlchartdir::GlobalGradientShading);
    } elsif ($img eq "3") {
        $c->addTitle("Concave Shading", "bold", 12, 0xffffff);
        $c->setSectorStyle($perlchartdir::ConcaveShading);
    } elsif ($img eq "4") {
        $c->addTitle("Rounded Edge", "bold", 12, 0xffffff);
        $c->setSectorStyle($perlchartdir::RoundedEdgeShading);
    } elsif ($img eq "5") {
        $c->addTitle("Radial Gradient", "bold", 12, 0xffffff);
        $c->setSectorStyle($perlchartdir::RadialShading);
    } elsif ($img eq "6") {
        $c->addTitle("Ring Shading", "bold", 12, 0xffffff);
        $c->setSectorStyle($perlchartdir::RingShading);
    }

    # Disable the sector labels by setting the color to Transparent
    $c->setLabelStyle("", 8, $perlchartdir::Transparent);

    # Output the chart
    $c->makeChart("donutshading$img.png")
}

createChart(0);
createChart(1);
createChart(2);
createChart(3);
createChart(4);
createChart(5);
createChart(6);

