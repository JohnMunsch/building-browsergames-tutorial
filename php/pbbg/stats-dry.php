<?php

include 'database.php';

function getStatDRY($type,$statName,$trackingID) {
	createIfNotExistsDRY($type,$statName,$trackingID);
	$query = sprintf("SELECT value FROM entity_stats WHERE stat_id = (SELECT id FROM stats WHERE display_name = '%s' OR short_name = '%s') AND entity_id = '%s' AND entity_type = '%s'",
		mysql_real_escape_string($statName),
		mysql_real_escape_string($statName),
		mysql_real_escape_string($trackingID),
		mysql_real_escape_string($type));
	$result = mysql_query($query);
	list($value) = mysql_fetch_row($result);
	return $value;		
}

function setStatDRY($type,$statName,$trackingID,$value) {
	createIfNotExistsDRY($type,$statName,$trackingID);
	$query = sprintf("UPDATE entity_stats SET value = '%s' WHERE stat_id = (SELECT id FROM stats WHERE display_name = '%s' OR short_name = '%s') AND entity_id = '%s' AND entity_type = '%s'",
		mysql_real_escape_string($value),
		mysql_real_escape_string($statName),
		mysql_real_escape_string($statName),
		mysql_real_escape_string($trackingID),
		mysql_real_escape_string($type));
	$result = mysql_query($query);
}

function createIfNotExistsDRY($type,$statName,$trackingID) {
	$query = sprintf("SELECT count(value) FROM entity_stats WHERE stat_id = (SELECT id FROM stats WHERE display_name = '%s' OR short_name = '%s') AND entity_id = '%s' AND entity_type ='%s'",
		mysql_real_escape_string($statName),
		mysql_real_escape_string($statName),
		mysql_real_escape_string($trackingID),
		mysql_real_escape_string($type));
	$result = mysql_query($query);
	list($count) = mysql_fetch_row($result);
	if($count == 0) {
		// the stat doesn't exist; insert it into the database
		$query = sprintf("INSERT INTO entity_stats(stat_id,entity_id,value,entity_type) VALUES ((SELECT id FROM stats WHERE display_name = '%s' OR short_name = '%s'),'%s','%s','%s')",
		mysql_real_escape_string($statName),
		mysql_real_escape_string($statName),
		mysql_real_escape_string($trackingID),
		'0',
		mysql_real_escape_string($type));
		mysql_query($query);
	}	
}

?>