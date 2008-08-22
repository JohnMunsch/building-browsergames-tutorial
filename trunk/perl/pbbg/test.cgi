#!/usr/bin/perl -w
use strict;
use CGI qw(:cgi);
use items;

my $query = new CGI;
my %item = items::getItem(1);
$item{atk} = items::getStat('atk',1);

print $query->header();
print qq ~
Name: $item{name}<br />
Type: $item{type}<br />
ID: $item{id}<br />
Attack: $item{atk}
~;