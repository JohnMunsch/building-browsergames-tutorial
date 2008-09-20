#!/usr/bin/perl -w
 
use strict;
use CGI qw(:cgi);
use HTML::Template;
use DBI;
use config;
use stats;
 
my $query = new CGI;
my $cookie = $query->cookie('username+password');

my $template = HTML::Template->new(
		filename	=>	'bank.tmpl',
	);
my %parameters;
 
my ($username) = split(/\+/,$cookie);
my $dbh = DBI->connect("DBI:mysql:$config{dbName}:$config{dbHost}",$config{dbUser},$config{dbPass},{RaiseError => 1});
my $sth = $dbh->prepare("SELECT id FROM users WHERE UPPER(username) = UPPER(?)");
$sth->execute($username);
my $userID;
$sth->bind_columns(\$userID);
$sth->fetch;

my $gold = stats::getStat('gc',$userID);
my %arguments = $query->Vars;
if(%arguments) {
	my $amount = $arguments{amount};
	if($arguments{action} eq 'Deposit') {
		if($amount > $gold || $amount eq '') {
			# weird input - assume maximum
			$amount = $gold;	
		}
		$amount = abs($amount);
		stats::setStat('gc',$userID,stats::getStat('gc',$userID) - $amount);
		stats::setStat('bankgc',$userID,stats::getStat('bankgc',$userID) + $amount);
		$parameters{deposited} = $amount;	
	} else {
		my $bankGold = stats::getStat('bankgc',$userID);
		if($amount > $bankGold || $amount == '') {
			# weird input - assume maximum
			$amount = $bankGold;	
		}
		stats::setStat('gc',$userID,stats::getStat('gc',$userID) + $amount);
		stats::setStat('bankgc',$userID,stats::getStat('bankgc',$userID) - $amount);
		$parameters{withdrawn} = $amount;
	}	
}

$parameters{inbank} = stats::getStat('bankgc',$userID);
$parameters{gold} = stats::getStat('gc',$userID);

$template->param(%parameters);
print $query->header(), $template->output;