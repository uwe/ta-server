#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;
use Parse::RecDescent;


my $input = $ARGV[0] || 'SMA(50, CLOSE)';


my $grammar = <<'EOF';
<autotree>
startrule: term /\Z/
term: indicator '(' param_list(?) ')' | indicator 
indicator: /[A-Z][A-Z_0-9]*/
param_list: param_comma(s?) param
param_comma: param ','
param: term | literal
literal: /-?\d+/
EOF

my $parser = Parse::RecDescent->new($grammar);

my $tree = $parser->startrule($input);


warn Dumper $tree;

