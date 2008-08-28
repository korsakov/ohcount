perl	comment	#!/usr/bin/perl
perl	comment	# Conserve bandwidth - put a copy of Dilbert on your intranet.
perl	comment	# Run every morning with cron - after about 7am Eastern
perl	comment	########################################################
perl	code	use Time::ParseDate;
perl	code	use Time::CTime;
perl	code	use LWP::Simple;
perl	blank	
perl	comment	# Where do you want the image put?
perl	code	$dir="/usr/local/etc/httpd/htdocs/Dilbert";
perl	comment	# $dir = "c:/httpd/htdocs/Dilbert";
perl	code	$location ="$dir/dilbert.gif";
perl	blank	
perl	code	$_ = get("http://www.unitedmedia.com/comics/dilbert/index.html");
perl	blank	
perl	comment	# These next 4 lines will change every time they change the
perl	comment	# page layout on the Dilbert site. Check back on my web site
perl	comment	# if things suddenly stop working
perl	code	s/^.*strip_left\.gif//s;
perl	code	s/^.*?HREF=\"//s;
perl	code	s/\">.*$//s;
perl	code	$line = "http://www.unitedmedia.com" . $_;
perl	blank	
perl	comment	#  Back up yesterday's image:
perl	comment	# get the number
perl	code	open  (ID,"$dir/id");
perl	code	$id=<ID>;
perl	code	close ID;
perl	blank	
perl	code	$id++;
perl	code	$id=~s/\n$//;
perl	code	`mv $location $dir/dilbert.$id.gif`;
perl	comment	# If you're using this on NT, you may want to replace 'mv'
perl	comment	# with 'move'.
perl	blank	
perl	code	open (ID,">$dir/id");
perl	code	print ID "$id";
perl	code	close ID;
perl	blank	
perl	comment	#  Now get the actual image
perl	code	$_ = get($line);
perl	blank	
perl	code	open (FILE, ">$location");
perl	code	binmode FILE; # Important for NT
perl	code	print FILE;
perl	code	close FILE;
perl	blank	
perl	comment	# Now I want to update the index.html file
perl	code	open (FILE, "$dir/index.html");
perl	code	@index=<FILE>;
perl	code	close FILE;
perl	blank	
perl	code	$yesterday = parsedate('yesterday');
perl	code	$printdate = strftime('%a, %b %d', localtime($yesterday));
perl	blank	
perl	code	open (FILE, ">$dir/index.html");
perl	code	for (@index)	{
perl	code	if (/INSERT HERE/)	{
perl	code		print FILE "$_";
perl	code		print FILE "<td><a href=\"dilbert.$id.gif\">$printdate</a></td>\n";
perl	code		if (($id % 5) == 0) {print FILE "</tr><tr>\n"}
perl	code			}
perl	code	else	{print FILE "$_"};
perl	code		}  #  End for
perl	code	close FILE;
perl	blank	
perl	comment	# Start with an index.html file containing ...
perl	comment	# <table border><tr>
perl	comment	# <!-- INSERT HERE -->
perl	comment	# </tr></table>
perl	comment	# ...
perl	comment	#  And whatever else you want on the page.
