#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

use lib 'lib';
use TAserver;
use TAserver::Instrument;


my $ta = TAserver->new;


warn Dumper $ta;

my $class = $ta->class_map->{HIST_VOLA};

warn Dumper [$class->param];
warn Dumper [$class->opt];


my $instr = TAserver::Instrument->new(ta => $ta);
warn Dumper $instr->get('SMA(50, HV)');

