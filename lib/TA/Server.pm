package TA::Server;

use Mojo::Base -base;

use DateTime;
use File::Slurp qw/slurp/;


has data_path => 'data/';


# merge quotes to arrayref of hashes
sub get_quotes {
    my ($self, $symbol) = @_;

    my ($open, $dates) = $self->_get_data_file($self->data_path . "$symbol-OPEN.txt");
    my ($high)         = $self->_get_data_file($self->data_path . "$symbol-HIGH.txt");
    my ($low)          = $self->_get_data_file($self->data_path . "$symbol-LOW.txt");
    my ($close)        = $self->_get_data_file($self->data_path . "$symbol-CLOSE.txt");
    my ($volume)       = $self->_get_data_file($self->data_path . "$symbol-VOLUME.txt");

    # sanity check
    if (@$open != @$high or @$open != @$low or @$open != @$close or @$open != @$volume) {
        die sprintf(
            'Different number of rows: open=%d, high=%d, low=%d, close=%d, volume=%d',
            scalar @$open,
            scalar @$high,
            scalar @$low,
            scalar @$close,
            scalar @$volume,
        );
    }

    my @quotes = ();
    for (my $i = 0; $i < scalar @$open; $i++) {
        push @quotes, {
            date   => $dates->[$i],
            open   => $open->[$i],
            high   => $high->[$i],
            low    => $low->[$i],
            close  => $close->[$i],
            volume => $volume->[$i],
        };
    }

    return \@quotes;
}

# return data as arrayref (without gaps)
sub _get_data_file {
    my ($self, $file) = @_;

    my @lines = slurp($file, chomp => 1);
    my $date;
    if ($lines[1] =~ /^# start: (\d{4})-(\d\d)-(\d\d)$/) {
        $date = DateTime->new(
            year  => $1,
            month => $2,
            day   => $3,
        );
    } else {
        die 'Date not found: ' . $lines[1];
    }

    my @data  = ();
    my @dates = ();
    foreach my $line (slurp($file, chomp => 1)) {
        next if $line =~ /^#/;
        unless ($line) {
            $date = $date->add(days => 1);
            $date = $date->add(days => 2) if $date->dow > 5;
            next;
        }
        push @data, $line;
        push @dates, $date->ymd('-');
        $date = $date->add(days => 1);
        $date = $date->add(days => 2) if $date->dow > 5;
    }

    return \@data, \@dates;
}

1;

