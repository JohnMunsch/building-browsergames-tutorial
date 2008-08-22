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
		filename	=>	'login.tmpl',
		associate	=>	$query,		# for argument memory
	);
my %parameters;
 
if(%arguments) {
	my $dbh = DBI->connect("DBI:mysql:$config{dbName}:$config{dbHost}",$config{dbUser},$config{dbPass},{RaiseError => 1});
	my $sth = $dbh->prepare("SELECT COUNT(id) FROM users WHERE UPPER(username) = UPPER(?) AND password = ?");
	my $count;
	$sth->execute($arguments{username},crypt($arguments{password},$arguments{username}));
	$sth->bind_columns(\$count);
	$sth->fetch;
	if($count == 1) {
		my $cookie = $query->cookie(
				-name	=>	'username+password',
				-value	=>	$arguments{username} . '+' . crypt($arguments{password},$arguments{username}),
				-expires	=>	'+3M',
			);
		my $uri = 'changepass.cgi';
		print $query->header(-cookie=>$cookie,-location=>$uri);
	} else {
		$sth = $dbh->prepare("SELECT COUNT(id) FROM users WHERE UPPER(username) = UPPER(?) AND password = ?");
		$sth->execute($arguments{username},md5('saltgoeshere' . $arguments{password}));
		$sth->bind_columns(\$count);
		$sth->fetch;
		if($count == 1) {
			$sth = $dbh->prepare("UPDATE users SET last_login = NOW() WHERE UPPER(username) = UPPER(?) AND password = ?");
			$sth->execute($arguments{username},md5('saltgoeshere' . $arguments{password}));
			$sth = $dbh->prepare("SELECT is_admin FROM users WHERE UPPER(username) = UPPER(?) AND password = ?");
			my $is_admin;
			$sth->execute($arguments{username},md5('saltgoeshere' . $arguments{password}));
			$sth->bind_columns(\$is_admin);
			$sth->fetch;
			my $cookie = $query->cookie(
					-name	=>	'username+password',
					-value	=>	$arguments{username} . '+' . md5('saltgoeshere' . $arguments{password}),
					-expires	=>	'+3M',
				);
			my $uri = 'index.cgi';
			if($is_admin == 1) {
				# redirect to admin page
				$uri = 'admin.cgi';
			}
			print $query->header(-cookie=>$cookie,-location=>$uri);
		} else {
		$parameters{error} = 'That username and password combination does not match any currently in our database.';
		}
	}
}

$template->param(%parameters);
print $query->header(),$template->output();