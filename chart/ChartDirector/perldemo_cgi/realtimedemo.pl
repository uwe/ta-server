#!/usr/bin/perl

# Include current script directory in the module path (needed on Microsoft IIS).
# This allows this script to work by copying ChartDirector to the same directory
# as the script (as an alternative to installation in Perl module directory)
use File::Basename;
use lib dirname($0) =~ /(.*)/;

use perlchartdir;

#
# In this demo, the generated web page needs to load the "cdjcv.js" Javascript file. For ease of
# installation, we put "cdjcv.js" in the same directory as this script. However, if this script is
# installed in a CGI only directory (such as cgi-bin), the web server would not allow the browser to
# access this non-CGI file.
#
# To get around this potential issue, a special load resource script is used to load these files.
# Instead of using:
#
#    <SCRIPT SRC="cdjcv.js">
#
# we now use:
#
#    <SCRIPT SRC="loadresource.pl?file=cdjcv.js">
#
# If this script is not in a CGI only directory, you may replace the following loadResource string
# with an empty string "" to improve performance.
#
my $loadResource = "loadresource.pl?file=";

print "Content-type: text/html\n\n";
print <<EndOfHTML
<html>
<head>
    <title>ChartDirector Realtime Chart Demonstration</title>
    <script type="text/javascript" src="${loadResource}cdjcv.js"></script>
</head>
<body style="margin:0px">
<table cellspacing="0" cellpadding="0" border="0">
    <tr>
        <td align="right" colspan="2" style="background:#000088">
            <div style="padding-bottom:2px; padding-right:3px; font-weight:bold; font-size:10pt; font-style:italic; font-family:Arial;">
                <a style="color:#FFFF00; text-decoration:none" href="http://www.advsofteng.com/">Advanced Software Engineering</a>
            </div>
        </td>
    </tr>
    <tr valign="top">
        <td style="width:150px; background:#c0c0ff; border-left:black 1px solid; border-right:black 1px solid; border-bottom:black 1px solid;">
            <br /><br />
            <div style="padding:10px; font-size:9pt; font-family:Verdana">
                <b>Update Period</b><br />
                <select id="UpdatePeriod" style="width:130px">
                    <option value="5">5 seconds</option>
                    <option value="10" selected="selected">10 seconds</option>
                    <option value="20">20 seconds</option>
                    <option value="30">30 seconds</option>
                    <option value="60">60 seconds</option>
                </select>
            </div>
            <div style="padding:10px; font-size:9pt; font-family:Verdana">
                <b>Time Remaining</b><br />
                <div style="width:130px; border:#888888 1px inset;">
                    <div style="margin:3px" id="TimeRemaining">&nbsp;</div>
                </div>
            </div>
        </td>
        <td>
            <div style="font-weight:bold; font-size:20pt; margin:5px 0px 0px 5px; font-family:Arial">
                ChartDirector Realtime Chart Demonstration
            </div>
            <hr style="border:solid 1px #000080" />
            <div style="padding:0px 5px 0px 10px">
                <!-- ****** Here is the image tag for the chart image ****** -->
                <img id="ChartImage1" src="realtimechart.pl?chartId=demoChart1">
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
// The followings is executed once every second
function updateDisplay()
{
    // Utility to get an object by id that works with most browsers
    var getObj = function(id) {    return document.getElementById ? document.getElementById(id) : document.all[id]; }

    // Get the configured update period
    var updatePeriodObj = getObj("UpdatePeriod");
    var updatePeriod = parseInt(updatePeriodObj.value);

    // Subtract 1 second for the remaining time - reload the counter if remaining time is 0
    if (!updatePeriodObj.timeLeft || (updatePeriodObj.timeLeft <= 0))
        updatePeriodObj.timeLeft = updatePeriod - 1;
    else
        updatePeriodObj.timeLeft = Math.min(updatePeriod, updatePeriodObj.timeLeft) - 1;

    // Update the chart if configured time has elasped
    if ((updatePeriodObj.timeLeft <= 0) && window.JsChartViewer)
        JsChartViewer.get('ChartImage1').streamUpdate();

    // Update the display to show remaining time
    getObj("TimeRemaining").innerHTML = updatePeriodObj.timeLeft + ((updatePeriodObj.timeLeft > 1) ? " seconds" : " second");
}
window.setInterval("updateDisplay()", 1000);
</script>
</body>
</html>
EndOfHTML
;
