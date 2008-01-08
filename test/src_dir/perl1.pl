#!/usr/bin/perl
# Conserve bandwidth - put a copy of Dilbert on your intranet.
# Run every morning with cron - after about 7am Eastern
########################################################
use Time::ParseDate;
use Time::CTime;
use LWP::Simple;

# Where do you want the image put?
$dir="/usr/local/etc/httpd/htdocs/Dilbert";
# $dir = "c:/httpd/htdocs/Dilbert";
$location ="$dir/dilbert.gif";

$_ = get("http://www.unitedmedia.com/comics/dilbert/index.html");

# These next 4 lines will change every time they change the
# page layout on the Dilbert site. Check back on my web site
# if things suddenly stop working
s/^.*strip_left\.gif//s;
s/^.*?HREF=\"//s;
s/\">.*$//s;
$line = "http://www.unitedmedia.com" . $_;

#  Back up yesterday's image:
# get the number
open  (ID,"$dir/id");
$id=<ID>;
close ID;

$id++;
$id=~s/\n$//;
`mv $location $dir/dilbert.$id.gif`;
# If you're using this on NT, you may want to replace 'mv'
# with 'move'.

open (ID,">$dir/id");
print ID "$id";
close ID;

#  Now get the actual image
$_ = get($line);

open (FILE, ">$location");
binmode FILE; # Important for NT
print FILE;
close FILE;

# Now I want to update the index.html file
open (FILE, "$dir/index.html");
@index=<FILE>;
close FILE;

$yesterday = parsedate('yesterday');
$printdate = strftime('%a, %b %d', localtime($yesterday));

open (FILE, ">$dir/index.html");
for (@index)	{
if (/INSERT HERE/)	{
	print FILE "$_";
	print FILE "<td><a href=\"dilbert.$id.gif\">$printdate</a></td>\n";
	if (($id % 5) == 0) {print FILE "</tr><tr>\n"}
		}
else	{print FILE "$_"};
	}  #  End for
close FILE;

# Start with an index.html file containing ...
# <table border><tr>
# <!-- INSERT HERE -->
# </tr></table>
# ...
#  And whatever else you want on the page.
