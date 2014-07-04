#!/usr/bin/env perl

use strict;
use warnings;

use File::Path  qw/make_path/;
use File::Slurp qw/append_file/;


local $| = 1;

my $exchange    = $ARGV[0] || 'NASDAQ';
my $input_path  = '/raid/projekt/eoddata.com/unsort/' . $exchange;
my $output_path = '/raid/projekt/eoddata.com/db';

my $stop_file   = $output_path . '/stop';


my @month = qw/xxx Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;

foreach my $file (sort glob($input_path . '/*.csv')) {
	unless ($file =~ m#/(AMEX|NASDAQ|NYSE)_(\d{8}).csv$#) {
		die "wrong file format: $file";
	}
	my $exchange = $1;
	my $date     = $2;

	print "$exchange $date\n";

	# calculate date string to double check CSV files
	$date =~ /(\d\d\d\d)(\d\d)(\d\d)/;
	$date = join '-', $1, $2, $3;
	my $date_str = join '-', $3, $month[$2], $1;

	open(my $fh, '<', $file) or die $!;
	while (my $line = <$fh>) {
		$line =~ s/\r//g;
        $line =~ s/\n//g;
		next if $line eq 'Symbol,Date,Open,High,Low,Close,Volume';
		my @data = split /,/, $line;

		my $symbol = shift @data;
		if ($date_str ne shift @data) {
			print "Date mismatch: $date, $date_str and $line\n";
            die;
		}

		my $out_path = join(
            '/',
			$output_path,
			$exchange,
			substr($symbol, 0, 1),
			$symbol,
		);
		make_path($out_path);

		append_file(
			$out_path . '/eod.csv',
			join(',', $date, @data) . "\n",
		);
	}
	close($fh);

    # update date
    my $file2 = join '/', $output_path, $exchange, 'last_update.txt';
    open(my $fh2, '>', $file2) or die $!;
    print $fh2 $date;
    close($fh2);

    # check stop file
    last if -f $stop_file;
}

