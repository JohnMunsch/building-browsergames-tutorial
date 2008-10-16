package items;
use DBI;
use statsDRY;
 
sub getStat {
	my ($statName,$itemID) = @_;
	return statsDRY::getStatDRY('Item',$statName,$itemID);
}

sub setStat {
	my ($statName,$itemID,$statValue) = @_;
	statsDRY::setStatDRY('Item',$statName,$itemID,$statValue);
}
 
1;