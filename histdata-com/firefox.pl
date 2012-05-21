#!/usr/bin/env perl

use strict;
use warnings;

use DateTime;
use WWW::Mechanize::Firefox;

my $url   = 'http://www.histdata.com/download-free-forex-data/?/ascii/tick-data-quotes';

my %CURRENCY = (
    eurusd => 200005, eurchf => 200201, eurgbp => 200203, eurjpy => 200203,
    euraud => 200208, usdcad => 200006, usdchf => 200005, usdjpy => 200005,
    usdmxn => 201011, gbpchf => 200208, gbpjpy => 200205, gbpusd => 200005,
    audjpy => 200208, audusd => 200006, chfjpy => 200208, nzdjpy => 200609,
    nzdusd => 200508, xauusd => 200903, eurcad => 200703, audcad => 200707,
    cadjpy => 200703, eurnzd => 200803, grxeur => 201011, nzdcad => 200803,
    sgdjpy => 200808, usdhkd => 200808, usdnok => 200808, usdtry => 201011,
    xauaud => 200905, audchf => 200803, auxaud => 201011, eurhuf => 201011,
    eurpln => 201011, frxeur => 201011, hkxhkd => 201011, nzdchf => 200803,
    spxusd => 201011, usdhuf => 201011, usdpln => 201011, usdzar => 201011,
    xauchf => 200905, zarjpy => 201011, bcousd => 201011, etxeur => 201011,
    eurczk => 201011, eursek => 200808, gbpaud => 200709, gbpnzd => 200803,
    jpxjpy => 201011, udxusd => 201011, usdczk => 200808, usdsek => 200808,
    wtiusd => 201011, xaueur => 200905, audnzd => 200709, cadchf => 200803,
    eurdkk => 200808, eurnok => 200808, eurtry => 201011, gbpcad => 200709,
    nsxusd => 201011, ukxgbp => 201011, usddkk => 200808, usdsgd => 200808,
    xagusd => 200905, xaugbp => 200905,
);


my @currencies = ();
my @years      = ();
my @months     = ();

foreach my $arg (@ARGV) {
    if ($arg =~ /^\w{6}$/) {
        push @currencies, $arg;
    }
    elsif ($arg =~ /^\d{4}$/) {
        push @years, $arg;
    }
    elsif ($arg =~ /^\d{2}$/) {
        push @months, $arg;
    }
    else {
        warn "unrecognized parameter: $arg";
    }
}

my $today = DateTime->today;
if (@months and not @years) {
    warn "year missing, assuming actual year";
    @years = ($today->year);
}

@currencies = keys %CURRENCY         unless @currencies;
@years      = (2000 .. $today->year) unless @years;
@months     = (1 .. 12)              unless @months;

my $mech = WWW::Mechanize::Firefox->new;

foreach my $currency (@currencies) {
    unless ($CURRENCY{$currency}) {
        warn "currency $currency unknown";
        next;
    }

    $CURRENCY{$currency} =~ /^(\d{4})(\d{2})$/;
    my $start_year  = $1;
    my $start_month = $2;

    print "$currency\n";

    foreach my $year (@years) {
        next if $year < $start_year;
        next if $year > $today->year;

        foreach my $month (@months) {
            next if $year == $start_year and $month < $start_month;
            next if $year == $today->year and $month > $today->month;

            $mech->get(join '/', $url, $currency, $year, $month);

            my $link = $mech->find_link(url_regex => qr/get.php/);
            my $file = sprintf('zip/%s-%4d-%02d.zip', $currency, $year, $month);
            $mech->save_url($link->url, $file);
        }
    }
}

