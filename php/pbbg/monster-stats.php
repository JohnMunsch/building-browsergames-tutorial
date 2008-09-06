<?php

require_once 'stats-dry.php';

function getMonsterStat($statName,$monsterID) {
	return getStatDRY('monster',$statName,$monsterID);
}

?>