package items;
use DBI;
use statsDRY;
use constant TYPE => 'item';



sub getItem {
	my ($itemID) = @_;
	use config;
	my $dbh = DBI->connect("DBI:mysql:$config{dbName}:$config{dbHost}",$config{dbUser},$config{dbPass},{RaiseError => 1});
	my $sth = $dbh->prepare("SELECT name, type FROM items WHERE id = ?");
	$sth->execute($itemID);
	my %item;
	$sth->bind_columns(\@item{qw(name type)});
	$sth->fetch;
	$item{id} = $itemID;
	return %item;
}
 
sub getStat {
	my ($statName,$userID) = @_;
	return statsDRY::getStatDRY(TYPE,$statName,$userID);
}

sub setStat {
	my ($statName,$userID,$statValue) = @_;
	statsDRY::setStatDRY(TYPE,$statName,$userID,$statValue);
}
 
1;