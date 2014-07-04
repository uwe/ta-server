#!/usr/bin/env perl

use strict;
use warnings;

use File::Slurp;

my $out_dir = 'data';

my $last;
my $last_date;

my $out = '';
foreach my $line (<>) {
    chomp $line;
    my @data = split /,/, $line;
    my ($date, $time) = split / /, $data[0];
    $data[0] =~ s/ //;
    $data[1] =~ s/\.//;
    $data[2] =~ s/\.//;
    # bid/ask swapped?
    ($data[1], $data[2]) = ($data[2], $data[1]) if $data[1] > $data[2];

    if ($last) {
        # ignore out of time order ticks
        next if $data[0] < $last;

        # new day?
        if ($last_date < $date) {
            # save old data
            save_ticks(\$out, $last_date);
            $out = '';
        }
    }

    unless ($time =~ /^(\d\d)(\d\d)(\d\d)(\d\d\d)$/) {
        die "INVALID timestamp: $time ($line)";
    }
    my $hour   = int $1;
    my $minute = int $2;
    my $second = int $3;
    my $milli  = int $4;
    my $offset = $hour * 3600_000 + $minute * 60_000 + $second * 1_000 + $milli;

    $out .= pack(
        'NNN',
        $offset,
        $data[1],
        $data[2],
    );

    $last      = $data[0];
    $last_date = $date;
}
save_ticks(\$out, $last_date) if $out;

sub save_ticks {
    my ($buffer, $date) = @_;
    my $file = $out_dir . '/' . $date . '.tick';
    warn $file;
    write_file($file, $buffer);
}

