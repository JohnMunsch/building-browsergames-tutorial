package stats;
use DBI;
 
use statsDRY;

sub getStat {
	my ($statName,$userID) = @_;
	return statsDRY::getStatDRY('user',$statName,$userID);
}

sub setStat {
	my ($statName,$userID,$statValue) = @_;
	statsDRY::setStatDRY('user',$statName,$userID,$statValue);
}
 
1;