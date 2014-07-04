package TAserver::Indicator::HV;

use Moo;

extends 'TAserver::Indicator';

has periods        => (is => 'ro', required => 1);
has quote          => (is => 'ro', required => 1);
has annual_periods => (is => 'ro', required => 1);


sub name  { 'HIST_VOLA' }
sub desc  { 'historical volatility' }
sub alias { 'HV' }
sub param {
    {
        name    => 'periods',
        type    => 'int',
        desc    => 'periods (e. g. days)',
        default => 20,
    },
}
sub opt {
    {
        name    => 'quote',
        type    => 'quote',
        desc    => 'price type used for calculation',
        default => 'CLOSE',
    },
    {
        name    => 'annual_periods',
        type    => 'int',
        desc    => 'number of periods in a year',
        default => 262,
    },
}

1;

