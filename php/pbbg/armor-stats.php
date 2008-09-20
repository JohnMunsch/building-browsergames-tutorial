<?php

require_once 'stats-dry.php';

function getArmorStat($statName,$armorID) {
	return getStatDRY('Item',$statName,$armorID);
}

?>