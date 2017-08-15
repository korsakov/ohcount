perl	comment	#!/usr/bin/perl -w
perl	blank	
perl	comment	# ajaxCheckbox.pl - a script to test Ajax functionality
perl	blank	
perl	code	use strict;
perl	code	use CGI qw/:standard/;     
perl	code	use CGI::Ajax;
perl	code	use DBI;
perl	blank	
perl	comment	# --- database authenication
perl	code	my $dbh = do 'db.inc';
perl	blank	
perl	code	my $query = q{ SELECT project.project_id, project.name, project.phase, prio.prio, 
perl	code		       HEX((255 - prio.prio)) AS hex, begun, tags
perl	code			   FROM project JOIN prio 
perl	code			   ON (project.project_id = prio.project_id)
perl	code			   WHERE completed < 1
perl	code			   ORDER BY prio.prio DESC LIMIT 3};
perl	blank	
perl	code	my $sth = $dbh->prepare($query);
perl	code	$sth->execute();
perl	code	my $result = $dbh->selectall_arrayref($sth);
perl	blank	
perl	code	my $cgi = new CGI;
perl	code	my $pjx = new CGI::Ajax( 'toStruck' => \&perl_func );
perl	code	print $pjx->build_html( $cgi, \&Show_HTML);
perl	blank	
perl	code	sub Show_HTML {
perl	blank	
perl	code	    use CGI qw/:standard/; 
perl	blank	
perl	code	    my $html = <<HEAD;
perl	code	    <!DOCTYPE html
perl	code		PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
perl	code		"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
perl	code		<html xmlns="http://www.w3.org/1999/xhtml" lang="en-US" xml:lang="en-US">
perl	code		<head>
perl	code		<title>This is the lastest source version</title>
perl	code		<link rel="stylesheet" type="text/css" href="/css/carrot.css" />
perl	code		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
perl	code		</head><body>
perl	code		<h2>Carrot Queue</h2><a href="/cgi-bin/source_carrot/index.cgi">Priority List</a><b>&nbsp; | &nbsp;</b>
perl	code		<a href="/cgi-bin/source_carrot/add.cgi">Add a listing</a><b>&nbsp; | &nbsp;</b><div class="content" /><h4>Project listing</h4>
perl	code	HEAD
perl	blank	
perl	code	foreach my $row (@$result) {
perl	code	    $html .= "<input type=\"checkbox\" name=name" . @$row[0] . " id=val" . @$row[0] . " value=\"ON\" onClick=\"toStruck( ['val@$row[0]'], ['div@$row[0]'] );\">";
perl	code	    $html .= "<div id=\"div@$row[0]\" style=\"display: inline;\"><!-- This gets entirely replaced -->" . @$row[1] . "</span></div><br>";
perl	code	}
perl	blank	
perl	comment	# you can append stuff to the HTML this way 
perl	code	$html .= "</body></html>";
perl	blank	
perl	code	return $html;
perl	code	}
perl	blank	
perl	code	sub perl_func {
perl	code	    my 	$input=shift;
perl	blank	
perl	comment	    # if onClick the change the style
perl	code	    if ($input eq "ON") {
perl	code		$input="<span style=\"text-decoration: line-through; display: inline;\">";
perl	code	    } else {
perl	code		$input ="<span style=\"text-decoration: none; display: inline;\">";
perl	code	    } 
perl	code	}
