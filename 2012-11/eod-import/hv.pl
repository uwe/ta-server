#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dump qw/pp/;
use File::Slurp qw/read_file/;


my $quotes_path = 'C:/quotes/';
my $exchange    = 'NASDAQ';
my $symbol      = $ARGV[0] || 'AAPL';
my $debug       = $ARGV[2] || 0;

my $file = join '/', $quotes_path . $exchange, substr($symbol, 0, 1), $symbol, 'eod.csv';

my @lines = read_file($file, {chomp => 1});

my @close = ();
foreach my $line (@lines) {
	my ($date, $open, $high, $low, $close, $volume) = split /,/, $line;
	push @close, $close;
}

$debug && printf "Close = %s\n", pp [splice(@close, -10)];

# calculate returns
my $last = shift @close;
my @r = ();
foreach my $close (@close) {
	push @r, log($close / $last);
	$last = $close;
}

$debug && printf "r = %s\n", pp [splice(@r, -10)];

# average return
my $n = $ARGV[1] || 252;
@r = splice(@r, 0, $n);
my $r_avg = 0;
$r_avg += $_ foreach (@r);
$r_avg /= $n;

$debug && printf "r_avg = %s\n", $r_avg;

# squared deviation from average
my @r_2 = map { ($_ - $r_avg) ** 2 } @r;

$debug && printf "r_2 = %s\n", pp [splice(@r_2, -10)];

# calculate variance
my $sigma_2 = 0;
$sigma_2 += $_ foreach (@r_2);
$sigma_2 /= $n;

$debug && printf "sigma_2 = %s\n", $sigma_2;

# calculate standard deviation
my $sigma = sqrt($sigma_2);

$debug && printf "sigma = %s\n", $sigma;

# annualize
my $hv = $sigma * sqrt(252);

print "HV = $hv\n";

