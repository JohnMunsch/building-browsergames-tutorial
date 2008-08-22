package database;
 
use Exporter;
use DBI;
use config;
our @ISA = qw(Exporter);
 
our $dbh;
our @EXPORT = qw($dbh);

$dbh = DBI->connect("DBI:mysql:$config{dbName}:$config{dbHost}",$config{dbUser},$config{dbPass},{RaiseError => 1});
 
1;