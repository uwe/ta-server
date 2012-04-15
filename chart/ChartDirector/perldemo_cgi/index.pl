#!/usr/bin/perl
print "Content-type: text/html\n\n";
print <<EndOfHTML
<html>
<head>
<title>ChartDirector Ver 5.0 Sample Programs</title>
</head>
<frameset rows="19,*" framespacing="0">
    <frame
        name="indextop"
        src="indextop.pl"
        scrolling="no"
        frameborder="1"
    />
    <frameset cols="222,*" framespacing="0">
        <frame
            name="indexleft"
            src="indexleft.pl"
            scrolling="auto"
            frameborder="1"
        />
        <frame
            name="indexright"
            src="indexright.pl"
            scrolling="auto"
            frameborder="1"
        />
    </frameset>
</frameset>
</html>
EndOfHTML
;
