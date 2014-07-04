package TAserver::Indicator::SMA;

# simple moving average

use Moo;

extends 'TAserver::Indicator';

has periods => (is => 'ro', required => 1);
has quote   => (is => 'ro', required => 1);


sub name  { 'SMA'}
sub desc  { 'simple moving average' }
sub param {
    {
        name => 'periods',
        type => 'int',
        desc => 'periods (e. g. days)',
    },
    {
        name    => 'quote',
        type    => 'quote',
        desc    => 'price type used for calculation',
        default => 'CLOSE',
    },
}


1;

