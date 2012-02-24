#!/usr/bin/env perl

use strict;
use warnings;


my @files  = sort @ARGV;
my @stocks = map { load_ibd($_) } @files;

my $name1   = shift @files;
my $stocks1 = shift @stocks;

while (@stocks) {
    my $name2   = shift @files;
    my $stocks2 = shift @stocks;
    my ($added, $removed) = diff_ibd($stocks1, $stocks2);
    print "$name1 -> $name2:\n";
    print 'added:   ' . join(', ', @$added)   . "\n" if @$added;
    print 'removed: ' . join(', ', @$removed) . "\n" if @$removed;
    print "\n";
}


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

sub diff_ibd {
    my ($stocks1, $stocks2) = @_;

    my %stock1 = map { $_ => 1 } @$stocks1;
    my %stock2 = map { $_ => 1 } @$stocks2;

    # eliminate the common ones
    foreach (@$stocks1) {
        if ($stock2{$_}) {
            delete $stock1{$_};
            delete $stock2{$_};
        }
    }

    return [keys %stock2], [keys %stock1];
}

