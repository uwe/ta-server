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

#
# In this demo, the generated web page needs to load the "cdjcv.js" Javascript file and several GIF
# files. For ease of installation, we put these files in the same directory as this script. However,
# if this script is installed in a CGI only directory (such as cgi-bin), the web server would not
# allow the browser to access these non-CGI files.
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
# Similar methods are used to load the GIF files.
#
# If this script is not in a CGI only directory, you may replace the following loadResource string
# with an empty string "" to improve performance.
#
my $loadResource = "loadresource.pl?file=";

#
# We need to handle 3 types of request: - initial request for the full web page - partial update
# (AJAX chart update) to update the chart without reloading the page - full page update for old
# browsers that does not support partial updates
#

# The total date range of all data.
my $startDate = undef;
my $endDate = undef;

# The date range of the data that we zoomed into (visible on the chart).
my $viewPortStartDate = undef;
my $viewPortEndDate = undef;

#
# Handles the initial request
#
sub createFirstChart
{
    my ($viewer) = @_;
    # Initialize the Javascript ChartViewer
    $viewer->setMouseUsage($perlchartdir::MouseUsageScroll);

    # In this demo, we allow scrolling the chart for the last 5 years
    my($unused, $unused, $unused, $d, $m, $y, $unused, $unused, $unused) = localtime();

    # The localtime month format is from 0 - 11, while the year is offsetted by 1900. We adjust them
    # to human used format.
    $m = $m + 1;
    $y = $y + 1900;

    $endDate = perlchartdir::chartTime($y, $m, $d);

    # We roll back 5 years for the start date. Note that if the end date is Feb 29 (leap year only
    # date), we need to change it to Feb 28 in the start year
    if (($m == 2) && ($d == 29)) {
        $d = 28;
    }
    $startDate = perlchartdir::chartTime($y - 5, $m, $d);

    # The initial selected date range is last 1 year
    $viewPortStartDate = perlchartdir::chartTime($y - 1, $m, $d);
    $viewPortEndDate = $endDate;

    # We store the scroll range as custom Javascript ChartViewer attributes, so the range can be
    # retrieved later in partial or full update requests
    $viewer->setCustomAttr("startDate", $startDate);
    $viewer->setCustomAttr("endDate", $endDate);

    # In this demo, we set the maximum zoom-in to 10 days
    $viewer->setZoomInWidthLimit(10 * 86400 / ($endDate - $startDate));

    # Draw the chart
    drawChart($viewer);
}

#
# Handles partial update (AJAX chart update)
#
sub processPartialUpdate
{
    my ($viewer) = @_;
    # Retrieve the overall date range from custom Javascript ChartViewer attributes.
    $startDate = $viewer->getCustomAttr("startDate");
    $endDate = $viewer->getCustomAttr("endDate");

    # Now we need to determine the visible date range selected by the user. There are two
    # possibilities. The user may use the zoom/scroll features of the Javascript ChartViewer to
    # select the range, or s/he may use the start date / end date select boxes to select the date
    # range.

    if ($viewer->isViewPortChangedEvent()) {
        # Is a view port change event from the Javascript ChartViewer, so we should get the selected
        # date range from the ChartViewer view port settings.
        my $duration = $endDate - $startDate;
        $viewPortStartDate = $startDate + int(0.5 + $viewer->getViewPortLeft() * $duration);
        $viewPortEndDate = $viewPortStartDate + int(0.5 + $viewer->getViewPortWidth() * $duration);
    } else {
        # The user has changed the selected range by using the start date / end date select boxes.
        # We need to retrieve the selected dates from those boxes. For partial updates, the select
        # box values are sent in as Javascript ChartViewer custom attributes.
        my $startYear = int($viewer->getCustomAttr("StartYear"));
        my $startMonth = int($viewer->getCustomAttr("StartMonth"));
        my $startDay = int($viewer->getCustomAttr("StartDay"));
        my $endYear = int($viewer->getCustomAttr("EndYear"));
        my $endMonth = int($viewer->getCustomAttr("EndMonth"));
        my $endDay = int($viewer->getCustomAttr("EndDay"));

        # Note that for browsers that do not support Javascript, there is no validation on the
        # client side. So it is possible for the day to exceed the valid range for a month (eg. Nov
        # 31, but Nov only has 30 days). So we set the date by adding the days difference to the 1
        # day of a month. For example, Nov 31 will be treated as Nov 1 + 30 days = Dec 1.
        $viewPortStartDate = perlchartdir::chartTime($startYear, $startMonth, 1) + ($startDay - 1) *
            86400;
        $viewPortEndDate = perlchartdir::chartTime($endYear, $endMonth, 1) + ($endDay - 1) * 86400;
    }

    # Draw the chart
    drawChart($viewer);

    #
    # We need to communicate the new start date / end date back to the select boxes on the browser
    # side.
    #

    # The getChartYMD function retrives the date as an 8 digit decimal number yyyymmdd.
    my $startYMD = perlchartdir::getChartYMD($viewPortStartDate);
    my $endYMD = perlchartdir::getChartYMD($viewPortEndDate);

    # Send year, month, day components to the start date / end date select boxes through Javascript
    # ChartViewer custom attributes.
    $viewer->setCustomAttr("StartYear", int($startYMD / 10000));
    $viewer->setCustomAttr("StartMonth", int($startYMD / 100) % 100);
    $viewer->setCustomAttr("StartDay", $startYMD % 100);
    $viewer->setCustomAttr("EndYear", int($endYMD / 10000));
    $viewer->setCustomAttr("EndMonth", int($endYMD / 100) % 100);
    $viewer->setCustomAttr("EndDay", $endYMD % 100);
}

