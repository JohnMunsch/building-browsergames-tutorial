package config;
 
use Exporter;
our @ISA = qw(Exporter);
 
our %config;
our @EXPORT = qw(%config);
 
%config = (
	dbHost	=>	'localhost',
	dbName	=>	'sandbox',
	dbUser	=>	'root',
	dbPass	=>	't0luen3',
);
 
1;