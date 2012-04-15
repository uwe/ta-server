#!/usr/bin/perl

my %query = map {my($k,$v) = split(/=/)} split(/&/, $ENV{"QUERY_STRING"});
my $filename = $query{"img"};
$filename =~ s/\%([A-Za-z0-9]{2})/pack('C', hex($1))/seg;
if ($filename !~ /\bcd__/) {
	die "Filename '$filename' is not a temporary file created by ChartDirector Ver 4.1 or above.";
}
my $extPos = rindex($filename, ".");
my $ext = "png";
if ($extPos != -1) {
	$ext = lc(substr($filename, $extPos + 1));
}

my $contentType = "image/png";
if ($ext eq "gif") {
	$contentType = "image/gif";
} elsif (($ext eq "jpg") || ($ext eq "jpeg")) {
	$contentType = "image/jpeg";
} elsif ($ext eq "bmp") {
	$contentType = "image/bmp";
} elsif (($ext eq "wmp") or ($ext eq "wbmp")) {
	$contentType = "image/vnd.wap.wbmp";
} elsif (($ext eq "svg") or ($ext eq "svgz")) {
	$contentType = "image/svg+xml";
} elsif (($ext eq "map") or ($ext eq "gz")) {
	$contentType = "text/html; charset=utf-8";
}

binmode(STDOUT);
print "Content-type: $contentType\n";
if (($ext eq "gz") or ($ext eq "svgz")) {
	print "Content-Encoding: gzip\n";
}
if (defined $query{"filename"}) {
	print "Content-Disposition: inline; filename=$query{'filename'}\n";
}
print "\n";

my $data;
open(FILE, $filename);
binmode(FILE);
while (!eof(FILE)) {
	read(FILE, $data, 64000);
	print $data;
}
close(FILE);
