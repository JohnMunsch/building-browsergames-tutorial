package login;

use CGI qw(:cgi);
use DBI;
use config;

my $query = new CGI;
my $cookie = $query->cookie('username+password');
 
my ($username) = split(/\+/,$cookie);
my $dbh = DBI->connect("DBI:mysql:$config{dbName}:$config{dbHost}",$config{dbUser},$config{dbPass},{RaiseError => 1});
my $sth = $dbh->prepare("SELECT id FROM users WHERE UPPER(username) = UPPER(?)");
$sth->execute($username);
my $userID;
$sth->bind_columns(\$userID);
$sth->fetch;
if(!$userID) {
	print $query->redirect('login.cgi');	
}

1;