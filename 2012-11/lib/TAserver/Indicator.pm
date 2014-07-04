package TAserver::Indicator;

use Moo;

has instrument => (is => 'ro', required => 1);


sub name  { die 'NAME missing' }
sub desc  {}
sub alias {}
sub param {}
sub opt   {}


1;

