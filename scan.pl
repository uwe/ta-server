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
    my $last = $state->{last};

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

    # innenstab?
    if ($state->{aussenstab}) {
        if (check_innenstab($state->{aussenstab}, $day)) {
            warn "Innenstab on $day->{date}.";
        } else {
            warn "Breakout";
            delete $state->{aussenstab};
        }
    }
    else {
        # aussenstab?
        if (check_innenstab($last, $day)) {
            warn "Aussenstab on $last->{date}: $last->{low} - $last->{high} vs. $day->{open} / $day->{close}";
            $state->{aussenstab} = $last;
        }
    }

    $state->{last} = $day;
}

sub check_innenstab {
    my ($aussen, $innen) = @_;

    if ($innen->{open}  < $aussen->{high} and $innen->{open}  > $aussen->{low} and
        $innen->{close} < $aussen->{high} and $innen->{close} > $aussen->{low}) {
        warn "   $aussen->{low} - $aussen->{high} vs. $innen->{open} / $innen->{close}";
        return 1;
    }
    return;
}

