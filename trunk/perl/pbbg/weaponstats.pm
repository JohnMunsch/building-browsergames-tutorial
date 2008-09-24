package weaponstats;
use DBI;
 
use statsDRY;

sub getWeaponStat {
	my ($statName,$userID) = @_;
	return statsDRY::getStatDRY('Item',$statName,$userID);
}
 
1;