#
# Handles full update
#
sub processFullUpdate
{
    my ($viewer) = @_;
    # A full chart update is essentially the same as a partial chart update. The main difference is
    # that in a full chart update, the start date / end date select boxes are in Form Post
    # variables, while in partial chart update, they are in Javascript ChartViewer custom
    # attributes.
    #
    # So a simple implementation of the full chart update is to copy the Form Post values to the
    # Javascript ChartViewer custom attributes, and then call the partial chart update.

    # Controls to copy
    my $ctrls = ["StartYear", "StartMonth", "StartDay", "EndYear", "EndMonth", "EndDay"];

    # Copy control values to Javascript ChartViewer custom attributes
    for(my $i = 0; $i < scalar(@$ctrls); ++$i) {
        $viewer->setCustomAttr($ctrls->[$i], $query->param($ctrls->[$i]));
    }

    # Now can use partial chart update
    processPartialUpdate($viewer);
}

#
# Draw the chart
#
sub drawChart
{
    my ($viewer) = @_;
    #
    # Validate and adjust the view port dates.
    #

    # Verify if the view port dates are within limits
    my $totalDuration = $endDate - $startDate;
    my $minDuration = $viewer->getZoomInWidthLimit() * $totalDuration;
    if ($viewPortStartDate < $startDate) {
        $viewPortStartDate = $startDate;
    }
    if ($endDate - $viewPortStartDate < $minDuration) {
        $viewPortStartDate = $endDate - $minDuration;
    }
    if ($viewPortEndDate > $endDate) {
        $viewPortEndDate = $endDate;
    }
    if ($viewPortEndDate - $viewPortStartDate < $minDuration) {
        $viewPortEndDate = $viewPortStartDate + $minDuration;
    }

    # Adjust the view port to reflect the selected date range
    $viewer->setViewPortWidth(($viewPortEndDate - $viewPortStartDate) / $totalDuration);
    $viewer->setViewPortLeft(($viewPortStartDate - $startDate) / $totalDuration);

    #
    # Now we have the date range, we can get the necessary data. In this demo, we just use a random
    # number generator. In practice, you may get the data from a database or XML or by other means.
    # (See "Using Data Sources with ChartDirector" in the ChartDirector documentation if you need
    # some sample code on how to read data from database to array variables.)
    #

    # Just a random number generator to generate the data - emulates a table of numbers from
    # startDate to endDate
    my $r = new RanTable(127, 4, int(0.5 + $totalDuration / 86400) + 1);
    $r->setDateCol(0, $startDate, 86400);
    $r->setCol(1, 150, -10, 10);
    $r->setCol(2, 200, -10, 10);
    $r->setCol(3, 250, -10, 10);

    # Emulate selecting the date range viewPortStartDate to viewPortEndDate. Note that we add one
    # day margin on both ends. It is because we are using daily data, but the view port can cover
    # partial days. For example, the view port end date can be at 3:00am Feb 1, 2006. In this case,
    # we need the data point at Feb 2, 2006.
    $r->selectDate(0, $viewPortStartDate - 86400, $viewPortEndDate + 86400);

    # Emulate getting the random data from the table
    my $timeStamps = $r->getCol(0);
    my $dataSeriesA = $r->getCol(1);
    my $dataSeriesB = $r->getCol(2);
    my $dataSeriesC = $r->getCol(3);

    if (scalar(@$timeStamps) >= 520) {
        #
        # Zoomable chart with high zooming ratios often need to plot many thousands of points when
        # fully zoomed out. However, it is usually not needed to plot more data points than the
        # pixel resolution of the chart. Plotting too many points may cause the points and the lines
        # to overlap on the same pixel. So rather than increasing resolution, this reduces the
        # clarity of the chart. It is better to aggregate the data first if there are too many
        # points.
        #
        # In our current example, the chart plot area only has 520 pixels in width and is using a 2
        # pixel line width. So if there are more than 520 data points, we aggregate the data using
        # the ChartDirector aggregation utility method.
        #
        # If in your real application, you do not have too many data points, you may remove the
        # following code altogether.
        #

        # Set up an aggregator to aggregate the data based on regular sized slots
        my $m = new ArrayMath($timeStamps);
        $m->selectRegularSpacing(scalar(@$timeStamps) / 260);

        # For the timestamps, take the first timestamp on each slot
        $timeStamps = $m->aggregate($timeStamps, $perlchartdir::AggregateFirst);

        # For the data values, take the averages
        $dataSeriesA = $m->aggregate($dataSeriesA, $perlchartdir::AggregateAvg);
        $dataSeriesB = $m->aggregate($dataSeriesB, $perlchartdir::AggregateAvg);
        $dataSeriesC = $m->aggregate($dataSeriesC, $perlchartdir::AggregateAvg);
    }

    #
    # Now we have obtained the data, we can plot the chart.
    #

    #================================================================================
    # Step 1 - Configure overall chart appearance.
    #================================================================================

    # Create an XYChart object 600 x 300 pixels in size, with pale blue (0xf0f0ff) background, black
    # (000000) rounded border, 1 pixel raised effect.
    my $c = new XYChart(600, 300, 0xf0f0ff, 0x000000);
    $c->setRoundedFrame();

    # Set the plotarea at (52, 60) and of size 520 x 192 pixels. Use white (ffffff) background.
    # Enable both horizontal and vertical grids by setting their colors to grey (cccccc). Set
    # clipping mode to clip the data lines to the plot area.
    $c->setPlotArea(55, 60, 520, 192, 0xffffff, -1, -1, 0xcccccc, 0xcccccc);
    $c->setClipping();

    # Add a top title to the chart using 15 pts Times New Roman Bold Italic font, with a light blue
    # (ccccff) background, black (000000) border, and a glass like raised effect.
    $c->addTitle("Zooming and Scrolling Demonstration", "timesbi.ttf", 15)->setBackground(0xccccff,
        0x000000, perlchartdir::glassEffect());

    # Add a bottom title to the chart to show the date range of the axis, with a light blue (ccccff)
    # background.
    $c->addTitle2($perlchartdir::Bottom, sprintf(
        "From <*font=arialbi.ttf*>%s<*/font*> to <*font=arialbi.ttf*>%s<*/font*> (Duration ".
        "<*font=arialbi.ttf*>%s<*/font*> days)", $c->formatValue($viewPortStartDate,
        "{value|mmm dd, yyyy}"), $c->formatValue($viewPortEndDate, "{value|mmm dd, yyyy}"), int(0.5
         + ($viewPortEndDate - $viewPortStartDate) / 86400)), "ariali.ttf", 10)->setBackground(
        0xccccff);

    # Add a legend box at the top of the plot area with 9pts Arial Bold font with flow layout.
    $c->addLegend(50, 33, 0, "arialbd.ttf", 9)->setBackground($perlchartdir::Transparent,
        $perlchartdir::Transparent);

    # Set axes width to 2 pixels
    $c->xAxis()->setWidth(2);
    $c->yAxis()->setWidth(2);

    # Add a title to the y-axis
    $c->yAxis()->setTitle("Price (USD)", "arialbd.ttf", 10);

    #================================================================================
    # Step 2 - Add data to chart
    #================================================================================

    #
    # In this example, we represent the data by lines. You may modify the code below if you want to
    # use other representations (areas, scatter plot, etc).
    #

    # Add a line layer for the lines, using a line width of 2 pixels
    my $layer = $c->addLineLayer2();
    $layer->setLineWidth(2);

    # Now we add the 3 data series to a line layer, using the color red (ff0000), green (00cc00) and
    # blue (0000ff)
    $layer->setXData($timeStamps);
    $layer->addDataSet($dataSeriesA, 0xff0000, "Product Alpha");
    $layer->addDataSet($dataSeriesB, 0x00cc00, "Product Beta");
    $layer->addDataSet($dataSeriesC, 0x0000ff, "Product Gamma");

    #================================================================================
    # Step 3 - Set up x-axis scale
    #================================================================================

    # Set x-axis date scale to the view port date range. ChartDirector auto-scaling will
    # automatically determine the ticks on the axis.
    $c->xAxis()->setDateScale($viewPortStartDate, $viewPortEndDate);

    #
    # In the current demo, the x-axis range can be from a few years to a few days. We can let
    # ChartDirector auto-determine the date/time format. However, for more beautiful formatting, we
    # set up several label formats to be applied at different conditions.
    #

    # If all ticks are yearly aligned, then we use "yyyy" as the label format.
    $c->xAxis()->setFormatCondition("align", 360 * 86400);
    $c->xAxis()->setLabelFormat("{value|yyyy}");

    # If all ticks are monthly aligned, then we use "mmm yyyy" in bold font as the first label of a
    # year, and "mmm" for other labels.
    $c->xAxis()->setFormatCondition("align", 30 * 86400);
    $c->xAxis()->setMultiFormat(perlchartdir::StartOfYearFilter(), "<*font=bold*>{value|mmm yyyy}",
        perlchartdir::AllPassFilter(), "{value|mmm}");

    # If all ticks are daily algined, then we use "mmm dd<*br*>yyyy" in bold font as the first label
    # of a year, and "mmm dd" in bold font as the first label of a month, and "dd" for other labels.
    $c->xAxis()->setFormatCondition("align", 86400);
    $c->xAxis()->setMultiFormat(perlchartdir::StartOfYearFilter(),
        "<*block,halign=left*><*font=bold*>{value|mmm dd<*br*>yyyy}",
        perlchartdir::StartOfMonthFilter(), "<*font=bold*>{value|mmm dd}");
    $c->xAxis()->setMultiFormat2(perlchartdir::AllPassFilter(), "{value|dd}");

    # For all other cases (sub-daily ticks), use "hh:nn<*br*>mmm dd" for the first label of a day,
    # and "hh:nn" for other labels.
    $c->xAxis()->setFormatCondition("else");
    $c->xAxis()->setMultiFormat(perlchartdir::StartOfDayFilter(),
        "<*font=bold*>{value|hh:nn<*br*>mmm dd}", perlchartdir::AllPassFilter(), "{value|hh:nn}");

    #================================================================================
    # Step 4 - Set up y-axis scale
    #================================================================================

    if ($viewer->getZoomDirection() == $perlchartdir::DirectionHorizontal) {
        # y-axis is auto-scaled - so vertically, the view port always cover the entire y data range.
        # We save the y-axis scale for supporting xy-zoom mode if needed in the future.
        $c->layout();
        $viewer->setCustomAttr("minValue", $c->yAxis()->getMinValue());
        $viewer->setCustomAttr("maxValue", $c->yAxis()->getMaxValue());
        $viewer->setViewPortTop(0);
        $viewer->setViewPortHeight(1);
    } else {
        # xy-zoom mode - retrieve the auto-scaled axis range, which contains the entire y data
        # range.
        my $minValue = $viewer->getCustomAttr("minValue");
        my $maxValue = $viewer->getCustomAttr("maxValue");

        # Compute the view port axis range
        my $axisLowerLimit = $maxValue - ($maxValue - $minValue) * ($viewer->getViewPortTop() +
            $viewer->getViewPortHeight());
        my $axisUpperLimit = $maxValue - ($maxValue - $minValue) * $viewer->getViewPortTop();

        # Set the axis scale to the view port axis range
        $c->yAxis()->setLinearScale($axisLowerLimit, $axisUpperLimit);

        # By default, ChartDirector will round the axis scale to the tick position. For zooming, we
        # want to use the exact computed axis scale and so we disable rounding.
        $c->yAxis()->setRounding(0, 0);
    }

    #================================================================================
    # Step 5 - Output the chart
    #================================================================================

    # Create the image and save it in a temporary location
    my $chartQuery = $c->makeTmpFile("/tmp/tmpcharts");

    # Include tool tip for the chart
    my $imageMap = $c->getHTMLImageMap("", "",
        "title='[{dataSetName}] {x|mmm dd, yyyy}: USD {value|2}'");

    # Set the chart URL, image map, and chart metrics to the viewer. For the image map, we use
    # delayed delivery and with compression, so the chart image will show up quicker.
    $viewer->setImageUrl("getchart.pl?img=/tmp/tmpcharts/".$chartQuery);
    $viewer->setImageMap("getchart.pl?img=/tmp/tmpcharts/".$viewer->makeDelayedMapAsTmpFile(
        "/tmp/tmpcharts", $imageMap, 1));
    $viewer->setChartMetrics($c->getChartMetrics());
}

