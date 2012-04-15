#!/usr/bin/perl
use File::Basename;

my %query = map {my($k,$v) = split(/=/)} split(/&/, $ENV{"QUERY_STRING"});
my $filename = basename($query{"file"});

my $extPos = rindex($filename, ".");
my $mimeType = undef;
if ($extPos != -1) {
	my $ext = lc(substr($filename, $extPos + 1));
	if ($ext eq "js") {
		$mimeType = "application/x-javascript";
	} elsif ($ext eq "png") {
		$mimeType = "image/png";
	} elsif ($ext eq "gif") {
		$mimeType = "image/gif";
	} elsif (($ext eq "jpg") || ($ext eq "jpeg")) {
		$mimeType = "image/jpeg";
	} elsif ($ext eq "cur") {
		$mimeType = "application/octet-stream";
	}
}

if (!defined $mimeType) {
	die "Invalid file extension for '$filename'";
}

binmode(STDOUT);
print "Cache-Control: max-age=43200\n";
print "Content-type: $mimeType\n\n";

my $data;
open(FILE, dirname($0)."/".$filename);
binmode(FILE);
while (!eof(FILE)) {
	read(FILE, $data, 64000);
	print $data;
}
close(FILE);
