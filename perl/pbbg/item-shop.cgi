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
	my $price;
	my $itemID;
	$itemID = $arguments{'item-id'} ? $arguments{'item-id'} : $arguments{sell};
	$sth = $dbh->prepare("SELECT price FROM items WHERE id = ?");
	$sth->execute($itemID);
	$sth->bind_columns(\$price);
	$sth->fetch;
	my $gold = stats::getStat('gc',$userID);
	if($arguments{'item-id'}) {
		if($gold >= $price) {
			stats::setStat('gc',$userID,($gold - $price));
			$sth = $dbh->prepare("SELECT count(id) FROM user_items WHERE user_id = ? AND item_id = ?");
			$sth->execute($userID,$itemID);
			my $count;
			$sth->bind_columns(\$count);
			$sth->fetch;
			if($count > 0) {
				# already has one of the item
				$sth = $dbh->prepare("UPDATE user_items SET quantity = quantity + 1 WHERE user_id = ? AND item_id = ?");
			} else {
				# has none of the item - new row
				$sth = $dbh->prepare("INSERT INTO user_items(quantity,user_id,item_id) VALUES (1,?,?)");
			}
			$sth->execute($userID,$itemID);
			$parameters{message} = 'You purchased the item.';
		} else {
			$parameters{error} = 'You cannot afford that item!';
		}		
	} elsif($arguments{sell}) {
		stats::setStat('gc',$userID,($gold + $price));
		$sth = $dbh->prepare("SELECT quantity FROM user_items WHERE user_id = ? AND item_id = ?");
		$sth->execute($userID,$itemID);
		my $quantity;
		$sth->bind_columns(\$quantity);
		$sth->fetch;
		if($quantity > 1) {
			$sth = $dbh->prepare("UPDATE user_items SET quantity = quantity - 1 WHERE user_id = ? AND item_id = ?");
		} else {
			$sth = $dbh->prepare("DELETE FROM user_items WHERE user_id = ? AND item_id = ?");
		}
		$sth->execute($userID,$itemID);
		$parameters{message} = 'You sold the item.';
	}
}

$sth = $dbh->prepare("SELECT DISTINCT(id), name, price FROM items WHERE type = 'Usable' LIMIT 5");
$sth->execute();
my @items = ();
while(my $row = $sth->fetchrow_hashref) {
	push @items, $row;
}

$sth = $dbh->prepare("SELECT item_id, quantity FROM user_items WHERE user_id = ?");
$sth->execute($userID);
my @inventory = ();
while(my $row = $sth->fetchrow_hashref) {
	my $sth2 = $dbh->prepare("SELECT name FROM items WHERE id = ?");
	$sth2->execute($row->{item_id});
	$sth2->bind_columns(\$row->{name});
	$sth2->fetch;
	push @inventory, $row;
}

$parameters{inventory} = \@inventory;
$parameters{items} = \@items;

my $template = HTML::Template->new(
		filename	=>	'item-shop.tmpl',
		associate	=>	$query,
	);
$template->param(%parameters);
print $query->header(), $template->output;