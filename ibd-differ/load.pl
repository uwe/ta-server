#!/usr/bin/env perl

use strict;
use warnings;

my $file  = $ARGV[0] || 'IBD_50_20120219.txt';

my $stocks = load_ibd($file);
print join(', ', @$stocks) . "\n";


sub load_ibd {
    my ($file) = @_;

    my @stocks = ();

    my $skip = 1;
    open(my $fh, '<', $file) or die $!;
    while (my $line = <$fh>) {
        if ($skip) {
            $skip = 0 if $line =~ /^------/;
        } else {
            last if $line =~ /^Screen results /;
            if ($line =~ /^([A-Z]{1,4})  /) {
                push @stocks, $1;
            } else {
                warn 'Unknown line: ' . substr($line, 0, 30);
            }
        }
    }

    return \@stocks;
}

