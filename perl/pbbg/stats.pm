package stats;
use DBI;
 
use statsDRY;

use constant TYPE => 'user';

sub getStat {
	my ($statName,$userID) = @_;
	return statsDRY::getStatDRY(TYPE,$statName,$userID);
}

sub setStat {
	my ($statName,$userID,$statValue) = @_;
	statsDRY::setStatDRY(TYPE,$statName,$userID,$statValue);
}
 
1;