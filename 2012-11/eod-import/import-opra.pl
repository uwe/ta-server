#!/usr/bin/env perl

use strict;
use warnings;

use File::Path  qw/make_path/;
use File::Slurp qw/append_file/;


local $| = 1;

my $input_glob  = 'C:/eoddata3/OPRA/*.csv';
$input_glob = 'C:/eoddata.com/OPRA_*.txt';
my $output_path = 'C:/quotes/';

my $skip_date   = '';
my $skip_symbol = '';

my @month = qw/xxx Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;

my $skip = 0;
$skip = 1 if $skip_date or $skip_symbol;

foreach my $file (sort glob($input_glob)) {
	unless ($file =~ m#/(OPRA)_(\d{8}).(csv|txt)$#) {
		die "wrong file format: $file";
	}
	my $exchange = $1;
	my $date     = $2;

	if ($skip) {
		next if $date lt $skip_date;
		$skip = 0 unless $skip_symbol;
	}

	print "$exchange $date\n";

	# calculate date string to double check CSV files
	$date =~ /(\d\d\d\d)(\d\d)(\d\d)/;
	$date = join '-', $1, $2, $3;
	my $date_str  = join '-', $3, $month[$2], $1;
	my $date_str2 = join '', $1, $2, $3;

	open(my $fh, '<', $file) or die $!;
	while (my $line = <$fh>) {
		chomp $line;
		next if $line eq 'Symbol,Date,Open,High,Low,Close,Volume,OpenInt';
		my @data = split /,/, $line;

		my $symbol   = shift @data;
		my $csv_date = shift @data;
		if ($csv_date ne $date_str and $csv_date ne $date_str2) {
			die "Date mismatch: $date, $date_str, $date_str2 and $line";
		}

		# extract underlying, expiration, type and strike
		unless ($symbol =~ /(\D+)(\d\d)(\d\d)(\d\d)(C|P)(\d{8})/) {
			die "wrong symbol format: $symbol";
		}
		my $underlying = $1;
		my $expiration = join '-', 20 . $2, $3, $4;
		my $type       = $5;
		my $strike     = $6;

		if ($skip) {
			next unless $underlying eq $skip_symbol;
			$skip = 0;
		}

		# no dots in symbol/directory name
		$underlying =~ s/\./_/g;

		my $out_path = sprintf(
			'%s%s/%s/%s/%s/',
			$output_path,
			$exchange,
			substr($underlying, 0, 1),
			$underlying,
			$expiration,
		);
		make_path($out_path);

		append_file(
			$out_path . $type . $strike . '.csv',
			join(',', $date, @data) . "\n",
		);
	}
	close($fh);
}

