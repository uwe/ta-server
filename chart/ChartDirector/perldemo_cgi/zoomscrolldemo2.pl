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
# Copyright 2006 Advanced Software Engineering Limited
#
# You may use and modify the sample code in this file in your application, provided the Sample Code
# and its modifications are used only in conjunction with ChartDirector. Usage of this software is
# subjected to the terms and condition of the ChartDirector license.
#

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

#
# Handles the initial request
#
sub createFirstChart
{
    my ($viewer) = @_;
    # Initialize the Javascript ChartViewer
    $viewer->setScrollDirection($perlchartdir::DirectionHorizontalVertical);
    $viewer->setZoomDirection($perlchartdir::DirectionHorizontalVertical);
    $viewer->setMouseUsage($perlchartdir::MouseUsageScroll);

    # Draw the chart
    drawChart($viewer);
}

#
# Handles partial update (AJAX chart update)
#
sub processPartialUpdate
{
    my ($viewer) = @_;
    # In this demo, we just need to redraw the chart
    drawChart($viewer);
}

#
# Handles full update
#
sub processFullUpdate
{
    my ($viewer) = @_;
    # In this demo, we just need to redraw the chart
    drawChart($viewer);
}

#
# Draw the chart
#
sub drawChart
{
    my ($viewer) = @_;
    #
    # For simplicity, in this demo, we just use hard coded data. In a real application, the data may
    # come from a dynamic source such as a database. (See "Using Data Sources with ChartDirector" in
    # the ChartDirector documentation if you need some sample code on how to read data from database
    # to array variables.)
    #
    my $dataX0 = [10, 15, 6, -12, 14, -8, 13, -3, 16, 12, 10.5, -7, 3, -10, -5, 2, 5];
    my $dataY0 = [130, 150, 80, 110, -110, -105, -130, -15, -170, 125, 125, 60, 25, 150, 150, 15,
        120];
    my $dataX1 = [6, 7, -4, 3.5, 7, 8, -9, -10, -12, 11, 8, -3, -2, 8, 4, -15, 15];
    my $dataY1 = [65, -40, -40, 45, -70, -80, 80, 10, -100, 105, 60, 50, 20, 170, -25, 50, 75];
    my $dataX2 = [-10, -12, 11, 8, 6, 12, -4, 3.5, 7, 8, -9, 3, -13, 16, -7.5, -10, -15];
    my $dataY2 = [65, -80, -40, 45, -70, -80, 80, 90, -100, 105, 60, -75, -150, -40, 120, -50, -30];

    # Create an XYChart object 500 x 480 pixels in size, with light blue (c0c0ff) as background
    # color
    my $c = new XYChart(500, 480, 0xc0c0ff);

    # Set the plotarea at (50, 40) and of size 400 x 400 pixels. Use light grey (c0c0c0) horizontal
    # and vertical grid lines. Set 4 quadrant coloring, where the colors of the quadrants alternate
    # between lighter and deeper grey (dddddd/eeeeee).
    $c->setPlotArea(50, 40, 400, 400, -1, -1, -1, 0xc0c0c0, 0xc0c0c0)->set4QBgColor(0xdddddd,
        0xeeeeee, 0xdddddd, 0xeeeeee, 0x000000);

    # Enable clipping mode to clip the part of the data that is outside the plot area.
    $c->setClipping();

    # Set 4 quadrant mode, with both x and y axes symetrical around the origin
    $c->setAxisAtOrigin($perlchartdir::XYAxisAtOrigin, $perlchartdir::XAxisSymmetric +
        $perlchartdir::YAxisSymmetric);

    # Add a legend box at (450, 40) (top right corner of the chart) with vertical layout and 8 pts
    # Arial Bold font. Set the background color to semi-transparent grey (40dddddd).
    my $legendBox = $c->addLegend(450, 40, 1, "arialbd.ttf", 8);
    $legendBox->setAlignment($perlchartdir::TopRight);
    $legendBox->setBackground(0x40dddddd);

    # Add titles to axes
    $c->xAxis()->setTitle("Alpha Index");
    $c->yAxis()->setTitle("Beta Index");

    # Set axes line width to 2 pixels
    $c->xAxis()->setWidth(2);
    $c->yAxis()->setWidth(2);

    # The default ChartDirector settings has a denser y-axis grid spacing and less-dense x-axis grid
    # spacing. In this demo, we want the tick spacing to be symmetrical. We use around 40 pixels
    # between major ticks and 20 pixels between minor ticks.
    $c->xAxis()->setTickDensity(40, 20);
    $c->yAxis()->setTickDensity(40, 20);

    #
    # In this example, we represent the data by scatter points. If you want to represent the data by
    # somethings else (lines, bars, areas, floating boxes, etc), just modify the code below to use
    # the layer type of your choice.
    #

    # Add scatter layer, using 11 pixels red (ff33333) X shape symbols
    $c->addScatterLayer($dataX0, $dataY0, "Group A", perlchartdir::Cross2Shape(), 11, 0xff3333);

    # Add scatter layer, using 11 pixels green (33ff33) circle symbols
    $c->addScatterLayer($dataX1, $dataY1, "Group B", $perlchartdir::CircleShape, 11, 0x33ff33);

    # Add scatter layer, using 11 pixels blue (3333ff) triangle symbols
    $c->addScatterLayer($dataX2, $dataY2, "Group C", $perlchartdir::TriangleSymbol, 11, 0x3333ff);

    if (!defined($viewer->getCustomAttr("minY")) || ($viewer->getCustomAttr("minY") eq "")) {
        # The axis scale has not yet been set up. This means this is the first time the chart is
        # drawn and it is drawn with no zooming. We can use auto-scaling to determine the
        # axis-scales, then remember them for future use.

        # explicitly auto-scale axes so we can get the axis scales
        $c->layout();

        # save the axis scales for future use
        $viewer->setCustomAttr("minX", $c->xAxis()->getMinValue());
        $viewer->setCustomAttr("maxX", $c->xAxis()->getMaxValue());
        $viewer->setCustomAttr("minY", $c->yAxis()->getMinValue());
        $viewer->setCustomAttr("maxY", $c->yAxis()->getMaxValue());
    } else {
        # Retrieve the original full axes scale
        my $minX = $viewer->getCustomAttr("minX");
        my $maxX = $viewer->getCustomAttr("maxX");
        my $minY = $viewer->getCustomAttr("minY");
        my $maxY = $viewer->getCustomAttr("maxY");

        # Compute the zoomed-in axis scales by multiplying the full axes scale with the view port
        # ratio
        my $xScaleMin = $minX + ($maxX - $minX) * $viewer->getViewPortLeft();
        my $xScaleMax = $minX + ($maxX - $minX) * ($viewer->getViewPortLeft() +
            $viewer->getViewPortWidth());
        my $yScaleMax = $maxY - ($maxY - $minY) * $viewer->getViewPortTop();
        my $yScaleMin = $maxY - ($maxY - $minY) * ($viewer->getViewPortTop() +
            $viewer->getViewPortHeight());

        # Set the axis scales
        $c->xAxis()->setLinearScale($xScaleMin, $xScaleMax);
        $c->yAxis()->setLinearScale($yScaleMin, $yScaleMax);

        # By default, ChartDirector will round the axis scale to the tick position. For zooming, we
        # want to use the exact computed axis scale and so we disable rounding.
        $c->xAxis()->setRounding(0, 0);
        $c->yAxis()->setRounding(0, 0);
    }

    # Create the image
    my $chartQuery = $c->makeTmpFile("/tmp/tmpcharts");

    # Include tool tip for the chart
    my $imageMap = $c->getHTMLImageMap("", "",
        "title='[{dataSetName}] Alpha = {x|G}, Beta = {value|G}'");

    # Set the chart URL, image map, and chart metrics to the viewer
    $viewer->setImageUrl("getchart.pl?img=/tmp/tmpcharts/".$chartQuery);
    $viewer->setImageMap($imageMap);
    $viewer->setChartMetrics($c->getChartMetrics());
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

print "Content-type: text/html\n\n";
print <<EndOfHTML
<html>
<head>
    <title>ChartDirector Zoom and Scroll Demonstration (2)</title>
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

    // Connect the view port window navigation pad to the Javascript ChartViewer object
    connectViewerViewPort('ViewerViewPort1', viewer);

    // Detect if browser is capable of support partial update (AJAX chart update)
    if (JsChartViewer.canSupportPartialUpdate())
        // Browser can support partial update, so connect the view port change event to
        // trigger a partial update
        viewer.attachHandler("ViewPortChanged", viewer.partialUpdate);
    else
        // Browser cannot support partial update - so use full page update
        viewer.attachHandler("ViewPortChanged", function() { document.forms[0].submit(); });
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
        <td style="width:130px; background:#e0e0e0; border-left:black 1px solid; border-top:black 1px solid; border-bottom:black 1px solid;">
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

                // Set the button styles (colors) based on mouse usage mode
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

                // Set the Javascript ChartViewer mouse usage mode if the buttons are clicked.
                getObj(controlId + "_Scroll").onclick = function() { viewer.setMouseUsage(JsChartViewer.Scroll); syncButtons(); }
                getObj(controlId + "_ZoomIn").onclick = function() { viewer.setMouseUsage(JsChartViewer.ZoomIn); syncButtons(); }
                getObj(controlId + "_ZoomOut").onclick = function() { viewer.setMouseUsage(JsChartViewer.ZoomOut); syncButtons(); }
            }
            </script>
            <br /><br /><br /><br />
            <!-- The following DIV blocks constitute the view port navigation pad. -->
            <div id="ViewerViewPort1" style="margin: 10px 5px; text-align: center">
                <div style="border:black 1px solid; padding:0px; margin:0px; width:120px; height:120px; background-color:#c0c0ff;
                    text-align:left">
                    <div id="ViewerViewPort1_ViewPort" style="border:black 1px solid; padding:0px; margin:0px; visibility:hidden;
                        width:60px; height:60px; position:relative; background-color:#c0c0c0">
                        <img src="" style="display:none" height="1" width="1" alt="" />
                    </div>
                </div>
            </div>
            <script type="text/javascript">
            // Connect the view port navigation pad to the Javascript ChartViewer
            function connectViewerViewPort(controlId, viewer)
            {
                // A cross browser utility to get the object by id.
                function getObj(id) { return document.getElementById ? document.getElementById(id) : document.all[id]; }

                // Get the inner rectangle representing the visible view port
                var p = getObj(controlId + "_ViewPort");

                // Set up the mouse down event handler
                p.onmousedown = ViewerViewPort_startDrag;
                p.viewer = viewer;

                // Remember the width and height of the outer container of the navigation pad. The exact definition of
                // width and height differs depending on browsers (some includes the borders and some exclude the borders).
                var parent = p.parentElement || p.parentNode;
                p.parentW = parent.offsetWidth - (document.all ? 2 : 4);
                p.parentH = parent.offsetHeight - (document.all ? 2 : 4);

                // Connect the view port to the viewer PostUpdate handler
                connectViewPortHandler(controlId, viewer);

                // The navigation pad has been set up, so can display it now.
                p.style.visibility = "visible";
            }
            // Connect the view port to the viewer PostUpdate handler
            function connectViewPortHandler(controlId, viewer)
            {
                // Set the navigation pad size and position depending on the Javascript ChartViewer view port state
                var syncViewPort = function()
                {
                    // A cross browser utility to get the object by id.
                    function getObj(id) { return document.getElementById ? document.getElementById(id) : document.all[id]; }

                    // Get the inner rectangle representing the visible view port
                    var p = getObj(controlId + "_ViewPort");

                    // Set the size and position based on Javascript ChartViewer view port state
                    p.currentWidth = p.style.width = Math.round(p.parentW * viewer.getViewPortWidth());
                    p.currentHeight = p.style.height = Math.round(p.parentH * viewer.getViewPortHeight());
                    p.currentX = p.style.left = Math.round(p.parentW * viewer.getViewPortLeft());
                    p.currentY = p.style.top = Math.round(p.parentH * viewer.getViewPortTop());
                }
                syncViewPort();

                // Run syncViewPort whenever the Javascript ChartViewer is updated
                viewer.attachHandler("PostUpdate", syncViewPort);
            }
            // Mouse down event handler
            function ViewerViewPort_startDrag(e)
            {
                if (document.onmousemove != ViewerViewPort_mouseMove)
                {
                    // Remember the current onmousemove and onmouseup event handler and replace them
                    // with our own handler
                    document.ViewerViewPort_onmousemovesave = document.onmousemove;
                    document.ViewerViewPort_onmouseupsave = document.onmouseup;
                    document.onmousemove = ViewerViewPort_mouseMove;
                    document.onmouseup = ViewerViewPort_endDrag;
                }

                // Remember the mouse down position
                document.ViewerViewPort_dragObj = this;
                this.refX = this.currentX - (window.event || e).clientX;
                this.refY = this.currentY - (window.event || e).clientY;
            }
            // Mouse move event handler
            function ViewerViewPort_mouseMove(e)
            {
                // Set the position of the navigation pad depending on how far the mouse has been dragged
                var obj = document.ViewerViewPort_dragObj;
                obj.currentX = obj.style.left =
                    Math.max(0, Math.min(obj.refX + (window.event || e).clientX, obj.parentW - obj.currentWidth));
                obj.currentY = obj.style.top =
                    Math.max(0, Math.min(obj.refY + (window.event || e).clientY, obj.parentH - obj.currentHeight));
                return false;
            }
            // Mouse up event handler
            function ViewerViewPort_endDrag(e)
            {
                // Restore the previous nmousemove and onmouseup event handler
                document.onmousemove = document.ViewerViewPort_onmousemovesave;
                document.onmouseup = document.ViewerViewPort_onmouseupsave;

                // Set the new view port position based on the mouse position
                var newVpLeft = 0;
                var newVpTop = 0;
                var obj = document.ViewerViewPort_dragObj;
                if (obj.viewer.getViewPortWidth() < 1)
                    newVpLeft = obj.currentX / (obj.parentW - obj.currentWidth) * (1 - obj.viewer.getViewPortWidth());
                if (obj.viewer.getViewPortHeight() < 1)
                    newVpTop = obj.currentY / (obj.parentH - obj.currentHeight) * (1 - obj.viewer.getViewPortHeight());

                // Change the view port only when the new view port position is really different from
                // existing position (to avoid unnecessary partial or full update)
                if ((Math.abs(obj.viewer.getViewPortLeft() - newVpLeft) > 0.0000001) ||
                    (Math.abs(obj.viewer.getViewPortTop() - newVpTop) > 0.0000001))
                {
                    obj.viewer.setViewPortLeft(newVpLeft);
                    obj.viewer.setViewPortTop(newVpTop);
                    obj.viewer.applyHandlers("ViewPortChanged");
                }
            }
            </script>
        </td>
        <td style="border: black 1px solid; background-color: #c0c0ff">
            <div style="padding:5px">
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
