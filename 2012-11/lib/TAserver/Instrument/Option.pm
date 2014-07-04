package TAserver::Instrument::Option;

use Moo;

has type => (
    is       => 'ro',
    isa      => sub { die "CALL/PUT" unless $_[0] =~ /^(CALL|PUT)$/ },
    required => 1,
);

has underlying => (is => 'ro');
has strike     => (is => 'ro', required => 1);
has expiration => (is => 'ro', required => 1);


1;

