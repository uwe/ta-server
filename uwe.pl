#!/usr/bin/perl

use strict;
use warnings;

use lib 'lib';
use FinanceChart;
use TA::Server;


my $symbol = $ARGV[0] || 'GOOG';
my $days   = $ARGV[1] || 100;


my $ta = TA::Server->new;

my $data = $ta->get_quotes($symbol);

my @data = splice(@$data, -$days);

add_inout_bars(@data);

my $chart = new FinanceChart(1200);
$chart->addTitle($symbol);
$chart->setData(
    [ map { perlchartdir::chartTime(split /[- :]/, $_->{date}) } @data ],
    [ map { $_->{high}   } @data ],
    [ map { $_->{low}    } @data ],
    [ map { $_->{open}   } @data ],
    [ map { $_->{close}  } @data ],
    [ map { $_->{volume} } @data ],
    0,
);

my $main = $chart->addMainChart(800);
$chart->addHLOC(0x008000, 0xcc0000)->setLineWidth(2);
$chart->addLineIndicator2($main, [ map { $_->{inout_high_0} } @data ], 0x888888, 'InOut High');
$chart->addLineIndicator2($main, [ map { $_->{inout_low_0}  } @data ], 0x888888, 'InOut Low');
$chart->addLineIndicator2($main, [ map { $_->{inout_high_1} } @data ], 0x888888, 'InOut High');
$chart->addLineIndicator2($main, [ map { $_->{inout_low_1}  } @data ], 0x888888, 'InOut Low');
$chart->makeChart("out.png");


sub add_inout_bars {
    my @data = @_;

    my $index = 0;
    my $inout;
    my $last;
    foreach my $day (@data) {
        if ($inout) {
            unless (check_inbar($inout, $day, $index)) {
                # draw breakout
                $day->{"inout_high_$index"} = $inout->{high};
                $day->{"inout_low_$index"}  = $inout->{low};

                $inout = undef;
                $index = 1 - $index;
            }
        }
        else {
            if ($last and check_inbar($last, $day, $index)) {
                $inout = $last;
                $last->{"inout_high_$index"} = $last->{high};
                $last->{"inout_low_$index"}  = $last->{low}; 
            }
        }

        $day->{inout_high_0} ||= $perlchartdir::NoValue;
        $day->{inout_high_1} ||= $perlchartdir::NoValue;
        $day->{inout_low_0}  ||= $perlchartdir::NoValue;
        $day->{inout_low_1}  ||= $perlchartdir::NoValue;

        $last = $day;
    }
}

sub check_inbar {
    my ($out, $in, $index) = @_;
    
    if ($in->{open}  < $out->{high} and $in->{open}  > $out->{low} and
        $in->{close} < $out->{high} and $in->{close} > $out->{low}) {
        $in->{"inout_high_$index"} = $out->{high};
        $in->{"inout_low_$index"}  = $out->{low};
        return 1;
    }

    return;
}

