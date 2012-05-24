#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dump qw/pp/;
use DateTime;
use File::Slurp;


my $year = $ARGV[0] || 2012;

my $dir  = 'data/eurusd';
my $size = 60 * 60;


foreach my $file (sort glob "$dir/$year/*.tick") {
    $file =~ m|/(20\d\d)(\d\d)(\d\d).tick$|;
    my $date = DateTime->new(
        year  => $1,
        month => $2,
        day   => $3,
    );

    my $data = read_file($file);

    my $bar = {
        date => $date->iso8601,
    };

    my $start       = 0;
    my $data_offset = 0;
    while ($data_offset < length $data) {
        my $tick_data = substr($data, $data_offset, 12);

        my ($offset, $bid, $ask) = unpack('NNN', $tick_data);
        if ($offset > ($start + 1) * $size * 1000) {
            output_bar($bar);

            # skip empty bars
            my $diff = int($offset / ($size * 1000)) - $start;
            $date = $date->add(seconds => $diff * $size);
            $bar = {
                date => $date->iso8601,
            };

            $start = int($offset / ($size * 1000));
        }

        unless ($bar->{open}) {
            $bar->{open}  = $bid;
            $bar->{high}  = $ask;
            $bar->{low}   = $bid;
            $bar->{close} = $bid;
        }

        $bar->{high}  = $ask if $ask > $bar->{high};
        $bar->{low}   = $bid if $bid < $bar->{low};
        $bar->{close} = $bid;

        $data_offset += 12;
    }

    output_bar($bar);
}

sub output_bar {
    my ($bar) = @_;
    return unless $bar->{open};

    printf(
        "%s,%d,%d,%d,%d\n",
        $bar->{date},
        $bar->{open},
        $bar->{high},
        $bar->{low},
        $bar->{close},
    );
}

