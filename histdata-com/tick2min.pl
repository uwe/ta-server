#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dump qw/pp/;
use File::Slurp;


my $file = 'data/2012/20120511.tick';
my $size = 60*60; # in seconds
#my $type = 'max';


my $data = read_file($file);

my %bar = (
    start => 0,
);
$size *= 1000;

my $data_offset = 0;
while ($data_offset < length $data) {
    my $tick_data = substr($data, $data_offset, 12);

    my ($offset, $bid, $ask) = unpack('NNN', $tick_data);
    if ($offset > ($bar{start} + 1) * $size) {
        warn pp \%bar;
        %bar = (
            start => int($offset / $size),
        );
    }

    unless ($bar{open}) {
        $bar{open}  = $bid;
        $bar{high}  = $ask;
        $bar{low}   = $bid;
        $bar{close} = $bid;
    }

    $bar{high}  = $ask if $ask > $bar{high};
    $bar{low}   = $bid if $bid < $bar{low};
    $bar{close} = $bid;

    $data_offset += 12;
}

warn pp \%bar;

