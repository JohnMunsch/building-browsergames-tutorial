package monsterstats;
use DBI;
 
use statsDRY;

sub getMonsterStat {
	my ($statName,$userID) = @_;
	return statsDRY::getStatDRY('monster',$statName,$userID);
}

sub setStat {
	my ($statName,$userID,$statValue) = @_;
	statsDRY::setStatDRY('monster',$statName,$userID,$statValue);
}
 
1;