#
# A utility to create the <option> tags for the date range <select> boxes
#
# Parameters: startValue: The minimum selectable value. endValue: The maximum selectable value.
# selectedValue: The currently selected value.
#
sub createSelectOptions
{
    my ($startValue, $endValue, $selectedValue) = @_;
    my $ret = [(undef) x ($endValue - $startValue + 1)];
    for(my $i = $startValue; $i < $endValue + 1; ++$i) {
        if ($i == $selectedValue) {
            # Use a "selected" <option> tag if it is the selected value
            $ret->[$i - $startValue] = "<option value='$i' selected>$i</option>";
        } else {
            # Use a normal <option> tag
            $ret->[$i - $startValue] = "<option value='$i'>$i</option>";
        }
    }
    return join("", @$ret);
}

# Create the WebChartViewer object
my $viewer = new WebChartViewer($query, "chart1");
if ($viewer->isPartialUpdateRequest()) {
    # Is a partial update request (AJAX chart update)
    processPartialUpdate($viewer);
    # Since it is a partial update, there is no need to output the entire web page. We stream the
    # chart and then terminate the script immediately.
    print $viewer->partialUpdateChart();
    exit 0;
} elsif ($viewer->isFullUpdateRequest()) {
    # Is a full update request
    processFullUpdate($viewer);
} else {
    # Is a initial request
    createFirstChart($viewer);
}

