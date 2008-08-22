#!/usr/bin/perl -w

use strict;
use CGI qw(:cgi);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
use DBI;
use config;		# this is our database settings
use HTML::Template;
use Digest::MD5 qw(md5);

my $query = new CGI;
my %arguments = $query->Vars;

my $template = HTML::Template->new(
		filename	=>	'register.tmpl',
		associate	=>	$query,		# for argument memory
	);
my %parameters;
if(%arguments) {
	if($arguments{password} ne $arguments{confirm}) {
		$parameters{error} = 'Those passwords do not match!';
	} else {
		my $dbh = DBI->connect("DBI:mysql:$config{dbName}:$config{dbHost}",$config{dbUser},$config{dbPass},{RaiseError => 1});
		my $sth = $dbh->prepare("SELECT count(id) FROM users WHERE UPPER(username) = UPPER(?)");
		$sth->execute($arguments{username});
		my $count;
		$sth->bind_columns(\$count);
		$sth->fetch;
		if($count >= 1) {
			$parameters{error} = 'That username is taken.';
		} else {
			$sth = $dbh->prepare("INSERT INTO users(username,password) VALUES (?,?)");
			$sth->execute($arguments{username},md5('saltgoeshere' . $arguments{password}));
			$parameters{message} = 'Congratulations! You registered successfully!';
			$sth = $dbh->prepare("SELECT LAST_INSERT_ID() FROM users");
			$sth->execute();
			my $userID;
			$sth->bind_columns(\$userID);
			$sth->fetch;
			use stats;
			stats::setStat('atk',$userID,5);
			stats::setStat('def',$userID,5);
			stats::setStat('mag',$userID,5);
		}
	}
}

$template->param(%parameters);
print $query->header(),$template->output();