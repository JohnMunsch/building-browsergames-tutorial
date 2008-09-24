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

if(%arguments) {
	use armorstats;
	if($arguments{sell}) {
		my $armorID = stats::getStat($arguments{sell},$userID);
		$sth = $dbh->prepare("SELECT price FROM items WHERE id = ?");
		$sth->execute($armorID);
		my $price;
		$sth->bind_columns(\$price);
		$sth->fetch;
		my $gold = stats::getStat('gc',$userID);
		stats::setStat('gc',$userID,($gold + $price));
		stats::setStat($arguments{sell},$userID,'');
	} else {
		my $armorID = $arguments{'armor-id'};
		$sth = $dbh->prepare("SELECT price FROM items WHERE id = ?");
		$sth->execute($armorID);
		my $cost;
		$sth->bind_columns(\$cost);
		$sth->fetch;
		my $gold = stats::getStat('gc',$userID);
		if ($gold > $cost) {
			my $slot = armorstats::getArmorStat('aslot',$armorID);
			my $equipped = stats::getStat($slot,$userID);
			if(!$equipped) {
				stats::setStat($slot,$userID,$armorID);
				stats::setStat('gc',$userID,($gold - $cost));
				$parameters{'message'} = 'You purchased and equipped the new armor.';
			} else {
				# they already have something equipped - display an error message
				$parameters{'error'} = 'You are already wearing a piece of that kind of armor! You will need to sell your current armor before you can buy new armor.';
			}
		} else {
			$parameters{'error'} = 'You cannot afford that piece of armor.';
		}
	}
}

$sth = $dbh->prepare("SELECT DISTINCT(id), name, price FROM items WHERE type = 'Armor' ORDER BY RAND() LIMIT 10");
$sth->execute();
my @armor = ();
while(my $row = $sth->fetchrow_hashref) {
	push @armor, $row;
}
$parameters{armor} = \@armor;
my @stats = qw(atorso ahead alegs aright aleft);
$sth = $dbh->prepare("SELECT name FROM items WHERE id = ?");
foreach my $key (@stats) {
	my $id = stats::getStat($key,$userID);
	$sth->execute($id);
	my $name;
	$sth->bind_columns(\$name);
	if($sth->fetch) {
		$parameters{$key} = $name;
	}
	
}

my $template = HTML::Template->new(
		filename	=>	'armor-shop.tmpl',
		associate	=>	$query,
	);
$template->param(%parameters);
print $query->header(), $template->output;