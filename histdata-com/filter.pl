#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;
use File::Slurp;


my $file = $ARGV[0] or die "Usage: $0 file.csv";

my @lines = read_file($file, chomp => 1);

my @last   = ();
my @bad    = ();
my %diff   = ();
my %spread = ();

my $i = 0;
while ($i < @lines) {
    my @data = split /,/, $lines[$i++];
    $data[0] =~ s/ //;
    $data[1] =~ s/\.//;
    $data[2] =~ s/\.//;

    $spread{$data[2] - $data[1]}++;

    if (@last) {
        $diff{abs($last[1] - $data[1])}++;

        if ($data[0] < $last[0]) {
            push @bad, $i - 1;
            #print "Wrong timeline:\n";
            #my $j = $i - 4;
            #$j = 0 if $j < 0;
           #print "$lines[$_]\n" for ($j .. $j + 6);
           #print "\n";
        }
    }
    @last = @data;
}

foreach my $diff (sort { $a <=> $b } keys %diff) {
    printf("%5d %d\n", $diff, $diff{$diff});
}

warn Dumper \%spread;
warn Dumper \@bad;

