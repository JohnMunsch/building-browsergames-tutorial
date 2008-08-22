#!/usr/bin/perl -w

use strict;
use CGI qw(:cgi);
use DBI;
use config;
use Digest::MD5 qw(md5);
use HTML::Template;

require login;

my $query = new CGI;
my %arguments = $query->Vars;
my $cookie = $query->cookie('username+password');
my ($username) = split(/\+/,$cookie);
my %params;

if(%arguments) {
	if($arguments{password} ne $arguments{confirm}) {
		$params{error} = 'Passwords do not match!';
	} else {
		my $dbh = DBI->connect("DBI:mysql:$config{dbName}:$config{dbHost}",$config{dbUser},$config{dbPass},{RaiseError => 1});
		my $sth = $dbh->prepare("UPDATE users SET password = ? WHERE UPPER(username) = UPPER(?)");
		$sth->execute(md5('saltgoeshere' . $arguments{password}),$username);
		$params{message} = "Password updated successfully.";
	}
}

my $template = HTML::Template->new(
		filename	=>	'changepass.tmpl',
	);
$template->param(%params);
print $query->header(), $template->output;