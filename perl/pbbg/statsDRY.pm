package statsDRY;

use database;

sub getStatDRY {
	my ($type,$statName,$trackingID) = @_;
	my $dbh = $dbh;
	createIfNotExistsDRY($type,$statName,$userID);
	my $sth = $dbh->prepare("SELECT value FROM entity_stats WHERE stat_id = (SELECT id FROM stats WHERE display_name = ? OR short_name = ?) AND entity_id = ? AND entity_type = ?");
	$sth->execute($statName,$statName,$trackingID,$type);
	my $value;
	$sth->bind_columns(\$value);
	$sth->fetch;
	return $value;
}

sub setStatDRY {
	my ($type,$statName,$trackingID,$statValue) = @_;
	my $dbh = $dbh;
	createIfNotExistsDRY($type,$statName,$trackingID);
	my $sth = $dbh->prepare("UPDATE entity_stats SET value = ? WHERE stat_id = (SELECT id FROM stats WHERE display_name = ? OR short_name = ?) AND entity_id = ? AND entity_type = ?");
	$sth->execute($statValue,$statName,$statName,$trackingID,$type);
}

sub createIfNotExistsDRY {
	my ($type,$statName, $trackingID) = @_;	
	my $dbh = $dbh;
	my $sth = $dbh->prepare("SELECT count(value) FROM entity_stats WHERE stat_id = (SELECT id FROM stats WHERE display_name = ? OR short_name = ?) AND entity_id = ? AND entity_type = ?");
	$sth->execute($statName,$statName,$trackingID,$type);
	my $count;
	$sth->bind_columns(\$count);
	$sth->fetch;
	if($count == 0) {
		# no entry for that stat/user combination - insert one with a value of 0
		$sth = $dbh->prepare("INSERT INTO entity_stats(stat_id,entity_id,value,entity_type) VALUES ((SELECT id FROM stats WHERE display_name = ? OR short_name = ?),?,?,?)");
		$sth->execute($statName,$statName,$trackingID,0,$type);
	}	
}


1;