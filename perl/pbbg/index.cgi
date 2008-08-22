#!/usr/bin/perl -w
 
use strict;
use CGI qw(:cgi);
use HTML::Template;

require login;

my $query = new CGI;
my $cookie = $query->cookie('username+password');
 
my ($username) = split(/\+/,$cookie);
use DBI;
use config;
my $dbh = DBI->connect("DBI:mysql:$config{dbName}:$config{dbHost}",$config{dbUser},$config{dbPass},{RaiseError => 1});
my $sth = $dbh->prepare("SELECT id FROM users WHERE UPPER(username) = UPPER(?)");
$sth->execute($username);
my $userID;
$sth->bind_columns(\$userID);
$sth->fetch;
use stats;
my %stats;
$stats{attack} = stats::getStat('atk',$userID);
$stats{defence} = stats::getStat('def',$userID);
$stats{magic} = stats::getStat('mag',$userID);
$stats{gold} = stats::getStat('gc',$userID);
my $setHP = stats::getStat('sethp',$userID);
if($setHP == 0) {
	# haven't set up the user's HP - set to defaults
	stats::setStat('curhp',$userID,10);
	stats::setStat('maxhp',$userID,10);
	stats::setStat('sethp',$userID,1);	
}
$stats{current_hp} = stats::getStat('curhp',$userID);
$stats{maximum_hp} = stats::getStat('maxhp',$userID);

my $template = HTML::Template->new(
		filename	=>	'index.tmpl',
	);
$template->param(username	=>	$username,%stats);
print $query->header(), $template->output;