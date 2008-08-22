#!/usr/bin/perl -w
 
use strict;
use CGI qw(:cgi);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
use HTML::Template;
use DBI;
use config;
 
my $query = new CGI;
my %arguments = $query->Vars;

my $dbh = DBI->connect("DBI:mysql:$config{dbName}:$config{dbHost}",$config{dbUser},$config{dbPass},{RaiseError => 1});
my $sth;
my %parameters;

use stats;

my $cookie = $query->cookie('username+password');
my ($username) = split(/\+/,$cookie);
$sth = $dbh->prepare("SELECT id FROM users WHERE UPPER(username) = UPPER(?)");
$sth->execute($username);
my $userID;
$sth->bind_columns(\$userID);
$sth->fetch;

my $phand = stats::getStat('phand',$userID);
my $shand = stats::getStat('shand',$userID);
if(%arguments) {
	stats::setStat('phand',$userID,$shand);
	stats::setStat('shand',$userID,$phand);
	my $temp = $shand;
	$shand = $phand;
	$phand = $temp;	
}

$sth = $dbh->prepare("SELECT name FROM items WHERE id = ?");
$sth->execute($phand);
my $phand_name;
$sth->bind_columns(\$phand_name);
$sth->fetch;
if($phand_name) {
	$parameters{phand} = $phand_name;
}

# $sth is already prepared, so all we do is re-execute
$sth->execute($shand);
my $shand_name;
$sth->bind_columns(\$shand_name);
$sth->fetch;
$parameters{shand} = $shand_name if $shand_name;
my $template = HTML::Template->new(
		filename	=>	'equipment.tmpl',
		associate	=>	$query,
	);
$template->param(%parameters);
print $query->header(), $template->output;