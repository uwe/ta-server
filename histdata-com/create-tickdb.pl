#!/usr/bin/env perl

use strict;
use warnings;

use DateTime;
use File::Slurp;

my $CUT_OFF = 17_00_00_000;

my $out_dir = 'data';

my @last = ();

my $out = '';
foreach my $line (<>) {
    chomp $line;
    my @data = split /,/, $line;
    $data[0] =~ s/ //;
    $data[1] =~ s/\.//;
    $data[2] =~ s/\.//;
    # bid/ask swapped?
    ($data[1], $data[2]) = ($data[2], $data[1]) if $data[1] > $data[2];

    if (@last) {
        # ignore out of time order ticks
        next if $data[0] < $last[0];

        # new day?
        if (substr($last[0], 8) <= $CUT_OFF and
            substr($data[0], 8) >  $CUT_OFF) {
            # save old data
            save_ticks(\$out, $data[0]);
            $out = '';
        }
    }

    my $offset = substr($data[0], 8);
    if ($offset > $CUT_OFF) {
        $offset -= $CUT_OFF;
    } else {
        $offset += 24_00_00_000 - $CUT_OFF;
    }
    # pad with zeros
    $offset = '0' x (9 - length $offset) . $offset;
    unless ($offset =~ /^(\d\d)(\d\d)(\d\d)(\d\d\d)$/) {
        die "INVALID timestamp: $offset ($line)";
    }
    my $hour   = int $1;
    my $minute = int $2;
    my $second = int $3;
    my $milli  = int $4;
    $offset = $hour * 3600_000 + $minute * 60_000 + $second * 1_000 + $milli;

    $out .= pack(
        'NNN',
        $offset,
        $data[1],
        $data[2],
    );

    @last = @data;
}
save_ticks(\$out, $last[0]);

sub save_ticks {
    my ($buffer, $timestamp) = @_;
    my $file = $out_dir . '/' . substr($timestamp, 0, 8) . '.tick';
    write_file($file, $buffer);
}

