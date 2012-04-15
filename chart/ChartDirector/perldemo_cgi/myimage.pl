#!/usr/bin/perl

%query = map {my($k,$v) = split(/=/)} split(/&/, $ENV{"QUERY_STRING"});
if ($query{"img"} !~ /\bcd__/) {
	die "Filename '".$query{"img"}."' is not a temporary file created by ChartDirector Ver 4.1 or above.";
}

open(FILE, $query{"img"});

binmode(FILE);
binmode(STDOUT);

print "Content-type: image/png\n\n";
while (!eof(FILE)) {
	read(FILE, $data, 64000);
	print $data;
}
close(FILE);
