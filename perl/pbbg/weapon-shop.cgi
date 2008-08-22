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
	if($arguments{sell}) {
		my $weaponID = stats::getStat($arguments{sell},$userID);
		$sth = $dbh->prepare("SELECT price FROM items WHERE id = ?");
		$sth->execute($weaponID);
		my $cost;
		$sth->bind_columns(\$cost);
		$sth->fetch;
		my $gold = stats::getStat('gc',$userID);
		stats::setStat('gc',$userID,($gold + $cost));
		stats::setStat($arguments{sell},$userID,'');
		$shand = stats::getStat('shand',$userID);
		$phand = stats::getStat('phand',$userID);
	} else {
		my $weaponID = $arguments{'weapon-id'};
		$sth = $dbh->prepare("SELECT price FROM items WHERE id = ?");
		$sth->execute($weaponID);
		my $cost;
		$sth->bind_columns(\$cost);
		$sth->fetch;
		my $gold = stats::getStat('gc',$userID);
		if($gold >= $cost) {
			if(!$phand) {
				stats::setStat('phand',$userID,$weaponID);
				stats::setStat('gc',$userID,($gold - $cost));
				$phand = $weaponID;
				$parameters{message} = 'You equipped the weapon in your primary hand.';
			} else {
				if(!$shand) {
					stats::setStat('shand',$userID,$weaponID);
					stats::setStat('gc',$userID,($gold - $cost));
					$shand = $weaponID;
					$parameters{message} = 'You equipped the weapon in your secondary hand.';
				} else {
					$parameters{error} = 'You already have two weapons! You must sell one before equipping another.';
				}
			}
		} else {
			$parameters{error} = 'You cannot afford that weapon!';
		}
	}
}

$sth = $dbh->prepare("SELECT DISTINCT(id), name, price FROM items WHERE type = 'Weapon' LIMIT 5");
$sth->execute();
my @weapons = ();
while(my $row = $sth->fetchrow_hashref) {
	push @weapons, $row;
}

$parameters{weapons} = \@weapons;

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
		filename	=>	'weapon-shop.tmpl',
		associate	=>	$query,
	);
$template->param(%parameters);
print $query->header(), $template->output;