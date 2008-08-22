#!/usr/bin/perl -w
 
use strict;
use CGI qw(:cgi);
 
my $query = new CGI;
my $logout = $query->cookie(
	-name		=>	'username+password',
	-value		=>	'',
	-expires	=>	'-3M',
);
print $query->redirect(-cookie=>$logout,-uri=>'http://buildingbrowsergames.com/game/index.html');
