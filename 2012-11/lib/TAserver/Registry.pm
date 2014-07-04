package TAserver::Registry;

use Moo;


has class => (is => 'ro', default => sub { {} });
has alias => (is => 'ro', default => sub { {} });


sub add {
    my ($self, $name, $class) = @_;

    my $hash = $self->class;

    die "duplicate name $name" if $hash->{$name};

    $hash->{$name} = $class;
}

sub add_alias {
    my ($self, $name, $alias
