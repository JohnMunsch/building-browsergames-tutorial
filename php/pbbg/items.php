<?php

require_once 'stats-dry.php';
define('TYPE','item');

function getItem($itemID) {
	include 'config.php';
	$conn = mysql_connect($dbhost,$dbuser,$dbpass)
		or die ('Error connecting to mysql:');
	mysql_select_db($dbname);
	$query = sprintf("SELECT name, type FROM items WHERE id = '%s'",
		mysql_real_escape_string($itemID));
	$result = mysql_query($query);
	$item = mysql_fetch_assoc($result);
	$item['id']	= $itemID;
	return $item;
}

function getItemStat($statName,$ItemID) {
	return getStatDRY(TYPE,$statName,$ItemID);
}
function setItemStat($statName,$ItemID,$value) {
	setStatDRY(TYPE,$statName,$ItemID,$value);
}

?>