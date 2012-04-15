#!/usr/bin/perl

print "Content-type: text/html\n\n";
print "<html><body>";

my $dead = 0;
my $ret = eval '

	local $SIG{__DIE__} = sub { print $_[0], "<BR><BR>"; $dead = 1; };

	use DBI;

	#
	#Create an samoke SQL statement to test the database
	#
	my $SQL = "Select Software, Hardware, Services From revenue Where Year(TimeStamp)=2001 Order By TimeStamp";
	
	#
	#Read in the revenue data into arrays
	#
	my $dbh = DBI->connect("dbi:mysql:sample", "test", "test") or die $DBI::errstr;
	my $sth = $dbh->prepare($SQL) or die $DBI::errstr;
	$sth->execute() or die $DBI::errstr;

	my $software = [];
	my $hardware = [];
	my $services = [];
	while (my @row = $sth->fetchrow_array) {
	    push @$software, $row[0];
    	push @$hardware, $row[1];
	    push @$services, $row[2];
	}
	$dbh->disconnect;
	return 1;
';

if (!$ret) {
	print "<p><b>Error accessing database</b></p>";
	if (!$dead) { print "<p>$@</p>"; }
} else {
	print "<p><b>Database connection test successful<b></p>";
}

print "</body></html>";
