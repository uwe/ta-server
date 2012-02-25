#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dump qw/pp/;
use DateTime;
use File::Slurp qw/write_file/;
use Finance::QuoteHist::Yahoo;


my $symbol = $ARGV[0] || 'IBM';

my $q = Finance::QuoteHist::Yahoo->new(
    symbols => [$symbol],
);

get_splits($symbol)    unless -f "data/$symbol-SPLIT.txt";
get_dividends($symbol) unless -f "data/$symbol-DIVIDEND.txt";
get_quotes($symbol)    unless -f "data/$symbol-OPEN.txt";


sub get_splits {
    my ($symbol) = @_;

    my @splits = $q->splits;
    if (@splits) {
        my $out = "# $symbol SPLIT\n";
        foreach (@splits) {
            my ($sym, $date, $post, $pre) = @$_;
            if ($date =~ m|^(\d{4})/(\d\d)/(\d\d)$|) {
                $out .= "$1-$2-$3 $post $pre\n";
            } else {
                warn "Unknown date: $date";
            }
        }
        write_file("data/$symbol-SPLIT.txt", $out);
    }
}

sub get_dividends {
    my ($symbol) = @_;

    my @dividends = $q->dividends;
    if (@dividends) {
        my $out = "# $symbol DIVIDEND\n";
        foreach (@dividends) {
            my ($sym, $date, $div) = @$_;
            if ($date =~ m|^(\d{4})/(\d\d)/(\d\d)$|) {
                $out .= "$1-$2-$3 $div\n";
            } else {
                warn "Unknown date: $date";
            }
        }
        write_file("data/$symbol-DIVIDEND.txt", $out);
    }
}

sub get_quotes {
    my ($symbol) = @_;

    my @quotes = $q->quotes;
    if (@quotes) {
        my $open   = "# $symbol OPEN\n";
        my $high   = "# $symbol HIGH\n";
        my $low    = "# $symbol LOW\n";
        my $close  = "# $symbol CLOSE\n";
        my $volume = "# $symbol VOLUME\n";

        my $last;
        foreach (@quotes) {
            my ($sym, $date, $o, $h, $l, $c, $v) = @$_;
            if ($date =~ m|^(\d{4})/(\d\d)/(\d\d)$|) {
                my $dt = DateTime->new(
                    year  => $1,
                    month => $2,
                    day   => $3,
                );
                if ($dt->dow > 5) {
                    die 'Wrong weekday: ' . $dt->ymd('-') . ' ' . $dt->dow;
                }

                unless ($last) {
                    $open   .= sprintf("# start: %s\n", $dt->ymd('-'));
                    $high   .= sprintf("# start: %s\n", $dt->ymd('-'));
                    $low    .= sprintf("# start: %s\n", $dt->ymd('-'));
                    $close  .= sprintf("# start: %s\n", $dt->ymd('-'));
                    $volume .= sprintf("# start: %s\n", $dt->ymd('-'));
                }

                # check for missing days (e. g. holidays)
                if (my $gaps = _check_gaps($last, $dt)) {
                    foreach (1 .. $gaps) {
                        $open   .= "\n";
                        $high   .= "\n";
                        $low    .= "\n";
                        $close  .= "\n";
                        $volume .= "\n";
                    }
                }
                $last = $dt;

                $open   .= "$o\n";
                $high   .= "$h\n";
                $low    .= "$l\n";
                $close  .= "$c\n";
                $volume .= "$v\n";
            } else {
                warn "Unknown date: $date";
            }
        }
        $open   .= sprintf("# end: %s\n", $last->ymd('-'));
        $high   .= sprintf("# end: %s\n", $last->ymd('-'));
        $low    .= sprintf("# end: %s\n", $last->ymd('-'));
        $close  .= sprintf("# end: %s\n", $last->ymd('-'));
        $volume .= sprintf("# end: %s\n", $last->ymd('-'));

        write_file("data/$symbol-OPEN.txt",   $open);
        write_file("data/$symbol-HIGH.txt",   $high);
        write_file("data/$symbol-LOW.txt",    $low);
        write_file("data/$symbol-CLOSE.txt",  $close);
        write_file("data/$symbol-VOLUME.txt", $volume);
    }
}

sub _check_gaps {
    my ($last, $date) = @_;

    return 0 unless $last;

    if ($last >= $date) {
        die 'LAST >= DATE (' . $last->ymd('-') . ' vs. ' . $date->ymd('-') . ')';
    }

    my $delta = $date->delta_days($last);
    # next day
    return 0 if $delta->days == 1;
    # Friday -> Monday
    return 0 if $delta->days == 3 and $last->dow == 5 and $date->dow == 1;
    # count weekdays
    my $start = $last->add(days => 1);
    my $gaps = 0;
    while ($start < $date) {
        $gaps++ if $start->dow >= 1 and $start->dow <= 5;
        $start = $start->add(days => 1);
    }
    return $gaps;
}

