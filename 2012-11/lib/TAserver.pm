package TAserver;

use Moo;

use Module::Find qw/useall/;


has class_map => (is => 'ro', default => sub { {} });
has alias_map => (is => 'ro', default => sub { {} });


sub BUILD {
    my ($self) = @_;

    my $class_map = $self->class_map;
    my $alias_map = $self->alias_map;

    # load and register all quotes and indicators
    my @classes = (
        useall('TAserver::Quote'),
        useall('TAserver::Indicator'),
    );
    foreach my $class (@classes) {
        my $name = $class->name;

        die "duplicate name $name" if $class_map->{$name};
        $class_map->{$name} = $class;

        foreach my $alias ($class->alias) {
            die "duplicate alias $alias" if $alias_map->{$alias};
            $alias_map->{$alias} = $name;
        }
    }
}


1;

