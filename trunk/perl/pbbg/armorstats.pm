package armorstats;
use DBI;
 
use statsDRY;

sub getArmorStat {
	my ($statName,$userID) = @_;
	return statsDRY::getStatDRY('Item',$statName,$userID);
}
 
1;