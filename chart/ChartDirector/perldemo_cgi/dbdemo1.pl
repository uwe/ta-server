#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

# Get HTTP query parameters
use CGI;
my $query = new CGI;

# The currently selected year
my $selectedYear = ($query->param("year") or 2001);

#
# The following code generates the <option> tags for the HTML select box, with the
# <option> tag representing the currently selected year marked as selected.
#

my $optionTags = [(undef) x (2001 - 1990 + 1)];
for(my $i = 1990; $i < 2001 + 1; ++$i) {
    if ($i == $selectedYear) {
        $optionTags->[$i - 1990] = "<option value='$i' selected>$i</option>";
    } else {
        $optionTags->[$i - 1990] = "<option value='$i'>$i</option>";
    }
}
my $selectYearOptions = join("", @$optionTags);

print "Content-type: text/html\n\n";
print <<EndOfHTML
<html>
<body style="margin:5px 0px 0px 5px">
<div style="font-size:18pt; font-family:verdana; font-weight:bold">
    Database Integration Demo (1)
</div>
<hr style="border:solid 1px #000080" />
<div style="font-size:10pt; font-family:verdana; margin-bottom:20px">
&#8226; <a href="viewsource.pl?file=$ENV{"SCRIPT_NAME"}">
    View containing HTML page source code
</a>
<br />
&#8226; <a href="viewsource.pl?file=dbdemo1a.pl">
    View chart generation page source code
</a>
<br />
<br />
<form>
    I want to obtain the revenue data for the year
    <select name="year">
        $selectYearOptions
    </select>
    <input type="submit" value="OK">
</form>
</div>

<img src="dbdemo1a.pl?year=$selectedYear">

</body>
</html>
EndOfHTML
;
