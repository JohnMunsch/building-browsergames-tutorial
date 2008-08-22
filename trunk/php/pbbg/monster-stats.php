<?php

require_once 'stats-dry.php';
define('TYPE','monster');

function getMonsterStat($statName,$monsterID) {
	return getStatDRY(TYPE,$statName,$monsterID);
}

?>