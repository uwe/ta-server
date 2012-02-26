#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';
use TA::Server;


my $ta = TA::Server->new;


my $data = $ta->get_quotes('GOOG');

my $first = shift @$data;
my $state = {
    all_time_high => $first->{high},
    all_high_date => $first->{date},
    all_time_low  => $first->{low},
    all_low_date  => $first->{date},
    last          => $first,
};

foreach my $day (@$data) {
    # new high?
    if ($day->{high} > $state->{all_time_high}) {
        warn "New all time high on $day->{date}: $day->{high} vs. $state->{all_time_high}";
        $state->{all_time_high} = $day->{high};
        $state->{all_high_date} = $day->{date};
    }

    # new low?
    if ($day->{low} < $state->{all_time_low}) {
        warn "New all time low on $day->{date}: $day->{low} vs. $state->{all_time_low}";
        $state->{all_time_low} = $day->{low};
        $state->{all_low_date} = $day->{date};
    }

    $state->{last} = $day;
}