# Create the <option> tags for the start date / end date select boxes to reflect the currently
# selected data range
my $startYearSelectOptions = createSelectOptions(int(perlchartdir::getChartYMD($startDate) / 10000),
    int(perlchartdir::getChartYMD($endDate) / 10000), int(perlchartdir::getChartYMD(
    $viewPortStartDate) / 10000));
my $startMonthSelectOptions = createSelectOptions(1, 12, int(perlchartdir::getChartYMD(
    $viewPortStartDate) / 100) % 100);
my $startDaySelectOptions = createSelectOptions(1, 31, int(perlchartdir::getChartYMD(
    $viewPortStartDate) % 100));
my $endYearSelectOptions = createSelectOptions(int(perlchartdir::getChartYMD($startDate) / 10000),
    int(perlchartdir::getChartYMD($endDate) / 10000), int(perlchartdir::getChartYMD($viewPortEndDate
    ) / 10000));
my $endMonthSelectOptions = createSelectOptions(1, 12, int(perlchartdir::getChartYMD(
    $viewPortEndDate) / 100) % 100);
my $endDaySelectOptions = createSelectOptions(1, 31, int(perlchartdir::getChartYMD($viewPortEndDate)
     % 100));

print "Content-type: text/html\n\n";
print <<EndOfHTML
<html>
<head>
    <title>ChartDirector Zoom and Scroll Demonstration</title>
    <script type="text/javascript" src="${loadResource}cdjcv.js"></script>
    <style type="text/css">
        div.chartPushButtonSelected { padding:5px; background:#ccffcc; cursor:hand; }
        div.chartPushButton { padding:5px; cursor:hand; }
        td.chartPushButton { font-family:Verdana; font-size:9pt; cursor:pointer; border-bottom:#000000 1px solid; }
    </style>
</head>
<body style="margin:0px" onload="initJsChartViewer()">
<script type="text/javascript">
// Initialize browser side Javascript controls
function initJsChartViewer()
{
    // Check if the Javascript ChartViewer library is loaded
    if (!window.JsChartViewer)
        return;

    // Get the Javascript ChartViewer object
    var viewer = JsChartViewer.get('@{[$viewer->getId()]}');

    // Connect the mouse usage buttons to the Javascript ChartViewer object
    connectViewerMouseUsage('ViewerMouseUsage1', viewer);
    // Connect the xy zoom mode buttons to the Javascript ChartViewer object
    connectViewerZoomControl('ViewerZoomControl1', viewer);

    // Detect if browser is capable of support partial update (AJAX chart update)
    if (JsChartViewer.canSupportPartialUpdate())
    {
        // Browser can support partial update, so connect the view port change event and
        // the submit button to trigger a partial update
        viewer.attachHandler("ViewPortChanged", viewer.partialUpdate);
        document.getElementById('SubmitButton').onclick = function() { viewer.partialUpdate(); return false; };

        // For partial updates, we need to pass the start date / end date select boxes values to/from
        // the server via Javascript ChartViewer custom attributes
        var controlsToSync = ['StartYear', 'StartMonth', 'StartDay', 'EndYear', 'EndMonth', 'EndDay'];
        viewer.attachHandler("PreUpdate", function() { copyToViewer(viewer, controlsToSync); });
        viewer.attachHandler("PostUpdate", function() { copyFromViewer(viewer, controlsToSync); });
    }
    else
        // Browser cannot support partial update - so use full page update
        viewer.attachHandler("ViewPortChanged", function() { document.forms[0].submit(); });
}
// A utility to copy HTML control values to Javascript ChartViewer custom attributes
function copyToViewer(viewer, controlsToSync)
{
    for (var i = 0; i < controlsToSync.length; ++i)
    {
        var obj = document.getElementById(controlsToSync[i]);
        if (obj && !{"button":1, "file":1, "image":1, "reset":1, "submit":1}[obj.type])
        {
            if ((obj.type == "checkbox") || (obj.type == "radio"))
                viewer.setCustomAttr(obj.id, obj.checked ? 1 : 0);
            else
                viewer.setCustomAttr(obj.id, obj.value);
        }
    }
}
// A utility to copy Javascipt ChartViewer custom attributes to HTML controls
function copyFromViewer(viewer, controlsToSync)
{
    for (var i = 0; i < controlsToSync.length; ++i)
    {
        var obj = document.getElementById(controlsToSync[i]);
        if (obj)
        {
            var value = viewer.getCustomAttr(obj.id);
            if (typeof value != "undefined")
            {
                if ((obj.type == "checkbox") || (obj.type == "radio"))
                    obj.checked = parseInt(value);
                else
                    obj.value = value;

                if (obj.validate)
                    obj.validate();
            }
        }
    }
}
</script>
<form method="post">
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
            <!-- The following table is to create 3 cells for 3 buttons. The buttons are used to control
                 the mouse usage mode of the Javascript ChartViewer. -->
            <table id="ViewerMouseUsage1" cellspacing="0" cellpadding="0" width="100%" border="0">
                <tr>
                    <td class="chartPushButton">
                        <div class="chartPushButton" id="ViewerMouseUsage1_Scroll" title="Pointer">
                            <img src="${loadResource}pointer.gif" style="vertical-align:middle" width="16" height="16" alt="Pointer" />&nbsp;&nbsp;Pointer
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="chartPushButton">
                        <div class="chartPushButton" id="ViewerMouseUsage1_ZoomIn" title="Zoom In">
                            <img src="${loadResource}zoomInIcon.gif" style="vertical-align:middle" width="16" height="16" alt="Zoom In" />&nbsp;&nbsp;Zoom In
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="chartPushButton">
                        <div class="chartPushButton" id="ViewerMouseUsage1_ZoomOut" title="Zoom Out">
                            <img src="${loadResource}zoomOutIcon.gif" style="vertical-align:middle" width="16" height="16" alt="Zoom Out" />&nbsp;&nbsp;Zoom Out
                        </div>
                    </td>
                </tr>
            </table>
            <script type="text/javascript">
            // Connect the mouse usage buttons to the Javascript ChartViewer
            function connectViewerMouseUsage(controlId, viewer)
            {
                // A cross browser utility to get the object by id.
                function getObj(id) { return document.getElementById ? document.getElementById(id) : document.all[id]; }

                // Set the button styles (colors) based on the current mouse usage mode of the Javascript ChartViewer
                function syncButtons()
                {
                    getObj(controlId + "_Scroll").className = (viewer.getMouseUsage() == JsChartViewer.Scroll) ?
                        "chartPushButtonSelected" : "chartPushButton";
                    getObj(controlId + "_ZoomIn").className = (viewer.getMouseUsage() == JsChartViewer.ZoomIn) ?
                        "chartPushButtonSelected" : "chartPushButton";
                    getObj(controlId + "_ZoomOut").className = (viewer.getMouseUsage() == JsChartViewer.ZoomOut) ?
                        "chartPushButtonSelected" : "chartPushButton";
                }
                syncButtons();

                // Run syncButtons whenever the Javascript ChartViewer is updated
                viewer.attachHandler("PostUpdate", syncButtons);

                // Set the Javascript ChartViewer mouse usage mode if a button is clicked.
                getObj(controlId + "_Scroll").onclick = function() { viewer.setMouseUsage(JsChartViewer.Scroll); syncButtons(); }
                getObj(controlId + "_ZoomIn").onclick = function() { viewer.setMouseUsage(JsChartViewer.ZoomIn); syncButtons(); }
                getObj(controlId + "_ZoomOut").onclick = function() { viewer.setMouseUsage(JsChartViewer.ZoomOut); syncButtons(); }
            }
            </script>
            <div style="font-size:9pt; margin:15px 5px 0px; font-family:verdana"><b>Zoom Mode</b></div>
            <!-- The following table is to create 2 cells for 2 buttons. The buttons are used to control
                 the zoom/scroll directions of the Javascript ChartViewer. -->
            <table id="ViewerZoomControl1" cellspacing="0" cellpadding="0" width="100%" border="0">
                <tr>
                    <td class="chartPushButton" style="border-bottom: #000000 1px solid; border-top: #000000 1px solid;">
                        <div class="chartPushButton" id="ViewerZoomControl1_Xmode" title="X-Axis zoomable / Y-Axis auto-scaled">
                            <img src="${loadResource}xrange.gif" style="vertical-align:middle" width="16" height="16" alt="X Zoom/Y Auto" />&nbsp;&nbsp;X Zoom / Y Auto
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="chartPushButton" style="border-bottom: #000000 1px solid;">
                        <div class="chartPushButton" id="ViewerZoomControl1_XYmode" title="X-Axis and Y-Axis zoomable">
                            <img src="${loadResource}xyrange.gif" style="vertical-align:middle" width="16" height="16" alt="XY Zoom" />&nbsp;&nbsp;XY Zoom
                        </div>
                    </td>
                </tr>
            </table>
            <script type="text/javascript">
            // Connect the zoom/scroll direction buttons to the Javascript ChartViewer
            function connectViewerZoomControl(controlId, viewer)
            {
                // A cross browser utility to get the object by id.
                function getObj(id) { return document.getElementById ? document.getElementById(id) : document.all[id]; }

                // Set the button styles (colors) based on current zoom/scroll direction settings of the Javascript ChartViewer
                function syncButtons()
                {
                    getObj(controlId + "_Xmode").className = (viewer.getZoomDirection() == JsChartViewer.Horizontal) ?
                        "chartPushButtonSelected" : "chartPushButton";
                    getObj(controlId + "_XYmode").className = (viewer.getZoomDirection() == JsChartViewer.HorizontalVertical) ?
                        "chartPushButtonSelected" : "chartPushButton";
                }
                syncButtons();

                // Run syncButtons whenever the Javascript ChartViewer is updated
                viewer.attachHandler("PostUpdate", syncButtons);

                // Set the Javascript ChartViewer zoom/scroll direction if a button is clicked.
                function setViewerDirection(d)
                {
                    viewer.setScrollDirection(d);
                    viewer.setZoomDirection(d);
                    syncButtons();
                }
                getObj(controlId + "_Xmode").onclick = function() { setViewerDirection(JsChartViewer.Horizontal); }
                getObj(controlId + "_XYmode").onclick = function() { setViewerDirection(JsChartViewer.HorizontalVertical); }
            }
            </script>
            <div style="font-size:9pt; margin:15px 5px 0px; font-family:Verdana">
                <b>Start Time</b><br />
                <table cellspacing="0" cellpadding="0" border="0">
                    <tr>
                        <td style="font-size:8pt; font-family:Arial">Year</td>
                        <td style="font-size:8pt; font-family:Arial">Mon</td>
                        <td style="font-size:8pt; font-family:Arial">Day</td>
                    </tr>
                    <tr>
                        <td><select id="StartYear" name="StartYear" style="width:60">
                            $startYearSelectOptions
                        </select></td>
                        <td><select id="StartMonth" name="StartMonth" style="width:40">
                            $startMonthSelectOptions
                        </select></td>
                        <td><select id="StartDay" name="StartDay" style="width:40">
                            $startDaySelectOptions
                        </select></td>
                    </tr>
                </table>
            </div>
            <div style="font-size:9pt; margin:15px 5px 0px; font-family:Verdana">
                <b>End Time</b><br />
                <table cellspacing="0" cellpadding="0" border="0">
                    <tr>
                        <td style="font-size:8pt; font-family:Arial">Year</td>
                        <td style="font-size:8pt; font-family:Arial">Mon</td>
                        <td style="font-size:8pt; font-family:Arial">Day</td>
                    </tr>
                    <tr>
                        <td><select id="EndYear" name="EndYear" style="width:60">
                            $endYearSelectOptions
                        </select></td>
                        <td><select id="EndMonth" name="EndMonth" style="width:40">
                            $endMonthSelectOptions
                        </select></td>
                        <td><select id="EndDay" name="EndDay" style="width:40">
                            $endDaySelectOptions
                        </select></td>
                    </tr>
                </table>
            </div>
            <script type="text/javascript">
            // A utility to validate the day of month for the start date / end date HTML controls.
            // It sets the day of month select so that it only shows the legal range.
            function validateYMDControls(yearObj, monthObj, dayObj)
            {
                // Get the number of days in a month
                var noOfDays = [31, (parseInt(yearObj.value) % 4 == 0) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
                    [monthObj.selectedIndex];

                // Ensure the selected day of month is not bigger than the days in month
                dayObj.selectedIndex = Math.min(noOfDays - 1, dayObj.selectedIndex);

                // Extend/Shrink the day of month select box to ensure it covers the legal day range
                for (var i = dayObj.options.length; i < noOfDays; ++i)
                    dayObj.options[i] = new Option(i + 1, i + 1);
                for (var j = dayObj.options.length; j > noOfDays; --j)
                    dayObj.remove(j - 1);
            }
            // Initialize the HTML select controls for selecting dates
            function initYMDControls(yearId, monthId, dayId)
            {
                // A cross browser utility to get the object by id.
                var getObj = function(id) { return document.getElementById ? document.getElementById(id) : document.all[id]; }

                // Connect the onchange event to validateYMDControls
                getObj(yearId).onchange = getObj(yearId).validate = getObj(monthId).onchange = getObj(monthId).validate =
                    function() { validateYMDControls(getObj(yearId), getObj(monthId), getObj(dayId)); };

                // Validate once immediately
                getObj(yearId).validate();
            }
            // Connnect the start date / end date HTML select controls
            initYMDControls('StartYear', 'StartMonth', 'StartDay');
            initYMDControls('EndYear', 'EndMonth', 'EndDay');
            </script>
            <div style="margin-top:20px; font-family:Verdana; font-size:9pt; text-align:center">
                <input type="submit" id="SubmitButton" name="SubmitButton" value="Update Chart"></input>
            </div>
        </td>
        <td>
            <div style="font-weight:bold; font-size:20pt; margin:5px 0px 0px 5px; font-family:Arial">
                ChartDirector Zoom and Scroll Demonstration
            </div>
            <hr style="border:solid 1px #000080" />
            <div style="padding:0px 5px 0px 10px">
                <!-- ****** Here is the chart image ****** -->
                @{[$viewer->renderHTML()]}
            </div>
        </td>
    </tr>
</table>
</form>
</body>
</html>
EndOfHTML
;
