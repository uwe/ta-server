#!/usr/bin/perl

use strict;
use warnings;

use lib 'lib';
use FinanceChart;
use TA::Server;


my $ta = TA::Server->new;


my $data = $ta->get_quotes($ARGV[0] || 'GOOG');

my @data = splice(@$data, - ($ARGV[1] || 100));

add_aussenstab(@data);

my $chart = new FinanceChart(1200);
$chart->addTitle("Finance Chart Demonstration");
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
$chart->addLineIndicator2($main, [ map { $_->{inout_high} } @data ], 0x888888, 'InOut High');
$chart->addLineIndicator2($main, [ map { $_->{inout_low}  } @data ], 0x888888, 'InOut Low');
$chart->makeChart("out.png");


sub add_aussenstab {
    my @data = @_;

    my $aussenstab;
    my $last;
    foreach my $day (@data) {
        if ($aussenstab) {
            unless (check_innenstab($aussenstab, $day)) {
                $aussenstab = undef;
            }
        }
        else {
            if ($last and check_innenstab($last, $day)) {
                $aussenstab = $last;
                $last->{inout_high} = $last->{high};
                $last->{inout_low}  = $last->{low}; 
            }
        }

        $day->{inout_high} ||= $perlchartdir::NoValue;
        $day->{inout_low}  ||= $perlchartdir::NoValue;

        $last = $day;
    }
}

sub check_innenstab {
    my ($aussen, $innen) = @_;
    
    if ($innen->{open}  < $aussen->{high} and $innen->{open}  > $aussen->{low} and
        $innen->{close} < $aussen->{high} and $innen->{close} > $aussen->{low}) {
        $innen->{inout_high} = $aussen->{high};
        $innen->{inout_low}  = $aussen->{low};
        return 1;
    }

    return;
}

