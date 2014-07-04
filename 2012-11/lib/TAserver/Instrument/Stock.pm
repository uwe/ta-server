package TAserver::Instrument::Stock;

use Moo;

has symbol   => (is => 'ro', required => 1);
has exchange => (is => 'ro', required => 1);


1;

