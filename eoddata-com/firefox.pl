#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long;
use WWW::Mechanize::Firefox;


my @EXCHANGES = qw/INDEX FOREX AMEX NASDAQ NYSE/;


my $username = $ENV{EOD_USER};
my $password = $ENV{EOD_PASS};

GetOptions(
    'user|u=s' => \$username,
    'pass|p=s' => \$password,
);

unless ($username and $password) {
    print <<"EOF";
Usage: $0 ARGUMENTS
-u --user  username (default: env variable EOD_USER)
-p --pass  password (default: env variable EOD_PASS)
EOF
    exit 1;
}


my $mech = WWW::Mechanize::Firefox->new;

# login
$mech->get('http://www.eoddata.com/');
if ($mech->by_id('ctl00_cph1_lg1_btnLogin', any => 1)) {
    $mech->form_name('aspnetForm');
    $mech->field('#ctl00_cph1_lg1_txtEmail'    => 'uwevoelker');
    $mech->field('#ctl00_cph1_lg1_txtPassword' => 'uweweb');
    $mech->click({id => 'ctl00_cph1_lg1_btnLogin'});
}


# download .csv
$mech->get('http://www.eoddata.com/download.aspx');
if ($mech->by_id('cboxClose', any => 1)) {
    # close ad box
    $mech->click({id => 'cboxClose', synchronize => 0});
}

my $today; # used for symbol changes and splits
$mech->form_name('aspnetForm');
foreach my $exchange (@EXCHANGES) {
    $mech->select('ctl00$cph1$d1$cboExchange', $exchange);

    # trigger reload
    $mech->click({id => 'ctl00_cph1_d1_radExchangeGroup', synchronize => 0});
    sleep 2;
    $mech->click({id => 'ctl00_cph1_d1_radExchange',      synchronize => 0});

    foreach my $link ($mech->find_all_links(text_regex => qr/ \d\d \d\d\d\d$/)) {
        unless ($link->url =~ /[?&]sd=(\d{8})/) {
            warn 'Unknown link: ' . $link->url;
            next;
        }
        my $date = $1;
        $today ||= $date; # used for symbol changes and splits
        my $file = "csv/$exchange-$date.csv";
        next if -f $file;

        $mech->save_url($link->url, $file);
        sleep 2;
    }
}

# download symbol lists
foreach my $exchange (@EXCHANGES) {
    my $url  = 'http://www.eoddata.com/Data/symbollist.aspx?e=' . $exchange;
    my $file = $exchange . '.txt';
    $mech->save_url($url, $file);
}

# download symbol changes
{
    my $url  = 'http://www.eoddata.com/symbolchanges.aspx';
    my $file = "html/symbol-changes-$today.html";
    $mech->save_url($url, $file);
}

# download splits
{
    my $url  = 'http://www.eoddata.com/splits.aspx';
    my $file = "html/splits-$today.html";
    $mech->save_url($url, $file);
}

