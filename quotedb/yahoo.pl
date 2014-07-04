#!/usr/bin/env perl

use strict;
use warnings;

use lib '/home/uwe/repos/finance-quotedb/lib';
use Finance::QuoteDB;
use Finance::QuoteDB::Schema;


my $fqdb = Finance::QuoteDB->new(
    {
        dsn       => 'dbi:mysql:quotedb',
        dsnuser   => 'uwe',
        dsnpasswd => 'uwe',
    }
);

my @pattern = map { $_ . '**' } ('A' .. 'Z');
my $exchanges = 'NYQ,NAS,NYS,NMS,ASE';
$fqdb->add_yahoo_stocks($exchanges, \@pattern);

