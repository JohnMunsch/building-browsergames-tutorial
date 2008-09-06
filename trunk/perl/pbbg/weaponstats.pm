package weaponstats;
use DBI;
 
use statsDRY;

sub getWeaponStat {
	my ($statName,$userID) = @_;
	return statsDRY::getStatDRY('Weapon',$statName,$userID);
}
 
1;