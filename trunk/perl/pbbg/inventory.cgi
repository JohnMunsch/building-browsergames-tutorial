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

my %actions = (
	'potion' => \&use_potion,
	'crystal_ball'	=>	\&use_crystal_ball,
);

sub use_crystal_ball {
	$parameters{message} = 'This is code that would run if the user used a crystal ball.';
}

sub use_potion {
	$parameters{message} = 'This is code that would run if the user used a potion.';
}

if(%arguments) {
	if($arguments{'item-id'}) {
		use items;
		$sth = $dbh->prepare("SELECT item_id FROM user_items WHERE user_id = ? AND id = ?");
		$sth->execute($userID,$arguments{'item-id'});
		my $itemID;
		$sth->bind_columns(\$itemID);
		$sth->fetch;
		my $token = items::getStat('token',$itemID);
		$actions{$token}->();
	}
}

$sth = $dbh->prepare("SELECT id, item_id, quantity FROM user_items WHERE user_id = ?");
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

my $template = HTML::Template->new(
		filename	=>	'inventory.tmpl',
		associate	=>	$query,
		die_on_bad_params => 0,
	);
$template->param(%parameters);
print $query->header(), $template->output;