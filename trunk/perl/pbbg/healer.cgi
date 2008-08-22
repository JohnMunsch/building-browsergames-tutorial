#!/usr/bin/perl -w
 
use strict;
use CGI qw(:cgi);
use HTML::Template;
use DBI;
use config;
use stats;
 
my $query = new CGI;
my %arguments = $query->Vars;
my $cookie = $query->cookie('username+password');

my $template = HTML::Template->new(
		filename	=>	'healer.tmpl',
	);
my %parameters;
 
my ($username) = split(/\+/,$cookie);
my $dbh = DBI->connect("DBI:mysql:$config{dbName}:$config{dbHost}",$config{dbUser},$config{dbPass},{RaiseError => 1});
my $sth = $dbh->prepare("SELECT id FROM users WHERE UPPER(username) = UPPER(?)");
$sth->execute($username);
my $userID;
$sth->bind_columns(\$userID);
$sth->fetch;

if(%arguments) {
	my $amount = $arguments{amount};
	my $gold = stats::getStat('gc',$userID);
	my $needed = stats::getStat('maxhp',$userID) - stats::getStat('curhp',$userID);	
	if($amount > $needed || $amount eq '') {
		$amount = $needed;	
	}
	if($amount > $gold) {
		$amount = $gold;	
	}
	stats::setStat('gc',$userID,stats::getStat('gc',$userID) - $amount);
	stats::setStat('curhp',$userID,stats::getStat('curhp',$userID) + $amount);
	$parameters{healed} = $amount;
}

$parameters{gold} = stats::getStat('gc',$userID);
$parameters{curhp} = stats::getStat('curhp',$userID);
$parameters{maxhp} = stats::getStat('maxhp',$userID);

$template->param(%parameters);
print $query->header(), $template->output;