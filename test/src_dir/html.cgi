#!/usr/bin/perl -w

# ajaxCheckbox.pl - a script to test Ajax functionality

use strict;
use CGI qw/:standard/;     
use CGI::Ajax;
use DBI;

# --- database authenication
my $dbh = do 'db.inc';

my $query = q{ SELECT project.project_id, project.name, project.phase, prio.prio, 
	       HEX((255 - prio.prio)) AS hex, begun, tags
		   FROM project JOIN prio 
		   ON (project.project_id = prio.project_id)
		   WHERE completed < 1
		   ORDER BY prio.prio DESC LIMIT 3};

my $sth = $dbh->prepare($query);
$sth->execute();
my $result = $dbh->selectall_arrayref($sth);

my $cgi = new CGI;
my $pjx = new CGI::Ajax( 'toStruck' => \&perl_func );
print $pjx->build_html( $cgi, \&Show_HTML);

sub Show_HTML {

    use CGI qw/:standard/; 

    my $html = <<HEAD;
    <!DOCTYPE html
	PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml" lang="en-US" xml:lang="en-US">
	<head>
	<title>This is the lastest source version</title>
	<link rel="stylesheet" type="text/css" href="/css/carrot.css" />
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	</head><body>
	<h2>Carrot Queue</h2><a href="/cgi-bin/source_carrot/index.cgi">Priority List</a><b>&nbsp; | &nbsp;</b>
	<a href="/cgi-bin/source_carrot/add.cgi">Add a listing</a><b>&nbsp; | &nbsp;</b><div class="content" /><h4>Project listing</h4>
HEAD

foreach my $row (@$result) {
    $html .= "<input type=\"checkbox\" name=name" . @$row[0] . " id=val" . @$row[0] . " value=\"ON\" onClick=\"toStruck( ['val@$row[0]'], ['div@$row[0]'] );\">";
    $html .= "<div id=\"div@$row[0]\" style=\"display: inline;\"><!-- This gets entirely replaced -->" . @$row[1] . "</span></div><br>";
}

# you can append stuff to the HTML this way 
$html .= "</body></html>";

return $html;
}

sub perl_func {
    my 	$input=shift;

    # if onClick the change the style
    if ($input eq "ON") {
	$input="<span style=\"text-decoration: line-through; display: inline;\">";
    } else {
	$input ="<span style=\"text-decoration: none; display: inline;\">";
    } 
}
