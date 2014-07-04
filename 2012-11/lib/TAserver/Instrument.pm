package TAserver::Instrument;

use Moo;

has ta => (is => 'ro', required => 1);


my $name_re = qr/[A-Z][A-Z_0-9]*/;


sub get {
    my ($self, $term) = @_;

    # parse term
    my $param = _parse(\$term);
    die "Unrecognized characters: '$term'" if $term;

    return $self->_get(@$param);
}

sub _get {
    my ($self, $name, @param) = @_;

    # resolve params
    foreach my $param (@param) {
        if (ref $param) {
            $param = $self->_get(@$param);
        }
    }

    my $class = $self->ta->class_map->{$self->ta->alias_map->{$name} || $name};
    die "Unknown name '$name'" unless $class;

    my %param = (
        instrument => $self,
    );
    foreach my $meta ($class->param) {
        ###TODO### type checking, required
        $param{$meta->{name}} = shift @param || $meta->{default};
    }
    foreach my $meta ($class->opt) {
        $param{$meta->{name}} = $meta->{default};
    }

    die "Additional parameters: @param" if @param;

    return $class->new(%param);
}

sub _parse {
    my ($term) = @_;

    # indicator name
    unless ($$term =~ s/^\s*($name_re)\s*//) {
        die "Indicator name expected: '$$term'";
    }

    my $indicator = $1;

    # parameter list
    my @param = ();
    if ($$term =~ s/^\(\s*//) {
        while ($$term) {
            # literal?
            if ($$term =~ s/^(\d+)\s*,?\s*//) {
                push @param, $1;
            }
            # indicator?
            elsif ($$term =~ /^$name_re/) {
                push @param, _parse($term);
                $$term =~ s/^,\s*//;
            }
            # end of params
            elsif ($$term =~ s/^\)\s*//) {
                return [$indicator, @param];
            }
            else {
                die "Unknown token in '$indicator' at '$term'";
            }
        }
        die "Unexpected end of string in '$indicator'";
    }

    return [$indicator];
}


1;

