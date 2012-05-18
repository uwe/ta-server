#!/usr/bin/env perl

use strict;
use warnings;

use DateTime;
use WWW::Mechanize::Firefox;


my $url   = 'http://www.histdata.com/download-free-forex-data/?/ascii/tick-data-quotes/eurusd';

my $mech  = WWW::Mechanize::Firefox->new;
my $today = DateTime->today;

foreach my $year (2000 .. $today->year) {
    foreach my $month (1 .. 12) {
        next if $year == 2000 and $month < 5;
        next if $year == $today->year and $month > $today->month;

        $mech->get(join '/', $url, $year, $month);

        my $link = $mech->find_link(url_regex => qr/get.php/);
        my $file = sprintf('eur-usd-%4d-%02d.zip', $year, $month);
        $mech->save_url($link->url, $file);
    }
}

